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

// SEG_COUNT x 64b words (6 = 1x100G, 4 = 1x40G, 1 = one 25G port)

// tx_ready_mode: 0 = always ready, 1 = random, 2 = paced at line rate
// rx_overdrive:  0 = RX paced at line rate, 1 = back-to-back (no IFG)

`timescale 1ns/100ps

module mrmac_ns_loopback_model #(
  parameter SEG_COUNT = 6,
  parameter TS_WIDTH = 55,
  parameter [TS_WIDTH-1:0] TS_START = 0,
  parameter [TS_WIDTH-1:0] TS_INC = 55'd655,
  parameter MEM_ADDR_W = 22,
  parameter FRM_ADDR_W = 14,
  parameter TX_TS_DELAY = 8,
  // line rate per 390.625 MHz client clock: 32 bytes at 100 Gb/s, 8 at
  // 25 Gb/s, 64 bytes per 5 clocks (12.8) at 40 Gb/s
  parameter LINE_BYTES_NUM = (SEG_COUNT == 1) ? 8 : (SEG_COUNT == 4) ? 64 : 32,
  parameter LINE_BYTES_DEN = (SEG_COUNT == 4) ? 5 : 1
) (
  input  wire                  clk,
  input  wire                  rst,

  input  wire [1:0]            tx_ready_mode,
  input  wire                  rx_overdrive,

  input  wire [SEG_COUNT*64-1:0]          tx_axis_tdata,
  input  wire [SEG_COUNT*11-1:0]           tx_axis_tkeep_user,
  input  wire                  tx_axis_tvalid,
  output wire                  tx_axis_tready,
  input  wire                  tx_axis_tlast,

  output reg  [SEG_COUNT*64-1:0]          rx_axis_tdata = 0,
  output reg  [SEG_COUNT*11-1:0]           rx_axis_tkeep_user = 0,
  output reg                   rx_axis_tvalid = 1'b0,
  output reg                   rx_axis_tlast = 1'b0,

  input  wire [1:0]            tx_ptp_1588op,
  input  wire [15:0]           tx_ptp_tag_field,
  output reg  [TS_WIDTH-1:0]   tx_ptp_tstamp = 0,
  output reg  [15:0]           tx_ptp_tstamp_tag = 0,
  output reg                   tx_ptp_tstamp_valid = 1'b0,
  output wire [TS_WIDTH-1:0]   rx_ptp_tstamp,

  output reg  [31:0]           error_count = 0,
  output reg  [31:0]           tx_frames = 0,
  output reg  [31:0]           rx_frames = 0
);

  localparam MEM_SIZE = 1 << MEM_ADDR_W;
  localparam FRM_SIZE = 1 << FRM_ADDR_W;

  // bytes per beat; per-frame overhead on the wire: FCS 4 + preamble 8 + IFG 12
  localparam integer NB = SEG_COUNT * 8;
  localparam integer FRAME_OVERHEAD = 24;

  reg [7:0] mem [0:MEM_SIZE-1];
  reg [MEM_ADDR_W:0] mem_wr = 0;
  reg [MEM_ADDR_W:0] mem_rd = 0;

  reg [15:0] frm_len [0:FRM_SIZE-1];
  reg        frm_err [0:FRM_SIZE-1];
  reg [FRM_ADDR_W:0] frm_wr = 0;
  reg [FRM_ADDR_W:0] frm_rd = 0;

  reg [TS_WIDTH-1:0] rx_sop_ts [0:FRM_SIZE-1];

  reg [TS_WIDTH-1:0] ts_cnt = TS_START;
  assign rx_ptp_tstamp = ts_cnt;

  reg        tx_in_frame = 1'b0;
  reg [15:0] tx_len = 0;
  integer    tx_credit = 0;

  wire [MEM_ADDR_W:0] mem_used = mem_wr - mem_rd;
  wire [FRM_ADDR_W:0] frm_used = frm_wr - frm_rd;
  wire mem_room = mem_used < (MEM_SIZE - 65536);
  wire frm_room = frm_used < (FRM_SIZE - 4);

  reg tx_ready_q = 1'b0;
  assign tx_axis_tready = tx_ready_q;

  reg [NB-1:0] tx_keep;
  reg [5:0]    tx_nbytes;
  reg        tx_keep_ok;
  integer    i;
  reg        txerr_bad;

  always @* begin
    for (i = 0; i < SEG_COUNT; i = i + 1)
      tx_keep[i*8 +: 8] = tx_axis_tkeep_user[i*11 +: 8];
    tx_nbytes = 0;
    for (i = 0; i < NB; i = i + 1)
      tx_nbytes = tx_nbytes + tx_keep[i];
    tx_keep_ok = (tx_nbytes != 0) &&
                 (tx_keep == ({NB{1'b1}} >> (NB - tx_nbytes)));
  end

  reg [TS_WIDTH-1:0] ts_dly  [0:TX_TS_DELAY-1];
  reg [15:0]         tag_dly [0:TX_TS_DELAY-1];
  reg                vld_dly [0:TX_TS_DELAY-1];

  integer k;

  initial begin
    for (k = 0; k < TX_TS_DELAY; k = k + 1) begin
      ts_dly[k] = 0;
      tag_dly[k] = 0;
      vld_dly[k] = 1'b0;
    end
  end

  always @(posedge clk) begin
    ts_cnt <= ts_cnt + TS_INC;

    if (tx_credit < LINE_BYTES_NUM)
      tx_credit = tx_credit + LINE_BYTES_NUM;

    if (tx_in_frame && !tx_axis_tvalid) begin
      $display("%t MODEL: TX tvalid dropped mid-frame (MRMAC underflow)", $time);
      error_count <= error_count + 1;
    end

    for (k = TX_TS_DELAY-1; k > 0; k = k - 1) begin
      ts_dly[k]  <= ts_dly[k-1];
      tag_dly[k] <= tag_dly[k-1];
      vld_dly[k] <= vld_dly[k-1];
    end
    vld_dly[0] <= 1'b0;

    if (tx_axis_tvalid && tx_axis_tready) begin
      txerr_bad = (tx_axis_tkeep_user[10:9] != 2'b00);
      for (i = 1; i < SEG_COUNT; i = i + 1)
        if (tx_axis_tkeep_user[i*11 + 8]) txerr_bad = 1'b1;
      if (txerr_bad) begin
        $display("%t MODEL: TX ERR/preempt/resume set outside word 0 [8]", $time);
        error_count <= error_count + 1;
      end
      if (!tx_axis_tlast && tx_keep != {NB{1'b1}}) begin
        $display("%t MODEL: TX partial keep on a non-last beat", $time);
        error_count <= error_count + 1;
      end
      if (tx_axis_tlast && !tx_keep_ok) begin
        $display("%t MODEL: TX non-contiguous keep on the last beat", $time);
        error_count <= error_count + 1;
      end
      if (!tx_in_frame) begin
        if (tx_ptp_1588op != 2'b10) begin
          $display("%t MODEL: TX SOP without a 2-step timestamp request", $time);
          error_count <= error_count + 1;
        end
        ts_dly[0]  <= ts_cnt;
        tag_dly[0] <= tx_ptp_tag_field;
        vld_dly[0] <= 1'b1;
      end

      for (i = 0; i < NB; i = i + 1)
        if (i < (tx_axis_tlast ? tx_nbytes : NB))
          mem[(mem_wr + i) % MEM_SIZE] = tx_axis_tdata[i*8 +: 8];
      mem_wr = mem_wr + (tx_axis_tlast ? tx_nbytes : NB);

      if (tx_axis_tlast) begin
        if (tx_len + tx_nbytes < 60) begin
          $display("%t MODEL: TX frame of %0d B, under the 60 B minimum", $time, tx_len + tx_nbytes);
          error_count <= error_count + 1;
        end
        tx_credit = tx_credit - (tx_nbytes + FRAME_OVERHEAD) * LINE_BYTES_DEN;
        frm_len[frm_wr % FRM_SIZE] = tx_len + tx_nbytes;
        frm_err[frm_wr % FRM_SIZE] = tx_axis_tkeep_user[8];
        frm_wr = frm_wr + 1;
        tx_frames <= tx_frames + 1;
        tx_len <= 0;
        tx_in_frame <= 1'b0;
      end else begin
        tx_credit = tx_credit - NB * LINE_BYTES_DEN;
        tx_len <= tx_len + NB;
        tx_in_frame <= 1'b1;
      end
    end

    tx_ptp_tstamp       <= ts_dly[TX_TS_DELAY-1];
    tx_ptp_tstamp_tag   <= tag_dly[TX_TS_DELAY-1];
    tx_ptp_tstamp_valid <= vld_dly[TX_TS_DELAY-1];

    tx_ready_q <= mem_room && frm_room &&
                  (tx_ready_mode == 2'd0 ? 1'b1 :
                   tx_ready_mode == 2'd1 ? (($random & 3) != 0) :
                   (tx_credit >= 0));

    if (rst) begin
      tx_in_frame <= 1'b0;
      tx_len <= 0;
      tx_ready_q <= 1'b0;
    end
  end

  reg        rx_busy = 1'b0;
  reg [15:0] rx_left = 0;
  reg        rx_cur_err = 1'b0;
  integer    rx_credit = 0;
  integer    n;

  always @(posedge clk) begin
    rx_axis_tvalid <= 1'b0;
    rx_axis_tlast <= 1'b0;

    if (rx_credit < LINE_BYTES_NUM)
      rx_credit = rx_credit + LINE_BYTES_NUM;

    if (!rx_busy && frm_rd != frm_wr && (rx_overdrive || rx_credit >= 0)) begin
      rx_busy = 1'b1;
      rx_left = frm_len[frm_rd % FRM_SIZE];
      rx_cur_err = frm_err[frm_rd % FRM_SIZE];
      rx_sop_ts[frm_rd % FRM_SIZE] <= ts_cnt + TS_INC;
      rx_credit = rx_credit - (rx_left + FRAME_OVERHEAD) * LINE_BYTES_DEN;
      frm_rd = frm_rd + 1;
    end

    if (rx_busy) begin
      n = (rx_left > NB) ? NB : rx_left;
      rx_axis_tdata <= 0;
      rx_axis_tkeep_user <= 0;
      for (i = 0; i < NB; i = i + 1) begin
        if (i < n) begin
          rx_axis_tdata[i*8 +: 8] <= mem[(mem_rd + i) % MEM_SIZE];
          if (rx_left <= NB)
            rx_axis_tkeep_user[(i/8)*11 + (i%8)] <= 1'b1;
        end
      end
      mem_rd = mem_rd + n;
      rx_axis_tvalid <= 1'b1;
      if (rx_left <= NB) begin
        rx_axis_tlast <= 1'b1;
        rx_axis_tkeep_user[8] <= rx_cur_err;
        rx_busy = 1'b0;
        rx_frames <= rx_frames + 1;
      end
      rx_left = rx_left - n;
    end

    if (rst) begin
      rx_axis_tvalid <= 1'b0;
      rx_axis_tlast <= 1'b0;
    end
  end

endmodule
