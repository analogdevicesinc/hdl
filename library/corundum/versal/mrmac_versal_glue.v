// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MODE="1x100G": one CAUI-4 port, independent 384b non-segmented, on one
 * bonded gtwiz interface INTF0 (four lanes).
 * MODE="1x40G": one XLAUI-4 port, independent 256b non-segmented (words 0..3).
 * MODE="4x25G": four independent 25GBASE-R ports, 64b non-segmented, on gtwiz
 * INTF0..3 with one lane each.
 */

`timescale 1ns/100ps

module mrmac_versal_glue #(
  parameter GT_TYPE = "GTM",
  parameter MODE = "1x100G",
  parameter PORTS = (MODE == "4x25G") ? 4 : 1,
  // GT channel of MRMAC port n, 2 bits per port, port 0 in [1:0]
  parameter TX_CH_MAP = 8'b11_10_01_00,
  parameter RX_CH_MAP = 8'b11_10_01_00,
  // 1: one RX MBUFG_GT per lane
  // 0: one RX MBUFG_GT off the lane 0 outclk broadcast to all lanes
  parameter RX_PER_LANE_CLK = (GT_TYPE != "GTM") ? 1 : 0,
  // Per-lane serdes data widths (MRMAC / gtwiz channel).
  parameter MRMAC_SERDES_W = (GT_TYPE != "GTM") ? 80  : 160,
  parameter GT_CH_W        = (GT_TYPE != "GTM") ? 128 : 256,
  // 1: build one mrmac_axis_loopback per port between the MRMAC client streams
  // and the shim; 0: plain pass-through
  parameter LOOPBACK_ENABLE = 0,
  // Per-port shim AXIS widths: six 64b words and six 11b
  // tkeep_user fields at 1x100G, four at 1x40G, one of each at 4x25G.
  parameter SHIM_W = (MODE == "4x25G") ? 64 : (MODE == "1x40G") ? 256 : 384,
  parameter KU_W   = SHIM_W / 64 * 11
) (
  input  wire        gt_ref_clk_p,
  input  wire        gt_ref_clk_n,
  output wire        gt_refclk_out,

  output wire        ptp_refclk_bufg,

  input  wire        axis_clk_in,
  input  wire        ts_clk_in,
  input  wire        pl_resetn,

  input  wire        loopback_en,
  input  wire        loopback_mac_swap,

  // Suffix _n (none for 0) is GT channel n.
  input  wire        gt_tx_outclk,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_tx_outclk_1,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_tx_outclk_2,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_tx_outclk_3,
  input  wire        gt_rx_outclk,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_1,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_2,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire        gt_rx_outclk_3,

  input  wire        gt_tx_clr,
  input  wire        gt_tx_clr_1,
  input  wire        gt_tx_clr_2,
  input  wire        gt_tx_clr_3,
  input  wire        gt_tx_clrb_leaf,
  input  wire        gt_tx_clrb_leaf_1,
  input  wire        gt_tx_clrb_leaf_2,
  input  wire        gt_tx_clrb_leaf_3,
  input  wire        gt_rx_clr,
  input  wire        gt_rx_clr_1,
  input  wire        gt_rx_clr_2,
  input  wire        gt_rx_clr_3,
  input  wire        gt_rx_clrb_leaf,
  input  wire        gt_rx_clrb_leaf_1,
  input  wire        gt_rx_clrb_leaf_2,
  input  wire        gt_rx_clrb_leaf_3,

  input  wire        gt_rst_tx_done,
  input  wire        gt_rst_tx_done_1,
  input  wire        gt_rst_tx_done_2,
  input  wire        gt_rst_tx_done_3,
  input  wire        gt_rst_rx_done,
  input  wire        gt_rst_rx_done_1,
  input  wire        gt_rst_rx_done_2,
  input  wire        gt_rst_rx_done_3,

  output wire        gt_tx_usrclk_0,
  output wire        gt_tx_usrclk_1,
  output wire        gt_tx_usrclk_2,
  output wire        gt_tx_usrclk_3,
  output wire        gt_rx_usrclk_0,
  output wire        gt_rx_usrclk_1,
  output wire        gt_rx_usrclk_2,
  output wire        gt_rx_usrclk_3,

  output wire        gt_rst_all,

  // [3:0] per GT lane (= per port at 4x25G).
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_core_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_core_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_serdes_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_alt_serdes_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_alt_serdes_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_ts_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_axi_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_flexif_clk,

  (* X_INTERFACE_IGNORE = "true" *)
  output wire        shim_axi_reset,

  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_core_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_core_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_tx_serdes_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_rx_serdes_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0]  mrmac_flexif_reset,

  // mrmac_*_n is MRMAC lane n, gt_ch_*_n is GT channel n
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_0,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_1,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_2,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [MRMAC_SERDES_W-1:0] mrmac_txdata_in_3,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_0,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_1,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_2,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [GT_CH_W-1:0] gt_ch_txdata_3,

  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_0,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_1,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_2,
  (* X_INTERFACE_IGNORE = "true" *)
  input  wire [GT_CH_W-1:0] gt_ch_rxdata_3,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_0,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_1,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_2,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [MRMAC_SERDES_W-1:0] mrmac_rxdata_out_3,

  // AXIS. Shim: port p at [p*SHIM_W +: SHIM_W] (words low first) and
  // [p*KU_W +: KU_W] (11b fields), one bit per port for the handshakes.
  // MRMAC: one pin per 64b word; 1x100G uses words 0..5 and 1x40G words 0..3 with the _0
  // handshakes, 4x25G port p uses word 2p with the _p handshakes.
  input  wire [PORTS*SHIM_W-1:0] shim_tx_axis_tdata,
  input  wire [PORTS*KU_W-1:0]   shim_tx_axis_tkeep_user,
  input  wire [PORTS-1:0]        shim_tx_axis_tvalid,
  input  wire [PORTS-1:0]        shim_tx_axis_tlast,
  output wire [PORTS-1:0]        shim_tx_axis_tready,

  output wire [63:0]  mrmac_tx_axis_tdata0,
  output wire [63:0]  mrmac_tx_axis_tdata1,
  output wire [63:0]  mrmac_tx_axis_tdata2,
  output wire [63:0]  mrmac_tx_axis_tdata3,
  output wire [63:0]  mrmac_tx_axis_tdata4,
  output wire [63:0]  mrmac_tx_axis_tdata5,
  output wire [63:0]  mrmac_tx_axis_tdata6,
  output wire [10:0]  mrmac_tx_axis_tkeep_user0,
  output wire [10:0]  mrmac_tx_axis_tkeep_user1,
  output wire [10:0]  mrmac_tx_axis_tkeep_user2,
  output wire [10:0]  mrmac_tx_axis_tkeep_user3,
  output wire [10:0]  mrmac_tx_axis_tkeep_user4,
  output wire [10:0]  mrmac_tx_axis_tkeep_user5,
  output wire [10:0]  mrmac_tx_axis_tkeep_user6,
  output wire         mrmac_tx_axis_tvalid_0,
  output wire         mrmac_tx_axis_tvalid_1,
  output wire         mrmac_tx_axis_tvalid_2,
  output wire         mrmac_tx_axis_tvalid_3,
  output wire         mrmac_tx_axis_tlast_0,
  output wire         mrmac_tx_axis_tlast_1,
  output wire         mrmac_tx_axis_tlast_2,
  output wire         mrmac_tx_axis_tlast_3,
  input  wire         mrmac_tx_axis_tready_0,
  input  wire         mrmac_tx_axis_tready_1,
  input  wire         mrmac_tx_axis_tready_2,
  input  wire         mrmac_tx_axis_tready_3,

  input  wire [63:0]  mrmac_rx_axis_tdata0,
  input  wire [63:0]  mrmac_rx_axis_tdata1,
  input  wire [63:0]  mrmac_rx_axis_tdata2,
  input  wire [63:0]  mrmac_rx_axis_tdata3,
  input  wire [63:0]  mrmac_rx_axis_tdata4,
  input  wire [63:0]  mrmac_rx_axis_tdata5,
  input  wire [63:0]  mrmac_rx_axis_tdata6,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user0,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user1,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user2,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user3,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user4,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user5,
  input  wire [10:0]  mrmac_rx_axis_tkeep_user6,
  input  wire         mrmac_rx_axis_tvalid_0,
  input  wire         mrmac_rx_axis_tvalid_1,
  input  wire         mrmac_rx_axis_tvalid_2,
  input  wire         mrmac_rx_axis_tvalid_3,
  input  wire         mrmac_rx_axis_tlast_0,
  input  wire         mrmac_rx_axis_tlast_1,
  input  wire         mrmac_rx_axis_tlast_2,
  input  wire         mrmac_rx_axis_tlast_3,

  output wire [PORTS*SHIM_W-1:0] shim_rx_axis_tdata,
  output wire [PORTS*KU_W-1:0]   shim_rx_axis_tkeep_user,
  output wire [PORTS-1:0]        shim_rx_axis_tvalid,
  output wire [PORTS-1:0]        shim_rx_axis_tlast,

  // Status, PTP and pause: MRMAC pins _p are port p, shim vectors pack port p
  // at [p*W +: W].
  input  wire         mrmac_stat_rx_status_0,
  input  wire         mrmac_stat_rx_status_1,
  input  wire         mrmac_stat_rx_status_2,
  input  wire         mrmac_stat_rx_status_3,
  output wire [PORTS-1:0] shim_stat_rx_status,

  input  wire [54:0]  mrmac_rx_ptp_tstamp_0,
  input  wire [54:0]  mrmac_rx_ptp_tstamp_1,
  input  wire [54:0]  mrmac_rx_ptp_tstamp_2,
  input  wire [54:0]  mrmac_rx_ptp_tstamp_3,
  output wire [PORTS*55-1:0] shim_rx_ptp_tstamp,

  input  wire [PORTS*2-1:0]  shim_tx_ptp_1588op,
  input  wire [PORTS*16-1:0] shim_tx_ptp_tag_field,
  output wire [1:0]   mrmac_tx_ptp_1588op_0,
  output wire [1:0]   mrmac_tx_ptp_1588op_1,
  output wire [1:0]   mrmac_tx_ptp_1588op_2,
  output wire [1:0]   mrmac_tx_ptp_1588op_3,
  output wire [15:0]  mrmac_tx_ptp_tag_field_0,
  output wire [15:0]  mrmac_tx_ptp_tag_field_1,
  output wire [15:0]  mrmac_tx_ptp_tag_field_2,
  output wire [15:0]  mrmac_tx_ptp_tag_field_3,

  input  wire [54:0]  mrmac_tx_ptp_tstamp_0,
  input  wire [54:0]  mrmac_tx_ptp_tstamp_1,
  input  wire [54:0]  mrmac_tx_ptp_tstamp_2,
  input  wire [54:0]  mrmac_tx_ptp_tstamp_3,
  input  wire [15:0]  mrmac_tx_ptp_tstamp_tag_0,
  input  wire [15:0]  mrmac_tx_ptp_tstamp_tag_1,
  input  wire [15:0]  mrmac_tx_ptp_tstamp_tag_2,
  input  wire [15:0]  mrmac_tx_ptp_tstamp_tag_3,
  input  wire         mrmac_tx_ptp_tstamp_valid_0,
  input  wire         mrmac_tx_ptp_tstamp_valid_1,
  input  wire         mrmac_tx_ptp_tstamp_valid_2,
  input  wire         mrmac_tx_ptp_tstamp_valid_3,
  output wire [PORTS*55-1:0] shim_tx_ptp_tstamp,
  output wire [PORTS*16-1:0] shim_tx_ptp_tstamp_tag,
  output wire [PORTS-1:0]    shim_tx_ptp_tstamp_valid,

  input  wire [PORTS*55-1:0] shim_tx_ptp_systemtimer,
  input  wire [PORTS-1:0]    shim_tx_ptp_st_sync,
  input  wire [PORTS-1:0]    shim_tx_ptp_st_overwrite,
  input  wire [PORTS*55-1:0] shim_rx_ptp_systemtimer,
  input  wire [PORTS-1:0]    shim_rx_ptp_st_sync,
  input  wire [PORTS-1:0]    shim_rx_ptp_st_overwrite,
  output wire [54:0]  mrmac_ctl_tx_ptp_systemtimer_0,
  output wire [54:0]  mrmac_ctl_tx_ptp_systemtimer_1,
  output wire [54:0]  mrmac_ctl_tx_ptp_systemtimer_2,
  output wire [54:0]  mrmac_ctl_tx_ptp_systemtimer_3,
  output wire         mrmac_ctl_tx_ptp_st_sync_0,
  output wire         mrmac_ctl_tx_ptp_st_sync_1,
  output wire         mrmac_ctl_tx_ptp_st_sync_2,
  output wire         mrmac_ctl_tx_ptp_st_sync_3,
  output wire         mrmac_ctl_tx_ptp_st_overwrite_0,
  output wire         mrmac_ctl_tx_ptp_st_overwrite_1,
  output wire         mrmac_ctl_tx_ptp_st_overwrite_2,
  output wire         mrmac_ctl_tx_ptp_st_overwrite_3,
  output wire [54:0]  mrmac_ctl_rx_ptp_systemtimer_0,
  output wire [54:0]  mrmac_ctl_rx_ptp_systemtimer_1,
  output wire [54:0]  mrmac_ctl_rx_ptp_systemtimer_2,
  output wire [54:0]  mrmac_ctl_rx_ptp_systemtimer_3,
  output wire         mrmac_ctl_rx_ptp_st_sync_0,
  output wire         mrmac_ctl_rx_ptp_st_sync_1,
  output wire         mrmac_ctl_rx_ptp_st_sync_2,
  output wire         mrmac_ctl_rx_ptp_st_sync_3,
  output wire         mrmac_ctl_rx_ptp_st_overwrite_0,
  output wire         mrmac_ctl_rx_ptp_st_overwrite_1,
  output wire         mrmac_ctl_rx_ptp_st_overwrite_2,
  output wire         mrmac_ctl_rx_ptp_st_overwrite_3,

  // Pause, 9b per port: [8] link pause, [7:0] priority pause.
  input  wire [PORTS*9-1:0] shim_ctl_tx_pause_enable,
  input  wire [PORTS*9-1:0] shim_ctl_tx_pause_req,
  input  wire [PORTS*9-1:0] shim_ctl_rx_pause_enable,
  input  wire [PORTS*9-1:0] shim_ctl_rx_pause_ack,
  output wire [PORTS*9-1:0] shim_stat_rx_pause_req,
  output wire [8:0]   mrmac_ctl_tx_pause_enable_0,
  output wire [8:0]   mrmac_ctl_tx_pause_enable_1,
  output wire [8:0]   mrmac_ctl_tx_pause_enable_2,
  output wire [8:0]   mrmac_ctl_tx_pause_enable_3,
  output wire [8:0]   mrmac_ctl_tx_pause_req_0,
  output wire [8:0]   mrmac_ctl_tx_pause_req_1,
  output wire [8:0]   mrmac_ctl_tx_pause_req_2,
  output wire [8:0]   mrmac_ctl_tx_pause_req_3,
  output wire [8:0]   mrmac_ctl_rx_pause_enable_0,
  output wire [8:0]   mrmac_ctl_rx_pause_enable_1,
  output wire [8:0]   mrmac_ctl_rx_pause_enable_2,
  output wire [8:0]   mrmac_ctl_rx_pause_enable_3,
  output wire [8:0]   mrmac_ctl_rx_pause_ack_0,
  output wire [8:0]   mrmac_ctl_rx_pause_ack_1,
  output wire [8:0]   mrmac_ctl_rx_pause_ack_2,
  output wire [8:0]   mrmac_ctl_rx_pause_ack_3,
  input  wire [8:0]   mrmac_stat_rx_pause_req_0,
  input  wire [8:0]   mrmac_stat_rx_pause_req_1,
  input  wire [8:0]   mrmac_stat_rx_pause_req_2,
  input  wire [8:0]   mrmac_stat_rx_pause_req_3
);

  localparam M4 = (MODE == "4x25G");

  localparam [7:0] TX_MAP = M4 ? TX_CH_MAP[7:0] : 8'b11_10_01_00;
  localparam [7:0] RX_MAP = M4 ? RX_CH_MAP[7:0] : 8'b11_10_01_00;

  localparam [3:0] TX_CH_SET = (4'd1 << TX_MAP[1:0]) | (4'd1 << TX_MAP[3:2]) |
                               (4'd1 << TX_MAP[5:4]) | (4'd1 << TX_MAP[7:6]);
  localparam [3:0] RX_CH_SET = (4'd1 << RX_MAP[1:0]) | (4'd1 << RX_MAP[3:2]) |
                               (4'd1 << RX_MAP[5:4]) | (4'd1 << RX_MAP[7:6]);

  initial begin
    if (MODE != "1x100G" && MODE != "4x25G" && MODE != "1x40G") begin
      $error("Error: MODE must be \"1x100G\", \"4x25G\" or \"1x40G\" (instance %m)");
      $finish;
    end
    if (TX_CH_SET != 4'hf || RX_CH_SET != 4'hf) begin
      $error("Error: TX_CH_MAP and RX_CH_MAP must be permutations of 0..3 (instance %m)");
      $finish;
    end
  end

  assign gt_rst_all = ~pl_resetn;

  wire gt_refclk_odiv2;

  generate
    if (GT_TYPE != "GTM") begin : gen_ibufds_gte5
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

  BUFG_GT #(
    .SIM_DEVICE (GT_TYPE == "GTY"  ? "VERSAL_AI_CORE" :
                 GT_TYPE == "GTYP" ? "VERSAL_AI_EDGE" : "VERSAL_PREMIUM")
  ) i_bufg_gt_ptp_refclk (
    .O       (ptp_refclk_bufg),
    .CE      (1'b1),
    .CEMASK  (1'b1),
    .CLR     (1'b0),
    .CLRMASK (1'b1),
    .DIV     (3'd0),
    .I       (gt_refclk_odiv2)
  );

  wire [3:0] gt_tx_outclk_ch = {gt_tx_outclk_3, gt_tx_outclk_2,
                                gt_tx_outclk_1, gt_tx_outclk};
  wire [3:0] gt_rx_outclk_ch = {gt_rx_outclk_3, gt_rx_outclk_2,
                                gt_rx_outclk_1, gt_rx_outclk};
  wire [3:0] gt_tx_clr_ch = {gt_tx_clr_3, gt_tx_clr_2, gt_tx_clr_1, gt_tx_clr};
  wire [3:0] gt_tx_clrb_leaf_ch = {gt_tx_clrb_leaf_3, gt_tx_clrb_leaf_2,
                                   gt_tx_clrb_leaf_1, gt_tx_clrb_leaf};
  wire [3:0] gt_rx_clr_ch = {gt_rx_clr_3, gt_rx_clr_2, gt_rx_clr_1, gt_rx_clr};
  wire [3:0] gt_rx_clrb_leaf_ch = {gt_rx_clrb_leaf_3, gt_rx_clrb_leaf_2,
                                   gt_rx_clrb_leaf_1, gt_rx_clrb_leaf};

  wire [3:0] tx_usrclk_o1, tx_usrclk_o2;
  wire [3:0] rx_usrclk_o1, rx_usrclk_o2;
  wire [3:0] gt_rst_tx_done_ch, gt_rst_rx_done_ch;

  genvar c;
  generate
    if (M4) begin : g_clk_4x25g
      for (c = 0; c < 4; c = c + 1) begin : g_ch
        MBUFG_GT #(
          .MODE ("PERFORMANCE")
        ) i_mbufg_gt_tx (
          .O1        (tx_usrclk_o1[c]),
          .O2        (tx_usrclk_o2[c]),
          .O3        (),
          .O4        (),
          .CE        (1'b1),
          .CEMASK    (1'b0),
          .CLR       (gt_tx_clr_ch[c]),
          .CLRB_LEAF (gt_tx_clrb_leaf_ch[c]),
          .CLRMASK   (1'b0),
          .DIV       (3'b000),
          .I         (gt_tx_outclk_ch[c])
        );

        MBUFG_GT #(
          .MODE ("PERFORMANCE")
        ) i_mbufg_gt_rx (
          .O1        (rx_usrclk_o1[c]),
          .O2        (rx_usrclk_o2[c]),
          .O3        (),
          .O4        (),
          .CE        (1'b1),
          .CEMASK    (1'b0),
          .CLR       (gt_rx_clr_ch[c]),
          .CLRB_LEAF (gt_rx_clrb_leaf_ch[c]),
          .CLRMASK   (1'b0),
          .DIV       (3'b000),
          .I         (gt_rx_outclk_ch[c])
        );
      end

      assign gt_rst_tx_done_ch = {gt_rst_tx_done_3, gt_rst_tx_done_2,
                                  gt_rst_tx_done_1, gt_rst_tx_done};
      assign gt_rst_rx_done_ch = {gt_rst_rx_done_3, gt_rst_rx_done_2,
                                  gt_rst_rx_done_1, gt_rst_rx_done};
    end else begin : g_clk_1x100g
      wire tx_usrclk_o1_m, tx_usrclk_o2_m;

      MBUFG_GT #(
        .MODE ("PERFORMANCE")
      ) i_mbufg_gt_tx (
        .O1        (tx_usrclk_o1_m),
        .O2        (tx_usrclk_o2_m),
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

      assign tx_usrclk_o1 = {4{tx_usrclk_o1_m}};
      assign tx_usrclk_o2 = {4{tx_usrclk_o2_m}};

      if (RX_PER_LANE_CLK) begin : g_rx_per_lane
        for (c = 0; c < 4; c = c + 1) begin : g_lane
          MBUFG_GT #(
            .MODE ("PERFORMANCE")
          ) i_mbufg_gt_rx (
            .O1        (rx_usrclk_o1[c]),
            .O2        (rx_usrclk_o2[c]),
            .O3        (),
            .O4        (),
            .CE        (1'b1),
            .CEMASK    (1'b0),
            .CLR       (gt_rx_clr),
            .CLRB_LEAF (gt_rx_clrb_leaf),
            .CLRMASK   (1'b0),
            .DIV       (3'b000),
            .I         (gt_rx_outclk_ch[c])
          );
        end
      end else begin : g_rx_shared
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

      assign gt_rst_tx_done_ch = {4{gt_rst_tx_done}};
      assign gt_rst_rx_done_ch = {4{gt_rst_rx_done}};
    end
  endgenerate

  assign gt_tx_usrclk_0 = tx_usrclk_o2[0];
  assign gt_tx_usrclk_1 = tx_usrclk_o2[1];
  assign gt_tx_usrclk_2 = tx_usrclk_o2[2];
  assign gt_tx_usrclk_3 = tx_usrclk_o2[3];
  assign gt_rx_usrclk_0 = rx_usrclk_o2[0];
  assign gt_rx_usrclk_1 = rx_usrclk_o2[1];
  assign gt_rx_usrclk_2 = rx_usrclk_o2[2];
  assign gt_rx_usrclk_3 = rx_usrclk_o2[3];

  // MRMAC lane n <-> GT channel TX_MAP/RX_MAP[n]. Only the low MRMAC_SERDES_W
  // bits carry the raw serdes payload.
  localparam SERDES_PAD_W = GT_CH_W - MRMAC_SERDES_W;

  wire [4*MRMAC_SERDES_W-1:0] mrmac_txdata = {mrmac_txdata_in_3, mrmac_txdata_in_2,
                                              mrmac_txdata_in_1, mrmac_txdata_in_0};
  wire [4*MRMAC_SERDES_W-1:0] mrmac_rxdata;
  wire [4*GT_CH_W-1:0] gt_txdata_ch;
  wire [4*GT_CH_W-1:0] gt_rxdata = {gt_ch_rxdata_3, gt_ch_rxdata_2,
                                    gt_ch_rxdata_1, gt_ch_rxdata_0};

  assign {gt_ch_txdata_3, gt_ch_txdata_2,
          gt_ch_txdata_1, gt_ch_txdata_0} = gt_txdata_ch;

  genvar n;
  generate
    for (n = 0; n < 4; n = n + 1) begin : g_lane_map
      localparam integer TX_C = TX_MAP[2*n +: 2];
      localparam integer RX_C = RX_MAP[2*n +: 2];

      assign gt_txdata_ch[TX_C*GT_CH_W +: GT_CH_W] =
        {{SERDES_PAD_W{1'b0}}, mrmac_txdata[n*MRMAC_SERDES_W +: MRMAC_SERDES_W]};
      assign mrmac_rxdata[n*MRMAC_SERDES_W +: MRMAC_SERDES_W] =
        gt_rxdata[RX_C*GT_CH_W +: MRMAC_SERDES_W];

      assign mrmac_tx_core_clk[n]       = tx_usrclk_o1[TX_C];
      assign mrmac_tx_alt_serdes_clk[n] = tx_usrclk_o2[TX_C];
      assign mrmac_rx_core_clk[n]       = rx_usrclk_o1[RX_C];
      assign mrmac_rx_serdes_clk[n]     = rx_usrclk_o1[RX_C];
      assign mrmac_rx_alt_serdes_clk[n] = rx_usrclk_o2[RX_C];

      assign mrmac_tx_core_reset[n]   = ~gt_rst_tx_done_ch[TX_C];
      assign mrmac_tx_serdes_reset[n] = ~gt_rst_tx_done_ch[TX_C];
      assign mrmac_rx_core_reset[n]   = ~gt_rst_rx_done_ch[RX_C];
      assign mrmac_rx_serdes_reset[n] = ~gt_rst_rx_done_ch[RX_C];
    end
  endgenerate

  assign mrmac_rxdata_out_0 = mrmac_rxdata[0*MRMAC_SERDES_W +: MRMAC_SERDES_W];
  assign mrmac_rxdata_out_1 = mrmac_rxdata[1*MRMAC_SERDES_W +: MRMAC_SERDES_W];
  assign mrmac_rxdata_out_2 = mrmac_rxdata[2*MRMAC_SERDES_W +: MRMAC_SERDES_W];
  assign mrmac_rxdata_out_3 = mrmac_rxdata[3*MRMAC_SERDES_W +: MRMAC_SERDES_W];

  assign mrmac_axi_clk = {4{axis_clk_in}};
  assign mrmac_ts_clk  = {4{ts_clk_in}};
  assign mrmac_flexif_clk = {4{axis_clk_in}};

  assign shim_axi_reset = ~pl_resetn;

  assign mrmac_flexif_reset = {4{~pl_resetn}};

  // MRMAC client pins packed per word (7 x 64b / 11b) and per port ([3:0])
  wire [7*64-1:0] mrmac_rx_w = {mrmac_rx_axis_tdata6, mrmac_rx_axis_tdata5,
                                mrmac_rx_axis_tdata4, mrmac_rx_axis_tdata3,
                                mrmac_rx_axis_tdata2, mrmac_rx_axis_tdata1,
                                mrmac_rx_axis_tdata0};
  wire [7*11-1:0] mrmac_rx_ku = {mrmac_rx_axis_tkeep_user6, mrmac_rx_axis_tkeep_user5,
                                 mrmac_rx_axis_tkeep_user4, mrmac_rx_axis_tkeep_user3,
                                 mrmac_rx_axis_tkeep_user2, mrmac_rx_axis_tkeep_user1,
                                 mrmac_rx_axis_tkeep_user0};
  wire [7*64-1:0] mrmac_tx_w;
  wire [7*11-1:0] mrmac_tx_ku;

  assign {mrmac_tx_axis_tdata6, mrmac_tx_axis_tdata5, mrmac_tx_axis_tdata4,
          mrmac_tx_axis_tdata3, mrmac_tx_axis_tdata2, mrmac_tx_axis_tdata1,
          mrmac_tx_axis_tdata0} = mrmac_tx_w;
  assign {mrmac_tx_axis_tkeep_user6, mrmac_tx_axis_tkeep_user5,
          mrmac_tx_axis_tkeep_user4, mrmac_tx_axis_tkeep_user3,
          mrmac_tx_axis_tkeep_user2, mrmac_tx_axis_tkeep_user1,
          mrmac_tx_axis_tkeep_user0} = mrmac_tx_ku;

  wire [3:0] mrmac_tx_tvalid_p, mrmac_tx_tlast_p;
  wire [3:0] mrmac_tx_tready_p = {mrmac_tx_axis_tready_3, mrmac_tx_axis_tready_2,
                                  mrmac_tx_axis_tready_1, mrmac_tx_axis_tready_0};
  wire [3:0] mrmac_rx_tvalid_p = {mrmac_rx_axis_tvalid_3, mrmac_rx_axis_tvalid_2,
                                  mrmac_rx_axis_tvalid_1, mrmac_rx_axis_tvalid_0};
  wire [3:0] mrmac_rx_tlast_p = {mrmac_rx_axis_tlast_3, mrmac_rx_axis_tlast_2,
                                 mrmac_rx_axis_tlast_1, mrmac_rx_axis_tlast_0};
  wire [4*16-1:0] mrmac_tx_tag_p;

  assign {mrmac_tx_axis_tvalid_3, mrmac_tx_axis_tvalid_2,
          mrmac_tx_axis_tvalid_1, mrmac_tx_axis_tvalid_0} = mrmac_tx_tvalid_p;
  assign {mrmac_tx_axis_tlast_3, mrmac_tx_axis_tlast_2,
          mrmac_tx_axis_tlast_1, mrmac_tx_axis_tlast_0} = mrmac_tx_tlast_p;
  assign {mrmac_tx_ptp_tag_field_3, mrmac_tx_ptp_tag_field_2,
          mrmac_tx_ptp_tag_field_1, mrmac_tx_ptp_tag_field_0} = mrmac_tx_tag_p;

  // per-port MRMAC-side client streams, packed like the shim
  wire [PORTS*SHIM_W-1:0] port_rx_tdata;
  wire [PORTS*KU_W-1:0]   port_rx_tkeep_user;
  wire [PORTS*SHIM_W-1:0] port_tx_tdata;
  wire [PORTS*KU_W-1:0]   port_tx_tkeep_user;

  genvar p;
  generate
    if (M4) begin : g_words_4x25g
      for (p = 0; p < 4; p = p + 1) begin : g_port
        assign port_rx_tdata[p*64 +: 64]      = mrmac_rx_w[2*p*64 +: 64];
        assign port_rx_tkeep_user[p*11 +: 11] = mrmac_rx_ku[2*p*11 +: 11];
        assign mrmac_tx_w[2*p*64 +: 64]       = port_tx_tdata[p*64 +: 64];
        assign mrmac_tx_ku[2*p*11 +: 11]      = port_tx_tkeep_user[p*11 +: 11];
        if (p < 3) begin : g_odd
          assign mrmac_tx_w[(2*p+1)*64 +: 64]  = 64'd0;
          assign mrmac_tx_ku[(2*p+1)*11 +: 11] = 11'd0;
        end
      end
    end else begin : g_words_1port
      assign port_rx_tdata      = mrmac_rx_w[SHIM_W-1:0];
      assign port_rx_tkeep_user = mrmac_rx_ku[KU_W-1:0];
      assign mrmac_tx_w  = {{(7*64-SHIM_W){1'b0}}, port_tx_tdata};
      assign mrmac_tx_ku = {{(7*11-KU_W){1'b0}}, port_tx_tkeep_user};
    end

    for (p = 0; p < PORTS; p = p + 1) begin : g_port
      if (LOOPBACK_ENABLE) begin : g_loopback
        mrmac_axis_loopback #(
          .SEG_COUNT (SHIM_W / 64)
        ) i_loopback (
          .clk(axis_clk_in),
          .resetn(pl_resetn),
          .loopback_en(loopback_en),
          .mac_swap(loopback_mac_swap),
          .mrmac_rx_axis_tdata(port_rx_tdata[p*SHIM_W +: SHIM_W]),
          .mrmac_rx_axis_tkeep_user(port_rx_tkeep_user[p*KU_W +: KU_W]),
          .mrmac_rx_axis_tvalid(mrmac_rx_tvalid_p[p]),
          .mrmac_rx_axis_tlast(mrmac_rx_tlast_p[p]),
          .shim_rx_axis_tdata(shim_rx_axis_tdata[p*SHIM_W +: SHIM_W]),
          .shim_rx_axis_tkeep_user(shim_rx_axis_tkeep_user[p*KU_W +: KU_W]),
          .shim_rx_axis_tvalid(shim_rx_axis_tvalid[p]),
          .shim_rx_axis_tlast(shim_rx_axis_tlast[p]),
          .shim_tx_axis_tdata(shim_tx_axis_tdata[p*SHIM_W +: SHIM_W]),
          .shim_tx_axis_tkeep_user(shim_tx_axis_tkeep_user[p*KU_W +: KU_W]),
          .shim_tx_axis_tvalid(shim_tx_axis_tvalid[p]),
          .shim_tx_axis_tlast(shim_tx_axis_tlast[p]),
          .shim_tx_axis_tready(shim_tx_axis_tready[p]),
          .shim_tx_ptp_tag_field(shim_tx_ptp_tag_field[p*16 +: 16]),
          .mrmac_tx_axis_tdata(port_tx_tdata[p*SHIM_W +: SHIM_W]),
          .mrmac_tx_axis_tkeep_user(port_tx_tkeep_user[p*KU_W +: KU_W]),
          .mrmac_tx_axis_tvalid(mrmac_tx_tvalid_p[p]),
          .mrmac_tx_axis_tlast(mrmac_tx_tlast_p[p]),
          .mrmac_tx_axis_tready(mrmac_tx_tready_p[p]),
          .mrmac_tx_ptp_tag_field(mrmac_tx_tag_p[p*16 +: 16]),
          .lb_frames(),
          .lb_drops());
      end else begin : g_no_loopback
        assign port_tx_tdata[p*SHIM_W +: SHIM_W]    = shim_tx_axis_tdata[p*SHIM_W +: SHIM_W];
        assign port_tx_tkeep_user[p*KU_W +: KU_W]   = shim_tx_axis_tkeep_user[p*KU_W +: KU_W];
        assign mrmac_tx_tvalid_p[p]                 = shim_tx_axis_tvalid[p];
        assign mrmac_tx_tlast_p[p]                  = shim_tx_axis_tlast[p];
        assign shim_tx_axis_tready[p]               = mrmac_tx_tready_p[p];
        assign mrmac_tx_tag_p[p*16 +: 16]           = shim_tx_ptp_tag_field[p*16 +: 16];

        assign shim_rx_axis_tdata[p*SHIM_W +: SHIM_W]    = port_rx_tdata[p*SHIM_W +: SHIM_W];
        assign shim_rx_axis_tkeep_user[p*KU_W +: KU_W]   = port_rx_tkeep_user[p*KU_W +: KU_W];
        assign shim_rx_axis_tvalid[p]                    = mrmac_rx_tvalid_p[p];
        assign shim_rx_axis_tlast[p]                     = mrmac_rx_tlast_p[p];
      end
    end
  endgenerate

  wire [3:0]      mrmac_stat_rx_status_p = {mrmac_stat_rx_status_3, mrmac_stat_rx_status_2,
                                            mrmac_stat_rx_status_1, mrmac_stat_rx_status_0};
  wire [4*55-1:0] mrmac_rx_ptp_tstamp_p = {mrmac_rx_ptp_tstamp_3, mrmac_rx_ptp_tstamp_2,
                                           mrmac_rx_ptp_tstamp_1, mrmac_rx_ptp_tstamp_0};
  wire [4*55-1:0] mrmac_tx_ptp_tstamp_p = {mrmac_tx_ptp_tstamp_3, mrmac_tx_ptp_tstamp_2,
                                           mrmac_tx_ptp_tstamp_1, mrmac_tx_ptp_tstamp_0};
  wire [4*16-1:0] mrmac_tx_ptp_tstamp_tag_p = {mrmac_tx_ptp_tstamp_tag_3, mrmac_tx_ptp_tstamp_tag_2,
                                               mrmac_tx_ptp_tstamp_tag_1, mrmac_tx_ptp_tstamp_tag_0};
  wire [3:0]      mrmac_tx_ptp_tstamp_valid_p = {mrmac_tx_ptp_tstamp_valid_3, mrmac_tx_ptp_tstamp_valid_2,
                                                 mrmac_tx_ptp_tstamp_valid_1, mrmac_tx_ptp_tstamp_valid_0};
  wire [4*9-1:0]  mrmac_stat_rx_pause_req_p = {mrmac_stat_rx_pause_req_3, mrmac_stat_rx_pause_req_2,
                                               mrmac_stat_rx_pause_req_1, mrmac_stat_rx_pause_req_0};

  assign shim_stat_rx_status      = mrmac_stat_rx_status_p[PORTS-1:0];
  assign shim_rx_ptp_tstamp       = mrmac_rx_ptp_tstamp_p[PORTS*55-1:0];
  assign shim_tx_ptp_tstamp       = mrmac_tx_ptp_tstamp_p[PORTS*55-1:0];
  assign shim_tx_ptp_tstamp_tag   = mrmac_tx_ptp_tstamp_tag_p[PORTS*16-1:0];
  assign shim_tx_ptp_tstamp_valid = mrmac_tx_ptp_tstamp_valid_p[PORTS-1:0];
  assign shim_stat_rx_pause_req   = mrmac_stat_rx_pause_req_p[PORTS*9-1:0];

  wire [4*2-1:0]  mrmac_tx_ptp_1588op_p;
  wire [4*55-1:0] mrmac_ctl_tx_ptp_systemtimer_p, mrmac_ctl_rx_ptp_systemtimer_p;
  wire [3:0]      mrmac_ctl_tx_ptp_st_sync_p, mrmac_ctl_tx_ptp_st_overwrite_p;
  wire [3:0]      mrmac_ctl_rx_ptp_st_sync_p, mrmac_ctl_rx_ptp_st_overwrite_p;
  wire [4*9-1:0]  mrmac_ctl_tx_pause_enable_p, mrmac_ctl_tx_pause_req_p;
  wire [4*9-1:0]  mrmac_ctl_rx_pause_enable_p, mrmac_ctl_rx_pause_ack_p;

  assign mrmac_tx_ptp_1588op_p[PORTS*2-1:0]           = shim_tx_ptp_1588op;
  assign mrmac_ctl_tx_ptp_systemtimer_p[PORTS*55-1:0] = shim_tx_ptp_systemtimer;
  assign mrmac_ctl_tx_ptp_st_sync_p[PORTS-1:0]        = shim_tx_ptp_st_sync;
  assign mrmac_ctl_tx_ptp_st_overwrite_p[PORTS-1:0]   = shim_tx_ptp_st_overwrite;
  assign mrmac_ctl_rx_ptp_systemtimer_p[PORTS*55-1:0] = shim_rx_ptp_systemtimer;
  assign mrmac_ctl_rx_ptp_st_sync_p[PORTS-1:0]        = shim_rx_ptp_st_sync;
  assign mrmac_ctl_rx_ptp_st_overwrite_p[PORTS-1:0]   = shim_rx_ptp_st_overwrite;
  assign mrmac_ctl_tx_pause_enable_p[PORTS*9-1:0]     = shim_ctl_tx_pause_enable;
  assign mrmac_ctl_tx_pause_req_p[PORTS*9-1:0]        = shim_ctl_tx_pause_req;
  assign mrmac_ctl_rx_pause_enable_p[PORTS*9-1:0]     = shim_ctl_rx_pause_enable;
  assign mrmac_ctl_rx_pause_ack_p[PORTS*9-1:0]        = shim_ctl_rx_pause_ack;

  generate
    if (PORTS < 4) begin : g_unused_ports
      assign mrmac_tx_tvalid_p[3:PORTS]                = 0;
      assign mrmac_tx_tlast_p[3:PORTS]                 = 0;
      assign mrmac_tx_tag_p[4*16-1:PORTS*16]           = 0;
      assign mrmac_tx_ptp_1588op_p[4*2-1:PORTS*2]      = 0;
      assign mrmac_ctl_tx_ptp_systemtimer_p[4*55-1:PORTS*55] = 0;
      assign mrmac_ctl_tx_ptp_st_sync_p[3:PORTS]       = 0;
      assign mrmac_ctl_tx_ptp_st_overwrite_p[3:PORTS]  = 0;
      assign mrmac_ctl_rx_ptp_systemtimer_p[4*55-1:PORTS*55] = 0;
      assign mrmac_ctl_rx_ptp_st_sync_p[3:PORTS]       = 0;
      assign mrmac_ctl_rx_ptp_st_overwrite_p[3:PORTS]  = 0;
      assign mrmac_ctl_tx_pause_enable_p[4*9-1:PORTS*9] = 0;
      assign mrmac_ctl_tx_pause_req_p[4*9-1:PORTS*9]    = 0;
      assign mrmac_ctl_rx_pause_enable_p[4*9-1:PORTS*9] = 0;
      assign mrmac_ctl_rx_pause_ack_p[4*9-1:PORTS*9]    = 0;
    end
  endgenerate

  assign {mrmac_tx_ptp_1588op_3, mrmac_tx_ptp_1588op_2,
          mrmac_tx_ptp_1588op_1, mrmac_tx_ptp_1588op_0} = mrmac_tx_ptp_1588op_p;
  assign {mrmac_ctl_tx_ptp_systemtimer_3, mrmac_ctl_tx_ptp_systemtimer_2,
          mrmac_ctl_tx_ptp_systemtimer_1, mrmac_ctl_tx_ptp_systemtimer_0} = mrmac_ctl_tx_ptp_systemtimer_p;
  assign {mrmac_ctl_tx_ptp_st_sync_3, mrmac_ctl_tx_ptp_st_sync_2,
          mrmac_ctl_tx_ptp_st_sync_1, mrmac_ctl_tx_ptp_st_sync_0} = mrmac_ctl_tx_ptp_st_sync_p;
  assign {mrmac_ctl_tx_ptp_st_overwrite_3, mrmac_ctl_tx_ptp_st_overwrite_2,
          mrmac_ctl_tx_ptp_st_overwrite_1, mrmac_ctl_tx_ptp_st_overwrite_0} = mrmac_ctl_tx_ptp_st_overwrite_p;
  assign {mrmac_ctl_rx_ptp_systemtimer_3, mrmac_ctl_rx_ptp_systemtimer_2,
          mrmac_ctl_rx_ptp_systemtimer_1, mrmac_ctl_rx_ptp_systemtimer_0} = mrmac_ctl_rx_ptp_systemtimer_p;
  assign {mrmac_ctl_rx_ptp_st_sync_3, mrmac_ctl_rx_ptp_st_sync_2,
          mrmac_ctl_rx_ptp_st_sync_1, mrmac_ctl_rx_ptp_st_sync_0} = mrmac_ctl_rx_ptp_st_sync_p;
  assign {mrmac_ctl_rx_ptp_st_overwrite_3, mrmac_ctl_rx_ptp_st_overwrite_2,
          mrmac_ctl_rx_ptp_st_overwrite_1, mrmac_ctl_rx_ptp_st_overwrite_0} = mrmac_ctl_rx_ptp_st_overwrite_p;
  assign {mrmac_ctl_tx_pause_enable_3, mrmac_ctl_tx_pause_enable_2,
          mrmac_ctl_tx_pause_enable_1, mrmac_ctl_tx_pause_enable_0} = mrmac_ctl_tx_pause_enable_p;
  assign {mrmac_ctl_tx_pause_req_3, mrmac_ctl_tx_pause_req_2,
          mrmac_ctl_tx_pause_req_1, mrmac_ctl_tx_pause_req_0} = mrmac_ctl_tx_pause_req_p;
  assign {mrmac_ctl_rx_pause_enable_3, mrmac_ctl_rx_pause_enable_2,
          mrmac_ctl_rx_pause_enable_1, mrmac_ctl_rx_pause_enable_0} = mrmac_ctl_rx_pause_enable_p;
  assign {mrmac_ctl_rx_pause_ack_3, mrmac_ctl_rx_pause_ack_2,
          mrmac_ctl_rx_pause_ack_1, mrmac_ctl_rx_pause_ack_0} = mrmac_ctl_rx_pause_ack_p;

endmodule
