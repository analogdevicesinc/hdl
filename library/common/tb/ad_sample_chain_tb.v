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


// ad_sample_skip and ad_sample_edge_select followed by ad_sample_compact,
// the chain behind a multi sample packer.
//
// SAMPLES samples arrive per cycle, each with its index as data and the level of
// an active low "result ready" marker that falls with the first sample of every
// decimation period of D samples. With D smaller than SAMPLES several periods,
// and so several marker pulses, start within one cycle. Random cycles carry no
// samples at all. After skip samples, the output stream must be exactly the
// first sample of every period, in order, packed SAMPLES to a word; without the
// selection it must be every sample from skip on.

`timescale 1ns/100ps

module ad_sample_chain_tb;

  parameter VCD_FILE = "ad_sample_chain_tb.vcd";

  `define TIMEOUT 20000000
  `include "tb_base.v"

  wire [6:0] c_fail;
  wire [6:0] c_done;

  ad_sample_chain_case #(.SAMPLES(4), .D(2), .SEL(1), .SKIP(3), .SEED(1)) i_c0 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_sample_chain_case #(.SAMPLES(4), .D(3), .SEL(1), .SKIP(5), .SEED(2)) i_c1 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_sample_chain_case #(.SAMPLES(4), .D(5), .SEL(1), .SKIP(0), .SEED(3)) i_c2 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_sample_chain_case #(.SAMPLES(2), .D(2), .SEL(1), .SKIP(1), .SEED(4)) i_c3 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));
  ad_sample_chain_case #(.SAMPLES(3), .D(2), .SEL(1), .SKIP(7), .SEED(5)) i_c4 (.clk(clk), .fail(c_fail[4]), .done(c_done[4]));
  ad_sample_chain_case #(.SAMPLES(4), .D(2), .SEL(0), .SKIP(9), .SEED(6)) i_c5 (.clk(clk), .fail(c_fail[5]), .done(c_done[5]));
  ad_sample_chain_case #(.SAMPLES(8), .D(2), .SEL(1), .SKIP(11), .SEED(7)) i_c6 (.clk(clk), .fail(c_fail[6]), .done(c_done[6]));

  initial begin
    wait (&c_done);
    @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_sample_chain_case #(
  parameter SAMPLES = 4,
  parameter D     = 2,
  parameter SEL   = 1,
  parameter SKIP  = 3,
  parameter SEED  = 1
) (
  input      clk,
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  localparam W = 16;

  reg                    reset    = 1'b1;
  reg  [SAMPLES*W-1:0]     idata    = 'd0;
  reg  [SAMPLES-1:0]       ipresent = 'd0;
  reg  [SAMPLES-1:0]       imark    = 'd0;
  wire [SAMPLES-1:0]       keep;
  wire [SAMPLES*W-1:0]     odata;
  wire                   ovalid;

  wire [SAMPLES-1:0]       skip_keep;
  wire [SAMPLES-1:0]       edge_keep;

  ad_sample_skip #(
    .SAMPLES(SAMPLES),
    .CNT_W(32)
  ) i_skip (
    .clk(clk),
    .reset(reset),
    .ipresent(ipresent),
    .skip_limit(SKIP),
    .okeep(skip_keep));

  ad_sample_edge_select #(
    .SAMPLES(SAMPLES),
    .EDGE("FALL")
  ) i_edge_select (
    .clk(clk),
    .reset(reset),
    .ipresent(ipresent),
    .ilevel(imark),
    .okeep(edge_keep));

  // Both are combinational, so the keep mask meets the data in the same cycle.
  assign keep = skip_keep & (edge_keep | {SAMPLES{~SEL[0]}});

  ad_sample_compact #(
    .SLOT_W(W),
    .IN_SLOTS(SAMPLES),
    .OUT_SLOTS(SAMPLES)
  ) i_compact (
    .clk(clk),
    .reset(reset),
    .idata(idata),
    .ikeep(keep),
    .odata(odata),
    .ovalid(ovalid));

  integer seed  = SEED;
  integer idx   = 0;     // index of the next sample
  integer expv  = 0;     // next expected output sample index
  integer phase0;        // index of the first period start
  integer nout  = 0;
  integer npulse_max = 0;
  integer k, j, np;

  // The first expected sample: from SKIP on, and with the selection the next
  // period start, which is the first sample whose index is phase0 mod D.
  function integer next_exp;
    input integer from;
    integer v;
    begin
      v = from;
      if (SEL) while (((v - phase0) % D + D) % D != 0) v = v + 1;
      next_exp = v;
    end
  endfunction

  always @(posedge clk) begin
    if (!reset && ovalid) begin
      for (k = 0; k < SAMPLES; k = k + 1) begin
        if (odata[k*W +: W] !== expv[W-1:0]) begin
          fail = 1'b1;
          $display("FAIL L%0d D%0d sel%0d: word %0d lane %0d expected %0d got %0d",
                   SAMPLES, D, SEL, nout, k, expv, odata[k*W +: W]);
        end
        expv = next_exp(expv + (SEL ? D : 1));
      end
      nout = nout + 1;
    end
  end

  initial begin
    // The marker starts in the middle of a period, at a random phase, so the
    // samples before the first falling edge must not be selected.
    phase0 = 1 + (($random(seed) & 32'h7fffffff) % D);
    expv   = next_exp(SKIP);
    repeat (4) @(posedge clk);
    @(negedge clk) reset = 1'b0;
    for (j = 0; j < 4000; j = j + 1) begin
      @(negedge clk);
      np = 0;
      if (($random(seed) & 7) == 0) begin
        ipresent = 'd0;
      end else begin
        ipresent = {SAMPLES{1'b1}};
        for (k = 0; k < SAMPLES; k = k + 1) begin
          idata[k*W +: W] = idx;
          // high only on the last sample before a period start, low elsewhere
          imark[k] = (idx < phase0) ? 1'b1 : ((((idx - phase0) % D) == D-1) ? 1'b1 : 1'b0);
          if (idx >= phase0 && ((idx - phase0) % D) == 0) np = np + 1;
          idx = idx + 1;
        end
      end
      if (np > npulse_max) npulse_max = np;
    end
    @(negedge clk) ipresent = 'd0;
    repeat (8) @(posedge clk);
    if (nout < 100) begin
      fail = 1'b1;
      $display("FAIL L%0d D%0d sel%0d: only %0d words", SAMPLES, D, SEL, nout);
    end
    $display("L%0d D%0d sel%0d skip %0d: %0d words checked, up to %0d marker pulses per cycle, %0s",
             SAMPLES, D, SEL, SKIP, nout, npulse_max, fail ? "FAIL" : "ok");
    done = 1'b1;
  end

endmodule
