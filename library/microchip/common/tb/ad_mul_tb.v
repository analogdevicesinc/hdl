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

`timescale 1ns/1ps

// ad_mul: data_p = data_a * data_b (signed) and ddata_out = ddata_in, both with
// a latency of 3 clock cycles, as the Xilinx (MULT_MACRO LATENCY 3) and Intel
// (lpm_pipeline 3) ones. Random and full-scale operands each cycle, for the
// 17 x 17 width of the common modules and a wider 25 x 18 one.

module ad_mul_tb;

  localparam integer LATENCY = 3;
  localparam integer SAMPLES = 4096;

  reg clk = 1'b0;
  always #5 clk = ~clk;

  // 17 x 17, ddata 16

  reg  [16:0] a0 = 'd0;
  reg  [16:0] b0 = 'd0;
  reg  [15:0] d0 = 'd0;
  wire [33:0] p0;
  wire [15:0] dout0;

  ad_mul #(
    .A_DATA_WIDTH (17),
    .B_DATA_WIDTH (17),
    .DELAY_DATA_WIDTH (16)
  ) i_mul_17x17 (
    .clk (clk),
    .data_a (a0),
    .data_b (b0),
    .data_p (p0),
    .ddata_in (d0),
    .ddata_out (dout0));

  // 25 x 18, ddata 8

  reg  [24:0] a1 = 'd0;
  reg  [17:0] b1 = 'd0;
  reg  [ 7:0] d1 = 'd0;
  wire [42:0] p1;
  wire [ 7:0] dout1;

  ad_mul #(
    .A_DATA_WIDTH (25),
    .B_DATA_WIDTH (18),
    .DELAY_DATA_WIDTH (8)
  ) i_mul_25x18 (
    .clk (clk),
    .data_a (a1),
    .data_b (b1),
    .data_p (p1),
    .ddata_in (d1),
    .ddata_out (dout1));

  // expected outputs, LATENCY cycles back

  reg [33:0] p0_exp [0:LATENCY-1];
  reg [15:0] d0_exp [0:LATENCY-1];
  reg [42:0] p1_exp [0:LATENCY-1];
  reg [ 7:0] d1_exp [0:LATENCY-1];

  integer n;
  integer k;
  integer seed = 1;

  // full-scale operands first, then random ones
  task next_operands;
    begin
      case (n)
        0: begin a0 = 17'h0ffff; b0 = 17'h0ffff; a1 = 25'h0ffffff; b1 = 18'h1ffff; end
        1: begin a0 = 17'h10000; b0 = 17'h10000; a1 = 25'h1000000; b1 = 18'h20000; end
        2: begin a0 = 17'h10000; b0 = 17'h0ffff; a1 = 25'h1000000; b1 = 18'h1ffff; end
        3: begin a0 = 17'h1ffff; b0 = 17'h1ffff; a1 = 25'h1ffffff; b1 = 18'h3ffff; end
        default: begin
          a0 = $random(seed); b0 = $random(seed);
          a1 = $random(seed); b1 = $random(seed);
        end
      endcase
      d0 = n;
      d1 = n;
    end
  endtask

  initial begin
    for (k = 0; k < LATENCY; k = k + 1) begin
      p0_exp[k] = 'd0; d0_exp[k] = 'd0;
      p1_exp[k] = 'd0; d1_exp[k] = 'd0;
    end
    repeat (LATENCY + 2) @(posedge clk);

    for (n = 0; n < SAMPLES + LATENCY; n = n + 1) begin
      @(negedge clk);
      // the outputs of the operands of LATENCY cycles before
      if (n >= LATENCY) begin
        if (p0 !== p0_exp[LATENCY-1])
          $fatal(1, "17x17: data_p %h, expected %h (sample %0d)", p0, p0_exp[LATENCY-1], n - LATENCY);
        if (dout0 !== d0_exp[LATENCY-1])
          $fatal(1, "17x17: ddata_out %0d, expected %0d (not aligned with data_p)", dout0, d0_exp[LATENCY-1]);
        if (p1 !== p1_exp[LATENCY-1])
          $fatal(1, "25x18: data_p %h, expected %h (sample %0d)", p1, p1_exp[LATENCY-1], n - LATENCY);
        if (dout1 !== d1_exp[LATENCY-1])
          $fatal(1, "25x18: ddata_out %0d, expected %0d (not aligned with data_p)", dout1, d1_exp[LATENCY-1]);
      end
      for (k = LATENCY - 1; k > 0; k = k - 1) begin
        p0_exp[k] = p0_exp[k-1]; d0_exp[k] = d0_exp[k-1];
        p1_exp[k] = p1_exp[k-1]; d1_exp[k] = d1_exp[k-1];
      end
      next_operands;
      p0_exp[0] = $signed(a0) * $signed(b0);
      d0_exp[0] = d0;
      p1_exp[0] = $signed(a1) * $signed(b1);
      d1_exp[0] = d1;
    end

    $display("[TB] ad_mul: %0d products and ddata of both widths match with latency %0d", SAMPLES, LATENCY);
    $finish;
  end

endmodule
