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
//
// One comparator pair of the AD7134 frame-slip detector.
//
// Watches two channels of the 256-bit sample beat and reports when their
// relative alignment changes by a whole ODR period.
//
// The two dies see the same input tone. Writing a = A*sin(wn) and
// b = A*sin(wn + phi), the difference is
//
//     d[n] = a[n] - b[n] = -2*A*sin(phi/2)*cos(wn + phi/2)
//
// which is a sinusoid whose AMPLITUDE encodes the misalignment. A slip of k
// whole sample periods replaces phi with phi + k*w, so the envelope of d jumps.
// At 19999 Hz / 1.3333 MSPS with a +7.9 ns residual, the aligned envelope is
// ~8.3k LSB and a k=1 slip gives ~790k LSB - a ~95x separation.
//
// Detecting on the ENVELOPE rather than on an instantaneous step matters: the
// step d[n]-d[n-1] is itself sinusoidal in n, so a slip landing near a peak of
// the input tone produces a near-zero step and would be missed. The envelope is
// independent of where in the tone the slip lands.
//
// Detection fires on the CHANGE in envelope between consecutive windows, not on
// an absolute level. That makes it immune to whatever baseline the particular
// channel pair happens to have (gain and offset mismatch), and it fires in both
// directions, which the observed +/-1, +/-3 zero-mean random walk needs.
//
// ***************************************************************************
`timescale 1ns/100ps

module ad7134_slip_detect_pair #(
  parameter integer DC_SHIFT = 12
) (
  input                   clk,
  input                   resetn,

  // sample stream snoop (not in the data path)

  input                   beat,
  input       [255:0]     tdata,
  input                   restart,

  // configuration

  input                   detect_en,
  input                   dc_bypass,
  input       [ 2:0]      sel_a,
  input       [ 2:0]      sel_b,
  input       [ 4:0]      msb_pos,
  input       [ 3:0]      win_log2,
  input       [31:0]      threshold,
  input                   clr_env_max,

  // results

  (* mark_debug = "true" *) output reg  [31:0]      env,
  output reg  [31:0]      env_max,
  output reg  [31:0]      corr,
  (* mark_debug = "true" *) output reg              evt,

  // debug taps for the ILA

  output      [23:0]      dbg_ch_a,
  output      [23:0]      dbg_ch_b,
  output      [24:0]      dbg_d
);

  // The leaky integrator holds the mean scaled by 2**DC_SHIFT, so it needs the
  // sample width plus DC_SHIFT plus one guard bit.

  localparam integer MEAN_W = 26 + DC_SHIFT;

  // The datapath is split into six pipeline stages. Beats arrive ~75 clocks
  // apart (1.33 MSPS on a 100 MHz clock) so latency is free, but combinational
  // depth is not: as a single cloud, mux -> variable slice -> subtract -> DC
  // -> accumulate -> compare came to 34 logic levels and missed the 10 ns
  // period by 7.8 ns. Each stage carries the beat strobe forward, so the
  // window count stays exact regardless of the added latency.

  // -------------------------------------------------------------------------
  // Stage 1 - channel extraction
  // -------------------------------------------------------------------------

  // The offload packs channel i at tdata[i*32 +: 32]. Where the 24 payload bits
  // sit inside that word depends on the frame format, so msb_pos is a register
  // field: 23 for a plain 24-bit frame, 31 for 24-bit+CRC (data[31:8]).

  wire [31:0] word_a = tdata[sel_a*32 +: 32];
  wire [31:0] word_b = tdata[sel_b*32 +: 32];

  wire [ 4:0] msb = (msb_pos < 5'd23) ? 5'd23 : msb_pos;

  wire signed [23:0] ch_a_c = word_a[msb -: 24];
  wire signed [23:0] ch_b_c = word_b[msb -: 24];

  (* mark_debug = "true" *) reg signed [23:0] ch_a = 24'd0;
  (* mark_debug = "true" *) reg signed [23:0] ch_b = 24'd0;
  reg               beat_1 = 1'b0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      ch_a   <= 24'd0;
      ch_b   <= 24'd0;
      beat_1 <= 1'b0;
    end else begin
      beat_1 <= beat;
      if (beat == 1'b1) begin
        ch_a <= ch_a_c;
        ch_b <= ch_b_c;
      end
    end
  end

  assign dbg_ch_a = ch_a;
  assign dbg_ch_b = ch_b;

  // -------------------------------------------------------------------------
  // Stage 2 - difference and channel-A derivative
  // -------------------------------------------------------------------------

  reg signed [23:0] ch_a_d1 = 24'd0;
  (* mark_debug = "true" *) reg signed [24:0] d = 25'd0;
  reg signed [24:0] da = 25'd0;
  reg               beat_2 = 1'b0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      ch_a_d1 <= 24'd0;
      d       <= 25'd0;
      da      <= 25'd0;
      beat_2  <= 1'b0;
    end else begin
      beat_2 <= beat_1;
      if (beat_1 == 1'b1) begin
        d       <= ch_a - ch_b;
        da      <= ch_a - ch_a_d1;
        ch_a_d1 <= ch_a;
      end
    end
  end

  assign dbg_d = d;

  // -------------------------------------------------------------------------
  // Stage 3 - DC removal
  // -------------------------------------------------------------------------

  // Offset mismatch between the two channels puts a constant in d. The delta
  // detector below would cancel it anyway, but removing it here makes the ENV
  // register a directly interpretable measure of |k|. The integrator now runs
  // one beat behind d, which is immaterial at a 2**DC_SHIFT time constant.

  reg signed [MEAN_W-1:0] mean_acc = {MEAN_W{1'b0}};

  wire signed [MEAN_W-1:0] mean_full = mean_acc >>> DC_SHIFT;
  wire signed [24:0] mean = mean_full[24:0];

  reg signed [24:0] d_hp = 25'd0;
  reg signed [24:0] da_1 = 25'd0;
  reg               beat_3 = 1'b0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      mean_acc <= {MEAN_W{1'b0}};
      d_hp     <= 25'd0;
      da_1     <= 25'd0;
      beat_3   <= 1'b0;
    end else begin
      beat_3 <= beat_2;
      if (beat_2 == 1'b1) begin
        mean_acc <= mean_acc + d - mean_full;
        d_hp     <= dc_bypass ? d : (d - mean);
        da_1     <= da;
      end
    end
  end

  // -------------------------------------------------------------------------
  // Stage 4 - magnitude and correlation product
  // -------------------------------------------------------------------------

  // sum(d_hp * da) is positive or negative depending on which die is ahead.
  // Both operands are truncated to 18 bits so the product fits a single DSP48;
  // registering the product lands in the DSP's own MREG rather than in fabric.

  wire signed [17:0] da_t = da_1[24:7];
  wire signed [17:0] hp_t = d_hp[24:7];

  reg        [24:0] abs_hp = 25'd0;
  reg signed [35:0] prod = 36'd0;
  reg               beat_4 = 1'b0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      abs_hp <= 25'd0;
      prod   <= 36'd0;
      beat_4 <= 1'b0;
    end else begin
      beat_4 <= beat_3;
      if (beat_3 == 1'b1) begin
        abs_hp <= d_hp[24] ? (~d_hp + 1'b1) : d_hp;
        prod   <= da_t * hp_t;
      end
    end
  end

  // -------------------------------------------------------------------------
  // Stage 5 - window accumulation
  // -------------------------------------------------------------------------

  reg  [31:0] acc = 32'd0;

  wire [32:0] acc_sum  = {1'b0, acc} + {8'd0, abs_hp};
  wire [31:0] acc_next = acc_sum[32] ? 32'hffffffff : acc_sum[31:0];

  reg signed [47:0] corr_acc = 48'd0;

  wire signed [47:0] corr_sum = corr_acc + {{12{prod[35]}}, prod};

  // win_log2 is clamped to 4..10 so the counter and the accumulator cannot be
  // driven into a range they were not sized for.

  wire [ 3:0] win_sel = (win_log2 < 4'd4)  ? 4'd4 :
                        (win_log2 > 4'd10) ? 4'd10 : win_log2;

  wire [ 9:0] win_last = (10'd1 << win_sel) - 10'd1;

  reg  [ 9:0] win_cnt = 10'd0;
  reg  [31:0] env_acc = 32'd0;
  reg signed [47:0] env_corr = 48'd0;
  reg               win_done = 1'b0;

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      acc      <= 32'd0;
      corr_acc <= 48'd0;
      win_cnt  <= 10'd0;
      env_acc  <= 32'd0;
      env_corr <= 48'd0;
      win_done <= 1'b0;
    end else begin
      win_done <= 1'b0;

      if (beat_4 == 1'b1) begin
        if (win_cnt == win_last) begin
          env_acc  <= acc_next;
          env_corr <= corr_sum;
          acc      <= 32'd0;
          corr_acc <= 48'd0;
          win_cnt  <= 10'd0;
          win_done <= 1'b1;
        end else begin
          acc      <= acc_next;
          corr_acc <= corr_sum;
          win_cnt  <= win_cnt + 1'b1;
        end
      end
    end
  end

  // -------------------------------------------------------------------------
  // Stage 6 - detection
  // -------------------------------------------------------------------------

  // Evaluating the threshold a cycle after the window closes keeps the 32-bit
  // accumulate out of the same path as the subtract and the two compares.

  reg  [31:0] env_prev = 32'd0;
  reg  [ 1:0] warmup   = 2'd2;

  wire [31:0] delta = (env_acc > env_prev) ? (env_acc - env_prev) :
                                             (env_prev - env_acc);

  wire hit = detect_en && (warmup == 2'd0) && (delta > threshold);

  wire [31:0] corr_sat = (env_corr > 48'sh0000_7fffffff) ? 32'h7fffffff :
                         (env_corr < -48'sh0000_80000000) ? 32'h80000000 :
                         env_corr[31:0];

  always @(posedge clk) begin
    if (resetn == 1'b0 || restart == 1'b1) begin
      env      <= 32'd0;
      env_prev <= 32'd0;
      corr     <= 32'd0;
      evt      <= 1'b0;
      warmup   <= 2'd2;
    end else begin
      evt <= 1'b0;

      if (win_done == 1'b1) begin
        env      <= env_acc;
        env_prev <= env_acc;
        corr     <= corr_sat;
        evt      <= hit;

        // env_prev is meaningless until two windows have completed, so the
        // first comparisons are suppressed rather than reported as a slip.
        //
        // A slip lands mid-window, so the straddling window sees only part of
        // the amplitude step and the window after it sees the rest. Both clear
        // the threshold. Suppressing one window after a hit lets env_prev
        // re-settle at the new level, so one slip reports as exactly one event
        // and EVENT_COUNT stays directly comparable to the offline
        // cross-correlation count.
        if (hit == 1'b1) begin
          warmup <= 2'd1;
        end else if (warmup != 2'd0) begin
          warmup <= warmup - 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (resetn == 1'b0 || clr_env_max == 1'b1) begin
      env_max <= 32'd0;
    end else if (win_done == 1'b1 && env_acc > env_max) begin
      env_max <= env_acc;
    end
  end

endmodule
