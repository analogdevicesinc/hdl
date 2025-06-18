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

module axi_fsrc_tx_regmap #(
  parameter ID = 0,
  parameter [31:0] CORE_VERSION = 0,
  parameter [31:0] CORE_MAGIC = 0,
  parameter ACCUM_WIDTH = 64,
  parameter NUM_SAMPLES = 16
) (
  input         clk,
  input         reset,
  output        tx_fsrc_en,
  output        transmit_start,
  output        transmit_stop,
  output        tx_fsrc_stop,
  output        tx_fsrc_change_rate,
  output        fsrc_accum_set,
  output [15:0] conv_mask,
  output [ACCUM_WIDTH-1:0] fsrc_accum_add_val,
  output reg [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] fsrc_accum_set_val,

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

  wire  [3:0] fsrc_accum_set_val_addr;
  wire [63:0] fsrc_accum_set_val_s;
  wire fsrc_accum_set_val_apply;
  wire [31:0] jesd204b_tx_config;
  wire [31:0] ctrl_transmit;
  wire [31:0] link_ctrl;

  // internal registers
  reg [31:0] up_scratch_s;
  reg [31:0] up_jesd204b_tx_config_s;
  reg [31:0] up_ctrl_transmit_s;
  reg [31:0] up_link_ctrl_s;
  reg [31:0] up_fsrc_accum_add_val_s;
  reg [31:0] up_fsrc_accum_add_val_2_s;
  reg  [3:0] up_fsrc_accum_set_val_addr_s;
  reg        up_fsrc_accum_set_val_apply_s;
  reg [31:0] up_fsrc_accum_set_val_s;
  reg [31:0] up_fsrc_accum_set_val_2_s;

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch_s <= 'd0;
      up_jesd204b_tx_config_s <= 'd0;
      up_ctrl_transmit_s <= 'd0;
      up_link_ctrl_s <= 'd0;
      up_fsrc_accum_add_val_s <= 'd0;
      up_fsrc_accum_add_val_2_s <= 'd0;
      up_fsrc_accum_set_val_addr_s <= 'd0;
      up_fsrc_accum_set_val_apply_s <= 1'b0;
      up_fsrc_accum_set_val_s <= 'd0;
      up_fsrc_accum_set_val_2_s <= 'd0;
    end else begin
      up_wack <= up_wreq;
      if ((up_wreq == 1'b1) && (up_waddr == 14'h2)) begin
        up_scratch_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h4)) begin
        up_jesd204b_tx_config_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h5)) begin
        up_ctrl_transmit_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h6)) begin
        up_link_ctrl_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h7)) begin
        up_fsrc_accum_add_val_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h8)) begin
        up_fsrc_accum_add_val_2_s <= up_wdata;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'h9)) begin
        up_fsrc_accum_set_val_addr_s <= up_wdata[3:0];
        up_fsrc_accum_set_val_apply_s <= 1'b1;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'ha)) begin
        up_fsrc_accum_set_val_s <= up_wdata;
        up_fsrc_accum_set_val_apply_s <= 1'b0;
      end
      if ((up_wreq == 1'b1) && (up_waddr == 14'hb)) begin
        up_fsrc_accum_set_val_2_s <= up_wdata;
        up_fsrc_accum_set_val_apply_s <= 1'b0;
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
          14'h4:   up_rdata <= up_jesd204b_tx_config_s;
          14'h5:   up_rdata <= up_ctrl_transmit_s;
          14'h6:   up_rdata <= up_link_ctrl_s;
          14'h7:   up_rdata <= up_fsrc_accum_add_val_s;
          14'h8:   up_rdata <= up_fsrc_accum_add_val_2_s;
          14'h9:   up_rdata <= {28'b0, up_fsrc_accum_set_val_addr_s};
          14'ha:   up_rdata <= up_fsrc_accum_set_val_s;
          14'hb:   up_rdata <= up_fsrc_accum_set_val_2_s;
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
  ) jesd204b_tx_config_sync (
    .in_bits(up_jesd204b_tx_config_s),
    .out_clk(clk),
    .out_bits(jesd204b_tx_config));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) ctrl_transmit_sync (
    .in_bits(up_ctrl_transmit_s),
    .out_clk(clk),
    .out_bits(ctrl_transmit));

  sync_bits #(
    .NUM_OF_BITS (32),
    .ASYNC_CLK (1)
  ) link_ctrl_sync (
    .in_bits(up_link_ctrl_s),
    .out_clk(clk),
    .out_bits(link_ctrl));

  sync_bits #(
    .NUM_OF_BITS (ACCUM_WIDTH),
    .ASYNC_CLK (1)
  ) fsrc_accum_add_val_sync (
    .in_bits({up_fsrc_accum_add_val_2_s, up_fsrc_accum_add_val_s}),
    .out_clk(clk),
    .out_bits(fsrc_accum_add_val));

  sync_bits #(
      .NUM_OF_BITS (ACCUM_WIDTH + 5),
    .ASYNC_CLK (1)
  ) fsrc_accum_set_val_sync (
    .in_bits({up_fsrc_accum_set_val_2_s, up_fsrc_accum_set_val_s, up_fsrc_accum_set_val_addr_s, up_fsrc_accum_set_val_apply_s}),
    .out_clk(clk),
    .out_bits({fsrc_accum_set_val_s, fsrc_accum_set_val_addr, fsrc_accum_set_val_apply}));

  genvar j;
  for (j=0; j < NUM_SAMPLES; j=j+1) begin : set_val_gen
    always @(posedge clk) begin
      // Write value first then address to apply
      if (j == fsrc_accum_set_val_addr && fsrc_accum_set_val_apply) begin
        fsrc_accum_set_val[j] <= fsrc_accum_set_val_s;
      end
    end
  end

  assign tx_fsrc_en          = jesd204b_tx_config[0];
  assign transmit_start      = ctrl_transmit[1];
  assign transmit_stop       = ctrl_transmit[3];
  assign tx_fsrc_stop        = ctrl_transmit[4];
  assign tx_fsrc_change_rate = ctrl_transmit[5];
  assign fsrc_accum_set = ctrl_transmit[6];
  assign conv_mask      = link_ctrl[31:16];

endmodule