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

module jesd204_f_tile_adapter_rx #(
  parameter I_WIDTH = 80,
  parameter DATA_PATH_WIDTH = 8
) (
  // PHY interface
  input               i_clk,
  input [I_WIDTH-1:0] i_phy_data,

  // Link layer intarface
  input                                o_clk,
  input                                o_reset,

  output     [DATA_PATH_WIDTH*8-1:0]   o_phy_data,
  output     [1:0]                     o_phy_header,
  output                               o_phy_block_sync,
  // Dummy interface to keep 204B compatibility
  output reg [DATA_PATH_WIDTH-1:0]     o_phy_charisk = 'h0,
  output reg [DATA_PATH_WIDTH-1:0]     o_phy_notintable = 'h0,
  output reg [DATA_PATH_WIDTH-1:0]     o_phy_disperr = 'h0,
  input                                o_phy_patternalign_en,

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
  reg  [63:0] i_data;
  wire        i_fifo_full;
  // reg         i_valid;
  wire [65:0] i_gb_data;
  wire        i_gb_valid;

  wire        o_fifo_empty;
  wire [63:0] o_read_data;
  wire [ 1:0] o_read_header;
  wire        o_bitslip;
  wire [ 1:0] o_header_aligned;
  wire [63:0] o_data_aligned;
  wire [ 1:0] o_header_rev;
  wire [63:0] o_data_rev;
  reg  [ 1:0] o_header;
  reg  [63:0] o_data;

  // In LR / 64 domain
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_resetn_cdc (
    .in_bits(o_reset),
    .out_clk(i_clk),
    .out_resetn(1'b1),
    .out_bits(i_reset));

  // Register the input data to ease timing
  always @(posedge i_clk) begin
    i_data <= {i_phy_data[71:40], i_phy_data[31:0]};
  end

  gearbox_64b66b i_gearbox (
    .clk (i_clk),
    .reset (i_reset),
    .i_data (i_data),
    .o_data (i_gb_data),
    .o_valid (i_gb_valid));

  // CDC from LR / 64 to LR / 66
  assign wr_clk = i_clk;
  assign rd_clk = o_clk;
  assign wr_data = i_gb_data;
  assign wr_en = i_gb_valid & ~i_fifo_full;
  assign rd_en = ~o_reset & ~o_fifo_empty;
  assign aclr = i_reset;

  assign i_fifo_full = wr_full;
  assign o_fifo_empty = rd_empty;
  assign {o_read_data, o_read_header} = rd_data;

  // In LR / 66 domain
  bitslip i_bitslip (
    .clk (o_clk),
    .reset (o_reset),
    .bitslip (o_bitslip),
    .data_in ({o_read_data, o_read_header}),
    .bitslip_done (o_bitslip_done),
    .data_out ({o_data_aligned, o_header_aligned}));

  /*
   * F-tile transceivers are LSB first so the received
   * data has to be bit-swapped:
   *
   * Asssuming that we are on the first valid gearbox cycle:
   * From the transceiver:
   * D0  D1  D2  D3  ... D62 D63  H0  H1
   * 65  64  63  62  ...   3   2   1  0
   *
   * Correct format:
   * H1  H0 D63 D62  ...  D3  D2  D1  D0
   * 65  64  63  62  ...   3   2   1   0
   *
   * D - data bits
   * H - header bits
   */
  generate
    genvar i;
    for (i=0; i < 64; i=i+1) begin
      assign o_data_rev[63-i] = o_data_aligned[i];
    end
  endgenerate
  assign o_header_rev = {o_header_aligned[0], o_header_aligned[1]};

  always @(posedge o_clk) begin
    o_header <= o_header_rev;
    o_data <= o_data_rev;
  end

  sync_header_align i_header_align (
    .clk (o_clk),
    .reset (o_reset),
    .i_data ({o_header, o_data}),
    .i_slip (o_bitslip),
    .i_slip_done (o_bitslip_done),
    .o_data (o_phy_data),
    .o_header (o_phy_header),
    .o_block_sync (o_phy_block_sync));

endmodule
