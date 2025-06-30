// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_fsrc_sequencer_regmap #(
  parameter ID = 0,
  parameter [31:0] CORE_VERSION = 0,
  parameter [31:0] CORE_MAGIC = 0,
  parameter CTRL_WIDTH = 40,
  parameter COUNTER_WIDTH = 4,
  parameter NUM_TRIG = 4
) (
  input         clk,
  input         reset,

  output [31:0] reg_o_seq_gpio_change_cnt,

  output        reg_o_seq_start,
  output        reg_o_seq_en,
  output        reg_o_tx_sequencer_non_fsrc_delay_en,
  output [15:0] reg_o_seq_tx_accum_reset_cnt,

  output        reg_o_seq_ext_trig_en,

  output [CTRL_WIDTH-1:0]    reg_o_dut_seq_gpio_w,

  output [NUM_TRIG-1:0] reg_o_trig_out,

  output [NUM_TRIG-1:0] [COUNTER_WIDTH-1:0] reg_o_first_trig_cnt,


  // axi interface
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

  wire [31:0] seq_ctrl_1;
  wire [31:0] seq_ctrl_2;
  wire [31:0] seq_ctrl_3;
  wire [31:0] seq_ctrl_4;
  wire [31:0] seq_gpio_w_1;
  wire [31:0] seq_gpio_w_2;
  wire [31:0] trig_ctrl;

  // internal registers
  reg [31:0] up_scratch_s;
  reg        up_start_s;
  reg [31:0] up_seq_ctrl_1_s;
  reg [31:0] up_seq_ctrl_2_s;
  reg [31:0] up_seq_ctrl_3_s;
  reg [31:0] up_seq_ctrl_4_s;
  reg [31:0] up_seq_gpio_w_1_s;
  reg [31:0] up_seq_gpio_w_2_s;
  reg [31:0] up_trig_ctrl_s;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch_s <= 'd0;
      up_start_s <= 'd0;
      up_seq_ctrl_1_s <= 'd0;
      up_seq_ctrl_2_s <= 'd0;
      up_seq_ctrl_3_s <= 'd0;
      up_seq_ctrl_4_s <= 'd0;
      up_seq_gpio_w_1_s <= 'd0;
      up_seq_gpio_w_2_s <= 'd0;
      up_trig_ctrl_s  <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_scratch_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        up_seq_ctrl_1_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        up_seq_ctrl_2_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
        up_seq_ctrl_3_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h7)) begin
        up_seq_ctrl_4_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h8)) begin
        up_seq_gpio_w_1_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h9)) begin
        up_seq_gpio_w_2_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h10)) begin
        up_trig_ctrl_s <= up_wdata;
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case (up_raddr)
          14'h0:   up_rdata <= CORE_VERSION;
          14'h1:   up_rdata <= ID;
          14'h2:   up_rdata <= up_scratch_s;
          14'h3:   up_rdata <= CORE_MAGIC;
          14'h4:   up_rdata <= up_seq_ctrl_1_s;
          14'h5:   up_rdata <= up_seq_ctrl_2_s;
          14'h6:   up_rdata <= up_seq_ctrl_3_s;
          14'h7:   up_rdata <= up_seq_ctrl_4_s;
          14'h8:   up_rdata <= up_seq_gpio_w_1_s;
          14'h9:   up_rdata <= up_seq_gpio_w_2_s;
          14'h10:  up_rdata <= up_trig_ctrl_s;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_ctrl_1_sync (
    .in_bits(up_seq_ctrl_1_s),
    .out_clk(clk),
    //.out_resetn(~reset),
    .out_bits(seq_ctrl_1));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_ctrl_2_sync (
    .in_bits(up_seq_ctrl_2_s),
    .out_clk(clk),
    .out_bits(seq_ctrl_2));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_ctrl_3_sync (
    .in_bits(up_seq_ctrl_3_s),
    .out_clk(clk),
    .out_bits(seq_ctrl_3));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_ctrl_4_sync (
    .in_bits(up_seq_ctrl_4_s),
    .out_clk(clk),
    .out_bits(seq_ctrl_4));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_gpio_w_1_sync (
    .in_bits(up_seq_gpio_w_1_s),
    .out_clk(clk),
    .out_bits(seq_gpio_w_1));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) seq_gpio_w_2_sync (
    .in_bits(up_seq_gpio_w_2_s),
    .out_clk(clk),
    .out_bits(seq_gpio_w_2));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) trig_ctrl_sync (
    .in_bits(up_trig_ctrl_s),
    .out_clk(clk),
    .out_bits(trig_ctrl));

  assign reg_o_seq_gpio_change_cnt = seq_ctrl_1;

  genvar i;
  generate
    for (i = 0; i < NUM_TRIG; i++) begin
      assign reg_o_first_trig_cnt[i]  = seq_ctrl_2[(i*4) +: COUNTER_WIDTH];
    end
  endgenerate

  assign reg_o_seq_start                      = seq_ctrl_3[0];
  assign reg_o_seq_en                         = seq_ctrl_3[1];
  assign reg_o_tx_sequencer_non_fsrc_delay_en = seq_ctrl_3[4];
  assign reg_o_seq_tx_accum_reset_cnt         = seq_ctrl_3[16+:COUNTER_WIDTH];

  assign reg_o_seq_ext_trig_en  = seq_ctrl_4[0];

  assign reg_o_dut_seq_gpio_w = {seq_gpio_w_2, seq_gpio_w_1};

  assign reg_o_trig_out = trig_ctrl[0+:NUM_TRIG];

endmodule
