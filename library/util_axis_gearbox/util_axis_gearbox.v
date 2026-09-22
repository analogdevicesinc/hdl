// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// AXI-Stream width converter for any rational width ratio, including the
// non-integer ones util_axis_resize and util_axis_fifo_asym cannot express
// (e.g. 1536 -> 2048, where 4 slave beats carry exactly 3 master beats).
// Data only: there is no tkeep/tlast, so beats carry no framing and a partial
// tail is not representable. The stream must be a multiple of
// lcm(S_DATA_WIDTH,M_DATA_WIDTH) bits or the remainder stays in the buffer.

module util_axis_gearbox #(

  parameter S_DATA_WIDTH = 64,
  parameter M_DATA_WIDTH = 64
) (
  input                       clk,
  input                       resetn,

  input                       s_axis_valid,
  output                      s_axis_ready,
  input  [S_DATA_WIDTH-1:0]   s_axis_data,

  output                      m_axis_valid,
  input                       m_axis_ready,
  output [M_DATA_WIDTH-1:0]   m_axis_data
);

  function integer gcd;
    input integer a;
    input integer b;
    integer x, y, r;
    begin
      x = a;
      y = b;
      while (y != 0) begin
        r = x % y;
        x = y;
        y = r;
      end
      gcd = x;
    end
  endfunction

  // Both widths are an integer number of units, so buffer occupancy is tracked
  // in units instead of bits and every shift is by a whole number of them.
  localparam UNIT_WIDTH = gcd(S_DATA_WIDTH, M_DATA_WIDTH);
  localparam S_UNITS = S_DATA_WIDTH / UNIT_WIDTH;
  localparam M_UNITS = M_DATA_WIDTH / UNIT_WIDTH;
  localparam BUF_UNITS = S_UNITS + M_UNITS - 1;
  localparam BUF_WIDTH = BUF_UNITS * UNIT_WIDTH;
  localparam LEVEL_WIDTH = $clog2(BUF_UNITS + 1);

  reg [BUF_WIDTH-1:0] buffer = {BUF_WIDTH{1'b0}};
  reg [LEVEL_WIDTH-1:0] level = {LEVEL_WIDTH{1'b0}};
  reg [BUF_WIDTH-1:0] buffer_next;
  reg [LEVEL_WIDTH-1:0] level_next;

  wire in_xfer;
  wire out_xfer;
  wire [LEVEL_WIDTH-1:0] level_out;
  wire [BUF_WIDTH-1:0] buffer_out;

  assign m_axis_valid = level >= M_UNITS;
  assign m_axis_data = buffer[M_DATA_WIDTH-1:0];

  assign out_xfer = m_axis_valid & m_axis_ready;
  assign level_out = out_xfer ? level - M_UNITS : level;
  assign buffer_out = out_xfer ? buffer >> M_DATA_WIDTH : buffer;

  // Room is evaluated after this cycle's output, which is what keeps the slave
  // side at full rate: for 1536 -> 2048 the buffer sits at 4..6 units in steady
  // state, so gating on the pre-shift level would accept only 4 beats every 7
  // cycles instead of one per cycle.
  assign s_axis_ready = level_out <= (BUF_UNITS - S_UNITS);
  assign in_xfer = s_axis_valid & s_axis_ready;

  always @(*) begin
    buffer_next = buffer_out;
    level_next = level_out;
    if (in_xfer) begin
      buffer_next[level_out*UNIT_WIDTH +: S_DATA_WIDTH] = s_axis_data;
      level_next = level_out + S_UNITS;
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      level <= 'd0;
    end else begin
      buffer <= buffer_next;
      level <= level_next;
    end
  end

endmodule
