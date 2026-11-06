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

// ad_sample_join_fifo test.
//
// Two channels run on clocks of the same period and a different phase, and
// deliver words with the same gap pattern, one channel a few cycles behind
// the other. Word n carries n in every half, tagged with the channel and the
// half. The clocks stop while sync_n is low, as the BUFR divided clocks do.
// A single channel instance takes channel 0 alone.
//
// Checked: the pairs leave in order from word 0 after every sync, with the
// same n on both channels, whatever the lag and phase between the channels;
// the single channel words leave in order from word 0 as well. The channel
// enables reach out_clk within a few cycles, and every out_overflow pulse
// reaches both channel clocks. With channel 1 stopped, the full FIFO of
// channel 0 pulses overflow 0 only, with OVERFLOW_XFER_REQ only while
// xfer_req is high.

`timescale 1ns/100ps

module ad_sample_join_fifo_tb;

  localparam DW     = 32;
  localparam PERIOD = 10.0;

  reg         clk_0_raw = 1'b0;
  reg         clk_1_raw = 1'b0;
  reg         sync_n    = 1'b0;
  reg  [7:0]  lag_0     = 8'd0;
  reg  [7:0]  lag       = 8'd3;
  real        phase     = 3.3;

  wire        clk_0 = clk_0_raw & sync_n;
  wire        clk_1 = clk_1_raw & sync_n;

  reg  [31:0] t_0 = 0;
  reg  [31:0] t_1 = 0;
  reg  [11:0] n_0 = 0;
  reg  [11:0] n_1 = 0;
  reg         valid_0 = 1'b0;
  reg         valid_1 = 1'b0;
  reg  [DW-1:0] data_0 = 'd0;
  reg  [DW-1:0] data_1 = 'd0;

  wire          out_reset;
  wire          out_valid;
  wire [DW-1:0] out_data_0;
  wire [DW-1:0] out_data_1;

  integer errors = 0;
  integer pairs  = 0;
  reg  [11:0] exp_n = 0;

  always #(PERIOD/2) clk_0_raw = ~clk_0_raw;
  initial begin
    #(phase);
    forever #(PERIOD/2) clk_1_raw = ~clk_1_raw;
  end

  // the same gap pattern on both channels, 3 words out of 5 cycles
  function gap_ok(input [31:0] t);
    gap_ok = ((t * 7) % 5) < 3;
  endfunction

  // word n of a channel: {tag_hi, n}, {tag_lo, n}
  function [DW-1:0] word(input [3:0] tag_hi, input [3:0] tag_lo, input [11:0] n);
    word = {tag_hi, n, tag_lo, n};
  endfunction

  always @(posedge clk_0 or negedge sync_n) begin
    if (~sync_n) begin
      t_0 <= 0;
      n_0 <= 0;
      valid_0 <= 1'b0;
    end else begin
      t_0 <= t_0 + 1;
      valid_0 <= (t_0 >= 8 + lag_0) && gap_ok(t_0 - lag_0);
      if ((t_0 >= 8 + lag_0) && gap_ok(t_0 - lag_0)) begin
        data_0 <= word(4'h1, 4'h0, n_0);
        n_0 <= n_0 + 1;
      end
    end
  end

  always @(posedge clk_1 or negedge sync_n) begin
    if (~sync_n) begin
      t_1 <= 0;
      n_1 <= 0;
      valid_1 <= 1'b0;
    end else begin
      t_1 <= t_1 + 1;
      valid_1 <= (t_1 >= 8 + lag) && gap_ok(t_1 - lag);
      if ((t_1 >= 8 + lag) && gap_ok(t_1 - lag)) begin
        data_1 <= word(4'h3, 4'h2, n_1);
        n_1 <= n_1 + 1;
      end
    end
  end

  // enables toggle on their own clocks, overflow pulses on out_clk
  reg           en_0 = 1'b0;
  reg           en_1 = 1'b0;
  reg  [5:0]    ec_0 = 0;
  reg  [5:0]    ec_1 = 0;
  reg           ovf = 1'b0;
  reg  [5:0]    oc = 0;
  reg  [3:0]    en_bad = 0;
  wire [1:0]    out_enable;
  wire [1:0]    overflow;
  integer       ovf_sent = 0;
  integer       ovf_got_0 = 0;
  integer       ovf_got_1 = 0;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(2),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4)
  ) i_dut (
    .async_resetn(sync_n),
    .xfer_req(1'b0),
    .clk({clk_1, clk_0}),
    .reset(2'b00),
    .valid({valid_1, valid_0}),
    .data({data_1, data_0}),
    .enable({en_1, en_0}),
    .overflow(overflow),
    .out_clk(clk_0),
    .out_reset(out_reset),
    .out_valid(out_valid),
    .out_data({out_data_1, out_data_0}),
    .out_enable(out_enable),
    .out_overflow(ovf));

  always @(posedge clk_0) begin
    ec_0 <= (ec_0 == 36) ? 0 : ec_0 + 1;
    if (ec_0 == 36) en_0 <= ~en_0;
    oc  <= (oc == 49) ? 0 : oc + 1;
    ovf <= (oc == 0);
    if (ovf) ovf_sent = ovf_sent + 1;
    if (overflow[0]) ovf_got_0 = ovf_got_0 + 1;
    en_bad <= (out_enable != {en_1, en_0}) ? en_bad + 1 : 0;
    if (en_bad == 6) begin
      errors = errors + 1;
      if (errors <= 10)
        $display("ERROR %0t: out_enable %b enable %b", $time, out_enable, {en_1, en_0});
    end
  end

  always @(posedge clk_1) begin
    ec_1 <= (ec_1 == 40) ? 0 : ec_1 + 1;
    if (ec_1 == 40) en_1 <= ~en_1;
    if (overflow[1]) ovf_got_1 = ovf_got_1 + 1;
  end

  wire          out_valid_s;
  wire [DW-1:0] out_data_s;
  reg  [11:0]   exp_s = 0;
  integer       words_s = 0;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(1),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4)
  ) i_dut_single (
    .async_resetn(sync_n),
    .xfer_req(1'b0),
    .clk(clk_0),
    .reset(1'b0),
    .valid(valid_0),
    .data(data_0),
    .out_clk(clk_1),
    .out_reset(),
    .out_valid(out_valid_s),
    .out_data(out_data_s));

  always @(posedge clk_1 or negedge sync_n) begin
    if (~sync_n) begin
      exp_s <= 0;
    end else if (out_valid_s) begin
      words_s <= words_s + 1;
      if (out_data_s !== word(4'h1, 4'h0, exp_s)) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("ERROR %0t: single n %0d got %h expected %h",
                   $time, exp_s, out_data_s, word(4'h1, 4'h0, exp_s));
      end
      exp_s <= exp_s + 1;
    end
  end

  wire [DW-1:0] e_0   = word(4'h1, 4'h0, exp_n);
  wire [DW-1:0] e_1   = word(4'h3, 4'h2, exp_n);

  // xfer_req on 120 of 160 cycles: no output without it, and within one
  // request the pairs carry the same n on both channels, one after another
  reg  [7:0]    rq_cnt = 0;
  reg           xfer_req = 1'b0;
  reg           req_d1 = 1'b0;
  reg           req_d2 = 1'b0;
  reg           have_last = 1'b0;
  reg  [11:0]   last_n = 0;
  integer       words_r = 0;
  wire          out_valid_r;
  wire [DW-1:0] out_data_r_0;
  wire [DW-1:0] out_data_r_1;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(2),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4),
    .XFER_REQ_ENABLE(1)
  ) i_dut_req (
    .async_resetn(sync_n),
    .xfer_req(xfer_req),
    .clk({clk_1, clk_0}),
    .reset(2'b00),
    .valid({valid_1, valid_0}),
    .data({data_1, data_0}),
    .out_clk(clk_0),
    .out_reset(),
    .out_valid(out_valid_r),
    .out_data({out_data_r_1, out_data_r_0}));

  always @(posedge clk_0) begin
    rq_cnt   <= (rq_cnt == 159) ? 0 : rq_cnt + 1;
    xfer_req <= (rq_cnt < 120);
    req_d1   <= xfer_req;
    req_d2   <= req_d1;
    if (~req_d2) begin
      have_last <= 1'b0;
    end
    if (out_valid_r) begin
      words_r <= words_r + 1;
      if (~req_d2 ||
          (out_data_r_0 !== word(4'h1, 4'h0, out_data_r_0[11:0])) ||
          (out_data_r_1 !== word(4'h3, 4'h2, out_data_r_0[11:0])) ||
          (have_last && (out_data_r_0[11:0] != last_n + 1'b1))) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("ERROR %0t: xfer_req %b last %0d got %h %h",
                   $time, req_d2, last_n, out_data_r_0, out_data_r_1);
      end
      last_n    <= out_data_r_0[11:0];
      have_last <= req_d2;
    end
  end

  // the counting restarts from 0 after sync_n, while clk_0 is stopped
  always @(negedge sync_n) have_last <= 1'b0;

  always @(posedge clk_0 or negedge sync_n) begin
    if (~sync_n) begin
      exp_n <= 0;
    end else if (out_valid) begin
      pairs <= pairs + 1;
      if ((out_data_0 !== e_0) || (out_data_1 !== e_1)) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("ERROR %0t: n %0d got %h %h expected %h %h",
                   $time, exp_n, out_data_0, out_data_1, e_0, e_1);
      end
      exp_n <= exp_n + 1;
    end
  end

  // channel 1 never delivers, so channel 0 fills its FIFO and drops words
  wire [1:0]    overflow_l;
  integer       ovf_l0 = 0;
  integer       ovf_l1 = 0;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(2),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4)
  ) i_dut_local (
    .async_resetn(sync_n),
    .xfer_req(1'b0),
    .clk({clk_1, clk_0}),
    .reset(2'b00),
    .valid({1'b0, valid_0}),
    .data({data_1, data_0}),
    .enable(2'b11),
    .overflow(overflow_l),
    .out_clk(clk_0),
    .out_reset(),
    .out_valid(),
    .out_data(),
    .out_enable(),
    .out_overflow(1'b0));

  always @(posedge clk_0) if (overflow_l[0]) ovf_l0 = ovf_l0 + 1;
  always @(posedge clk_1) if (overflow_l[1]) ovf_l1 = ovf_l1 + 1;

  // the same with OVERFLOW_XFER_REQ: silent while xfer_req is low (q0), counted while high (q1)
  wire [1:0]    overflow_q0;
  wire [1:0]    overflow_q1;
  integer       ovf_q0 = 0;
  integer       ovf_q1 = 0;

  ad_sample_join_fifo #(
    .NUM_CHANNELS(2),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4),
    .XFER_REQ_ENABLE(1),
    .OVERFLOW_XFER_REQ(1)
  ) i_dut_local_q0 (
    .async_resetn(sync_n),
    .xfer_req(1'b0),
    .clk({clk_1, clk_0}),
    .reset(2'b00),
    .valid({1'b0, valid_0}),
    .data({data_1, data_0}),
    .enable(2'b11),
    .overflow(overflow_q0),
    .out_clk(clk_0),
    .out_reset(),
    .out_valid(),
    .out_data(),
    .out_enable(),
    .out_overflow(1'b0));

  ad_sample_join_fifo #(
    .NUM_CHANNELS(2),
    .DATA_WIDTH(DW),
    .ADDRESS_WIDTH(4),
    .XFER_REQ_ENABLE(1),
    .OVERFLOW_XFER_REQ(1)
  ) i_dut_local_q1 (
    .async_resetn(sync_n),
    .xfer_req(1'b1),
    .clk({clk_1, clk_0}),
    .reset(2'b00),
    .valid({1'b0, valid_0}),
    .data({data_1, data_0}),
    .enable(2'b11),
    .overflow(overflow_q1),
    .out_clk(clk_0),
    .out_reset(),
    .out_valid(),
    .out_data(),
    .out_enable(),
    .out_overflow(1'b0));

  always @(posedge clk_0) begin
    if (overflow_q0[0]) ovf_q0 = ovf_q0 + 1;
    if (overflow_q1[0]) ovf_q1 = ovf_q1 + 1;
  end

  task run_case(input [7:0] l0, input [7:0] l, input integer words);
    integer start;
    integer start_s;
    begin
      sync_n = 1'b0;
      #(7*PERIOD);
      lag_0 = l0;
      lag  = l;
      #(3*PERIOD + 1.7);
      sync_n = 1'b1;
      start = pairs;
      start_s = words_s;
      wait (pairs - start >= words && words_s - start_s >= words);
      $display("case lag %0d/%0d: %0d pairs, %0d single", l0, l,
               pairs - start, words_s - start_s);
      // at most the pulse in flight is missing
      if ((ovf_sent - ovf_got_0 > 1) || (ovf_sent - ovf_got_1 > 1) ||
          (ovf_got_0 > ovf_sent) || (ovf_got_1 > ovf_sent)) begin
        errors = errors + 1;
        $display("ERROR: overflow sent %0d got %0d %0d", ovf_sent, ovf_got_0, ovf_got_1);
      end
      ovf_sent  = ovf_sent - ovf_got_0;
      ovf_got_1 = ovf_got_1 - ovf_got_0;
      ovf_got_0 = 0;
    end
  endtask

  initial begin
    run_case(8'd0, 8'd3,  200);
    run_case(8'd0, 8'd0,  200);
    run_case(8'd0, 8'd12, 200);
    run_case(8'd9, 8'd0,  200);
    run_case(8'd0, 8'd1,  200);
    run_case(8'd4, 8'd5,  200);
    if (words_r == 0) begin
      errors = errors + 1;
      $display("ERROR: no output with xfer_req");
    end
    $display("xfer_req: %0d pairs", words_r);
    $display("local overflow: %0d on channel 0, %0d on channel 1", ovf_l0, ovf_l1);
    if (ovf_l0 == 0 || ovf_l1 != 0) begin
      errors = errors + 1;
      $display("ERROR: local overflow %0d %0d", ovf_l0, ovf_l1);
    end
    $display("local overflow with OVERFLOW_XFER_REQ: %0d with xfer_req low, %0d high", ovf_q0, ovf_q1);
    if (ovf_q0 != 0 || ovf_q1 == 0) begin
      errors = errors + 1;
      $display("ERROR: local overflow with OVERFLOW_XFER_REQ %0d %0d", ovf_q0, ovf_q1);
    end
    if (errors == 0)
      $display("SUCCESS");
    else
      $display("FAILED %0d errors", errors);
    $finish;
  end

  initial begin
    #2000000;
    $display("FAILED timeout");
    $finish;
  end

endmodule
