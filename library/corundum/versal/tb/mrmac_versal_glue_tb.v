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
`define TIMEOUT 200000
`endif

module mrmac_versal_glue_tb;

  parameter VCD_FILE = "mrmac_versal_glue_tb.vcd";

  `include "tb_base.v"

  glbl glbl ();

`ifdef MODE_4X25G
  localparam MODE  = "4x25G";
  localparam M4    = 1;
  localparam PORTS = 4;
`elsif MODE_1X40G
  localparam MODE  = "1x40G";
  localparam M4    = 0;
  localparam PORTS = 1;
`else
  localparam MODE  = "1x100G";
  localparam M4    = 0;
  localparam PORTS = 1;
`endif

  // 64b words per port on the shim and client side
  localparam WORDS  = M4 ? 1 : (MODE == "1x40G") ? 4 : 6;
  localparam SHIM_W = WORDS*64;
  localparam KU_W   = WORDS*11;

  // Non-identity maps, port n in bits [2n+1:2n]
  localparam [7:0] TX_CH_MAP = 8'b10_00_01_11;
  localparam [7:0] RX_CH_MAP = 8'b10_01_11_00;

  localparam SW = 80;
  localparam CW = 128;

  function integer tx_ch;
    input integer n;
    tx_ch = M4 ? TX_CH_MAP[2*n +: 2] : n;
  endfunction

  function integer rx_ch;
    input integer n;
    rx_ch = M4 ? RX_CH_MAP[2*n +: 2] : n;
  endfunction

  function integer tx_if;
    input integer n;
    tx_if = M4 ? TX_CH_MAP[2*n +: 2] : 0;
  endfunction

  function integer rx_if;
    input integer n;
    rx_if = M4 ? RX_CH_MAP[2*n +: 2] : 0;
  endfunction

  integer errors = 0;

  task chk;
    input [8*48-1:0] name;
    input [511:0]    got;
    input [511:0]    exp;
    begin
      if (got !== exp) begin
        $display("%t %0s: got %h exp %h", $time, name, got, exp);
        errors = errors + 1;
      end
    end
  endtask

  task pass_fail;
    input [8*32-1:0] name;
    input integer    e0;
    begin
      if (errors == e0)
        $display("PASS  %0s", name);
      else begin
        $display("FAIL  %0s", name);
        failed <= 1'b1;
      end
    end
  endtask

  reg [3:0] tx_outclk = 4'd0;
  reg [3:0] rx_outclk = 4'd0;

  always #1.0 tx_outclk[0] = ~tx_outclk[0];
  always #1.2 tx_outclk[1] = ~tx_outclk[1];
  always #1.4 tx_outclk[2] = ~tx_outclk[2];
  always #1.7 tx_outclk[3] = ~tx_outclk[3];
  always #1.1 rx_outclk[0] = ~rx_outclk[0];
  always #1.3 rx_outclk[1] = ~rx_outclk[1];
  always #1.5 rx_outclk[2] = ~rx_outclk[2];
  always #1.8 rx_outclk[3] = ~rx_outclk[3];

  reg axis_clk = 1'b0;
  reg ts_clk = 1'b0;
  always #1.3 axis_clk = ~axis_clk;
  always #2.0 ts_clk = ~ts_clk;

  reg pl_resetn = 1'b0;
  reg loopback_en = 1'b0;

  reg [3:0] tx_clr = 4'hf;
  reg [3:0] tx_clrb_leaf = 4'h0;
  reg [3:0] rx_clr = 4'hf;
  reg [3:0] rx_clrb_leaf = 4'h0;
  reg [3:0] tx_done = 4'h0;
  reg [3:0] rx_done = 4'h0;

  reg  [4*SW-1:0] txd = 0;
  wire [4*CW-1:0] gt_txd;
  reg  [4*CW-1:0] gt_rxd = 0;
  wire [4*SW-1:0] rxd;

  wire [3:0] gt_tx_usrclk;
  wire [3:0] gt_rx_usrclk;
  wire [3:0] tx_core_clk, rx_core_clk, rx_serdes_clk;
  wire [3:0] tx_alt_serdes_clk, rx_alt_serdes_clk;
  wire [3:0] tx_core_reset, rx_core_reset, tx_serdes_reset, rx_serdes_reset;

  reg  [PORTS*SHIM_W-1:0] s_tx_tdata = 0;
  reg  [PORTS*KU_W-1:0]   s_tx_ku = 0;
  reg  [PORTS-1:0]        s_tx_tvalid = 0;
  reg  [PORTS-1:0]        s_tx_tlast = 0;
  wire [PORTS-1:0]        s_tx_tready;
  wire [PORTS*SHIM_W-1:0] s_rx_tdata;
  wire [PORTS*KU_W-1:0]   s_rx_ku;
  wire [PORTS-1:0]        s_rx_tvalid;
  wire [PORTS-1:0]        s_rx_tlast;
  wire [PORTS-1:0]        s_rx_status;

  wire [PORTS*55-1:0]     s_rx_ts;
  reg  [PORTS*2-1:0]      s_tx_op = 0;
  reg  [PORTS*16-1:0]     s_tx_tag = 0;
  wire [PORTS*55-1:0]     s_tx_ts;
  wire [PORTS*16-1:0]     s_tx_ts_tag;
  wire [PORTS-1:0]        s_tx_ts_valid;
  reg  [PORTS*55-1:0]     s_tx_st = 0;
  reg  [PORTS-1:0]        s_tx_st_sync = 0;
  reg  [PORTS-1:0]        s_tx_st_ow = 0;
  reg  [PORTS*55-1:0]     s_rx_st = 0;
  reg  [PORTS-1:0]        s_rx_st_sync = 0;
  reg  [PORTS-1:0]        s_rx_st_ow = 0;
  reg  [PORTS*9-1:0]      s_tx_pen = 0;
  reg  [PORTS*9-1:0]      s_tx_preq = 0;
  reg  [PORTS*9-1:0]      s_rx_pen = 0;
  reg  [PORTS*9-1:0]      s_rx_pack = 0;
  wire [PORTS*9-1:0]      s_rx_preq;

  // MRMAC side: seven 64b words, four ports
  wire [7*64-1:0] m_tx_w;
  wire [7*11-1:0] m_tx_ku;
  wire [3:0]      m_tx_tvalid, m_tx_tlast;
  reg  [3:0]      m_tx_tready = 0;
  reg  [7*64-1:0] m_rx_w = 0;
  reg  [7*11-1:0] m_rx_ku = 0;
  reg  [3:0]      m_rx_tvalid = 0;
  reg  [3:0]      m_rx_tlast = 0;
  reg  [3:0]      m_rx_status = 0;

  reg  [4*55-1:0] m_rx_ts = 0;
  wire [4*2-1:0]  m_tx_op;
  wire [4*16-1:0] m_tx_tag;
  reg  [4*55-1:0] m_tx_ts = 0;
  reg  [4*16-1:0] m_tx_ts_tag = 0;
  reg  [3:0]      m_tx_ts_valid = 0;
  wire [4*55-1:0] m_tx_st, m_rx_st;
  wire [3:0]      m_tx_st_sync, m_tx_st_ow, m_rx_st_sync, m_rx_st_ow;
  wire [4*9-1:0]  m_tx_pen, m_tx_preq, m_rx_pen, m_rx_pack;
  reg  [4*9-1:0]  m_rx_preq = 0;

  mrmac_versal_glue #(
    .GT_TYPE         ("GTYP"),
    .MODE            (MODE),
    .TX_CH_MAP       (TX_CH_MAP),
    .RX_CH_MAP       (RX_CH_MAP),
    .MRMAC_SERDES_W  (SW),
    .GT_CH_W         (CW),
    .RX_PER_LANE_CLK (1),
    .LOOPBACK_ENABLE (0)
  ) dut (
    .gt_ref_clk_p (1'b0),
    .gt_ref_clk_n (1'b1),
    .gt_refclk_out (),
    .ptp_refclk_bufg (),
    .axis_clk_in (axis_clk),
    .ts_clk_in (ts_clk),
    .pl_resetn (pl_resetn),
    .loopback_en (1'b0),
    .loopback_mac_swap (1'b0),

    .gt_tx_outclk   (tx_outclk[0]),
    .gt_tx_outclk_1 (tx_outclk[1]),
    .gt_tx_outclk_2 (tx_outclk[2]),
    .gt_tx_outclk_3 (tx_outclk[3]),
    .gt_rx_outclk   (rx_outclk[0]),
    .gt_rx_outclk_1 (rx_outclk[1]),
    .gt_rx_outclk_2 (rx_outclk[2]),
    .gt_rx_outclk_3 (rx_outclk[3]),

    .gt_tx_clr         (tx_clr[0]),
    .gt_tx_clr_1       (tx_clr[1]),
    .gt_tx_clr_2       (tx_clr[2]),
    .gt_tx_clr_3       (tx_clr[3]),
    .gt_tx_clrb_leaf   (tx_clrb_leaf[0]),
    .gt_tx_clrb_leaf_1 (tx_clrb_leaf[1]),
    .gt_tx_clrb_leaf_2 (tx_clrb_leaf[2]),
    .gt_tx_clrb_leaf_3 (tx_clrb_leaf[3]),
    .gt_rx_clr         (rx_clr[0]),
    .gt_rx_clr_1       (rx_clr[1]),
    .gt_rx_clr_2       (rx_clr[2]),
    .gt_rx_clr_3       (rx_clr[3]),
    .gt_rx_clrb_leaf   (rx_clrb_leaf[0]),
    .gt_rx_clrb_leaf_1 (rx_clrb_leaf[1]),
    .gt_rx_clrb_leaf_2 (rx_clrb_leaf[2]),
    .gt_rx_clrb_leaf_3 (rx_clrb_leaf[3]),

    .gt_rst_tx_done   (tx_done[0]),
    .gt_rst_tx_done_1 (tx_done[1]),
    .gt_rst_tx_done_2 (tx_done[2]),
    .gt_rst_tx_done_3 (tx_done[3]),
    .gt_rst_rx_done   (rx_done[0]),
    .gt_rst_rx_done_1 (rx_done[1]),
    .gt_rst_rx_done_2 (rx_done[2]),
    .gt_rst_rx_done_3 (rx_done[3]),

    .gt_tx_usrclk_0 (gt_tx_usrclk[0]),
    .gt_tx_usrclk_1 (gt_tx_usrclk[1]),
    .gt_tx_usrclk_2 (gt_tx_usrclk[2]),
    .gt_tx_usrclk_3 (gt_tx_usrclk[3]),
    .gt_rx_usrclk_0 (gt_rx_usrclk[0]),
    .gt_rx_usrclk_1 (gt_rx_usrclk[1]),
    .gt_rx_usrclk_2 (gt_rx_usrclk[2]),
    .gt_rx_usrclk_3 (gt_rx_usrclk[3]),
    .gt_rst_all (),

    .mrmac_tx_core_clk       (tx_core_clk),
    .mrmac_rx_core_clk       (rx_core_clk),
    .mrmac_rx_serdes_clk     (rx_serdes_clk),
    .mrmac_tx_alt_serdes_clk (tx_alt_serdes_clk),
    .mrmac_rx_alt_serdes_clk (rx_alt_serdes_clk),
    .mrmac_ts_clk (),
    .mrmac_axi_clk (),
    .mrmac_flexif_clk (),
    .shim_axi_reset (),
    .mrmac_tx_core_reset   (tx_core_reset),
    .mrmac_rx_core_reset   (rx_core_reset),
    .mrmac_tx_serdes_reset (tx_serdes_reset),
    .mrmac_rx_serdes_reset (rx_serdes_reset),
    .mrmac_flexif_reset (),

    .mrmac_txdata_in_0 (txd[0*SW +: SW]),
    .mrmac_txdata_in_1 (txd[1*SW +: SW]),
    .mrmac_txdata_in_2 (txd[2*SW +: SW]),
    .mrmac_txdata_in_3 (txd[3*SW +: SW]),
    .gt_ch_txdata_0 (gt_txd[0*CW +: CW]),
    .gt_ch_txdata_1 (gt_txd[1*CW +: CW]),
    .gt_ch_txdata_2 (gt_txd[2*CW +: CW]),
    .gt_ch_txdata_3 (gt_txd[3*CW +: CW]),
    .gt_ch_rxdata_0 (gt_rxd[0*CW +: CW]),
    .gt_ch_rxdata_1 (gt_rxd[1*CW +: CW]),
    .gt_ch_rxdata_2 (gt_rxd[2*CW +: CW]),
    .gt_ch_rxdata_3 (gt_rxd[3*CW +: CW]),
    .mrmac_rxdata_out_0 (rxd[0*SW +: SW]),
    .mrmac_rxdata_out_1 (rxd[1*SW +: SW]),
    .mrmac_rxdata_out_2 (rxd[2*SW +: SW]),
    .mrmac_rxdata_out_3 (rxd[3*SW +: SW]),

    .shim_tx_axis_tdata      (s_tx_tdata),
    .shim_tx_axis_tkeep_user (s_tx_ku),
    .shim_tx_axis_tvalid     (s_tx_tvalid),
    .shim_tx_axis_tlast      (s_tx_tlast),
    .shim_tx_axis_tready     (s_tx_tready),

    .mrmac_tx_axis_tdata0 (m_tx_w[0*64 +: 64]),
    .mrmac_tx_axis_tdata1 (m_tx_w[1*64 +: 64]),
    .mrmac_tx_axis_tdata2 (m_tx_w[2*64 +: 64]),
    .mrmac_tx_axis_tdata3 (m_tx_w[3*64 +: 64]),
    .mrmac_tx_axis_tdata4 (m_tx_w[4*64 +: 64]),
    .mrmac_tx_axis_tdata5 (m_tx_w[5*64 +: 64]),
    .mrmac_tx_axis_tdata6 (m_tx_w[6*64 +: 64]),
    .mrmac_tx_axis_tkeep_user0 (m_tx_ku[0*11 +: 11]),
    .mrmac_tx_axis_tkeep_user1 (m_tx_ku[1*11 +: 11]),
    .mrmac_tx_axis_tkeep_user2 (m_tx_ku[2*11 +: 11]),
    .mrmac_tx_axis_tkeep_user3 (m_tx_ku[3*11 +: 11]),
    .mrmac_tx_axis_tkeep_user4 (m_tx_ku[4*11 +: 11]),
    .mrmac_tx_axis_tkeep_user5 (m_tx_ku[5*11 +: 11]),
    .mrmac_tx_axis_tkeep_user6 (m_tx_ku[6*11 +: 11]),
    .mrmac_tx_axis_tvalid_0 (m_tx_tvalid[0]),
    .mrmac_tx_axis_tvalid_1 (m_tx_tvalid[1]),
    .mrmac_tx_axis_tvalid_2 (m_tx_tvalid[2]),
    .mrmac_tx_axis_tvalid_3 (m_tx_tvalid[3]),
    .mrmac_tx_axis_tlast_0 (m_tx_tlast[0]),
    .mrmac_tx_axis_tlast_1 (m_tx_tlast[1]),
    .mrmac_tx_axis_tlast_2 (m_tx_tlast[2]),
    .mrmac_tx_axis_tlast_3 (m_tx_tlast[3]),
    .mrmac_tx_axis_tready_0 (m_tx_tready[0]),
    .mrmac_tx_axis_tready_1 (m_tx_tready[1]),
    .mrmac_tx_axis_tready_2 (m_tx_tready[2]),
    .mrmac_tx_axis_tready_3 (m_tx_tready[3]),

    .mrmac_rx_axis_tdata0 (m_rx_w[0*64 +: 64]),
    .mrmac_rx_axis_tdata1 (m_rx_w[1*64 +: 64]),
    .mrmac_rx_axis_tdata2 (m_rx_w[2*64 +: 64]),
    .mrmac_rx_axis_tdata3 (m_rx_w[3*64 +: 64]),
    .mrmac_rx_axis_tdata4 (m_rx_w[4*64 +: 64]),
    .mrmac_rx_axis_tdata5 (m_rx_w[5*64 +: 64]),
    .mrmac_rx_axis_tdata6 (m_rx_w[6*64 +: 64]),
    .mrmac_rx_axis_tkeep_user0 (m_rx_ku[0*11 +: 11]),
    .mrmac_rx_axis_tkeep_user1 (m_rx_ku[1*11 +: 11]),
    .mrmac_rx_axis_tkeep_user2 (m_rx_ku[2*11 +: 11]),
    .mrmac_rx_axis_tkeep_user3 (m_rx_ku[3*11 +: 11]),
    .mrmac_rx_axis_tkeep_user4 (m_rx_ku[4*11 +: 11]),
    .mrmac_rx_axis_tkeep_user5 (m_rx_ku[5*11 +: 11]),
    .mrmac_rx_axis_tkeep_user6 (m_rx_ku[6*11 +: 11]),
    .mrmac_rx_axis_tvalid_0 (m_rx_tvalid[0]),
    .mrmac_rx_axis_tvalid_1 (m_rx_tvalid[1]),
    .mrmac_rx_axis_tvalid_2 (m_rx_tvalid[2]),
    .mrmac_rx_axis_tvalid_3 (m_rx_tvalid[3]),
    .mrmac_rx_axis_tlast_0 (m_rx_tlast[0]),
    .mrmac_rx_axis_tlast_1 (m_rx_tlast[1]),
    .mrmac_rx_axis_tlast_2 (m_rx_tlast[2]),
    .mrmac_rx_axis_tlast_3 (m_rx_tlast[3]),

    .shim_rx_axis_tdata      (s_rx_tdata),
    .shim_rx_axis_tkeep_user (s_rx_ku),
    .shim_rx_axis_tvalid     (s_rx_tvalid),
    .shim_rx_axis_tlast      (s_rx_tlast),

    .mrmac_stat_rx_status_0 (m_rx_status[0]),
    .mrmac_stat_rx_status_1 (m_rx_status[1]),
    .mrmac_stat_rx_status_2 (m_rx_status[2]),
    .mrmac_stat_rx_status_3 (m_rx_status[3]),
    .shim_stat_rx_status (s_rx_status),

    .mrmac_rx_ptp_tstamp_0 (m_rx_ts[0*55 +: 55]),
    .mrmac_rx_ptp_tstamp_1 (m_rx_ts[1*55 +: 55]),
    .mrmac_rx_ptp_tstamp_2 (m_rx_ts[2*55 +: 55]),
    .mrmac_rx_ptp_tstamp_3 (m_rx_ts[3*55 +: 55]),
    .shim_rx_ptp_tstamp (s_rx_ts),

    .shim_tx_ptp_1588op (s_tx_op),
    .shim_tx_ptp_tag_field (s_tx_tag),
    .mrmac_tx_ptp_1588op_0 (m_tx_op[0*2 +: 2]),
    .mrmac_tx_ptp_1588op_1 (m_tx_op[1*2 +: 2]),
    .mrmac_tx_ptp_1588op_2 (m_tx_op[2*2 +: 2]),
    .mrmac_tx_ptp_1588op_3 (m_tx_op[3*2 +: 2]),
    .mrmac_tx_ptp_tag_field_0 (m_tx_tag[0*16 +: 16]),
    .mrmac_tx_ptp_tag_field_1 (m_tx_tag[1*16 +: 16]),
    .mrmac_tx_ptp_tag_field_2 (m_tx_tag[2*16 +: 16]),
    .mrmac_tx_ptp_tag_field_3 (m_tx_tag[3*16 +: 16]),

    .mrmac_tx_ptp_tstamp_0 (m_tx_ts[0*55 +: 55]),
    .mrmac_tx_ptp_tstamp_1 (m_tx_ts[1*55 +: 55]),
    .mrmac_tx_ptp_tstamp_2 (m_tx_ts[2*55 +: 55]),
    .mrmac_tx_ptp_tstamp_3 (m_tx_ts[3*55 +: 55]),
    .mrmac_tx_ptp_tstamp_tag_0 (m_tx_ts_tag[0*16 +: 16]),
    .mrmac_tx_ptp_tstamp_tag_1 (m_tx_ts_tag[1*16 +: 16]),
    .mrmac_tx_ptp_tstamp_tag_2 (m_tx_ts_tag[2*16 +: 16]),
    .mrmac_tx_ptp_tstamp_tag_3 (m_tx_ts_tag[3*16 +: 16]),
    .mrmac_tx_ptp_tstamp_valid_0 (m_tx_ts_valid[0]),
    .mrmac_tx_ptp_tstamp_valid_1 (m_tx_ts_valid[1]),
    .mrmac_tx_ptp_tstamp_valid_2 (m_tx_ts_valid[2]),
    .mrmac_tx_ptp_tstamp_valid_3 (m_tx_ts_valid[3]),
    .shim_tx_ptp_tstamp (s_tx_ts),
    .shim_tx_ptp_tstamp_tag (s_tx_ts_tag),
    .shim_tx_ptp_tstamp_valid (s_tx_ts_valid),

    .shim_tx_ptp_systemtimer (s_tx_st),
    .shim_tx_ptp_st_sync (s_tx_st_sync),
    .shim_tx_ptp_st_overwrite (s_tx_st_ow),
    .shim_rx_ptp_systemtimer (s_rx_st),
    .shim_rx_ptp_st_sync (s_rx_st_sync),
    .shim_rx_ptp_st_overwrite (s_rx_st_ow),
    .mrmac_ctl_tx_ptp_systemtimer_0 (m_tx_st[0*55 +: 55]),
    .mrmac_ctl_tx_ptp_systemtimer_1 (m_tx_st[1*55 +: 55]),
    .mrmac_ctl_tx_ptp_systemtimer_2 (m_tx_st[2*55 +: 55]),
    .mrmac_ctl_tx_ptp_systemtimer_3 (m_tx_st[3*55 +: 55]),
    .mrmac_ctl_tx_ptp_st_sync_0 (m_tx_st_sync[0]),
    .mrmac_ctl_tx_ptp_st_sync_1 (m_tx_st_sync[1]),
    .mrmac_ctl_tx_ptp_st_sync_2 (m_tx_st_sync[2]),
    .mrmac_ctl_tx_ptp_st_sync_3 (m_tx_st_sync[3]),
    .mrmac_ctl_tx_ptp_st_overwrite_0 (m_tx_st_ow[0]),
    .mrmac_ctl_tx_ptp_st_overwrite_1 (m_tx_st_ow[1]),
    .mrmac_ctl_tx_ptp_st_overwrite_2 (m_tx_st_ow[2]),
    .mrmac_ctl_tx_ptp_st_overwrite_3 (m_tx_st_ow[3]),
    .mrmac_ctl_rx_ptp_systemtimer_0 (m_rx_st[0*55 +: 55]),
    .mrmac_ctl_rx_ptp_systemtimer_1 (m_rx_st[1*55 +: 55]),
    .mrmac_ctl_rx_ptp_systemtimer_2 (m_rx_st[2*55 +: 55]),
    .mrmac_ctl_rx_ptp_systemtimer_3 (m_rx_st[3*55 +: 55]),
    .mrmac_ctl_rx_ptp_st_sync_0 (m_rx_st_sync[0]),
    .mrmac_ctl_rx_ptp_st_sync_1 (m_rx_st_sync[1]),
    .mrmac_ctl_rx_ptp_st_sync_2 (m_rx_st_sync[2]),
    .mrmac_ctl_rx_ptp_st_sync_3 (m_rx_st_sync[3]),
    .mrmac_ctl_rx_ptp_st_overwrite_0 (m_rx_st_ow[0]),
    .mrmac_ctl_rx_ptp_st_overwrite_1 (m_rx_st_ow[1]),
    .mrmac_ctl_rx_ptp_st_overwrite_2 (m_rx_st_ow[2]),
    .mrmac_ctl_rx_ptp_st_overwrite_3 (m_rx_st_ow[3]),

    .shim_ctl_tx_pause_enable (s_tx_pen),
    .shim_ctl_tx_pause_req (s_tx_preq),
    .shim_ctl_rx_pause_enable (s_rx_pen),
    .shim_ctl_rx_pause_ack (s_rx_pack),
    .shim_stat_rx_pause_req (s_rx_preq),
    .mrmac_ctl_tx_pause_enable_0 (m_tx_pen[0*9 +: 9]),
    .mrmac_ctl_tx_pause_enable_1 (m_tx_pen[1*9 +: 9]),
    .mrmac_ctl_tx_pause_enable_2 (m_tx_pen[2*9 +: 9]),
    .mrmac_ctl_tx_pause_enable_3 (m_tx_pen[3*9 +: 9]),
    .mrmac_ctl_tx_pause_req_0 (m_tx_preq[0*9 +: 9]),
    .mrmac_ctl_tx_pause_req_1 (m_tx_preq[1*9 +: 9]),
    .mrmac_ctl_tx_pause_req_2 (m_tx_preq[2*9 +: 9]),
    .mrmac_ctl_tx_pause_req_3 (m_tx_preq[3*9 +: 9]),
    .mrmac_ctl_rx_pause_enable_0 (m_rx_pen[0*9 +: 9]),
    .mrmac_ctl_rx_pause_enable_1 (m_rx_pen[1*9 +: 9]),
    .mrmac_ctl_rx_pause_enable_2 (m_rx_pen[2*9 +: 9]),
    .mrmac_ctl_rx_pause_enable_3 (m_rx_pen[3*9 +: 9]),
    .mrmac_ctl_rx_pause_ack_0 (m_rx_pack[0*9 +: 9]),
    .mrmac_ctl_rx_pause_ack_1 (m_rx_pack[1*9 +: 9]),
    .mrmac_ctl_rx_pause_ack_2 (m_rx_pack[2*9 +: 9]),
    .mrmac_ctl_rx_pause_ack_3 (m_rx_pack[3*9 +: 9]),
    .mrmac_stat_rx_pause_req_0 (m_rx_preq[0*9 +: 9]),
    .mrmac_stat_rx_pause_req_1 (m_rx_preq[1*9 +: 9]),
    .mrmac_stat_rx_pause_req_2 (m_rx_preq[2*9 +: 9]),
    .mrmac_stat_rx_pause_req_3 (m_rx_preq[3*9 +: 9]));

  reg  [PORTS*SHIM_W-1:0] l_tx_tdata = 0;
  reg  [PORTS*16-1:0]     l_tx_tag = 0;
  reg  [PORTS-1:0]        l_tx_tvalid = 0;
  wire [PORTS-1:0]        l_tx_tready;
  wire [7*64-1:0]         lm_tx_w;
  wire [3:0]              lm_tx_tvalid;
  wire [4*16-1:0]         lm_tx_tag;
  wire [PORTS*SHIM_W-1:0] l_rx_tdata;
  wire [PORTS-1:0]        l_rx_tvalid;

  mrmac_versal_glue #(
    .GT_TYPE         ("GTYP"),
    .MODE            (MODE),
    .TX_CH_MAP       (TX_CH_MAP),
    .RX_CH_MAP       (RX_CH_MAP),
    .LOOPBACK_ENABLE (1)
  ) dut_lb (
    .axis_clk_in (axis_clk),
    .ts_clk_in (ts_clk),
    .pl_resetn (pl_resetn),
    .loopback_en (loopback_en),
    .loopback_mac_swap (1'b0),

    .shim_tx_axis_tdata      (l_tx_tdata),
    .shim_tx_axis_tkeep_user ({PORTS*KU_W{1'b0}}),
    .shim_tx_axis_tvalid     (l_tx_tvalid),
    .shim_tx_axis_tlast      ({PORTS{1'b1}}),
    .shim_tx_axis_tready     (l_tx_tready),
    .shim_tx_ptp_tag_field   (l_tx_tag),

    .mrmac_tx_axis_tdata0 (lm_tx_w[0*64 +: 64]),
    .mrmac_tx_axis_tdata1 (lm_tx_w[1*64 +: 64]),
    .mrmac_tx_axis_tdata2 (lm_tx_w[2*64 +: 64]),
    .mrmac_tx_axis_tdata3 (lm_tx_w[3*64 +: 64]),
    .mrmac_tx_axis_tdata4 (lm_tx_w[4*64 +: 64]),
    .mrmac_tx_axis_tdata5 (lm_tx_w[5*64 +: 64]),
    .mrmac_tx_axis_tdata6 (lm_tx_w[6*64 +: 64]),
    .mrmac_tx_axis_tvalid_0 (lm_tx_tvalid[0]),
    .mrmac_tx_axis_tvalid_1 (lm_tx_tvalid[1]),
    .mrmac_tx_axis_tvalid_2 (lm_tx_tvalid[2]),
    .mrmac_tx_axis_tvalid_3 (lm_tx_tvalid[3]),
    .mrmac_tx_axis_tready_0 (1'b1),
    .mrmac_tx_axis_tready_1 (1'b1),
    .mrmac_tx_axis_tready_2 (1'b1),
    .mrmac_tx_axis_tready_3 (1'b1),
    .mrmac_tx_ptp_tag_field_0 (lm_tx_tag[0*16 +: 16]),
    .mrmac_tx_ptp_tag_field_1 (lm_tx_tag[1*16 +: 16]),
    .mrmac_tx_ptp_tag_field_2 (lm_tx_tag[2*16 +: 16]),
    .mrmac_tx_ptp_tag_field_3 (lm_tx_tag[3*16 +: 16]),

    .mrmac_rx_axis_tdata0 (m_rx_w[0*64 +: 64]),
    .mrmac_rx_axis_tdata1 (m_rx_w[1*64 +: 64]),
    .mrmac_rx_axis_tdata2 (m_rx_w[2*64 +: 64]),
    .mrmac_rx_axis_tdata3 (m_rx_w[3*64 +: 64]),
    .mrmac_rx_axis_tdata4 (m_rx_w[4*64 +: 64]),
    .mrmac_rx_axis_tdata5 (m_rx_w[5*64 +: 64]),
    .mrmac_rx_axis_tdata6 (m_rx_w[6*64 +: 64]),
    .mrmac_rx_axis_tkeep_user0 (m_rx_ku[0*11 +: 11]),
    .mrmac_rx_axis_tkeep_user1 (m_rx_ku[1*11 +: 11]),
    .mrmac_rx_axis_tkeep_user2 (m_rx_ku[2*11 +: 11]),
    .mrmac_rx_axis_tkeep_user3 (m_rx_ku[3*11 +: 11]),
    .mrmac_rx_axis_tkeep_user4 (m_rx_ku[4*11 +: 11]),
    .mrmac_rx_axis_tkeep_user5 (m_rx_ku[5*11 +: 11]),
    .mrmac_rx_axis_tkeep_user6 (m_rx_ku[6*11 +: 11]),
    .mrmac_rx_axis_tvalid_0 (m_rx_tvalid[0]),
    .mrmac_rx_axis_tvalid_1 (m_rx_tvalid[1]),
    .mrmac_rx_axis_tvalid_2 (m_rx_tvalid[2]),
    .mrmac_rx_axis_tvalid_3 (m_rx_tvalid[3]),
    .mrmac_rx_axis_tlast_0 (m_rx_tlast[0]),
    .mrmac_rx_axis_tlast_1 (m_rx_tlast[1]),
    .mrmac_rx_axis_tlast_2 (m_rx_tlast[2]),
    .mrmac_rx_axis_tlast_3 (m_rx_tlast[3]),
    .shim_rx_axis_tdata  (l_rx_tdata),
    .shim_rx_axis_tvalid (l_rx_tvalid));

  // clock edge counters: [k*4 + i] for group k, bit i

  localparam G_TX_CORE = 0, G_TX_ALT = 1, G_RX_CORE = 2, G_RX_SERDES = 3,
             G_RX_ALT = 4, G_GT_TXU = 5, G_GT_RXU = 6, G_TX_OUT = 7, G_RX_OUT = 8;

  wire [36-1:0] mon = {rx_outclk, tx_outclk, gt_rx_usrclk, gt_tx_usrclk,
                       rx_alt_serdes_clk, rx_serdes_clk, rx_core_clk,
                       tx_alt_serdes_clk, tx_core_clk};

  integer cnt [0:35];
  reg cnt_en = 1'b0;

  genvar g;
  generate
    for (g = 0; g < 36; g = g + 1) begin : g_cnt
      initial cnt[g] = 0;
      always @(posedge mon[g])
        if (cnt_en) cnt[g] = cnt[g] + 1;
    end
  endgenerate

  task count_window;
    integer i;
    begin
      for (i = 0; i < 36; i = i + 1)
        cnt[i] = 0;
      cnt_en = 1'b1;
      #2000;
      cnt_en = 1'b0;
      #10;
    end
  endtask

  task chk_clk;
    input [8*32-1:0] name;
    input integer    idx;
    input integer    got;
    input integer    ref;
    input integer    div;
    integer exp;
    begin
      exp = (div == 0) ? 0 : ref / div;
      if (got < exp - 2 || got > exp + 2 || (div != 0 && exp < 100)) begin
        $display("%t %0s[%0d]: %0d edges, expected %0d", $time, name, idx, got, exp);
        errors = errors + 1;
      end
    end
  endtask

  task test_lane_map;
    integer e0, k, n, c, p;
    begin
      e0 = errors;

      for (k = 0; k < 4; k = k + 1) begin
        for (n = 0; n < 4; n = n + 1)
          txd[n*SW +: SW] = {n[7:0] | 8'hd0, k[7:0], $random, $random};
        for (c = 0; c < 4; c = c + 1)
          gt_rxd[c*CW +: CW] = {$random, $random, c[7:0] | 8'he0, k[7:0], $random, $random};
        #1;
        for (c = 0; c < 4; c = c + 1) begin
          p = -1;
          for (n = 0; n < 4; n = n + 1)
            if (tx_ch(n) == c) p = n;
          chk("gt_ch_txdata", gt_txd[c*CW +: CW], {{(CW-SW){1'b0}}, txd[p*SW +: SW]});
        end
        for (n = 0; n < 4; n = n + 1)
          chk("mrmac_rxdata_out", rxd[n*SW +: SW], gt_rxd[rx_ch(n)*CW +: SW]);
      end

      for (c = 0; c < 4; c = c + 1) begin
        tx_done = 4'b0001 << c;
        rx_done = 4'b0001 << c;
        #1;
        for (n = 0; n < 4; n = n + 1) begin
          chk("mrmac_tx_core_reset",   tx_core_reset[n],   tx_if(n) != c);
          chk("mrmac_tx_serdes_reset", tx_serdes_reset[n], tx_if(n) != c);
          chk("mrmac_rx_core_reset",   rx_core_reset[n],   rx_if(n) != c);
          chk("mrmac_rx_serdes_reset", rx_serdes_reset[n], rx_if(n) != c);
        end
      end
      tx_done = 4'hf;
      rx_done = 4'hf;

      count_window;
      for (n = 0; n < 4; n = n + 1) begin
        chk_clk("mrmac_tx_core_clk",       n, cnt[G_TX_CORE*4+n],   cnt[G_TX_OUT*4+tx_if(n)], 1);
        chk_clk("mrmac_tx_alt_serdes_clk", n, cnt[G_TX_ALT*4+n],    cnt[G_TX_OUT*4+tx_if(n)], 2);
        chk_clk("mrmac_rx_core_clk",       n, cnt[G_RX_CORE*4+n],   cnt[G_RX_OUT*4+rx_ch(n)], 1);
        chk_clk("mrmac_rx_serdes_clk",     n, cnt[G_RX_SERDES*4+n], cnt[G_RX_OUT*4+rx_ch(n)], 1);
        chk_clk("mrmac_rx_alt_serdes_clk", n, cnt[G_RX_ALT*4+n],    cnt[G_RX_OUT*4+rx_ch(n)], 2);
      end
      for (c = 0; c < 4; c = c + 1) begin
        chk_clk("gt_tx_usrclk", c, cnt[G_GT_TXU*4+c], cnt[G_TX_OUT*4+(M4 ? c : 0)], 2);
        chk_clk("gt_rx_usrclk", c, cnt[G_GT_RXU*4+c], cnt[G_RX_OUT*4+c], 2);
      end

      pass_fail("test_lane_map", e0);
    end
  endtask

  task test_clk_clear;
    integer e0, n, c;
    begin
      e0 = errors;
      for (c = 0; c < 4; c = c + 1) begin
        tx_clr = 4'b0001 << c;
        rx_clr = 4'b0001 << c;
        #20;
        count_window;
        for (n = 0; n < 4; n = n + 1) begin
          chk_clk("mrmac_tx_core_clk", n, cnt[G_TX_CORE*4+n],
                  cnt[G_TX_OUT*4+tx_if(n)], (tx_if(n) == c) ? 0 : 1);
          chk_clk("mrmac_rx_core_clk", n, cnt[G_RX_CORE*4+n],
                  cnt[G_RX_OUT*4+rx_ch(n)], (rx_if(n) == c) ? 0 : 1);
        end
        tx_clr = 4'h0;
        rx_clr = 4'h0;
        #20;
      end
      pass_fail("test_clk_clear", e0);
    end
  endtask

  task test_shim_ports;
    integer e0, k, w, n;
    reg [63:0] ew;
    reg [10:0] ek;
    begin
      e0 = errors;
      for (k = 0; k < 4; k = k + 1) begin
        for (w = 0; w < PORTS*SHIM_W/32; w = w + 1)
          s_tx_tdata[w*32 +: 32] = $random;
        for (w = 0; w < 7*2; w = w + 1)
          m_rx_w[w*32 +: 32] = $random;
        s_tx_ku = {$random, $random, $random};
        m_rx_ku = {$random, $random, $random};
        s_tx_tvalid = $random;
        s_tx_tlast = $random;
        m_tx_tready = $random;
        m_rx_tvalid = $random;
        m_rx_tlast = $random;
        m_rx_status = $random;
        m_rx_ts = {$random, $random, $random, $random, $random, $random, $random};
        s_tx_op = $random;
        s_tx_tag = {$random, $random};
        m_tx_ts = {$random, $random, $random, $random, $random, $random, $random};
        m_tx_ts_tag = {$random, $random};
        m_tx_ts_valid = $random;
        s_tx_st = {$random, $random, $random, $random, $random, $random, $random};
        s_rx_st = {$random, $random, $random, $random, $random, $random, $random};
        s_tx_st_sync = $random;
        s_tx_st_ow = $random;
        s_rx_st_sync = $random;
        s_rx_st_ow = $random;
        s_tx_pen = {$random, $random};
        s_tx_preq = {$random, $random};
        s_rx_pen = {$random, $random};
        s_rx_pack = {$random, $random};
        m_rx_preq = {$random, $random};
        #1;

        // MRMAC word w: 4x25G port w/2 on even words, port 0 on words 0..WORDS-1 otherwise;
        // words 4..6 stay 0 at 1x40G
        for (w = 0; w < 7; w = w + 1) begin
          ew = 64'd0;
          ek = 11'd0;
          if (M4 && w % 2 == 0) begin
            ew = s_tx_tdata[(w/2)*64 +: 64];
            ek = s_tx_ku[(w/2)*11 +: 11];
          end else if (!M4 && w < WORDS) begin
            ew = s_tx_tdata[w*64 +: 64];
            ek = s_tx_ku[w*11 +: 11];
          end
          chk("mrmac_tx_axis_tdata", m_tx_w[w*64 +: 64], ew);
          chk("mrmac_tx_axis_tkeep_user", m_tx_ku[w*11 +: 11], ek);
        end

        for (n = 0; n < PORTS; n = n + 1) begin
          if (M4) begin
            chk("shim_rx_axis_tdata", s_rx_tdata[n*64 +: 64], m_rx_w[2*n*64 +: 64]);
            chk("shim_rx_axis_tkeep_user", s_rx_ku[n*11 +: 11], m_rx_ku[2*n*11 +: 11]);
          end else begin
            chk("shim_rx_axis_tdata", s_rx_tdata, m_rx_w[SHIM_W-1:0]);
            chk("shim_rx_axis_tkeep_user", s_rx_ku, m_rx_ku[KU_W-1:0]);
          end
          chk("shim_rx_axis_tvalid", s_rx_tvalid[n], m_rx_tvalid[n]);
          chk("shim_rx_axis_tlast", s_rx_tlast[n], m_rx_tlast[n]);
          chk("shim_tx_axis_tready", s_tx_tready[n], m_tx_tready[n]);
          chk("shim_stat_rx_status", s_rx_status[n], m_rx_status[n]);
          chk("shim_rx_ptp_tstamp", s_rx_ts[n*55 +: 55], m_rx_ts[n*55 +: 55]);
          chk("shim_tx_ptp_tstamp", s_tx_ts[n*55 +: 55], m_tx_ts[n*55 +: 55]);
          chk("shim_tx_ptp_tstamp_tag", s_tx_ts_tag[n*16 +: 16], m_tx_ts_tag[n*16 +: 16]);
          chk("shim_tx_ptp_tstamp_valid", s_tx_ts_valid[n], m_tx_ts_valid[n]);
          chk("shim_stat_rx_pause_req", s_rx_preq[n*9 +: 9], m_rx_preq[n*9 +: 9]);
        end

        for (n = 0; n < 4; n = n + 1) begin
          chk("mrmac_tx_axis_tvalid", m_tx_tvalid[n], n < PORTS ? s_tx_tvalid[n] : 1'b0);
          chk("mrmac_tx_axis_tlast", m_tx_tlast[n], n < PORTS ? s_tx_tlast[n] : 1'b0);
          chk("mrmac_tx_ptp_1588op", m_tx_op[n*2 +: 2], n < PORTS ? s_tx_op[n*2 +: 2] : 2'd0);
          chk("mrmac_tx_ptp_tag_field", m_tx_tag[n*16 +: 16], n < PORTS ? s_tx_tag[n*16 +: 16] : 16'd0);
          chk("mrmac_ctl_tx_ptp_systemtimer", m_tx_st[n*55 +: 55], n < PORTS ? s_tx_st[n*55 +: 55] : 55'd0);
          chk("mrmac_ctl_tx_ptp_st_sync", m_tx_st_sync[n], n < PORTS ? s_tx_st_sync[n] : 1'b0);
          chk("mrmac_ctl_tx_ptp_st_overwrite", m_tx_st_ow[n], n < PORTS ? s_tx_st_ow[n] : 1'b0);
          chk("mrmac_ctl_rx_ptp_systemtimer", m_rx_st[n*55 +: 55], n < PORTS ? s_rx_st[n*55 +: 55] : 55'd0);
          chk("mrmac_ctl_rx_ptp_st_sync", m_rx_st_sync[n], n < PORTS ? s_rx_st_sync[n] : 1'b0);
          chk("mrmac_ctl_rx_ptp_st_overwrite", m_rx_st_ow[n], n < PORTS ? s_rx_st_ow[n] : 1'b0);
          chk("mrmac_ctl_tx_pause_enable", m_tx_pen[n*9 +: 9], n < PORTS ? s_tx_pen[n*9 +: 9] : 9'd0);
          chk("mrmac_ctl_tx_pause_req", m_tx_preq[n*9 +: 9], n < PORTS ? s_tx_preq[n*9 +: 9] : 9'd0);
          chk("mrmac_ctl_rx_pause_enable", m_rx_pen[n*9 +: 9], n < PORTS ? s_rx_pen[n*9 +: 9] : 9'd0);
          chk("mrmac_ctl_rx_pause_ack", m_rx_pack[n*9 +: 9], n < PORTS ? s_rx_pack[n*9 +: 9] : 9'd0);
        end
      end
      m_rx_tvalid = 4'd0;
      pass_fail("test_shim_ports", e0);
    end
  endtask

  task test_loopback_ports;
    integer e0, n, w, i;
    reg [PORTS-1:0] seen;
    reg [PORTS-1:0] done;
    reg [SHIM_W-1:0] ew;
    begin
      e0 = errors;
      seen = 0;
      done = 0;
      @(posedge axis_clk);
      for (w = 0; w < PORTS*SHIM_W/32; w = w + 1)
        l_tx_tdata[w*32 +: 32] <= $random;
      for (n = 0; n < PORTS; n = n + 1)
        l_tx_tag[n*16 +: 16] <= 16'h7a00 + n;
      l_tx_tvalid <= {PORTS{1'b1}};

      for (i = 0; i < 20; i = i + 1) begin
        @(posedge axis_clk);
        done = done | (l_tx_tvalid & l_tx_tready);
        l_tx_tvalid <= l_tx_tvalid & ~(l_tx_tvalid & l_tx_tready);
        for (n = 0; n < PORTS; n = n + 1) begin
          if (lm_tx_tvalid[n]) begin
            ew = M4 ? lm_tx_w[2*n*64 +: 64] : lm_tx_w[SHIM_W-1:0];
            chk("lb mrmac_tx_axis_tdata", ew, l_tx_tdata[n*SHIM_W +: SHIM_W]);
            chk("lb mrmac_tx_ptp_tag_field", lm_tx_tag[n*16 +: 16], 16'h7a00 + n);
            seen[n] = 1'b1;
          end
        end
      end
      chk("lb tx beats seen", seen, {PORTS{1'b1}});
      chk("lb tx beats accepted", done, {PORTS{1'b1}});
      chk("lb mrmac_tx_axis_tvalid unused ports", lm_tx_tvalid >> PORTS, 0);

      for (w = 0; w < 7*2; w = w + 1)
        m_rx_w[w*32 +: 32] = $random;
      m_rx_tvalid = 4'hf;
      m_rx_tlast = 4'hf;
      #1;
      for (n = 0; n < PORTS; n = n + 1) begin
        chk("lb shim_rx_axis_tvalid", l_rx_tvalid[n], 1'b1);
        chk("lb shim_rx_axis_tdata", l_rx_tdata[n*SHIM_W +: SHIM_W],
            M4 ? m_rx_w[2*n*64 +: 64] : m_rx_w[SHIM_W-1:0]);
      end
      @(posedge axis_clk);
      m_rx_tvalid = 4'h0;
      pass_fail("test_loopback_ports", e0);
    end
  endtask

  initial begin
    #(`TIMEOUT - 1);
    $display("FAIL  tests did not complete before TIMEOUT");
    failed <= 1'b1;
  end

  initial begin
    #50;
    pl_resetn = 1'b1;
    #100;
    tx_clr = 4'h0;
    rx_clr = 4'h0;
    #10;
    tx_clrb_leaf = 4'hf;
    rx_clrb_leaf = 4'hf;
    #50;

    test_lane_map;
    test_clk_clear;
    test_shim_ports;
    test_loopback_ports;

    if (errors != 0) failed <= 1'b1;
    #10;
    $display("%0s: %0d errors", MODE, errors);
    if (failed == 1'b0)
      $display("SUCCESS");
    else
      $display("FAILED");
    $finish;
  end

endmodule
