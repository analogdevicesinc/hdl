// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2024 Analog Devices, Inc. All rights reserved
 */
/*
 * This file repackages Corundum MQNIC Core AXI with the sole purpose of
 * providing it as an IP Core.
 * The original file can be refereed at:
 * https://github.com/ucsdsysnet/corundum/blob/master/fpga/common/rtl/mqnic_core_axi.v
 */

`timescale 1ns/100ps

module ethernet_core #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,
  parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF,

  parameter XGMII_DATA_WIDTH = 64,
  parameter XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8,
  parameter AXIS_ETH_DATA_WIDTH = XGMII_DATA_WIDTH,
  parameter AXIS_ETH_KEEP_WIDTH = AXIS_ETH_DATA_WIDTH/8,
  parameter AXIS_ETH_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_ETH_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,

  // // Interrupts
  // parameter IRQ_COUNT = 32,
  // parameter IRQ_STRETCH = 10,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,
  parameter PTP_TS_FMT_TOD = 0,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 48,
  parameter TX_TAG_WIDTH = 16,
  parameter PFC_ENABLE = 1,
  parameter LFC_ENABLE = PFC_ENABLE,
  parameter ENABLE_PADDING = 1,
  parameter ENABLE_DIC = 1,
  parameter MIN_FRAME_LENGTH = 64

) (

  // Clock and reset
  input            clk,
  input      [0:0] rst,

  /*
   * GPIO
   */
  output     [1:0] led,
  output     [1:0] sfp_led,

  // // IRQ Output
  // output reg [IRQ_COUNT-1:0] core_irq,

  /*
   * Ethernet: SFP+
   */
  input            sfp_rx_p,
  input            sfp_rx_n,
  output           sfp_tx_p,
  output           sfp_tx_n,
  input            sfp_mgt_refclk_p,
  input            sfp_mgt_refclk_n,

  // input            sfp_tx_disable,
  input            sfp_tx_fault,
  input            sfp_rx_los,
  input            sfp_mod_abs,

  output           sfp_tx_fault_int,
  output           sfp_rx_los_int,
  output           sfp_mod_abs_int,


  // Ethernet SFP+ control
  output                                  sfp_tx_clk_int,
  // output                                  sfp_tx_rst_int,
  // input  [63:0]                           sfp_txd_int,
  // input  [7:0]                            sfp_txc_int,
  // input                                   sfp_tx_prbs31_enable_int,
  output                                  sfp_rx_clk_int,
  // output                                  sfp_rx_rst_int,
  // output   [63:0]                         sfp_rxd_int,
  // output   [7:0]                          sfp_rxc_int,
  // input                                   sfp_rx_prbs31_enable_int,
  output   [6:0]                          sfp_rx_error_count_int,


  output                                  sfp_drp_clk,
  output                                  sfp_drp_rst,
  input  [23:0]                           sfp_drp_addr,
  input  [15:0]                           sfp_drp_di,
  input                                   sfp_drp_en,
  input                                   sfp_drp_we,
  output   [15:0]                         sfp_drp_do,
  output                                  sfp_drp_rdy,

  // PTP setup

  output                                  ptp_clk,
  output                                  ptp_rst,
  output                                  ptp_sample_clk,
  // input                                   ptp_pps_str,

  // XGMII interface
  output [PORT_COUNT-1:0]                 eth_tx_clk,
  output [PORT_COUNT-1:0]                 eth_tx_rst,

  input [PORT_COUNT*PTP_TS_WIDTH-1:0]            eth_tx_ptp_ts,
  input [PORT_COUNT-1:0]                         eth_tx_ptp_ts_step,
  output [PORT_COUNT*PTP_TS_WIDTH-1:0]           eth_rx_ptp_ts,
  output [PORT_COUNT-1:0]                        eth_rx_ptp_ts_step,

  input [PORT_COUNT*AXIS_ETH_DATA_WIDTH-1:0]     axis_eth_tx_tdata,
  input [PORT_COUNT*AXIS_ETH_KEEP_WIDTH-1:0]     axis_eth_tx_tkeep,
  input [PORT_COUNT-1:0]                         axis_eth_tx_tvalid,
  output [PORT_COUNT-1:0]                        axis_eth_tx_tready,
  input [PORT_COUNT-1:0]                         axis_eth_tx_tlast,
  input [PORT_COUNT*AXIS_ETH_TX_USER_WIDTH-1:0]  axis_eth_tx_tuser,

  output [PORT_COUNT*PTP_TS_WIDTH-1:0]           axis_eth_tx_ptp_ts,
  output [PORT_COUNT*TX_TAG_WIDTH-1:0]           axis_eth_tx_ptp_ts_tag,
  output [PORT_COUNT-1:0]                        axis_eth_tx_ptp_ts_valid,
  input [PORT_COUNT-1:0]                         axis_eth_tx_ptp_ts_ready,

  input [PORT_COUNT-1:0]                         eth_tx_enable,
  output [PORT_COUNT-1:0]                        eth_tx_status,
  input [PORT_COUNT-1:0]                         eth_tx_lfc_en,
  input [PORT_COUNT-1:0]                         eth_tx_lfc_req,
  input [PORT_COUNT*8-1:0]                       eth_tx_pfc_en,
  input [PORT_COUNT*8-1:0]                       eth_tx_pfc_req,
  // output [PORT_COUNT*8-1:0]                      eth_tx_fc_quanta_clk_en,

  output [PORT_COUNT-1:0]                         eth_rx_clk,
  output [PORT_COUNT-1:0]                         eth_rx_rst,

  output [PORT_COUNT*AXIS_ETH_DATA_WIDTH-1:0]    axis_eth_rx_tdata,
  output [PORT_COUNT*AXIS_ETH_KEEP_WIDTH-1:0]    axis_eth_rx_tkeep,
  output [PORT_COUNT-1:0]                        axis_eth_rx_tvalid,
  input  [PORT_COUNT-1:0]                        axis_eth_rx_tready,
  output [PORT_COUNT-1:0]                        axis_eth_rx_tlast,
  output [PORT_COUNT*AXIS_ETH_RX_USER_WIDTH-1:0] axis_eth_rx_tuser,

  input  [PORT_COUNT-1:0]                        eth_rx_enable,
  output [PORT_COUNT-1:0]                        eth_rx_status,
  input  [PORT_COUNT-1:0]                        eth_rx_lfc_en,
  output [PORT_COUNT-1:0]                        eth_rx_lfc_req,
  input  [PORT_COUNT-1:0]                        eth_rx_lfc_ack,
  input  [PORT_COUNT*8-1:0]                      eth_rx_pfc_en,
  output [PORT_COUNT*8-1:0]                      eth_rx_pfc_req,
  input  [PORT_COUNT*8-1:0]                      eth_rx_pfc_ack,

  inout            sfp_i2c_scl,
  inout            sfp_i2c_sda,
  
  output           sfp_iic_scl_i_w,
  input            sfp_iic_scl_o_w,
  input            sfp_iic_scl_t_w,
  output           sfp_iic_sda_i_w,
  input            sfp_iic_sda_o_w,
  input            sfp_iic_sda_t_w
);

  // Ethernet interface configuration
  // localparam XGMII_DATA_WIDTH = 64;
  // localparam XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8;

  // localparam PORT_COUNT = IF_COUNT*PORTS_PER_IF;

  // wire sfp_iic_scl_i_w;
  // wire sfp_iic_scl_o_w;
  // wire sfp_iic_scl_t_w;
  // wire sfp_iic_sda_i_w;
  // wire sfp_iic_sda_o_w;
  // wire sfp_iic_sda_t_w;

  reg sfp_i2c_scl_o_reg;
  reg sfp_i2c_scl_t_reg;
  reg sfp_i2c_sda_o_reg;
  reg sfp_i2c_sda_t_reg;

  always @(posedge clk) begin
      sfp_i2c_scl_o_reg <= sfp_iic_scl_o_w;
      sfp_i2c_scl_t_reg <= sfp_iic_scl_t_w;
      sfp_i2c_sda_o_reg <= sfp_iic_sda_o_w;
      sfp_i2c_sda_t_reg <= sfp_iic_sda_t_w;
  end

  //  reg [(IRQ_COUNT*IRQ_STRETCH)-1:0] irq_stretch = {(IRQ_COUNT*IRQ_STRETCH){1'b0}};

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

  wire sfp_tx_rst_int;
  wire [63:0] sfp_txd_int;
  wire [7:0] sfp_txc_int;
  wire sfp_tx_prbs31_enable_int;
  wire sfp_rx_rst_int;
  wire [63:0] sfp_rxd_int;
  wire [7:0] sfp_rxc_int;
  wire sfp_rx_prbs31_enable_int;

  wire sfp_rx_status;

  wire sfp_rst;

  sync_signal #(
    .WIDTH(5),
    .N(2)
  ) sync_signal_inst (
    .clk(clk),
    .in({sfp_tx_fault,      sfp_rx_los,     sfp_mod_abs,     sfp_i2c_scl,   sfp_i2c_sda}),
    .out({sfp_tx_fault_int, sfp_rx_los_int, sfp_mod_abs_int, sfp_iic_scl_i_w, sfp_iic_sda_i_w})
  );

  assign sfp_i2c_scl = sfp_i2c_scl_t_reg ? 1'bz : sfp_i2c_scl_o_reg;
  assign sfp_i2c_sda = sfp_i2c_sda_t_reg ? 1'bz : sfp_i2c_sda_o_reg;

  // always @(posedge clk) begin
  //   if (rst) begin
  //     irq_stretch <= {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
  //   end else begin
  //     /* IRQ shift vector */
  //     irq_stretch <= {irq_stretch[0 +: (IRQ_COUNT*IRQ_STRETCH)-IRQ_COUNT], irq};
  //   end
  // end

  // integer i, k;
  // always @* begin
  //   for (k = 0; k < IRQ_COUNT; k = k + 1) begin
  //     core_irq[k] = 1'b0;
  //     for (i = 0; i < (IRQ_COUNT*IRQ_STRETCH); i = i + IRQ_COUNT) begin
  //       core_irq[k] = core_irq[k] | irq_stretch[k + i];
  //     end
  //   end
  // end

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
    .LOCKED(mmcm_locked)
  );

  BUFG #(
  ) clk_125mhz_bufg_inst (
    .I(clk_125mhz_mmcm_out),
    .O(clk_125mhz_int)
  );

  sync_reset #(
    .N(4)
  ) sync_reset_125mhz_inst (
    .clk(clk_125mhz_int),
    .rst(~mmcm_locked),
    .out(rst_125mhz_int)
  );

  IBUFDS_GTE4 #(
  ) ibufds_gte4_sfp_mgt_refclk_inst (
    .I     (sfp_mgt_refclk_p),
    .IB    (sfp_mgt_refclk_n),
    .CEB   (1'b0),
    .O     (sfp_mgt_refclk),
    .ODIV2 (sfp_mgt_refclk_int)
  );

  BUFG_GT #(
  ) bufg_gt_sfp_mgt_refclk_inst (
    .CE      (sfp_gtpowergood),
    .CEMASK  (1'b1),
    .CLR     (1'b0),
    .CLRMASK (1'b1),
    .DIV     (3'd0),
    .I       (sfp_mgt_refclk_int),
    .O       (sfp_mgt_refclk_bufg)
  );


  sync_reset #(
    .N(4)
  )
  sfp_sync_reset_inst (
    .clk(sfp_mgt_refclk_bufg),
    .rst(rst_125mhz_int),
    .out(sfp_rst)
  );

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
    // .xcvr_ref_clk(sfp_mgt_refclk),
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
    .phy_1_cfg_rx_prbs31_enable(sfp_rx_prbs31_enable_int)
  );

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
    .port_rx_status(eth_rx_status)
);

  generate
    genvar n;

    for (n = 0; n < PORT_COUNT; n = n + 1) begin : mac

        assign eth_tx_clk[n] = port_xgmii_tx_clk[n];
        assign eth_tx_rst[n] = port_xgmii_tx_rst[n];
        assign eth_rx_clk[n] = port_xgmii_rx_clk[n];
        assign eth_rx_rst[n] = port_xgmii_rx_rst[n];

        eth_mac_10g #(
            .DATA_WIDTH(AXIS_ETH_DATA_WIDTH),
            .KEEP_WIDTH(AXIS_ETH_KEEP_WIDTH),
            .ENABLE_PADDING(ENABLE_PADDING),
            .ENABLE_DIC(ENABLE_DIC),
            .MIN_FRAME_LENGTH(MIN_FRAME_LENGTH),
            .PTP_TS_ENABLE(PTP_TS_ENABLE),
            .PTP_TS_FMT_TOD(PTP_TS_FMT_TOD),
            .PTP_TS_WIDTH(PTP_TS_WIDTH),
            .TX_PTP_TS_CTRL_IN_TUSER(0),
            .TX_PTP_TAG_ENABLE(PTP_TS_ENABLE),
            .TX_PTP_TAG_WIDTH(TX_TAG_WIDTH),
            .TX_USER_WIDTH(AXIS_ETH_TX_USER_WIDTH),
            .RX_USER_WIDTH(AXIS_ETH_RX_USER_WIDTH),
            .PFC_ENABLE(PFC_ENABLE),
            .PAUSE_ENABLE(LFC_ENABLE)
        )
        eth_mac_inst (
            .tx_clk(port_xgmii_tx_clk[n]),
            .tx_rst(port_xgmii_tx_rst[n]),
            .rx_clk(port_xgmii_rx_clk[n]),
            .rx_rst(port_xgmii_rx_rst[n]),

            /*
             * AXI input
             */
            .tx_axis_tdata(axis_eth_tx_tdata[n*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .tx_axis_tkeep(axis_eth_tx_tkeep[n*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .tx_axis_tvalid(axis_eth_tx_tvalid[n +: 1]),
            .tx_axis_tready(axis_eth_tx_tready[n +: 1]),
            .tx_axis_tlast(axis_eth_tx_tlast[n +: 1]),
            .tx_axis_tuser(axis_eth_tx_tuser[n*AXIS_ETH_TX_USER_WIDTH +: AXIS_ETH_TX_USER_WIDTH]),

            /*
             * AXI output
             */
            .rx_axis_tdata(axis_eth_rx_tdata[n*AXIS_ETH_DATA_WIDTH +: AXIS_ETH_DATA_WIDTH]),
            .rx_axis_tkeep(axis_eth_rx_tkeep[n*AXIS_ETH_KEEP_WIDTH +: AXIS_ETH_KEEP_WIDTH]),
            .rx_axis_tvalid(axis_eth_rx_tvalid[n +: 1]),
            .rx_axis_tlast(axis_eth_rx_tlast[n +: 1]),
            .rx_axis_tuser(axis_eth_rx_tuser[n*AXIS_ETH_RX_USER_WIDTH +: AXIS_ETH_RX_USER_WIDTH]),

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
            .cfg_rx_pfc_en(eth_rx_pfc_en[n*8 +: 8] != 0)
        );

    end

  endgenerate

endmodule
