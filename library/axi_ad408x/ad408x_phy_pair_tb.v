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


// Two ad408x_phy instances joined and packed by util_sample_pack, wired as in
// the ad4880_fmc_evb block design: join FIFO on, the packer on the clock of
// channel A, async_resetn from sync_n, xfer_req from the test as the DMA
// would drive it, the configuration held during a transfer.
//
// Both converters sample on the same CNV and send on DCOs of the same phase,
// so sample k leaves both of them at the same time. The DCOs start when the
// driver enables the interface of each channel, one after the other, and the
// core resets are released one after the other. The BUFR divider of each PHY
// starts on the first DCO edge it sees, so the adc_clk of channel B is offset
// from the one of channel A by the start delay modulo 4 DCO periods. Channel B
// can also have a board skew against channel A.
//
// Two flows: without sync_n after the start, and with a sync_n pulse after
// both channels run. sync_n is the AD9508 SYNC: it stops the DCOs and the
// conversions, and restarts both together, with the BUFR dividers.
//
// Every case captures one transfer. The words must hold, round by round, the
// samples of the enabled channels, and each channel must continue without a
// repeated or a missing sample. After a sync_n pulse both channels must hold
// the same index in every round. Without it the channels start on the reset
// of the join FIFO, whose crossing to each channel clock is uncertain by one
// cycle, about one sample, so B may trail A by a sample; the offset must stay
// constant within the transfer and is reported.
//
// For comparison, a capture without the join FIFO is monitored too: on the
// clock of channel A, whenever channel A is valid, the data of both channels
// is taken. Its B samples are expected to repeat or skip; it is reported and
// never fails the test.
//
// 20 bit depth, two lanes, every depth built, sample_slots_select 1 (two slots per sample). The DCO runs at
// 200 MHz as in ad408x_phy_tb, the scaling does not change the cycle
// relations.

`timescale 1ps/1ps

module ad408x_phy_pair_tb;

  localparam DCO_PERIOD = 5000;
  localparam Q          = DCO_PERIOD / 4;
  localparam WORDS      = 400;
  localparam CASES      = 14;

  reg base_clk = 1'b0;
  always #(Q) base_clk = ~base_clk;

  // free running DCO of the AD9508; each channel gets it once enabled
  reg dco_free = 1'b0;
  always @(posedge base_clk) dco_free = ~dco_free;

  reg     run_a   = 1'b0;
  reg     run_b   = 1'b0;
  // board delay of each channel, clock and data together
  integer skew_a  = 0;
  integer skew_b  = 0;
  reg     sync_n  = 1'b1;

  wire dco_a_s = dco_free & run_a;
  wire dco_b_s = dco_free & run_b;
  reg  dco_a = 1'b0;
  reg  dco_b = 1'b0;
  always @(dco_a_s) dco_a <= #(skew_a) dco_a_s;
  always @(dco_b_s) dco_b <= #(skew_b) dco_b_s;

  // Converter model, shared timeline: a sample every 10 DCO edges, two bits
  // per edge, MSB first on lane a. Launched on the falling base_clk edge, so
  // every DCO edge sits in the middle of the bit.

  reg        data_mode = 1'b0;
  reg [17:0] idx       = 18'd0;
  reg [19:0] sh_a      = 20'd0;
  reg [19:0] sh_b      = 20'd0;
  integer    bitcnt    = 0;
  reg        da_a_s = 1'b0, db_a_s = 1'b0;
  reg        da_a = 1'b0, db_a = 1'b0;
  reg        da_b_s = 1'b0, db_b_s = 1'b0;
  reg        da_b = 1'b0, db_b = 1'b0;

  always @(negedge base_clk) begin
    if (sync_n === 1'b0) begin
      // the conversions restart with sync
      idx    = 18'd0;
      bitcnt = 0;
    end else begin
      if (bitcnt == 0) begin
        // channel tag in bits 19:18, A 0 and B 1, the sample index below
        sh_a   = data_mode ? {2'd0, idx} : 20'hAC5D6;
        sh_b   = data_mode ? {2'd1, idx} : 20'hAC5D6;
        idx    = idx + 1'b1;
        bitcnt = 20;
      end
      da_a_s = sh_a[19];
      db_a_s = sh_a[18];
      da_b_s = sh_b[19];
      db_b_s = sh_b[18];
      sh_a   = sh_a << 2;
      sh_b   = sh_b << 2;
      bitcnt = bitcnt - 2;
    end
  end

  always @(da_a_s) da_a <= #(skew_a) da_a_s;
  always @(db_a_s) db_a <= #(skew_a) db_a_s;
  always @(da_b_s) da_b <= #(skew_b) da_b_s;
  always @(db_b_s) db_b <= #(skew_b) db_b_s;

  // register and delay reference clocks

  reg delay_clk = 1'b0;
  always #2500 delay_clk = ~delay_clk;
  reg delay_rst = 1'b1;
  initial #100000 delay_rst = 1'b0;
  reg up_clk = 1'b0;
  always #5000 up_clk = ~up_clk;

  reg adc_rst_a = 1'b1;
  reg adc_rst_b = 1'b1;
  reg slip_a    = 1'b0;
  reg slip_b    = 1'b0;

  wire        clk_a, clk_b;
  wire [31:0] data_a, data_b;
  wire        valid_a, valid_b;
  wire        lock_a, lock_b;

  ad408x_phy #(
    .FPGA_TECHNOLOGY(1),
    .NUM_LANES(2)
  ) i_phy_a (
    .dclk_in_p(dco_a), .dclk_in_n(~dco_a),
    .data_a_in_p(da_a), .data_a_in_n(~da_a),
    .data_b_in_p(db_a), .data_b_in_n(~db_a),
    .cnv_in_p(1'b0), .cnv_in_n(1'b1),
    .sync_n(sync_n),
    .num_lanes(5'd2),
    .device_code(2'h0),
    .self_sync(1'b1),
    .bitslip_enable(slip_a),
    .filter_enable(1'b0),
    .filter_rdy_n(1'b1),
    .up_clk(up_clk),
    .up_adc_dld(2'd0), .up_adc_dwdata(10'd0), .up_adc_drdata(),
    .delay_clk(delay_clk), .delay_rst(delay_rst), .delay_locked(),
    .adc_rst(adc_rst_a),
    .adc_clk(clk_a),
    .adc_data(data_a),
    .adc_valid(valid_a),
    .sync_status(lock_a));

  ad408x_phy #(
    .FPGA_TECHNOLOGY(1),
    .NUM_LANES(2),
    .IO_DELAY_GROUP("adc_if_delay_group2")
  ) i_phy_b (
    .dclk_in_p(dco_b), .dclk_in_n(~dco_b),
    .data_a_in_p(da_b), .data_a_in_n(~da_b),
    .data_b_in_p(db_b), .data_b_in_n(~db_b),
    .cnv_in_p(1'b0), .cnv_in_n(1'b1),
    .sync_n(sync_n),
    .num_lanes(5'd2),
    .device_code(2'h0),
    .self_sync(1'b1),
    .bitslip_enable(slip_b),
    .filter_enable(1'b0),
    .filter_rdy_n(1'b1),
    .up_clk(up_clk),
    .up_adc_dld(2'd0), .up_adc_dwdata(10'd0), .up_adc_drdata(),
    .delay_clk(delay_clk), .delay_rst(delay_rst), .delay_locked(),
    .adc_rst(adc_rst_b),
    .adc_clk(clk_b),
    .adc_data(data_b),
    .adc_valid(valid_b),
    .sync_status(lock_b));

  // the packer as in the block design

  reg         en_a    = 1'b1;
  reg         en_b    = 1'b1;
  reg         xfer_req = 1'b0;
  wire        p_en;
  wire [63:0] p_data;
  wire        p_sync;

  util_sample_pack #(
    .SLOT_W(16),
    .NUM_CH(2),
    .CH_SLOTS(2),
    .ENABLE_SAMPLE_SLOTS_SELECT(1),
    .JOIN_FIFO_ENABLE(1),
    .XFER_REQ_ENABLE(1),
    .OVERFLOW_XFER_REQ(1),
    .CONFIG_XFER_HOLD(1)
  ) i_pack (
    .async_resetn(sync_n),
    .clk_0(clk_a), .reset_0(adc_rst_a), .valid_0(valid_a), .data_0(data_a),
    .enable_0(en_a), .overflow_0(),
    .clk_1(clk_b), .reset_1(adc_rst_b), .valid_1(valid_b), .data_1(data_b),
    .enable_1(en_b), .overflow_1(),
    .clk(clk_a),
    .reset(adc_rst_a),
    .sample_slots_select(1'b1),
    .slot_enable(4'hf),
    .packed_fifo_wr_en(p_en),
    .packed_fifo_wr_data(p_data),
    .packed_fifo_wr_overflow(1'b0),
    .packed_fifo_wr_xfer_req(xfer_req),
    .packed_sync(p_sync));

  // Checker: two 32 bit samples per word, the earlier one in the low half.
  // Round by round the enabled channels follow each other, A before B.

  reg     mon_en = 1'b0;
  reg     exact  = 1'b1;
  integer words = 0, errs = 0;
  integer next_ch, cur, prev_a, prev_b, s, offset;
  reg [31:0] smp;

  always @(posedge clk_a) begin
    if (mon_en && p_en) begin
      words = words + 1;
      for (s = 0; s < 2; s = s + 1) begin
        smp = p_data[32*s +: 32];
        if (smp[19:18] != next_ch) begin
          errs = errs + 1;
          if (errs <= 5) $display("  word %0d sample %0d: channel %0d, expected %0d",
                                  words, s, smp[19:18], next_ch);
        end
        cur = smp[17:0];
        if (smp[19:18] == 0) begin
          if (prev_a >= 0 && cur != prev_a + 1) begin
            errs = errs + 1;
            if (errs <= 5) $display("  word %0d: A %0d after %0d", words, cur, prev_a);
          end
          prev_a = cur;
        end else begin
          if (prev_b >= 0 && cur != prev_b + 1) begin
            errs = errs + 1;
            if (errs <= 5) $display("  word %0d: B %0d after %0d", words, cur, prev_b);
          end
          // B against A of the same round: 0 after sync, constant otherwise
          if (en_a) begin
            if (offset == -1000000) offset = prev_a - cur;
            if ((exact && cur != prev_a) || (prev_a - cur != offset)) begin
              errs = errs + 1;
              if (errs <= 5) $display("  word %0d: B %0d paired with A %0d", words, cur, prev_a);
            end
          end
          prev_b = cur;
        end
        next_ch = (en_a && en_b) ? 1 - smp[19:18] : next_ch;
      end
    end
  end

  // capture without the join FIFO, for comparison only

  integer d_pairs = 0, d_mism = 0, d_dups = 0, d_skips = 0, d_prev_b = -1;

  always @(posedge clk_a) begin
    if (mon_en && valid_a && (data_a[19:18] == 2'd0) && (data_b[19:18] == 2'd1)) begin
      d_pairs = d_pairs + 1;
      if (data_a[17:0] != data_b[17:0]) d_mism = d_mism + 1;
      if (d_prev_b >= 0) begin
        if (data_b[17:0] == d_prev_b)          d_dups  = d_dups + 1;
        else if (data_b[17:0] != d_prev_b + 1) d_skips = d_skips + 1;
      end
      d_prev_b = data_b[17:0];
    end
  end

  task wait_dco_low;
    begin
      @(negedge base_clk);
      while (dco_free !== 1'b0) @(negedge base_clk);
    end
  endtask

  task lock;
    input ch;
    integer i;
    begin
      if (ch == 0) begin
        @(posedge clk_a) slip_a = 1'b1;
        @(posedge clk_a) slip_a = 1'b0;
        i = 0;
        repeat (4) @(posedge clk_a);
        while (lock_a !== 1'b1 && i < 8000) @(posedge clk_a) i = i + 1;
      end else begin
        @(posedge clk_b) slip_b = 1'b1;
        @(posedge clk_b) slip_b = 1'b0;
        i = 0;
        repeat (4) @(posedge clk_b);
        while (lock_b !== 1'b1 && i < 8000) @(posedge clk_b) i = i + 1;
      end
    end
  endtask

  integer n_ok = 0;
  integer n_total = 0;

  // start_b: DCO periods between the interface enable of A and B
  task run_case;
    input         with_sync;
    input integer start_b;
    input integer skew;
    input         ena;
    input         enb;
    integer       t;
    begin
      // start over: interfaces off, dividers cleared
      run_a     = 1'b0;
      run_b     = 1'b0;
      adc_rst_a = 1'b1;
      adc_rst_b = 1'b1;
      data_mode = 1'b0;
      xfer_req  = 1'b0;
      en_a      = ena;
      en_b      = enb;
      sync_n    = 1'b0;
      skew_a    = (skew < 0) ? -skew : 0;
      skew_b    = (skew > 0) ?  skew : 0;
      repeat (40) @(posedge base_clk);
      sync_n    = 1'b1;
      repeat (40) @(posedge base_clk);

      // driver: channel A interface on and core enabled, then channel B
      wait_dco_low;
      run_a = 1'b1;
      repeat (start_b) @(posedge dco_free);
      wait_dco_low;
      run_b = 1'b1;
      repeat (20) @(posedge clk_a);
      adc_rst_a = 1'b0;
      repeat (20) @(posedge clk_b);
      adc_rst_b = 1'b0;
      repeat (20) @(posedge clk_a);

      // data align of each channel on the test pattern
      lock(0);
      lock(1);

      if (with_sync) begin
        wait_dco_low;
        sync_n    = 1'b0;
        run_a     = 1'b0;
        run_b     = 1'b0;
        data_mode = 1'b0;
        repeat (40) @(posedge base_clk);
        wait_dco_low;
        sync_n    = 1'b1;
        run_a     = 1'b1;
        run_b     = 1'b1;
        repeat (20) @(posedge clk_a);
        lock(0);
        lock(1);
      end

      data_mode = 1'b1;
      repeat (100) @(posedge clk_a);

      // one transfer, as the DMA requests it
      words   = 0;
      errs    = 0;
      prev_a  = -1;
      prev_b  = -1;
      offset  = -1000000;
      exact   = with_sync;
      d_pairs = 0;
      d_mism  = 0;
      d_dups  = 0;
      d_skips = 0;
      d_prev_b = -1;
      next_ch = ena ? 0 : 1;
      @(posedge clk_a);
      xfer_req = 1'b1;
      mon_en   = 1'b1;
      t = 0;
      while (words < WORDS && t < 100*WORDS) @(posedge clk_a) t = t + 1;
      mon_en   = 1'b0;
      xfer_req = 1'b0;
      if (words < WORDS) begin
        errs = errs + 1;
        $display("  only %0d words", words);
      end

      $display("%0s, B %0d DCO periods after A (phase %0d/4), skew %4d ps, enable A%0d B%0d, shift %0d/%0d: %0d words, B trails A by %0d, %0d errors -> %0s",
               with_sync ? "sync   " : "no sync", start_b, start_b % 4, skew, ena, enb,
               i_phy_a.shift_cnt, i_phy_b.shift_cnt, words,
               (offset == -1000000) ? 0 : offset, errs,
               (errs == 0) ? "ok" : "BROKEN");
      if (en_a && en_b)
        $display("        without join FIFO (expected faults, not checked): %0d pairs, %0d B != A, %0d B repeated, %0d B skipped",
                 d_pairs, d_mism, d_dups, d_skips);
      if (errs == 0) n_ok = n_ok + 1;
      n_total = n_total + 1;
    end
  endtask

  integer w, k;

  initial begin
    @(negedge delay_rst);
    for (w = 0; w < 2; w = w + 1) begin
      for (k = 16; k < 20; k = k + 1) run_case(w, k, 0, 1'b1, 1'b1);
      run_case(w, 16,  300, 1'b1, 1'b1);
      run_case(w, 16, -300, 1'b1, 1'b1);
    end
    run_case(0, 17, 0, 1'b1, 1'b0);
    run_case(0, 17, 0, 1'b0, 1'b1);
    $display("%0d of %0d cases correct", n_ok, n_total);
    if (n_ok == CASES && n_total == CASES) $display("SUCCESS");
    else                                   $display("FAILED");
    $finish;
  end

  initial begin
    #2000000000;
    $display("FAILED timeout");
    $finish;
  end

endmodule
