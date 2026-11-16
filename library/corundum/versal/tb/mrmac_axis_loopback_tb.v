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
`define TIMEOUT 40000000
`else
`define TIMEOUT 4000000
`endif
`endif

module mrmac_axis_loopback_tb;

  parameter VCD_FILE = "mrmac_axis_loopback_tb.vcd";

  `include "tb_base.v"

`ifdef MODE_4X25G
  localparam SEG_COUNT   = 1;
`elsif MODE_1X40G
  localparam SEG_COUNT   = 4;
`else
  localparam SEG_COUNT   = 6;
`endif

  localparam W     = SEG_COUNT * 64;
  localparam KW    = SEG_COUNT * 11;
  localparam BYTES = SEG_COUNT * 8;

  // frame header: dst, src, marker (2), id (4), len (2) = 20 bytes
  localparam HB = (20 + BYTES - 1) / BYTES;

  function integer rnd;
    input integer lo;
    input integer hi;
    begin
      rnd = lo + ({$random} % (hi - lo + 1));
    end
  endfunction

  reg loopback_en = 1'b0;
  reg mac_swap = 1'b1;

  reg  [W-1:0] rx_tdata = 0;
  reg  [KW-1:0]  rx_kuser = 0;
  reg          rx_tvalid = 1'b0;
  reg          rx_tlast = 1'b0;

  wire [W-1:0] srx_tdata;
  wire [KW-1:0]  srx_kuser;
  wire         srx_tvalid;
  wire         srx_tlast;

  reg  [W-1:0] stx_tdata = 0;
  reg  [KW-1:0]  stx_kuser = 0;
  reg          stx_tvalid = 1'b0;
  reg          stx_tlast = 1'b0;
  wire         stx_tready;
  reg  [15:0]  stx_tag = 16'd0;
  wire [15:0]  tx_tag;

  wire [W-1:0] tx_tdata;
  wire [KW-1:0]  tx_kuser;
  wire         tx_tvalid;
  wire         tx_tlast;
  reg          tx_tready = 1'b1;

  wire [31:0]  lb_frames;
  wire [31:0]  lb_drops;

  mrmac_axis_loopback #(.SEG_COUNT(SEG_COUNT)) dut (
    .clk(clk), .resetn(!reset),
    .loopback_en(loopback_en), .mac_swap(mac_swap),
    .mrmac_rx_axis_tdata(rx_tdata), .mrmac_rx_axis_tkeep_user(rx_kuser),
    .mrmac_rx_axis_tvalid(rx_tvalid), .mrmac_rx_axis_tlast(rx_tlast),
    .shim_rx_axis_tdata(srx_tdata), .shim_rx_axis_tkeep_user(srx_kuser),
    .shim_rx_axis_tvalid(srx_tvalid), .shim_rx_axis_tlast(srx_tlast),
    .shim_tx_axis_tdata(stx_tdata), .shim_tx_axis_tkeep_user(stx_kuser),
    .shim_tx_axis_tvalid(stx_tvalid), .shim_tx_axis_tlast(stx_tlast),
    .shim_tx_axis_tready(stx_tready),
    .shim_tx_ptp_tag_field(stx_tag),
    .mrmac_tx_axis_tdata(tx_tdata), .mrmac_tx_axis_tkeep_user(tx_kuser),
    .mrmac_tx_axis_tvalid(tx_tvalid), .mrmac_tx_axis_tlast(tx_tlast),
    .mrmac_tx_axis_tready(tx_tready),
    .mrmac_tx_ptp_tag_field(tx_tag),
    .lb_frames(lb_frames), .lb_drops(lb_drops)
  );

  localparam [47:0] MAC_A = 48'h0a0b0c0d0e0f;
  localparam [47:0] MAC_B = 48'h112233445566;

  // frame f: first 20 bytes = dst, src, marker (2), id (4), len (2), then a
  // pattern derived from (f, beat); the header spans HB beats
  function automatic [W-1:0] beat_data(input [15:0] marker, input [31:0] f,
                                       input [15:0] len, input integer k);
    reg [W-1:0] d;
    reg [159:0] hd;
    integer i, p;
    begin
      for (i = 0; i < W/32; i = i + 1)
        d[i*32 +: 32] = f*32'h9e3779b9 + k*32'h85ebca6b + i*32'h01000193;
      hd = {len, f, marker, MAC_B, MAC_A};
      for (i = 0; i < BYTES; i = i + 1) begin
        p = k*BYTES + i;
        if (p < 20)
          d[i*8 +: 8] = hd[p*8 +: 8];
      end
      beat_data = d;
    end
  endfunction

  function automatic [KW-1:0] kuser_for(input integer bytes_last, input bad);
    reg [KW-1:0] ku;
    integer w, n;
    begin
      ku = 0;
      for (w = 0; w < SEG_COUNT; w = w + 1) begin
        n = bytes_last - w*8;
        if (n >= 8) ku[w*11 +: 8] = 8'hff;
        else if (n > 0) ku[w*11 +: 8] = (8'h1 << n) - 1;
      end
      ku[8] = bad;
      kuser_for = ku;
    end
  endfunction

  localparam TOG_BASE = 10000;
  localparam TOG_N = 300;
  integer tog_seen [0:TOG_N-1];

  integer errors = 0;
  integer rx_sent = 0, rx_bad_sent = 0, stx_sent = 0;
  integer lb_seen = 0, stx_seen = 0, srx_seen = 0;
  integer last_lb_id = -1, last_stx_id = -1, last_srx_id = -1;
  integer bad_ids [0:4095];
  integer n_bad = 0;

  reg rx_nogap = 1'b0;
  reg rx_gaps = 1'b1;

  task automatic send_rx(input [31:0] f, input integer len, input bad);
    integer nb, k;
    begin
      nb = (len + BYTES - 1) / BYTES;
      for (k = 0; k < nb; k = k + 1) begin
        rx_tdata  <= beat_data(16'h00a0, f, len, k);
        rx_tlast  <= (k == nb-1);
        rx_kuser  <= (k == nb-1) ? kuser_for(len - k*BYTES, bad) : 0;
        rx_tvalid <= 1'b1;
        @(posedge clk);
        if (rx_gaps && k < nb-1 && rnd(0, 3) == 0) begin
          rx_tvalid <= 1'b0;
          rx_tlast <= 1'b0;
          repeat (rnd(1, 3)) @(posedge clk);
        end
      end
      rx_tvalid <= 1'b0;
      rx_tlast <= 1'b0;
      if (!rx_nogap)
        repeat (rnd(0, 3)) @(posedge clk);
    end
  endtask

  initial begin : rx_gen
    integer f, len;
    reg bad;
    wait (!reset);
    repeat (20) @(posedge clk);
    for (f = 0; f < 1500; f = f + 1) begin
      case (rnd(0, 9))
        0: len = 9214;
        1, 2: len = 64;
        default: len = rnd(64, 1518);
      endcase
      bad = (rnd(0, 19) == 0);
      if (bad) begin bad_ids[n_bad] = f; n_bad = n_bad + 1; end
      send_rx(f, len, bad);
      rx_sent = rx_sent + 1;
      if (bad) rx_bad_sent = rx_bad_sent + 1;
    end
  end

  initial begin : stx_gen
    integer f, len, nb, k;
    wait (!reset);
    repeat (25) @(posedge clk);
    for (f = 0; f < 800; f = f + 1) begin
      len = rnd(64, 1518);
      nb = (len + BYTES - 1) / BYTES;
      for (k = 0; k < nb; k = k + 1) begin
        stx_tdata  <= beat_data(16'h00c0, f, len, k);
        stx_tag    <= f[15:0];
        stx_tlast  <= (k == nb-1);
        stx_kuser  <= (k == nb-1) ? kuser_for(len - k*BYTES, 1'b0) : {SEG_COUNT{11'h0ff}};
        stx_tvalid <= 1'b1;
        @(posedge clk);
        while (!stx_tready) @(posedge clk);
      end
      stx_tvalid <= 1'b0;
      stx_tlast <= 1'b0;
      stx_sent = stx_sent + 1;
      repeat (rnd(0, 20)) @(posedge clk);
    end
  end

  task automatic send_stx(input [31:0] f, input integer len);
    integer nb, k;
    begin
      nb = (len + BYTES - 1) / BYTES;
      for (k = 0; k < nb; k = k + 1) begin
        stx_tdata  <= beat_data(16'h00c0, f, len, k);
        stx_tag    <= f[15:0];
        stx_tlast  <= (k == nb-1);
        stx_kuser  <= (k == nb-1) ? kuser_for(len - k*BYTES, 1'b0) : {SEG_COUNT{11'h0ff}};
        stx_tvalid <= 1'b1;
        @(posedge clk);
        while (!stx_tready) @(posedge clk);
      end
      stx_tvalid <= 1'b0;
      stx_tlast <= 1'b0;
    end
  endtask

  always @(posedge clk) tx_tready <= (rnd(0, 9) != 0);

  initial begin
    wait (!reset);
    repeat (2000) @(posedge clk);
    loopback_en <= 1'b1;
    repeat (15000) @(posedge clk);
    loopback_en <= 1'b0;
    repeat (3000) @(posedge clk);
    loopback_en <= 1'b1;
    repeat (12000) @(posedge clk);
    loopback_en <= 1'b0;
  end

  task automatic check_beat(input [8*16-1:0] name, input [W-1:0] d, input [KW-1:0] ku,
                            input last, input swapped, inout integer k,
                            inout integer cur_id, inout integer cur_len,
                            inout integer cur_mark, inout integer last_id,
                            inout integer seen, inout [HB*W-1:0] hb);
    reg [HB*W-1:0] h;
    reg [W-1:0] exp;
    reg [KW-1:0] ek;
    integer nb, j, w;
    begin
      if (k < HB)
        hb[k*W +: W] = d;
      if (k == HB-1 || (last && k < HB-1)) begin
        h = hb;
        if (swapped) h[95:0] = {hb[47:0], hb[95:48]};
        if (h[47:0] != MAC_A || h[95:48] != MAC_B) begin
          $display("%t %0s: bad MACs %h", $time, name, hb[95:0]); errors = errors + 1;
        end
        cur_mark = h[111:96];
        cur_id = h[143:112];
        cur_len = h[159:144];
        if (cur_id <= last_id) begin
          $display("%t %0s: frame %0d after %0d", $time, name, cur_id, last_id); errors = errors + 1;
        end
        for (j = 0; j <= k; j = j + 1)
          if (h[j*W +: W] != beat_data(cur_mark, cur_id, cur_len, j)) begin
            $display("%t %0s: frame %0d beat %0d data mismatch", $time, name, cur_id, j); errors = errors + 1;
          end
      end else if (k >= HB) begin
        exp = beat_data(cur_mark, cur_id, cur_len, k);
        if (d != exp) begin
          $display("%t %0s: frame %0d beat %0d data mismatch", $time, name, cur_id, k); errors = errors + 1;
        end
      end
      nb = (cur_len + BYTES - 1) / BYTES;
      if (last != (k == nb-1)) begin
        $display("%t %0s: frame %0d tlast at beat %0d of %0d", $time, name, cur_id, k, nb); errors = errors + 1;
      end
      ek = kuser_for(cur_len - k*BYTES, 1'b0);
      if (last)
        for (w = 0; w < SEG_COUNT; w = w + 1)
          if (ku[w*11 +: 8] != ek[w*11 +: 8]) begin
            $display("%t %0s: frame %0d bad last keep", $time, name, cur_id); errors = errors + 1;
          end
      if (last) begin
        last_id = cur_id;
        seen = seen + 1;
        if (cur_id >= TOG_BASE && cur_id < TOG_BASE + TOG_N)
          tog_seen[cur_id - TOG_BASE] = tog_seen[cur_id - TOG_BASE] + 1;
        k = 0;
      end else begin
        k = k + 1;
      end
    end
  endtask

  integer tk = 0, tid = 0, tlen = 0, tmark = 0, t_in = 0, t_cor = 0, t_tag = 0;
  integer sk = 0, sid = 0, slen = 0, smark = 0;
  reg [HB*W-1:0] thb_c = 0, thb_l = 0, shb = 0;
  integer i;

  always @(posedge clk) begin
    if (!reset) begin
      if (t_in && !tx_tvalid) begin
        $display("%t TX: tvalid dropped inside a frame", $time); errors = errors + 1;
      end
      if (tx_tvalid && tx_tready) begin
        t_in = !tx_tlast;
        if (tk == 0) t_cor = (tx_tdata[47:0] == MAC_A);
        if (t_cor) begin
          if (tk == 0) t_tag = tx_tag;
          if (tx_tag != t_tag) begin
            $display("%t TX corundum: PTP tag changed inside a frame", $time); errors = errors + 1;
          end
          check_beat("TX corundum", tx_tdata, tx_kuser, tx_tlast, 1'b0, tk, tid, tlen, tmark, last_stx_id, stx_seen, thb_c);
          if (tk == HB && t_tag != tid[15:0]) begin
            $display("%t TX corundum: PTP tag %h on frame %0d", $time, t_tag, tid); errors = errors + 1;
          end
        end else
          check_beat("TX loopback", tx_tdata, tx_kuser, tx_tlast, mac_swap, tk, tid, tlen, tmark, last_lb_id, lb_seen, thb_l);
        if (tx_tlast && !t_cor)
          for (i = 0; i < n_bad; i = i + 1)
            if (bad_ids[i] == tid) begin
              $display("%t TX: bad-FCS frame %0d looped", $time, tid); errors = errors + 1;
            end
      end
      if (srx_tvalid)
        check_beat("RX corundum", srx_tdata, srx_kuser, srx_tlast, 1'b0, sk, sid, slen, smark, last_srx_id, srx_seen, shb);
    end
  end

  reg all_done = 1'b0;

  initial begin
    #(`TIMEOUT - 1);
    if (!all_done) begin
      $display("FAIL  tests did not complete before TIMEOUT");
      failed <= 1'b1;
    end
  end

  initial begin
    wait (rx_sent == 1500 && stx_sent == 800);
    repeat (3000) @(posedge clk);
    $display("RX sent %0d (%0d bad FCS); corundum TX sent %0d", rx_sent, rx_bad_sent, stx_sent);
    $display("looped %0d, to corundum RX %0d, corundum TX out %0d; lb_frames %0d lb_drops %0d",
             lb_seen, srx_seen, stx_seen, lb_frames, lb_drops);
    if (lb_seen == 0 || srx_seen == 0 || stx_seen == 0) begin
      $display("no traffic on one of the paths"); errors = errors + 1;
    end
    if (lb_seen + srx_seen + lb_drops > rx_sent) begin
      $display("more RX frames out than in"); errors = errors + 1;
    end
    if (errors != 0) failed <= 1'b1;

    test_loopback_toggle_64b;
    all_done = 1'b1;
  end

  localparam STX_BASE = 20000;
  localparam STX_N = 150;

  task test_loopback_toggle_64b;
    integer f, g, len, e0, s0, l0, d0, x0, ok, misses, dups, stx_misses, x1;
    begin
      for (f = 0; f < TOG_N; f = f + 1) tog_seen[f] = 0;
      e0 = errors; s0 = srx_seen; l0 = lb_seen; d0 = lb_drops; x0 = stx_seen;
      rx_nogap = 1'b1;
      rx_gaps = 1'b0;
      loopback_en <= 1'b0;
      repeat (8) @(posedge clk);
      fork
        begin
          for (f = 0; f < TOG_N - 10; f = f + 1) begin
            if (f % 3 == 0) loopback_en <= !loopback_en;
            len = rnd(64, 400);
            send_rx(TOG_BASE + f, len, 1'b0);
          end
          loopback_en <= 1'b1;
          repeat (16) @(posedge clk);
          for (f = TOG_N - 10; f < TOG_N; f = f + 1) begin
            len = rnd(64, 400);
            send_rx(TOG_BASE + f, len, 1'b0);
          end
        end
        begin
          for (g = 0; g < STX_N; g = g + 1) begin
            send_stx(STX_BASE + g, rnd(64, 400));
            repeat (rnd(0, 5)) @(posedge clk);
          end
        end
      join
      rx_nogap = 1'b0;
      rx_gaps = 1'b1;
      repeat (3000) @(posedge clk);
      loopback_en <= 1'b0;
      repeat (3000) @(posedge clk);
      x1 = stx_seen - x0;
      for (g = 0; g < 10; g = g + 1)
        send_stx(STX_BASE + STX_N + g, rnd(64, 400));
      repeat (3000) @(posedge clk);
      misses = 0;
      dups = 0;
      for (f = 0; f < TOG_N; f = f + 1) begin
        if (tog_seen[f] > 1) dups = dups + 1;
        if (tog_seen[f] == 0 && f >= TOG_N - 10) misses = misses + 1;
      end
      stx_misses = 10 - (stx_seen - x0 - x1);
      $display("toggle: %0d frames, to corundum RX %0d, looped %0d, drops %0d, duplicated %0d, lost in closing run %0d",
               TOG_N, srx_seen - s0, lb_seen - l0, lb_drops - d0, dups, misses);
      $display("toggle: corundum TX %0d of %0d out while toggling, %0d of 10 in the closing run",
               x1, STX_N, 10 - stx_misses);
      ok = (errors == e0) && misses == 0 && dups == 0 && lb_drops == d0 &&
           (srx_seen - s0) > 0 && (lb_seen - l0) > 0 &&
           (srx_seen - s0) + (lb_seen - l0) <= TOG_N &&
           x1 > 0 && x1 <= STX_N && stx_misses == 0;
      if (ok)
        $display("PASS  test_loopback_toggle_64b");
      else begin
        $display("FAIL  test_loopback_toggle_64b");
        failed <= 1'b1;
      end
    end
  endtask

endmodule
