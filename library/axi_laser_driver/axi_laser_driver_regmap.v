// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/100ps

module axi_laser_driver_regmap #(

  parameter       ID = 0,
  parameter       LASER_DRIVER_ID = 1
) (

  // control and status signals

  input                   clk,
  output                  driver_en_n,
  input                   driver_otw_n,

  input                   pulse,
  output reg              irq,

  input       [31:0]      up_ext_clk_count,

  // TIA sequencer

  output                  sequence_en,
  output                  auto_sequence,
  output      [31:0]      sequence_offset,

  output      [ 1:0]      auto_seq0,
  output      [ 1:0]      auto_seq1,
  output      [ 1:0]      auto_seq2,
  output      [ 1:0]      auto_seq3,

  output      [ 7:0]      manual_select,

  // processor interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output reg              up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output reg  [31:0]      up_rdata,
  output reg              up_rack
);

  // internal registers

  reg             up_driver_en_n = 1'b0;
  reg   [2:0]     up_irq_mask = 3'b111;
  reg   [2:0]     up_irq_source = 3'b000;
  reg             up_driver_otw_n_int = 1'b1;

  reg             up_sequence_en = 1'b0;
  reg             up_auto_sequence = 1'b1;
  reg   [31:0]    up_sequence_offset = 32'b0;
  reg   [ 1:0]    up_auto_seq0 = 2'b00;
  reg   [ 1:0]    up_auto_seq1 = 2'b01;
  reg   [ 1:0]    up_auto_seq2 = 2'b10;
  reg   [ 1:0]    up_auto_seq3 = 2'b11;
  reg   [ 7:0]    up_manual_select = 8'h00;

  // internal signals

  wire            up_wreq_int_s;
  wire            up_rreq_int_s;
  wire            up_driver_otw_n_s;
  wire  [2:0]     up_irq_pending_s;
  wire  [2:0]     up_irq_trigger_s;
  wire  [2:0]     up_irq_source_clear_s;
  wire            up_pulse_s;

  wire            up_driver_otw_n_enter_s;
  wire            up_driver_otw_n_exit_s;

  // map the laser driver registers into the address space

  assign up_wreq_int_s = (up_waddr[13:5] == LASER_DRIVER_ID) ? up_wreq : 1'b0;
  assign up_rreq_int_s = (up_raddr[13:5] == LASER_DRIVER_ID) ? up_rreq : 1'b0;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 1'b0;
      up_driver_en_n <= 1'b1;        // by default laser is disabled
      up_irq_mask <= 3'b111;
      up_sequence_en <= 1'b0;
      up_auto_sequence <= 1'b1;
      up_sequence_offset <= 32'h19;  // 25*4ns is the default offset for TIA selection
      up_auto_seq0 <= 2'b00;
      up_auto_seq1 <= 2'b01;
      up_auto_seq2 <= 2'b10;
      up_auto_seq3 <= 2'b11;
      up_manual_select <= 8'h00;
    end else begin
      up_wack <= up_wreq_int_s;
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'h0)) begin
        up_driver_en_n <= up_wdata[0];
      end
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_irq_mask <= up_wdata[2:0];
      end
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'hB)) begin
        up_sequence_en <= up_wdata[0];
        up_auto_sequence <= up_wdata[1];
      end
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'hC)) begin
        up_sequence_offset <= up_wdata;
      end
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'hD)) begin
        up_auto_seq0 <= up_wdata[1:0];
        up_auto_seq1 <= up_wdata[5:4];
        up_auto_seq2 <= up_wdata[9:8];
        up_auto_seq3 <= up_wdata[13:12];
      end
      if ((up_wreq_int_s == 1'b1) && (up_waddr[3:0] == 4'hE)) begin
        up_manual_select <= {up_wdata[13:12],
                             up_wdata[9:8],
                             up_wdata[5:4],
                             up_wdata[1:0]};
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rreq_int_s;
      if (up_rreq_int_s == 1'b1) begin
        case (up_raddr[4:0])
          5'h00: up_rdata <= {31'h0, up_driver_en_n};
          5'h01: up_rdata <= {31'h0, up_driver_otw_n_s};
          5'h02: up_rdata <= up_ext_clk_count;
          5'h08: up_rdata <= {29'h0, up_irq_mask};
          5'h09: up_rdata <= {29'h0, up_irq_source};
          5'h0A: up_rdata <= {29'h0, up_irq_pending_s};
          5'h0B: up_rdata <= {30'h0, up_auto_sequence, up_sequence_en};
          5'h0C: up_rdata <= up_sequence_offset;
          5'h0D: up_rdata <= {18'h0, up_auto_seq3,
                               2'h0, up_auto_seq2,
                               2'h0, up_auto_seq1,
                               2'h0, up_auto_seq0};
          5'h0E: up_rdata <= {18'h0, up_manual_select[7:6],
                               2'h0, up_manual_select[5:4],
                               2'h0, up_manual_select[3:2],
                               2'h0, up_manual_select[1:0]};

          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  assign driver_en_n = up_driver_en_n;

  always @(posedge up_clk) begin
    up_driver_otw_n_int <= up_driver_otw_n_s;
  end
  // negative edge of otw_n - system enters into an over temperature state
  assign up_driver_otw_n_enter_s = ~up_driver_otw_n_s & up_driver_otw_n_int;
  // positive edge of otw_n - system exits from an over temperature state
  assign up_driver_otw_n_exit_s = up_driver_otw_n_s & ~up_driver_otw_n_int;

  // Interrupt handling - it can be generated by a generated pulse or an over
  // temperature warning signal

  assign up_irq_pending_s = ~up_irq_mask & up_irq_source;
  assign up_irq_trigger_s = {up_driver_otw_n_exit_s, up_driver_otw_n_enter_s, up_pulse_s};
  assign up_irq_source_clear_s = (up_wreq_int_s == 1'b1 && up_waddr[3:0] == 4'hA) ? up_wdata[2:0] : 3'b000;

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      irq <= 1'b0;
    end else begin
      irq <= |up_irq_pending_s;
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_irq_source <= 3'b000;
    end else begin
      up_irq_source <= up_irq_trigger_s | (up_irq_source & ~up_irq_source_clear_s);
    end
  end

  // CDC logic

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_driver_otw_sync (
    .in_bits (driver_otw_n),
    .out_clk (up_clk),
    .out_resetn (1'b1),
    .out_bits (up_driver_otw_n_s));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_pulse_sync (
    .in_bits (pulse),
    .out_clk (up_clk),
    .out_resetn (1'b1),
    .out_bits (up_pulse_s));

  sync_bits #(
    .NUM_OF_BITS (2),
    .ASYNC_CLK (1)
  ) i_sequence_control_sync (
    .in_bits ({up_auto_sequence, up_sequence_en}),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits ({auto_sequence, sequence_en}));

  sync_bits #(
    .NUM_OF_BITS (16),
    .ASYNC_CLK (1)
  ) i_sequencer_sync (
    .in_bits ({up_auto_seq3,
               up_auto_seq2,
               up_auto_seq1,
               up_auto_seq0,
               up_manual_select
               }),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits ({auto_seq3,
                auto_seq2,
                auto_seq1,
                auto_seq0,
                manual_select
                }));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) i_sequence_offset_sync (
    .in_bits (up_sequence_offset),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits (sequence_offset));

endmodule
