// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * mrmac_versal_glue - the "companion network" glue for an AMD Versal MRMAC in
 * 1x100GE CAUI-4 "Independent 384b Segmented" mode (MAC+PCS, IS_GT_WIZ_OLD=0,
 * the NEW GT-Wizard flow). This is the small block of RTL that block-design
 * automation would normally generate but does NOT for a Versal GT-Wizard MRMAC
 * (apply_bd_automation -rule mrmac emits "Block Automation is not supported with
 * Versal Adaptive SoC GT Wizard Subsystem" and wires nothing). The VPK180 branch
 * of corundum.tcl instantiates mrmac_0 + gtwiz_versal as BD cells and this
 * module as the RTL cell that stitches together everything the automation would.
 *
 * It is a faithful, minimal extraction of the MRMAC NEW-GT-wizard SEGMENTED
 * example design (mrmac_nw_exdes.sv) clocking/reset section:
 *   - the GT reference-clock input buffer  (IBUFDS_GTME5 for GT_TYPE="GTM"
 *     transceivers / IBUFDS_GTE5 for GT_TYPE="GTY" - selected by parameter)
 *   - the user-clock buffers               (one shared TX MBUFG_GT + four per-lane
 *     RX MBUFG_GTs - see CLOCK TOPOLOGY below)
 *   - core/serdes reset generation from gtwiz's per-interface reset-done
 *     (exdes 663-666: {4{~INTF0_rst_{tx,rx}_done_out}})
 *   - the AXIS clock broadcast             (tx/rx_axi_clk = {4{clk}})
 *   - the flexif clock + reset             (clk from axis, reset {4{~pl_resetn}})
 *   - the segmented AXIS pack/unpack       (one 384b bus <-> six 64b segments)
 *   - the GTM serdes-data width adaptation (mrmac 160b <-> gtwiz 256b, zero-
 *     extend TX / low-slice RX - see the SERDES DATA section below)
 *
 * ---------------------------------------------------------------------------
 * NEW-FLOW (IS_GT_WIZ_OLD=0): gtwiz MASTERS the GT reset/clear FSM.
 *   Under the OLD flow the MRMAC exposed typed serdes BUS interfaces and was the
 *   GT reset master (it drove clr_out/clrb_leaf_out/gt_{tx,rx}_reset_done_out and
 *   consumed gtpowergood_in). Those pins DO NOT EXIST under IS_GT_WIZ_OLD=0.
 *   Instead:
 *     - serdes DATA is a FLAT per-lane bus, whose width depends on GT_TYPE:
 *         GTM: MRMAC txdata_in_0..3 [159:0] (out) / rxdata_out_0..3 [159:0] (in);
 *              gtwiz INTF0_{TX,RX}{n}_ch_{tx,rx}data [255:0].
 *         GTY: MRMAC tx_serdes_data0..3 [79:0] (out) / rx_serdes_data0..3 [79:0]
 *              (in); gtwiz INTF0_{TX,RX}{n}_ch_{tx,rx}data [127:0].
 *       In BOTH families the MRMAC bus is narrower than gtwiz's channel bus, and a
 *       partial connect_bd_net would leave gtwiz's upper TX input bits undriven
 *       (blocking DRC). So the data is routed THROUGH this glue, parameterized by
 *       MRMAC_SERDES_W/GT_CH_W (derived from GT_TYPE): TX zero-extends
 *       MRMAC_SERDES_W->GT_CH_W, RX takes the low MRMAC_SERDES_W (user directive:
 *       "only the low bits are used, extend with zeroes"). See the SERDES DATA
 *       section below.
 *     - the MBUFG clears come from GTWIZ: INTF0_{TX,RX}_clr_out / _clrb_leaf_out.
 *     - the core/serdes resets are held until GTWIZ's INTF0_rst_{tx,rx}_done_out.
 *     - gtwiz owns gtpowergood internally; the MRMAC has no gtpowergood_in.
 * ---------------------------------------------------------------------------
 * CLOCK TOPOLOGY (frequency-independent). TX SHARED, RX PER-LANE.
 *   Matches PG314's 1x100G clocking figure (X21095-062118) and the NEW-flow
 *   example design (mrmac_0_exdes.sv:650-654). The two directions are NOT
 *   symmetric:
 *     TX - one MBUFG_GT off QUAD0_TX0_outclk (TXMSTCLK=TX0), fanned to all four
 *       lanes. All four TX lanes are driven from the same PLL, so the figure draws
 *       TXOUTCLK as a single net with junction dots tapping tx_core_clk[0..3].
 *         O1 (full rate) -> mrmac tx_core_clk        (x4, shared)
 *         O2 (rate / 2)  -> gtwiz QUAD0_TX0..3_usrclk (x4, shared)
 *                        AND mrmac tx_alt_serdes_clk  (x4, shared)
 *     RX - FOUR MBUFG_GTs, one per lane, off QUAD0_RX{0,1,2,3}_outclk. Each lane
 *       recovers its RX clock from its OWN CDR, so the figure draws rx_serdes_clk
 *       [0] and rx_serdes_clk[3] as separate nets from separate lane buffers.
 *         O1 (full rate) -> mrmac rx_core_clk[n] & rx_serdes_clk[n]
 *         O2 (rate / 2)  -> gtwiz QUAD0_RXn_usrclk
 *                        AND mrmac rx_alt_serdes_clk[n]
 *       This requires gtwiz CONFIG.QUAD0_RX{1,2,3}_OUTCLK_EN {true} (the exdes
 *       sets all four RX enables true). Set RX_PER_LANE_CLK=0 to fall back to the
 *       older single-buffer broadcast - see that parameter's comment for why that
 *       is wrong on hardware yet harmless in a serial-loopback sim.
 *   DIV is always 0 - the /2 is the fixed MBUFG_GT O2 tap, so the topology holds
 *   whatever rate gtwiz emits; the actual rate is set by the gtwiz INT/USER
 *   data-width CONFIG. Clears come from gtwiz INTF0_TX_clr_out / INTF0_RX_clr_out;
 *   there is ONE pair per direction (not per lane), so all four RX buffers share
 *   the RX pair, exactly as the exdes does.
 * ---------------------------------------------------------------------------
 * PIN-WIDTH RULE (probed in real Vivado 2025.2, xcvp1802):
 *   * gtwiz_versal exposes SCALAR per-channel usrclk/outclk pins and SCALAR
 *     per-interface clr_out/clrb_leaf_out/rst_done pins.
 *   * mrmac_0 exposes [3:0] VECTOR clock/reset pins (tx_core_clk[3:0], ...).
 *   * A BD connect_bd_net CANNOT slice a vector cell-pin to a scalar cell-pin.
 *     So this glue presents SCALAR ports on the gtwiz-facing side and [3:0]
 *     vector ports on the mrmac-facing side; it is exactly that bridge, plus the
 *     primitives that must live in RTL.
 * ---------------------------------------------------------------------------
 *
 * NOT handled here (driven on the BD): gtwiz control-plane constants (loopback,
 * GPI, line rate), the gtwiz datapath/pll resets, gtwiz_freerun_clk, and both
 * AXI4-Lite register interfaces (mrmac s_axi + gtwiz QUAD0_AXI_LITE, exposed at
 * the corundum hierarchy boundary for a consumer CPU to run the MRMAC bring-up
 * register sequence - MRMAC has NO hardware tx/rx enable pin). The gtwiz serial
 * pins (Quad0_GT_Serial) connect to the external QSFP. The serdes DATA path DOES
 * pass through this glue under GTM (width adaptation, see the SERDES DATA
 * section) - unlike the GTYP flow, where it was wired directly in the BD.
 */

`timescale 1ns/100ps

module mrmac_versal_glue #(
  // GT transceiver family this glue is elaborated against. Selects the two
  // family-specific primitives below (the refclk input buffer and the PTP
  // BUFG_GT SIM_DEVICE) AND the per-lane serdes-data widths. Default "GTM"
  // preserves the VPK180/Versal-Premium build byte-for-byte; the VCK190/
  // Versal-AI-Core build passes "GTY".
  parameter GT_TYPE = "GTM",
  // RX user-clock topology. Each GTY/GTM lane recovers its RX clock from its OWN
  // CDR, so PG314's 1x100G clocking figure (X21095-062118) draws rx_serdes_clk[0]
  // and rx_serdes_clk[3] as SEPARATE nets from separate lane buffers - unlike
  // TXOUTCLK, which it draws as one net with junction dots tapping tx_core_clk
  // [0..3]. RX is per-lane; TX is shared. The MRMAC NEW-flow example design
  // implements exactly that (mrmac_0_exdes.sv:650-654: four RX MBUFG_GTs off
  // ch{0,1,2,3}_rxoutclk, ONE TX MBUFG_GT fanned to all four tx_core_clk lanes).
  //
  //   RX_PER_LANE_CLK = 1 (correct, matches the figure and the exdes): four RX
  //     MBUFG_GTs, one per lane, off gt_rx_outclk_{0,1,2,3}. Requires the gtwiz
  //     CONFIG.QUAD0_RX{1,2,3}_OUTCLK_EN {true} so those outclk pins exist.
  //   RX_PER_LANE_CLK = 0 (legacy): ONE RX MBUFG_GT off the master RX outclk,
  //     broadcast to all four lanes. Only lane 0's recovered clock is used, so
  //     lanes 1-3 are sampled in the wrong domain. This is BENIGN in a serial
  //     loopback sim (all four lanes carry the same ideal clock, which is why the
  //     loopback still reaches aligned=1 block_lock=0xfffff) but is NOT correct
  //     on real hardware with four independent CDRs. Kept only so the GTM/VPK180
  //     build stays byte-identical until its gtwiz outclk enables are flipped too.
  //
  // TX is shared in BOTH modes - there is one TX MBUFG_GT regardless.
  parameter RX_PER_LANE_CLK = (GT_TYPE == "GTY") ? 1 : 0,
  // Per-lane serdes-data widths, derived from GT_TYPE. GTM: MRMAC drives 160b
  // and gtwiz's channel-data pin is 256b. GTY: MRMAC drives 80b and gtwiz's
  // channel-data pin is 128b. In both families the useful data is the low
  // MRMAC_SERDES_W bits, zero-extended into the wider gtwiz envelope. These are
  // declared as derived parameters so the port widths track GT_TYPE; the VCK190
  // island tcl also sets them explicitly (belt-and-suspenders in case the BD
  // bakes the GTM-default width when only GT_TYPE is overridden).
  parameter MRMAC_SERDES_W = (GT_TYPE == "GTY") ? 80  : 160,
  parameter GT_CH_W        = (GT_TYPE == "GTY") ? 128 : 256
) (
  // ---- GT reference clock (board differential pair -> gtwiz) ----------------
  input  wire        gt_ref_clk_p,
  input  wire        gt_ref_clk_n,
  output wire        gt_refclk_out,          // -> gtwiz_versal QUAD0_GTREFCLK0

  // BUFG'd copy of the GT reference clock, brought into the fabric for the
  // Corundum PTP hardware clock (mirrors VCU118's qsfp_mgt_refclk_bufg). ODIV2
  // of the IBUFDS_GTME5 is the FULL refclk (REFCLK_HROW_CK_SEL=2'b00 -> /1), so
  // this equals the board refclk (156.25 MHz) and PTP_CLK_PERIOD_NS must match.
  output wire        ptp_refclk_bufg,

  // ---- AXIS client clock + PTP timestamp clock + board reset ---------------
  input  wire        axis_clk_in,            // MRMAC AXIS client clock (390.625 MHz)
  // Separate, SLOWER PTP timestamp clock. The 100G segmented AXIS client clock
  // (390.625 MHz, period 2.56 ns) is OUTSIDE the MRMAC ts-clk legal range
  // (TIMESTAMP_CLK_PERIOD_NS in (2.8571, 20.0) ns = 50-350 MHz; 2.56 ns is
  // REJECTED with [IP_Flow 19-3488]). So the timestamp clock cannot equal the
  // AXIS clock and is driven from a dedicated clk_wizard output (250 MHz).
  input  wire        ts_clk_in,              // MRMAC PTP timestamp clock (250 MHz)
  input  wire        pl_resetn,              // board reset, active-LOW

  // ==========================================================================
  // gtwiz-facing side (single bonded CAUI-4 interface INTF0, quad channels 0..3)
  // ==========================================================================
  // ---- from gtwiz_versal: output clocks -------------------------------------
  // TX: only the master TX outclk is enabled (gtwiz TXMSTCLK=TX0) and it feeds
  // all four lanes - the four TX lanes share one clock (PG314 figure
  // X21095-062118 draws TXOUTCLK as a single net tapping tx_core_clk[0..3]).
  //
  // RX: each lane recovers its own clock from its own CDR, so at
  // RX_PER_LANE_CLK=1 all four RX outclks are consumed, one per lane. gt_rx_outclk
  // is lane 0 (the master, RXMSTCLK=RX0) and gt_rx_outclk_{1,2,3} are the other
  // three; the gtwiz must have CONFIG.QUAD0_RX{1,2,3}_OUTCLK_EN {true} for those
  // pins to exist. At RX_PER_LANE_CLK=0 only gt_rx_outclk is used; the extra three
  // inputs are then unread, and a GTM BD that leaves them unconnected elaborates
  // unchanged (an unconnected input on a BD module cell is legal - it is not a
  // clock pin needing a source, since nothing downstream consumes it in that mode).
  // NOTE: these are plain inputs with NO default value. Verilog-2005 rejects
  // default port values ("Default port value requires SystemVerilog") and this
  // file is compiled as .v - verified with iverilog.
  //
  // X_INTERFACE_IGNORE on the three ADDED ports: their names contain "clk", so
  // Vivado would infer CONFIG.TYPE=clk, and a BD clock pin with no clock source is
  // a hard error ([BD 41-758]) - which is exactly the GTM case, where they are
  // intentionally left unconnected. Suppressing inference leaves them untyped,
  // which still connects cleanly to gtwiz's outclk pins on the GTY side (same
  // reasoning as the mrmac-facing outputs below). gt_rx_outclk itself is left typed
  // and unchanged - it is always connected.
  input  wire        gt_tx_outclk,           // <- QUAD0_TX0_outclk (master TX)
  input  wire        gt_rx_outclk,           // <- QUAD0_RX0_outclk (master RX, lane 0)
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_1,         // <- QUAD0_RX1_outclk (RX_PER_LANE_CLK=1 only)
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_2,         // <- QUAD0_RX2_outclk (RX_PER_LANE_CLK=1 only)
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_3,         // <- QUAD0_RX3_outclk (RX_PER_LANE_CLK=1 only)

  // ---- from gtwiz_versal: MBUFG clears (NEW flow - gtwiz masters them) -------
  // Under IS_GT_WIZ_OLD=0 the GT reset FSM lives in gtwiz, which sources the
  // MBUFG async clears. ONE clr pair per direction per interface (not per lane):
  // the TX pair feeds the single TX MBUFG, and the RX pair feeds ALL the RX MBUFGs
  // (all four of them at RX_PER_LANE_CLK=1). The exdes does the same - it fans
  // INTF0_RX_clr_out out to per-lane wires for readability only (:1446-1453).
  input  wire        gt_tx_clr,              // <- gtwiz INTF0_TX_clr_out
  input  wire        gt_tx_clrb_leaf,        // <- gtwiz INTF0_TX_clrb_leaf_out
  input  wire        gt_rx_clr,              // <- gtwiz INTF0_RX_clr_out
  input  wire        gt_rx_clrb_leaf,        // <- gtwiz INTF0_RX_clrb_leaf_out

  // ---- from gtwiz_versal: per-interface reset-done --------------------------
  // gtwiz raises these when its TX/RX datapath is up. The glue holds the MRMAC
  // core+serdes in reset until then (exdes 663-666: {4{~INTF0_rst_*_done_out}}).
  input  wire        gt_rst_tx_done,         // <- gtwiz INTF0_rst_tx_done_out
  input  wire        gt_rst_rx_done,         // <- gtwiz INTF0_rst_rx_done_out

  // ---- to gtwiz_versal: per-channel user clocks -----------------------------
  // TX bonded (all = TX MBUFG O2); RX per-lane (each = that lane's RX MBUFG O2).
  output wire        gt_tx_usrclk_0,         // -> QUAD0_TX0_usrclk
  output wire        gt_tx_usrclk_1,         // -> QUAD0_TX1_usrclk
  output wire        gt_tx_usrclk_2,         // -> QUAD0_TX2_usrclk
  output wire        gt_tx_usrclk_3,         // -> QUAD0_TX3_usrclk
  output wire        gt_rx_usrclk_0,         // -> QUAD0_RX0_usrclk
  output wire        gt_rx_usrclk_1,         // -> QUAD0_RX1_usrclk
  output wire        gt_rx_usrclk_2,         // -> QUAD0_RX2_usrclk
  output wire        gt_rx_usrclk_3,         // -> QUAD0_RX3_usrclk

  // ---- to gtwiz_versal: interface "reset all" (from board reset) ------------
  output wire        gt_rst_all,             // -> INTF0_rst_all_in (active-high)

  // ==========================================================================
  // mrmac-facing clock/reset outputs: [3:0] VECTOR (matches mrmac_0's pins)
  // ==========================================================================
  // NOTE: X_INTERFACE_IGNORE on every mrmac-facing clock/reset output. Without
  // it, Vivado infers CONFIG.TYPE=clk (from "clk" in the port name) and then
  // connect_bd_net REFUSES the wire to mrmac_0's inputs, which the IP types as
  // gt_usrclk: "Cannot connect pins of incompatible types (clk) and
  // (gt_usrclk)" [BD 41-1170]. Suppressing inference leaves the pin untyped,
  // which connects to gt_usrclk (and to plain clocks) cleanly. Verified in
  // Vivado 2025.2 (xcvp1802). All nets here are driven by explicit
  // connect_bd_net in corundum_vpk180_mac.tcl, so ignoring inference is safe.
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_core_clk,      // -> mrmac_0 tx_core_clk   (TX O1, bonded)
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_core_clk,      // -> mrmac_0 rx_core_clk   (RX O1, per-lane)
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_serdes_clk,    // -> mrmac_0 rx_serdes_clk (RX O1, per-lane)
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_alt_serdes_clk,// -> mrmac_0 tx_alt_serdes_clk (TX O2, bonded)
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_alt_serdes_clk,// -> mrmac_0 rx_alt_serdes_clk (RX O2, per-lane)
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_ts_clk,           // -> mrmac_0 tx_ts_clk & rx_ts_clk
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_axi_clk,          // -> mrmac_0 tx_axi_clk & rx_axi_clk ([3:0], 4 GT lanes)
  // Flex-interface clock. Unused in MAC+PCS AXIS mode, but mrmac_0 exposes
  // tx_flexif_clk/rx_flexif_clk as clock inputs; a BD clock pin MUST have a real
  // clock source or validate_bd_design errors [BD 41-758] (the exdes ties it to
  // 0 in pure RTL, which a BD cannot do). Driven from the AXIS clock - benign,
  // the flex datapath is inactive.
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_flexif_clk,       // -> mrmac_0 tx_flexif_clk & rx_flexif_clk

  // ---- to the ethernet_vpk180 shim: AXIS-domain reset -----------------------
  // mrmac_0 has NO axi reset pin; this drives ONLY the shim's tx/rx_reset_in.
  // SCALAR, not [3:0]: the shim is PORT_COUNT=1, so its mrmac_tx_reset_in /
  // mrmac_rx_reset_in are 1-bit ([PORT_COUNT-1:0]). (The mrmac-facing clock/reset
  // outputs above stay [3:0] because mrmac_0's pins are per-GT-lane [3:0]
  // regardless of port count; only the shim collapsed to 1 bit at 100G.) The
  // shim's AXIS clock is driven directly from clk_wizard/clk_out1 in the BD (same
  // net that feeds axis_clk_in here), so no scalar clock port is needed - only
  // the reset, which requires the ~pl_resetn inversion done here.
  (* X_INTERFACE_IGNORE = "true" *)
  output wire        shim_axi_reset,         // -> shim mrmac_tx_reset_in & mrmac_rx_reset_in

  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_core_reset,    // -> mrmac_0 tx_core_reset
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_core_reset,    // -> mrmac_0 rx_core_reset
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_serdes_reset,  // -> mrmac_0 tx_serdes_reset
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_serdes_reset,  // -> mrmac_0 rx_serdes_reset
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_flexif_reset,     // -> mrmac_0 rx_flexif_reset

  // ==========================================================================
  // Serdes-data path (per-lane, 4 CAUI-4 lanes). MRMAC drives/consumes
  // MRMAC_SERDES_W bits per lane; gtwiz's channel data pins are GT_CH_W bits.
  // The glue adapts the width (both derived from GT_TYPE):
  //   GTM: MRMAC 160b (txdata_in/rxdata_out) <-> gtwiz 256b
  //   GTY: MRMAC  80b (tx_serdes_data/rx_serdes_data) <-> gtwiz 128b
  //   TX: mrmac_txdata_in_${n} [MRMAC_SERDES_W-1:0] -> gt_ch_txdata_${n}
  //       [GT_CH_W-1:0] (zero-extend the unused upper envelope bits)
  //   RX: gt_ch_rxdata_${n} [GT_CH_W-1:0] -> mrmac_rxdata_out_${n}
  //       [MRMAC_SERDES_W-1:0] (take the low MRMAC_SERDES_W bits)
  // X_INTERFACE_IGNORE keeps Vivado from inferring a data/clock interface on
  // these plain-vector pins (same rationale as the clock/reset outputs above).
  // ---- TX: MRMAC serdes-out -> gtwiz channel-in --------------------------
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_0,     // <- mrmac_0 tx serdes 0
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_1,     // <- mrmac_0 tx serdes 1
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_2,     // <- mrmac_0 tx serdes 2
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_3,     // <- mrmac_0 tx serdes 3
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_0,        // -> gtwiz INTF0_TX0_ch_txdata
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_1,        // -> gtwiz INTF0_TX1_ch_txdata
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_2,        // -> gtwiz INTF0_TX2_ch_txdata
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_3,        // -> gtwiz INTF0_TX3_ch_txdata

  // ---- RX: gtwiz channel-out -> MRMAC serdes-in --------------------------
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_0,        // <- gtwiz INTF0_RX0_ch_rxdata
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_1,        // <- gtwiz INTF0_RX1_ch_rxdata
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_2,        // <- gtwiz INTF0_RX2_ch_rxdata
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_3,        // <- gtwiz INTF0_RX3_ch_rxdata
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_0,    // -> mrmac_0 rx serdes 0
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_1,    // -> mrmac_0 rx serdes 1
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_2,    // -> mrmac_0 rx serdes 2
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_3,    // -> mrmac_0 rx serdes 3

  // ==========================================================================
  // AXIS datapath: the ethernet_vpk180 shim exposes ONE 384b segmented bus
  // (six 64b segments packed low-segment-first, plus one 66b tkeep_user vector
  // = six 11b per-segment fields) with a SINGLE handshake. mrmac_0 exposes the
  // six segments as separate pins (tdata0..5 / tkeep_user0..5) with a single
  // tvalid_0/tready_0/tlast_0. A BD connect_bd_net cannot slice the shim's
  // packed bus, so the split/join happens here. Pure re-packing, NOT width
  // conversion (64b + 11b per segment on both sides).
  // --------------------------------------------------------------------------
  // TX: shim (master) -> mrmac (slave). Shim drives data/keep/valid/last;
  // mrmac drives tready back.
  input  wire [383:0] shim_tx_axis_tdata,        // shim mrmac_tx_axis_tdata      [SEG_COUNT*64-1:0]
  input  wire [65:0]  shim_tx_axis_tkeep_user,   // shim mrmac_tx_axis_tkeep_user [SEG_COUNT*11-1:0]
  input  wire         shim_tx_axis_tvalid,
  input  wire         shim_tx_axis_tlast,
  output wire         shim_tx_axis_tready,

  output wire [63:0]  mrmac_tx_axis_tdata0,      // -> mrmac_0 tx_axis_tdata0 (segment 0)
  output wire [63:0]  mrmac_tx_axis_tdata1,
  output wire [63:0]  mrmac_tx_axis_tdata2,
  output wire [63:0]  mrmac_tx_axis_tdata3,
  output wire [63:0]  mrmac_tx_axis_tdata4,
  output wire [63:0]  mrmac_tx_axis_tdata5,
  output wire [10:0]  mrmac_tx_axis_tkeep_user0,
  output wire [10:0]  mrmac_tx_axis_tkeep_user1,
  output wire [10:0]  mrmac_tx_axis_tkeep_user2,
  output wire [10:0]  mrmac_tx_axis_tkeep_user3,
  output wire [10:0]  mrmac_tx_axis_tkeep_user4,
  output wire [10:0]  mrmac_tx_axis_tkeep_user5,
  output wire         mrmac_tx_axis_tvalid_0,    // -> mrmac_0 tx_axis_tvalid_0
  output wire         mrmac_tx_axis_tlast_0,     // -> mrmac_0 tx_axis_tlast_0
  input  wire         mrmac_tx_axis_tready_0,    // <- mrmac_0 tx_axis_tready_0

  // RX: mrmac (master) -> shim (slave), valid-only (no tready on this MRMAC
  // config - the shim FIFO always accepts).
  input  wire [63:0]  mrmac_rx_axis_tdata0,      // <- mrmac_0 rx_axis_tdata0 (segment 0)
  input  wire [63:0]  mrmac_rx_axis_tdata1,
  input  wire [63:0]  mrmac_rx_axis_tdata2,
  input  wire [63:0]  mrmac_rx_axis_tdata3,
  input  wire [63:0]  mrmac_rx_axis_tdata4,
  input  wire [63:0]  mrmac_rx_axis_tdata5,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user0,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user1,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user2,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user3,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user4,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user5,
  input  wire         mrmac_rx_axis_tvalid_0,    // <- mrmac_0 rx_axis_tvalid_0
  input  wire         mrmac_rx_axis_tlast_0,     // <- mrmac_0 rx_axis_tlast_0

  output wire [383:0] shim_rx_axis_tdata,        // -> shim mrmac_rx_axis_tdata
  output wire [65:0]  shim_rx_axis_tkeep_user,   // -> shim mrmac_rx_axis_tkeep_user
  output wire         shim_rx_axis_tvalid,       // -> shim mrmac_rx_axis_tvalid
  output wire         shim_rx_axis_tlast,        // -> shim mrmac_rx_axis_tlast

  // ---- MAC RX link status ---------------------------------------------------
  // Bonded 100G link: the four stat_rx_status_0..3 lanes rise together; the
  // shim wants one status bit, so take lane 0.
  input  wire         mrmac_stat_rx_status_0,    // <- mrmac_0 stat_rx_status_0
  output wire         shim_stat_rx_status,       // -> shim mrmac_stat_rx_status

  // ==========================================================================
  // PTP interface (single 100G port). The shim carries PTP as flat vectors;
  // mrmac_0 exposes per-port pins with a _0 suffix (only port 0 exists in 100G
  // mode). Whole-pin 1:1 connects on the mrmac side. Widths: tstamp/systemtimer
  // = 55b (MRMAC {ns,fns8}), 1588op = 2b, tag = 16b. The 55b<->80b Corundum
  // format conversion and the sync/overwrite FSM live in the shim, not here.
  // ==========================================================================
  // RX timestamp (mrmac -> shim).
  input  wire [54:0]  mrmac_rx_ptp_tstamp_0,     // <- mrmac_0 rx_ptp_tstamp_out_0
  output wire [54:0]  shim_rx_ptp_tstamp,        // -> shim mrmac_rx_ptp_tstamp

  // TX op/tag (shim -> mrmac).
  input  wire [1:0]   shim_tx_ptp_1588op,        // shim mrmac_tx_ptp_1588op
  input  wire [15:0]  shim_tx_ptp_tag_field,     // shim mrmac_tx_ptp_tag_field
  output wire [1:0]   mrmac_tx_ptp_1588op_0,     // -> mrmac_0 tx_ptp_1588op_in_0
  output wire [15:0]  mrmac_tx_ptp_tag_field_0,  // -> mrmac_0 tx_ptp_tag_field_in_0

  // TX completion (mrmac -> shim).
  input  wire [54:0]  mrmac_tx_ptp_tstamp_0,     // <- mrmac_0 tx_ptp_tstamp_out_0
  input  wire [15:0]  mrmac_tx_ptp_tstamp_tag_0, // <- mrmac_0 tx_ptp_tstamp_tag_out_0
  input  wire         mrmac_tx_ptp_tstamp_valid_0, // <- mrmac_0 tx_ptp_tstamp_valid_out_0
  output wire [54:0]  shim_tx_ptp_tstamp,        // -> shim mrmac_tx_ptp_tstamp
  output wire [15:0]  shim_tx_ptp_tstamp_tag,    // -> shim mrmac_tx_ptp_tstamp_tag
  output wire         shim_tx_ptp_tstamp_valid,  // -> shim mrmac_tx_ptp_tstamp_valid

  // System-timer discipline (shim -> mrmac).
  input  wire [54:0]  shim_tx_ptp_systemtimer,   // shim mrmac_tx_ptp_systemtimer
  input  wire         shim_tx_ptp_st_sync,       // shim mrmac_tx_ptp_st_sync
  input  wire         shim_tx_ptp_st_overwrite,  // shim mrmac_tx_ptp_st_overwrite
  input  wire [54:0]  shim_rx_ptp_systemtimer,   // shim mrmac_rx_ptp_systemtimer
  input  wire         shim_rx_ptp_st_sync,       // shim mrmac_rx_ptp_st_sync
  input  wire         shim_rx_ptp_st_overwrite,  // shim mrmac_rx_ptp_st_overwrite
  output wire [54:0]  mrmac_ctl_tx_ptp_systemtimer_0,  // -> mrmac_0 ctl_tx_ptp_systemtimer_0
  output wire         mrmac_ctl_tx_ptp_st_sync_0,      // -> mrmac_0 ctl_tx_ptp_st_sync_0
  output wire         mrmac_ctl_tx_ptp_st_overwrite_0, // -> mrmac_0 ctl_tx_ptp_st_overwrite_0
  output wire [54:0]  mrmac_ctl_rx_ptp_systemtimer_0,  // -> mrmac_0 ctl_rx_ptp_systemtimer_0
  output wire         mrmac_ctl_rx_ptp_st_sync_0,      // -> mrmac_0 ctl_rx_ptp_st_sync_0
  output wire         mrmac_ctl_rx_ptp_st_overwrite_0, // -> mrmac_0 ctl_rx_ptp_st_overwrite_0

  // ==========================================================================
  // Flow control (pause). Pure pass-through, shim <-> mrmac_0, like the PTP ctl
  // signals above. 9-bit [8:0] {lfc, pfc} vectors (bit 8 = link pause). Only
  // port 0 exists in 100G mode; the shim already forms/splits the vectors.
  // ==========================================================================
  input  wire [8:0]   shim_ctl_tx_pause_enable,  // shim mrmac_ctl_tx_pause_enable
  input  wire [8:0]   shim_ctl_tx_pause_req,     // shim mrmac_ctl_tx_pause_req
  input  wire [8:0]   shim_ctl_rx_pause_enable,  // shim mrmac_ctl_rx_pause_enable
  input  wire [8:0]   shim_ctl_rx_pause_ack,     // shim mrmac_ctl_rx_pause_ack
  output wire [8:0]   shim_stat_rx_pause_req,    // -> shim mrmac_stat_rx_pause_req
  output wire [8:0]   mrmac_ctl_tx_pause_enable_0, // -> mrmac_0 ctl_tx_pause_enable_0
  output wire [8:0]   mrmac_ctl_tx_pause_req_0,    // -> mrmac_0 ctl_tx_pause_req_0
  output wire [8:0]   mrmac_ctl_rx_pause_enable_0, // -> mrmac_0 ctl_rx_pause_enable_0
  output wire [8:0]   mrmac_ctl_rx_pause_ack_0,    // -> mrmac_0 ctl_rx_pause_ack_0
  input  wire [8:0]   mrmac_stat_rx_pause_req_0    // <- mrmac_0 stat_rx_pause_req_0
);

  ////////////////////////////////////////////////////////////////////////////
  // gtwiz "reset all" tracks the board reset (active-high). The GT holds in
  // reset while pl_resetn is asserted-low, then runs. One bonded interface.
  ////////////////////////////////////////////////////////////////////////////
  assign gt_rst_all = ~pl_resetn;

  ////////////////////////////////////////////////////////////////////////////
  // GT reference-clock input buffer
  ////////////////////////////////////////////////////////////////////////////
  // ODIV2 = the full reference clock (REFCLK_HROW_CK_SEL=2'b00 -> divide-by-1),
  // tapped into the fabric via a BUFG_GT for the PTP hardware clock. This mirrors
  // VCU118 (IBUFDS_GTE4.ODIV2 -> BUFG_GT(DIV=0) -> qsfp_mgt_refclk_bufg -> ptp_clk).
  //
  // GTM transceivers use IBUFDS_GTME5 (not the GTYP IBUFDS_GTE5). The two
  // primitives are interface-identical (same O/ODIV2/CEB/I/IB ports and same
  // REFCLK_* params, verified against the 2025.2 unisim models), so this is a
  // pure primitive swap. The GTM example XDC places it at GTM_REFCLK_X*Y* via
  // USE_IBUFDS_GTME5.GEN_IBUFDS_GTME5[0].IBUFDS_GTME5_U.
  wire gt_refclk_odiv2;

  // GTM transceivers use IBUFDS_GTME5; GTY use IBUFDS_GTE5. The two primitives
  // are interface-identical (same params REFCLK_EN_TX_PATH/HROW_CK_SEL/ICNTL_RX,
  // same ports O/ODIV2/CEB/I/IB) - only the primitive name differs by family.
  generate
    if (GT_TYPE == "GTY") begin : gen_ibufds_gte5
      IBUFDS_GTE5 #(
        .REFCLK_EN_TX_PATH  (1'b0),
        .REFCLK_HROW_CK_SEL (2'b00),
        .REFCLK_ICNTL_RX    (2'b00)
      ) i_ibufds_gte5_refclk (
        .O   (gt_refclk_out),
        .ODIV2 (gt_refclk_odiv2),
        .CEB (1'b0),
        .I   (gt_ref_clk_p),
        .IB  (gt_ref_clk_n)
      );
    end else begin : gen_ibufds_gtme5
      IBUFDS_GTME5 #(
        .REFCLK_EN_TX_PATH  (1'b0),
        .REFCLK_HROW_CK_SEL (2'b00),
        .REFCLK_ICNTL_RX    (2'b00)
      ) i_ibufds_gtme5_refclk (
        .O   (gt_refclk_out),
        .ODIV2 (gt_refclk_odiv2),
        .CEB (1'b0),
        .I   (gt_ref_clk_p),
        .IB  (gt_ref_clk_n)
      );
    end
  endgenerate

  // Bring ODIV2 onto a global clock buffer for the fabric PTP domain. DIV=3'd0
  // (divide-by-1) passes the full refclk through, so ptp_refclk_bufg is exactly
  // the board GT reference-clock frequency (156.25 MHz).
  BUFG_GT #(
    .SIM_DEVICE (GT_TYPE == "GTY" ? "VERSAL_AI_CORE" : "VERSAL_PREMIUM")
  ) i_bufg_gt_ptp_refclk (
    .O       (ptp_refclk_bufg),
    .CE      (1'b1),
    .CEMASK  (1'b1),
    .CLR     (1'b0),
    .CLRMASK (1'b1),
    .DIV     (3'd0),
    .I       (gt_refclk_odiv2)
  );

  ////////////////////////////////////////////////////////////////////////////
  // User-clock buffers. TX is SHARED (one MBUFG_GT fanned to all four lanes);
  // RX is PER-LANE at RX_PER_LANE_CLK=1 (four MBUFG_GTs, one per lane) because
  // each lane's CDR recovers its own RX clock. This asymmetry is exactly what
  // PG314 figure X21095-062118 draws and what mrmac_0_exdes.sv:650-654 implements.
  //
  //   TX (always one buffer, off QUAD0_TX0_outclk):
  //     O1 (full rate) -> mrmac tx_core_clk        (x4, shared)
  //     O2 (rate/2)    -> gtwiz QUAD0_TX0..3_usrclk (x4, shared)
  //                    AND mrmac tx_alt_serdes_clk  (x4, shared)
  //   RX lane n (RX_PER_LANE_CLK=1: four buffers, off QUAD0_RXn_outclk):
  //     O1 (full rate) -> mrmac rx_core_clk[n] & rx_serdes_clk[n]
  //     O2 (rate/2)    -> gtwiz QUAD0_RXn_usrclk AND mrmac rx_alt_serdes_clk[n]
  //   RX (RX_PER_LANE_CLK=0: one buffer off the master, broadcast x4 - legacy).
  //
  // DIV=0 on every MBUFG: the /2 is the fixed O2 tap (unisim MBUFG_GT.v:514-515 -
  // O1 is the pass-through, O2 toggles on each O1 rising edge), so the topology
  // holds at whatever rate gtwiz emits.
  //
  // CLEARS: gtwiz exposes ONE clr/clrb_leaf pair per direction per interface
  // (INTF0_RX_clr_out), not per lane, so all four RX MBUFG clears are driven from
  // that one pair. The exdes does the same - it fans INTF0_RX_clr_out out to
  // per-lane wires (mrmac_0_exdes.sv:1446-1453) purely for readability. So the
  // per-lane RX split needs NO new gtwiz clear pins.
  ////////////////////////////////////////////////////////////////////////////
  wire tx_usrclk_o1, tx_usrclk_o2;
  wire [3:0] rx_usrclk_o1, rx_usrclk_o2;

  // ---- shared TX ------------------------------------------------------------
  MBUFG_GT #(
    .MODE ("PERFORMANCE")
  ) i_mbufg_gt_tx (
    .O1        (tx_usrclk_o1),
    .O2        (tx_usrclk_o2),
    .O3        (),
    .O4        (),
    .CE        (1'b1),
    .CEMASK    (1'b0),
    .CLR       (gt_tx_clr),
    .CLRB_LEAF (gt_tx_clrb_leaf),
    .CLRMASK   (1'b0),
    .DIV       (3'b000),
    .I         (gt_tx_outclk)
  );

  // ---- RX ------------------------------------------------------------------
  // The four lane outclks gathered into one vector so the per-lane buffers can be
  // a generate loop. Lane 0 is the master outclk in both modes.
  wire [3:0] gt_rx_outclk_lane = {gt_rx_outclk_3, gt_rx_outclk_2,
                                  gt_rx_outclk_1, gt_rx_outclk};

  generate
    if (RX_PER_LANE_CLK) begin : g_rx_per_lane
      // One MBUFG_GT per lane, each off its own lane's recovered RX outclk.
      genvar l;
      for (l = 0; l < 4; l = l + 1) begin : g_lane
        MBUFG_GT #(
          .MODE ("PERFORMANCE")
        ) i_mbufg_gt_rx (
          .O1        (rx_usrclk_o1[l]),
          .O2        (rx_usrclk_o2[l]),
          .O3        (),
          .O4        (),
          .CE        (1'b1),
          .CEMASK    (1'b0),
          .CLR       (gt_rx_clr),
          .CLRB_LEAF (gt_rx_clrb_leaf),
          .CLRMASK   (1'b0),
          .DIV       (3'b000),
          .I         (gt_rx_outclk_lane[l])
        );
      end
    end else begin : g_rx_shared
      // Legacy: one buffer off the master RX outclk, broadcast to all four lanes.
      wire rx_usrclk_o1_m, rx_usrclk_o2_m;
      MBUFG_GT #(
        .MODE ("PERFORMANCE")
      ) i_mbufg_gt_rx (
        .O1        (rx_usrclk_o1_m),
        .O2        (rx_usrclk_o2_m),
        .O3        (),
        .O4        (),
        .CE        (1'b1),
        .CEMASK    (1'b0),
        .CLR       (gt_rx_clr),
        .CLRB_LEAF (gt_rx_clrb_leaf),
        .CLRMASK   (1'b0),
        .DIV       (3'b000),
        .I         (gt_rx_outclk)
      );
      assign rx_usrclk_o1 = {4{rx_usrclk_o1_m}};
      assign rx_usrclk_o2 = {4{rx_usrclk_o2_m}};
    end
  endgenerate

  // O2 (rate/2) -> the GT's per-channel user clocks. TX shared; RX per-lane (each
  // lane's usrclk must come from that lane's own buffer - exdes:1427-1430).
  assign gt_tx_usrclk_0 = tx_usrclk_o2;
  assign gt_tx_usrclk_1 = tx_usrclk_o2;
  assign gt_tx_usrclk_2 = tx_usrclk_o2;
  assign gt_tx_usrclk_3 = tx_usrclk_o2;
  assign gt_rx_usrclk_0 = rx_usrclk_o2[0];
  assign gt_rx_usrclk_1 = rx_usrclk_o2[1];
  assign gt_rx_usrclk_2 = rx_usrclk_o2[2];
  assign gt_rx_usrclk_3 = rx_usrclk_o2[3];

  // O1 (full rate) -> the MRMAC core & RX serdes clocks. TX shared x4; RX carries
  // the per-lane vector straight through (exdes:650-652).
  assign mrmac_tx_core_clk   = {4{tx_usrclk_o1}};
  assign mrmac_rx_core_clk   = rx_usrclk_o1;
  assign mrmac_rx_serdes_clk = rx_usrclk_o1;

  // O2 (rate/2) -> the MRMAC alt-serdes clocks. TX shared x4; RX per-lane
  // (exdes:653-654). TX has no separate serdes clock in this mode (tx_core_clk +
  // tx_alt_serdes_clk only) - the PG314 figure shows no tx_serdes_clk either, and
  // the IP genuinely has no such pin.
  assign mrmac_tx_alt_serdes_clk = {4{tx_usrclk_o2}};
  assign mrmac_rx_alt_serdes_clk = rx_usrclk_o2;

  ////////////////////////////////////////////////////////////////////////////
  // AXIS client clock + PTP timestamp clock broadcast (bonded x4).
  //   * mrmac_axi_clk  <- axis_clk_in (390.625 MHz): TX/RX AXIS client clock.
  //   * mrmac_ts_clk   <- ts_clk_in  (250 MHz)     : PTP timestamp clock. It is
  //     a SEPARATE, slower domain because the 390.625 MHz AXIS clock exceeds the
  //     MRMAC ts-clk legal maximum (350 MHz) - see the ts_clk_in port comment.
  // The two are asynchronous. The shim's systemtimer load crosses into ts_clk
  // via MRMAC's built-in toggle+hold st_sync handshake (the value is held stable
  // for many ts_clk cycles around each st_sync edge, per PG314); the RX capture
  // (rx_ptp_tstamp_out) is presented by MRMAC in the rx_axi_clk domain, so the
  // shim reads it with no extra CDC. See corundum_vpk180_mac.tcl section 10.
  ////////////////////////////////////////////////////////////////////////////
  assign mrmac_axi_clk = {4{axis_clk_in}};
  assign mrmac_ts_clk  = {4{ts_clk_in}};

  // Flex-interface clock (unused in MAC+PCS AXIS mode). Driven from the AXIS
  // clock so the mrmac_0 tx/rx_flexif_clk BD clock pins have a valid clock
  // source (else [BD 41-758]); the flex datapath itself is inactive.
  assign mrmac_flexif_clk = {4{axis_clk_in}};

  // The shim's AXIS domain is reset from the board reset. mrmac_0 has no axi
  // reset pin, so this drives only the ethernet_vpk180 shim FIFOs (1-bit,
  // PORT_COUNT=1).
  assign shim_axi_reset = ~pl_resetn;

  ////////////////////////////////////////////////////////////////////////////
  // Core / serdes resets: hold the MRMAC core and serdes in reset until gtwiz's
  // TX/RX datapath reset completes (exdes 663-666). Under IS_GT_WIZ_OLD=0 the
  // reset-done comes from gtwiz INTF0_rst_{tx,rx}_done_out (one bit per
  // direction, broadcast to all four bonded lanes).
  ////////////////////////////////////////////////////////////////////////////
  assign mrmac_tx_core_reset   = {4{~gt_rst_tx_done}};
  assign mrmac_tx_serdes_reset = {4{~gt_rst_tx_done}};
  assign mrmac_rx_core_reset   = {4{~gt_rst_rx_done}};
  assign mrmac_rx_serdes_reset = {4{~gt_rst_rx_done}};

  // Flex interface reset tracks the board reset (exdes 619). The flex interface
  // is unused in this MAC+PCS AXIS build but the RX pin must be driven. (This
  // MRMAC config has no tx_flexif_reset pin.)
  assign mrmac_flexif_reset = {4{~pl_resetn}};

  ////////////////////////////////////////////////////////////////////////////
  // Serdes-data width adaptation (per CAUI-4 lane), parameterized by GT_TYPE.
  //   GTM (IS_GT_WIZ_OLD=0): MRMAC serdes bus 160b/lane; gtwiz channel data 256b.
  //     Probed in real Vivado 2025.2 (xcvp1802): mrmac txdata_in/rxdata_out=[159:0];
  //     gtwiz INTF0_{TX,RX}${n}_ch_{tx,rx}data=[255:0].
  //   GTY: MRMAC serdes bus 80b/lane (tx_serdes_data/rx_serdes_data); gtwiz
  //     channel data 128b. Confirmed in the VCK190 example (mrmac_0.v serdes ports
  //     [79:0]; mrmac_0_gtwiz_versal_intf_quad_map.v ch data [127:0]).
  //   In both families only the low MRMAC_SERDES_W bits carry the RAW serdes
  //   payload; gtwiz's upper (GT_CH_W - MRMAC_SERDES_W) TX-input bits are unused
  //   padding.
  //
  //   TX: zero-extend MRMAC MRMAC_SERDES_W -> gtwiz GT_CH_W (drives ALL gtwiz
  //       input bits, so no undriven-pin DRC - which is exactly why this cannot
  //       be a partial connect_bd_net in the BD).
  //   RX: take the low MRMAC_SERDES_W of gtwiz's GT_CH_W -> MRMAC. gtwiz's upper
  //       bits are don't-care under RAW/NRZ at this rate.
  ////////////////////////////////////////////////////////////////////////////
  localparam SERDES_PAD_W = GT_CH_W - MRMAC_SERDES_W;

  assign gt_ch_txdata_0 = {{SERDES_PAD_W{1'b0}}, mrmac_txdata_in_0};
  assign gt_ch_txdata_1 = {{SERDES_PAD_W{1'b0}}, mrmac_txdata_in_1};
  assign gt_ch_txdata_2 = {{SERDES_PAD_W{1'b0}}, mrmac_txdata_in_2};
  assign gt_ch_txdata_3 = {{SERDES_PAD_W{1'b0}}, mrmac_txdata_in_3};

  assign mrmac_rxdata_out_0 = gt_ch_rxdata_0[MRMAC_SERDES_W-1:0];
  assign mrmac_rxdata_out_1 = gt_ch_rxdata_1[MRMAC_SERDES_W-1:0];
  assign mrmac_rxdata_out_2 = gt_ch_rxdata_2[MRMAC_SERDES_W-1:0];
  assign mrmac_rxdata_out_3 = gt_ch_rxdata_3[MRMAC_SERDES_W-1:0];

  ////////////////////////////////////////////////////////////////////////////
  // Segmented AXIS pack/unpack. The shim's 384b bus is a low-segment-first
  // concatenation (segment s occupies data bits [s*64 +: 64], tkeep_user bits
  // [s*11 +: 11]); mrmac_0 exposes the six segments as separate pins. Single
  // handshake on both sides.
  //
  // TX (shim -> mrmac): split the packed bus into the six segment pins.
  ////////////////////////////////////////////////////////////////////////////
  assign mrmac_tx_axis_tdata0 = shim_tx_axis_tdata[0*64 +: 64];
  assign mrmac_tx_axis_tdata1 = shim_tx_axis_tdata[1*64 +: 64];
  assign mrmac_tx_axis_tdata2 = shim_tx_axis_tdata[2*64 +: 64];
  assign mrmac_tx_axis_tdata3 = shim_tx_axis_tdata[3*64 +: 64];
  assign mrmac_tx_axis_tdata4 = shim_tx_axis_tdata[4*64 +: 64];
  assign mrmac_tx_axis_tdata5 = shim_tx_axis_tdata[5*64 +: 64];

  assign mrmac_tx_axis_tkeep_user0 = shim_tx_axis_tkeep_user[0*11 +: 11];
  assign mrmac_tx_axis_tkeep_user1 = shim_tx_axis_tkeep_user[1*11 +: 11];
  assign mrmac_tx_axis_tkeep_user2 = shim_tx_axis_tkeep_user[2*11 +: 11];
  assign mrmac_tx_axis_tkeep_user3 = shim_tx_axis_tkeep_user[3*11 +: 11];
  assign mrmac_tx_axis_tkeep_user4 = shim_tx_axis_tkeep_user[4*11 +: 11];
  assign mrmac_tx_axis_tkeep_user5 = shim_tx_axis_tkeep_user[5*11 +: 11];

  assign mrmac_tx_axis_tvalid_0 = shim_tx_axis_tvalid;
  assign mrmac_tx_axis_tlast_0  = shim_tx_axis_tlast;
  assign shim_tx_axis_tready    = mrmac_tx_axis_tready_0;

  ////////////////////////////////////////////////////////////////////////////
  // RX (mrmac -> shim): join the six segment pins into the packed bus.
  ////////////////////////////////////////////////////////////////////////////
  assign shim_rx_axis_tdata = { mrmac_rx_axis_tdata5,
                                mrmac_rx_axis_tdata4,
                                mrmac_rx_axis_tdata3,
                                mrmac_rx_axis_tdata2,
                                mrmac_rx_axis_tdata1,
                                mrmac_rx_axis_tdata0 };

  assign shim_rx_axis_tkeep_user = { mrmac_rx_axis_tkeep_user5,
                                     mrmac_rx_axis_tkeep_user4,
                                     mrmac_rx_axis_tkeep_user3,
                                     mrmac_rx_axis_tkeep_user2,
                                     mrmac_rx_axis_tkeep_user1,
                                     mrmac_rx_axis_tkeep_user0 };

  assign shim_rx_axis_tvalid = mrmac_rx_axis_tvalid_0;
  assign shim_rx_axis_tlast  = mrmac_rx_axis_tlast_0;

  assign shim_stat_rx_status = mrmac_stat_rx_status_0;

  ////////////////////////////////////////////////////////////////////////////
  // PTP wiring (single port). Pure 1:1 (no packing needed at PORT_COUNT=1); the
  // format/FSM work lives in the shim (mrmac_gty_wrapper).
  ////////////////////////////////////////////////////////////////////////////
  // RX timestamp (mrmac -> shim).
  assign shim_rx_ptp_tstamp = mrmac_rx_ptp_tstamp_0;

  // TX op / tag (shim -> mrmac).
  assign mrmac_tx_ptp_1588op_0    = shim_tx_ptp_1588op;
  assign mrmac_tx_ptp_tag_field_0 = shim_tx_ptp_tag_field;

  // TX completion (mrmac -> shim).
  assign shim_tx_ptp_tstamp       = mrmac_tx_ptp_tstamp_0;
  assign shim_tx_ptp_tstamp_tag   = mrmac_tx_ptp_tstamp_tag_0;
  assign shim_tx_ptp_tstamp_valid = mrmac_tx_ptp_tstamp_valid_0;

  // System-timer discipline (shim -> mrmac).
  assign mrmac_ctl_tx_ptp_systemtimer_0  = shim_tx_ptp_systemtimer;
  assign mrmac_ctl_tx_ptp_st_sync_0      = shim_tx_ptp_st_sync;
  assign mrmac_ctl_tx_ptp_st_overwrite_0 = shim_tx_ptp_st_overwrite;
  assign mrmac_ctl_rx_ptp_systemtimer_0  = shim_rx_ptp_systemtimer;
  assign mrmac_ctl_rx_ptp_st_sync_0      = shim_rx_ptp_st_sync;
  assign mrmac_ctl_rx_ptp_st_overwrite_0 = shim_rx_ptp_st_overwrite;

  // Flow control (pause) - pure pass-through, shim <-> mrmac_0.
  assign mrmac_ctl_tx_pause_enable_0 = shim_ctl_tx_pause_enable;
  assign mrmac_ctl_tx_pause_req_0    = shim_ctl_tx_pause_req;
  assign mrmac_ctl_rx_pause_enable_0 = shim_ctl_rx_pause_enable;
  assign mrmac_ctl_rx_pause_ack_0    = shim_ctl_rx_pause_ack;
  assign shim_stat_rx_pause_req      = mrmac_stat_rx_pause_req_0;

endmodule
