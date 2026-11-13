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

// ad_dcfilter, self-checking:
//   1. dcfilt_enb = 0, and dcfilt_enb = 1 with a coefficient of 0: data_out =
//      data + dcfilt_offset and valid_out = valid, both 3 clock cycles later,
//      also with gaps in valid.
//   2. dcfilt_enb = 1: a sine on a DC bias; data_out never has x or z, after
//      settling its mean is about 0 and its peak to peak is the input one.
//   3. dcfilt_enb = 1, the DC bias steps: the filter settles again.

module ad_dcfilter_tb;

  localparam LATENCY  = 3;
  localparam SETTLE   = 32768;
  localparam MEASURE  = 4096;
  localparam AMPL     = 2000;
  localparam MEAN_TOL = 50;
  localparam PKPK_TOL = 400;

  reg               clk = 1'b0;
  reg               valid = 1'b0;
  reg  signed [15:0] data = 16'sd0;
  reg               dcfilt_enb = 1'b0;
  reg        [15:0] dcfilt_coeff = 16'h0400;
  reg        [15:0] dcfilt_offset = 16'h0000;

  wire              valid_out;
  wire signed [15:0] data_out;

  reg               valid_exp [0:LATENCY-1];
  reg        [15:0] data_exp [0:LATENCY-1];

  reg  signed [15:0] sine_lut [0:15];
  reg  signed [15:0] dc_bias = 16'sd3000;
  reg               check_x = 1'b0;
  integer           phase = 0;
  integer           n;
  integer           k;
  integer           seed = 1;
  integer           sum;
  integer           cnt;
  integer           max_out;
  integer           min_out;

  always #5 clk = ~clk;

  ad_dcfilter #(
    .DISABLE (0)
  ) dut (
    .clk (clk),
    .valid (valid),
    .data (data),
    .valid_out (valid_out),
    .data_out (data_out),
    .dcfilt_enb (dcfilt_enb),
    .dcfilt_coeff (dcfilt_coeff),
    .dcfilt_offset (dcfilt_offset));

  initial begin
    sine_lut[ 0] =  16'sd0;    sine_lut[ 1] =  16'sd765;
    sine_lut[ 2] =  16'sd1414; sine_lut[ 3] =  16'sd1848;
    sine_lut[ 4] =  16'sd2000; sine_lut[ 5] =  16'sd1848;
    sine_lut[ 6] =  16'sd1414; sine_lut[ 7] =  16'sd765;
    sine_lut[ 8] =  16'sd0;    sine_lut[ 9] = -16'sd765;
    sine_lut[10] = -16'sd1414; sine_lut[11] = -16'sd1848;
    sine_lut[12] = -16'sd2000; sine_lut[13] = -16'sd1848;
    sine_lut[14] = -16'sd1414; sine_lut[15] = -16'sd765;
  end

  // no x or z on the outputs once the filter runs
  always @(negedge clk) begin
    if (check_x && ((^data_out === 1'bx) || (valid_out !== 1'b1)))
      $fatal(1, "enb=1: valid_out %b data_out %h at %0t", valid_out, data_out, $time);
  end

  // sine on dc_bias, a new sample each cycle
  task sine_sample;
    begin
      @(negedge clk);
      valid = 1'b1;
      data  = sine_lut[phase] + dc_bias;
      phase = (phase + 1) % 16;
    end
  endtask

  // mean and peak to peak of data_out over MEASURE cycles
  task measure;
    input [8*16-1:0] name;
    begin
      sum = 0;
      cnt = 0;
      max_out = -32768;
      min_out = 32767;
      for (n = 0; n < MEASURE; n = n + 1) begin
        sine_sample;
        sum = sum + data_out;
        cnt = cnt + 1;
        if (data_out > max_out) max_out = data_out;
        if (data_out < min_out) min_out = data_out;
      end
      $display("[TB] %0s: mean %0d, min %0d, max %0d, pkpk %0d (input pkpk %0d)",
        name, sum / cnt, min_out, max_out, max_out - min_out, 2 * AMPL);
      if ((sum / cnt > MEAN_TOL) || (sum / cnt < -MEAN_TOL))
        $fatal(1, "%0s: mean %0d, expected 0 +/- %0d", name, sum / cnt, MEAN_TOL);
      if ((max_out - min_out > 2 * AMPL + PKPK_TOL) || (max_out - min_out < 2 * AMPL - PKPK_TOL))
        $fatal(1, "%0s: pkpk %0d, expected %0d +/- %0d", name, max_out - min_out, 2 * AMPL, PKPK_TOL);
    end
  endtask

  // random data and valid: data_out = data + dcfilt_offset, LATENCY cycles later
  task exact_delay;
    begin
      for (k = 0; k < LATENCY; k = k + 1) begin
        valid_exp[k] = 1'b0;
        data_exp[k] = 16'd0;
      end
      for (n = 0; n < 2000; n = n + 1) begin
        @(negedge clk);
        if (n >= LATENCY) begin
          if (valid_out !== valid_exp[LATENCY-1])
            $fatal(1, "enb=%b: valid_out %b, expected %b (cycle %0d)", dcfilt_enb, valid_out, valid_exp[LATENCY-1], n);
          if (valid_out && (data_out !== data_exp[LATENCY-1]))
            $fatal(1, "enb=%b: data_out %h, expected %h (cycle %0d)", dcfilt_enb, data_out, data_exp[LATENCY-1], n);
        end
        for (k = LATENCY - 1; k > 0; k = k - 1) begin
          valid_exp[k] = valid_exp[k-1];
          data_exp[k] = data_exp[k-1];
        end
        valid = $random(seed);
        data = $random(seed);
        valid_exp[0] = valid;
        data_exp[0] = data + dcfilt_offset;
      end
      $display("[TB] enb=%b coeff=%h: 2000 cycles, data_out = data + offset, latency %0d",
        dcfilt_enb, dcfilt_coeff, LATENCY);
    end
  endtask

  initial begin

    // 1. bypass: exact data + offset, latency 3, random valid

    dcfilt_enb = 1'b0;
    dcfilt_offset = 16'h0123;
    repeat (LATENCY + 2) @(posedge clk);
    exact_delay;

    // filter on with coefficient 0: the estimate stays 0, the same latency

    dcfilt_coeff = 16'h0000;
    repeat (2) @(posedge clk);
    dcfilt_enb = 1'b1;
    repeat (LATENCY + 2) @(posedge clk);
    exact_delay;
    dcfilt_enb = 1'b0;
    dcfilt_coeff = 16'h0400;

    // 2. filter on, DC bias 3000

    dcfilt_offset = 16'h0000;
    dcfilt_enb = 1'b1;
    repeat (LATENCY + 1) sine_sample;
    check_x = 1'b1;
    for (n = 0; n < SETTLE; n = n + 1)
      sine_sample;
    measure("enb=1 dc 3000");

    // 3. DC bias steps to -2000

    dc_bias = -16'sd2000;
    for (n = 0; n < SETTLE; n = n + 1)
      sine_sample;
    measure("enb=1 dc -2000");

    $display("[TB] ad_dcfilter: PASS");
    $finish;
  end

endmodule
