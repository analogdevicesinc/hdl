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

// Bit alignment of a deserialized word stream.
//
// Words of I_W units, the oldest unit in the most significant position. The
// module removes shift units from the head of the stream, counted from the
// first valid word after reset, so that the next stage sees the sample
// boundaries at fixed positions.
//
// The last NW valid words are kept in a delay line and the output word is
// selected from it at shift units from the oldest word. Every shift value
// 0..2^SHIFT_W-1 is covered, and a change of shift takes effect with the next
// valid word, in either direction. ovalid rises once the delay line is full.
// The output is registered: the word in the output register when shift
// changes still has the previous offset.
//
// With ASYNC_RESET the valid registers are reset asynchronously, so ovalid
// drops as soon as reset rises, also while clk is stopped.

`timescale 1ns/100ps

module ad_bitslip_align #(
  parameter I_W     = 8,
  parameter UNIT_W  = 1,
  parameter SHIFT_W = 5,
  parameter ASYNC_RESET = 0
) (
  input                         clk,
  input                         reset,

  input       [I_W*UNIT_W-1:0]  idata,
  input                         ivalid,

  input       [SHIFT_W-1:0]     shift,

  output reg  [I_W*UNIT_W-1:0]  odata = 'd0,
  output reg                    ovalid = 1'b0
);

  localparam W  = I_W*UNIT_W;
  // words to hold the largest shift plus one output word
  localparam NW = ((1 << SHIFT_W) - 1 + 2*I_W - 1) / I_W;
  localparam FW = $clog2(NW);

  reg  [(NW-1)*W-1:0] dline = 'd0;
  reg  [FW-1:0]       fill = 'd0;

  // oldest word in the most significant position
  wire [NW*W-1:0]     win  = {dline, idata};
  wire                full = (fill == NW-1);
  // a shift operator maps to a staged barrel shifter, smaller than an indexed
  // part select on wide words
  wire [NW*W-1:0]     win_sh = win << (UNIT_W*shift);

  always @(posedge clk) begin
    if (ivalid) begin
      dline <= win[(NW-1)*W-1:0];
      odata <= win_sh[NW*W-1 -: W];
    end
  end

  // ASYNC_RESET selects the reset style of the valid registers.

  wire arst = (ASYNC_RESET != 0) ? reset : 1'b0;
  wire srst = (ASYNC_RESET != 0) ? 1'b0 : reset;

  always @(posedge clk or posedge arst) begin
    if (arst || srst) begin
      fill   <= 'd0;
      ovalid <= 1'b0;
    end else begin
      if (ivalid && !full) begin
        fill <= fill + 1'b1;
      end
      ovalid <= ivalid & full;
    end
  end

endmodule
