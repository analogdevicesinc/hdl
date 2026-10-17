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

// Edge select: keeps the first sample after every edge of a per sample level.
//
// Every cycle up to SAMPLES samples arrive, sample 0 the earliest, each with a
// present bit and the level of ilevel that travelled with it. A sample is
// selected when ilevel has its EDGE ("FALL" or "RISE") between it and the
// previous present sample. Each sample is compared with the previous one
// across samples and across cycles, so any number of edges per cycle is
// resolved and an edge on a cycle boundary is not lost. Before the first
// sample after reset the level counts as the one before the edge, high for
// "FALL" and low for "RISE".
//
// Typical use is a stream that repeats every decimated result for its whole
// decimation period, with ilevel a "result ready" line sampled beside the data:
// the selected samples are the first copy of every new result.
//
// okeep is combinational on ipresent and ilevel, so the selection adds no
// latency; only the last level is a register. With ASYNC_RESET that register
// is reset asynchronously.
//
// Example, SAMPLES = 2, EDGE = "FALL", samples listed as [0 1]:
//
//   cycle      0      1      2      3      4
//   sample    [a b]  [c d]  [e f]  [g h]  [i j]
//   ipresent  [1 1]  [1 1]  [1 0]  [1 1]  [0 1]
//   ilevel    [1 1]  [1 0]  [0 -]  [1 1]  [- 0]    - : not present, ignored
//   okeep     [0 0]  [0 1]  [0 0]  [0 0]  [0 1]
//
//   d is kept: its level falls from c in the same cycle.
//   j is kept: the previous present sample is h in cycle 3, so the edge is
//   found across the cycle boundary and the absent i is skipped.
//   g, h rise and are not kept; a is not kept, the level starts high.

`timescale 1ns/100ps

module ad_sample_edge_select #(
  parameter SAMPLES     = 2,
  parameter EDGE        = "FALL",
  parameter ASYNC_RESET = 0
) (
  input                     clk,
  input                     reset,

  input       [SAMPLES-1:0]  ipresent,
  input       [SAMPLES-1:0]  ilevel,

  output reg  [SAMPLES-1:0]  okeep
);

  localparam LEVEL_INIT = (EDGE == "RISE") ? 1'b0 : 1'b1;

  generate
  if ((EDGE != "FALL") && (EDGE != "RISE")) begin : g_cfg_error
    $error("ad_sample_edge_select: EDGE must be FALL or RISE");
    ad_sample_edge_select_ERROR_bad_edge i_cfg_error ();
  end
  endgenerate

  reg  level_last = LEVEL_INIT;
  reg  prev;

  integer j;

  always @(*) begin
    prev  = level_last;
    okeep = 'd0;
    for (j = 0; j < SAMPLES; j = j + 1) begin
      if (ipresent[j]) begin
        okeep[j] = (EDGE == "FALL") ? (~ilevel[j] & prev) : (ilevel[j] & ~prev);
        prev = ilevel[j];
      end
    end
  end

  // ASYNC_RESET selects the reset style; the unused one is tied off.
  wire arst = (ASYNC_RESET != 0) ? reset : 1'b0;
  wire srst = (ASYNC_RESET != 0) ? 1'b0 : reset;

  always @(posedge clk or posedge arst) begin
    if (arst || srst) begin
      level_last <= LEVEL_INIT;
    end else begin
      level_last <= prev;
    end
  end

endmodule
