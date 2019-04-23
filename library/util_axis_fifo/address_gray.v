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

`timescale 1ns/100ps

module fifo_address_gray #(
  parameter ADDRESS_WIDTH = 4
) (
  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output reg m_axis_valid,
  output reg [ADDRESS_WIDTH:0] m_axis_level,

  input s_axis_aclk,
  input s_axis_aresetn,
  output reg s_axis_ready,
  input s_axis_valid,
  output reg s_axis_empty,
  output [ADDRESS_WIDTH-1:0] s_axis_waddr,
  output reg [ADDRESS_WIDTH:0] s_axis_room
);

reg [ADDRESS_WIDTH:0] _s_axis_waddr = 'h00;
reg [ADDRESS_WIDTH:0] _s_axis_waddr_next;

reg [ADDRESS_WIDTH:0] _m_axis_raddr = 'h00;
reg [ADDRESS_WIDTH:0] _m_axis_raddr_next;

reg [ADDRESS_WIDTH:0] s_axis_waddr_gray = 'h00;
wire [ADDRESS_WIDTH:0] s_axis_waddr_gray_next;
wire [ADDRESS_WIDTH:0] s_axis_raddr_gray;

reg [ADDRESS_WIDTH:0] m_axis_raddr_gray = 'h00;
wire [ADDRESS_WIDTH:0] m_axis_raddr_gray_next;
wire [ADDRESS_WIDTH:0] m_axis_waddr_gray;

assign s_axis_waddr = _s_axis_waddr[ADDRESS_WIDTH-1:0];

always @(*)
begin
  if (s_axis_ready && s_axis_valid)
    _s_axis_waddr_next <= _s_axis_waddr + 1;
  else
    _s_axis_waddr_next <= _s_axis_waddr;
end

assign s_axis_waddr_gray_next = _s_axis_waddr_next ^ _s_axis_waddr_next[ADDRESS_WIDTH:1];

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    _s_axis_waddr <= 'h00;
    s_axis_waddr_gray <= 'h00;
  end else begin
    _s_axis_waddr <= _s_axis_waddr_next;
    s_axis_waddr_gray <= s_axis_waddr_gray_next;
  end
end

always @(*)
begin
  if (m_axis_ready && m_axis_valid)
    _m_axis_raddr_next <= _m_axis_raddr + 1;
  else
    _m_axis_raddr_next <= _m_axis_raddr;
end

assign m_axis_raddr_gray_next = _m_axis_raddr_next ^ _m_axis_raddr_next[ADDRESS_WIDTH:1];

always @(posedge m_axis_aclk)
begin
  if (m_axis_aresetn == 1'b0) begin
    _m_axis_raddr <= 'h00;
    m_axis_raddr_gray <= 'h00;
  end else begin
    _m_axis_raddr <= _m_axis_raddr_next;
    m_axis_raddr_gray <= m_axis_raddr_gray_next;
  end
end

sync_bits #(
  .NUM_OF_BITS(ADDRESS_WIDTH + 1)
) i_waddr_sync (
  .out_clk(m_axis_aclk),
  .out_resetn(m_axis_aresetn),
  .in_bits(s_axis_waddr_gray),
  .out_bits(m_axis_waddr_gray)
);

sync_bits #(
  .NUM_OF_BITS(ADDRESS_WIDTH + 1)
) i_raddr_sync (
  .out_clk(s_axis_aclk),
  .out_resetn(s_axis_aresetn),
  .in_bits(m_axis_raddr_gray),
  .out_bits(s_axis_raddr_gray)
);

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    s_axis_ready <= 1'b1;
    s_axis_empty <= 1'b1;
  end else begin
    s_axis_ready <= (s_axis_raddr_gray[ADDRESS_WIDTH] == s_axis_waddr_gray_next[ADDRESS_WIDTH] ||
      s_axis_raddr_gray[ADDRESS_WIDTH-1] == s_axis_waddr_gray_next[ADDRESS_WIDTH-1] ||
      s_axis_raddr_gray[ADDRESS_WIDTH-2:0] != s_axis_waddr_gray_next[ADDRESS_WIDTH-2:0]);
    s_axis_empty <= s_axis_raddr_gray == s_axis_waddr_gray_next;
  end
end

always @(posedge m_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0)
    m_axis_valid <= 1'b0;
  else begin
    m_axis_valid <= m_axis_waddr_gray != m_axis_raddr_gray_next;
  end
end

endmodule

