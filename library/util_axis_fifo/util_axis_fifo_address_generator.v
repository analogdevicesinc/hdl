// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
`timescale 1ns/1ps

module util_axis_fifo_address_generator #(
  parameter ASYNC_CLK = 0,                // single or double clocked FIFO
  parameter WR_ADDRESS_WIDTH = 4,         // write address width, effective FIFO depth
  parameter RD_ADDRESS_WIDTH = 4          // read address width, must comply with write side
) (
  // Read interface - Sink side

  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output reg m_axis_valid = 1'b0,
  output reg m_axis_empty = 1'b0,
  output [RD_ADDRESS_WIDTH-1:0] m_axis_raddr,
  output reg [RD_ADDRESS_WIDTH:0] m_axis_level = 'b0,

  // Write interface - Source side

  input s_axis_aclk,
  input s_axis_aresetn,
  output reg s_axis_ready = 1'b1,
  input s_axis_valid,
  output reg s_axis_full = 1'b0,
  output [WR_ADDRESS_WIDTH-1:0] s_axis_waddr,
  output reg [WR_ADDRESS_WIDTH:0] s_axis_room = 'b0
);

//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------

localparam WRITE = 1'b1;
localparam READ = 1'b0;
localparam WIDER_IF = (WR_ADDRESS_WIDTH >= RD_ADDRESS_WIDTH) ? WRITE : READ;
localparam ASPECT_RATIO = (WR_ADDRESS_WIDTH >= RD_ADDRESS_WIDTH) ? (WR_ADDRESS_WIDTH - RD_ADDRESS_WIDTH) : (RD_ADDRESS_WIDTH - WR_ADDRESS_WIDTH);
localparam MAX_ROOM = {1'b1,{WR_ADDRESS_WIDTH{1'b0}}};

//------------------------------------------------------------------------------
// registers
//------------------------------------------------------------------------------

// Definition of address counters
// All the counters are wider with one bit to indicate wraparounds
reg [WR_ADDRESS_WIDTH:0] s_axis_waddr_reg = 'h0;
reg [WR_ADDRESS_WIDTH:0] s_axis_waddr_next = 'h0;
reg [RD_ADDRESS_WIDTH:0] m_axis_raddr_reg = 'h0;
reg [RD_ADDRESS_WIDTH:0] m_axis_raddr_next = 'h0;

//------------------------------------------------------------------------------
// wires
//------------------------------------------------------------------------------

wire [RD_ADDRESS_WIDTH:0] s_axis_raddr_reg_s;
wire [WR_ADDRESS_WIDTH:0] m_axis_waddr_reg_s;

wire s_axis_full_s;
wire s_axis_ready_s;
wire [WR_ADDRESS_WIDTH:0] s_axis_room_s;

wire m_axis_empty_s;
wire m_axis_valid_s;
wire [RD_ADDRESS_WIDTH:0] m_axis_level_s;

//------------------------------------------------------------------------------
// Write address counter
//------------------------------------------------------------------------------

always @(*) begin
  if (s_axis_ready && s_axis_valid)
    s_axis_waddr_next <= s_axis_waddr_reg + 1'b1;
  else
    s_axis_waddr_next <= s_axis_waddr_reg;
end

always @(posedge s_axis_aclk)
begin
  if (!s_axis_aresetn)
    s_axis_waddr_reg <= 'h0;
  else
    s_axis_waddr_reg <= s_axis_waddr_next;
end

//------------------------------------------------------------------------------
// Read address counter
//------------------------------------------------------------------------------

always @(*) begin
  if (m_axis_ready && m_axis_valid)
    m_axis_raddr_next <= m_axis_raddr_reg + 1'b1;
  else
    m_axis_raddr_next <= m_axis_raddr_reg;
end

always @(posedge m_axis_aclk)
begin
  if (!m_axis_aresetn)
    m_axis_raddr_reg <= 'h0;
  else
    m_axis_raddr_reg <= m_axis_raddr_next;
end

//------------------------------------------------------------------------------
// Output assignments
//------------------------------------------------------------------------------

assign s_axis_waddr = s_axis_waddr_reg[WR_ADDRESS_WIDTH-1:0];
assign m_axis_raddr = m_axis_raddr_reg[RD_ADDRESS_WIDTH-1:0];

//------------------------------------------------------------------------------
// CDC circuits for double clock configuration
//------------------------------------------------------------------------------
generate if (ASYNC_CLK == 1) begin
  // CDC transfer of the write pointer to the read clock domain
  sync_gray #(
    .DATA_WIDTH(WR_ADDRESS_WIDTH + 1)
  ) i_waddr_sync_gray (
    .in_clk(s_axis_aclk),
    .in_resetn(s_axis_aresetn),
    .out_clk(m_axis_aclk),
    .out_resetn(m_axis_aresetn),
    .in_count(s_axis_waddr_reg),
    .out_count(m_axis_waddr_reg_s)
  );

  // CDC transfer of the read pointer to the write clock domain
  sync_gray #(
    .DATA_WIDTH(RD_ADDRESS_WIDTH + 1)
  ) i_raddr_sync_gray (
    .in_clk(m_axis_aclk),
    .in_resetn(m_axis_aresetn),
    .out_clk(s_axis_aclk),
    .out_resetn(s_axis_aresetn),
    .in_count(m_axis_raddr_reg),
    .out_count(s_axis_raddr_reg_s)
  );
end else begin
  assign m_axis_waddr_reg_s = s_axis_waddr_reg;
  assign s_axis_raddr_reg_s = m_axis_raddr_reg;
end
endgenerate

//------------------------------------------------------------------------------
// FIFO write logic
//
// s_axis_full  - FIFO is full if the write pointer reaches the read pointer
// s_axis_ready - FIFO is always ready, unless it's full
// s_axis_room  - indicates how much free space has the FIFO
//
//------------------------------------------------------------------------------
generate
if (WIDER_IF == WRITE) begin // Write address is wider than read

  // Because the FIFO has a first-fall-through logic, we have to use RADDR-1
  // for our calculations
  assign s_axis_full_s = (s_axis_raddr_reg_s[RD_ADDRESS_WIDTH] != s_axis_waddr_next[WR_ADDRESS_WIDTH]) &&
                         (s_axis_raddr_reg_s[RD_ADDRESS_WIDTH-1:0]-1'b1 == s_axis_waddr_next[WR_ADDRESS_WIDTH-1:ASPECT_RATIO]);
  assign s_axis_room_s = MAX_ROOM + s_axis_raddr_reg_s[RD_ADDRESS_WIDTH-1:0] - s_axis_waddr_next[WR_ADDRESS_WIDTH-1:ASPECT_RATIO];

end else begin // Read address is wider than write address

  assign s_axis_full_s = (s_axis_raddr_reg_s[RD_ADDRESS_WIDTH] != s_axis_waddr_next[WR_ADDRESS_WIDTH]) &&
                         (s_axis_raddr_reg_s[RD_ADDRESS_WIDTH-1:ASPECT_RATIO] == s_axis_waddr_next[WR_ADDRESS_WIDTH-1:0]);
  assign s_axis_room_s = s_axis_raddr_reg_s[RD_ADDRESS_WIDTH-1:ASPECT_RATIO] - s_axis_waddr_next[WR_ADDRESS_WIDTH-1:0] + MAX_ROOM;

end
endgenerate

assign s_axis_ready_s = ~s_axis_full_s;

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    s_axis_ready <= 1'b1;
    s_axis_full <= 1'b0;
    s_axis_room <= MAX_ROOM;
  end else begin
    s_axis_ready <= s_axis_ready_s;
    s_axis_full <= s_axis_full_s;
    s_axis_room <= s_axis_room_s;
  end
end

//------------------------------------------------------------------------------
// FIFO read logic
//
// m_axis_empty - FIFO is empty if the read pointer reaches the write pointer
// m_axis_valid - FIFO has a valid output data, if it's not empty
// m_axis_level - indicates how much valid data are in the FIFO
//
//------------------------------------------------------------------------------
generate
if (WIDER_IF == WRITE) begin // Write address is wider than read

  assign m_axis_empty_s = m_axis_waddr_reg_s[WR_ADDRESS_WIDTH:ASPECT_RATIO] == m_axis_raddr_next;
  assign m_axis_valid_s = ~m_axis_empty_s;
  assign m_axis_level_s = m_axis_waddr_reg_s[WR_ADDRESS_WIDTH:ASPECT_RATIO] - m_axis_raddr_next;

end else begin // Read address is wider than write address

  assign m_axis_empty_s = m_axis_waddr_reg_s == m_axis_raddr_next[RD_ADDRESS_WIDTH:ASPECT_RATIO];
  assign m_axis_valid_s = ~m_axis_empty_s;
  assign m_axis_level_s = {m_axis_waddr_reg_s, {ASPECT_RATIO{1'b1}}} - m_axis_raddr_next[RD_ADDRESS_WIDTH:0];

end
endgenerate

always @(posedge m_axis_aclk)
begin
  if (m_axis_aresetn == 1'b0) begin
    m_axis_valid <= 1'b0;
    m_axis_empty <= 1'b1;
    m_axis_level <= 'h0;
  end else begin
    m_axis_valid <= m_axis_valid_s;
    m_axis_empty <= m_axis_empty_s;
    m_axis_level <= m_axis_level_s;
  end
end
endmodule

