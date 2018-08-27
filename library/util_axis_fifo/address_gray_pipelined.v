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

module fifo_address_gray_pipelined #(
  parameter ADDRESS_WIDTH = 4
) (
  input m_axis_aclk,
  input m_axis_aresetn,
  input m_axis_ready,
  output reg m_axis_valid,
  output [ADDRESS_WIDTH-1:0] m_axis_raddr,
  output reg [ADDRESS_WIDTH:0] m_axis_level,

  input s_axis_aclk,
  input s_axis_aresetn,
  output reg s_axis_ready,
  input s_axis_valid,
  output reg s_axis_empty,
  output [ADDRESS_WIDTH-1:0] s_axis_waddr,
  output reg [ADDRESS_WIDTH:0] s_axis_room
);

localparam MAX_ROOM = {1'b1,{ADDRESS_WIDTH{1'b0}}};

reg [ADDRESS_WIDTH:0] _s_axis_waddr = 'h00;
reg [ADDRESS_WIDTH:0] _s_axis_waddr_next;
wire [ADDRESS_WIDTH:0] _s_axis_raddr;

reg [ADDRESS_WIDTH:0] _m_axis_raddr = 'h00;
reg [ADDRESS_WIDTH:0] _m_axis_raddr_next;
wire [ADDRESS_WIDTH:0] _m_axis_waddr;

assign s_axis_waddr = _s_axis_waddr[ADDRESS_WIDTH-1:0];
assign m_axis_raddr = _m_axis_raddr[ADDRESS_WIDTH-1:0];

always @(*)
begin
  if (s_axis_ready && s_axis_valid)
    _s_axis_waddr_next <= _s_axis_waddr + 1'b1;
  else
    _s_axis_waddr_next <= _s_axis_waddr;
end

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    _s_axis_waddr <= 'h00;
  end else begin
    _s_axis_waddr <= _s_axis_waddr_next;
  end
end

always @(*)
begin
  if (m_axis_ready && m_axis_valid)
    _m_axis_raddr_next <= _m_axis_raddr + 1'b1;
  else
    _m_axis_raddr_next <= _m_axis_raddr;
end

always @(posedge m_axis_aclk)
begin
  if (m_axis_aresetn == 1'b0) begin
    _m_axis_raddr <= 'h00;
  end else begin
    _m_axis_raddr <= _m_axis_raddr_next;
  end
end

sync_gray #(
  .DATA_WIDTH(ADDRESS_WIDTH + 1)
) i_waddr_sync (
  .in_clk(s_axis_aclk),
  .in_resetn(s_axis_aresetn),
  .out_clk(m_axis_aclk),
  .out_resetn(m_axis_aresetn),
  .in_count(_s_axis_waddr),
  .out_count(_m_axis_waddr)
);

sync_gray #(
  .DATA_WIDTH(ADDRESS_WIDTH + 1)
) i_raddr_sync (
  .in_clk(m_axis_aclk),
  .in_resetn(m_axis_aresetn),
  .out_clk(s_axis_aclk),
  .out_resetn(s_axis_aresetn),
  .in_count(_m_axis_raddr),
  .out_count(_s_axis_raddr)
);

always @(posedge s_axis_aclk)
begin
  if (s_axis_aresetn == 1'b0) begin
    s_axis_ready <= 1'b1;
    s_axis_empty <= 1'b1;
    s_axis_room <= MAX_ROOM;
  end else begin
    s_axis_ready <= (_s_axis_raddr[ADDRESS_WIDTH] == _s_axis_waddr_next[ADDRESS_WIDTH] ||
      _s_axis_raddr[ADDRESS_WIDTH-1:0] != _s_axis_waddr_next[ADDRESS_WIDTH-1:0]);
    s_axis_empty <= _s_axis_raddr == _s_axis_waddr_next;
    s_axis_room <= _s_axis_raddr - _s_axis_waddr_next + MAX_ROOM;
  end
end

always @(posedge m_axis_aclk)
begin
  if (m_axis_aresetn == 1'b0) begin
    m_axis_valid <= 1'b0;
    m_axis_level <= 'h00;
  end else begin
    m_axis_valid <= _m_axis_waddr != _m_axis_raddr_next;
    m_axis_level <= _m_axis_waddr - _m_axis_raddr_next;
  end
end

endmodule

