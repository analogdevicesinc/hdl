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


// ad_sample_compact: random keep masks against an in order scoreboard.
//
// Every input sample carries a running index. A model queue holds the kept
// indices; every output word must be exactly the next OUT_SLOTS of them, lane
// 0 first. At the end the number of samples still in the module must be below
// a whole word. Several lane combinations run side by side, each with all
// keep patterns and with sparse and dense keep rates.

`timescale 1ns/100ps

module ad_sample_compact_tb;

  parameter VCD_FILE = "ad_sample_compact_tb.vcd";

  `define TIMEOUT 2000000
  `include "tb_base.v"

  wire [34:0] c_fail;
  wire [34:0] c_done;

  ad_sample_compact_case #(.IN_SLOTS(1), .OUT_SLOTS(1), .SEED(1)) i_c0 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_sample_compact_case #(.IN_SLOTS(1), .OUT_SLOTS(2), .SEED(2)) i_c1 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(2), .SEED(3)) i_c2 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(3), .SEED(4)) i_c3 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));
  ad_sample_compact_case #(.IN_SLOTS(4), .OUT_SLOTS(4), .SEED(5)) i_c4 (.clk(clk), .fail(c_fail[4]), .done(c_done[4]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(2), .OUT_SLOTS(2), .SEED(9)) i_c5 (.clk(clk), .fail(c_fail[5]), .done(c_done[5]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(4), .SEED(11)) i_c6 (.clk(clk), .fail(c_fail[6]), .done(c_done[6]));
  ad_sample_compact_case #(.IN_SLOTS(8), .OUT_SLOTS(8), .PIPE(0), .SEED(12)) i_c7 (.clk(clk), .fail(c_fail[7]), .done(c_done[7]));
  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .SEED(13)) i_c8 (.clk(clk), .fail(c_fail[8]), .done(c_done[8]));
  ad_sample_compact_case #(.IN_SLOTS(4), .OUT_SLOTS(8), .SEED(14)) i_c9 (.clk(clk), .fail(c_fail[9]), .done(c_done[9]));
  ad_sample_compact_case #(.IN_SLOTS(5), .OUT_SLOTS(7), .SEED(15)) i_c10 (.clk(clk), .fail(c_fail[10]), .done(c_done[10]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(8), .OUT_SLOTS(16), .SEED(16)) i_c11 (.clk(clk), .fail(c_fail[11]), .done(c_done[11]));
  ad_sample_compact_case #(.IN_SLOTS(4), .OUT_SLOTS(8), .ROT(1), .PIPE(1), .SEED(17)) i_c12 (.clk(clk), .fail(c_fail[12]), .done(c_done[12]));
  ad_sample_compact_case #(.IN_SLOTS(4), .OUT_SLOTS(8), .ROT(2), .PIPE(2), .SEED(18)) i_c13 (.clk(clk), .fail(c_fail[13]), .done(c_done[13]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(8), .OUT_SLOTS(16), .ROT(1), .PIPE(2), .SEED(19)) i_c14 (.clk(clk), .fail(c_fail[14]), .done(c_done[14]));
  ad_sample_compact_case #(.IN_SLOTS(5), .OUT_SLOTS(7), .ROT(2), .PIPE(1), .SEED(20)) i_c15 (.clk(clk), .fail(c_fail[15]), .done(c_done[15]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(3), .ROT(2), .PIPE(2), .SEED(21)) i_c16 (.clk(clk), .fail(c_fail[16]), .done(c_done[16]));
  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .ROT(2), .PIPE(1), .SEED(22)) i_c17 (.clk(clk), .fail(c_fail[17]), .done(c_done[17]));
  ad_sample_compact_case #(.IN_SLOTS(4), .OUT_SLOTS(4), .ROT(2), .SEED(23)) i_c18 (.clk(clk), .fail(c_fail[18]), .done(c_done[18]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(1), .OUT_SLOTS(2), .ROT(1), .PIPE(2), .SEED(24)) i_c19 (.clk(clk), .fail(c_fail[19]), .done(c_done[19]));
  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .PIPE(3), .SEED(25)) i_c20 (.clk(clk), .fail(c_fail[20]), .done(c_done[20]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(5), .OUT_SLOTS(7), .ROT(2), .PIPE(3), .SEED(26)) i_c21 (.clk(clk), .fail(c_fail[21]), .done(c_done[21]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(4), .PIPE(3), .SEED(27)) i_c22 (.clk(clk), .fail(c_fail[22]), .done(c_done[22]));
  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .PIPE(4), .SEED(28)) i_c23 (.clk(clk), .fail(c_fail[23]), .done(c_done[23]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(5), .OUT_SLOTS(7), .PIPE(4), .SEED(29)) i_c24 (.clk(clk), .fail(c_fail[24]), .done(c_done[24]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(8), .PIPE(4), .SEED(30)) i_c25 (.clk(clk), .fail(c_fail[25]), .done(c_done[25]));

  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .PIPE(5), .SEED(31)) i_c26 (.clk(clk), .fail(c_fail[26]), .done(c_done[26]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(13), .OUT_SLOTS(16), .PIPE(5), .SEED(32)) i_c27 (.clk(clk), .fail(c_fail[27]), .done(c_done[27]));
  ad_sample_compact_case #(.IN_SLOTS(5), .OUT_SLOTS(7), .PIPE(5), .SEED(33)) i_c28 (.clk(clk), .fail(c_fail[28]), .done(c_done[28]));
  ad_sample_compact_case #(.IN_SLOTS(32), .OUT_SLOTS(32), .PIPE(6), .SEED(34)) i_c29 (.clk(clk), .fail(c_fail[29]), .done(c_done[29]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(8), .OUT_SLOTS(16), .PIPE(6), .SEED(35)) i_c30 (.clk(clk), .fail(c_fail[30]), .done(c_done[30]));
  ad_sample_compact_case #(.IN_SLOTS(2), .OUT_SLOTS(3), .PIPE(6), .SEED(36)) i_c31 (.clk(clk), .fail(c_fail[31]), .done(c_done[31]));

  ad_sample_compact_case #(.IN_SLOTS(8), .OUT_SLOTS(8), .MASK(64'h20), .SEED(37)) i_c32 (.clk(clk), .fail(c_fail[32]), .done(c_done[32]));
  ad_sample_compact_case #(.IN_SLOTS(16), .OUT_SLOTS(16), .MASK(64'hA2), .SEED(38)) i_c33 (.clk(clk), .fail(c_fail[33]), .done(c_done[33]));
  ad_sample_compact_case #(.ASYNC(1), .IN_SLOTS(8), .OUT_SLOTS(32), .MASK(64'h1A4), .SEED(39)) i_c34 (.clk(clk), .fail(c_fail[34]), .done(c_done[34]));

  initial begin
    wait (&c_done);
    @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_sample_compact_case #(
  parameter ASYNC = 0,
  parameter IN_SLOTS  = 2,
  parameter OUT_SLOTS = 2,
  parameter ROT       = 0,
  parameter PIPE      = -1,
  parameter [63:0] MASK = 64'd0,
  parameter SEED      = 1
) (
  input      clk,
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  localparam W  = 16;
  localparam QN = 65536;

  reg                       reset = 1'b1;
  reg  [IN_SLOTS*W-1:0]     idata = 'd0;
  reg  [IN_SLOTS-1:0]       ikeep = 'd0;
  wire [OUT_SLOTS*W-1:0]    odata;
  wire                      ovalid;

  ad_sample_compact #(
    .ASYNC_RESET(ASYNC),
    .SLOT_W(W),
    .IN_SLOTS(IN_SLOTS),
    .OUT_SLOTS(OUT_SLOTS),
    .ROT_IMPL(ROT),
    .PIPE_STAGES(PIPE),
    .PIPE_MASK(MASK)
  ) i_dut (
    .clk(clk),
    .reset(reset),
    .idata(idata),
    .ikeep(ikeep),
    .odata(odata),
    .ovalid(ovalid));

  integer   seed = SEED;
  integer   idx  = 0;          // next input sample index
  reg [W-1:0] q [0:QN-1];      // kept sample indices, in order
  integer   qw   = 0;
  integer   qr   = 0;
  integer   nout = 0;
  integer   j, k, phase, rate;

  // Scoreboard on the output.
  always @(posedge clk) begin
    if (!reset && ovalid) begin
      for (k = 0; k < OUT_SLOTS; k = k + 1) begin
        if (qr >= qw) begin
          fail = 1'b1;
          $display("FAIL %0d->%0d: output lane %0d with no kept sample pending", IN_SLOTS, OUT_SLOTS, k);
        end else if (odata[k*W +: W] !== q[qr % QN]) begin
          fail = 1'b1;
          $display("FAIL %0d->%0d: word %0d lane %0d expected %04x got %04x",
                   IN_SLOTS, OUT_SLOTS, nout, k, q[qr % QN], odata[k*W +: W]);
        end
        qr = qr + 1;
      end
      nout = nout + 1;
    end
  end

  initial begin
    repeat (4) @(posedge clk);
    @(negedge clk) reset = 1'b0;
    // Phase 0 walks every keep pattern, then random keeps at falling rates:
    // rate is the percentage of samples that are kept.
    for (phase = 0; phase < 5; phase = phase + 1) begin
      rate = (phase == 1) ? 100 : (phase == 2) ? 70 : (phase == 3) ? 30 : 5;
      for (j = 0; j < 4000; j = j + 1) begin
        @(negedge clk);
        for (k = 0; k < IN_SLOTS; k = k + 1) begin
          idata[k*W +: W] = idx;
          if (phase == 0) ikeep[k] = (j >> k) & 1;
          else            ikeep[k] = (($random(seed) & 32'h7fffffff) % 100) < rate;
          if (ikeep[k]) begin
            q[qw % QN] = idx;
            qw = qw + 1;
          end
          idx = idx + 1;
        end
      end
    end
    @(negedge clk) ikeep = 'd0;
    repeat (8) @(posedge clk);
    if ((qw - qr) >= OUT_SLOTS || (qw - qr) < 0) begin
      fail = 1'b1;
      $display("FAIL %0d->%0d: %0d kept samples were not delivered", IN_SLOTS, OUT_SLOTS, qw - qr);
    end
    $display("%0d->%0d: %0d samples kept, %0d words checked, %0d left in the buffer, %0s",
             IN_SLOTS, OUT_SLOTS, qw, nout, qw - qr, fail ? "FAIL" : "ok");
    done = 1'b1;
  end

endmodule
