// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2024 Analog Devices, Inc. All rights reserved
 */
/*
 * This file repackages Corundum KR260 system top with the sole purpose of
 * providing it as an IP Core.
 * The original file can be refereed at:
 * https://github.com/corundum/corundum/blob/ed4a26e2cbc0a429c45d5cd5ddf1177f86838914/fpga/mqnic/KR260/fpga/rtl/fpga.v
 */

`timescale 1ns/100ps

module corundum #(
  // FW and board IDs
  parameter FPGA_ID = 32'h4A49093,
  parameter FW_ID = 32'h00000000,
  parameter FW_VER = 32'h00_00_01_00,
  parameter BOARD_ID = 32'h10ee_9104,
  parameter BOARD_VER = 32'h01_00_00_00,
  parameter BUILD_DATE = 32'd602976000,
  parameter GIT_HASH = 32'hdce357bf,
  parameter RELEASE_INFO = 32'h00000000,

  // Board configuration
  parameter TDMA_BER_ENABLE = 0,

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,

  // Clock configuration
  parameter CLK_PERIOD_NS_NUM = 4,
  parameter CLK_PERIOD_NS_DENOM = 1,

  // PTP configuration
  parameter PTP_CLOCK_PIPELINE = 0,
  parameter PTP_CLOCK_CDC_PIPELINE = 0,
  parameter PTP_PORT_CDC_PIPELINE = 0,
  parameter PTP_PEROUT_ENABLE = 1,
  parameter PTP_PEROUT_COUNT = 1,

  // Queue manager configuration
  parameter EVENT_QUEUE_OP_TABLE_SIZE = 32,
  parameter TX_QUEUE_OP_TABLE_SIZE = 32,
  parameter RX_QUEUE_OP_TABLE_SIZE = 32,
  parameter CQ_OP_TABLE_SIZE = 32,
  parameter EQN_WIDTH = 5,
  parameter TX_QUEUE_INDEX_WIDTH = 13,
  parameter RX_QUEUE_INDEX_WIDTH = 8,
  parameter CQN_WIDTH = (TX_QUEUE_INDEX_WIDTH > RX_QUEUE_INDEX_WIDTH ? TX_QUEUE_INDEX_WIDTH : RX_QUEUE_INDEX_WIDTH) + 1,
  parameter EQ_PIPELINE = 3,
  parameter TX_QUEUE_PIPELINE = 3+(TX_QUEUE_INDEX_WIDTH > 12 ? TX_QUEUE_INDEX_WIDTH-12 : 0),
  parameter RX_QUEUE_PIPELINE = 3+(RX_QUEUE_INDEX_WIDTH > 12 ? RX_QUEUE_INDEX_WIDTH-12 : 0),
  parameter CQ_PIPELINE = 3+(CQN_WIDTH > 12 ? CQN_WIDTH-12 : 0),

  // TX and RX engine configuration
  parameter TX_DESC_TABLE_SIZE = 32,
  parameter RX_DESC_TABLE_SIZE = 32,
  parameter RX_INDIR_TBL_ADDR_WIDTH = RX_QUEUE_INDEX_WIDTH > 8 ? 8 : RX_QUEUE_INDEX_WIDTH,

  // Scheduler configuration
  parameter TX_SCHEDULER_OP_TABLE_SIZE = TX_DESC_TABLE_SIZE,
  parameter TX_SCHEDULER_PIPELINE = TX_QUEUE_PIPELINE,
  parameter TDMA_INDEX_WIDTH = 6,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,
  parameter TX_CPL_FIFO_DEPTH = 32,
  parameter TX_CHECKSUM_ENABLE = 1,
  parameter RX_HASH_ENABLE = 1,
  parameter RX_CHECKSUM_ENABLE = 1,
  parameter TX_FIFO_DEPTH = 16384,
  parameter RX_FIFO_DEPTH = 16384,
  parameter MAX_TX_SIZE = 9214,
  parameter MAX_RX_SIZE = 9214,
  parameter TX_RAM_SIZE = 16384,
  parameter RX_RAM_SIZE = 16384,

  // Application block configuration
  parameter APP_ID = 32'h00000000,
  parameter APP_ENABLE = 0,
  parameter APP_CTRL_ENABLE = 1,
  parameter APP_DMA_ENABLE = 1,
  parameter APP_AXIS_DIRECT_ENABLE = 1,
  parameter APP_AXIS_SYNC_ENABLE = 1,
  parameter APP_AXIS_IF_ENABLE = 1,
  parameter APP_STAT_ENABLE = 1,

  // AXI interface configuration (DMA)
  parameter AXI_DATA_WIDTH = 128,
  parameter AXI_ADDR_WIDTH = 32,
  parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8),
  parameter AXI_ID_WIDTH = 8,

  // DMA interface configuration
  parameter DMA_IMM_ENABLE = 0,
  parameter DMA_IMM_WIDTH = 32,
  parameter DMA_LEN_WIDTH = 16,
  parameter DMA_TAG_WIDTH = 16,
  parameter RAM_ADDR_WIDTH = $clog2(TX_RAM_SIZE > RX_RAM_SIZE ? TX_RAM_SIZE : RX_RAM_SIZE),
  parameter RAM_PIPELINE = 2,
  parameter AXI_DMA_MAX_BURST_LEN = 256,

  // Interrupts
  parameter IRQ_COUNT = 32,
  parameter IRQ_STRETCH = 10,

  // AXI lite interface configuration (control)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  // AXI lite interface configuration (application control)
  parameter AXIL_APP_CTRL_DATA_WIDTH = AXIL_CTRL_DATA_WIDTH,
  parameter AXIL_APP_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_APP_CTRL_STRB_WIDTH = (AXIL_APP_CTRL_DATA_WIDTH/8),

  // Ethernet interface configuration
  parameter AXIS_ETH_TX_PIPELINE = 0,
  parameter AXIS_ETH_TX_FIFO_PIPELINE = 2,
  parameter AXIS_ETH_TX_TS_PIPELINE = 0,
  parameter AXIS_ETH_RX_PIPELINE = 0,
  parameter AXIS_ETH_RX_FIFO_PIPELINE = 2,

  // Statistics counter subsystem
  parameter STAT_ENABLE = 1,
  parameter STAT_DMA_ENABLE = 1,
  parameter STAT_AXI_ENABLE = 1,
  parameter STAT_INC_WIDTH = 24,
  parameter STAT_ID_WIDTH = 12
) (
  // Clock and reset
  input            clk,
  input      [0:0] rst,

  output reg [IRQ_COUNT-1:0] core_irq,

  // AXI lite connections

  input  [AXIL_CTRL_ADDR_WIDTH-1:0] s_axil_ctrl_araddr,
  input  [2:0]                      s_axil_ctrl_arprot,
  output [0:0]                      s_axil_ctrl_arready,
  input  [0:0]                      s_axil_ctrl_arvalid,
  input  [AXIL_CTRL_ADDR_WIDTH-1:0] s_axil_ctrl_awaddr,
  input  [2:0]                      s_axil_ctrl_awprot,
  output [0:0]                      s_axil_ctrl_awready,
  input  [0:0]                      s_axil_ctrl_awvalid,
  input  [0:0]                      s_axil_ctrl_bready,
  output [1:0]                      s_axil_ctrl_bresp,
  output [0:0]                      s_axil_ctrl_bvalid,
  output [AXIL_CTRL_DATA_WIDTH-1:0] s_axil_ctrl_rdata,
  input  [0:0]                      s_axil_ctrl_rready,
  output [1:0]                      s_axil_ctrl_rresp,
  output [0:0]                      s_axil_ctrl_rvalid,
  input  [AXIL_CTRL_DATA_WIDTH-1:0] s_axil_ctrl_wdata,
  output [0:0]                      s_axil_ctrl_wready,
  input  [AXIL_CTRL_STRB_WIDTH-1:0] s_axil_ctrl_wstrb,
  input  [0:0]                      s_axil_ctrl_wvalid,

  input  [AXIL_APP_CTRL_ADDR_WIDTH-1:0] s_axil_app_ctrl_araddr,
  input  [2:0]                          s_axil_app_ctrl_arprot,
  output [0:0]                          s_axil_app_ctrl_arready,
  input  [0:0]                          s_axil_app_ctrl_arvalid,
  input  [AXIL_APP_CTRL_ADDR_WIDTH-1:0] s_axil_app_ctrl_awaddr,
  input  [2:0]                          s_axil_app_ctrl_awprot,
  output [0:0]                          s_axil_app_ctrl_awready,
  input  [0:0]                          s_axil_app_ctrl_awvalid,
  input  [0:0]                          s_axil_app_ctrl_bready,
  output [1:0]                          s_axil_app_ctrl_bresp,
  output [0:0]                          s_axil_app_ctrl_bvalid,
  output [AXIL_APP_CTRL_DATA_WIDTH-1:0] s_axil_app_ctrl_rdata,
  input  [0:0]                          s_axil_app_ctrl_rready,
  output [1:0]                          s_axil_app_ctrl_rresp,
  output [0:0]                          s_axil_app_ctrl_rvalid,
  input  [AXIL_APP_CTRL_DATA_WIDTH-1:0] s_axil_app_ctrl_wdata,
  output [0:0]                          s_axil_app_ctrl_wready,
  input  [AXIL_APP_CTRL_STRB_WIDTH-1:0] s_axil_app_ctrl_wstrb,
  input  [0:0]                          s_axil_app_ctrl_wvalid,

  // Zynq AXI MM

  output [AXI_ADDR_WIDTH-1:0] m_axi_dma_araddr,
  output [1:0]                m_axi_dma_arburst,
  output [3:0]                m_axi_dma_arcache,
  output [AXI_ID_WIDTH-1:0]   m_axi_dma_arid,
  output [7:0]                m_axi_dma_arlen,
  output                      m_axi_dma_arlock,
  output [2:0]                m_axi_dma_arprot,
  output [3:0]                m_axi_dma_arqos,
  input                       m_axi_dma_arready,
  output [2:0]                m_axi_dma_arsize,
  output                      m_axi_dma_aruser,
  output                      m_axi_dma_arvalid,
  output [AXI_ADDR_WIDTH-1:0] m_axi_dma_awaddr,
  output [1:0]                m_axi_dma_awburst,
  output [3:0]                m_axi_dma_awcache,
  output [AXI_ID_WIDTH-1:0]   m_axi_dma_awid,
  output [7:0]                m_axi_dma_awlen,
  output                      m_axi_dma_awlock,
  output [2:0]                m_axi_dma_awprot,
  output [3:0]                m_axi_dma_awqos,
  input                       m_axi_dma_awready,
  output [2:0]                m_axi_dma_awsize,
  output                      m_axi_dma_awuser,
  output                      m_axi_dma_awvalid,
  input  [AXI_ID_WIDTH-1:0]   m_axi_dma_bid,
  output                      m_axi_dma_bready,
  input  [1:0]                m_axi_dma_bresp,
  input                       m_axi_dma_bvalid,
  input  [AXI_DATA_WIDTH-1:0] m_axi_dma_rdata,
  input  [AXI_ID_WIDTH-1:0]   m_axi_dma_rid,
  input                       m_axi_dma_rlast,
  output                      m_axi_dma_rready,
  input  [1:0]                m_axi_dma_rresp,
  input                       m_axi_dma_rvalid,
  output [AXI_DATA_WIDTH-1:0] m_axi_dma_wdata,
  output                      m_axi_dma_wlast,
  input                       m_axi_dma_wready,
  output [AXI_STRB_WIDTH-1:0] m_axi_dma_wstrb,
  output                      m_axi_dma_wvalid,
  /*
   * GPIO
   */
  output     [1:0] led,
  output     [1:0] sfp_led,

  /*
   * Ether net: SFP+
   */
  input            sfp_rx_p,
  input            sfp_rx_n,
  output           sfp_tx_p,
  output           sfp_tx_n,
  input            sfp_mgt_refclk_p,
  input            sfp_mgt_refclk_n,

  output           sfp_tx_disable,
  input            sfp_tx_fault,
  input            sfp_rx_los,
  input            sfp_mod_abs,

  input            scl_i,
  output reg       scl_o,
  output reg       scl_t,
  input            sda_i,
  output reg       sda_o,
  output reg       sda_t
);

  // PTP configuration
  localparam PTP_CLK_PERIOD_NS_NUM = 32;
  localparam PTP_CLK_PERIOD_NS_DENOM = 5;
  localparam PTP_TS_WIDTH = 96;
  localparam PTP_USE_SAMPLE_CLOCK = 1;
  localparam IF_PTP_PERIOD_NS = 6'h6;
  localparam IF_PTP_PERIOD_FNS = 16'h6666;

  // Interface configuration
  localparam TX_TAG_WIDTH = 16;

  // Ethernet interface configuration
  localparam XGMII_DATA_WIDTH = 64;
  localparam XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8;
  localparam AXIS_ETH_DATA_WIDTH = XGMII_DATA_WIDTH;
  localparam AXIS_ETH_KEEP_WIDTH = AXIS_ETH_DATA_WIDTH/8;
  localparam AXIS_ETH_SYNC_DATA_WIDTH = AXIS_ETH_DATA_WIDTH;
  localparam AXIS_ETH_TX_USER_WIDTH = TX_TAG_WIDTH + 1;
  localparam AXIS_ETH_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1;

  wire sfp_iic_scl_i_w;
  wire sfp_iic_scl_o_w;
  wire sfp_iic_scl_t_w;
  wire sfp_iic_sda_i_w;
  wire sfp_iic_sda_o_w;
  wire sfp_iic_sda_t_w;

  always @(posedge clk) begin
      scl_o <= sfp_iic_scl_o_w;
      scl_t <= sfp_iic_scl_t_w;
      sda_o <= sfp_iic_sda_o_w;
      sda_t <= sfp_iic_sda_t_w;
  end

  reg [(IRQ_COUNT*IRQ_STRETCH)-1:0] irq_stretch = {(IRQ_COUNT*IRQ_STRETCH){1'b0}};

  wire clk_156mhz_int;

  wire clk_125mhz_mmcm_out;

  // Internal 125 MHz clock
  wire clk_125mhz_int;
  wire rst_125mhz_int;

  wire mmcm_rst = rst;
  wire mmcm_locked;
  wire mmcm_clkfb;

  // GPIO
  wire sfp_tx_fault_int;
  wire sfp_rx_los_int;
  wire sfp_mod_abs_int;

  wire [IRQ_COUNT-1:0] irq;

  // XGMII 10G PHY
  wire                         sfp_tx_clk_int;
  wire                         sfp_tx_rst_int;
  wire [XGMII_DATA_WIDTH-1:0]  sfp_txd_int;
  wire [XGMII_CTRL_WIDTH-1:0]  sfp_txc_int;
  wire                         sfp_tx_prbs31_enable_int;
  wire                         sfp_rx_clk_int;
  wire                         sfp_rx_rst_int;
  wire [XGMII_DATA_WIDTH-1:0]  sfp_rxd_int;
  wire [XGMII_CTRL_WIDTH-1:0]  sfp_rxc_int;
  wire                         sfp_rx_prbs31_enable_int;
  wire [6:0]                   sfp_rx_error_count_int;

  wire        sfp_drp_clk = clk_125mhz_int;
  wire        sfp_drp_rst = rst_125mhz_int;
  wire [23:0] sfp_drp_addr;
  wire [15:0] sfp_drp_di;
  wire        sfp_drp_en;
  wire        sfp_drp_we;
  wire [15:0] sfp_drp_do;
  wire        sfp_drp_rdy;

  wire sfp_rx_block_lock;
  wire sfp_rx_status;
  wire sfp_gtpowergood;

  wire sfp_mgt_refclk;
  wire sfp_mgt_refclk_int;
  wire sfp_mgt_refclk_bufg;

  wire sfp_rst;

  wire ptp_clk;
  wire ptp_rst;
  wire ptp_sample_clk;

  sync_signal #(
    .WIDTH(5),
    .N(2)
  ) sync_signal_inst (
    .clk(clk),
    .in({sfp_tx_fault,      sfp_rx_los,     sfp_mod_abs,     scl_i,   sda_i}),
    .out({sfp_tx_fault_int, sfp_rx_los_int, sfp_mod_abs_int, sfp_iic_scl_i_w, sfp_iic_sda_i_w})
  );

  always @(posedge clk) begin
    if (rst) begin
      irq_stretch <= {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
    end else begin
      /* IRQ shift vector */
      irq_stretch <= {irq_stretch[0 +: (IRQ_COUNT*IRQ_STRETCH)-IRQ_COUNT], irq};
    end
  end

  integer i, k;
  always @* begin
    for (k = 0; k < IRQ_COUNT; k = k + 1) begin
      core_irq[k] = 1'b0;
      for (i = 0; i < (IRQ_COUNT*IRQ_STRETCH); i = i + IRQ_COUNT) begin
        core_irq[k] = core_irq[k] | irq_stretch[k + i];
      end
    end
  end

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
    .xcvr_ref_clk(sfp_mgt_refclk),

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
    .phy_1_tx_prbs31_enable(sfp_tx_prbs31_enable_int),
    .phy_1_rx_prbs31_enable(sfp_rx_prbs31_enable_int)
  );

  fpga_core #(
    // FW and board IDs
    .FPGA_ID(FPGA_ID),
    .FW_ID(FW_ID),
    .FW_VER(FW_VER),
    .BOARD_ID(BOARD_ID),
    .BOARD_VER(BOARD_VER),
    .BUILD_DATE(BUILD_DATE),
    .GIT_HASH(GIT_HASH),
    .RELEASE_INFO(RELEASE_INFO),

    // Board configuration
    .TDMA_BER_ENABLE(TDMA_BER_ENABLE),

    // Structural configuration
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .SCHED_PER_IF(SCHED_PER_IF),
    .PORT_MASK(PORT_MASK),

    // Clock configuration
    .CLK_PERIOD_NS_NUM(CLK_PERIOD_NS_NUM),
    .CLK_PERIOD_NS_DENOM(CLK_PERIOD_NS_DENOM),

    // PTP configuration
    .PTP_CLK_PERIOD_NS_NUM(PTP_CLK_PERIOD_NS_NUM),
    .PTP_CLK_PERIOD_NS_DENOM(PTP_CLK_PERIOD_NS_DENOM),
    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .PTP_CLOCK_PIPELINE(PTP_CLOCK_PIPELINE),
    .PTP_CLOCK_CDC_PIPELINE(PTP_CLOCK_CDC_PIPELINE),
    .PTP_USE_SAMPLE_CLOCK(PTP_USE_SAMPLE_CLOCK),
    .PTP_PORT_CDC_PIPELINE(PTP_PORT_CDC_PIPELINE),
    .PTP_PEROUT_ENABLE(PTP_PEROUT_ENABLE),
    .PTP_PEROUT_COUNT(PTP_PEROUT_COUNT),

    // Queue manager configuration
    .EVENT_QUEUE_OP_TABLE_SIZE(EVENT_QUEUE_OP_TABLE_SIZE),
    .TX_QUEUE_OP_TABLE_SIZE(TX_QUEUE_OP_TABLE_SIZE),
    .RX_QUEUE_OP_TABLE_SIZE(RX_QUEUE_OP_TABLE_SIZE),
    .CQ_OP_TABLE_SIZE(CQ_OP_TABLE_SIZE),
    .EQN_WIDTH(EQN_WIDTH),
    .TX_QUEUE_INDEX_WIDTH(TX_QUEUE_INDEX_WIDTH),
    .RX_QUEUE_INDEX_WIDTH(RX_QUEUE_INDEX_WIDTH),
    .CQN_WIDTH(CQN_WIDTH),
    .EQ_PIPELINE(EQ_PIPELINE),
    .TX_QUEUE_PIPELINE(TX_QUEUE_PIPELINE),
    .RX_QUEUE_PIPELINE(RX_QUEUE_PIPELINE),
    .CQ_PIPELINE(CQ_PIPELINE),

    // TX and RX engine configuration
    .TX_DESC_TABLE_SIZE(TX_DESC_TABLE_SIZE),
    .RX_DESC_TABLE_SIZE(RX_DESC_TABLE_SIZE),
    .RX_INDIR_TBL_ADDR_WIDTH(RX_INDIR_TBL_ADDR_WIDTH),

    // Scheduler configuration
    .TX_SCHEDULER_OP_TABLE_SIZE(TX_SCHEDULER_OP_TABLE_SIZE),
    .TX_SCHEDULER_PIPELINE(TX_SCHEDULER_PIPELINE),
    .TDMA_INDEX_WIDTH(TDMA_INDEX_WIDTH),

    // Interface configuration
    .PTP_TS_ENABLE(PTP_TS_ENABLE),
    .TX_CPL_FIFO_DEPTH(TX_CPL_FIFO_DEPTH),
    .TX_TAG_WIDTH(TX_TAG_WIDTH),
    .TX_CHECKSUM_ENABLE(TX_CHECKSUM_ENABLE),
    .RX_HASH_ENABLE(RX_HASH_ENABLE),
    .RX_CHECKSUM_ENABLE(RX_CHECKSUM_ENABLE),
    .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
    .RX_FIFO_DEPTH(RX_FIFO_DEPTH),
    .MAX_TX_SIZE(MAX_TX_SIZE),
    .MAX_RX_SIZE(MAX_RX_SIZE),
    .TX_RAM_SIZE(TX_RAM_SIZE),
    .RX_RAM_SIZE(RX_RAM_SIZE),

    // Application block configuration
    .APP_ID(APP_ID),
    .APP_ENABLE(APP_ENABLE),
    .APP_CTRL_ENABLE(APP_CTRL_ENABLE),
    .APP_DMA_ENABLE(APP_DMA_ENABLE),
    .APP_AXIS_DIRECT_ENABLE(APP_AXIS_DIRECT_ENABLE),
    .APP_AXIS_SYNC_ENABLE(APP_AXIS_SYNC_ENABLE),
    .APP_AXIS_IF_ENABLE(APP_AXIS_IF_ENABLE),
    .APP_STAT_ENABLE(APP_STAT_ENABLE),

    // AXI interface configuration (DMA)
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),

    // DMA interface configuration
    .DMA_IMM_ENABLE(DMA_IMM_ENABLE),
    .DMA_IMM_WIDTH(DMA_IMM_WIDTH),
    .DMA_LEN_WIDTH(DMA_LEN_WIDTH),
    .DMA_TAG_WIDTH(DMA_TAG_WIDTH),
    .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
    .RAM_PIPELINE(RAM_PIPELINE),
    .AXI_DMA_MAX_BURST_LEN(AXI_DMA_MAX_BURST_LEN),

    // Interrupts
    .IRQ_COUNT(IRQ_COUNT),

    // AXI lite interface configuration (control)
    .AXIL_CTRL_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
    .AXIL_CTRL_ADDR_WIDTH(AXIL_CTRL_ADDR_WIDTH),
    .AXIL_CTRL_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH),

    // AXI lite interface configuration (application control)
    .AXIL_APP_CTRL_DATA_WIDTH(AXIL_APP_CTRL_DATA_WIDTH),
    .AXIL_APP_CTRL_ADDR_WIDTH(AXIL_APP_CTRL_ADDR_WIDTH),
    .AXIL_APP_CTRL_STRB_WIDTH(AXIL_APP_CTRL_STRB_WIDTH),

    // Ethernet interface configuration
    .AXIS_ETH_DATA_WIDTH(AXIS_ETH_DATA_WIDTH),
    .AXIS_ETH_KEEP_WIDTH(AXIS_ETH_KEEP_WIDTH),
    .AXIS_ETH_SYNC_DATA_WIDTH(AXIS_ETH_SYNC_DATA_WIDTH),
    .AXIS_ETH_TX_USER_WIDTH(AXIS_ETH_TX_USER_WIDTH),
    .AXIS_ETH_RX_USER_WIDTH(AXIS_ETH_RX_USER_WIDTH),
    .AXIS_ETH_TX_PIPELINE(AXIS_ETH_TX_PIPELINE),
    .AXIS_ETH_TX_FIFO_PIPELINE(AXIS_ETH_TX_FIFO_PIPELINE),
    .AXIS_ETH_TX_TS_PIPELINE(AXIS_ETH_TX_TS_PIPELINE),
    .AXIS_ETH_RX_PIPELINE(AXIS_ETH_RX_PIPELINE),
    .AXIS_ETH_RX_FIFO_PIPELINE(AXIS_ETH_RX_FIFO_PIPELINE),

    // Statistics counter subsystem
    .STAT_ENABLE(STAT_ENABLE),
    .STAT_DMA_ENABLE(STAT_DMA_ENABLE),
    .STAT_AXI_ENABLE(STAT_AXI_ENABLE),
    .STAT_INC_WIDTH(STAT_INC_WIDTH),
    .STAT_ID_WIDTH(STAT_ID_WIDTH)
  ) core_inst (
    /*
     * Clock: 250 MHz
     * Synchronous reset
     */
    .clk_250mhz(clk),
    .rst_250mhz(rst),

    /*
     * PTP clock
     */
    .ptp_clk(ptp_clk),
    .ptp_rst(ptp_rst),
    .ptp_sample_clk(ptp_sample_clk),

    /*
     * GPIO
     */
    .led(led),
    // .sfp_led(sfp_led),

    /*
     * Interrupt outputs
     */
    .irq(irq),

    /*
     * AXI master interface (DMA)
     */
    .m_axi_awid(m_axi_dma_awid),
    .m_axi_awaddr(m_axi_dma_awaddr),
    .m_axi_awlen(m_axi_dma_awlen),
    .m_axi_awsize(m_axi_dma_awsize),
    .m_axi_awburst(m_axi_dma_awburst),
    .m_axi_awlock(m_axi_dma_awlock),
    .m_axi_awcache(m_axi_dma_awcache),
    .m_axi_awprot(m_axi_dma_awprot),
    .m_axi_awvalid(m_axi_dma_awvalid),
    .m_axi_awready(m_axi_dma_awready),
    .m_axi_wdata(m_axi_dma_wdata),
    .m_axi_wstrb(m_axi_dma_wstrb),
    .m_axi_wlast(m_axi_dma_wlast),
    .m_axi_wvalid(m_axi_dma_wvalid),
    .m_axi_wready(m_axi_dma_wready),
    .m_axi_bid(m_axi_dma_bid),
    .m_axi_bresp(m_axi_dma_bresp),
    .m_axi_bvalid(m_axi_dma_bvalid),
    .m_axi_bready(m_axi_dma_bready),
    .m_axi_arid(m_axi_dma_arid),
    .m_axi_araddr(m_axi_dma_araddr),
    .m_axi_arlen(m_axi_dma_arlen),
    .m_axi_arsize(m_axi_dma_arsize),
    .m_axi_arburst(m_axi_dma_arburst),
    .m_axi_arlock(m_axi_dma_arlock),
    .m_axi_arcache(m_axi_dma_arcache),
    .m_axi_arprot(m_axi_dma_arprot),
    .m_axi_arvalid(m_axi_dma_arvalid),
    .m_axi_arready(m_axi_dma_arready),
    .m_axi_rid(m_axi_dma_rid),
    .m_axi_rdata(m_axi_dma_rdata),
    .m_axi_rresp(m_axi_dma_rresp),
    .m_axi_rlast(m_axi_dma_rlast),
    .m_axi_rvalid(m_axi_dma_rvalid),
    .m_axi_rready(m_axi_dma_rready),

    /*
     * AXI lite interface configuration (control)
     */
    .s_axil_ctrl_awaddr(s_axil_ctrl_awaddr),
    .s_axil_ctrl_awprot(s_axil_ctrl_awprot),
    .s_axil_ctrl_awvalid(s_axil_ctrl_awvalid),
    .s_axil_ctrl_awready(s_axil_ctrl_awready),
    .s_axil_ctrl_wdata(s_axil_ctrl_wdata),
    .s_axil_ctrl_wstrb(s_axil_ctrl_wstrb),
    .s_axil_ctrl_wvalid(s_axil_ctrl_wvalid),
    .s_axil_ctrl_wready(s_axil_ctrl_wready),
    .s_axil_ctrl_bresp(s_axil_ctrl_bresp),
    .s_axil_ctrl_bvalid(s_axil_ctrl_bvalid),
    .s_axil_ctrl_bready(s_axil_ctrl_bready),
    .s_axil_ctrl_araddr(s_axil_ctrl_araddr),
    .s_axil_ctrl_arprot(s_axil_ctrl_arprot),
    .s_axil_ctrl_arvalid(s_axil_ctrl_arvalid),
    .s_axil_ctrl_arready(s_axil_ctrl_arready),
    .s_axil_ctrl_rdata(s_axil_ctrl_rdata),
    .s_axil_ctrl_rresp(s_axil_ctrl_rresp),
    .s_axil_ctrl_rvalid(s_axil_ctrl_rvalid),
    .s_axil_ctrl_rready(s_axil_ctrl_rready),

    /*
     * AXI lite interface configuration (application control)
     */
    .s_axil_app_ctrl_awaddr(s_axil_app_ctrl_awaddr),
    .s_axil_app_ctrl_awprot(s_axil_app_ctrl_awprot),
    .s_axil_app_ctrl_awvalid(s_axil_app_ctrl_awvalid),
    .s_axil_app_ctrl_awready(s_axil_app_ctrl_awready),
    .s_axil_app_ctrl_wdata(s_axil_app_ctrl_wdata),
    .s_axil_app_ctrl_wstrb(s_axil_app_ctrl_wstrb),
    .s_axil_app_ctrl_wvalid(s_axil_app_ctrl_wvalid),
    .s_axil_app_ctrl_wready(s_axil_app_ctrl_wready),
    .s_axil_app_ctrl_bresp(s_axil_app_ctrl_bresp),
    .s_axil_app_ctrl_bvalid(s_axil_app_ctrl_bvalid),
    .s_axil_app_ctrl_bready(s_axil_app_ctrl_bready),
    .s_axil_app_ctrl_araddr(s_axil_app_ctrl_araddr),
    .s_axil_app_ctrl_arprot(s_axil_app_ctrl_arprot),
    .s_axil_app_ctrl_arvalid(s_axil_app_ctrl_arvalid),
    .s_axil_app_ctrl_arready(s_axil_app_ctrl_arready),
    .s_axil_app_ctrl_rdata(s_axil_app_ctrl_rdata),
    .s_axil_app_ctrl_rresp(s_axil_app_ctrl_rresp),
    .s_axil_app_ctrl_rvalid(s_axil_app_ctrl_rvalid),
    .s_axil_app_ctrl_rready(s_axil_app_ctrl_rready),

    /*
     * Ethernet: SFP+
     */
    .sfp_tx_clk(sfp_tx_clk_int),
    .sfp_tx_rst(sfp_tx_rst_int),
    .sfp_txd(sfp_txd_int),
    .sfp_txc(sfp_txc_int),
    .sfp_tx_prbs31_enable(sfp_tx_prbs31_enable_int),
    .sfp_rx_clk(sfp_rx_clk_int),
    .sfp_rx_rst(sfp_rx_rst_int),
    .sfp_rxd(sfp_rxd_int),
    .sfp_rxc(sfp_rxc_int),
    .sfp_rx_prbs31_enable(sfp_rx_prbs31_enable_int),
    .sfp_rx_error_count(sfp_rx_error_count_int),
    .sfp_rx_status(sfp_rx_status),

    .sfp_tx_disable(sfp_tx_disable),
    .sfp_tx_fault(sfp_tx_fault_int),
    .sfp_rx_los(sfp_rx_los_int),
    .sfp_mod_abs(sfp_mod_abs_int),
    .sfp_i2c_scl_i(sfp_iic_scl_i_w),
    .sfp_i2c_scl_o(sfp_iic_scl_o_w),
    .sfp_i2c_scl_t(sfp_iic_scl_t_w),
    .sfp_i2c_sda_i(sfp_iic_sda_i_w),
    .sfp_i2c_sda_o(sfp_iic_sda_o_w),
    .sfp_i2c_sda_t(sfp_iic_sda_t_w),

    .sfp_drp_clk(sfp_drp_clk),
    .sfp_drp_rst(sfp_drp_rst),
    .sfp_drp_addr(sfp_drp_addr),
    .sfp_drp_di(sfp_drp_di),
    .sfp_drp_en(sfp_drp_en),
    .sfp_drp_we(sfp_drp_we),
    .sfp_drp_do(sfp_drp_do),
    .sfp_drp_rdy(sfp_drp_rdy)
  );

  assign clk_156mhz_int = sfp_mgt_refclk_bufg;

  assign ptp_clk = sfp_mgt_refclk_bufg;
  assign ptp_rst = sfp_rst;
  assign ptp_sample_clk = clk_125mhz_int;

  assign sfp_led[0] = sfp_rx_status;
  assign sfp_led[1] = 1'b0;

endmodule
