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

module jesd204c_phy_adaptor_rx #(
  parameter I_WIDTH = 80,
  parameter DATA_PATH_WIDTH = 8
) (
  // input clock. Lane rate / serdes factor
  // e.g  lane rate/64
  input i_clk,

  input [I_WIDTH-1:0] i_phy_data,
  input               i_phy_rx_ready,
  output  reg         i_phy_bitslip = 1'b0,

  // output clock. Lane rate / 66
  input o_clk,

  output [DATA_PATH_WIDTH*8-1:0] o_phy_data,
  output [1:0] o_phy_header,
  output o_phy_block_sync,
  // Dummy interface to keep 204B compatibility
  output reg [DATA_PATH_WIDTH-1:0] o_phy_charisk = 'h0,
  output reg [DATA_PATH_WIDTH-1:0] o_phy_notintable = 'h0,
  output reg [DATA_PATH_WIDTH-1:0] o_phy_disperr = 'h0,
  input                            o_phy_patternalign_en,

  output reg o_status_rate_mismatch = 'b0
);

  wire        i_valid;
  wire [65:0] i_data;
  wire        i_slip_done;

  wire [65:0] o_data;

  assign i_valid = i_phy_data[68];
  assign i_slip_done = i_phy_data[70];
  assign i_data = {i_phy_data[66:40],i_phy_data[38:0]};

  // shallow FIFO
  parameter SIZE = 4;
  localparam ADDR_WIDTH = $clog2(SIZE);

  reg [ADDR_WIDTH:0] i_wr_addr = 'h00;
  reg [ADDR_WIDTH:0] o_rd_addr = 'h00;
  reg o_sha_disable = 1'b1;
  reg o_ref_tag = 1'b0;

  wire i_mem_wr_en;
  wire o_rx_ready;
  wire o_slip_done;

  // write to memory when PHY is ready and link clock domain is
  // also running achieved with two sync_bits
  always @(posedge i_clk) begin
    if (~i_phy_rx_ready) begin
      i_wr_addr <= 'h00;
    end else if (i_mem_wr_en & i_valid) begin
      i_wr_addr <= i_wr_addr + 1'b1;
    end
  end

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_rx_ready_cdc (
    .in_bits(i_phy_rx_ready),
    .out_clk(o_clk),
    .out_resetn(1'b1),
    .out_bits(o_rx_ready));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_rx_ready_back_cdc (
    .in_bits(o_rx_ready),
    .out_clk(i_clk),
    .out_resetn(1'b1),
    .out_bits(i_mem_wr_en));

  ad_mem #(
    .DATA_WIDTH (2+66),
    .ADDRESS_WIDTH (ADDR_WIDTH)
  ) i_ad_mem (
    .clka(i_clk),
    .wea(i_mem_wr_en & i_valid),
    .addra(i_wr_addr[ADDR_WIDTH-1:0]),
    .dina({i_slip_done,i_wr_addr[ADDR_WIDTH],i_data}),

    .clkb(o_clk),
    .reb(1'b1),
    .addrb(o_rd_addr[ADDR_WIDTH-1:0]),
    .doutb({o_slip_done,o_tag,o_data}));

  // When at least one element is written into the memory read can start
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_i_mem_wr_en_cdc (
    .in_bits(i_mem_wr_en),
    .out_clk(o_clk),
    .out_resetn(o_rx_ready),
    .out_bits(o_mem_rd));

  always @(posedge o_clk) begin
    if (~o_rx_ready) begin
      o_rd_addr <= 'h00;
      o_sha_disable <= 1'b1;
      o_ref_tag <= 1'b0;
    end else if (o_mem_rd) begin
      o_rd_addr <= o_rd_addr + 1'b1;
      o_sha_disable <= 1'b0;
      o_ref_tag <= o_rd_addr[ADDR_WIDTH];
    end
  end

  // Detect overflow or underflow by checking reference tag against received
  // one over the memory
  always @(posedge o_clk) begin
    if (~o_rx_ready) begin
      o_status_rate_mismatch <= 1'b0;
    end else if (o_tag ^ o_ref_tag) begin
      o_status_rate_mismatch <= 1'b1;
    end
  end

  wire o_slip_done_edge;
  reg o_slip_done_d = 1'b0;
  reg o_slip_done_2d = 1'b0;
  reg o_slip_done_3d = 1'b0;
  always @(posedge o_clk) begin
    o_slip_done_d <= o_slip_done;
    o_slip_done_2d <= o_slip_done_d;
    o_slip_done_3d <= o_slip_done_2d;
  end

  // Slip is done actually two clock cycle after the falling edge of
  // parallel_data[70]
  assign o_slip_done_edge = ~o_slip_done_2d & o_slip_done_3d;

  wire o_slip_req;
  wire i_slip_req;

  // Sync slip request
  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_slip_req_cdc (
    .in_bits(o_slip_req),
    .out_clk(i_clk),
    .out_resetn(~i_slip_done),
    .out_bits(i_slip_req));

  reg [6:0] bitslip_quiet_cnt = 7'h40;

  // Avoid asserting bitslip faster than 64 clock cycles from the assertion of
  // bitslip done
  always @(posedge i_clk) begin
    if (i_slip_req & bitslip_quiet_cnt[6]) begin
      i_phy_bitslip <= 1'b1;
    end else if (i_slip_done) begin
      i_phy_bitslip <= 1'b0;
    end
  end

  always @(posedge i_clk) begin
    if (i_slip_done) begin
      bitslip_quiet_cnt <= 7'b0;
    end else if (~bitslip_quiet_cnt[6]) begin
      bitslip_quiet_cnt <= bitslip_quiet_cnt + 7'b1;
    end
  end

  // Sync header alignment
  sync_header_align i_sync_header_align (
    .clk(o_clk),
    .reset(o_sha_disable),
    .i_data(o_data),
    .i_slip(o_slip_req),
    .i_slip_done(o_slip_done_edge),
    .o_data(o_phy_data),
    .o_header(o_phy_header),
    .o_block_sync(o_phy_block_sync));

endmodule
