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


// ad_sample_edge_select: random present and level patterns against a sample by
// sample model, for several lane counts and both edges, with sparse and dense
// edges. okeep is combinational, so it is checked in the cycle of its input.

`timescale 1ns/100ps

module ad_sample_edge_select_tb;

  parameter VCD_FILE = "ad_sample_edge_select_tb.vcd";

  `define TIMEOUT 5000000
  `include "tb_base.v"

  wire [6:0] c_fail;
  wire [6:0] c_done;

  ad_sample_edge_select_case #(.SAMPLES(1), .EDGE("FALL"), .SEED(1)) i_c1 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_sample_edge_select_case #(.SAMPLES(2), .EDGE("FALL"), .SEED(2)) i_c2 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_sample_edge_select_case #(.SAMPLES(3), .EDGE("FALL"), .SEED(3)) i_c3 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_sample_edge_select_case #(.SAMPLES(4), .EDGE("FALL"), .SEED(4)) i_c4 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));
  ad_sample_edge_select_case #(.SAMPLES(2), .EDGE("RISE"), .SEED(5)) i_c5 (.clk(clk), .fail(c_fail[4]), .done(c_done[4]));
  ad_sample_edge_select_case #(.SAMPLES(4), .EDGE("RISE"), .SEED(6)) i_c6 (.clk(clk), .fail(c_fail[5]), .done(c_done[5]));
  ad_sample_edge_select_case #(.ASYNC(1), .SAMPLES(2), .EDGE("FALL"), .SEED(7)) i_c7 (.clk(clk), .fail(c_fail[6]), .done(c_done[6]));

  initial begin
    wait (&c_done);
    @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_sample_edge_select_case #(
  parameter ASYNC = 0,
  parameter SAMPLES = 2,
  parameter EDGE  = "FALL",
  parameter SEED  = 1
) (
  input      clk,
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  reg              reset    = 1'b1;
  reg  [SAMPLES-1:0] ipresent = 'd0;
  reg  [SAMPLES-1:0] ilevel   = 'd0;
  wire [SAMPLES-1:0] okeep;

  ad_sample_edge_select #(
    .ASYNC_RESET(ASYNC),
    .SAMPLES(SAMPLES),
    .EDGE(EDGE)
  ) i_dut (
    .clk(clk),
    .reset(reset),
    .ipresent(ipresent),
    .ilevel(ilevel),
    .okeep(okeep));

  integer seed = SEED;
  integer run, j, k, nerr, nkept;
  reg     prev;
  reg [SAMPLES-1:0] expect;

  initial begin
    nerr = 0;
    for (run = 0; run < 16; run = run + 1) begin
      @(negedge clk);
      reset    = 1'b1;
      ipresent = 'd0;
      @(negedge clk);
      reset = 1'b0;
      prev  = (EDGE == "RISE") ? 1'b0 : 1'b1;
      nkept = 0;
      for (k = 0; k < 2000; k = k + 1) begin
        @(negedge clk);
        expect = 'd0;
        for (j = 0; j < SAMPLES; j = j + 1) begin
          ipresent[j] = $random(seed);
          // sparse edges on even runs, dense on odd ones
          ilevel[j]   = run[0] ? $random(seed) : (($random(seed) & 7) == 0);
          if (ipresent[j]) begin
            expect[j] = (EDGE == "FALL") ? (!ilevel[j] && prev) : (ilevel[j] && !prev);
            prev = ilevel[j];
            if (expect[j]) nkept = nkept + 1;
          end
        end
        #1;
        if (okeep !== expect) begin
          nerr = nerr + 1;
          if (nerr < 5) $display("FAIL %0d lanes %0s: keep %b expected %b", SAMPLES, EDGE, okeep, expect);
          fail = 1'b1;
        end
      end
      @(negedge clk) ipresent = 'd0;
    end
    $display("%0d lanes %0s: 16 runs, %0s", SAMPLES, EDGE, fail ? "FAIL" : "ok");
    done = 1'b1;
  end

endmodule
