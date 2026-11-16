// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2026 Analog Devices, Inc. All rights reserved
 */
/*
 * MODE "1x100G": one 100GE port (512b). MODE "4x25G": four 25GBASE-R ports
 * (64b each, PORT_COUNT 4). MODE "1x40G": one 40GBASE-R4 port (256b).
 */

`timescale 1ns/100ps

module ethernet_vck190 #(
  parameter TDMA_BER_ENABLE = 0,

  // "1x100G", "4x25G" or "1x40G"
  parameter MODE = "1x100G",

  parameter QSFP_CNT = 1,
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,
  parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF,

  parameter PTP_TS_FMT_TOD = 0,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 48,
  parameter TX_TAG_WIDTH = 16,

  parameter MRMAC_TS_WIDTH = 55,

  parameter TDMA_INDEX_WIDTH = 6,

  parameter PTP_TS_ENABLE = 1,

  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  parameter AXIL_IF_CTRL_ADDR_WIDTH = AXIL_CTRL_ADDR_WIDTH-$clog2(IF_COUNT),
  parameter AXIL_CSR_ADDR_WIDTH = AXIL_IF_CTRL_ADDR_WIDTH-5-$clog2((SCHED_PER_IF+4+7)/8),

  parameter ETH_RX_CLK_FROM_TX = 0,
  parameter ETH_RS_FEC_ENABLE = 0,
  parameter AXIS_DATA_WIDTH = (MODE == "4x25G") ? 64 : (MODE == "1x40G") ? 256 : 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,

  parameter MRMAC_PORT_DATA_W  = (MODE == "4x25G") ? 64 : (MODE == "1x40G") ? 256 : 384,
  parameter MRMAC_PORT_KUSER_W = (MODE == "4x25G") ? 11 : (MODE == "1x40G") ? 44 : 66
) (
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_wr_addr,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_wr_data,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]          ctrl_reg_wr_strb,
  input  wire                                     ctrl_reg_wr_en,
  output wire                                     ctrl_reg_wr_wait,
  output wire                                     ctrl_reg_wr_ack,
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]           ctrl_reg_rd_addr,
  input  wire                                     ctrl_reg_rd_en,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]          ctrl_reg_rd_data,
  output wire                                     ctrl_reg_rd_wait,
  output wire                                     ctrl_reg_rd_ack,

  output wire [PORT_COUNT-1:0]                    eth_tx_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_rst,

  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_tx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_tx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_tx_ptp_ts_step,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_tx_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_tx_tkeep,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tvalid,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_tready,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_tlast,
  input  wire [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0] axis_eth_tx_tuser,

  output wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       axis_eth_tx_ptp_ts,
  output wire [PORT_COUNT*TX_TAG_WIDTH-1:0]       axis_eth_tx_ptp_ts_tag,
  output wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_valid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_tx_ptp_ts_ready,

  input  wire [PORT_COUNT-1:0]                    eth_tx_enable,
  output wire [PORT_COUNT-1:0]                    eth_tx_status,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_en,
  input  wire [PORT_COUNT-1:0]                    eth_tx_lfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_en,
  input  wire [PORT_COUNT*8-1:0]                  eth_tx_pfc_req,

  output wire [PORT_COUNT-1:0]                    eth_rx_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_rst,

  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_clk,
  output wire [PORT_COUNT-1:0]                    eth_rx_ptp_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]       eth_rx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                    eth_rx_ptp_ts_step,

  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]    axis_eth_rx_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]    axis_eth_rx_tkeep,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tvalid,
  input  wire [PORT_COUNT-1:0]                    axis_eth_rx_tready,
  output wire [PORT_COUNT-1:0]                    axis_eth_rx_tlast,
  output wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0] axis_eth_rx_tuser,

  input  wire [PORT_COUNT-1:0]                    eth_rx_enable,
  output wire [PORT_COUNT-1:0]                    eth_rx_status,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_en,
  output wire [PORT_COUNT-1:0]                    eth_rx_lfc_req,
  input  wire [PORT_COUNT-1:0]                    eth_rx_lfc_ack,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_en,
  output wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_req,
  input  wire [PORT_COUNT*8-1:0]                  eth_rx_pfc_ack,

  input  wire                                     gt_drp_clk,
  input  wire                                     gt_drp_rst,
  output wire [23:0]                              gt_drp_addr,
  output wire [31:0]                              gt_drp_di,
  output wire                                     gt_drp_en,
  output wire                                     gt_drp_we,
  input  wire [31:0]                              gt_drp_do,
  input  wire                                     gt_drp_rdy,

  /*
  * Per port:
  * one non-segmented word (1x100G: 6x64b data, 6x11b tkeep_user; 1x40G: 4x64b
  * data, 4x11b tkeep_user; 4x25G: 64b data, 11b tkeep_user).
  */
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_axi_clk,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axi_clk,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_reset_in,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_reset_in,

  output wire [PORT_COUNT*MRMAC_PORT_DATA_W-1:0]      mrmac_tx_axis_tdata,
  output wire [PORT_COUNT*MRMAC_PORT_KUSER_W-1:0]     mrmac_tx_axis_tkeep_user,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tready,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_axis_tlast,

  input  wire [PORT_COUNT*MRMAC_PORT_DATA_W-1:0]      mrmac_rx_axis_tdata,
  input  wire [PORT_COUNT*MRMAC_PORT_KUSER_W-1:0]     mrmac_rx_axis_tkeep_user,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                    mrmac_rx_axis_tlast,

  input  wire [PORT_COUNT-1:0]                    mrmac_stat_rx_status,
  output wire [PORT_COUNT-1:0]                    mrmac_ctl_tx_enable,
  output wire [PORT_COUNT-1:0]                    mrmac_ctl_rx_enable,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_fifo_overflow,

  // Per port: bit 8 = link pause (lfc), [7:0] = PFC.
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_tx_pause_enable,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_tx_pause_req,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_rx_pause_enable,
  output wire [PORT_COUNT*9-1:0]                  mrmac_ctl_rx_pause_ack,
  input  wire [PORT_COUNT*9-1:0]                  mrmac_stat_rx_pause_req,

  input  wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_rx_ptp_tstamp,
  output wire [PORT_COUNT*2-1:0]                  mrmac_tx_ptp_1588op,
  output wire [PORT_COUNT*16-1:0]                 mrmac_tx_ptp_tag_field,
  input  wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_tx_ptp_tstamp,
  input  wire [PORT_COUNT*16-1:0]                 mrmac_tx_ptp_tstamp_tag,
  input  wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_tstamp_valid,
  output wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_tx_ptp_systemtimer,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_st_sync,
  output wire [PORT_COUNT-1:0]                    mrmac_tx_ptp_st_overwrite,
  output wire [PORT_COUNT*MRMAC_TS_WIDTH-1:0]     mrmac_rx_ptp_systemtimer,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_ptp_st_sync,
  output wire [PORT_COUNT-1:0]                    mrmac_rx_ptp_st_overwrite
);

  genvar n;

  initial begin
    if (MODE != "1x100G" && MODE != "4x25G" && MODE != "1x40G") begin
      $error("Error: MODE must be \"1x100G\", \"4x25G\" or \"1x40G\" (instance %m)");
      $finish;
    end
    if (MODE == "1x100G" && AXIS_DATA_WIDTH != 512) begin
      $error("Error: ethernet_vck190 1x100G requires AXIS_DATA_WIDTH=512 (instance %m)");
      $finish;
    end
    if (MODE == "4x25G" && AXIS_DATA_WIDTH != 64) begin
      $error("Error: ethernet_vck190 4x25G requires AXIS_DATA_WIDTH=64 (instance %m)");
      $finish;
    end
    if (MODE == "1x40G" && AXIS_DATA_WIDTH != 256) begin
      $error("Error: ethernet_vck190 1x40G requires AXIS_DATA_WIDTH=256 (instance %m)");
      $finish;
    end
    if (AXIS_RX_USER_WIDTH > 81) begin
      $error("Error: AXIS_RX_USER_WIDTH exceeds the shim's 81-bit rx_axis_tuser field (instance %m)");
      $finish;
    end
  end

  localparam RB_BASE_ADDR = 16'h1000;

  localparam RB_DRP_BASE = RB_BASE_ADDR + 16'h40;

  rb_drp #(
    .DRP_ADDR_WIDTH(24),
    .DRP_DATA_WIDTH(32),
    .DRP_INFO({16'h0A03, 8'd2, 8'd4}),
    .REG_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
    .REG_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
    .REG_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),
    .RB_BASE_ADDR(RB_DRP_BASE),
    .RB_NEXT_PTR(0)
  ) mac_rb_drp_inst (
    .clk(clk),
    .rst(rst),

    .reg_wr_addr(ctrl_reg_wr_addr),
    .reg_wr_data(ctrl_reg_wr_data),
    .reg_wr_strb(ctrl_reg_wr_strb),
    .reg_wr_en(ctrl_reg_wr_en),
    .reg_wr_wait(ctrl_reg_wr_wait),
    .reg_wr_ack(ctrl_reg_wr_ack),
    .reg_rd_addr(ctrl_reg_rd_addr),
    .reg_rd_en(ctrl_reg_rd_en),
    .reg_rd_data(ctrl_reg_rd_data),
    .reg_rd_wait(ctrl_reg_rd_wait),
    .reg_rd_ack(ctrl_reg_rd_ack),

    .drp_clk(gt_drp_clk),
    .drp_rst(gt_drp_rst),
    .drp_addr(gt_drp_addr),
    .drp_di(gt_drp_di),
    .drp_en(gt_drp_en),
    .drp_we(gt_drp_we),
    .drp_do(gt_drp_do),
    .drp_rdy(gt_drp_rdy)
  );

  wire [PORT_COUNT-1:0]                 mac_tx_clk;
  wire [PORT_COUNT-1:0]                 mac_tx_rst;
  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_tx_axis_tdata;
  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_tx_axis_tkeep;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tvalid;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tready;
  wire [PORT_COUNT-1:0]                 mac_tx_axis_tlast;
  wire [PORT_COUNT*(16+1)-1:0]          mac_tx_axis_tuser;   // {tag[15:0], err}

  wire [PORT_COUNT*80-1:0]              mac_tx_ptp_time;
  wire [PORT_COUNT*80-1:0]              mac_tx_ptp_ts;
  wire [PORT_COUNT*16-1:0]              mac_tx_ptp_ts_tag;
  wire [PORT_COUNT-1:0]                 mac_tx_ptp_ts_valid;

  wire [PORT_COUNT-1:0]                 mac_tx_enable;
  wire [PORT_COUNT-1:0]                 mac_tx_lfc_en;
  wire [PORT_COUNT-1:0]                 mac_tx_lfc_req;
  wire [PORT_COUNT*8-1:0]               mac_tx_pfc_en;
  wire [PORT_COUNT*8-1:0]               mac_tx_pfc_req;

  wire [PORT_COUNT-1:0]                 mac_rx_clk;
  wire [PORT_COUNT-1:0]                 mac_rx_rst;
  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0] mac_rx_axis_tdata;
  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0] mac_rx_axis_tkeep;
  wire [PORT_COUNT-1:0]                 mac_rx_axis_tvalid;
  wire [PORT_COUNT-1:0]                 mac_rx_axis_tlast;
  wire [PORT_COUNT*(80+1)-1:0]          mac_rx_axis_tuser;   // {ptp_ts[79:0], err}

  wire [PORT_COUNT-1:0]                 mac_rx_ptp_clk;
  wire [PORT_COUNT-1:0]                 mac_rx_ptp_rst;
  wire [PORT_COUNT*80-1:0]              mac_rx_ptp_time;

  wire [PORT_COUNT-1:0]                 mac_rx_enable;
  wire [PORT_COUNT-1:0]                 mac_rx_status;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_en;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_req;
  wire [PORT_COUNT-1:0]                 mac_rx_lfc_ack;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_en;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_req;
  wire [PORT_COUNT*8-1:0]               mac_rx_pfc_ack;

  generate

    for (n = 0; n < PORT_COUNT; n = n + 1) begin : mac

      mrmac_gty_wrapper #(
        .MODE(MODE),
        .MRMAC_TS_WIDTH(MRMAC_TS_WIDTH)
      ) mrmac_gty_wrapper_inst (
        .tx_axi_clk(mrmac_tx_axi_clk[n +: 1]),
        .rx_axi_clk(mrmac_rx_axi_clk[n +: 1]),
        .tx_reset_in(mrmac_tx_reset_in[n +: 1]),
        .rx_reset_in(mrmac_rx_reset_in[n +: 1]),

        .tx_clk(mac_tx_clk[n +: 1]),
        .tx_rst(mac_tx_rst[n +: 1]),

        .tx_axis_tdata(mac_tx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .tx_axis_tkeep(mac_tx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .tx_axis_tvalid(mac_tx_axis_tvalid[n +: 1]),
        .tx_axis_tready(mac_tx_axis_tready[n +: 1]),
        .tx_axis_tlast(mac_tx_axis_tlast[n +: 1]),
        .tx_axis_tuser(mac_tx_axis_tuser[n*(16+1) +: (16+1)]),

        .tx_ptp_time(mac_tx_ptp_time[n*80 +: 80]),
        .tx_ptp_ts(mac_tx_ptp_ts[n*80 +: 80]),
        .tx_ptp_ts_tag(mac_tx_ptp_ts_tag[n*16 +: 16]),
        .tx_ptp_ts_valid(mac_tx_ptp_ts_valid[n +: 1]),

        .tx_enable(mac_tx_enable[n +: 1]),
        .tx_lfc_en(mac_tx_lfc_en[n +: 1]),
        .tx_lfc_req(mac_tx_lfc_req[n +: 1]),
        .tx_pfc_en(mac_tx_pfc_en[n*8 +: 8]),
        .tx_pfc_req(mac_tx_pfc_req[n*8 +: 8]),

        .rx_clk(mac_rx_clk[n +: 1]),
        .rx_rst(mac_rx_rst[n +: 1]),

        .rx_axis_tdata(mac_rx_axis_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .rx_axis_tkeep(mac_rx_axis_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .rx_axis_tvalid(mac_rx_axis_tvalid[n +: 1]),
        .rx_axis_tlast(mac_rx_axis_tlast[n +: 1]),
        .rx_axis_tuser(mac_rx_axis_tuser[n*(80+1) +: (80+1)]),

        .rx_ptp_clk(mac_rx_ptp_clk[n +: 1]),
        .rx_ptp_rst(mac_rx_ptp_rst[n +: 1]),
        .rx_ptp_time(mac_rx_ptp_time[n*80 +: 80]),

        .rx_enable(mac_rx_enable[n +: 1]),
        .rx_status(mac_rx_status[n +: 1]),
        .rx_lfc_en(mac_rx_lfc_en[n +: 1]),
        .rx_lfc_req(mac_rx_lfc_req[n +: 1]),
        .rx_lfc_ack(mac_rx_lfc_ack[n +: 1]),
        .rx_pfc_en(mac_rx_pfc_en[n*8 +: 8]),
        .rx_pfc_req(mac_rx_pfc_req[n*8 +: 8]),
        .rx_pfc_ack(mac_rx_pfc_ack[n*8 +: 8]),

        .mrmac_tx_axis_tdata(mrmac_tx_axis_tdata[n*MRMAC_PORT_DATA_W +: MRMAC_PORT_DATA_W]),
        .mrmac_tx_axis_tkeep_user(mrmac_tx_axis_tkeep_user[n*MRMAC_PORT_KUSER_W +: MRMAC_PORT_KUSER_W]),
        .mrmac_tx_axis_tvalid(mrmac_tx_axis_tvalid[n +: 1]),
        .mrmac_tx_axis_tready(mrmac_tx_axis_tready[n +: 1]),
        .mrmac_tx_axis_tlast(mrmac_tx_axis_tlast[n +: 1]),

        .mrmac_rx_axis_tdata(mrmac_rx_axis_tdata[n*MRMAC_PORT_DATA_W +: MRMAC_PORT_DATA_W]),
        .mrmac_rx_axis_tkeep_user(mrmac_rx_axis_tkeep_user[n*MRMAC_PORT_KUSER_W +: MRMAC_PORT_KUSER_W]),
        .mrmac_rx_axis_tvalid(mrmac_rx_axis_tvalid[n +: 1]),
        .mrmac_rx_axis_tlast(mrmac_rx_axis_tlast[n +: 1]),

        .mrmac_stat_rx_status(mrmac_stat_rx_status[n +: 1]),
        .ctl_tx_enable(mrmac_ctl_tx_enable[n +: 1]),
        .ctl_rx_enable(mrmac_ctl_rx_enable[n +: 1]),

        .mrmac_ctl_tx_pause_enable(mrmac_ctl_tx_pause_enable[n*9 +: 9]),
        .mrmac_ctl_tx_pause_req(mrmac_ctl_tx_pause_req[n*9 +: 9]),
        .mrmac_ctl_rx_pause_enable(mrmac_ctl_rx_pause_enable[n*9 +: 9]),
        .mrmac_ctl_rx_pause_ack(mrmac_ctl_rx_pause_ack[n*9 +: 9]),
        .mrmac_stat_rx_pause_req(mrmac_stat_rx_pause_req[n*9 +: 9]),

        .mrmac_rx_ptp_tstamp(mrmac_rx_ptp_tstamp[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_1588op(mrmac_tx_ptp_1588op[n*2 +: 2]),
        .mrmac_tx_ptp_tag_field(mrmac_tx_ptp_tag_field[n*16 +: 16]),
        .mrmac_tx_ptp_tstamp(mrmac_tx_ptp_tstamp[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_tstamp_tag(mrmac_tx_ptp_tstamp_tag[n*16 +: 16]),
        .mrmac_tx_ptp_tstamp_valid(mrmac_tx_ptp_tstamp_valid[n +: 1]),
        .mrmac_tx_ptp_systemtimer(mrmac_tx_ptp_systemtimer[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_tx_ptp_st_sync(mrmac_tx_ptp_st_sync[n +: 1]),
        .mrmac_tx_ptp_st_overwrite(mrmac_tx_ptp_st_overwrite[n +: 1]),
        .mrmac_rx_ptp_systemtimer(mrmac_rx_ptp_systemtimer[n*MRMAC_TS_WIDTH +: MRMAC_TS_WIDTH]),
        .mrmac_rx_ptp_st_sync(mrmac_rx_ptp_st_sync[n +: 1]),
        .mrmac_rx_ptp_st_overwrite(mrmac_rx_ptp_st_overwrite[n +: 1]),

        .rx_fifo_overflow(mrmac_rx_fifo_overflow[n +: 1]));

    end

  endgenerate

  // The shim's PTP ports are 80 bits; the port map uses PTP_TS_WIDTH (48, rel
  // format).
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_tx_ptp_time_int;
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_tx_ptp_ts_int;
  wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0] mac_rx_axis_tuser_int;
  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]     mac_rx_ptp_time_int;

  initial begin
    if (PTP_TS_WIDTH > 80) begin
      $error("Error: PTP_TS_WIDTH=%0d exceeds the shim's 80-bit PTP field; PTP_TS_FMT_TOD=1 (96-bit ToD) is not supported by this wrapper (instance %m)", PTP_TS_WIDTH);
      $finish;
    end
  end

  generate

  for (n = 0; n < PORT_COUNT; n = n + 1) begin : recon
    assign mac_tx_ptp_time[n*80 +: 80] =
        {{(80-PTP_TS_WIDTH){1'b0}}, mac_tx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]};
    assign mac_rx_ptp_time[n*80 +: 80] =
        {{(80-PTP_TS_WIDTH){1'b0}}, mac_rx_ptp_time_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]};

    assign mac_tx_ptp_ts_int[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]       = mac_tx_ptp_ts[n*80 +: PTP_TS_WIDTH];

    assign mac_rx_axis_tuser_int[n*AXIS_RX_USER_WIDTH +: AXIS_RX_USER_WIDTH] = mac_rx_axis_tuser[n*81 +: AXIS_RX_USER_WIDTH];
  end

  endgenerate

  mqnic_port_map_mac_axis #(
    .MAC_COUNT(PORT_COUNT),
    .PORT_MASK(PORT_MASK),
    .PORT_GROUP_SIZE(1),

    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),

    .PORT_COUNT(PORT_COUNT),

    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .PTP_TAG_WIDTH(TX_TAG_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TX_USER_WIDTH(AXIS_TX_USER_WIDTH),
    .AXIS_RX_USER_WIDTH(AXIS_RX_USER_WIDTH)
  ) mqnic_port_map_mac_axis_inst (
    .mac_tx_clk(mac_tx_clk),
    .mac_tx_rst(mac_tx_rst),

    .mac_tx_ptp_clk({PORT_COUNT{1'b0}}),
    .mac_tx_ptp_rst({PORT_COUNT{1'b0}}),
    .mac_tx_ptp_ts_96(mac_tx_ptp_time_int),
    .mac_tx_ptp_ts_step(),

    .m_axis_mac_tx_tdata(mac_tx_axis_tdata),
    .m_axis_mac_tx_tkeep(mac_tx_axis_tkeep),
    .m_axis_mac_tx_tvalid(mac_tx_axis_tvalid),
    .m_axis_mac_tx_tready(mac_tx_axis_tready),
    .m_axis_mac_tx_tlast(mac_tx_axis_tlast),
    .m_axis_mac_tx_tuser(mac_tx_axis_tuser),

    .s_axis_mac_tx_ptp_ts(mac_tx_ptp_ts_int),
    .s_axis_mac_tx_ptp_ts_tag(mac_tx_ptp_ts_tag),
    .s_axis_mac_tx_ptp_ts_valid(mac_tx_ptp_ts_valid),
    .s_axis_mac_tx_ptp_ts_ready(),

    .mac_tx_enable(mac_tx_enable),
    .mac_tx_status({PORT_COUNT{1'b1}}),
    .mac_tx_lfc_en(mac_tx_lfc_en),
    .mac_tx_lfc_req(mac_tx_lfc_req),
    .mac_tx_pfc_en(mac_tx_pfc_en),
    .mac_tx_pfc_req(mac_tx_pfc_req),

    .mac_rx_clk(mac_rx_clk),
    .mac_rx_rst(mac_rx_rst),

    .mac_rx_ptp_clk(mac_rx_ptp_clk),
    .mac_rx_ptp_rst(mac_rx_ptp_rst),
    .mac_rx_ptp_ts_96(mac_rx_ptp_time_int),
    .mac_rx_ptp_ts_step(),

    .s_axis_mac_rx_tdata(mac_rx_axis_tdata),
    .s_axis_mac_rx_tkeep(mac_rx_axis_tkeep),
    .s_axis_mac_rx_tvalid(mac_rx_axis_tvalid),
    .s_axis_mac_rx_tready(),
    .s_axis_mac_rx_tlast(mac_rx_axis_tlast),
    .s_axis_mac_rx_tuser(mac_rx_axis_tuser_int),

    .mac_rx_enable(mac_rx_enable),
    .mac_rx_status(mac_rx_status),
    .mac_rx_lfc_en(mac_rx_lfc_en),
    .mac_rx_lfc_req(mac_rx_lfc_req),
    .mac_rx_lfc_ack(mac_rx_lfc_ack),
    .mac_rx_pfc_en(mac_rx_pfc_en),
    .mac_rx_pfc_req(mac_rx_pfc_req),
    .mac_rx_pfc_ack(mac_rx_pfc_ack),

    .tx_clk(eth_tx_clk),
    .tx_rst(eth_tx_rst),

    .tx_ptp_clk(eth_tx_ptp_clk),
    .tx_ptp_rst(eth_tx_ptp_rst),
    .tx_ptp_ts_96(eth_tx_ptp_ts),
    .tx_ptp_ts_step(eth_tx_ptp_ts_step),

    .s_axis_tx_tdata(axis_eth_tx_tdata),
    .s_axis_tx_tkeep(axis_eth_tx_tkeep),
    .s_axis_tx_tvalid(axis_eth_tx_tvalid),
    .s_axis_tx_tready(axis_eth_tx_tready),
    .s_axis_tx_tlast(axis_eth_tx_tlast),
    .s_axis_tx_tuser(axis_eth_tx_tuser),

    .m_axis_tx_ptp_ts(axis_eth_tx_ptp_ts),
    .m_axis_tx_ptp_ts_tag(axis_eth_tx_ptp_ts_tag),
    .m_axis_tx_ptp_ts_valid(axis_eth_tx_ptp_ts_valid),
    .m_axis_tx_ptp_ts_ready(axis_eth_tx_ptp_ts_ready),

    .tx_enable(eth_tx_enable),
    .tx_status(eth_tx_status),
    .tx_lfc_en(eth_tx_lfc_en),
    .tx_lfc_req(eth_tx_lfc_req),
    .tx_pfc_en(eth_tx_pfc_en),
    .tx_pfc_req(eth_tx_pfc_req),

    .rx_clk(eth_rx_clk),
    .rx_rst(eth_rx_rst),

    .rx_ptp_clk(eth_rx_ptp_clk),
    .rx_ptp_rst(eth_rx_ptp_rst),
    .rx_ptp_ts_96(eth_rx_ptp_ts),
    .rx_ptp_ts_step(eth_rx_ptp_ts_step),

    .m_axis_rx_tdata(axis_eth_rx_tdata),
    .m_axis_rx_tkeep(axis_eth_rx_tkeep),
    .m_axis_rx_tvalid(axis_eth_rx_tvalid),
    .m_axis_rx_tready(axis_eth_rx_tready),
    .m_axis_rx_tlast(axis_eth_rx_tlast),
    .m_axis_rx_tuser(axis_eth_rx_tuser),

    .rx_enable(eth_rx_enable),
    .rx_status(eth_rx_status),
    .rx_lfc_en(eth_rx_lfc_en),
    .rx_lfc_req(eth_rx_lfc_req),
    .rx_lfc_ack(eth_rx_lfc_ack),
    .rx_pfc_en(eth_rx_pfc_en),
    .rx_pfc_req(eth_rx_pfc_req),
    .rx_pfc_ack(eth_rx_pfc_ack));

endmodule
