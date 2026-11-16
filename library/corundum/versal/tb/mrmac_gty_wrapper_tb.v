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

`timescale 1ns/100ps

`ifndef TIMEOUT
`ifdef MODE_4X25G
`define TIMEOUT 60000000
`elsif MODE_1X40G
`define TIMEOUT 60000000
`else
`define TIMEOUT 30000000
`endif
`endif

module mrmac_gty_wrapper_tb;

  parameter VCD_FILE = "mrmac_gty_wrapper_tb.vcd";

  `include "tb_base.v"

`ifdef MODE_4X25G
  localparam DUT_MODE  = "4x25G";
  localparam SEG_COUNT = 1;
`elsif MODE_1X40G
  localparam DUT_MODE  = "1x40G";
  localparam SEG_COUNT = 4;
`else
  localparam DUT_MODE  = "1x100G";
  localparam SEG_COUNT = 6;
`endif

  // bytes per beat on the fpga_core side
  localparam BW  = (DUT_MODE == "4x25G") ? 8 : (DUT_MODE == "1x40G") ? 32 : 64;

  // line rate in bytes per clock is LINE_NUM / LINE_DEN: 32 at 100G, 8 at 25G,
  // 12.8 at 40G; a minimum frame is 84 B on the wire
  localparam LINE_NUM = (DUT_MODE == "4x25G") ? 8 : (DUT_MODE == "1x40G") ? 64 : 32;
  localparam LINE_DEN = (DUT_MODE == "1x40G") ? 5 : 1;
  localparam LINE_CYCLES = 4096 * 84 * LINE_DEN / LINE_NUM;

  localparam N_BIG = (DUT_MODE == "4x25G") ? 300 : (DUT_MODE == "1x40G") ? 600 : 2000;
  localparam N_OVR = (DUT_MODE == "4x25G") ? 150 : (DUT_MODE == "1x40G") ? 300 : 1000;

  localparam FRM_SIZE = 16384;
  localparam MAX_DESC = 16384;
  localparam MIN_LEN  = 60;

  // 2.56 ns per clock in Corundum 2^-16 ns units
  localparam [47:0] PTP_INC = 48'd167772;
  localparam [54:0] MRMAC_TS_START = ((55'd1 << 32) - 55'd2000) << 8;

  integer cyc = 0;
  always @(posedge clk) cyc <= cyc + 1;

  wire          tx_clk, tx_rst, rx_clk, rx_rst, rx_ptp_clk, rx_ptp_rst;

  reg  [BW*8-1:0] tx_tdata = 0;
  reg  [BW-1:0]   tx_tkeep = 0;
  reg           tx_tvalid = 1'b0;
  wire          tx_tready;
  reg           tx_tlast = 1'b0;
  reg  [16:0]   tx_tuser = 0;

  wire [79:0]   tx_ptp_ts;
  wire [15:0]   tx_ptp_ts_tag;
  wire          tx_ptp_ts_valid;

  wire [BW*8-1:0] rx_tdata;
  wire [BW-1:0]   rx_tkeep;
  wire          rx_tvalid;
  wire          rx_tlast;
  wire [80:0]   rx_tuser;
  wire          rx_status;

  reg  [47:0]   ptp_time = {32'hFFFF_F000, 16'h0};
  reg  [47:0]   ptp_time_d = 0;

  wire [SEG_COUNT*64-1:0] m_tx_tdata;
  wire [SEG_COUNT*11-1:0] m_tx_tkeep_user;
  wire          m_tx_tvalid, m_tx_tready, m_tx_tlast;
  wire [SEG_COUNT*64-1:0] m_rx_tdata;
  wire [SEG_COUNT*11-1:0] m_rx_tkeep_user;
  wire          m_rx_tvalid, m_rx_tlast;

  wire [54:0]   m_rx_ptp_tstamp, m_tx_ptp_tstamp;
  wire [1:0]    m_tx_ptp_1588op;
  wire [15:0]   m_tx_ptp_tag_field, m_tx_ptp_tstamp_tag;
  wire          m_tx_ptp_tstamp_valid;
  wire [54:0]   m_tx_systemtimer, m_rx_systemtimer;
  wire          m_tx_st_sync, m_rx_st_sync;
  wire          m_tx_st_overwrite, m_rx_st_overwrite;
  wire          rx_fifo_overflow;

  reg  [1:0]    tx_ready_mode = 2'd1;
  reg           rx_overdrive = 1'b0;
  wire [31:0]   model_errors;
  wire [31:0]   model_tx_frames, model_rx_frames;

  mrmac_gty_wrapper #(
    .MODE(DUT_MODE)
  ) dut (
    .tx_axi_clk(clk),
    .rx_axi_clk(clk),
    .tx_reset_in(reset),
    .rx_reset_in(reset),

    .tx_clk(tx_clk),
    .tx_rst(tx_rst),
    .tx_axis_tdata(tx_tdata),
    .tx_axis_tkeep(tx_tkeep),
    .tx_axis_tvalid(tx_tvalid),
    .tx_axis_tready(tx_tready),
    .tx_axis_tlast(tx_tlast),
    .tx_axis_tuser(tx_tuser),
    .tx_ptp_time({32'd0, ptp_time}),
    .tx_ptp_ts(tx_ptp_ts),
    .tx_ptp_ts_tag(tx_ptp_ts_tag),
    .tx_ptp_ts_valid(tx_ptp_ts_valid),
    .tx_enable(1'b1),
    .tx_lfc_en(1'b0),
    .tx_lfc_req(1'b0),
    .tx_pfc_en(8'd0),
    .tx_pfc_req(8'd0),

    .rx_clk(rx_clk),
    .rx_rst(rx_rst),
    .rx_axis_tdata(rx_tdata),
    .rx_axis_tkeep(rx_tkeep),
    .rx_axis_tvalid(rx_tvalid),
    .rx_axis_tlast(rx_tlast),
    .rx_axis_tuser(rx_tuser),
    .rx_ptp_clk(rx_ptp_clk),
    .rx_ptp_rst(rx_ptp_rst),
    .rx_ptp_time({32'd0, ptp_time}),
    .rx_enable(1'b1),
    .rx_status(rx_status),
    .rx_lfc_en(1'b0),
    .rx_lfc_req(),
    .rx_lfc_ack(1'b0),
    .rx_pfc_en(8'd0),
    .rx_pfc_req(),
    .rx_pfc_ack(8'd0),

    .mrmac_tx_axis_tdata(m_tx_tdata),
    .mrmac_tx_axis_tkeep_user(m_tx_tkeep_user),
    .mrmac_tx_axis_tvalid(m_tx_tvalid),
    .mrmac_tx_axis_tready(m_tx_tready),
    .mrmac_tx_axis_tlast(m_tx_tlast),
    .mrmac_rx_axis_tdata(m_rx_tdata),
    .mrmac_rx_axis_tkeep_user(m_rx_tkeep_user),
    .mrmac_rx_axis_tvalid(m_rx_tvalid),
    .mrmac_rx_axis_tlast(m_rx_tlast),
    .mrmac_stat_rx_status(1'b1),
    .ctl_tx_enable(),
    .ctl_rx_enable(),
    .mrmac_ctl_tx_pause_enable(),
    .mrmac_ctl_tx_pause_req(),
    .mrmac_ctl_rx_pause_enable(),
    .mrmac_ctl_rx_pause_ack(),
    .mrmac_stat_rx_pause_req(9'd0),
    .mrmac_rx_ptp_tstamp(m_rx_ptp_tstamp),
    .mrmac_tx_ptp_1588op(m_tx_ptp_1588op),
    .mrmac_tx_ptp_tag_field(m_tx_ptp_tag_field),
    .mrmac_tx_ptp_tstamp(m_tx_ptp_tstamp),
    .mrmac_tx_ptp_tstamp_tag(m_tx_ptp_tstamp_tag),
    .mrmac_tx_ptp_tstamp_valid(m_tx_ptp_tstamp_valid),
    .mrmac_tx_ptp_systemtimer(m_tx_systemtimer),
    .mrmac_tx_ptp_st_sync(m_tx_st_sync),
    .mrmac_tx_ptp_st_overwrite(m_tx_st_overwrite),
    .mrmac_rx_ptp_systemtimer(m_rx_systemtimer),
    .mrmac_rx_ptp_st_sync(m_rx_st_sync),
    .mrmac_rx_ptp_st_overwrite(m_rx_st_overwrite),
    .rx_fifo_overflow(rx_fifo_overflow));

  mrmac_ns_loopback_model #(
    .SEG_COUNT(SEG_COUNT),
    .LINE_BYTES_NUM(LINE_NUM),
    .LINE_BYTES_DEN(LINE_DEN),
    .TS_START(MRMAC_TS_START),
    .FRM_ADDR_W(14)
  ) model (
    .clk(clk),
    .rst(reset),
    .tx_ready_mode(tx_ready_mode),
    .rx_overdrive(rx_overdrive),
    .tx_axis_tdata(m_tx_tdata),
    .tx_axis_tkeep_user(m_tx_tkeep_user),
    .tx_axis_tvalid(m_tx_tvalid),
    .tx_axis_tready(m_tx_tready),
    .tx_axis_tlast(m_tx_tlast),
    .rx_axis_tdata(m_rx_tdata),
    .rx_axis_tkeep_user(m_rx_tkeep_user),
    .rx_axis_tvalid(m_rx_tvalid),
    .rx_axis_tlast(m_rx_tlast),
    .tx_ptp_1588op(m_tx_ptp_1588op),
    .tx_ptp_tag_field(m_tx_ptp_tag_field),
    .tx_ptp_tstamp(m_tx_ptp_tstamp),
    .tx_ptp_tstamp_tag(m_tx_ptp_tstamp_tag),
    .tx_ptp_tstamp_valid(m_tx_ptp_tstamp_valid),
    .rx_ptp_tstamp(m_rx_ptp_tstamp),
    .error_count(model_errors),
    .tx_frames(model_tx_frames),
    .rx_frames(model_rx_frames));

  function [7:0] pat;
    input integer idx;
    input integer b;
    begin
      pat = (idx * 29 + b + (b >> 8) * 7) & 8'hff;
    end
  endfunction

  reg [15:0] desc_len [0:MAX_DESC-1];
  reg        desc_err [0:MAX_DESC-1];
  integer    desc_wr = 0;

  reg        tx_gaps = 1'b1;
  integer    tx_rd = 0;
  integer    tx_off = 0;
  integer    tx_beats_frame = 0;
  integer    first_accept_cyc = -1;
  integer    last_accept_cyc = 0;
  integer    b;

  always @(posedge clk) begin
    if (tx_tvalid && tx_tready) begin
      if (first_accept_cyc < 0)
        first_accept_cyc = cyc;
      if (tx_tlast) begin
        last_accept_cyc = cyc;
        tx_rd = tx_rd + 1;
        tx_off = 0;
      end else begin
        tx_off = tx_off + BW;
      end
    end

    if (!tx_tvalid || tx_tready) begin
      if (tx_rd < desc_wr && !(tx_gaps && ($random & 3) == 0)) begin
        for (b = 0; b < BW; b = b + 1) begin
          tx_tdata[b*8 +: 8] <= (tx_off + b < desc_len[tx_rd]) ? pat(tx_rd, tx_off + b) : 8'h00;
          tx_tkeep[b] <= (tx_off + b < desc_len[tx_rd]);
        end
        tx_tlast <= (tx_off + BW >= desc_len[tx_rd]);
        tx_tuser <= {tx_rd[15:0], desc_err[tx_rd]};
        tx_tvalid <= 1'b1;
      end else begin
        tx_tvalid <= 1'b0;
      end
    end

    if (tx_rst) begin
      tx_tvalid <= 1'b0;
    end
  end

  integer rx_idx = 0;
  integer rx_off = 0;
  integer rx_errors = 0;
  integer rx_dropped = 0;
  integer rx_skip;
  integer rx_nkeep;
  integer exp_len;
  reg     keep_ok;
  reg [79:0] exp_ts;

  always @(posedge clk) begin
    if (rx_tvalid && !rx_rst) begin
      // byte 0 is idx * 29 mod 256 and 29 * 53 = 1 mod 256
      if (rx_off == 0 && rx_tdata[7:0] !== pat(rx_idx, 0)) begin
        rx_skip = ((rx_tdata[7:0] - pat(rx_idx, 0)) * 53) & 8'hff;
        rx_idx = rx_idx + rx_skip;
        rx_dropped = rx_dropped + rx_skip;
      end
      exp_len = (desc_len[rx_idx] < MIN_LEN) ? MIN_LEN : desc_len[rx_idx];
      rx_nkeep = 0;
      for (b = 0; b < BW; b = b + 1)
        rx_nkeep = rx_nkeep + rx_tkeep[b];
      keep_ok = (rx_nkeep != 0) && (rx_tkeep == ({BW{1'b1}} >> (BW - rx_nkeep)));

      if (!rx_tlast && rx_nkeep != BW) begin
        $display("%t RX frame %0d: partial keep on non-last beat", $time, rx_idx);
        rx_errors = rx_errors + 1;
      end
      if (rx_tlast && !keep_ok) begin
        $display("%t RX frame %0d: non-contiguous keep on last beat", $time, rx_idx);
        rx_errors = rx_errors + 1;
      end

      exp_ts = {17'd0, model.rx_sop_ts[rx_idx % FRM_SIZE], 8'd0};
      if (rx_tuser[80:1] !== exp_ts) begin
        $display("%t RX frame %0d: ts %h != %h", $time, rx_idx, rx_tuser[80:1], exp_ts);
        rx_errors = rx_errors + 1;
      end

      for (b = 0; b < BW; b = b + 1) begin
        if (rx_tkeep[b] && rx_tdata[b*8 +: 8] !==
            ((rx_off + b < desc_len[rx_idx]) ? pat(rx_idx, rx_off + b) : 8'h00)) begin
          if (rx_errors < 50)
            $display("%t RX frame %0d byte %0d: %h != %h", $time, rx_idx, rx_off + b,
              rx_tdata[b*8 +: 8], pat(rx_idx, rx_off + b));
          rx_errors = rx_errors + 1;
        end
      end

      if (rx_tlast) begin
        if (rx_off + rx_nkeep != exp_len) begin
          $display("%t RX frame %0d: length %0d != %0d", $time, rx_idx, rx_off + rx_nkeep, exp_len);
          rx_errors = rx_errors + 1;
        end
        if (rx_tuser[0] !== desc_err[rx_idx]) begin
          $display("%t RX frame %0d: error bit %b != %b", $time, rx_idx, rx_tuser[0], desc_err[rx_idx]);
          rx_errors = rx_errors + 1;
        end
        rx_idx = rx_idx + 1;
        rx_off = 0;
      end else begin
        rx_off = rx_off + BW;
      end
    end
  end

  integer ts_idx = 0;
  integer ts_errors = 0;

  always @(posedge clk) begin
    if (tx_ptp_ts_valid) begin
      if (tx_ptp_ts_tag !== ts_idx[15:0] ||
          tx_ptp_ts !== {17'd0, m_tx_ptp_tstamp, 8'd0}) begin
        $display("%t TX ts %0d: tag %h ts %h (model %h)", $time, ts_idx,
          tx_ptp_ts_tag, tx_ptp_ts, m_tx_ptp_tstamp);
        ts_errors = ts_errors + 1;
      end
      ts_idx = ts_idx + 1;
    end
  end

  reg     tx_st_sync_d = 1'b0;
  reg     rx_st_sync_d = 1'b0;
  integer last_sync_cyc = -1;
  integer sync_events = 0;
  integer sync_errors = 0;
  integer ptp_wraps = 0;
  reg [79:0] cvt_in;

  always @(posedge clk) begin
    ptp_time <= ptp_time + PTP_INC;
    ptp_time_d <= ptp_time;
    tx_st_sync_d <= m_tx_st_sync;
    rx_st_sync_d <= m_rx_st_sync;

    if (ptp_time + PTP_INC < ptp_time)
      ptp_wraps = ptp_wraps + 1;

    if (!tx_rst && m_tx_st_sync != tx_st_sync_d) begin
      cvt_in = {32'd0, ptp_time_d} >> 8;
      if (m_tx_systemtimer !== cvt_in[54:0] || m_rx_systemtimer !== cvt_in[54:0]) begin
        $display("%t PTP sync: tx %h rx %h expected %h", $time,
          m_tx_systemtimer, m_rx_systemtimer, cvt_in[54:0]);
        sync_errors = sync_errors + 1;
      end
      if (m_rx_st_sync != m_tx_st_sync) begin
        $display("%t PTP sync: rx st_sync not aligned with tx", $time);
        sync_errors = sync_errors + 1;
      end
      if (!m_tx_st_overwrite || !m_rx_st_overwrite) begin
        $display("%t PTP sync: st_overwrite deasserted", $time);
        sync_errors = sync_errors + 1;
      end
      if (last_sync_cyc >= 0 && cyc - last_sync_cyc != 32) begin
        $display("%t PTP sync: interval %0d != 32", $time, cyc - last_sync_cyc);
        sync_errors = sync_errors + 1;
      end
      last_sync_cyc = cyc;
      sync_events = sync_events + 1;
    end
  end

  integer overflow_pulses = 0;
  always @(posedge clk)
    if (rx_fifo_overflow)
      overflow_pulses = overflow_pulses + 1;

  always @(posedge clk)
    if (cyc % 100000 == 0)
      $display("%t HB: queued %0d sent %0d model tx %0d rx %0d checked %0d tx ts %0d",
        $time, desc_wr, tx_rd, model_tx_frames, model_rx_frames, rx_idx, ts_idx);

  task queue_frame;
    input integer len;
    input err;
    begin
      desc_len[desc_wr] = len;
      desc_err[desc_wr] = err;
      desc_wr = desc_wr + 1;
    end
  endtask

  task wait_all;
    input integer max_cycles;
    integer start;
    begin
      start = cyc;
      while ((model_rx_frames < desc_wr || ts_idx < desc_wr) && cyc - start < max_cycles)
        @(posedge clk);
      while (rx_idx < desc_wr && cyc - start < max_cycles + 4096)
        @(posedge clk);
      if (model_rx_frames < desc_wr || ts_idx < desc_wr) begin
        $display("TIMEOUT: queued %0d, model rx %0d, checked %0d, tx ts %0d",
          desc_wr, model_rx_frames, rx_idx, ts_idx);
        failed <= 1'b1;
      end
      if (rx_idx < desc_wr) begin
        rx_dropped = rx_dropped + desc_wr - rx_idx;
        rx_idx = desc_wr;
      end
      repeat (64) @(posedge clk);
    end
  endtask

  task check;
    input [8*40-1:0] name;
    input cond;
    begin
      if (cond)
        $display("PASS  %0s", name);
      else begin
        $display("FAIL  %0s", name);
        failed <= 1'b1;
      end
    end
  endtask

  integer i, n0, err0, drop0, ovf0;
  integer elapsed;
  reg     all_done = 1'b0;

  initial begin
    #(`TIMEOUT - 1);
    if (!all_done) begin
      $display("FAIL  tests did not complete before TIMEOUT");
      failed <= 1'b1;
    end
  end

  initial begin
    @(negedge reset);
    repeat (32) @(posedge clk);

    tx_ready_mode = 2'd1;
    rx_overdrive = 1'b0;
    tx_gaps = 1'b1;
    err0 = rx_errors;
    drop0 = rx_dropped;
    queue_frame(1, 0);
    queue_frame(31, 0);
    queue_frame(32, 0);
    queue_frame(33, 0);
    queue_frame(59, 0);
    queue_frame(60, 0);
    queue_frame(61, 0);
    queue_frame(64, 0);
    queue_frame(65, 0);
    queue_frame(383, 0);
    queue_frame(384, 0);
    queue_frame(385, 0);
    queue_frame(1518, 0);
    queue_frame(9000, 0);
    queue_frame(9214, 0);
    queue_frame(60, 1);
    queue_frame(500, 1);
    queue_frame(9214, 1);
    for (i = 0; i < N_BIG; i = i + 1)
      queue_frame(60 + ({$random} % (9214 - 60 + 1)), 0);
    wait_all(2000000);
    check("test_frame_sizes", rx_errors == err0 && rx_dropped == drop0 && model_errors == 0);
    check("test_tx_error_propagation", rx_errors == err0);

    tx_ready_mode = 2'd2;
    rx_overdrive = 1'b0;
    tx_gaps = 1'b0;
    err0 = rx_errors;
    drop0 = rx_dropped;
    first_accept_cyc = -1;
    for (i = 0; i < 4096; i = i + 1)
      queue_frame(60, 0);
    wait_all(200000);
    elapsed = last_accept_cyc - first_accept_cyc;
    $display("line-rate paced: 4096 x 60 B in %0d cycles (line rate = %0d)", elapsed, LINE_CYCLES);
    check("test_min_frame_line_rate (paced)", rx_errors == err0 && rx_dropped == drop0 &&
      model_errors == 0 && elapsed <= LINE_CYCLES * 101 / 100 + 64);

    tx_ready_mode = 2'd0;
    rx_overdrive = 1'b0;
    err0 = rx_errors;
    drop0 = rx_dropped;
    first_accept_cyc = -1;
    for (i = 0; i < 4096; i = i + 1)
      queue_frame(60, 0);
    wait_all(200000);
    elapsed = last_accept_cyc - first_accept_cyc;
    $display("capacity: 4096 x 60 B in %0d cycles", elapsed);
    check("test_min_frame_line_rate (capacity)", rx_errors == err0 && rx_dropped == drop0 &&
      model_errors == 0 && elapsed <= LINE_CYCLES);

    err0 = rx_errors;
    drop0 = rx_dropped;
    ovf0 = overflow_pulses;
    for (i = 0; i < 4000; i = i + 1)
      queue_frame(60 + ({$random} % 241), 0);
    wait_all(400000);
    check("test_small_frames_line_rate", rx_errors == err0 && rx_dropped == drop0 &&
      overflow_pulses == ovf0 && model_errors == 0);

    rx_overdrive = 1'b1;
    err0 = rx_errors;
    drop0 = rx_dropped;
    ovf0 = overflow_pulses;
    for (i = 0; i < N_OVR; i = i + 1)
      queue_frame(60 + ({$random} % (9214 - 60 + 1)), 0);
    for (i = 0; i < 1000; i = i + 1)
      queue_frame(60 + ({$random} % 241), 0);
    wait_all(2000000);
    $display("overdrive: %0d of %0d frames dropped, %0d overflow pulses",
      rx_dropped - drop0, N_OVR + 1000, overflow_pulses - ovf0);
    check("test_overdrive_drops_whole", rx_errors == err0 && model_errors == 0 &&
      rx_dropped - drop0 == overflow_pulses - ovf0);
    rx_overdrive = 1'b0;

    tx_ready_mode = 2'd0;
    tx_gaps = 1'b0;
    err0 = rx_errors;
    drop0 = rx_dropped;
    n0 = ts_errors;
    for (i = 0; i < 8; i = i + 1) begin
      queue_frame(64, 0);
      queue_frame(65, 0);
      queue_frame(1518, 0);
      queue_frame(9214, 0);
    end
    wait_all(2000000);
    check("test_jumbo_25g", rx_errors == err0 && rx_dropped == drop0 &&
      model_errors == 0 && ts_errors == n0 && ts_idx == desc_wr);

    check("test_ptp_tag_and_ts", ts_errors == 0 && ts_idx == desc_wr);
    $display("ptp: %0d sync events, %0d wraps of the 48-bit rel time", sync_events, ptp_wraps);
    check("test_ptp_wrap", sync_errors == 0 && sync_events > 100 && ptp_wraps >= 1);

    check("rx_status", rx_status === 1'b1);
    $display("frames: queued %0d, model tx %0d rx %0d, checked %0d", desc_wr,
      model_tx_frames, model_rx_frames, rx_idx);
    all_done = 1'b1;
  end

endmodule
