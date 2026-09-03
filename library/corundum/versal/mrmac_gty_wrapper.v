// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MRMAC MAC shim / wrapper — parameterized by MODE (1x100G or 4x25G).
 *
 * Presents Corundum's per-port MAC-wrapper contract (the same interface
 * cmac_gty_wrapper presents to fpga_core: packet AXI-Stream + PTP + flow-control
 * + status + a DRP-style control bus) on one side, and the AMD Versal MRMAC
 * *non-segmented* user interface (user clocks, reset-done, link status) on the
 * other. The MRMAC IP + GT quad + clocking live in the block design.
 *
 * MODE="1x100G" (default): ONE 100GE port. MRMAC side = 384-bit (6x64 words);
 *   fpga_core side = 512-bit. Datapath (sim-verified against real MRMAC):
 *     TX: fpga_core 512b -> cmac_pad -> axis_adapter(512->1536->384)
 *         -> TX store-and-forward frame FIFO(384) -> mrmac_tx_adapt -> MRMAC
 *     RX: MRMAC -> mrmac_rx_adapt -> axis_fifo(384,frame)
 *         -> axis_adapter(384->1536->512) -> fpga_core 512b
 *
 * MODE="4x25G": ONE 25GE port (instantiate this wrapper x4, one per port). MRMAC
 *   side = 64-bit (1 word); fpga_core side = 64-bit. NO width conversion needed:
 *     TX: fpga_core 64b -> TX store-and-forward frame FIFO(64) -> mrmac_tx_adapt -> MRMAC
 *     RX: MRMAC -> mrmac_rx_adapt -> axis_fifo(64,frame) -> fpga_core 64b
 *   Runt padding is NOT done here for 25G (the MAC handles Ethernet min-frame;
 *   the 100G cmac_pad is 512-bit-only). The TX frame FIFO still guarantees
 *   gapless tvalid per frame into the MAC (avoids TX underflow).
 *
 * SCOPE: link-up + working datapath + PTP + LFC/PFC flow control. Pause is
 * wired to the MRMAC hardware pause pins (9-bit {lfc, pfc} vectors) in both
 * modes; TX pause quanta/refresh timers come from the s_axi bring-up.
 */

`timescale 1ns/100ps

module mrmac_gty_wrapper #(
  // "1x100G" or "4x25G" — selects the per-port datapath geometry.
  parameter MODE = "1x100G",
  // Widths derive from MODE (do not override): fpga_core side is 512b for
  // 100G, 64b for one 25G port; MRMAC side is 384b (6x64) or 64b (1x64).
  parameter AXIS_DATA_WIDTH = (MODE == "4x25G") ? 64 : 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter SEG_COUNT   = (MODE == "4x25G") ? 1 : 6,
  parameter SEG_WIDTH   = 64,
  parameter KUSER_WIDTH = 11,
  parameter NARROW      = SEG_COUNT*SEG_WIDTH,     // 384 (100G) or 64 (25G)
  parameter NARROW_KEEP = NARROW/8,                // 48  or 8
  // 100G width-conversion neck. MUST be a common multiple of the two ends
  // (512 and NARROW=384) or axis_adapter degenerates SILENTLY -- see the long
  // note at g_tx_100g. Legal: 128 (=gcd) or 1536 (=lcm). 1536 is the only value
  // that clears 100G line rate; 128 gives 50 Gb/s, the old 64 gave 25 Gb/s.
  parameter NECK        = 1536,
  parameter NECK_KEEP   = NECK/8,
  // FIFO depths are in BYTES, not beats: axis_fifo derives its address width as
  // $clog2(DEPTH/KEEP_WIDTH) (axis_fifo.v:137), so the usable capacity is
  // 2**$clog2(DEPTH/NARROW_KEEP) * NARROW_KEEP bytes. At NARROW_KEEP=48 the old
  // RX value of 4096 gave only 128 beats = 6144 bytes -- BELOW the configured
  // MAX_RX_SIZE of 9214 (corundum_vck190_cfg.tcl), so every jumbo frame hit
  // full_wr && DROP_OVERSIZE_FRAME and was dropped WHOLE with rx_fifo_overflow
  // set. Standard 1518-byte traffic was unaffected, which is what made it easy to
  // miss. 4096 was a leftover from the 64-bit-wide era (4096/8 = 512 beats).
  //   4096  -> 4096/48=85  -> $clog2=7 -> 128 beats x 48 B =  6144 B  (< 9214, BAD)
  //   8192  -> 8192/48=170 -> $clog2=8 -> 256 beats x 48 B = 12288 B  (>= 9214, ok)
  //   16384 -> 16384/48=341-> $clog2=9 -> 512 beats x 48 B = 24576 B  (2.6x MTU)
  // 16384 is used for both: it matches the TX store-and-forward depth and leaves
  // room for a raised MTU. Note the granularity -- because $clog2 rounds the BEAT
  // count up to a power of two, capacity jumps in 2x steps and any DEPTH in
  // 8161..16320 yields the same 256 beats. Keep both >= MAX_RX_SIZE/MAX_TX_SIZE.
  parameter RX_FIFO_DEPTH = 16384,
  parameter TX_FIFO_DEPTH = 16384,  // store-and-forward: holds the largest frame at NARROW width
  // PTP: Corundum carries its rel timestamp in an 80-bit CMAC-faithful field
  // (low 48 bits meaningful); the MRMAC PTP timer/timestamp is 55-bit (PG314).
  parameter PTP_TS_WIDTH   = 80,
  parameter COR_FNS_WIDTH  = 16,    // Corundum fractional-ns bits (ptp_clock.v)
  parameter MRMAC_TS_WIDTH = 55,    // MRMAC systemtimer/timestamp width (PG314)
  parameter MRMAC_FNS_WIDTH = 8,    // MRMAC fractional-ns bits (LSB = 2^-8 ns)
  // Clocks between MRMAC PTP st_sync transitions (PG314: >= 10; ~64 ns typical).
  parameter PTP_SYNC_CYCLES = 32
) (
  /*
   * MRMAC user clocks (from the BD, ~390.625 MHz in non-seg independent mode)
   */
  input  wire                        tx_axi_clk,
  input  wire                        rx_axi_clk,

  /*
   * Reset inputs from the BD (active-high, async; e.g. gated on MRMAC/GT
   * reset-done). Synchronized internally to produce tx_rst/rx_rst.
   */
  input  wire                        tx_reset_in,
  input  wire                        rx_reset_in,

  ////////////////////////////////////////////////////////////////////////////
  // fpga_core-facing side (Corundum MAC-wrapper contract)
  ////////////////////////////////////////////////////////////////////////////
  output wire                        tx_clk,
  output wire                        tx_rst,

  input  wire [AXIS_DATA_WIDTH-1:0]  tx_axis_tdata,
  input  wire [AXIS_KEEP_WIDTH-1:0]  tx_axis_tkeep,
  input  wire                        tx_axis_tvalid,
  output wire                        tx_axis_tready,
  input  wire                        tx_axis_tlast,
  input  wire [16+1-1:0]             tx_axis_tuser,   // {tag[15:0], error}

  input  wire [79:0]                 tx_ptp_time,
  output wire [79:0]                 tx_ptp_ts,
  output wire [15:0]                 tx_ptp_ts_tag,
  output wire                        tx_ptp_ts_valid,

  input  wire                        tx_enable,
  input  wire                        tx_lfc_en,
  input  wire                        tx_lfc_req,
  input  wire [7:0]                  tx_pfc_en,
  input  wire [7:0]                  tx_pfc_req,

  output wire                        rx_clk,
  output wire                        rx_rst,

  output wire [AXIS_DATA_WIDTH-1:0]  rx_axis_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]  rx_axis_tkeep,
  output wire                        rx_axis_tvalid,
  output wire                        rx_axis_tlast,
  output wire [80+1-1:0]             rx_axis_tuser,   // {ptp_ts[79:0], error}

  output wire                        rx_ptp_clk,
  output wire                        rx_ptp_rst,
  input  wire [79:0]                 rx_ptp_time,

  input  wire                        rx_enable,
  output wire                        rx_status,
  input  wire                        rx_lfc_en,
  output wire                        rx_lfc_req,
  input  wire                        rx_lfc_ack,
  input  wire [7:0]                  rx_pfc_en,
  output wire [7:0]                  rx_pfc_req,
  input  wire [7:0]                  rx_pfc_ack,

  // DRP-style control bus (from fpga_core's rb_drp). Minimal responder here.
  input  wire                        drp_clk,
  input  wire                        drp_rst,
  input  wire [23:0]                 drp_addr,
  input  wire [15:0]                 drp_di,
  input  wire                        drp_en,
  input  wire                        drp_we,
  output wire [15:0]                 drp_do,
  output wire                        drp_rdy,

  ////////////////////////////////////////////////////////////////////////////
  // MRMAC-facing side (to the BD's MRMAC non-segmented user interface)
  ////////////////////////////////////////////////////////////////////////////
  // TX: shim -> MRMAC (SEG_COUNT x 64b data packed low-word-first; SEG_COUNT x 11b tkeep_user)
  output wire [SEG_COUNT*SEG_WIDTH-1:0]   mrmac_tx_axis_tdata,
  output wire [SEG_COUNT*KUSER_WIDTH-1:0] mrmac_tx_axis_tkeep_user,
  output wire                             mrmac_tx_axis_tvalid,
  input  wire                             mrmac_tx_axis_tready,
  output wire                             mrmac_tx_axis_tlast,

  // RX: MRMAC -> shim (valid-only)
  input  wire [SEG_COUNT*SEG_WIDTH-1:0]   mrmac_rx_axis_tdata,
  input  wire [SEG_COUNT*KUSER_WIDTH-1:0] mrmac_rx_axis_tkeep_user,
  input  wire                             mrmac_rx_axis_tvalid,
  input  wire                             mrmac_rx_axis_tlast,

  // MRMAC status / control
  input  wire                        mrmac_stat_rx_status,   // link up (aligned)
  output wire                        ctl_tx_enable,
  output wire                        ctl_rx_enable,

  ////////////////////////////////////////////////////////////////////////////
  // MRMAC-facing flow control (pause). MRMAC packs LFC+PFC into one 9-bit
  // [8:0] vector per direction: bit 8 = link (global) pause, bits [7:0] = the
  // 8 PFC priority classes - identical to the CMAC {lfc, pfc} concatenation
  // (cmac_gty_wrapper: ctl_tx_pause_enable({tx_lfc_en, tx_pfc_en}) etc.). The
  // TX pause quanta / refresh timers are NOT pins on the MRMAC - they are set
  // through the s_axi register bring-up (the MRMAC AXI-enable model).
  ////////////////////////////////////////////////////////////////////////////
  output wire [8:0]                  mrmac_ctl_tx_pause_enable,
  output wire [8:0]                  mrmac_ctl_tx_pause_req,
  output wire [8:0]                  mrmac_ctl_rx_pause_enable,
  output wire [8:0]                  mrmac_ctl_rx_pause_ack,
  input  wire [8:0]                  mrmac_stat_rx_pause_req,

  ////////////////////////////////////////////////////////////////////////////
  // MRMAC-facing PTP interface (PG314). All in the ts-clk domain, tied to the
  // AXIS clock in the BD so no CDC to *_ptp_time / the AXIS datapath is needed.
  ////////////////////////////////////////////////////////////////////////////
  // RX: MRMAC captures a timestamp for each frame, valid at the RX SOP beat.
  input  wire [MRMAC_TS_WIDTH-1:0]   mrmac_rx_ptp_tstamp,

  // TX: request a 2-step timestamp (op=2'b10) tagged with the frame's tag, and
  // receive the completion (timestamp + tag + valid) a few beats later.
  output wire [1:0]                  mrmac_tx_ptp_1588op,
  output wire [15:0]                 mrmac_tx_ptp_tag_field,
  input  wire [MRMAC_TS_WIDTH-1:0]   mrmac_tx_ptp_tstamp,
  input  wire [15:0]                 mrmac_tx_ptp_tstamp_tag,
  input  wire                        mrmac_tx_ptp_tstamp_valid,

  // System-timer discipline (drive MRMAC's internal PTP timer to Corundum time).
  output wire [MRMAC_TS_WIDTH-1:0]   mrmac_tx_ptp_systemtimer,
  output wire                        mrmac_tx_ptp_st_sync,
  output wire                        mrmac_tx_ptp_st_overwrite,
  output wire [MRMAC_TS_WIDTH-1:0]   mrmac_rx_ptp_systemtimer,
  output wire                        mrmac_rx_ptp_st_sync,
  output wire                        mrmac_rx_ptp_st_overwrite,

  // Status
  output wire                        rx_fifo_overflow
);

  // check configuration
  initial begin
    if (MODE != "1x100G" && MODE != "4x25G") begin
      $error("Error: MODE must be \"1x100G\" or \"4x25G\" (instance %m)");
      $finish;
    end
  end

  // Datapath tuser widths (PTP-carrying):
  //   TX: {tag[15:0], error}  -> the PTP tag rides with the frame to the MRMAC
  //       TX interface, where it is presented as tx_ptp_tag_field (CMAC-style).
  //   RX: {ptp_ts[79:0], error} -> mac_ts_insert stamps the RX SOP beat; the
  //       timestamp then rides with the frame through the FIFO + width adapters
  //       to fpga_core (exactly the CMAC rx_axis_tuser contract).
  localparam TX_USER_WIDTH = 16 + 1;                 // 17
  localparam RX_USER_WIDTH = PTP_TS_WIDTH + 1;       // 81

  ////////////////////////////////////////////////////////////////////////////
  // Clocks / resets
  ////////////////////////////////////////////////////////////////////////////
  assign tx_clk = tx_axi_clk;
  assign rx_clk = rx_axi_clk;
  assign rx_ptp_clk = rx_axi_clk;

  sync_reset #(
    .N(4)
  ) tx_rst_sync_i (
    .clk(tx_axi_clk),
    .rst(tx_reset_in),
    .out(tx_rst)
  );
  sync_reset #(
    .N(4)
  ) rx_rst_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_reset_in),
    .out(rx_rst)
  );
  sync_reset #(
    .N(4)
  ) rx_ptp_rst_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_reset_in),
    .out(rx_ptp_rst)
  );

  ////////////////////////////////////////////////////////////////////////////
  // Enable / status
  ////////////////////////////////////////////////////////////////////////////
  // Direct enable (matches cmac_gty_wrapper default cmac_ctl_*_enable_reg = 1).
  assign ctl_tx_enable = tx_enable;
  assign ctl_rx_enable = rx_enable;
  // Link-up straight from the MAC alignment/status.
  assign rx_status = mrmac_stat_rx_status;

  ////////////////////////////////////////////////////////////////////////////
  // TX datapath (MODE-dependent). Common tail: a NARROW-width store-and-forward
  // FRAME FIFO feeding mrmac_tx_adapt — the MRMAC non-segmented TX interface
  // requires GAPLESS tvalid for a whole frame (a mid-frame bubble underflows the
  // MAC, aborting the frame with 0xFE fill; observed on long 100G frames in xsim).
  //   1x100G: fpga_core 512b -> cmac_pad -> 512->64->384 -> [frame FIFO] -> adapter
  //   4x25G : fpga_core 64b  ------------------------------> [frame FIFO] -> adapter
  ////////////////////////////////////////////////////////////////////////////
  wire [NARROW-1:0]          tx_pf_tdata;   // pre-FIFO, NARROW width
  wire [NARROW_KEEP-1:0]     tx_pf_tkeep;
  wire                       tx_pf_tvalid;
  wire                       tx_pf_tready;
  wire                       tx_pf_tlast;
  wire [TX_USER_WIDTH-1:0]   tx_pf_tuser;   // {tag[15:0], error}

  generate
  if (MODE == "1x100G") begin : g_tx_100g
    // 512b -> cmac_pad (runt pad, 512b-only) -> 512->64->384 into tx_pf_*.
    // The full {tag[15:0], error} tuser is carried through so the PTP tag reaches
    // the MRMAC TX interface (CMAC feeds cmac_tx_axis_tuser[16:1] to the tag).
    //
    // *** THE NECK IS THE THROUGHPUT-CRITICAL PARAMETER OF THIS DATAPATH ***
    //
    // 512 -> 384 is not an integral ratio, so it cannot be one axis_adapter; the
    // conversion goes 512 -> NECK -> 384. All four converters (TX pair here, RX pair
    // at g_rx_100g) are clocked from tx_clk / rx_clk (= tx_axi_clk / rx_axi_clk,
    // :215-216) -- the SAME clock as the 512-bit and 384-bit ends. So the chain moves
    // at most NECK/8 bytes per cycle and the whole path inherits that limit no matter
    // how wide its ends are. NECK, not the clock, is the knob.
    //
    // NECK MUST BE A COMMON MULTIPLE OF 512 AND 384, and nothing checks this for you.
    // axis_adapter derives SEG_COUNT = M_BYTE_LANES / S_BYTE_LANES as a TRUNCATING
    // integer divide (axis_adapter.v:137) and its three `initial` assertions
    // (:100-116) check only byte-divisibility and byte-size match -- never the S/M
    // ratio. A non-integral ratio therefore elaborates clean, simulates clean, and
    // passes a byte-exact test while quietly wasting bus: measured at NECK=768
    // (768/512 = 1.5), the neck carried 64 B/beat on a 96 B bus, a third of it dead,
    // for worse cycles/frame than 1536. gcd(512,384) = 128 and lcm(512,384) = 1536,
    // so 128 and 1536 are the only sane values.
    //
    // MEASURED at 390.625 MHz, standalone harness at
    // testbenches/ip/mrmac_only_gty/standalone/, 1024 frames, max rate:
    //
    //   NECK   cyc/frame (256 B)   sustained rate   verdict
    //   ----   -----------------   --------------   -------------------------------
    //     64            32           25.0 Gb/s      1/4 of line rate (was default)
    //    128            16           50.0 Gb/s      1/2 of line rate
    //   1536             6          133.3 Gb/s      clears 100G  <-- current value
    //
    // Why 1536 is needed and not merely nice: at 390.625 MHz, 100G requires
    // 100e9/390.625e6 = 256 bits/cycle SUSTAINED. Frames do not divide by the 48-byte
    // 384-bit beat, so the partial last beat costs real bandwidth -- the worst frame
    // in 64..1518 B needs 1/0.821 = 1.22x the average. That 22% is exactly the margin
    // the MRMAC's 6x64 = 384-bit client bus was overprovisioned to provide (4x64 =
    // 256b would be the zero-margin width and underruns). A neck below the lcm throws
    // that margin away before the 384-bit bus ever sees it.
    //
    // COST of 1536: four 1536-bit-wide register stages plus their muxes, at 390.625
    // MHz. This is the timing-closure risk of this module; if a 1536-bit mux fails to
    // close, the fallback is NECK=128 at half line rate, NOT a non-multiple value.
    //
    // RX SHARES THE NECK AND THE FAILURE MODE IS WORSE THERE. rx_384_neck_i /
    // rx_neck_512_i mirror this structure on rx_clk, but MRMAC RX cannot be
    // back-pressured, so a sustained arrival rate above the neck's capacity does not
    // stall -- it OVERFLOWS rx_fifo_i, and that FIFO drops WHOLE FRAMES
    // (DROP_WHEN_FULL=1). Under a real 100G ingress load an undersized neck therefore
    // shows up as silent frame loss with no corruption, easily misread as a link
    // fault. The bench prints rx_fifo status_overflow for exactly this reason
    // (testbenches/ip/mrmac_only_gty/mrmac_shim_fifo.v).
    wire [AXIS_DATA_WIDTH-1:0] pad_tdata;
    wire [AXIS_KEEP_WIDTH-1:0] pad_tkeep;
    wire                       pad_tvalid, pad_tready, pad_tlast;
    wire [TX_USER_WIDTH-1:0]   pad_tuser;

    cmac_pad #(
      .DATA_WIDTH(AXIS_DATA_WIDTH),
      .KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .USER_WIDTH(TX_USER_WIDTH)
    ) cmac_pad_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(tx_axis_tdata),
      .s_axis_tkeep(tx_axis_tkeep),
      .s_axis_tvalid(tx_axis_tvalid),
      .s_axis_tready(tx_axis_tready),
      .s_axis_tlast(tx_axis_tlast),
      .s_axis_tuser(tx_axis_tuser),
      .m_axis_tdata(pad_tdata),
      .m_axis_tkeep(pad_tkeep),
      .m_axis_tvalid(pad_tvalid),
      .m_axis_tready(pad_tready),
      .m_axis_tlast(pad_tlast),
      .m_axis_tuser(pad_tuser)
    );

    wire [NECK-1:0]          tx_neck_tdata;
    wire [NECK_KEEP-1:0]     tx_neck_tkeep;
    wire                     tx_neck_tvalid, tx_neck_tready, tx_neck_tlast;
    wire [TX_USER_WIDTH-1:0] tx_neck_tuser;

    axis_adapter #(
      .S_DATA_WIDTH(AXIS_DATA_WIDTH),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .M_DATA_WIDTH(NECK),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NECK_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(TX_USER_WIDTH)
    ) tx_512_neck_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(pad_tdata),
      .s_axis_tkeep(pad_tkeep),
      .s_axis_tvalid(pad_tvalid),
      .s_axis_tready(pad_tready),
      .s_axis_tlast(pad_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(pad_tuser),
      .m_axis_tdata(tx_neck_tdata),
      .m_axis_tkeep(tx_neck_tkeep),
      .m_axis_tvalid(tx_neck_tvalid),
      .m_axis_tready(tx_neck_tready),
      .m_axis_tlast(tx_neck_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(tx_neck_tuser)
    );

    axis_adapter #(
      .S_DATA_WIDTH(NECK),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NECK_KEEP),
      .M_DATA_WIDTH(NARROW),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NARROW_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(TX_USER_WIDTH)
    ) tx_neck_384_i (
      .clk(tx_clk),
      .rst(tx_rst),
      .s_axis_tdata(tx_neck_tdata),
      .s_axis_tkeep(tx_neck_tkeep),
      .s_axis_tvalid(tx_neck_tvalid),
      .s_axis_tready(tx_neck_tready),
      .s_axis_tlast(tx_neck_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(tx_neck_tuser),
      .m_axis_tdata(tx_pf_tdata),
      .m_axis_tkeep(tx_pf_tkeep),
      .m_axis_tvalid(tx_pf_tvalid),
      .m_axis_tready(tx_pf_tready),
      .m_axis_tlast(tx_pf_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(tx_pf_tuser)
    );
  end else begin : g_tx_25g
    // 64b fpga_core AXIS straight to the frame FIFO — NARROW==64, no conversion,
    // no cmac_pad (MAC handles Ethernet min-frame; cmac_pad is 512b-only).
    assign tx_pf_tdata   = tx_axis_tdata;
    assign tx_pf_tkeep   = tx_axis_tkeep;
    assign tx_pf_tvalid  = tx_axis_tvalid;
    assign tx_axis_tready = tx_pf_tready;
    assign tx_pf_tlast   = tx_axis_tlast;
    assign tx_pf_tuser   = tx_axis_tuser;   // {tag[15:0], error}
  end
  endgenerate

  // Common TX store-and-forward FRAME FIFO (NARROW width) -> mrmac_tx_adapt.
  // tuser carries {tag[15:0], error}: mrmac_tx_adapt uses bit 0 (error) for the
  // MRMAC per-word ERR encoding, and the wrapper taps bits [16:1] (tag) at the
  // adapter input to drive tx_ptp_tag_field on the SOP beat.
  wire [NARROW-1:0]        tx_n_tdata;
  wire [NARROW_KEEP-1:0]   tx_n_tkeep;
  wire                     tx_n_tvalid;
  wire                     tx_n_tready;
  wire                     tx_n_tlast;
  wire [TX_USER_WIDTH-1:0] tx_n_tuser;

  axis_fifo #(
    .DEPTH(TX_FIFO_DEPTH),
    .DATA_WIDTH(NARROW),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(NARROW_KEEP),
    .LAST_ENABLE(1),
    .USER_ENABLE(1),
    .USER_WIDTH(TX_USER_WIDTH),
    .FRAME_FIFO(1),
    .DROP_OVERSIZE_FRAME(0),
    .DROP_BAD_FRAME(0),
    .DROP_WHEN_FULL(0)
  ) tx_frame_fifo_i (
    .clk(tx_clk),
    .rst(tx_rst),
    .s_axis_tdata(tx_pf_tdata),
    .s_axis_tkeep(tx_pf_tkeep),
    .s_axis_tvalid(tx_pf_tvalid),
    .s_axis_tready(tx_pf_tready),
    .s_axis_tlast(tx_pf_tlast),
    .s_axis_tuser(tx_pf_tuser),
    .m_axis_tdata(tx_n_tdata),
    .m_axis_tkeep(tx_n_tkeep),
    .m_axis_tvalid(tx_n_tvalid),
    .m_axis_tready(tx_n_tready),
    .m_axis_tlast(tx_n_tlast),
    .m_axis_tuser(tx_n_tuser)
  );

  mrmac_tx_adapt #(
    .MODE(MODE),
    .SEG_COUNT(SEG_COUNT),
    .SEG_WIDTH(SEG_WIDTH),
    .KUSER_WIDTH(KUSER_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP),
    .USER_WIDTH(1)
  ) tx_adapt_i (
    .s_axis_tdata(tx_n_tdata),
    .s_axis_tkeep(tx_n_tkeep),
    .s_axis_tvalid(tx_n_tvalid),
    .s_axis_tready(tx_n_tready),
    .s_axis_tlast(tx_n_tlast),
    .s_axis_tuser(tx_n_tuser[0]),   // error bit only -> MRMAC per-word ERR
    .tx_axis_tdata(mrmac_tx_axis_tdata),
    .tx_axis_tkeep_user(mrmac_tx_axis_tkeep_user),
    .tx_axis_tvalid(mrmac_tx_axis_tvalid),
    .tx_axis_tready(mrmac_tx_axis_tready),
    .tx_axis_tlast(mrmac_tx_axis_tlast)
  );

  ////////////////////////////////////////////////////////////////////////////
  // TX PTP: request a 2-step timestamp on every frame's SOP beat and present
  // the frame's tag, exactly like CMAC (tx_ptp_1588op_in=2'b10,
  // tx_ptp_tag_field_in = tx_axis_tuser[16:1]). MRMAC latches these at the
  // frame's start-of-packet; hold the tag for the whole frame (constant per
  // frame from fpga_core) and drive op=2'b10 while a frame is in flight.
  // The completion (tstamp/tag/valid) is converted back to Corundum format and
  // returned on tx_ptp_ts*.
  ////////////////////////////////////////////////////////////////////////////
  assign mrmac_tx_ptp_1588op    = 2'b10;               // 2-step timestamp request
  assign mrmac_tx_ptp_tag_field = tx_n_tuser[16:1];    // {tag} rides with the frame

  // Completion timestamp: MRMAC 55-bit -> Corundum 80-bit field.
  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) tx_ts_cvt_i (
    .cor_ts_in({PTP_TS_WIDTH{1'b0}}),
    .mrmac_ts_out(),
    .mrmac_ts_in(mrmac_tx_ptp_tstamp),
    .cor_ts_out(tx_ptp_ts)
  );
  assign tx_ptp_ts_tag   = mrmac_tx_ptp_tstamp_tag;
  assign tx_ptp_ts_valid = mrmac_tx_ptp_tstamp_valid;

  ////////////////////////////////////////////////////////////////////////////
  // RX datapath: MRMAC -> mrmac_rx_adapt -> mac_ts_insert (stamp SOP with the
  // MRMAC RX timestamp, converted to Corundum format) -> axis_fifo -> width
  // up-convert -> fpga_core. The timestamp is inserted BEFORE the FIFO so it
  // rides with the frame (survives frame drops/reordering), unlike CMAC which
  // stamps directly at the MAC output (no FIFO in between there).
  ////////////////////////////////////////////////////////////////////////////
  wire [NARROW-1:0]      rx_n_tdata;
  wire [NARROW_KEEP-1:0] rx_n_tkeep;
  wire                   rx_n_tvalid;
  wire                   rx_n_tlast;
  wire                   rx_n_tuser;   // ERR (bad-frame), from MRMAC word-0

  mrmac_rx_adapt #(
    .MODE(MODE),
    .SEG_COUNT(SEG_COUNT),
    .SEG_WIDTH(SEG_WIDTH),
    .KUSER_WIDTH(KUSER_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP)
  ) rx_adapt_i (
    .rx_axis_tdata(mrmac_rx_axis_tdata),
    .rx_axis_tkeep_user(mrmac_rx_axis_tkeep_user),
    .rx_axis_tvalid(mrmac_rx_axis_tvalid),
    .rx_axis_tlast(mrmac_rx_axis_tlast),
    .m_axis_tdata(rx_n_tdata),
    .m_axis_tkeep(rx_n_tkeep),
    .m_axis_tvalid(rx_n_tvalid),
    .m_axis_tlast(rx_n_tlast),
    .m_axis_tuser(rx_n_tuser)
  );

  // MRMAC RX timestamp (55-bit, valid at SOP) -> Corundum 80-bit field.
  wire [PTP_TS_WIDTH-1:0] rx_ptp_ts_cor;
  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) rx_ts_cvt_i (
    .cor_ts_in({PTP_TS_WIDTH{1'b0}}),
    .mrmac_ts_out(),
    .mrmac_ts_in(mrmac_rx_ptp_tstamp),
    .cor_ts_out(rx_ptp_ts_cor)
  );

  // Insert the timestamp on the SOP beat. mac_ts_insert is a single register
  // stage with s_axis_tready = m_axis_tready. The downstream frame FIFO is
  // valid-only (DROP_WHEN_FULL keeps its s_axis_tready high), so m_axis_tready
  // is tied high here and the MRMAC RX beats are never back-pressured/lost.
  wire [NARROW-1:0]         rx_ins_tdata;
  wire [NARROW_KEEP-1:0]    rx_ins_tkeep;
  wire                      rx_ins_tvalid;
  wire                      rx_ins_tlast;
  wire [RX_USER_WIDTH-1:0]  rx_ins_tuser;   // {ptp_ts[79:0], error}

  mac_ts_insert #(
    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .DATA_WIDTH(NARROW),
    .KEEP_WIDTH(NARROW_KEEP),
    .S_USER_WIDTH(1),
    .M_USER_WIDTH(RX_USER_WIDTH)
  ) rx_ts_insert_i (
    .clk(rx_clk),
    .rst(rx_rst),
    .ptp_ts(rx_ptp_ts_cor),
    .s_axis_tdata(rx_n_tdata),
    .s_axis_tkeep(rx_n_tkeep),
    .s_axis_tvalid(rx_n_tvalid),
    .s_axis_tready(),                // valid-only source; ready == m_axis_tready
    .s_axis_tlast(rx_n_tlast),
    .s_axis_tuser(rx_n_tuser),
    .m_axis_tdata(rx_ins_tdata),
    .m_axis_tkeep(rx_ins_tkeep),
    .m_axis_tvalid(rx_ins_tvalid),
    .m_axis_tready(1'b1),            // FIFO (DROP_WHEN_FULL) is always ready
    .m_axis_tlast(rx_ins_tlast),
    .m_axis_tuser(rx_ins_tuser)
  );

  // Elastic frame FIFO at the MRMAC RX boundary (design risk R2): MRMAC RX is
  // valid-only, but the downstream 384->64 down-convert back-pressures. This FIFO
  // absorbs it and, on overrun, drops whole frames (never partial) and flags
  // overflow instead of corrupting the stream. The bad-frame value/mask target
  // the error bit (tuser[0]); the PTP timestamp occupies tuser[80:1].
  wire [NARROW-1:0]         rxf_tdata;
  wire [NARROW_KEEP-1:0]    rxf_tkeep;
  wire                      rxf_tvalid;
  wire                      rxf_tready;
  wire                      rxf_tlast;
  wire [RX_USER_WIDTH-1:0]  rxf_tuser;

  axis_fifo #(
    .DEPTH(RX_FIFO_DEPTH),
    .DATA_WIDTH(NARROW),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(NARROW_KEEP),
    .LAST_ENABLE(1),
    .USER_ENABLE(1),
    .USER_WIDTH(RX_USER_WIDTH),
    .FRAME_FIFO(1),
    .DROP_OVERSIZE_FRAME(1),
    .DROP_WHEN_FULL(1),
    .DROP_BAD_FRAME(0),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1)
  ) rx_fifo_i (
    .clk(rx_clk),
    .rst(rx_rst),
    .s_axis_tdata(rx_ins_tdata),
    .s_axis_tkeep(rx_ins_tkeep),
    .s_axis_tvalid(rx_ins_tvalid),
    .s_axis_tready(),   // valid-only source (mac_ts_insert m_axis_tready is 1)
    .s_axis_tlast(rx_ins_tlast),
    .s_axis_tuser(rx_ins_tuser),
    .m_axis_tdata(rxf_tdata),
    .m_axis_tkeep(rxf_tkeep),
    .m_axis_tvalid(rxf_tvalid),
    .m_axis_tready(rxf_tready),
    .m_axis_tlast(rxf_tlast),
    .m_axis_tuser(rxf_tuser),
    .status_overflow(rx_fifo_overflow)
  );

  // RX width up-convert (MODE-dependent): 100G converts NARROW(384) -> 512 via a
  // NECK-wide neck; 25G has NARROW==64 == fpga_core width, so pass through directly.
  // The 81-bit {ptp_ts, error} tuser travels through the width conversion.
  wire [AXIS_DATA_WIDTH-1:0] rx_w_tdata;
  wire [AXIS_KEEP_WIDTH-1:0] rx_w_tkeep;
  wire                       rx_w_tvalid;
  wire                       rx_w_tlast;
  wire [RX_USER_WIDTH-1:0]   rx_w_tuser;

  generate
  if (MODE == "1x100G") begin : g_rx_100g
    wire [NECK-1:0]          rx_neck_tdata;
    wire [NECK_KEEP-1:0]     rx_neck_tkeep;
    wire                     rx_neck_tvalid, rx_neck_tready, rx_neck_tlast;
    wire [RX_USER_WIDTH-1:0] rx_neck_tuser;

    axis_adapter #(
      .S_DATA_WIDTH(NARROW),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NARROW_KEEP),
      .M_DATA_WIDTH(NECK),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(NECK_KEEP),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(RX_USER_WIDTH)
    ) rx_384_neck_i (
      .clk(rx_clk),
      .rst(rx_rst),
      .s_axis_tdata(rxf_tdata),
      .s_axis_tkeep(rxf_tkeep),
      .s_axis_tvalid(rxf_tvalid),
      .s_axis_tready(rxf_tready),
      .s_axis_tlast(rxf_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(rxf_tuser),
      .m_axis_tdata(rx_neck_tdata),
      .m_axis_tkeep(rx_neck_tkeep),
      .m_axis_tvalid(rx_neck_tvalid),
      .m_axis_tready(rx_neck_tready),
      .m_axis_tlast(rx_neck_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(rx_neck_tuser)
    );

    axis_adapter #(
      .S_DATA_WIDTH(NECK),
      .S_KEEP_ENABLE(1),
      .S_KEEP_WIDTH(NECK_KEEP),
      .M_DATA_WIDTH(AXIS_DATA_WIDTH),
      .M_KEEP_ENABLE(1),
      .M_KEEP_WIDTH(AXIS_KEEP_WIDTH),
      .ID_ENABLE(0),
      .DEST_ENABLE(0),
      .USER_ENABLE(1),
      .USER_WIDTH(RX_USER_WIDTH)
    ) rx_neck_512_i (
      .clk(rx_clk),
      .rst(rx_rst),
      .s_axis_tdata(rx_neck_tdata),
      .s_axis_tkeep(rx_neck_tkeep),
      .s_axis_tvalid(rx_neck_tvalid),
      .s_axis_tready(rx_neck_tready),
      .s_axis_tlast(rx_neck_tlast),
      .s_axis_tid(8'd0),
      .s_axis_tdest(8'd0),
      .s_axis_tuser(rx_neck_tuser),
      .m_axis_tdata(rx_w_tdata),
      .m_axis_tkeep(rx_w_tkeep),
      .m_axis_tvalid(rx_w_tvalid),
      .m_axis_tready(1'b1),   // fpga_core RX has no tready
      .m_axis_tlast(rx_w_tlast),
      .m_axis_tid(),
      .m_axis_tdest(),
      .m_axis_tuser(rx_w_tuser)
    );
  end else begin : g_rx_25g
    // NARROW(64) == fpga_core width; drain the frame FIFO directly (no tready).
    assign rx_w_tdata  = rxf_tdata;
    assign rx_w_tkeep  = rxf_tkeep;
    assign rx_w_tvalid = rxf_tvalid;
    assign rx_w_tlast  = rxf_tlast;
    assign rx_w_tuser  = rxf_tuser;
    assign rxf_tready  = 1'b1;   // fpga_core RX has no back-pressure
  end
  endgenerate

  assign rx_axis_tdata  = rx_w_tdata;
  assign rx_axis_tkeep  = rx_w_tkeep;
  assign rx_axis_tvalid = rx_w_tvalid;
  assign rx_axis_tlast  = rx_w_tlast;
  // rx_axis_tuser = {ptp_ts[79:0], error} — carried from the SOP insertion.
  assign rx_axis_tuser  = rx_w_tuser;

  ////////////////////////////////////////////////////////////////////////////
  // PTP system-timer discipline: continuously align MRMAC's internal free-
  // running PTP timer to Corundum's ptp_time (Corundum is the PHC master, as on
  // VCU118). Corundum feeds tx_ptp_time / rx_ptp_time (80-bit rel format); we
  // convert to MRMAC 55-bit units and drive the st_sync/st_overwrite handshake
  // on each MRMAC PTP timer. Both timers (TX and RX) are disciplined to the same
  // Corundum timebase. These run in the ts-clk domain (tied to the AXIS clock in
  // the BD), so no CDC is needed from tx_ptp_time / rx_ptp_time.
  ////////////////////////////////////////////////////////////////////////////
  wire [MRMAC_TS_WIDTH-1:0] tx_ptp_time_mrmac;
  wire [MRMAC_TS_WIDTH-1:0] rx_ptp_time_mrmac;

  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) tx_time_cvt_i (
    .cor_ts_in(tx_ptp_time),
    .mrmac_ts_out(tx_ptp_time_mrmac),
    .mrmac_ts_in({MRMAC_TS_WIDTH{1'b0}}),
    .cor_ts_out()
  );

  mrmac_ptp_ts_cvt #(
    .COR_TS_WIDTH(PTP_TS_WIDTH),
    .COR_FNS_WIDTH(COR_FNS_WIDTH),
    .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH),
    .MRMAC_FNS_WIDTH(MRMAC_FNS_WIDTH)
  ) rx_time_cvt_i (
    .cor_ts_in(rx_ptp_time),
    .mrmac_ts_out(rx_ptp_time_mrmac),
    .mrmac_ts_in({MRMAC_TS_WIDTH{1'b0}}),
    .cor_ts_out()
  );

  mrmac_ptp_sync #(
    .TS_WIDTH(MRMAC_TS_WIDTH),
    .SYNC_CYCLES(PTP_SYNC_CYCLES)
  ) tx_ptp_sync_i (
    .clk(tx_axi_clk),
    .rst(tx_rst),
    .systemtime_in(tx_ptp_time_mrmac),
    .systemtimer(mrmac_tx_ptp_systemtimer),
    .st_sync(mrmac_tx_ptp_st_sync),
    .st_overwrite(mrmac_tx_ptp_st_overwrite)
  );

  mrmac_ptp_sync #(
    .TS_WIDTH(MRMAC_TS_WIDTH),
    .SYNC_CYCLES(PTP_SYNC_CYCLES)
  ) rx_ptp_sync_i (
    .clk(rx_axi_clk),
    .rst(rx_rst),
    .systemtime_in(rx_ptp_time_mrmac),
    .systemtimer(mrmac_rx_ptp_systemtimer),
    .st_sync(mrmac_rx_ptp_st_sync),
    .st_overwrite(mrmac_rx_ptp_st_overwrite)
  );

  ////////////////////////////////////////////////////////////////////////////
  // Flow control (LFC + PFC). Corundum's per-direction pause sideband maps onto
  // the MRMAC's 9-bit [8:0] pause vectors exactly as it does onto the CMAC:
  // bit 8 = link (global) pause = lfc, bits [7:0] = the 8 PFC classes = pfc.
  // Same TX/RX AXIS clock domain both sides (tx_clk=tx_axi_clk, rx_clk=
  // rx_axi_clk), so no CDC - plain concatenation like cmac_gty_wrapper.
  ////////////////////////////////////////////////////////////////////////////
  assign mrmac_ctl_tx_pause_enable = {tx_lfc_en,  tx_pfc_en};
  assign mrmac_ctl_tx_pause_req    = {tx_lfc_req, tx_pfc_req};
  assign mrmac_ctl_rx_pause_enable = {rx_lfc_en,  rx_pfc_en};
  assign mrmac_ctl_rx_pause_ack    = {rx_lfc_ack, rx_pfc_ack};
  assign {rx_lfc_req, rx_pfc_req}  = mrmac_stat_rx_pause_req;

  ////////////////////////////////////////////////////////////////////////////
  // Minimal DRP-style responder: always acks one cycle after enable, reads 0.
  // Prevents rb_drp from stalling; full MAC control/stats over DRP is future work.
  ////////////////////////////////////////////////////////////////////////////
  reg        drp_rdy_reg = 1'b0;
  reg [15:0] drp_do_reg  = 16'd0;

  always @(posedge drp_clk) begin
    drp_rdy_reg <= 1'b0;
    if (drp_en) begin
      drp_rdy_reg <= 1'b1;
      drp_do_reg  <= 16'd0;
    end
    if (drp_rst) begin
      drp_rdy_reg <= 1'b0;
      drp_do_reg  <= 16'd0;
    end
  end

  assign drp_do  = drp_do_reg;
  assign drp_rdy = drp_rdy_reg;

endmodule
