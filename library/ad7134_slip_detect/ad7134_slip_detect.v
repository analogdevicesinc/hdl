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
// AD7134 inter-die frame-slip detector.
//
// Sits between the SPI Engine offload and the DMA as a ZERO-LATENCY wire
// pass-through, and only snoops the handshake. It cannot stall or reorder the
// sample stream because it does not participate in the handshake at all.
//
// One AXI-Stream beat carries all 8 channels of one ODR frame
// (NUM_OF_SDI=8 x DATA_WIDTH=32 = 256 bits), so the two channels of a
// comparator pair are simultaneously present and no realignment is needed.
//
// Two comparator pairs run in parallel and form a built-in control experiment:
//
//   pair 0 - cross-die  (default ch0 vs ch4): the measurement
//   pair 1 - intra-die  (default ch0 vs ch1): the control
//
// Both firing together means the fault is common-mode (parser, DMA, memory
// path). Only pair 0 firing means a genuine inter-die frame slip.
//
// ***************************************************************************
`timescale 1ns/100ps

module ad7134_slip_detect #(
  parameter         ID = 0,
  parameter integer DC_SHIFT = 12,
  parameter integer IDLE_LOG2 = 16,
  parameter [ 3:0]  WIN_LOG2_DEFAULT = 4'd6,
  parameter [ 4:0]  MSB_POS_DEFAULT = 5'd23,
  parameter [ 5:0]  PAIR0_CHAN_DEFAULT = 6'h20,
  parameter [ 5:0]  PAIR1_CHAN_DEFAULT = 6'h08,
  parameter [31:0]  THRESHOLD_DEFAULT = 32'h00100000
) (
  // AXI-Lite

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,

  // sample stream - transparent pass-through

  input                   s_axis_aclk,
  input                   s_axis_aresetn,
  (* mark_debug = "true" *) input                   s_axis_valid,
  output                  s_axis_ready,
  input       [255:0]     s_axis_data,

  output                  m_axis_valid,
  (* mark_debug = "true" *) input                   m_axis_ready,
  output      [255:0]     m_axis_data,

  // ODR pulse, tapped from clkin_aligner/odr_out. Counting it separately from
  // the captured beats is what distinguishes an ODR period the capture path
  // never delivered from one it did.

  input                   odr_in,

  // interrupt

  output                  irq,

  // debug taps for the ILA (phase 2)

  output      [ 1:0]      slip_flag,
  output                  slip_stretch,
  output      [31:0]      dbg_frame,
  output      [31:0]      dbg_env,
  output      [23:0]      dbg_ch_a,
  output      [23:0]      dbg_ch_b,
  output      [24:0]      dbg_d
);

  localparam [31:0] CORE_VERSION = 32'h00000100;   // 0.1.0
  localparam [31:0] CORE_MAGIC   = 32'h534C4950;   // "SLIP"

  localparam [11:0] STRETCH_LEN = 12'hfff;

  // up_axi <-> regmap

  wire            up_clk;
  wire            up_rstn;
  wire            up_wreq;
  wire    [13:0]  up_waddr;
  wire    [31:0]  up_wdata;
  wire            up_wack;
  wire            up_rreq;
  wire    [13:0]  up_raddr;
  wire    [31:0]  up_rdata;
  wire            up_rack;

  // configuration in the sample stream domain

  wire            ext_resetn;
  wire            detect_en;
  wire            auto_clr_on_idle;
  wire            dc_bypass;
  wire    [ 3:0]  win_log2;
  wire    [ 4:0]  msb_pos;
  wire    [ 5:0]  chan_sel [0:1];
  wire    [31:0]  threshold [0:1];
  wire            clr_frame_count;
  wire            clr_events;
  wire            clr_env_max;

  // per-pair results

  wire    [31:0]  env [0:1];
  wire    [31:0]  env_max [0:1];
  wire    [31:0]  corr [0:1];
  wire    [ 1:0]  evt;

  reg     [31:0]  event_count [0:1];
  reg     [31:0]  event_frame_first [0:1];
  reg     [31:0]  event_odr_first [0:1];
  reg     [31:0]  event_frame_last [0:1];
  reg     [31:0]  event_env [0:1];
  reg     [31:0]  event_corr [0:1];

  wire    [23:0]  dbg_ch_a_i [0:1];
  wire    [23:0]  dbg_ch_b_i [0:1];
  wire    [24:0]  dbg_d_i [0:1];

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // ---------------------------------------------------------------
  // Sample stream pass-through
  // ---------------------------------------------------------------

  // Nothing is registered here. Vivado collapses these to direct nets, so the
  // DMA sees a bit-identical stream with identical timing.

  assign m_axis_valid = s_axis_valid;
  assign m_axis_data  = s_axis_data;
  assign s_axis_ready = m_axis_ready;

  // beat is also the ILA storage qualifier: one captured slot per ADC frame.

  (* mark_debug = "true" *) wire beat = s_axis_valid & m_axis_ready;

  wire resetn = s_axis_aresetn & ext_resetn;

  // ---------------------------------------------------------------
  // Stream idle detection
  // ---------------------------------------------------------------

  // The stream is declared idle after 2**IDLE_LOG2 clocks without a beat
  // (655 us at 100 MHz, versus 75 clocks between beats at 1.33 MSPS). This is
  // what a buffer teardown looks like from in here, and it is deliberately far
  // longer than any credible gap inside a live capture.

  reg  [IDLE_LOG2-1:0] idle_cnt = {IDLE_LOG2{1'b1}};

  wire idle = &idle_cnt;

  always @(posedge s_axis_aclk) begin
    if (resetn == 1'b0) begin
      idle_cnt <= {IDLE_LOG2{1'b1}};
    end else if (beat == 1'b1) begin
      idle_cnt <= {IDLE_LOG2{1'b0}};
    end else if (idle == 1'b0) begin
      idle_cnt <= idle_cnt + 1'b1;
    end
  end

  wire stream_active = ~idle;

  // A beat arriving while the stream is still marked idle is the first beat of
  // a new capture.

  wire capture_start = beat & idle & auto_clr_on_idle;

  // Holding restart asserted for the whole idle period re-arms the two-window
  // warm-up, so the first windows after a capture restarts cannot be reported
  // as a slip.

  wire restart = auto_clr_on_idle & idle;

  // ---------------------------------------------------------------
  // ODR pulse edge detection
  // ---------------------------------------------------------------

  // odr_in belongs to the gated 48 MHz clkin_aligner domain. Its high time is
  // 13 of those cycles (271 ns, 27 cycles here), so a two-flop synchronizer
  // cannot miss a pulse. The gate stopping simply freezes the count.

  (* mark_debug = "true" *) wire odr_sync;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_sync_odr (
    .in_bits (odr_in),
    .out_resetn (resetn),
    .out_clk (s_axis_aclk),
    .out_bits (odr_sync));

  reg odr_sync_d1 = 1'b0;

  always @(posedge s_axis_aclk) begin
    if (resetn == 1'b0) begin
      odr_sync_d1 <= 1'b0;
    end else begin
      odr_sync_d1 <= odr_sync;
    end
  end

  wire odr_edge = odr_sync & ~odr_sync_d1;

  // ---------------------------------------------------------------
  // Frame and ODR counters
  // ---------------------------------------------------------------

  // Both counters restart at the beginning of a capture, so EVENT_ODR_FIRST
  // reads directly as "ODR periods from the start of this capture to the first
  // slip". Clearing AUTO_CLR_ON_IDLE instead lets them free-run across bursts,
  // which measures elapsed ODR periods rather than captured ones.
  //
  // They are seeded with 1, not 0: the ODR pulse that launched the first beat
  // has already passed by the time that beat arrives, so seeding both keeps
  // them in lockstep. ODR_COUNT - FRAME_COUNT is then exactly the number of ODR
  // periods for which no sample beat was delivered.

  (* mark_debug = "true" *) reg  [31:0] frame_count = 32'd0;
  (* mark_debug = "true" *) reg  [31:0] odr_count = 32'd0;
  reg         overflow = 1'b0;

  always @(posedge s_axis_aclk) begin
    if (resetn == 1'b0 || clr_frame_count == 1'b1) begin
      frame_count <= 32'd0;
      odr_count   <= 32'd0;
      overflow    <= 1'b0;
    end else if (capture_start == 1'b1) begin
      frame_count <= 32'd1;
      odr_count   <= 32'd1;
    end else begin
      if (beat == 1'b1) begin
        frame_count <= frame_count + 1'b1;
        if (frame_count == 32'hffffffff) begin
          overflow <= 1'b1;
        end
      end
      if (odr_edge == 1'b1) begin
        odr_count <= odr_count + 1'b1;
      end
    end
  end

  // ---------------------------------------------------------------
  // Comparator pairs
  // ---------------------------------------------------------------

  genvar n;
  generate
  for (n = 0; n < 2; n = n + 1) begin: g_pair

    ad7134_slip_detect_pair #(
      .DC_SHIFT (DC_SHIFT)
    ) i_pair (
      .clk (s_axis_aclk),
      .resetn (resetn),
      .beat (beat),
      .tdata (s_axis_data),
      .restart (restart),
      .detect_en (detect_en),
      .dc_bypass (dc_bypass),
      .sel_a (chan_sel[n][2:0]),
      .sel_b (chan_sel[n][5:3]),
      .msb_pos (msb_pos),
      .win_log2 (win_log2),
      .threshold (threshold[n]),
      .clr_env_max (clr_env_max),
      .env (env[n]),
      .env_max (env_max[n]),
      .corr (corr[n]),
      .evt (evt[n]),
      .dbg_ch_a (dbg_ch_a_i[n]),
      .dbg_ch_b (dbg_ch_b_i[n]),
      .dbg_d (dbg_d_i[n]));

    always @(posedge s_axis_aclk) begin
      if (resetn == 1'b0 || clr_events == 1'b1) begin
        event_count[n]       <= 32'd0;
        event_frame_first[n] <= 32'd0;
        event_odr_first[n]   <= 32'd0;
        event_frame_last[n]  <= 32'd0;
        event_env[n]         <= 32'd0;
        event_corr[n]        <= 32'd0;
      end else if (evt[n] == 1'b1) begin
        event_count[n]      <= event_count[n] + 1'b1;
        event_frame_last[n] <= frame_count;
        event_env[n]        <= env[n];
        event_corr[n]       <= corr[n];
        if (event_count[n] == 32'd0) begin
          event_frame_first[n] <= frame_count;
          event_odr_first[n]   <= odr_count;
        end
      end
    end

  end
  endgenerate

  // ---------------------------------------------------------------
  // Debug taps
  // ---------------------------------------------------------------

  assign dbg_ch_a = dbg_ch_a_i[0];
  assign dbg_ch_b = dbg_ch_b_i[0];
  assign dbg_d    = dbg_d_i[0];
  assign dbg_env  = env[0];
  assign dbg_frame = frame_count;

  assign slip_flag = evt;

  // slip_stretch holds the flag long enough for an ILA in another clock domain
  // to cross-trigger on it through a two-flop synchronizer.

  // dont_touch as well as mark_debug: slip_stretch is left unconnected in the
  // block design, so this counter has no other consumer to keep it alive.

  (* mark_debug = "true", dont_touch = "true" *) reg [11:0] stretch_cnt = 12'd0;

  always @(posedge s_axis_aclk) begin
    if (resetn == 1'b0) begin
      stretch_cnt <= 12'd0;
    end else if (|evt) begin
      stretch_cnt <= STRETCH_LEN;
    end else if (stretch_cnt != 12'd0) begin
      stretch_cnt <= stretch_cnt - 1'b1;
    end
  end

  assign slip_stretch = (stretch_cnt != 12'd0);

  // ---------------------------------------------------------------
  // AXI-Lite glue
  // ---------------------------------------------------------------

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

  // ---------------------------------------------------------------
  // Register map (handles CDC between up_clk and s_axis_aclk)
  // ---------------------------------------------------------------

  ad7134_slip_detect_regmap #(
    .ID (ID),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .WIN_LOG2_DEFAULT (WIN_LOG2_DEFAULT),
    .MSB_POS_DEFAULT (MSB_POS_DEFAULT),
    .PAIR0_CHAN_DEFAULT (PAIR0_CHAN_DEFAULT),
    .PAIR1_CHAN_DEFAULT (PAIR1_CHAN_DEFAULT),
    .THRESHOLD_DEFAULT (THRESHOLD_DEFAULT)
  ) i_regmap (
    .ext_clk (s_axis_aclk),
    .ext_resetn (ext_resetn),
    .detect_en (detect_en),
    .auto_clr_on_idle (auto_clr_on_idle),
    .dc_bypass (dc_bypass),
    .win_log2 (win_log2),
    .msb_pos (msb_pos),
    .chan_sel_0 (chan_sel[0]),
    .chan_sel_1 (chan_sel[1]),
    .threshold_0 (threshold[0]),
    .threshold_1 (threshold[1]),
    .clr_frame_count (clr_frame_count),
    .clr_events (clr_events),
    .clr_env_max (clr_env_max),
    .frame_count (frame_count),
    .odr_count (odr_count),
    .stream_active (stream_active),
    .overflow (overflow),
    .env_0 (env[0]),
    .env_max_0 (env_max[0]),
    .event_count_0 (event_count[0]),
    .event_frame_first_0 (event_frame_first[0]),
    .event_odr_first_0 (event_odr_first[0]),
    .event_frame_last_0 (event_frame_last[0]),
    .event_env_0 (event_env[0]),
    .event_corr_0 (event_corr[0]),
    .env_1 (env[1]),
    .env_max_1 (env_max[1]),
    .event_count_1 (event_count[1]),
    .event_frame_first_1 (event_frame_first[1]),
    .event_odr_first_1 (event_odr_first[1]),
    .event_frame_last_1 (event_frame_last[1]),
    .event_env_1 (event_env[1]),
    .event_corr_1 (event_corr[1]),
    .evt_0 (evt[0]),
    .evt_1 (evt[1]),
    .irq (irq),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
