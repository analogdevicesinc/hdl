// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************

`resetall
`timescale 1ns / 1ps
`default_nettype none

module nic_core #(
  // FW and board IDs
  parameter FPGA_ID = 32'h4738093,
  parameter FW_ID = 32'h00000000,
  parameter FW_VER = 32'h00_00_01_00,
  parameter BOARD_ID = 32'h10ee_9066,
  parameter BOARD_VER = 32'h01_00_00_00,
  parameter BUILD_DATE = 32'd602976000,
  parameter GIT_HASH = 32'hdce357bf,
  parameter RELEASE_INFO = 32'h00000000,

  // Board configuration
  parameter TDMA_BER_ENABLE = 0,

  // Structural configuration
  parameter IF_COUNT = 2,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_MASK = 0,

  // Clock configuration
  parameter CLK_PERIOD_NS_NUM = 10,
  parameter CLK_PERIOD_NS_DENOM = 3,

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
  parameter TX_FIFO_DEPTH = 32768,
  parameter RX_FIFO_DEPTH = 32768,
  parameter MAX_TX_SIZE = 9214,
  parameter MAX_RX_SIZE = 9214,
  parameter TX_RAM_SIZE = 32768,
  parameter RX_RAM_SIZE = 32768,

  // RAM configuration
  parameter DDR_CH = 1,
  parameter DDR_ENABLE = 0,
  parameter AXI_DDR_DATA_WIDTH = 128,
  parameter AXI_DDR_ADDR_WIDTH = 29,
  parameter AXI_DDR_ID_WIDTH = 8,
  parameter AXI_DDR_MAX_BURST_LEN = 256,
  parameter AXI_DDR_NARROW_BURST = 0,

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
  input  wire                                 core_clk,
  input  wire                                 core_rst,
  output wire                                 core_irq_0,
  output wire                                 core_irq_1,
  output wire                                 core_irq_2,
  output wire                                 core_irq_3,
  output wire                                 core_irq_4,
  output wire                                 core_irq_5,
  output wire                                 core_irq_6,
  output wire                                 core_irq_7,

  input  wire                                 ptp_sample_clk,
  input  wire                                 ptp_clk,
  input  wire                                 ptp_rst,

  /* AXIL control interface */
  input  wire [AXIL_APP_CTRL_ADDR_WIDTH-1:0]  s_axi_awaddr,
  input  wire [2:0]                           s_axi_awprot,
  input  wire                                 s_axi_awvalid,
  output wire                                 s_axi_awready,
  input  wire [AXIL_APP_CTRL_DATA_WIDTH-1:0]  s_axi_wdata,
  input  wire [AXIL_APP_CTRL_STRB_WIDTH-1:0]  s_axi_wstrb,
  input  wire                                 s_axi_wvalid,
  output wire                                 s_axi_wready,
  output wire [1:0]                           s_axi_bresp,
  output wire                                 s_axi_bvalid,
  input  wire                                 s_axi_bready,
  input  wire [AXIL_APP_CTRL_ADDR_WIDTH-1:0]  s_axi_araddr,
  input  wire [2:0]                           s_axi_arprot,
  input  wire                                 s_axi_arvalid,
  output wire                                 s_axi_arready,
  output wire [AXIL_APP_CTRL_DATA_WIDTH-1:0]  s_axi_rdata,
  output wire [1:0]                           s_axi_rresp,
  output wire                                 s_axi_rvalid,
  input  wire                                 s_axi_rready,

  /* AXIL app control interface */
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]      s_axil_app_ctrl_awaddr,
  input  wire [2:0]                           s_axil_app_ctrl_awprot,
  input  wire                                 s_axil_app_ctrl_awvalid,
  output wire                                 s_axil_app_ctrl_awready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]      s_axil_app_ctrl_wdata,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]      s_axil_app_ctrl_wstrb,
  input  wire                                 s_axil_app_ctrl_wvalid,
  output wire                                 s_axil_app_ctrl_wready,
  output wire [1:0]                           s_axil_app_ctrl_bresp,
  output wire                                 s_axil_app_ctrl_bvalid,
  input  wire                                 s_axil_app_ctrl_bready,
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]      s_axil_app_ctrl_araddr,
  input  wire [2:0]                           s_axil_app_ctrl_arprot,
  input  wire                                 s_axil_app_ctrl_arvalid,
  output wire                                 s_axil_app_ctrl_arready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]      s_axil_app_ctrl_rdata,
  output wire [1:0]                           s_axil_app_ctrl_rresp,
  output wire                                 s_axil_app_ctrl_rvalid,
  input  wire                                 s_axil_app_ctrl_rready,

  /* AXI DMA interface */
  output wire [AXI_ID_WIDTH-1:0]              m_axi_awid,
  output wire [AXI_ADDR_WIDTH-1:0]            m_axi_awaddr,
  output wire [7:0]                           m_axi_awlen,
  output wire [2:0]                           m_axi_awsize,
  output wire [1:0]                           m_axi_awburst,
  output wire                                 m_axi_awlock,
  output wire [3:0]                           m_axi_awcache,
  output wire [2:0]                           m_axi_awprot,
  output wire                                 m_axi_awvalid,
  input  wire                                 m_axi_awready,
  output wire [AXI_DATA_WIDTH-1:0]            m_axi_wdata,
  output wire [AXI_STRB_WIDTH-1:0]            m_axi_wstrb,
  output wire                                 m_axi_wlast,
  output wire                                 m_axi_wvalid,
  input  wire                                 m_axi_wready,
  input  wire [AXI_ID_WIDTH-1:0]              m_axi_bid,
  input  wire [1:0]                           m_axi_bresp,
  input  wire                                 m_axi_bvalid,
  output wire                                 m_axi_bready,
  output wire [AXI_ID_WIDTH-1:0]              m_axi_arid,
  output wire [AXI_ADDR_WIDTH-1:0]            m_axi_araddr,
  output wire [7:0]                           m_axi_arlen,
  output wire [2:0]                           m_axi_arsize,
  output wire [1:0]                           m_axi_arburst,
  output wire                                 m_axi_arlock,
  output wire [3:0]                           m_axi_arcache,
  output wire [2:0]                           m_axi_arprot,
  output wire                                 m_axi_arvalid,
  input  wire                                 m_axi_arready,
  input  wire [AXI_ID_WIDTH-1:0]              m_axi_rid,
  input  wire [AXI_DATA_WIDTH-1:0]            m_axi_rdata,
  input  wire [1:0]                           m_axi_rresp,
  input  wire                                 m_axi_rlast,
  input  wire                                 m_axi_rvalid,
  output wire                                 m_axi_rready,

  input  wire                                 sfp_drp_clk,
  input  wire                                 sfp_drp_rst,
  output wire [23:0]                          sfp_drp_addr,
  output wire [15:0]                          sfp_drp_di,
  output wire                                 sfp_drp_en,
  output wire                                 sfp_drp_we,
  input  wire [15:0]                          sfp_drp_do,
  input  wire                                 sfp_drp_rdy,

  input  wire                                 sfp0_tx_clk,
  input  wire                                 sfp0_tx_rst,
  output wire [63:0]                          sfp0_txd,
  output wire [7:0]                           sfp0_txc,
  output wire                                 sfp0_tx_prbs31_enable,
  input  wire                                 sfp0_rx_clk,
  input  wire                                 sfp0_rx_rst,
  input  wire [63:0]                          sfp0_rxd,
  input  wire [7:0]                           sfp0_rxc,
  output wire                                 sfp0_rx_prbs31_enable,
  input  wire [6:0]                           sfp0_rx_error_count,
  input  wire                                 sfp0_rx_status,
  output wire                                 sfp0_tx_disable_b,

  input  wire                                 sfp1_tx_clk,
  input  wire                                 sfp1_tx_rst,
  output wire [63:0]                          sfp1_txd,
  output wire [7:0]                           sfp1_txc,
  output wire                                 sfp1_tx_prbs31_enable,
  input  wire                                 sfp1_rx_clk,
  input  wire                                 sfp1_rx_rst,
  input  wire [63:0]                          sfp1_rxd,
  input  wire [7:0]                           sfp1_rxc,
  output wire                                 sfp1_rx_prbs31_enable,
  input  wire [6:0]                           sfp1_rx_error_count,
  input  wire                                 sfp1_rx_status,
  output wire                                 sfp1_tx_disable_b,

  input  wire                                 sfp2_tx_clk,
  input  wire                                 sfp2_tx_rst,
  output wire [63:0]                          sfp2_txd,
  output wire [7:0]                           sfp2_txc,
  output wire                                 sfp2_tx_prbs31_enable,
  input  wire                                 sfp2_rx_clk,
  input  wire                                 sfp2_rx_rst,
  input  wire [63:0]                          sfp2_rxd,
  input  wire [7:0]                           sfp2_rxc,
  output wire                                 sfp2_rx_prbs31_enable,
  input  wire [6:0]                           sfp2_rx_error_count,
  input  wire                                 sfp2_rx_status,
  output wire                                 sfp2_tx_disable_b,

  input  wire                                 sfp3_tx_clk,
  input  wire                                 sfp3_tx_rst,
  output wire [63:0]                          sfp3_txd,
  output wire [7:0]                           sfp3_txc,
  output wire                                 sfp3_tx_prbs31_enable,
  input  wire                                 sfp3_rx_clk,
  input  wire                                 sfp3_rx_rst,
  input  wire [63:0]                          sfp3_rxd,
  input  wire [7:0]                           sfp3_rxc,
  output wire                                 sfp3_rx_prbs31_enable,
  input  wire [6:0]                           sfp3_rx_error_count,
  input  wire                                 sfp3_rx_status,
  output wire                                 sfp3_tx_disable_b
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

// RAM configuration
localparam AXI_DDR_STRB_WIDTH = (AXI_DDR_DATA_WIDTH/8);

// Ethernet interface configuration
localparam XGMII_DATA_WIDTH = 64;
localparam XGMII_CTRL_WIDTH = XGMII_DATA_WIDTH/8;
localparam AXIS_ETH_DATA_WIDTH = XGMII_DATA_WIDTH;
localparam AXIS_ETH_KEEP_WIDTH = AXIS_ETH_DATA_WIDTH/8;
localparam AXIS_ETH_SYNC_DATA_WIDTH = AXIS_ETH_DATA_WIDTH;
localparam AXIS_ETH_TX_USER_WIDTH = TX_TAG_WIDTH + 1;
localparam AXIS_ETH_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1;

// Clock and reset
wire clk_125mhz_ibufg;
wire clk_125mhz_bufg;
wire clk_125mhz_mmcm_out;

wire mmcm_rst = core_rst;
wire mmcm_locked;
wire mmcm_clkfb;

wire [IRQ_COUNT-1:0] irq;

reg [(IRQ_COUNT*IRQ_STRETCH)-1:0] irq_stretch = {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
reg [IRQ_COUNT-1:0] zynq_irq;
integer i, k;

always @(posedge core_clk) begin
  if (core_rst) begin
    irq_stretch <= {(IRQ_COUNT*IRQ_STRETCH){1'b0}};
  end else begin
    /* IRQ shift vector */
    irq_stretch <= {irq_stretch[0 +: (IRQ_COUNT*IRQ_STRETCH)-IRQ_COUNT], irq};
  end
end

always @* begin
  for (k = 0; k < IRQ_COUNT; k = k + 1) begin
    zynq_irq[k] = 1'b0;
    for (i = 0; i < (IRQ_COUNT*IRQ_STRETCH); i = i + IRQ_COUNT) begin
      zynq_irq[k] = zynq_irq[k] | irq_stretch[k + i];
    end
  end
end

assign core_irq_7 = zynq_irq[7];
assign core_irq_6 = zynq_irq[6];
assign core_irq_5 = zynq_irq[5];
assign core_irq_4 = zynq_irq[4];
assign core_irq_3 = zynq_irq[3];
assign core_irq_2 = zynq_irq[2];
assign core_irq_1 = zynq_irq[1];
assign core_irq_0 = zynq_irq[0];

wire                         sfp0_tx_clk_int;
wire                         sfp0_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp0_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp0_txc_int;
wire                         sfp0_tx_prbs31_enable_int;
wire                         sfp0_rx_clk_int;
wire                         sfp0_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp0_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp0_rxc_int;
wire                         sfp0_rx_prbs31_enable_int;
wire [6:0]                   sfp0_rx_error_count_int;

wire                         sfp1_tx_clk_int;
wire                         sfp1_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp1_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp1_txc_int;
wire                         sfp1_tx_prbs31_enable_int;
wire                         sfp1_rx_clk_int;
wire                         sfp1_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp1_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp1_rxc_int;
wire                         sfp1_rx_prbs31_enable_int;
wire [6:0]                   sfp1_rx_error_count_int;

wire                         sfp2_tx_clk_int;
wire                         sfp2_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp2_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp2_txc_int;
wire                         sfp2_tx_prbs31_enable_int;
wire                         sfp2_rx_clk_int;
wire                         sfp2_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp2_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp2_rxc_int;
wire                         sfp2_rx_prbs31_enable_int;
wire [6:0]                   sfp2_rx_error_count_int;

wire                         sfp3_tx_clk_int;
wire                         sfp3_tx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp3_txd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp3_txc_int;
wire                         sfp3_tx_prbs31_enable_int;
wire                         sfp3_rx_clk_int;
wire                         sfp3_rx_rst_int;
wire [XGMII_DATA_WIDTH-1:0]  sfp3_rxd_int;
wire [XGMII_CTRL_WIDTH-1:0]  sfp3_rxc_int;
wire                         sfp3_rx_prbs31_enable_int;
wire [6:0]                   sfp3_rx_error_count_int;

wire [DDR_CH-1:0]            ddr_clk;
wire [DDR_CH-1:0]            ddr_rst;

wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]    m_axi_ddr_awid;
wire [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]  m_axi_ddr_awaddr;
wire [DDR_CH*8-1:0]                   m_axi_ddr_awlen;
wire [DDR_CH*3-1:0]                   m_axi_ddr_awsize;
wire [DDR_CH*2-1:0]                   m_axi_ddr_awburst;
wire [DDR_CH-1:0]                     m_axi_ddr_awlock;
wire [DDR_CH*4-1:0]                   m_axi_ddr_awcache;
wire [DDR_CH*3-1:0]                   m_axi_ddr_awprot;
wire [DDR_CH*4-1:0]                   m_axi_ddr_awqos;
wire [DDR_CH-1:0]                     m_axi_ddr_awvalid;
wire [DDR_CH-1:0]                     m_axi_ddr_awready;
wire [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]  m_axi_ddr_wdata;
wire [DDR_CH*AXI_DDR_STRB_WIDTH-1:0]  m_axi_ddr_wstrb;
wire [DDR_CH-1:0]                     m_axi_ddr_wlast;
wire [DDR_CH-1:0]                     m_axi_ddr_wvalid;
wire [DDR_CH-1:0]                     m_axi_ddr_wready;
wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]    m_axi_ddr_bid;
wire [DDR_CH*2-1:0]                   m_axi_ddr_bresp;
wire [DDR_CH-1:0]                     m_axi_ddr_bvalid;
wire [DDR_CH-1:0]                     m_axi_ddr_bready;
wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]    m_axi_ddr_arid;
wire [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]  m_axi_ddr_araddr;
wire [DDR_CH*8-1:0]                   m_axi_ddr_arlen;
wire [DDR_CH*3-1:0]                   m_axi_ddr_arsize;
wire [DDR_CH*2-1:0]                   m_axi_ddr_arburst;
wire [DDR_CH-1:0]                     m_axi_ddr_arlock;
wire [DDR_CH*4-1:0]                   m_axi_ddr_arcache;
wire [DDR_CH*3-1:0]                   m_axi_ddr_arprot;
wire [DDR_CH*4-1:0]                   m_axi_ddr_arqos;
wire [DDR_CH-1:0]                     m_axi_ddr_arvalid;
wire [DDR_CH-1:0]                     m_axi_ddr_arready;
wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]    m_axi_ddr_rid;
wire [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]  m_axi_ddr_rdata;
wire [DDR_CH*2-1:0]                   m_axi_ddr_rresp;
wire [DDR_CH-1:0]                     m_axi_ddr_rlast;
wire [DDR_CH-1:0]                     m_axi_ddr_rvalid;
wire [DDR_CH-1:0]                     m_axi_ddr_rready;
wire [DDR_CH-1:0]                     ddr_status;

assign m_axi_ddr_awready = 0;
assign m_axi_ddr_wready = 0;
assign m_axi_ddr_bid = 0;
assign m_axi_ddr_bresp = 0;
assign m_axi_ddr_bvalid = 0;
assign m_axi_ddr_arready = 0;
assign m_axi_ddr_rid = 0;
assign m_axi_ddr_rdata = 0;
assign m_axi_ddr_rresp = 0;
assign m_axi_ddr_rlast = 0;
assign m_axi_ddr_rvalid = 0;

assign ddr_status = 0;

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

  // RAM configuration
  .DDR_CH(DDR_CH),
  .DDR_ENABLE(DDR_ENABLE),
  .AXI_DDR_DATA_WIDTH(AXI_DDR_DATA_WIDTH),
  .AXI_DDR_ADDR_WIDTH(AXI_DDR_ADDR_WIDTH),
  .AXI_DDR_STRB_WIDTH(AXI_DDR_STRB_WIDTH),
  .AXI_DDR_ID_WIDTH(AXI_DDR_ID_WIDTH),
  .AXI_DDR_MAX_BURST_LEN(AXI_DDR_MAX_BURST_LEN),
  .AXI_DDR_NARROW_BURST(AXI_DDR_NARROW_BURST),

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
   * Clock: 300 MHz
   * Synchronous reset
   */
  .clk_300mhz(core_clk),
  .rst_300mhz(core_rst),

  /*
   * PTP clock
   */
  .ptp_clk(ptp_clk),
  .ptp_rst(ptp_rst),
  .ptp_sample_clk(ptp_sample_clk),

  /*
   * Interrupt outputs
   */
  .irq(irq),

  /*
   * AXI master interface (DMA)
   */
  .m_axi_awid(m_axi_awid),
  .m_axi_awaddr(m_axi_awaddr),
  .m_axi_awlen(m_axi_awlen),
  .m_axi_awsize(m_axi_awsize),
  .m_axi_awburst(m_axi_awburst),
  .m_axi_awlock(m_axi_awlock),
  .m_axi_awcache(m_axi_awcache),
  .m_axi_awprot(m_axi_awprot),
  .m_axi_awvalid(m_axi_awvalid),
  .m_axi_awready(m_axi_awready),
  .m_axi_wdata(m_axi_wdata),
  .m_axi_wstrb(m_axi_wstrb),
  .m_axi_wlast(m_axi_wlast),
  .m_axi_wvalid(m_axi_wvalid),
  .m_axi_wready(m_axi_wready),
  .m_axi_bid(m_axi_bid),
  .m_axi_bresp(m_axi_bresp),
  .m_axi_bvalid(m_axi_bvalid),
  .m_axi_bready(m_axi_bready),
  .m_axi_arid(m_axi_arid),
  .m_axi_araddr(m_axi_araddr),
  .m_axi_arlen(m_axi_arlen),
  .m_axi_arsize(m_axi_arsize),
  .m_axi_arburst(m_axi_arburst),
  .m_axi_arlock(m_axi_arlock),
  .m_axi_arcache(m_axi_arcache),
  .m_axi_arprot(m_axi_arprot),
  .m_axi_arvalid(m_axi_arvalid),
  .m_axi_arready(m_axi_arready),
  .m_axi_rid(m_axi_rid),
  .m_axi_rdata(m_axi_rdata),
  .m_axi_rresp(m_axi_rresp),
  .m_axi_rlast(m_axi_rlast),
  .m_axi_rvalid(m_axi_rvalid),
  .m_axi_rready(m_axi_rready),

  /*
   * AXI lite interface configuration (control)
   */
  .s_axil_ctrl_awaddr(s_axi_awaddr),
  .s_axil_ctrl_awprot(s_axi_awprot),
  .s_axil_ctrl_awvalid(s_axi_awvalid),
  .s_axil_ctrl_awready(s_axi_awready),
  .s_axil_ctrl_wdata(s_axi_wdata),
  .s_axil_ctrl_wstrb(s_axi_wstrb),
  .s_axil_ctrl_wvalid(s_axi_wvalid),
  .s_axil_ctrl_wready(s_axi_wready),
  .s_axil_ctrl_bresp(s_axi_bresp),
  .s_axil_ctrl_bvalid(s_axi_bvalid),
  .s_axil_ctrl_bready(s_axi_bready),
  .s_axil_ctrl_araddr(s_axi_araddr),
  .s_axil_ctrl_arprot(s_axi_arprot),
  .s_axil_ctrl_arvalid(s_axi_arvalid),
  .s_axil_ctrl_arready(s_axi_arready),
  .s_axil_ctrl_rdata(s_axi_rdata),
  .s_axil_ctrl_rresp(s_axi_rresp),
  .s_axil_ctrl_rvalid(s_axi_rvalid),
  .s_axil_ctrl_rready(s_axi_rready),

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
  .sfp0_tx_clk(sfp0_tx_clk),
  .sfp0_tx_rst(sfp0_tx_rst),
  .sfp0_txd(sfp0_txd),
  .sfp0_txc(sfp0_txc),
  .sfp0_tx_prbs31_enable(sfp0_tx_prbs31_enable),
  .sfp0_rx_clk(sfp0_rx_clk),
  .sfp0_rx_rst(sfp0_rx_rst),
  .sfp0_rxd(sfp0_rxd),
  .sfp0_rxc(sfp0_rxc),
  .sfp0_rx_prbs31_enable(sfp0_rx_prbs31_enable),
  .sfp0_rx_error_count(sfp0_rx_error_count),
  .sfp0_rx_status(sfp0_rx_status),
  .sfp0_tx_disable_b(sfp0_tx_disable_b),

  .sfp1_tx_clk(sfp1_tx_clk),
  .sfp1_tx_rst(sfp1_tx_rst),
  .sfp1_txd(sfp1_txd),
  .sfp1_txc(sfp1_txc),
  .sfp1_tx_prbs31_enable(sfp1_tx_prbs31_enable),
  .sfp1_rx_clk(sfp1_rx_clk),
  .sfp1_rx_rst(sfp1_rx_rst),
  .sfp1_rxd(sfp1_rxd),
  .sfp1_rxc(),
  .sfp1_rx_prbs31_enable(sfp1_rx_prbs31_enable),
  .sfp1_rx_error_count(sfp1_rx_error_count),
  .sfp1_rx_status(sfp1_rx_status),
  .sfp1_tx_disable_b(sfp1_tx_disable_b),

  .sfp2_tx_clk(sfp2_tx_clk),
  .sfp2_tx_rst(sfp2_tx_rst),
  .sfp2_txd(sfp2_txd),
  .sfp2_txc(sfp2_txc),
  .sfp2_tx_prbs31_enable(sfp2_tx_prbs31_enable),
  .sfp2_rx_clk(sfp2_rx_clk),
  .sfp2_rx_rst(sfp2_rx_rst),
  .sfp2_rxd(sfp2_rxd),
  .sfp2_rxc(sfp2_rxc),
  .sfp2_rx_prbs31_enable(sfp2_rx_prbs31_enable),
  .sfp2_rx_error_count(sfp2_rx_error_count),
  .sfp2_rx_status(sfp2_rx_status),
  .sfp2_tx_disable_b(sfp2_tx_disable_b),

  .sfp3_tx_clk(sfp3_tx_clk),
  .sfp3_tx_rst(sfp3_tx_rst),
  .sfp3_txd(sfp3_txd),
  .sfp3_txc(sfp3_txc),
  .sfp3_tx_prbs31_enable(sfp3_tx_prbs31_enable),
  .sfp3_rx_clk(sfp3_rx_clk),
  .sfp3_rx_rst(sfp3_rx_rst),
  .sfp3_rxd(sfp3_rxd),
  .sfp3_rxc(sfp3_rxc),
  .sfp3_rx_prbs31_enable(sfp3_rx_prbs31_enable),
  .sfp3_rx_error_count(sfp3_rx_error_count),
  .sfp3_rx_status(sfp3_rx_status),
  .sfp3_tx_disable_b(sfp3_tx_disable_b),

  .sfp_drp_clk(sfp_drp_clk),
  .sfp_drp_rst(sfp_drp_rst),
  .sfp_drp_addr(sfp_drp_addr),
  .sfp_drp_di(sfp_drp_di),
  .sfp_drp_en(sfp_drp_en),
  .sfp_drp_we(sfp_drp_we),
  .sfp_drp_do(sfp_drp_do),
  .sfp_drp_rdy(sfp_drp_rdy),

  /*
   * DDR
   */
  .ddr_clk(ddr_clk),
  .ddr_rst(ddr_rst),

  .m_axi_ddr_awid(m_axi_ddr_awid),
  .m_axi_ddr_awaddr(m_axi_ddr_awaddr),
  .m_axi_ddr_awlen(m_axi_ddr_awlen),
  .m_axi_ddr_awsize(m_axi_ddr_awsize),
  .m_axi_ddr_awburst(m_axi_ddr_awburst),
  .m_axi_ddr_awlock(m_axi_ddr_awlock),
  .m_axi_ddr_awcache(m_axi_ddr_awcache),
  .m_axi_ddr_awprot(m_axi_ddr_awprot),
  .m_axi_ddr_awqos(m_axi_ddr_awqos),
  .m_axi_ddr_awvalid(m_axi_ddr_awvalid),
  .m_axi_ddr_awready(m_axi_ddr_awready),
  .m_axi_ddr_wdata(m_axi_ddr_wdata),
  .m_axi_ddr_wstrb(m_axi_ddr_wstrb),
  .m_axi_ddr_wlast(m_axi_ddr_wlast),
  .m_axi_ddr_wvalid(m_axi_ddr_wvalid),
  .m_axi_ddr_wready(m_axi_ddr_wready),
  .m_axi_ddr_bid(m_axi_ddr_bid),
  .m_axi_ddr_bresp(m_axi_ddr_bresp),
  .m_axi_ddr_bvalid(m_axi_ddr_bvalid),
  .m_axi_ddr_bready(m_axi_ddr_bready),
  .m_axi_ddr_arid(m_axi_ddr_arid),
  .m_axi_ddr_araddr(m_axi_ddr_araddr),
  .m_axi_ddr_arlen(m_axi_ddr_arlen),
  .m_axi_ddr_arsize(m_axi_ddr_arsize),
  .m_axi_ddr_arburst(m_axi_ddr_arburst),
  .m_axi_ddr_arlock(m_axi_ddr_arlock),
  .m_axi_ddr_arcache(m_axi_ddr_arcache),
  .m_axi_ddr_arprot(m_axi_ddr_arprot),
  .m_axi_ddr_arqos(m_axi_ddr_arqos),
  .m_axi_ddr_arvalid(m_axi_ddr_arvalid),
  .m_axi_ddr_arready(m_axi_ddr_arready),
  .m_axi_ddr_rid(m_axi_ddr_rid),
  .m_axi_ddr_rdata(m_axi_ddr_rdata),
  .m_axi_ddr_rresp(m_axi_ddr_rresp),
  .m_axi_ddr_rlast(m_axi_ddr_rlast),
  .m_axi_ddr_rvalid(m_axi_ddr_rvalid),
  .m_axi_ddr_rready(m_axi_ddr_rready),
  .ddr_status(ddr_status));

endmodule

`resetall