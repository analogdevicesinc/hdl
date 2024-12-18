// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
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

module jesd204_h_tile_adapter_rx (
  // PHY interface
  input        i_clk,
  input [63:0] i_phy_data,
  input [ 1:0] i_phy_control,
  input        i_phy_data_valid,

  output       i_phy_bitslip,

  // Link layer interface
  input            o_clk,
  input            o_reset,

  output    [63:0] o_phy_data,
  output    [ 1:0] o_phy_header,
  output           o_phy_block_sync,
  // Dummy interface to keep 204B compatibility
  output reg [7:0] o_phy_charisk = 'h0,
  output reg [7:0] o_phy_notintable = 'h0,
  output reg [7:0] o_phy_disperr = 'h0,
  input            o_phy_patternalign_en,

  // Fifo interface
  input  [65:0] rd_data,
  input         rd_empty,
  input         wr_full,

  output [65:0] wr_data,
  output        wr_clk,
  output        wr_en,
  output        rd_clk,
  output        rd_en,
  output        aclr
);

  wire        i_reset;
  wire        i_fifo_full;
  reg  [63:0] i_data;
  reg  [ 1:0] i_header;
  reg         i_data_valid;

  wire        o_fifo_empty;
  reg  [ 2:0] o_start_cnt = 'h0;
  reg         o_read_active = 1'b0;
  reg  [ 2:0] o_align_reset = 3'b111;
  wire [63:0] o_read_data;
  wire [ 1:0] o_read_header;
  wire [63:0] o_data_rev;
  wire [ 1:0] o_header_rev;
  wire        o_bitslip;
  reg  [63:0] o_data;
  reg  [ 1:0] o_header;
  reg  [ 7:0] o_bitslip_cnt = 8'h80;
  reg         o_bitslip_d = 1'b0;
  reg         o_bitslip_done = 1'b1;

  // In LR / 64 domain
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_resetn_cdc (
    .in_bits(o_reset),
    .out_clk(i_clk),
    .out_resetn(1'b1),
    .out_bits(i_reset));

  // Register data to ease timing
  always @(posedge i_clk) begin
    i_data <= i_phy_data;
    i_header <= i_phy_control;
    i_data_valid <= i_phy_data_valid;
  end

  // CDC from LR / 64 to LR / 66
  assign wr_clk = i_clk;
  assign rd_clk = o_clk;
  assign wr_data = {i_header, i_data};
  assign wr_en = i_data_valid & ~i_fifo_full;
  assign rd_en = o_read_active & ~o_fifo_empty;
  assign aclr = i_reset;

  assign i_fifo_full = wr_full;
  assign o_fifo_empty = rd_empty;
  assign {o_read_header, o_read_data} = rd_data;

  // In LR / 66 domain

  // The write and read rates are equal, so the FIFO keeps the fill level it has
  // when reading starts. Let it fill for a few cycles first, so the gaps in the
  // PHY data valid cannot drain it.
  always @(posedge o_clk) begin
    if (o_reset) begin
      o_start_cnt <= 'h0;
      o_read_active <= 1'b0;
    end else if (~o_read_active & ~o_fifo_empty) begin
      o_start_cnt <= o_start_cnt + 1'b1;
      o_read_active <= &o_start_cnt;
    end
  end

  // Hunt for the sync header only once data read from the FIFO reaches it
  always @(posedge o_clk) begin
    o_align_reset <= {o_align_reset[1:0], ~o_read_active};
  end

  generate
  genvar i;
  for (i=0; i < 64; i = i + 1) begin
    assign o_data_rev[63-i] = o_read_data[i];
  end
  endgenerate
  assign o_header_rev = {o_read_header[0], o_read_header[1]};

  always @(posedge o_clk) begin
    o_data <= o_data_rev;
    o_header <= o_header_rev;
  end

  sync_header_align i_header_align (
    .clk (o_clk),
    .reset (o_align_reset[2]),
    .i_data ({o_header, o_data}),
    .i_slip (o_bitslip),
    .i_slip_done (o_bitslip_done),
    .o_data (o_phy_data),
    .o_header (o_phy_header),
    .o_block_sync (o_phy_block_sync));

  // A slip only reaches this side after the CDC into the PHY clock, the PHY
  // bitslip and RX FIFOs, and this CDC FIFO, so a new slip is accepted only
  // 128 cycles after the previous one. The PHY slips on the rising edge of the
  // 4 cycle pulse.
  always @(posedge o_clk) begin
    if (o_reset) begin
      o_bitslip_cnt <= 8'h80;
    end else if (~o_bitslip_cnt[7]) begin
      o_bitslip_cnt <= o_bitslip_cnt + 1'b1;
    end else if (o_bitslip) begin
      o_bitslip_cnt <= 8'h0;
    end
  end

  always @(posedge o_clk) begin
    o_bitslip_done <= 1'b1;
    o_bitslip_d <= 1'b0;
    if (o_bitslip_cnt < 4) begin
      o_bitslip_d <= 1'b1;
      o_bitslip_done <= 1'b0;
    end
  end

  // Sync bitslip to PHY domain
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_bitslip_cdc (
    .in_bits(o_bitslip_d),
    .out_clk(i_clk),
    .out_resetn(1'b1),
    .out_bits(i_phy_bitslip));

endmodule
