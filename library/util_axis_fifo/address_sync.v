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

module fifo_address_sync #(
  parameter ADDRESS_WIDTH = 4
) (
  input clk,
  input resetn,

  input m_axis_ready,
  output reg m_axis_valid,
  output reg  [ADDRESS_WIDTH-1:0] m_axis_raddr,
  output [ADDRESS_WIDTH:0] m_axis_level,

  output reg s_axis_ready,
  input s_axis_valid,
  output reg s_axis_empty,
  output reg [ADDRESS_WIDTH-1:0] s_axis_waddr,
  output [ADDRESS_WIDTH:0] s_axis_room
);

localparam MAX_ROOM = {1'b1,{ADDRESS_WIDTH{1'b0}}};

reg [ADDRESS_WIDTH:0] room = MAX_ROOM;
reg [ADDRESS_WIDTH:0] level = 'h00;
reg [ADDRESS_WIDTH:0] level_next;

assign s_axis_room = room;
assign m_axis_level = level;

wire read = m_axis_ready & m_axis_valid;
wire write = s_axis_ready & s_axis_valid;

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    s_axis_waddr <= 'h00;
    m_axis_raddr <= 'h00;
  end else begin
    if (write)
      s_axis_waddr <= s_axis_waddr + 1'b1;
    if (read)
      m_axis_raddr <= m_axis_raddr + 1'b1;
  end
end

always @(*)
begin
  if (read & ~write)
    level_next <= level - 1'b1;
  else if (~read & write)
    level_next <= level + 1'b1;
  else
    level_next <= level;
end

always @(posedge clk)
begin
  if (resetn == 1'b0) begin
    m_axis_valid <= 1'b0;
    s_axis_ready <= 1'b0;
    level <= 'h00;
    room <= MAX_ROOM;
    s_axis_empty <= 'h00;
  end else begin
    level <= level_next;
    room <= MAX_ROOM - level_next;
    m_axis_valid <= level_next != 0;
    s_axis_ready <= level_next != MAX_ROOM;
    s_axis_empty <= level_next == 0;
  end
end

endmodule

