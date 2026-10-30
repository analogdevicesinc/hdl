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

// Skip up to a limit: drops the first skip_limit samples after reset.
//
// Every cycle up to SAMPLES samples arrive, sample 0 the earliest, with a present
// bit each. The count is in samples, so the limit can be reached in the middle
// of a cycle; the samples of that cycle before it are dropped, the rest kept.
//
// okeep is combinational on ipresent, so the skip adds no latency; only the
// remaining count is a register. The comparisons only involve the low bits of
// the count, so its width does not reach the logic depth.
//
// With ASYNC_RESET okeep is low while reset is high, also without a clock, and
// a load flag is reset asynchronously. Until the first clock edge after reset
// the count is taken from skip_limit directly, so the skip is exact even when
// no clock edge was seen during reset.

`timescale 1ns/100ps

module ad_sample_skip #(
  parameter SAMPLES = 2,
  parameter CNT_W = 32,
  parameter ASYNC_RESET = 0
) (
  input                     clk,
  input                     reset,

  input       [SAMPLES-1:0]  ipresent,
  input       [CNT_W-1:0]    skip_limit,

  output reg  [SAMPLES-1:0]  okeep
);

  localparam RW = $clog2(SAMPLES+1);

  generate
  if (CNT_W < RW) begin : g_cfg_error
    $error("ad_sample_skip: CNT_W must be at least $clog2(SAMPLES+1)");
    ad_sample_skip_ERROR_cnt_w_too_small i_cfg_error ();
  end
  endgenerate

  // rem counts the samples still to skip. A present sample is kept once the
  // present samples in front of it in the same cycle exhaust rem.
  reg  [CNT_W-1:0]    rem = 'd0;
  reg                  loaded = 1'b0;
  reg  [RW-1:0]        rank;
  reg  [SAMPLES-1:0]   keep_c;

  // The count in effect this cycle. Only with ASYNC_RESET can the first cycle
  // after reset come without a load, so only then is loaded used.
  wire [CNT_W-1:0]     rem_c     = (loaded || (ASYNC_RESET == 0)) ? rem : skip_limit;
  wire                 rem_small = ((rem_c >> RW) == 'd0);

  integer j;

  always @(*) begin
    rank   = 'd0;
    keep_c = 'd0;
    for (j = 0; j < SAMPLES; j = j + 1) begin
      if (ipresent[j]) begin
        // rank >= rem
        keep_c[j] = rem_small && (rem_c[RW-1:0] <= rank);
        rank = rank + 1'b1;
      end
    end
    okeep = (ASYNC_RESET != 0) ? (keep_c & {SAMPLES{~reset}}) : keep_c;
  end

  always @(posedge clk) begin
    if (reset) begin
      rem <= skip_limit;
    end else if (~rem_small || (rem_c[RW-1:0] > rank)) begin
      // rem > present samples of the cycle
      rem <= rem_c - rank;
    end else begin
      rem <= 'd0;
    end
  end

  // ASYNC_RESET selects the reset style; the unused one is tied off.
  wire arst = (ASYNC_RESET != 0) ? reset : 1'b0;
  wire srst = (ASYNC_RESET != 0) ? 1'b0 : reset;

  always @(posedge clk or posedge arst) begin
    if (arst || srst) begin
      loaded <= 1'b0;
    end else begin
      loaded <= 1'b1;
    end
  end

endmodule
