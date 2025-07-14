// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2025 Analog Devices, Inc. All rights reserved
 */
/*
 * This file repackages Corundum MQNIC Core AXI with the sole purpose of
 * providing it as an IP Core.
 * The original file can be refereed at:
 * https://github.com/ucsdsysnet/corundum/blob/master/fpga/common/rtl/mqnic_core_axi.v
 */

`timescale 1ns/100ps

module ethernet_k26 #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,
  parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF,

  parameter TDMA_BER_ENABLE = 0,

  parameter PTP_PEROUT_COUNT = 1,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,
  parameter PTP_TS_FMT_TOD = 1,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 64,
  parameter TX_TAG_WIDTH = 16,
  parameter PFC_ENABLE = 1,
  parameter LFC_ENABLE = PFC_ENABLE,
  parameter ENABLE_PADDING = 1,
  parameter ENABLE_DIC = 1,
  parameter MIN_FRAME_LENGTH = 64,

  parameter XGMII_DATA_WIDTH = 64,
  parameter XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8,
  parameter AXIS_DATA_WIDTH = XGMII_DATA_WIDTH,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,

  // AXI lite interface configuration (control)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),
  parameter AXIL_IF_CTRL_ADDR_WIDTH = AXIL_CTRL_ADDR_WIDTH-$clog2(IF_COUNT),
  parameter AXIL_CSR_ENABLE = 0,
  parameter AXIL_CSR_ADDR_WIDTH = AXIL_IF_CTRL_ADDR_WIDTH-5-$clog2((SCHED_PER_IF+4+7)/8),

  // Statistics counter subsystem
  parameter STAT_ENABLE = 0,
  parameter STAT_DMA_ENABLE = 1,
  parameter STAT_AXI_ENABLE = 1,
  parameter STAT_INC_WIDTH = 24,
  parameter STAT_ID_WIDTH = 12
) (
  /*
  *  Clock and reset
  */
  input  wire                                       clk,
  input  wire                                       rst,

  /*
   * GPIO
   */
  output wire [1:0]                                 led,
  output wire [1:0]                                 sfp_led,

  /*
   * Ethernet: SFP+
   */
  input  wire                                      sfp_rx_p,
  input  wire                                      sfp_rx_n,
  output wire                                      sfp_tx_p,
  output wire                                      sfp_tx_n,
  input  wire                                      sfp_mgt_refclk_p,
  input  wire                                      sfp_mgt_refclk_n,

  output wire                                      sfp_tx_disable,
  input  wire                                      sfp_tx_fault,
  input  wire                                      sfp_rx_los,
  input  wire                                      sfp_mod_abs,

  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]            ctrl_reg_wr_addr,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]           ctrl_reg_wr_data,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]           ctrl_reg_wr_strb,
  input  wire                                      ctrl_reg_wr_en,
  output wire                                      ctrl_reg_wr_wait,
  output wire                                      ctrl_reg_wr_ack,
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]            ctrl_reg_rd_addr,
  input  wire                                      ctrl_reg_rd_en,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]           ctrl_reg_rd_data,
  output wire                                      ctrl_reg_rd_wait,
  output wire                                      ctrl_reg_rd_ack,

  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]            s_axil_csr_awaddr,
  input  wire [2:0]                                s_axil_csr_awprot,
  input  wire                                      s_axil_csr_awvalid,
  output wire                                      s_axil_csr_awready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]           s_axil_csr_wdata,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]           s_axil_csr_wstrb,
  input  wire                                      s_axil_csr_wvalid,
  output wire                                      s_axil_csr_wready,
  output wire [1:0]                                s_axil_csr_bresp,
  output wire                                      s_axil_csr_bvalid,
  input  wire                                      s_axil_csr_bready,
  input  wire [AXIL_CSR_ADDR_WIDTH-1:0]            s_axil_csr_araddr,
  input  wire [2:0]                                s_axil_csr_arprot,
  input  wire                                      s_axil_csr_arvalid,
  output wire                                      s_axil_csr_arready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]           s_axil_csr_rdata,
  output wire [1:0]                                s_axil_csr_rresp,
  output wire                                      s_axil_csr_rvalid,
  input  wire                                      s_axil_csr_rready,

  /*
  * PTP setup
  */
  output wire                                      ptp_clk,
  output wire                                      ptp_rst,
  output wire                                      ptp_sample_clk,
  input  wire                                      ptp_td_sd,
  input  wire                                      ptp_pps,
  input  wire                                      ptp_pps_str,
  input  wire                                      ptp_sync_locked,
  input  wire [63:0]                               ptp_sync_ts_rel,
  input  wire                                      ptp_sync_ts_rel_step,
  input  wire [96:0]                               ptp_sync_ts_tod,
  input  wire                                      ptp_sync_ts_tod_step,
  input  wire                                      ptp_sync_pps,
  input  wire                                      ptp_sync_pps_str,
  input  wire [PTP_PEROUT_COUNT-1:0]               ptp_perout_locked,
  input  wire [PTP_PEROUT_COUNT-1:0]               ptp_perout_error,
  input  wire [PTP_PEROUT_COUNT-1:0]               ptp_perout_pulse,

  output wire [PORT_COUNT-1:0]                     eth_tx_clk,
  output wire [PORT_COUNT-1:0]                     eth_tx_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]        eth_tx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                     eth_tx_ptp_ts_step,

  output wire [PORT_COUNT-1:0]                     eth_rx_clk,
  output wire [PORT_COUNT-1:0]                     eth_rx_rst,
  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]        eth_rx_ptp_ts,
  input  wire [PORT_COUNT-1:0]                     eth_rx_ptp_ts_step,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]     axis_eth_tx_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]     axis_eth_tx_tkeep,
  input  wire [PORT_COUNT-1:0]                     axis_eth_tx_tvalid,
  output wire [PORT_COUNT-1:0]                     axis_eth_tx_tready,
  input  wire [PORT_COUNT-1:0]                     axis_eth_tx_tlast,
  input  wire [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0]  axis_eth_tx_tuser,

  output wire [PORT_COUNT*PTP_TS_WIDTH-1:0]        axis_eth_tx_ptp_ts,
  output wire [PORT_COUNT*TX_TAG_WIDTH-1:0]        axis_eth_tx_ptp_ts_tag,
  output wire [PORT_COUNT-1:0]                     axis_eth_tx_ptp_ts_valid,
  input  wire [PORT_COUNT-1:0]                     axis_eth_tx_ptp_ts_ready,

  input  wire [PORT_COUNT-1:0]                     eth_tx_enable,
  output wire [PORT_COUNT-1:0]                     eth_tx_status,
  input  wire [PORT_COUNT-1:0]                     eth_tx_lfc_en,
  input  wire [PORT_COUNT-1:0]                     eth_tx_lfc_req,
  input  wire [PORT_COUNT*8-1:0]                   eth_tx_pfc_en,
  input  wire [PORT_COUNT*8-1:0]                   eth_tx_pfc_req,
  output wire [PORT_COUNT*8-1:0]                   eth_tx_fc_quanta_clk_en,

  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]     axis_eth_rx_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]     axis_eth_rx_tkeep,
  output wire [PORT_COUNT-1:0]                     axis_eth_rx_tvalid,
  input  wire [PORT_COUNT-1:0]                     axis_eth_rx_tready,
  output wire [PORT_COUNT-1:0]                     axis_eth_rx_tlast,
  output wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0]  axis_eth_rx_tuser,

  input  wire [PORT_COUNT-1:0]                     eth_rx_enable,
  output wire [PORT_COUNT-1:0]                     eth_rx_status,
  input  wire [PORT_COUNT-1:0]                     eth_rx_lfc_en,
  output wire [PORT_COUNT-1:0]                     eth_rx_lfc_req,
  input  wire [PORT_COUNT-1:0]                     eth_rx_lfc_ack,
  input  wire [PORT_COUNT*8-1:0]                   eth_rx_pfc_en,
  output wire [PORT_COUNT*8-1:0]                   eth_rx_pfc_req,
  input  wire [PORT_COUNT*8-1:0]                   eth_rx_pfc_ack,
  output wire [PORT_COUNT-1:0]                     eth_rx_fc_quanta_clk_en,

  /*
  * Statistics increment input
  */
  output wire [STAT_INC_WIDTH-1:0]                 s_axis_stat_tdata,
  output wire [STAT_ID_WIDTH-1:0]                  s_axis_stat_tid,
  output wire                                      s_axis_stat_tvalid,
  input  wire                                      s_axis_stat_tready,

  input  wire                                      scl_i,
  output reg                                       scl_o,
  output reg                                       scl_t,
  input  wire                                      sda_i,
  output reg                                       sda_o,
  output reg                                       sda_t
);

  wire sfp_iic_scl_i_w;
  wire sfp_iic_scl_o_w;
  wire sfp_iic_scl_t_w;
  wire sfp_iic_sda_i_w;
  wire sfp_iic_sda_o_w;
  wire sfp_iic_sda_t_w;

  wire sfp_drp_clk;
  wire sfp_drp_rst;
  wire [23:0] sfp_drp_addr;
  wire [15:0] sfp_drp_di;
  wire sfp_drp_en;
  wire sfp_drp_we;
  wire [15:0] sfp_drp_do;
  wire sfp_drp_rdy;

  localparam RB_BASE_ADDR = 16'h1000;
  localparam RBB = RB_BASE_ADDR & {AXIL_CTRL_ADDR_WIDTH{1'b1}};

  localparam RB_DRP_SFP_BASE = RB_BASE_ADDR + 16'h20;

  reg sfp_iic_scl_o_reg = 1'b1;
  reg sfp_iic_sda_o_reg = 1'b1;

  always @(posedge clk) begin
    scl_o <= sfp_iic_scl_o_w;
    scl_t <= sfp_iic_scl_t_w;
    sda_o <= sfp_iic_sda_o_w;
    sda_t <= sfp_iic_sda_t_w;
  end

  assign sfp_iic_scl_o_w = sfp_iic_scl_o_reg;
  assign sfp_iic_scl_t_w = sfp_iic_scl_o_reg;
  assign sfp_iic_sda_o_w = sfp_iic_sda_o_reg;
  assign sfp_iic_sda_t_w = sfp_iic_sda_o_reg;

  wire clk_156mhz_int;

  wire clk_125mhz_mmcm_out;

  // Internal 125 MHz clock
  wire clk_125mhz_int;
  wire rst_125mhz_int;

  wire mmcm_rst = rst;
  wire mmcm_locked;
  wire mmcm_clkfb;

  assign  sfp_drp_clk = clk_125mhz_int;
  assign  sfp_drp_rst = rst_125mhz_int;

  wire sfp_rx_block_lock;
  wire sfp_gtpowergood;

  wire sfp_mgt_refclk;
  wire sfp_mgt_refclk_int;
  wire sfp_mgt_refclk_bufg;

  wire sfp_tx_clk_int;
  wire sfp_tx_rst_int;
  wire [63:0] sfp_txd_int;
  wire [7:0] sfp_txc_int;
  wire sfp_tx_prbs31_enable_int;
  wire sfp_rx_clk_int;
  wire sfp_rx_rst_int;
  wire [63:0] sfp_rxd_int;
  wire [7:0] sfp_rxc_int;
  wire sfp_rx_prbs31_enable_int;
  wire [6:0] sfp_rx_error_count_int;

  wire sfp_rx_status;

  wire sfp_rst;

  wire sfp_tx_fault_int;
  wire sfp_rx_los_int;
  wire sfp_mod_abs_int;

  sync_signal #(
    .WIDTH(5),
    .N(2)
  ) sync_signal_inst (
    .clk(clk),
    .in({sfp_tx_fault,      sfp_rx_los,     sfp_mod_abs,     scl_i,   sda_i}),
    .out({sfp_tx_fault_int, sfp_rx_los_int, sfp_mod_abs_int, sfp_iic_scl_i_w, sfp_iic_sda_i_w}));

  // MMCM instance
  // 156.25 MHz in, 125 MHz out
  // PFD range: 10 MHz to 500 MHz
  // VCO range: 800 MHz to 1600 MHz
  // M = 8, D = 1 sets Fvco = 1250 MHz
  // Divide by 10 to get output frequency of 125 MHz
  MMCME4_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKOUT0_DIVIDE_F(10),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT1_PHASE(0),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT2_PHASE(0),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT3_PHASE(0),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT4_PHASE(0),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT5_PHASE(0),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT6_PHASE(0),
    .CLKFBOUT_MULT_F(8),
    .CLKFBOUT_PHASE(0),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.010),
    .CLKIN1_PERIOD(6.4),
    .STARTUP_WAIT("FALSE"),
    .CLKOUT4_CASCADE("FALSE")
  ) clk_mmcm_inst (
    .CLKIN1(clk_156mhz_int),
    .CLKFBIN(mmcm_clkfb),
    .RST(mmcm_rst),
    .PWRDWN(1'b0),
    .CLKOUT0(clk_125mhz_mmcm_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(mmcm_clkfb),
    .CLKFBOUTB(),
    .LOCKED(mmcm_locked));

  BUFG #(
  ) clk_125mhz_bufg_inst (
    .I(clk_125mhz_mmcm_out),
    .O(clk_125mhz_int));

  sync_reset #(
    .N(4)
  ) sync_reset_125mhz_inst (
    .clk(clk_125mhz_int),
    .rst(~mmcm_locked),
    .out(rst_125mhz_int));

  IBUFDS_GTE4 #(
  ) ibufds_gte4_sfp_mgt_refclk_inst (
    .I     (sfp_mgt_refclk_p),
    .IB    (sfp_mgt_refclk_n),
    .CEB   (1'b0),
    .O     (sfp_mgt_refclk),
    .ODIV2 (sfp_mgt_refclk_int));

  BUFG_GT #(
  ) bufg_gt_sfp_mgt_refclk_inst (
    .CE      (sfp_gtpowergood),
    .CEMASK  (1'b1),
    .CLR     (1'b0),
    .CLRMASK (1'b1),
    .DIV     (3'd0),
    .I       (sfp_mgt_refclk_int),
    .O       (sfp_mgt_refclk_bufg));

  sync_reset #(
    .N(4)
  )
  sfp_sync_reset_inst (
    .clk(sfp_mgt_refclk_bufg),
    .rst(rst_125mhz_int),
    .out(sfp_rst));

  // TODO move out of the IP
  eth_xcvr_phy_10g_gty_quad_wrapper #(
    .COUNT(1),
    .GT_GTH(1),
    .PRBS31_ENABLE(1)
  ) sfp_phy_quad_inst (
    .xcvr_ctrl_clk(clk_125mhz_int),
    .xcvr_ctrl_rst(sfp_rst),

    /*
     * Common
     */
    .xcvr_gtpowergood_out(sfp_gtpowergood),
    .xcvr_gtrefclk00_in(sfp_mgt_refclk),
    .xcvr_qpll0pd_in(0),
    .xcvr_qpll0reset_in(0),
    .xcvr_qpll0pcierate_in(0),
    .xcvr_gtrefclk01_in(0),
    .xcvr_qpll1pd_in(0),
    .xcvr_qpll1reset_in(0),
    .xcvr_qpll1pcierate_in(0),

    /*
     * DRP
     */
    .drp_clk(sfp_drp_clk),
    .drp_rst(sfp_drp_rst),
    .drp_addr(sfp_drp_addr),
    .drp_di(sfp_drp_di),
    .drp_en(sfp_drp_en),
    .drp_we(sfp_drp_we),
    .drp_do(sfp_drp_do),
    .drp_rdy(sfp_drp_rdy),

    /*
     * Serial data
     */
    .xcvr_txp({sfp_tx_p}),
    .xcvr_txn({sfp_tx_n}),
    .xcvr_rxp({sfp_rx_p}),
    .xcvr_rxn({sfp_rx_n}),

    /*
     * PHY connections
     */
    .phy_1_tx_clk(sfp_tx_clk_int),
    .phy_1_tx_rst(sfp_tx_rst_int),
    .phy_1_xgmii_txd(sfp_txd_int),
    .phy_1_xgmii_txc(sfp_txc_int),
    .phy_1_rx_clk(sfp_rx_clk_int),
    .phy_1_rx_rst(sfp_rx_rst_int),
    .phy_1_xgmii_rxd(sfp_rxd_int),
    .phy_1_xgmii_rxc(sfp_rxc_int),
    .phy_1_tx_bad_block(),
    .phy_1_rx_error_count(sfp_rx_error_count_int),
    .phy_1_rx_bad_block(),
    .phy_1_rx_sequence_error(),
    .phy_1_rx_block_lock(sfp_rx_block_lock),
    .phy_1_rx_high_ber(),
    .phy_1_rx_status(sfp_rx_status),
    .phy_1_cfg_tx_prbs31_enable(sfp_tx_prbs31_enable_int),
    .phy_1_cfg_rx_prbs31_enable(sfp_rx_prbs31_enable_int));

  assign clk_156mhz_int = sfp_mgt_refclk_bufg;

  assign ptp_clk = sfp_mgt_refclk_bufg;
  assign ptp_rst = sfp_rst;
  assign ptp_sample_clk = clk_125mhz_int;

  assign sfp_led[0] = sfp_rx_status;
  assign sfp_led[1] = 1'b0;

  wire [PORT_COUNT-1:0]                   port_xgmii_tx_clk;
  wire [PORT_COUNT-1:0]                   port_xgmii_tx_rst;
  wire [PORT_COUNT*XGMII_DATA_WIDTH-1:0]  port_xgmii_txd;
  wire [PORT_COUNT*XGMII_CTRL_WIDTH-1:0]  port_xgmii_txc;

  wire [PORT_COUNT-1:0]                   port_xgmii_rx_clk;
  wire [PORT_COUNT-1:0]                   port_xgmii_rx_rst;
  wire [PORT_COUNT*XGMII_DATA_WIDTH-1:0]  port_xgmii_rxd;
  wire [PORT_COUNT*XGMII_CTRL_WIDTH-1:0]  port_xgmii_rxc;

  mqnic_port_map_phy_xgmii #(
    .PHY_COUNT(1),
    .PORT_MASK(PORT_MASK),
    .PORT_GROUP_SIZE(1),

    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),

    .PORT_COUNT(PORT_COUNT),

    .XGMII_DATA_WIDTH(XGMII_DATA_WIDTH),
    .XGMII_CTRL_WIDTH(XGMII_CTRL_WIDTH)
  )
  mqnic_port_map_phy_xgmii_inst (
    // towards PHY
    .phy_xgmii_tx_clk({sfp_tx_clk_int}),
    .phy_xgmii_tx_rst({sfp_tx_rst_int}),
    .phy_xgmii_txd({sfp_txd_int}),
    .phy_xgmii_txc({sfp_txc_int}),
    .phy_tx_status(1'b1),

    .phy_xgmii_rx_clk({sfp_rx_clk_int}),
    .phy_xgmii_rx_rst({sfp_rx_rst_int}),
    .phy_xgmii_rxd({sfp_rxd_int}),
    .phy_xgmii_rxc({sfp_rxc_int}),
    .phy_rx_status({sfp_rx_status}),

    // towards MAC
    .port_xgmii_tx_clk(port_xgmii_tx_clk),
    .port_xgmii_tx_rst(port_xgmii_tx_rst),
    .port_xgmii_txd(port_xgmii_txd),
    .port_xgmii_txc(port_xgmii_txc),
    .port_tx_status(eth_tx_status),

    .port_xgmii_rx_clk(port_xgmii_rx_clk),
    .port_xgmii_rx_rst(port_xgmii_rx_rst),
    .port_xgmii_rxd(port_xgmii_rxd),
    .port_xgmii_rxc(port_xgmii_rxc),
    .port_rx_status(eth_rx_status));

  generate
    genvar n;

    for (n = 0; n < PORT_COUNT; n = n + 1) begin : mac

      assign eth_tx_clk[n] = port_xgmii_tx_clk[n];
      assign eth_tx_rst[n] = port_xgmii_tx_rst[n];
      assign eth_rx_clk[n] = port_xgmii_rx_clk[n];
      assign eth_rx_rst[n] = port_xgmii_rx_rst[n];

      eth_mac_10g #(
        .DATA_WIDTH(AXIS_DATA_WIDTH),
        .KEEP_WIDTH(AXIS_KEEP_WIDTH),
        .ENABLE_PADDING(ENABLE_PADDING),
        .ENABLE_DIC(ENABLE_DIC),
        .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
        .PTP_TS_ENABLE(PTP_TS_ENABLE),
        .PTP_TS_FMT_TOD(PTP_TS_FMT_TOD),
        .PTP_TS_WIDTH(PTP_TS_WIDTH),
        .TX_PTP_TS_CTRL_IN_TUSER(0),
        .TX_PTP_TAG_ENABLE(PTP_TS_ENABLE),
        .TX_PTP_TAG_WIDTH(TX_TAG_WIDTH),
        .TX_USER_WIDTH(AXIS_TX_USER_WIDTH),
        .RX_USER_WIDTH(AXIS_RX_USER_WIDTH),
        .PFC_ENABLE(PFC_ENABLE),
        .PAUSE_ENABLE(LFC_ENABLE)
      ) eth_mac_inst (
        .tx_clk(port_xgmii_tx_clk[n]),
        .tx_rst(port_xgmii_tx_rst[n]),
        .rx_clk(port_xgmii_rx_clk[n]),
        .rx_rst(port_xgmii_rx_rst[n]),

        /*
         * AXI input
         */
        .tx_axis_tdata(axis_eth_tx_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .tx_axis_tkeep(axis_eth_tx_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .tx_axis_tvalid(axis_eth_tx_tvalid[n +: 1]),
        .tx_axis_tready(axis_eth_tx_tready[n +: 1]),
        .tx_axis_tlast(axis_eth_tx_tlast[n +: 1]),
        .tx_axis_tuser(axis_eth_tx_tuser[n*AXIS_TX_USER_WIDTH +: AXIS_TX_USER_WIDTH]),

        /*
         * AXI output
         */
        .rx_axis_tdata(axis_eth_rx_tdata[n*AXIS_DATA_WIDTH +: AXIS_DATA_WIDTH]),
        .rx_axis_tkeep(axis_eth_rx_tkeep[n*AXIS_KEEP_WIDTH +: AXIS_KEEP_WIDTH]),
        .rx_axis_tvalid(axis_eth_rx_tvalid[n +: 1]),
        .rx_axis_tlast(axis_eth_rx_tlast[n +: 1]),
        .rx_axis_tuser(axis_eth_rx_tuser[n*AXIS_RX_USER_WIDTH +: AXIS_RX_USER_WIDTH]),

        /*
         * XGMII interface
         */
        .xgmii_rxd(port_xgmii_rxd[n*XGMII_DATA_WIDTH +: XGMII_DATA_WIDTH]),
        .xgmii_rxc(port_xgmii_rxc[n*XGMII_CTRL_WIDTH +: XGMII_CTRL_WIDTH]),
        .xgmii_txd(port_xgmii_txd[n*XGMII_DATA_WIDTH +: XGMII_DATA_WIDTH]),
        .xgmii_txc(port_xgmii_txc[n*XGMII_CTRL_WIDTH +: XGMII_CTRL_WIDTH]),

        /*
         * PTP
         */
        .tx_ptp_ts(eth_tx_ptp_ts[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]),
        .rx_ptp_ts(eth_rx_ptp_ts[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]),
        .tx_axis_ptp_ts(axis_eth_tx_ptp_ts[n*PTP_TS_WIDTH +: PTP_TS_WIDTH]),
        .tx_axis_ptp_ts_tag(axis_eth_tx_ptp_ts_tag[n*TX_TAG_WIDTH +: TX_TAG_WIDTH]),
        .tx_axis_ptp_ts_valid(axis_eth_tx_ptp_ts_valid[n +: 1]),

        /*
         * Link-level Flow Control (LFC) (IEEE 802.3 annex 31B PAUSE)
         */
        .tx_lfc_req(eth_tx_lfc_req[n +: 1]),
        .tx_lfc_resend(1'b0),
        .rx_lfc_en(eth_rx_lfc_en[n +: 1]),
        .rx_lfc_req(eth_rx_lfc_req[n +: 1]),
        .rx_lfc_ack(eth_rx_lfc_ack[n +: 1]),

        /*
         * Priority Flow Control (PFC) (IEEE 802.3 annex 31D PFC)
         */
        .tx_pfc_req(eth_tx_pfc_req[n*8 +: 8]),
        .tx_pfc_resend(1'b0),
        .rx_pfc_en(eth_rx_pfc_en[n*8 +: 8]),
        .rx_pfc_req(eth_rx_pfc_req[n*8 +: 8]),
        .rx_pfc_ack(eth_rx_pfc_ack[n*8 +: 8]),

        /*
         * Pause interface
         */
        .tx_lfc_pause_en(1'b1),
        .tx_pause_req(1'b0),
        .tx_pause_ack(),

        /*
         * Status
         */
        .tx_start_packet(),
        .tx_error_underflow(),
        .rx_start_packet(),
        .rx_error_bad_frame(),
        .rx_error_bad_fcs(),
        .stat_tx_mcf(),
        .stat_rx_mcf(),
        .stat_tx_lfc_pkt(),
        .stat_tx_lfc_xon(),
        .stat_tx_lfc_xoff(),
        .stat_tx_lfc_paused(),
        .stat_tx_pfc_pkt(),
        .stat_tx_pfc_xon(),
        .stat_tx_pfc_xoff(),
        .stat_tx_pfc_paused(),
        .stat_rx_lfc_pkt(),
        .stat_rx_lfc_xon(),
        .stat_rx_lfc_xoff(),
        .stat_rx_lfc_paused(),
        .stat_rx_pfc_pkt(),
        .stat_rx_pfc_xon(),
        .stat_rx_pfc_xoff(),
        .stat_rx_pfc_paused(),

        /*
         * Configuration
         */
        .cfg_ifg(8'd12),
        .cfg_tx_enable(eth_tx_enable[n +: 1]),
        .cfg_rx_enable(eth_rx_enable[n +: 1]),
        .cfg_mcf_rx_eth_dst_mcast(48'h01_80_C2_00_00_01),
        .cfg_mcf_rx_check_eth_dst_mcast(1'b1),
        .cfg_mcf_rx_eth_dst_ucast(48'd0),
        .cfg_mcf_rx_check_eth_dst_ucast(1'b0),
        .cfg_mcf_rx_eth_src(48'd0),
        .cfg_mcf_rx_check_eth_src(1'b0),
        .cfg_mcf_rx_eth_type(16'h8808),
        .cfg_mcf_rx_opcode_lfc(16'h0001),
        .cfg_mcf_rx_check_opcode_lfc(eth_rx_lfc_en[n +: 1]),
        .cfg_mcf_rx_opcode_pfc(16'h0101),
        .cfg_mcf_rx_check_opcode_pfc(eth_rx_pfc_en[n*8 +: 8] != 0),
        .cfg_mcf_rx_forward(1'b0),
        .cfg_mcf_rx_enable(eth_rx_lfc_en[n +: 1] || eth_rx_pfc_en[n*8 +: 8]),
        .cfg_tx_lfc_eth_dst(48'h01_80_C2_00_00_01),
        .cfg_tx_lfc_eth_src(48'h80_23_31_43_54_4C),
        .cfg_tx_lfc_eth_type(16'h8808),
        .cfg_tx_lfc_opcode(16'h0001),
        .cfg_tx_lfc_en(eth_tx_lfc_en[n +: 1]),
        .cfg_tx_lfc_quanta(16'hffff),
        .cfg_tx_lfc_refresh(16'h7fff),
        .cfg_tx_pfc_eth_dst(48'h01_80_C2_00_00_01),
        .cfg_tx_pfc_eth_src(48'h80_23_31_43_54_4C),
        .cfg_tx_pfc_eth_type(16'h8808),
        .cfg_tx_pfc_opcode(16'h0101),
        .cfg_tx_pfc_en(eth_tx_pfc_en[n*8 +: 8] != 0),
        .cfg_tx_pfc_quanta({8{16'hffff}}),
        .cfg_tx_pfc_refresh({8{16'h7fff}}),
        .cfg_rx_lfc_opcode(16'h0001),
        .cfg_rx_lfc_en(eth_rx_lfc_en[n +: 1]),
        .cfg_rx_pfc_opcode(16'h0101),
        .cfg_rx_pfc_en(eth_rx_pfc_en[n*8 +: 8] != 0));
    end

  endgenerate

  generate

  if (TDMA_BER_ENABLE) begin

    // BER tester
    tdma_ber #(
      .COUNT(1),
      .INDEX_WIDTH(6),
      .SLICE_WIDTH(5),
      .AXIL_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
      .AXIL_ADDR_WIDTH(8+6+$clog2(1)),
      .AXIL_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),
      .SCHEDULE_START_S(0),
      .SCHEDULE_START_NS(0),
      .SCHEDULE_PERIOD_S(0),
      .SCHEDULE_PERIOD_NS(1000000),
      .TIMESLOT_PERIOD_S(0),
      .TIMESLOT_PERIOD_NS(100000),
      .ACTIVE_PERIOD_S(0),
      .ACTIVE_PERIOD_NS(90000)
    ) tdma_ber_inst (
      .clk(clk),
      .rst(rst),
      .phy_tx_clk({sfp_tx_clk_int}),
      .phy_rx_clk({sfp_rx_clk_int}),
      .phy_rx_error_count({sfp_rx_error_count_int}),
      .phy_cfg_tx_prbs31_enable({sfp_cfg_tx_prbs31_enable_int}),
      .phy_cfg_rx_prbs31_enable({sfp_cfg_rx_prbs31_enable_int}),
      .s_axil_awaddr(s_axil_csr_awaddr),
      .s_axil_awprot(s_axil_csr_awprot),
      .s_axil_awvalid(s_axil_csr_awvalid),
      .s_axil_awready(s_axil_csr_awready),
      .s_axil_wdata(s_axil_csr_wdata),
      .s_axil_wstrb(s_axil_csr_wstrb),
      .s_axil_wvalid(s_axil_csr_wvalid),
      .s_axil_wready(s_axil_csr_wready),
      .s_axil_bresp(s_axil_csr_bresp),
      .s_axil_bvalid(s_axil_csr_bvalid),
      .s_axil_bready(s_axil_csr_bready),
      .s_axil_araddr(s_axil_csr_araddr),
      .s_axil_arprot(s_axil_csr_arprot),
      .s_axil_arvalid(s_axil_csr_arvalid),
      .s_axil_arready(s_axil_csr_arready),
      .s_axil_rdata(s_axil_csr_rdata),
      .s_axil_rresp(s_axil_csr_rresp),
      .s_axil_rvalid(s_axil_csr_rvalid),
      .s_axil_rready(s_axil_csr_rready),
      .ptp_ts_96(ptp_sync_ts_tod),
      .ptp_ts_step(ptp_sync_ts_tod_step));

  end else begin

    assign sfp_cfg_tx_prbs31_enable = 1'b0;
    assign sfp_cfg_rx_prbs31_enable = 1'b0;

  end
  endgenerate

  wire sfp_drp_reg_wr_wait;
  wire sfp_drp_reg_wr_ack;
  wire [AXIL_CTRL_DATA_WIDTH-1:0] sfp_drp_reg_rd_data;
  wire sfp_drp_reg_rd_wait;
  wire sfp_drp_reg_rd_ack;

  reg ctrl_reg_wr_ack_reg = 1'b0;
  reg [AXIL_CTRL_DATA_WIDTH-1:0] ctrl_reg_rd_data_reg = {AXIL_CTRL_DATA_WIDTH{1'b0}};
  reg ctrl_reg_rd_ack_reg = 1'b0;

  reg sfp_tx_disable_reg = 1'b0;

  assign ctrl_reg_wr_wait = sfp_drp_reg_wr_wait;
  assign ctrl_reg_wr_ack = ctrl_reg_wr_ack_reg | sfp_drp_reg_wr_ack;
  assign ctrl_reg_rd_data = ctrl_reg_rd_data_reg | sfp_drp_reg_rd_data;
  assign ctrl_reg_rd_wait = sfp_drp_reg_rd_wait;
  assign ctrl_reg_rd_ack = ctrl_reg_rd_ack_reg | sfp_drp_reg_rd_ack;

  assign sfp_tx_disable = sfp_tx_disable_reg;

  always @(posedge clk) begin
    ctrl_reg_wr_ack_reg <= 1'b0;
    ctrl_reg_rd_data_reg <= {AXIL_CTRL_DATA_WIDTH{1'b0}};
    ctrl_reg_rd_ack_reg <= 1'b0;

    if (ctrl_reg_wr_en && !ctrl_reg_wr_ack_reg) begin
      // write operation
      ctrl_reg_wr_ack_reg <= 1'b0;
      case ({ctrl_reg_wr_addr >> 2, 2'b00})
        // I2C 0
        RBB+8'h0C: begin
          // I2C ctrl: control
          if (ctrl_reg_wr_strb[0]) begin
            sfp_iic_scl_o_reg <= ctrl_reg_wr_data[1];
          end
          if (ctrl_reg_wr_strb[1]) begin
            sfp_iic_sda_o_reg <= ctrl_reg_wr_data[9];
          end
        end
        // XCVR GPIO
        RBB+8'h1C: begin
          // XCVR GPIO: control 0123
          if (ctrl_reg_wr_strb[0]) begin
            sfp_tx_disable_reg <= ctrl_reg_wr_data[5];
          end
        end
          default: ctrl_reg_wr_ack_reg <= 1'b0;
      endcase
    end

    if (ctrl_reg_rd_en && !ctrl_reg_rd_ack_reg) begin
      // read operation
      ctrl_reg_rd_ack_reg <= 1'b1;
      case ({ctrl_reg_rd_addr >> 2, 2'b00})
        // I2C 0
        RBB+8'h00: ctrl_reg_rd_data_reg <= 32'h0000C110;             // I2C ctrl: Type
        RBB+8'h04: ctrl_reg_rd_data_reg <= 32'h00000100;             // I2C ctrl: Version
        RBB+8'h08: ctrl_reg_rd_data_reg <= RB_BASE_ADDR+8'h10;       // I2C ctrl: Next header
        RBB+8'h0C: begin
        // I2C ctrl: control
          ctrl_reg_rd_data_reg[0] <= sfp_iic_scl_i_w;
          ctrl_reg_rd_data_reg[1] <= sfp_iic_scl_o_reg;
          ctrl_reg_rd_data_reg[8] <= sfp_iic_sda_i_w;
          ctrl_reg_rd_data_reg[9] <= sfp_iic_sda_o_reg;
        end
        // XCVR GPIO
        RBB+8'h10: ctrl_reg_rd_data_reg <= 32'h0000C101;             // XCVR GPIO: Type
        RBB+8'h14: ctrl_reg_rd_data_reg <= 32'h00000100;             // XCVR GPIO: Version
        RBB+8'h18: ctrl_reg_rd_data_reg <= RB_DRP_SFP_BASE;          // XCVR GPIO: Next header
        RBB+8'h1C: begin
        // XCVR GPIO: control 0123
          ctrl_reg_rd_data_reg[0] <= !sfp_mod_abs_int;
          ctrl_reg_rd_data_reg[1] <= sfp_tx_fault_int;
          ctrl_reg_rd_data_reg[2] <= sfp_rx_los_int;
          ctrl_reg_rd_data_reg[5] <= sfp_tx_disable_reg;
        end
          default: ctrl_reg_rd_ack_reg <= 1'b0;
      endcase
    end

    if (rst) begin
      ctrl_reg_wr_ack_reg <= 1'b0;
      ctrl_reg_rd_ack_reg <= 1'b0;

      sfp_tx_disable_reg <= 1'b0;

      sfp_iic_scl_o_reg <= 1'b1;
      sfp_iic_sda_o_reg <= 1'b1;
    end
  end

  rb_drp #(
    .DRP_ADDR_WIDTH(24),
    .DRP_DATA_WIDTH(16),
    .DRP_INFO({8'h09, 8'h02, 8'd0, 8'd1}),
    .REG_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
    .REG_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
    .REG_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),
    .RB_BASE_ADDR(RB_DRP_SFP_BASE),
    .RB_NEXT_PTR(0)
  ) sfp_rb_drp_inst (
    .clk(clk),
    .rst(rst),

    /*
     * Register interface
     */
    .reg_wr_addr(ctrl_reg_wr_addr),
    .reg_wr_data(ctrl_reg_wr_data),
    .reg_wr_strb(ctrl_reg_wr_strb),
    .reg_wr_en(ctrl_reg_wr_en),
    .reg_wr_wait(sfp_drp_reg_wr_wait),
    .reg_wr_ack(sfp_drp_reg_wr_ack),
    .reg_rd_addr(ctrl_reg_rd_addr),
    .reg_rd_en(ctrl_reg_rd_en),
    .reg_rd_data(sfp_drp_reg_rd_data),
    .reg_rd_wait(sfp_drp_reg_rd_wait),
    .reg_rd_ack(sfp_drp_reg_rd_ack),

    /*
     * DRP
     */
    .drp_clk(sfp_drp_clk),
    .drp_rst(sfp_drp_rst),
    .drp_addr(sfp_drp_addr),
    .drp_di(sfp_drp_di),
    .drp_en(sfp_drp_en),
    .drp_we(sfp_drp_we),
    .drp_do(sfp_drp_do),
    .drp_rdy(sfp_drp_rdy));

endmodule
