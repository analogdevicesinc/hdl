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

module jesd204_h_tile_adapter_tx #(
  parameter INVERT = 0
) (
  // PHY interface
  input             o_clk,
  output reg [63:0] o_phy_data,
  output reg [ 1:0] o_phy_control,
  output reg        o_phy_data_valid,

  // Link layer Interface
  input i_clk,
  input i_reset,
  input [63:0] i_phy_data,
  input [ 1:0] i_phy_header,
  // Dummy interface to keep 204B compatibility
  input [7:0]  i_phy_charisk,

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
  reg  [ 2:0] o_start_cnt = 'h0;
  reg         o_read_active = 1'b0;
  reg  [ 5:0] o_valid_cnt = 'h0;
  wire        o_valid_slot;
  wire [63:0] o_data;
  wire [ 1:0] o_header;

  wire        i_fifo_full;
  wire [63:0] i_phy_data_rev;
  wire [ 1:0] i_phy_header_rev;
  reg  [63:0] i_data;
  reg  [ 1:0] i_header;

  // In LR / 66 domain
  generate
  genvar i;
  for (i = 0; i < 64; i = i + 1) begin
    assign i_phy_data_rev[63-i] = i_phy_data[i];
  end
  endgenerate
  assign i_phy_header_rev = {i_phy_header[0], i_phy_header[1]};

  // Register the input data to ease timing
  always @(posedge i_clk) begin
    i_data <= i_phy_data_rev;
    i_header <= i_phy_header_rev;
  end

  // CDC from LR / 66 to LR / 64
  assign wr_clk = i_clk;
  assign rd_clk = o_clk;
  assign wr_data = {i_header, i_data};
  assign wr_en = ~i_reset & ~i_fifo_full;
  assign rd_en = o_read_active & o_valid_slot & ~o_fifo_empty;
  assign aclr = i_reset;

  assign i_fifo_full  = wr_full;
  assign o_fifo_empty = rd_empty;
  assign {o_header, o_data} = rd_data;

  // In LR / 64 domain
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) o_resetn_cdc (
    .in_bits(i_reset),
    .out_clk(o_clk),
    .out_resetn(1'b1),
    .out_bits(o_reset));

  // The 66:64 gearbox takes a 66-bit word on 32 out of every 33 PHY clock
  // cycles, which matches the rate the link layer writes the FIFO at.
  assign o_valid_slot = o_valid_cnt != 6'd32;

  always @(posedge o_clk) begin
    if (o_reset) begin
      o_start_cnt <= 'h0;
      o_read_active <= 1'b0;
      o_valid_cnt <= 'h0;
    end else begin
      if (~o_read_active & ~o_fifo_empty) begin
        o_start_cnt <= o_start_cnt + 1'b1;
        o_read_active <= &o_start_cnt;
      end
      o_valid_cnt <= o_valid_slot ? o_valid_cnt + 1'b1 : 6'd0;
    end
  end

  // The FIFO output follows a read by one cycle and holds between reads, so
  // the word registered on a read cycle is the one from the previous read.
  always @(posedge o_clk) begin
    o_phy_data <= INVERT ? ~o_data : o_data;
    o_phy_control <= INVERT ? ~o_header : o_header;
    o_phy_data_valid <= rd_en;
  end

endmodule
