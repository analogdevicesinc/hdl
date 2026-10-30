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


// Logical validation of ad408x_phy at the serial bit level.
//
// The converter is modelled bit by bit: a free running DCO, DDR data on one or two
// lanes and the FILTER_RESULT_RDY output. Every transmitted sample is recorded
// with its index, and a scoreboard matches every adc_valid against that record,
// so a dropped, repeated, misaligned or bit swapped sample is an error. The data
// is random, so every bit position and the sign extension are exercised.
//
// Build configurations, 7 series: both lane counts crossed with all seven non
// zero bit depth enable combinations, both lane counts with every depth and
// EN_FILTER_RDY off, a two lane build with the converter on one lane (lane B
// random), a two lane build whose converter switches to one lane and back
// while running, and both lane counts on a 64 bit output bus. Each instance
// walks its enabled depths by re-syncing the PHY.
//
// Checked per depth:
//   1. The pattern search locks, and the stream after the lock is exactly the
//      transmitted one.
//   2. Bit offset sweep (SWEEP builds): after sync the converter sends L lead
//      ticks before the first sample, for every L from 0 to N-1. Every L must
//      lock and stream correctly, and the found offset must move with L:
//      shift_cnt(L) = shift_cnt(0) + L * bits per tick, modulo N. This walks
//      every offset of the alignment delay line used by the depth.
//   3. Serdes factor and clock ratio: 8 and DCO/4 in both lane modes,
//      whatever depths are built.
//   4. Filter: exactly the first sample of every decimation period, where
//      FILTER_RESULT_RDY falls, reaches the bus, each one, in order. The filter line is
//      skewed FILT_SKEW ticks against the data, late or early.
//
// Not covered: the lane interleave is the same assumption the PHY makes, so a
// mismatch against the real converter cannot be detected here. The DCO rate
// per lane mode is the model's assumption (single lane twice the dual lane
// rate).

`timescale 1ps/1ps

module ad408x_phy_tb;

  parameter VCD_FILE = "ad408x_phy_tb.vcd";

  `define TIMEOUT 2000000000
  `include "../common/tb/tb_base.v"

  // 14 masks on 7 series, the enable mask is the generate index: bit 2 is the
  // 20 bit depth, bit 1 the 16 bit and bit 0 the 14 bit. The builds with every
  // depth sweep the bit offset. The filter skew
  // alternates between late and early.
  // Two more 7 series builds with EN_FILTER_RDY off, without filter support:
  // filter_enable must leave the stream unchanged.
  localparam NUM_CASES = 20;

  wire [NUM_CASES-1:0] case_fail;
  wire [NUM_CASES-1:0] case_done;

  genvar l, m;
  generate
  for (l = 1; l <= 2; l = l + 1) begin : g_lane
    for (m = 1; m <= 7; m = m + 1) begin : g_mask

      ad408x_phy_case #(
        .FPGA_TECH(1),
        .NUM_LANES(l),
        .ENABLE_20BIT((m >> 2) & 1),
        .ENABLE_16BIT((m >> 1) & 1),
        .ENABLE_14BIT(m & 1),
        // Decimation 2 is the minimum and the hardest case: the filter line
        // changes every sample. Longer periods only give more margin.
        .FILT_DECIM(2),
        .FILT_SKEW((m & 1) ? 2 : -2),
        .SWEEP(m == 7),
        .SEED(l*16 + m)
      ) i_case (
        .fail(case_fail[(l-1)*7 + (m-1)]),
        .done(case_done[(l-1)*7 + (m-1)]));

    end

    ad408x_phy_case #(
      .FPGA_TECH(1),
      .NUM_LANES(l),
      .ENABLE_20BIT(1),
      .ENABLE_16BIT(1),
      .ENABLE_14BIT(1),
      .EN_FILTER_RDY(0),
      .FILT_DECIM(2),
      .FILT_SKEW(0),
      .SWEEP(0),
      .SEED(200 + l)
    ) i_case_fab (
      .fail(case_fail[14 + (l-1)]),
      .done(case_done[14 + (l-1)]));

  end
  endgenerate

  // A 2 lane build with the converter on one lane: lane B carries random data,
  // num_lanes stays at its reset value 0.
  ad408x_phy_case #(
    .FPGA_TECH(1),
    .NUM_LANES(2),
    .DEV_LANES(1),
    .ONE_LANE_REG(0),
    .ENABLE_20BIT(1),
    .ENABLE_16BIT(1),
    .ENABLE_14BIT(1),
    .FILT_DECIM(2),
    .FILT_SKEW(2),
    .SWEEP(1),
    .SEED(300)
  ) i_case_1on2 (
    .fail(case_fail[16]),
    .done(case_done[16]));

  // A 2 lane build whose converter switches to one lane and back while running.
  ad408x_phy_case #(
    .FPGA_TECH(1),
    .NUM_LANES(2),
    .ENABLE_20BIT(1),
    .ENABLE_16BIT(1),
    .ENABLE_14BIT(1),
    .FILT_DECIM(2),
    .FILT_SKEW(-2),
    .SWITCH_LANES(1),
    .SEED(400)
  ) i_case_switch (
    .fail(case_fail[17]),
    .done(case_done[17]));

  // 64 bit output bus on both lane counts: two 20 bit or four 16/14 bit
  // samples per word.
  generate
  for (l = 1; l <= 2; l = l + 1) begin : g_wide
    ad408x_phy_case #(
      .FPGA_TECH(1),
      .NUM_LANES(l),
      .DATA_WIDTH(64),
      .ENABLE_20BIT(1),
      .ENABLE_16BIT(1),
      .ENABLE_14BIT(1),
      .FILT_DECIM(2),
      .FILT_SKEW(2),
      .SEED(500 + l)
    ) i_case_wide (
      .fail(case_fail[17 + l]),
      .done(case_done[17 + l]));
  end
  endgenerate

  initial begin
    wait (&case_done);
    repeat (4) @(posedge clk);
    failed = |case_fail;
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

  initial begin
    #(`TIMEOUT - 100000);
    if (!(&case_done)) begin
      failed = 1'b1;
      $display("FAIL: not all %0d build configurations completed before the timeout, done mask %b",
               NUM_CASES, case_done);
    end
  end

endmodule

// One build configuration: converter model, PHY instance and scoreboard.

module ad408x_phy_case #(
  // FPGA_TECHNOLOGY of the device under test: 1 for 7 series, 3 for UltraScale+.
  parameter FPGA_TECH = 1,
  // Lane count of the device under test. 1 or 2.
  parameter NUM_LANES = 1,
  // Lanes the converter sends on; 1 on a 2 lane build drives lane B with
  // random data, which the PHY must ignore.
  parameter DEV_LANES = NUM_LANES,
  // num_lanes register value for one lane: 0 is the reset value, as without a
  // driver write; two lanes always write 2.
  parameter ONE_LANE_REG = 1,
  // 2 lane build only: run all depths on 2 lanes, then on 1, then on 2 again,
  // switching the converter and num_lanes while running.
  parameter SWITCH_LANES = 0,
  // Bit depths built into this instance of the PHY.
  parameter ENABLE_20BIT = 1,
  parameter ENABLE_16BIT = 1,
  parameter ENABLE_14BIT = 1,
  // EN_FILTER_RDY of the device under test.
  parameter EN_FILTER_RDY = 1,
  // Filter decimation. As in Figure 97 of the AD4080 data sheet the filter
  // output falls with the first output word of a new result, stays low for the
  // first FILT_DECIM-1 words and is high for the last one.
  parameter FILT_DECIM = 2,
  // Skew of the filter line against the data in DCO edges: positive delays the
  // filter line, negative delays the data lanes.
  parameter FILT_SKEW = 2,
  // Sweep the lead ticks over a whole sample for every depth.
  parameter SWEEP = 0,
  // Output bus width of the device under test, 0 for the default.
  parameter DATA_WIDTH = 0,
  parameter SEED = 1
) (
  output reg fail = 1'b0,
  output reg done = 1'b0
);

  // Same derivation as the PHY and the project tcl: the bus is only widened to
  // 32 bits because of the 20 bit depth.
  localparam ADC_DATA_WIDTH = (DATA_WIDTH != 0) ? DATA_WIDTH :
    ((ENABLE_20BIT != 0) || ((ENABLE_14BIT != 0) && (NUM_LANES == 2))) ? 32 : 16;

  // A dual lane device sends two bits per DCO edge, so it runs the DCO at half
  // the rate for the same bit rate. The bit stream is gapless.
  // The converter lane mode is a variable, so it can switch while running.
  integer dev_lanes  = DEV_LANES;
  integer dev_req    = DEV_LANES;
  integer dco_period = (DEV_LANES == 2) ? 5000 : 2500;
  integer bpe        = (DEV_LANES == 2) ? 2 : 1;
  // lane count in the messages: 21 for a 2 lane build on a 1 lane converter
  integer lane_tag;
  always @(dev_lanes) lane_tag = (dev_lanes == NUM_LANES) ? NUM_LANES : 10*NUM_LANES + dev_lanes;
  localparam DSKEW      = (FILT_SKEW < 0) ? -FILT_SKEW : 0;
  localparam FSKEW      = (FILT_SKEW > 0) ?  FILT_SKEW : 0;

  // base_clk toggles every quarter DCO period. The DCO toggles on its rising
  // edge and the data is launched on its falling edge, so every DCO edge sits
  // in the middle of its bit.
  integer base_half = ((DEV_LANES == 2) ? 5000 : 2500) / 4;
  // base_clk rising edges per delay_clk half period, for a 200 MHz reference.
  integer dly_div   = 5000 / ((DEV_LANES == 2) ? 5000 : 2500);

  localparam HIST = 4096;

  reg base_clk = 1'b0;
  always #(base_half) base_clk <= ~base_clk;

  reg        dco            = 1'b0;
  reg        da             = 1'b0;
  reg        db             = 1'b0;
  reg        sync_n         = 1'b0;
  reg        adc_rst        = 1'b1;
  reg        filter_rdy_n   = 1'b1;
  reg  [1:0] device_code    = 2'h0;
  reg        bitslip_enable = 1'b0;
  reg        delay_clk      = 1'b0;
  reg        delay_rst      = 1'b1;
  reg        up_clk         = 1'b0;
  reg        filt_en        = 1'b0;

  wire                      adc_clk;
  wire [ADC_DATA_WIDTH-1:0] adc_data;
  wire                      adc_valid;
  wire                      sync_status;

  ad408x_phy #(
    .FPGA_TECHNOLOGY(FPGA_TECH),
    .DRP_WIDTH(5),
    .NUM_LANES(NUM_LANES),
    .ENABLE_20BIT(ENABLE_20BIT),
    .ENABLE_16BIT(ENABLE_16BIT),
    .ENABLE_14BIT(ENABLE_14BIT),
    .EN_FILTER_RDY(EN_FILTER_RDY),
    .ADC_DATA_WIDTH(ADC_DATA_WIDTH)
  ) i_dut (
    .dclk_in_p(dco),
    .dclk_in_n(~dco),
    .data_a_in_p(da),
    .data_a_in_n(~da),
    .data_b_in_p(db),
    .data_b_in_n(~db),
    .cnv_in_p(1'b0),
    .cnv_in_n(1'b1),
    .sync_n(sync_n),
    .num_lanes((dev_lanes == 2) ? 5'd2 : ONE_LANE_REG[4:0]),
    .device_code(device_code),
    .self_sync(1'b1),
    .bitslip_enable(bitslip_enable),
    .filter_enable(filt_en),
    .filter_rdy_n(filter_rdy_n),
    .up_clk(up_clk),
    .up_adc_dld({NUM_LANES{1'b0}}),
    .up_adc_dwdata({5*NUM_LANES{1'b0}}),
    .up_adc_drdata(),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(),
    .adc_rst(adc_rst),
    .adc_clk(adc_clk),
    .adc_data(adc_data),
    .adc_valid(adc_valid),
    .sync_status(sync_status));

  // IDELAYCTRL reference clock and register clock, both divided from base_clk.

  integer dly_cnt = 0;
  integer up_cnt  = 0;
  integer rst_cnt = 0;

  always @(posedge base_clk) begin
    if (dly_cnt >= dly_div-1) begin
      dly_cnt   = 0;
      delay_clk = ~delay_clk;
    end else begin
      dly_cnt = dly_cnt + 1;
    end
    if (up_cnt >= 7) begin
      up_cnt = 0;
      up_clk = ~up_clk;
    end else begin
      up_cnt = up_cnt + 1;
    end
  end

  always @(posedge delay_clk) begin
    if (rst_cnt >= 8) delay_rst = 1'b0;
    else              rst_cnt   = rst_cnt + 1;
  end

  // Converter model
  //
  // The DCO runs all the time. sync_n restarts the conversions, so the sample
  // stream starts again when sync_n deasserts; in the PHY it only stops and
  // restarts the clock divider.

  always @(posedge base_clk) begin
    dco = ~dco;
  end

  // DCO periods modulo the divide ratio, free running. sync_n is released on
  // a fixed phase of it, as a sync generated in step with the DCO would be.
  integer dco_ph = 0;
  always @(posedge dco) dco_ph = (dco_ph + 1) % 4;

  integer    seed       = SEED;
  integer    nbits      = 20;
  reg [19:0] pattern    = 20'hAC5D6;
  reg        tx_random  = 1'b0;
  // With the filter on, the converter repeats each result for the whole
  // decimation period; tx_hold models that.
  reg        tx_hold    = 1'b0;
  // All zero data: no bit offset of it can ever equal a pattern.
  reg        tx_zero    = 1'b0;
  reg [19:0] hold_val   = 20'd0;
  integer    lead       = 0;      // lead ticks still to send after sync
  reg [19:0] shreg      = 20'd0;
  integer    bitcnt     = 0;
  integer    filt_cnt   = FILT_DECIM - 1;
  reg        filt_lvl   = 1'b1;

  // Record of the transmitted samples since the last sync: value and filter
  // mark, indexed by tx_cnt modulo HIST.
  integer    tx_cnt = 0;
  reg [19:0] tx_val  [0:HIST-1];
  reg        tx_mark [0:HIST-1];
  // Random entries only: the pattern repeats, so it cannot identify a sample.
  reg        tx_rand [0:HIST-1];

  // Per tick delay lines: the data lanes are delayed DSKEW ticks, the filter
  // line FSKEW ticks.
  reg [15:0] da_pipe   = 16'd0;
  reg [15:0] db_pipe   = 16'd0;
  reg [15:0] filt_pipe = 16'hffff;

  task load_sample;
    reg [19:0] val;
    begin
      filt_cnt = (filt_cnt >= FILT_DECIM-1) ? 0 : filt_cnt + 1;
      filt_lvl = (filt_cnt == FILT_DECIM-1) ? 1'b1 : 1'b0;
      if (tx_zero)                       val = 20'd0;
      else if (!tx_random)               val = pattern;
      else if (tx_hold && filt_cnt != 0) val = hold_val;
      else                               val = $random(seed);
      val      = val & ((20'd1 << nbits) - 20'd1);
      hold_val = val;
      shreg    = val << (20 - nbits);   // left justify, MSB goes out first
      bitcnt   = nbits;
      tx_val[tx_cnt % HIST]  = val;
      // The sample to pass is the first one of a period, where the line falls.
      tx_mark[tx_cnt % HIST] = (filt_cnt == 0);
      tx_rand[tx_cnt % HIST] = tx_random;
      tx_cnt   = tx_cnt + 1;
    end
  endtask

  reg ra, rb;

  always @(negedge base_clk) begin
    if (sync_n === 1'b0) begin
      da        = 1'b0;
      db        = 1'b0;
      bitcnt    = 0;
      filter_rdy_n = 1'b1;
      filt_lvl  = 1'b1;
      filt_cnt  = FILT_DECIM - 1;
      da_pipe   = 16'd0;
      db_pipe   = 16'd0;
      filt_pipe = 16'hffff;
    end else begin
      if (lead > 0) begin
        // Lead ticks before the first sample: random bits, filter idle high.
        ra   = $random(seed);
        rb   = $random(seed);
        lead = lead - 1;
      end else begin
        if (bitcnt == 0) begin
          // a lane mode switch takes effect on a sample boundary
          if (dev_req != dev_lanes) begin
            dev_lanes  = dev_req;
            dco_period = (dev_req == 2) ? 5000 : 2500;
            bpe        = (dev_req == 2) ? 2 : 1;
            base_half  = dco_period / 4;
            dly_div    = 5000 / dco_period;
          end
          load_sample;
        end
        ra = shreg[19];
        rb = shreg[18];
        shreg  = shreg << bpe;
        bitcnt = bitcnt - bpe;
      end
      da_pipe   = {da_pipe[14:0], ra};
      db_pipe   = {db_pipe[14:0], rb};
      filt_pipe = {filt_pipe[14:0], filt_lvl};
      da = da_pipe[DSKEW];
      if (bpe == 2) db = db_pipe[DSKEW];
      else          db = $random;
      filter_rdy_n = filt_pipe[FSKEW];
    end
  end

  // Samples per output word: a 20 bit sample takes a 32 bit slot, a 16 or 14
  // bit sample a 16 bit slot; the earliest one in the low bits.
  function integer slot_w;
    input integer n;
    slot_w = (n == 20) ? 32 : 16;
  endfunction

  function integer spw;
    input integer n;
    spw = ADC_DATA_WIDTH / slot_w(n);
  endfunction

  // Expected value of one sample in its slot, sign extended.
  function [31:0] expect_slot;
    input [19:0] v;
    input integer n;
    reg [31:0] e;
    begin
      e = v & ((32'd1 << n) - 32'd1);
      if (v[n-1]) e = e | ~((32'd1 << n) - 32'd1);
      if (slot_w(n) == 16) e = e & 32'h0000ffff;
      expect_slot = e;
    end
  endfunction

  function [31:0] out_slot;
    input [ADC_DATA_WIDTH-1:0] d;
    input integer k;
    input integer n;
    begin
      out_slot = d >> (slot_w(n)*k);
      if (slot_w(n) == 16) out_slot = out_slot & 32'h0000ffff;
    end
  endfunction

  // Scoreboard, on samples. An output word is split into its samples, earliest
  // first.
  //
  // While searching, a sample is matched against the 48 most recently started
  // samples, newest first; with the filter only marked samples qualify. Once
  // matched, every further sample has to be exactly the next one, or with the
  // filter the next marked one. sb_first records the index the search locked
  // on.

  reg     sb_en     = 1'b0;
  reg     sb_filt   = 1'b0;
  integer sb_idx    = -1;
  integer sb_first  = -1;
  integer sb_ok     = 0;
  integer sb_err    = 0;
  integer sb_quiet  = 0;   // suppress error prints, for the negative test
  // Count samples that match nothing before the lock as discards instead of
  // errors. Used right after sync, where the first packed samples hold the
  // zeros of the serdes reset.
  reg     sb_disc_en = 1'b0;
  integer sb_disc    = 0;
  integer j, nx, ks, nmatch;
  reg [31:0] got;

  always @(posedge adc_clk) begin
    if (sb_en && adc_valid) begin
      for (ks = 0; ks < spw(nbits); ks = ks + 1) begin
        got = out_slot(adc_data, ks, nbits);
        if (sb_idx < 0) begin
          // A random 14 bit value can repeat within the window; lock only on
          // a unique match, an ambiguous output is passed over.
          nmatch = 0;
          for (j = tx_cnt - 1; (j >= 0) && (j >= tx_cnt - 48); j = j - 1) begin
            if ((got === expect_slot(tx_val[j % HIST], nbits)) &&
                tx_rand[j % HIST] && (!sb_filt || tx_mark[j % HIST])) begin
              if (nmatch == 0) sb_idx = j;
              nmatch = nmatch + 1;
            end
          end
          if (nmatch > 1) begin
            sb_idx = -1;
          end else if (sb_idx < 0 && sb_disc_en) begin
            sb_disc = sb_disc + 1;
          end else if (sb_idx < 0) begin
            sb_err = sb_err + 1;
            if (!sb_quiet)
              $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: output %08x matches none of the recent samples",
                       (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, got);
          end else begin
            sb_first = sb_idx;
            sb_ok    = sb_ok + 1;
          end
        end else begin
          nx = sb_idx + 1;
          if (sb_filt) begin
            while ((nx < tx_cnt) && !tx_mark[nx % HIST]) nx = nx + 1;
          end
          if (nx >= tx_cnt) begin
            sb_err = sb_err + 1;
            if (!sb_quiet)
              $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: output after sample %0d, which has not been sent yet",
                       (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, sb_idx);
          end else if (got !== expect_slot(tx_val[nx % HIST], nbits)) begin
            sb_err = sb_err + 1;
            if (!sb_quiet)
              $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: sample %0d expected %08x got %08x",
                       (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, nx, expect_slot(tx_val[nx % HIST], nbits), got);
          end else begin
            sb_ok = sb_ok + 1;
          end
          sb_idx = nx;
        end
      end
    end
  end

  task sb_start;
    input filt;
    begin
      sb_idx  = -1;
      sb_first = -1;
      sb_disc  = 0;
      sb_ok   = 0;
      sb_err  = 0;
      sb_filt = filt;
      sb_en   = 1'b1;
    end
  endtask

  // Runs the scoreboard for n outputs, or a cycle limit.
  task sb_run;
    input filt;
    input integer n;
    integer i;
    begin
      sb_start(filt);
      i = 0;
      while ((sb_ok + sb_err) < n && i < 8000) begin
        @(posedge adc_clk) i = i + 1;
      end
      sb_en = 1'b0;
    end
  endtask

  // One sync and lock at the given lead, followed by the stream check.
  // Returns the found shift count, or -1 if the lock failed.

  integer found_val;

  // Restarts the converter clock and the PHY. The converter sends the pattern,
  // or random data when random is set, after lead_ticks lead ticks.

  task do_sync;
    input [1:0]   code;
    input integer lead_ticks;
    input         random;
    input         arm;
    begin
      // sync_n does not touch adc_rst; adc_rst is only released once, after
      // the first sync, as the driver enables the core. sync_n deasserts on the
      // same DCO/4 phase every time, so the divider restarts on the same edge.
      @(posedge base_clk);
      sync_n    = 1'b0;
      tx_random = 1'b0;
      repeat (160) @(posedge base_clk);

      case (code)
        2'h0    : begin nbits = 20; pattern = 20'hAC5D6; end
        2'h1    : begin nbits = 16; pattern = 20'h0AC5D; end
        default : begin nbits = 14; pattern = 20'h02B17; end
      endcase
      device_code = code;
      lead        = lead_ticks;
      tx_cnt      = 0;
      tx_random   = random;
      @(posedge dco);
      while (dco_ph != 0) @(posedge dco);
      @(negedge base_clk);
      // With arm the scoreboard sees the stream from the very first output.
      if (arm) sb_start(1'b0);
      sync_n      = 1'b1;
      repeat (160) @(posedge base_clk);

      if (adc_rst === 1'b1) begin
        repeat (8) @(posedge adc_clk);
        @(posedge adc_clk) adc_rst = 1'b0;
      end
    end
  endtask

  task sync_and_lock;
    input [1:0]   code;
    input integer lead_ticks;
    integer i;
    begin
      found_val = -1;
      // A previous lock survives sync_n on purpose. A bitslip request clears
      // sync_status; checked here before the sync.
      if (sync_status === 1'b1) begin
        tx_zero = 1'b1;
        @(posedge adc_clk) bitslip_enable = 1'b1;
        @(posedge adc_clk) bitslip_enable = 1'b0;
        i = 0;
        while (sync_status !== 1'b0 && i < 4000) begin
          @(posedge adc_clk) i = i + 1;
        end
        tx_zero = 1'b0;
        if (sync_status !== 1'b0) begin
          fail = 1'b1;
          $display("FAIL %0s %0d/%0d/%0d %0d lane: previous lock could not be invalidated", (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, NUM_LANES);
        end
      end

      do_sync(code, lead_ticks, 1'b0, 1'b0);
      @(posedge adc_clk) bitslip_enable = 1'b1;
      @(posedge adc_clk) bitslip_enable = 1'b0;
      // The request clears the status a few cycles later; a status read
      // before that may still be a lock of the earlier search.
      repeat (4) @(posedge adc_clk);

      i = 0;
      while (sync_status !== 1'b1 && i < 4000) begin
        @(posedge adc_clk) i = i + 1;
      end

      if (sync_status !== 1'b1) begin
        fail = 1'b1;
        $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit lead %0d: pattern search did not lock",
                 (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, lead_ticks);
      end else begin
        found_val = i_dut.shift_cnt;
        tx_random = 1'b1;
        // Let the pattern samples still in the pipeline drain.
        repeat (64) @(posedge adc_clk);
        sb_run(1'b0, 64);
        if (sb_err != 0 || sb_ok < 64) begin
          fail = 1'b1;
          $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit lead %0d: stream check %0d ok %0d errors",
                   (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, lead_ticks, sb_ok, sb_err);
        end
      end
    end
  endtask

  // Filter: every output must be exactly the next marked sample.

  task run_filter;
    begin
      // The converter repeats every result for its decimation period, as with the
      // digital filter on. Within a period the copies are equal, so the check is
      // on results: every result exactly once, in order, none skipped and none
      // repeated. Samples already in the pipeline drain first.
      // Without EN_FILTER_RDY filter_enable must have no effect: every sample
      // still has to come out.
      // Without filter support every copy comes out, so the copies would make
      // the scoreboard ambiguous; the converter keeps sending distinct data.
      tx_hold = (EN_FILTER_RDY != 0);
      filt_en = 1'b1;
      repeat (64) @(posedge adc_clk);
      sb_run(EN_FILTER_RDY != 0, 64);
      filt_en = 1'b0;
      tx_hold = 1'b0;
      if (EN_FILTER_RDY == 0) begin
        if (sb_err != 0 || sb_ok < 64) begin
          fail = 1'b1;
          $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: no filter support, but filter_enable changed the stream, %0d ok %0d errors",
                   (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, sb_ok, sb_err);
        end else begin
          $display("%0s %0d lane, %0d bit: no filter support, filter_enable has no effect, %0d samples in order",
                   (FPGA_TECH == 3) ? "US+" : "7S", lane_tag, nbits, sb_ok);
        end
      end else if (sb_err != 0 || sb_ok < 64) begin
        fail = 1'b1;
        $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: filter decimation %0d skew %0d, %0d ok %0d errors",
                 (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, FILT_DECIM, FILT_SKEW, sb_ok, sb_err);
      end else begin
        $display("%0s %0d lane, %0d bit: filter decimation %0d skew %0d, %0d results each exactly once",
                 (FPGA_TECH == 3) ? "US+" : "7S", lane_tag, nbits, FILT_DECIM, FILT_SKEW, sb_ok);
      end
      repeat (4) @(posedge adc_clk);
    end
  endtask

  // Relock as the driver does it after a sync: the old lock is still there, the
  // word boundary has moved, a new request is made and sync_status is polled;
  // as soon as it is set the converter leaves the pattern mode. The status must
  // therefore come from the new search, and the stream must be right at once.

  task run_relock;
    input integer found0;
    integer i, lead_new, exp;
    begin
      lead_new = 3;
      do_sync(device_code, lead_new, 1'b0, 1'b0);
      @(posedge adc_clk) bitslip_enable = 1'b1;
      @(posedge adc_clk) bitslip_enable = 1'b0;
      // The request clears the status within a few cycles; the driver reads it
      // later than that, behind the clock domain crossing.
      repeat (4) @(posedge adc_clk);
      // driver: poll the status, then switch the converter to real data
      i = 0;
      while (sync_status !== 1'b1 && i < 4000) begin
        @(posedge adc_clk) i = i + 1;
      end
      tx_random = 1'b1;
      exp = (found0 + lead_new * bpe) % nbits;
      if (sync_status !== 1'b1) begin
        fail = 1'b1;
        $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: relock did not lock", (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits);
      end else begin
        repeat (64) @(posedge adc_clk);
        sb_run(1'b0, 64);
        if (sb_err != 0 || sb_ok < 64 || i_dut.shift_cnt != exp) begin
          fail = 1'b1;
          $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: relock shift count %0d expected %0d, stream %0d ok %0d errors",
                   (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, i_dut.shift_cnt, exp, sb_ok, sb_err);
        end else begin
          $display("%0s %0d lane, %0d bit: relock after a moved word boundary, shift count %0d, stream in order",
                   (FPGA_TECH == 3) ? "US+" : "7S", lane_tag, nbits, i_dut.shift_cnt);
        end
      end
    end
  endtask

  // A request right after the converter switched from data to the pattern, as
  // the driver does it, with the alignment already right: the samples still in
  // the pipeline are data, so the search must wait for samples received after
  // the request and lock again without moving the offset, whatever cycle the
  // request lands on.

  task run_rerequest;
    input integer found0;
    integer ph, i, nbad;
    begin
      nbad = 0;
      for (ph = 0; ph < 10; ph = ph + 1) begin
        tx_random = 1'b1;
        repeat (32 + ph) @(posedge adc_clk);
        @(posedge adc_clk) begin
          tx_random      = 1'b0;
          bitslip_enable = 1'b1;
        end
        @(posedge adc_clk) bitslip_enable = 1'b0;
        repeat (4) @(posedge adc_clk);
        i = 0;
        while (sync_status !== 1'b1 && i < 2000) begin
          @(posedge adc_clk) i = i + 1;
        end
        if (sync_status !== 1'b1 || i_dut.shift_cnt != found0) begin
          nbad = nbad + 1;
          fail = 1'b1;
          $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: request at phase %0d, status %b, shift count %0d expected %0d",
                   (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, ph, sync_status, i_dut.shift_cnt, found0);
        end
      end
      tx_random = 1'b1;
      if (nbad == 0)
        $display("%0s %0d lane, %0d bit: 10 requests right after the switch to the pattern, all relocked in place",
                 (FPGA_TECH == 3) ? "US+" : "7S", lane_tag, nbits);
    end
  endtask

  task check_clocking;
    realtime t0, t1;
    begin
      @(posedge adc_clk) t0 = $realtime;
      @(posedge adc_clk) t1 = $realtime;
      if ((i_dut.SERDES_FACTOR != 8) || ((t1 - t0) != dco_period * 4)) begin
        fail = 1'b1;
        $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit: serdes factor %0d, adc_clk period %0.0f ps",
                 (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, i_dut.SERDES_FACTOR, t1 - t0);
      end
    end
  endtask

  // Switch the converter to n lanes; num_lanes follows. The next run_depth
  // re-syncs and re-requests, as the driver does after a mode change.
  task switch_lanes;
    input integer n;
    begin
      dev_req = n;
      while (dev_lanes != n) @(posedge base_clk);
      repeat (64) @(posedge base_clk);
      $display("%0s %0d lane build: converter switched to %0d lane(s) while running",
               (FPGA_TECH == 3) ? "US+" : "7S", NUM_LANES, n);
    end
  endtask

  task run_depth;
    input [1:0] code;
    integer L, n_lead, found0, exp, nfail;
    begin
      nfail  = 0;
      found0 = -1;
      n_lead = SWEEP ? ((code == 2'h0) ? 20 : (code == 2'h1) ? 16 : 14) : 1;
      for (L = 0; L < n_lead; L = L + 1) begin
        sync_and_lock(code, L);
        if (found_val < 0) begin
          nfail = nfail + 1;
        end else if (L == 0) begin
          found0 = found_val;
        end else begin
          exp = (found0 + L * bpe) % nbits;
          if (found_val != exp) begin
            fail  = 1'b1;
            nfail = nfail + 1;
            $display("FAIL %0s %0d/%0d/%0d %0d lane %0d bit lead %0d: shift count %0d, expected %0d",
                     (FPGA_TECH == 3) ? "US+" : "7S", ENABLE_20BIT ? 20 : 0, ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, lane_tag, nbits, L, found_val, exp);
          end
        end
        if (L == 0) begin
          check_clocking;
          if (found_val >= 0) begin
            run_filter;
            run_rerequest(found_val);
            run_relock(found_val);
          end
        end
      end
      $display("%0s %0d lane, %0d bit: %0d lead offsets locked and streamed%0s, shift count %0d at lead 0, serdes factor %0d",
               (FPGA_TECH == 3) ? "US+" : "7S", lane_tag, nbits, n_lead - nfail,
               (nfail != 0) ? " WITH ERRORS" : "", found0, i_dut.SERDES_FACTOR);
    end
  endtask

  initial begin
    $display("%0s %0d lane, depths %0d/%0d/%0d, bus %0d bit: DCO %0d ps, filter serdes %0d, decimation %0d, filter skew %0d, sweep %0d",
             (FPGA_TECH == 3) ? "US+" : "7S", NUM_LANES, ENABLE_20BIT ? 20 : 0,
             ENABLE_16BIT ? 16 : 0, ENABLE_14BIT ? 14 : 0, ADC_DATA_WIDTH,
             dco_period, EN_FILTER_RDY, FILT_DECIM, FILT_SKEW, SWEEP);
    if (ENABLE_20BIT) run_depth(2'h0);
    if (ENABLE_16BIT) run_depth(2'h1);
    if (ENABLE_14BIT) run_depth(2'h2);
    if (SWITCH_LANES != 0) begin
      switch_lanes(1);
      if (ENABLE_20BIT) run_depth(2'h0);
      if (ENABLE_16BIT) run_depth(2'h1);
      if (ENABLE_14BIT) run_depth(2'h2);
      switch_lanes(2);
      if (ENABLE_20BIT) run_depth(2'h0);
      if (ENABLE_16BIT) run_depth(2'h1);
      if (ENABLE_14BIT) run_depth(2'h2);
    end
    done = 1'b1;
  end

endmodule
