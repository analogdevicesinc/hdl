// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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

module jesd204_f_tile_adapter_tx #(
  parameter O_WIDTH = 80,
  parameter DATA_PATH_WIDTH = 8
) (
  // PHY interface
  input                    o_clk,
  output reg [O_WIDTH-1:0] o_phy_data,

  // Link layer Interface
  input i_clk,
  input i_reset,
  input [DATA_PATH_WIDTH*8-1:0] i_phy_data,
  input [1:0]                   i_phy_header,
  // Dummy interface to keep 204B compatibility
  input [DATA_PATH_WIDTH-1:0]   i_phy_charisk,

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

  wire        o_reset;
  wire        o_fifo_empty;
  wire        o_gb_read;
  wire [63:0] o_gb_data;
  wire [63:0] o_data;
  wire [ 1:0] o_header;
  wire        o_valid;

  wire        i_fifo_full;
  reg  [63:0] i_phy_data_r;
  reg  [ 1:0] i_phy_header_r;
  wire [63:0] i_phy_data_rev;
  wire [ 1:0] i_phy_header_rev;
  reg  [ 1:0] i_header;
  reg  [63:0] i_data;

  // In LR / 66 domain
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) o_resetn_cdc (
    .in_bits(i_reset),
    .out_clk(o_clk),
    .out_resetn(1'b1),
    .out_bits(o_reset));

  // Register the input data to ease timing
  always @(posedge i_clk) begin
    i_phy_data_r <= i_phy_data;
    i_phy_header_r <= i_phy_header;
  end

  /*
   * F-tile transceivers are LSB first so in order
   * to properly send the data it has to be bit-swapped.
   *
   * From the link layer:
   * H1  H0 D63 D62  ...   D3   D2  D1  D0
   * 65  64  63  62  ...    3    2   1   0
   *
   * To the transceiver:
   * D0  D1  D2  D3  ...  D62  D63  H0  H1
   * 65  64  63  62  ...    3    2   1   0
   *
   * D - data bits
   * H - header bits
   */
  generate
    genvar i;
    for (i=0; i < 64; i=i+1) begin
      assign i_phy_data_rev[63-i] = i_phy_data_r[i];
    end
    assign i_phy_header_rev = {i_phy_header_r[0], i_phy_header_r[1]};
  endgenerate

  always @(posedge i_clk) begin
    i_data <= i_phy_data_rev;
    i_header <= i_phy_header_rev;
  end

  // CDC from LR / 66 to LR / 64
  assign wr_clk = i_clk;
  assign rd_clk = o_clk;
  assign wr_data = {i_data, i_header};
  assign wr_en = ~i_reset & ~i_fifo_full;
  assign rd_en = o_gb_read & ~o_fifo_empty;
  assign aclr = i_reset;

  assign i_fifo_full  = wr_full;
  assign o_fifo_empty = rd_empty;
  assign {o_data, o_header} = rd_data;

  assign o_valid = ~o_fifo_empty & o_gb_read;

  // In LR / 64 domain
  gearbox_66b64b i_gearbox (
    .clk (o_clk),
    .reset (o_reset),
    .i_data ({o_data, o_header}),
    .i_valid (o_valid),
    .o_data (o_gb_data),
    .o_rd_en (o_gb_read));

  always @(posedge o_clk) begin
    o_phy_data <= 'd0;
    o_phy_data[79] <= 1'b1;
    o_phy_data[38] <= 1'b1;
    o_phy_data[71:40] <= o_gb_data[63:32];
    o_phy_data[31: 0] <= o_gb_data[31: 0];
  end

endmodule
