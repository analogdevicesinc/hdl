// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
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

module jesd204c_phy_adaptor_tx #(
  parameter O_WIDTH = 80,
  parameter DATA_PATH_WIDTH = 8
) (
  // output interface clock. Lane rate / serdes factor
  // e.g  lane rate/64
  input o_clk,

  output reg [O_WIDTH-1:0] o_phy_data = 'h0,
  input                    o_phy_tx_ready,

  // input interface clock. Lane rate / 66
  input i_clk,

  input [DATA_PATH_WIDTH*8-1:0] i_phy_data,
  input [1:0] i_phy_header,
  // Dummy interface to keep 204B compatibility
  input [DATA_PATH_WIDTH-1:0] i_phy_charisk,

  output reg o_status_rate_mismatch = 'b0
);

  // shallow FIFO
  parameter SIZE = 4;
  localparam ADDR_WIDTH = $clog2(SIZE);

  reg [ADDR_WIDTH:0] i_wr_addr = 'h00;
  reg [ADDR_WIDTH:0] o_rd_addr = 'h00;

  wire [65:0] o_data;
  wire o_mem_rd;
  wire o_mem_rd_en;

  wire i_tx_ready;

  // Valid to output interface can be high for 32 cycles out of 33
  reg [5:0] rate_cnt = 6'd32;

  always @(posedge o_clk) begin
    if (~o_mem_rd_en) begin
      rate_cnt <= 6'd32;
    end else if (rate_cnt[5] ) begin
      rate_cnt <= 6'd0;
    end else begin
      rate_cnt <= rate_cnt + 6'd1;
    end
  end

  assign o_mem_rd = ~rate_cnt[5];

  // write to memory when PHY is ready and link clock domain is
  // also running achieved with two sync_bits
  always @(posedge i_clk) begin
    if (~i_tx_ready) begin
      i_wr_addr <= 'h00;
    end else if (1'b1) begin
      i_wr_addr <= i_wr_addr + 1'b1;
    end
  end

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_tx_ready_cdc (
    .in_bits(o_phy_tx_ready),
    .out_clk(i_clk),
    .out_resetn(1'b1),
    .out_bits(i_tx_ready));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_tx_ready_back_cdc (
    .in_bits(i_tx_ready),
    .out_clk(o_clk),
    .out_resetn(1'b1),
    .out_bits(o_mem_rd_en));

  ad_mem #(
    .DATA_WIDTH (1+66),
    .ADDRESS_WIDTH (ADDR_WIDTH)
  ) i_ad_mem (
    .clka(i_clk),
    .wea(1'b1),
    .addra(i_wr_addr[ADDR_WIDTH-1:0]),
    .dina({i_wr_addr[ADDR_WIDTH],i_phy_header,i_phy_data}),

    .clkb(o_clk),
    .reb(o_mem_rd),
    .addrb(o_rd_addr[ADDR_WIDTH-1:0]),
    .doutb({o_tag,o_data}));

  reg o_ref_tag = 1'b0;

  always @(posedge o_clk) begin
    if (~o_phy_tx_ready) begin
      o_rd_addr <= 'h00;
      o_ref_tag <= 1'b0;
    end else if (o_mem_rd) begin
      o_rd_addr <= o_rd_addr + 1'b1;
      o_ref_tag <= o_rd_addr[ADDR_WIDTH];
    end
  end

  // Detect overflow or underflow by checking reference tag against received
  // one over the memory
  always @(posedge o_clk) begin
    if (~o_phy_tx_ready) begin
      o_status_rate_mismatch <= 1'b0;
    end else if (o_tag ^ o_ref_tag) begin
      o_status_rate_mismatch <= 1'b1;
    end
  end

  always @(posedge o_clk) begin
  o_phy_data[68] <= o_mem_rd;
  end

  always @(*) begin
    o_phy_data[38:0] = o_data[38:0];
    o_phy_data[66:40] = o_data[65:39];
  end

endmodule
