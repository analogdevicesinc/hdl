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


// ad_sample_skip: random present patterns against a sample by sample model,
// for several lane counts and skip limits, including limits that end in the
// middle of a cycle. okeep is combinational, so it is checked in the cycle of
// its input.

`timescale 1ns/100ps

module ad_sample_skip_tb;

  parameter VCD_FILE = "ad_sample_skip_tb.vcd";

  `define TIMEOUT 5000000
  `include "tb_base.v"

  wire [4:0] c_fail;
  wire [4:0] c_done;

  ad_sample_skip_case #(.SAMPLES(1), .SEED(1)) i_c1 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_sample_skip_case #(.SAMPLES(2), .SEED(2)) i_c2 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_sample_skip_case #(.SAMPLES(3), .SEED(3)) i_c3 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_sample_skip_case #(.SAMPLES(4), .SEED(4)) i_c4 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));
  ad_sample_skip_case #(.ASYNC(1), .SAMPLES(2), .SEED(5)) i_c5 (.clk(clk), .fail(c_fail[4]), .done(c_done[4]));

  initial begin
    wait (&c_done);
    @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_sample_skip_case #(
  parameter ASYNC = 0,
  parameter SAMPLES = 2,
  parameter SEED  = 1
) (
  input      clk,
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  reg              reset      = 1'b1;
  reg  [SAMPLES-1:0] ipresent   = 'd0;
  reg  [31:0]      skip_limit = 32'd0;
  wire [SAMPLES-1:0] okeep;

  ad_sample_skip #(
    .ASYNC_RESET(ASYNC),
    .SAMPLES(SAMPLES),
    .CNT_W(32)
  ) i_dut (
    .clk(clk),
    .reset(reset),
    .ipresent(ipresent),
    .skip_limit(skip_limit),
    .okeep(okeep));

  integer seed = SEED;
  integer cnt, run, j, k, nerr, nkept;
  reg [SAMPLES-1:0] expect;

  initial begin
    nerr = 0;
    for (run = 0; run < 24; run = run + 1) begin
      @(negedge clk);
      reset      = 1'b1;
      skip_limit = (run < 12) ? run : ($random(seed) & 32'h3f);
      ipresent   = 'd0;
      @(negedge clk);
      reset = 1'b0;
      cnt   = 0;
      nkept = 0;
      for (k = 0; k < 2000; k = k + 1) begin
        @(negedge clk);
        expect = 'd0;
        for (j = 0; j < SAMPLES; j = j + 1) begin
          ipresent[j] = $random(seed);
          if (ipresent[j]) begin
            expect[j] = (cnt >= skip_limit);
            cnt = cnt + 1;
            if (expect[j]) nkept = nkept + 1;
          end
        end
        #1;
        if (okeep !== expect) begin
          nerr = nerr + 1;
          if (nerr < 5) $display("FAIL %0d lanes: keep %b expected %b", SAMPLES, okeep, expect);
          fail = 1'b1;
        end
      end
      @(negedge clk) ipresent = 'd0;
    end
    $display("%0d lanes: 24 runs, %0s", SAMPLES, fail ? "FAIL" : "ok");
    done = 1'b1;
  end

endmodule
