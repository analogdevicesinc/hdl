// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module util_axis_fifo_address_generator #(
  parameter ASYNC_CLK = 0,                // single or double clocked FIFO
  parameter ADDRESS_WIDTH = 4,            // address width, effective FIFO depth
  parameter [ADDRESS_WIDTH-1:0] ALMOST_EMPTY_THRESHOLD = 16,
  parameter [ADDRESS_WIDTH-1:0] ALMOST_FULL_THRESHOLD = 16
) (

  // Read interface - Sink side

  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output m_axis_valid,
  output m_axis_empty,
  output m_axis_almost_empty,
  output [ADDRESS_WIDTH-1:0] m_axis_raddr,
  output [ADDRESS_WIDTH-1:0] m_axis_level,

  // Write interface - Source side

  input s_axis_aclk,
  input s_axis_aresetn,
  output s_axis_ready,
  input s_axis_valid,
  output  s_axis_full,
  output  s_axis_almost_full,
  output [ADDRESS_WIDTH-1:0] s_axis_waddr,
  output [ADDRESS_WIDTH-1:0] s_axis_room
);

  localparam FIFO_DEPTH = {ADDRESS_WIDTH{1'b1}};

  // Definition of address counters
  // All the counters are wider with one bit to indicate wraparounds
  reg [ADDRESS_WIDTH:0] s_axis_waddr_reg = 'h0;
  reg [ADDRESS_WIDTH:0] m_axis_raddr_reg = 'h0;

  wire [ADDRESS_WIDTH:0] s_axis_raddr_reg;
  wire [ADDRESS_WIDTH:0] m_axis_waddr_reg;

  wire s_axis_write_s;
  wire s_axis_ready_s;

  wire m_axis_read_s;
  wire m_axis_valid_s;
  wire [ADDRESS_WIDTH-1:0] m_axis_level_s;

  // Write address counter

  assign s_axis_write_s = s_axis_ready && s_axis_valid && ~s_axis_full;
  always @(posedge s_axis_aclk)
  begin
    if (!s_axis_aresetn)
      s_axis_waddr_reg <= 'h0;
    else
      if (s_axis_write_s)
        s_axis_waddr_reg <= s_axis_waddr_reg + 1'b1;
  end

  // Read address counter

  assign m_axis_read_s = m_axis_ready && m_axis_valid && ~m_axis_empty;
  always @(posedge m_axis_aclk)
  begin
    if (!m_axis_aresetn)
      m_axis_raddr_reg <= 'h0;
    else
      if (m_axis_read_s)
        m_axis_raddr_reg <= m_axis_raddr_reg + 1'b1;
  end

  // Output assignments

  assign s_axis_waddr = s_axis_waddr_reg[ADDRESS_WIDTH-1:0];
  assign m_axis_raddr = m_axis_raddr_reg[ADDRESS_WIDTH-1:0];

  // CDC circuits for double clock configuration

  generate if (ASYNC_CLK == 1) begin : g_async_clock
    // CDC transfer of the write pointer to the read clock domain
    sync_gray #(
      .DATA_WIDTH(ADDRESS_WIDTH + 1)
    ) i_waddr_sync_gray (
      .in_clk(s_axis_aclk),
      .in_resetn(s_axis_aresetn),
      .out_clk(m_axis_aclk),
      .out_resetn(m_axis_aresetn),
      .in_count(s_axis_waddr_reg),
      .out_count(m_axis_waddr_reg));

    // CDC transfer of the read pointer to the write clock domain
    sync_gray #(
      .DATA_WIDTH(ADDRESS_WIDTH + 1)
    ) i_raddr_sync_gray (
      .in_clk(m_axis_aclk),
      .in_resetn(m_axis_aresetn),
      .out_clk(s_axis_aclk),
      .out_resetn(s_axis_aresetn),
      .in_count(m_axis_raddr_reg),
      .out_count(s_axis_raddr_reg));
  end else begin
    assign m_axis_waddr_reg = s_axis_waddr_reg;
    assign s_axis_raddr_reg = m_axis_raddr_reg;
  end
  endgenerate

  //------------------------------------------------------------------------------
  // FIFO write logic - upstream
  //
  // s_axis_full  - FIFO is full if next write pointer equal to read pointer
  // s_axis_ready - FIFO is always ready, unless it's full
  //
  //------------------------------------------------------------------------------

  wire [ADDRESS_WIDTH:0] s_axis_fifo_fill = s_axis_waddr_reg - s_axis_raddr_reg;
  assign s_axis_full = (s_axis_fifo_fill == {ADDRESS_WIDTH{1'b1}});
  assign s_axis_almost_full = s_axis_fifo_fill > {1'b0, ~ALMOST_FULL_THRESHOLD};
  assign s_axis_ready = ~s_axis_full;
  assign s_axis_room = ~s_axis_fifo_fill;

  //------------------------------------------------------------------------------
  // FIFO read logic - downstream
  //
  // m_axis_empty - FIFO is empty if read pointer equal to write pointer
  // m_axis_valid - FIFO has a valid output data, if it's not empty
  //
  //------------------------------------------------------------------------------

  wire [ADDRESS_WIDTH:0] m_axis_fifo_fill = m_axis_waddr_reg - m_axis_raddr_reg;
  assign m_axis_empty = m_axis_fifo_fill == 0;
  assign m_axis_almost_empty = (m_axis_fifo_fill < ALMOST_EMPTY_THRESHOLD);
  assign m_axis_valid = ~m_axis_empty;
  assign m_axis_level = m_axis_fifo_fill;

endmodule
