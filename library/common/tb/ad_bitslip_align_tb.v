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


// ad_bitslip_align: a random bit stream with random input gaps.
//
// 1. For every start offset p the output must be the input stream from bit p
//    on, bit 0 being the first bit of the first valid word after reset.
// 2. Random changes of shift while running, in both directions: from the
//    second valid word after the change on, output word k must start at
//    stream bit k*I_W + shift. Only the word in the output register when
//    shift changes may still have the previous offset.

`timescale 1ns/100ps

module ad_bitslip_align_tb;

  parameter VCD_FILE = "ad_bitslip_align_tb.vcd";

  `define TIMEOUT 20000000
  `include "tb_base.v"

  // Valid input words, counting the one of the change cycle, before the check
  // resumes. The checker samples the output one cycle after the input, so the
  // check must skip the cycle that meets the word of the previous offset still
  // in the output register; 2 is the exact minimum.
  `ifndef CHANGE_WAIT
  `define CHANGE_WAIT 2
  `endif

  wire [3:0] c_fail;
  wire [3:0] c_done;

  ad_bitslip_align_case #(.I_W(8),  .SEED(1)) i_c0 (.clk(clk), .fail(c_fail[0]), .done(c_done[0]));
  ad_bitslip_align_case #(.I_W(16), .SEED(2)) i_c1 (.clk(clk), .fail(c_fail[1]), .done(c_done[1]));
  ad_bitslip_align_case #(.I_W(4),  .SEED(3)) i_c2 (.clk(clk), .fail(c_fail[2]), .done(c_done[2]));
  ad_bitslip_align_case #(.ASYNC(1), .I_W(8), .SEED(4)) i_c3 (.clk(clk), .fail(c_fail[3]), .done(c_done[3]));

  initial begin
    wait (&c_done);
    repeat (4) @(posedge clk);
    failed = |c_fail;
    if (failed == 1'b0) $display("SUCCESS");
    else                $display("FAILED");
    $finish;
  end

endmodule

module ad_bitslip_align_case #(
  parameter ASYNC = 0,
  parameter I_W  = 8,
  parameter SEED = 1
) (
  input      clk,
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  localparam NB = 1 << 16;

  reg            reset  = 1'b1;
  reg  [I_W-1:0] idata  = 'd0;
  reg            ivalid = 1'b0;
  reg  [4:0]     shift  = 5'd0;
  wire [I_W-1:0] odata;
  wire           ovalid;

  ad_bitslip_align #(
    .ASYNC_RESET(ASYNC),
    .I_W(I_W),
    .UNIT_W(1),
    .SHIFT_W(5)
  ) i_dut (
    .clk(clk),
    .reset(reset),
    .idata(idata),
    .ivalid(ivalid),
    .shift(shift),
    .odata(odata),
    .ovalid(ovalid));

  integer seed = SEED;
  reg     stream [0:NB-1];   // input bits in time order since reset
  integer nin  = 0;          // input bits sent
  integer nall = 0;          // output words since reset
  integer nchk = 0;
  integer nerr = 0;
  integer i, b, p, t, c;
  reg     ok;

  // Output word k must start at stream bit k*I_W + shift. Checked only while
  // chk_en, i.e. not right after a change.
  reg     chk_en = 1'b0;

  always @(posedge clk) begin
    if (reset) begin
      nall = 0;
    end else if (ovalid) begin
      if (chk_en) begin
        ok = 1'b1;
        for (b = 0; b < I_W; b = b + 1)
          if (odata[I_W-1-b] !== stream[(nall*I_W + shift + b) % NB]) ok = 1'b0;
        if (!ok) begin
          nerr = nerr + 1;
          fail = 1'b1;
          if (nerr < 5) $display("FAIL I_W %0d: output word %0d does not match the stream at bit %0d",
                                 I_W, nall, nall*I_W + shift);
        end
        nchk = nchk + 1;
      end
      nall = nall + 1;
    end
  end

  // one random input cycle, valid or a gap
  task drive;
    begin
      ivalid = (($random(seed) & 3) != 0);
      if (ivalid) begin
        for (i = 0; i < I_W; i = i + 1) begin
          idata[I_W-1-i]    = $random(seed);
          stream[nin % NB]  = idata[I_W-1-i];
          nin = nin + 1;
        end
      end
    end
  endtask

  task send;
    input integer n;
    integer k;
    begin
      for (k = 0; k < n; k = k + 1) begin
        @(negedge clk);
        drive;
      end
    end
  endtask

  initial begin
    // 1. every start offset
    for (p = 0; p <= 31; p = p + 1) begin
      @(negedge clk);
      reset   = 1'b1;
      ivalid  = 1'b0;
      shift   = p;
      chk_en  = 1'b0;
      @(negedge clk);
      @(negedge clk) reset = 1'b0;
      nin     = 0;
      chk_en  = 1'b1;
      send(200);
      @(negedge clk) ivalid = 1'b0;
      repeat (4) @(posedge clk);
      chk_en = 1'b0;
    end
    $display("I_W %0d: start offsets 0..31, %0s", I_W, fail ? "FAIL" : "ok");

    // 2. random changes while running, forward and backward
    @(negedge clk);
    reset = 1'b1;
    shift = 5'd0;
    @(negedge clk);
    @(negedge clk) reset = 1'b0;
    nin    = 0;
    chk_en = 1'b1;
    send(50);
    for (t = 0; t < 200; t = t + 1) begin
      // the change comes with a random input cycle, valid or a gap
      chk_en = 1'b0;
      @(negedge clk) begin
        shift = $random(seed);
        drive;
      end
      c = ivalid ? 1 : 0;
      while (c < `CHANGE_WAIT) begin
        send(1);
        if (ivalid) c = c + 1;
      end
      chk_en = 1'b1;
      send(20);
    end
    @(negedge clk) ivalid = 1'b0;
    repeat (4) @(posedge clk);
    $display("I_W %0d: 200 run time changes, %0d output words checked, %0s", I_W, nchk, fail ? "FAIL" : "ok");

    done = 1'b1;
  end

endmodule
