// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// Each core or library found in this collection may have its own licensing terms. 
// The user should keep this in in mind while exploring these cores. 
//
// Redistribution and use in source and binary forms,
// with or without modification of this file, are permitted under the terms of either
//  (at the option of the user):
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory, or at:
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
//
// OR
//
//   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
// https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
//
// ***************************************************************************
// ***************************************************************************

module fifo_address_sync (
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

parameter ADDRESS_WIDTH = 4;

reg [ADDRESS_WIDTH:0] room = 2**ADDRESS_WIDTH;
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
    room <= 2**ADDRESS_WIDTH;
    s_axis_empty <= 'h00;
  end else begin
    level <= level_next;
    room <= 2**ADDRESS_WIDTH - level_next;
    m_axis_valid <= level_next != 0;
    s_axis_ready <= level_next != 2**ADDRESS_WIDTH;
    s_axis_empty <= level_next == 0;
  end
end

endmodule

