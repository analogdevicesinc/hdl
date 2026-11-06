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

// util_sample_pack test with the join FIFO.
//
// NUM_CH channels run on clocks of the same period and their own phase and
// deliver CH_SLOTS slots per word with the same gap pattern, each channel a
// few cycles behind the previous one. Slot s of word n of channel c carries
// {c, s, n}. The packer runs on clk. Every run sets an enable mask and a
// sample size while xfer_req is low, then requests a transfer.
//
// Checked: after every request the packed words follow the round order from a
// round start, with consecutive n on all channels, and osync marks the words
// that start a round; no word leaves while xfer_req is low; every overflow
// pulse of the DMA reaches every channel and no channel FIFO overflows. With
// CH_SLOTS = 2 every sample_slots_select is valid; ad_sample_pack_tb covers
// the invalid ones.

`timescale 1ns/100ps

module util_sample_pack_tb;

  localparam NUM_CH   = 4;
  localparam CH_SLOTS = 2;
  localparam SLOT_W   = 16;
  localparam N        = NUM_CH*CH_SLOTS;
  localparam MW       = $clog2(CH_SLOTS+1);
  localparam LW       = (CH_SLOTS >= 256) ? 4 : (CH_SLOTS >= 16) ? 3 : (CH_SLOTS >= 4) ? 2 : 1;
  localparam PERIOD   = 10.0;

  reg              clk = 1'b0;
  reg              async_resetn = 1'b0;
  reg  [NUM_CH-1:0] ch_clk_raw = 'd0;
  // the channel clocks stop while async_resetn is low, as the converter clocks do
  wire [NUM_CH-1:0] ch_clk = ch_clk_raw & {NUM_CH{async_resetn}};
  reg  [NUM_CH-1:0] en = 'd0;
  reg  [MW-1:0]    ss = 'd1;
  // en_in/ss_select_in drive the packer; en/ss are the model, they differ when a run changes them mid transfer
  reg  [NUM_CH-1:0] en_in = 'd0;
  reg  [LW-1:0]    ss_select_in = 'd0;
  reg              xfer_req = 1'b0;
  reg              dma_ovf = 1'b0;

  wire             out_en;
  wire [N*SLOT_W-1:0] out_data;
  wire             out_sync;
  wire [NUM_CH-1:0] ch_ovf;

  integer errors = 0;
  integer i;

  always #(PERIOD/2) clk = ~clk;

  genvar c;
  generate
  for (c = 0; c < NUM_CH; c = c + 1) begin : g_ch
    localparam [3:0] CI = c;
    reg  [31:0]              t = 0;
    reg  [7:0]               n = 0;
    reg                      valid = 1'b0;
    reg  [CH_SLOTS*SLOT_W-1:0] data = 'd0;
    integer                  s;
    integer                  ovf_got = 0;

    initial begin
      #(1.3 + 2.1*c);
      forever #(PERIOD/2) ch_clk_raw[c] = ~ch_clk_raw[c];
    end

    // the same gap pattern on every channel, 3 words out of 5 cycles, c cycles late
    always @(posedge ch_clk[c]) begin
      t <= t + 1;
      valid <= (t >= 8 + c) && (((t - c) * 7) % 5 < 3);
      if ((t >= 8 + c) && (((t - c) * 7) % 5 < 3)) begin
        for (s = 0; s < CH_SLOTS; s = s + 1)
          data[s*SLOT_W +: SLOT_W] <= {CI, s[3:0], n};
        n <= n + 1;
      end
      if (ch_ovf[c]) ovf_got = ovf_got + 1;
    end
  end
  endgenerate

  util_sample_pack #(
    .SLOT_W(SLOT_W),
    .NUM_CH(NUM_CH),
    .CH_SLOTS(CH_SLOTS),
    .ENABLE_SAMPLE_SLOTS_SELECT(1),
    .CONFIG_CDC(1),
    .JOIN_FIFO_ENABLE(1),
    .XFER_REQ_ENABLE(1),
    .OVERFLOW_XFER_REQ(1),
    .CONFIG_XFER_HOLD(1)
  ) i_dut (
    .async_resetn(async_resetn),
    .clk_0(ch_clk[0]), .reset_0(1'b0), .valid_0(g_ch[0].valid), .data_0(g_ch[0].data), .enable_0(en_in[0]), .overflow_0(ch_ovf[0]),
    .clk_1(ch_clk[1]), .reset_1(1'b0), .valid_1(g_ch[1].valid), .data_1(g_ch[1].data), .enable_1(en_in[1]), .overflow_1(ch_ovf[1]),
    .clk_2(ch_clk[2]), .reset_2(1'b0), .valid_2(g_ch[2].valid), .data_2(g_ch[2].data), .enable_2(en_in[2]), .overflow_2(ch_ovf[2]),
    .clk_3(ch_clk[3]), .reset_3(1'b0), .valid_3(g_ch[3].valid), .data_3(g_ch[3].data), .enable_3(en_in[3]), .overflow_3(ch_ovf[3]),
    .clk(clk),
    .reset(1'b0),
    .sample_slots_select(ss_select_in),
    .slot_enable({N{1'b1}}),
    .packed_fifo_wr_en(out_en),
    .packed_fifo_wr_data(out_data),
    .packed_fifo_wr_overflow(dma_ovf),
    .packed_fifo_wr_xfer_req(xfer_req),
    .packed_sync(out_sync));

  // Model of the round order: position idx of the K slots of word n.
  integer kk, k_slots, m_idx, m_q, m_r, m_w, m_g, m_c, m_cnt, m_s;
  reg [7:0] m_n;
  reg       resync = 1'b0;
  integer   words = 0;
  integer   low_cnt = 0;

  function [SLOT_W-1:0] expect_slot(input integer idx, input [7:0] nn);
    integer q, r, w, g, cc, cnt, ch;
    reg [3:0] sv;
    begin
      q = idx / ss;
      g = idx % ss;
      r = q % kk;
      w = q / kk;
      cnt = 0;
      ch = 0;
      for (cc = 0; cc < NUM_CH; cc = cc + 1) begin
        if (en[cc]) begin
          if (cnt == r) ch = cc;
          cnt = cnt + 1;
        end
      end
      sv = w*ss + g;
      expect_slot = {ch[3:0], sv, nn};
    end
  endfunction

  always @(posedge clk) begin
    low_cnt <= xfer_req ? 0 : low_cnt + 1;
    if (out_en) begin
      words = words + 1;
      if (low_cnt > 16) begin
        errors = errors + 1;
        if (errors <= 10) $display("ERROR %0t: word with xfer_req low", $time);
      end
      for (i = 0; i < N; i = i + 1) begin
        if (resync && i == 0) begin
          m_n    = out_data[7:0];
          m_idx  = 0;
          resync = 1'b0;
        end
        if (out_data[i*SLOT_W +: SLOT_W] !== expect_slot(m_idx, m_n)) begin
          errors = errors + 1;
          if (errors <= 10)
            $display("ERROR %0t: en %b ss %0d slot %0d got %h expected %h", $time,
                     en, ss, i, out_data[i*SLOT_W +: SLOT_W], expect_slot(m_idx, m_n));
        end
        if (i == 0 && out_sync !== (m_idx % (kk*ss) == 0)) begin
          errors = errors + 1;
          if (errors <= 10)
            $display("ERROR %0t: en %b ss %0d osync %b at position %0d", $time, en, ss, out_sync, m_idx);
        end
        m_idx = m_idx + 1;
        if (m_idx == k_slots) begin
          m_idx = 0;
          m_n = m_n + 1;
        end
      end
    end
  end

  // DMA overflow pulses on clk; every channel counts them on its own clock.
  integer ovf_sent = 0;
  reg [6:0] oc = 0;
  reg       ovf_on = 1'b1;

  always @(posedge clk) begin
    oc <= oc + 1;
    dma_ovf <= (oc == 0) && async_resetn && ovf_on;
    if (dma_ovf) ovf_sent = ovf_sent + 1;
  end

  task run(input [NUM_CH-1:0] mask, input [MW-1:0] size, input integer cycles, input integer min_words,
           input disturb);
    integer start;
    begin
      @(posedge clk);
      xfer_req <= 1'b0;
      repeat (40) @(posedge clk);
      en <= mask;
      ss <= size;
      en_in <= mask;
      ss_select_in <= (size == 2);
      kk = 0;
      for (i = 0; i < NUM_CH; i = i + 1) kk = kk + mask[i];
      k_slots = kk * CH_SLOTS;
      // enable crossing and the table fill of the packer
      repeat (N*(N+2) + 60) @(posedge clk);
      resync <= 1'b1;
      xfer_req <= 1'b1;
      start = words;
      // a driver that changes the channels mid transfer: the held layout must go on
      if (disturb) begin
        repeat (cycles/2) @(posedge clk);
        en_in <= ~mask;
        ss_select_in <= (size != 2);
        repeat (cycles - cycles/2) @(posedge clk);
      end else begin
        repeat (cycles) @(posedge clk);
      end
      $display("run en %b ss %0d%s: %0d words", mask, size, disturb ? " changed mid transfer" : "", words - start);
      if (words - start < min_words) begin
        errors = errors + 1;
        $display("ERROR: en %b ss %0d: %0d words, at least %0d expected", mask, size, words - start, min_words);
      end
      if (min_words == 0 && words != start) begin
        errors = errors + 1;
        $display("ERROR: en %b ss %0d: output with an invalid sample size", mask, size);
      end
    end
  endtask

  initial begin
    #(20*PERIOD);
    async_resetn = 1'b1;
    run(4'b1111, 1, 2000, 300, 0);
    run(4'b0101, 2, 2000, 300, 0);
    run(4'b1011, 1, 2000, 300, 0);
    run(4'b1110, 2, 2000, 300, 0);
    run(4'b0001, 1, 2000, 100, 0);
    run(4'b1000, 2, 2000, 100, 0);
    run(4'b0101, 1, 2000, 300, 1);
    run(4'b1011, 2, 2000, 300, 1);
    @(posedge clk);
    xfer_req <= 1'b0;
    ovf_on <= 1'b0;
    repeat (100) @(posedge clk);
    $display("overflow: sent %0d, got %0d %0d %0d %0d", ovf_sent,
             g_ch[0].ovf_got, g_ch[1].ovf_got, g_ch[2].ovf_got, g_ch[3].ovf_got);
    if (g_ch[0].ovf_got != ovf_sent || g_ch[1].ovf_got != ovf_sent ||
        g_ch[2].ovf_got != ovf_sent || g_ch[3].ovf_got != ovf_sent) begin
      errors = errors + 1;
      $display("ERROR: overflow counts");
    end
    if (errors == 0)
      $display("SUCCESS");
    else
      $display("FAILED %0d errors", errors);
    $finish;
  end

  initial begin
    #5000000;
    $display("FAILED timeout");
    $finish;
  end

endmodule
