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

// `ifdef APP_CUSTOM_PARAMS_ENABLE
//   `include "mqnic_app_custom_params.vh"
// `endif

// `ifdef APP_CUSTOM_PORTS_ENABLE
//   `include "mqnic_app_custom_ports.vh"
// `endif

module corundum_core #(
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
  parameter AXIL_CSR_PASSTHROUGH_ENABLE = 0,

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,
  parameter SCHED_PER_IF = PORTS_PER_IF,
  parameter PORT_COUNT = IF_COUNT * PORTS_PER_IF,

  // Interrupt configuration
  parameter IRQ_COUNT = 32,

  // Clock configuration
  parameter CLK_PERIOD_NS_NUM = 4,
  parameter CLK_PERIOD_NS_DENOM = 1,

  // PTP configuration
  parameter PTP_CLK_PERIOD_NS_NUM = 32,
  parameter PTP_CLK_PERIOD_NS_DENOM = 5,
  parameter PTP_CLOCK_PIPELINE = 0,
  parameter PTP_CLOCK_CDC_PIPELINE = 0,
  parameter PTP_PORT_CDC_PIPELINE = 0,
  parameter PTP_PEROUT_ENABLE = 1,
  parameter PTP_PEROUT_COUNT = 1,
  parameter PTP_TS_ENABLE = 1,
  parameter PTP_TS_FMT_TOD = 0,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 48,

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

  // Memory configuration
  parameter TX_CPL_FIFO_DEPTH = 32,
  parameter TX_TAG_WIDTH = 16,
  parameter TX_CHECKSUM_ENABLE = 1,
  parameter RX_HASH_ENABLE = 1,
  parameter RX_CHECKSUM_ENABLE = 1,
  parameter PFC_ENABLE = 1,
  parameter LFC_ENABLE = PFC_ENABLE,
  parameter TX_FIFO_DEPTH = 32768,
  parameter RX_FIFO_DEPTH = 32768,
  parameter MAX_TX_SIZE = 9214,
  parameter MAX_RX_SIZE = 9214,
  parameter TX_RAM_SIZE = 32768,
  parameter RX_RAM_SIZE = 32768,

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

  // AXI lite interface configuration (control)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  // AXI lite interface configuration (application control)
  parameter AXIL_APP_CTRL_DATA_WIDTH = AXIL_CTRL_DATA_WIDTH,
  parameter AXIL_APP_CTRL_ADDR_WIDTH = 24,
  parameter AXIL_APP_CTRL_STRB_WIDTH = (AXIL_APP_CTRL_DATA_WIDTH/8),

  // Ethernet interface configuration
  parameter XGMII_DATA_WIDTH = 64,
  parameter AXIS_DATA_WIDTH = XGMII_DATA_WIDTH,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_SYNC_DATA_WIDTH = AXIS_DATA_WIDTH,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,
  parameter AXIS_TX_PIPELINE = 0,
  parameter AXIS_TX_FIFO_PIPELINE = 2,
  parameter AXIS_TX_TS_PIPELINE = 0,
  parameter AXIS_RX_PIPELINE = 0,
  parameter AXIS_RX_FIFO_PIPELINE = 2,

  // Statistics counter subsystem
  parameter STAT_ENABLE = 0,
  parameter STAT_DMA_ENABLE = 0,
  parameter STAT_AXI_ENABLE = 0,
  parameter STAT_INC_WIDTH = 24,
  parameter STAT_ID_WIDTH = 12
) (
  // Clock and reset
  input  wire                                       clk_250mhz,
  input  wire                                       rst_250mhz,

  /*
  * AXI master interface (DMA)
  */
  output wire [AXI_ID_WIDTH-1:0]                    m_axi_awid,
  output wire [AXI_ADDR_WIDTH-1:0]                  m_axi_awaddr,
  output wire [7:0]                                 m_axi_awlen,
  output wire [2:0]                                 m_axi_awsize,
  output wire [1:0]                                 m_axi_awburst,
  output wire                                       m_axi_awlock,
  output wire [3:0]                                 m_axi_awcache,
  output wire [2:0]                                 m_axi_awprot,
  output wire                                       m_axi_awvalid,
  input  wire                                       m_axi_awready,
  output wire [AXI_DATA_WIDTH-1:0]                  m_axi_wdata,
  output wire [AXI_STRB_WIDTH-1:0]                  m_axi_wstrb,
  output wire                                       m_axi_wlast,
  output wire                                       m_axi_wvalid,
  input  wire                                       m_axi_wready,
  input  wire [AXI_ID_WIDTH-1:0]                    m_axi_bid,
  input  wire [1:0]                                 m_axi_bresp,
  input  wire                                       m_axi_bvalid,
  output wire                                       m_axi_bready,
  output wire [AXI_ID_WIDTH-1:0]                    m_axi_arid,
  output wire [AXI_ADDR_WIDTH-1:0]                  m_axi_araddr,
  output wire [7:0]                                 m_axi_arlen,
  output wire [2:0]                                 m_axi_arsize,
  output wire [1:0]                                 m_axi_arburst,
  output wire                                       m_axi_arlock,
  output wire [3:0]                                 m_axi_arcache,
  output wire [2:0]                                 m_axi_arprot,
  output wire                                       m_axi_arvalid,
  input  wire                                       m_axi_arready,
  input  wire [AXI_ID_WIDTH-1:0]                    m_axi_rid,
  input  wire [AXI_DATA_WIDTH-1:0]                  m_axi_rdata,
  input  wire [1:0]                                 m_axi_rresp,
  input  wire                                       m_axi_rlast,
  input  wire                                       m_axi_rvalid,
  output wire                                       m_axi_rready,

  /*
  * AXI-Lite slave interface (control)
  */
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]            s_axil_ctrl_awaddr,
  input  wire [2:0]                                 s_axil_ctrl_awprot,
  input  wire                                       s_axil_ctrl_awvalid,
  output wire                                       s_axil_ctrl_awready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]            s_axil_ctrl_wdata,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]            s_axil_ctrl_wstrb,
  input  wire                                       s_axil_ctrl_wvalid,
  output wire                                       s_axil_ctrl_wready,
  output wire [1:0]                                 s_axil_ctrl_bresp,
  output wire                                       s_axil_ctrl_bvalid,
  input  wire                                       s_axil_ctrl_bready,
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]            s_axil_ctrl_araddr,
  input  wire [2:0]                                 s_axil_ctrl_arprot,
  input  wire                                       s_axil_ctrl_arvalid,
  output wire                                       s_axil_ctrl_arready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]            s_axil_ctrl_rdata,
  output wire [1:0]                                 s_axil_ctrl_rresp,
  output wire                                       s_axil_ctrl_rvalid,
  input  wire                                       s_axil_ctrl_rready,

  /*
   * AXI lite interface configuration (application control)
   */
  input  wire [AXIL_APP_CTRL_ADDR_WIDTH-1:0]  s_axil_app_ctrl_awaddr,
  input  wire [2:0]                           s_axil_app_ctrl_awprot,
  input  wire                                 s_axil_app_ctrl_awvalid,
  output wire                                 s_axil_app_ctrl_awready,
  input  wire [AXIL_APP_CTRL_DATA_WIDTH-1:0]  s_axil_app_ctrl_wdata,
  input  wire [AXIL_APP_CTRL_STRB_WIDTH-1:0]  s_axil_app_ctrl_wstrb,
  input  wire                                 s_axil_app_ctrl_wvalid,
  output wire                                 s_axil_app_ctrl_wready,
  output wire [1:0]                           s_axil_app_ctrl_bresp,
  output wire                                 s_axil_app_ctrl_bvalid,
  input  wire                                 s_axil_app_ctrl_bready,
  input  wire [AXIL_APP_CTRL_ADDR_WIDTH-1:0]  s_axil_app_ctrl_araddr,
  input  wire [2:0]                           s_axil_app_ctrl_arprot,
  input  wire                                 s_axil_app_ctrl_arvalid,
  output wire                                 s_axil_app_ctrl_arready,
  output wire [AXIL_APP_CTRL_DATA_WIDTH-1:0]  s_axil_app_ctrl_rdata,
  output wire [1:0]                           s_axil_app_ctrl_rresp,
  output wire                                 s_axil_app_ctrl_rvalid,
  input  wire                                 s_axil_app_ctrl_rready,

  /*
  * Interrupt outputs
  */
  output wire  [IRQ_COUNT-1:0]                       irq,

  /*
  * PTP clock
  */
  input  wire                                       ptp_clk,
  input  wire                                       ptp_rst,
  input  wire                                       ptp_sample_clk,

  /*
  * Ethernet
  */
  input  wire [PORT_COUNT-1:0]                      tx_clk,
  input  wire [PORT_COUNT-1:0]                      tx_rst,

//   input  wire [PORT_COUNT-1:0]                      tx_ptp_clk,
//   input  wire [PORT_COUNT-1:0]                      tx_ptp_rst,
  output wire [PORT_COUNT*PTP_TS_WIDTH-1:0]         tx_ptp_ts,
  output wire [PORT_COUNT-1:0]                      tx_ptp_ts_step,

  output wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]         axis_eth_tx_tdata,
  output wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]         axis_eth_tx_tkeep,
  output wire [PORT_COUNT-1:0]                         axis_eth_tx_tvalid,
  input  wire [PORT_COUNT-1:0]                         axis_eth_tx_tready,
  output wire [PORT_COUNT-1:0]                         axis_eth_tx_tlast,
  output wire [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0]      axis_eth_tx_tuser,

  input  wire [PORT_COUNT*PTP_TS_WIDTH-1:0]            axis_eth_tx_ptp_ts,
  input  wire [PORT_COUNT*TX_TAG_WIDTH-1:0]            axis_eth_tx_ptp_ts_tag,
  input  wire [PORT_COUNT-1:0]                         axis_eth_tx_ptp_ts_valid,
  output wire [PORT_COUNT-1:0]                         axis_eth_tx_ptp_ts_ready,

  output wire [PORT_COUNT-1:0]                      eth_tx_enable,
  input  wire [PORT_COUNT-1:0]                      eth_tx_status,
  output wire [PORT_COUNT-1:0]                      eth_tx_lfc_en,
  output wire [PORT_COUNT-1:0]                      eth_tx_lfc_req,
  output wire [PORT_COUNT*8-1:0]                    eth_tx_pfc_en,
  output wire [PORT_COUNT*8-1:0]                    eth_tx_pfc_req,
//   input  wire [PORT_COUNT-1:0]                      eth_tx_fc_quanta_clk_en,

  input  wire [PORT_COUNT-1:0]                      eth_rx_clk,
  input  wire [PORT_COUNT-1:0]                      eth_rx_rst,

//   input  wire [PORT_COUNT-1:0]                      rx_ptp_clk,
//   input  wire [PORT_COUNT-1:0]                      rx_ptp_rst,
  input wire [PORT_COUNT*PTP_TS_WIDTH-1:0]          rx_ptp_ts,
  input wire [PORT_COUNT-1:0]                       rx_ptp_ts_step,

  input  wire [PORT_COUNT*AXIS_DATA_WIDTH-1:0]         axis_eth_rx_tdata,
  input  wire [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]         axis_eth_rx_tkeep,
  input  wire [PORT_COUNT-1:0]                         axis_eth_rx_tvalid,
  output wire [PORT_COUNT-1:0]                         axis_eth_rx_tready,
  input  wire [PORT_COUNT-1:0]                         axis_eth_rx_tlast,
  input  wire [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0]      axis_eth_rx_tuser,

  output wire [PORT_COUNT-1:0]                      eth_rx_enable,
  input  wire [PORT_COUNT-1:0]                      eth_rx_status,
  output wire [PORT_COUNT-1:0]                      eth_rx_lfc_en,
  input  wire [PORT_COUNT-1:0]                      eth_rx_lfc_req,
  output wire [PORT_COUNT-1:0]                      eth_rx_lfc_ack,
  output wire [PORT_COUNT*8-1:0]                    eth_rx_pfc_en,
  input  wire [PORT_COUNT*8-1:0]                    eth_rx_pfc_req,
  output wire [PORT_COUNT*8-1:0]                    eth_rx_pfc_ack,
//   input  wire [PORT_COUNT-1:0]                      eth_rx_fc_quanta_clk_en,

  output wire                                 sfp_tx_disable,
  input  wire                                 sfp_tx_fault,
  input  wire                                 sfp_rx_los,
  input  wire                                 sfp_mod_abs,
  input  wire                                 sfp_i2c_scl_i,
  output wire                                 sfp_i2c_scl_o,
  output wire                                 sfp_i2c_scl_t,
  input  wire                                 sfp_i2c_sda_i,
  output wire                                 sfp_i2c_sda_o,
  output wire                                 sfp_i2c_sda_t,

  input                                   sfp_drp_clk,
  input                                   sfp_drp_rst,
  output  [23:0]                          sfp_drp_addr,
  output  [15:0]                          sfp_drp_di,
  output                                  sfp_drp_en,
  output                                  sfp_drp_we,
  input   [15:0]                          sfp_drp_do,
  input                                   sfp_drp_rdy,

  input                                   sfp_tx_clk,
//   input                                   sfp_tx_rst,
//   output  [63:0]                          sfp_txd,
//   output  [7:0]                           sfp_txc,
//   output                                  sfp_tx_prbs31_enable,
  input                                   sfp_rx_clk,
//   input                                   sfp_rx_rst,
//   input   [63:0]                          sfp_rxd,
//   input   [7:0]                           sfp_rxc,
//   output                                  sfp_rx_prbs31_enable,
  input   [6:0]                           sfp_rx_error_count

  /*
  * Custom application block ports
  */
  // `ifdef APP_CUSTOM_PORTS_ENABLE
  //   `APP_CUSTOM_PORTS_DECL
  // `endif
  
  /*
  * Statistics increment input
  */
//   input  wire [STAT_INC_WIDTH-1:0]                  s_axis_stat_tdata,
//   input  wire [STAT_ID_WIDTH-1:0]                   s_axis_stat_tid,
//   input  wire                                       s_axis_stat_tvalid,
//   output wire                                       s_axis_stat_tready
);

// parameter PORT_COUNT = IF_COUNT*PORTS_PER_IF;

localparam AXIL_IF_CTRL_ADDR_WIDTH = AXIL_CTRL_ADDR_WIDTH-$clog2(IF_COUNT);
localparam AXIL_CSR_ADDR_WIDTH = AXIL_IF_CTRL_ADDR_WIDTH-5-$clog2((PORTS_PER_IF+3)/8);

localparam RB_BASE_ADDR = 16'h1000;
localparam RBB = RB_BASE_ADDR & {AXIL_CTRL_ADDR_WIDTH{1'b1}};

localparam RB_DRP_SFP_BASE = RB_BASE_ADDR + 16'h20;

initial begin
    if (PORT_COUNT > 1) begin
        $error("Error: Max port count exceeded (instance %m)");
        $finish;
    end
end

// AXI lite connections
wire [AXIL_CSR_ADDR_WIDTH-1:0]   axil_csr_awaddr;
wire [2:0]                       axil_csr_awprot;
wire                             axil_csr_awvalid;
wire                             axil_csr_awready;
wire [AXIL_CTRL_DATA_WIDTH-1:0]  axil_csr_wdata;
wire [AXIL_CTRL_STRB_WIDTH-1:0]  axil_csr_wstrb;
wire                             axil_csr_wvalid;
wire                             axil_csr_wready;
wire [1:0]                       axil_csr_bresp;
wire                             axil_csr_bvalid;
wire                             axil_csr_bready;
wire [AXIL_CSR_ADDR_WIDTH-1:0]   axil_csr_araddr;
wire [2:0]                       axil_csr_arprot;
wire                             axil_csr_arvalid;
wire                             axil_csr_arready;
wire [AXIL_CTRL_DATA_WIDTH-1:0]  axil_csr_rdata;
wire [1:0]                       axil_csr_rresp;
wire                             axil_csr_rvalid;
wire                             axil_csr_rready;

  /*
  * Control register interface
  */
wire [AXIL_CTRL_ADDR_WIDTH-1:0]            ctrl_reg_wr_addr;
wire [AXIL_CTRL_DATA_WIDTH-1:0]            ctrl_reg_wr_data;
wire [AXIL_CTRL_STRB_WIDTH-1:0]            ctrl_reg_wr_strb;
wire                                       ctrl_reg_wr_en;
wire                                       ctrl_reg_wr_wait;
wire                                       ctrl_reg_wr_ack;
wire [AXIL_CTRL_ADDR_WIDTH-1:0]            ctrl_reg_rd_addr;
wire                                       ctrl_reg_rd_en;
wire [AXIL_CTRL_DATA_WIDTH-1:0]            ctrl_reg_rd_data;
wire                                       ctrl_reg_rd_wait;
wire                                       ctrl_reg_rd_ack;

// PTP

wire                                       ptp_td_sd;
wire                                       ptp_pps;
wire                                       ptp_sync_locked;
wire [63:0]                                ptp_sync_ts_rel;
wire                                       ptp_sync_ts_rel_step;
wire [96:0]                                ptp_sync_ts_tod;
wire                                       ptp_sync_ts_tod_step;
wire                                       ptp_sync_pps;
wire                                       ptp_sync_pps_str;
wire [PTP_PEROUT_COUNT-1:0]                ptp_perout_locked;
wire [PTP_PEROUT_COUNT-1:0]                ptp_perout_error;
wire [PTP_PEROUT_COUNT-1:0]                ptp_perout_pulse;

wire                                       ptp_pps_str;

wire sfp_drp_reg_wr_wait;
wire sfp_drp_reg_wr_ack;
wire [AXIL_CTRL_DATA_WIDTH-1:0] sfp_drp_reg_rd_data;
wire sfp_drp_reg_rd_wait;
wire sfp_drp_reg_rd_ack;

reg ctrl_reg_wr_ack_reg = 1'b0;
reg [AXIL_CTRL_DATA_WIDTH-1:0] ctrl_reg_rd_data_reg = {AXIL_CTRL_DATA_WIDTH{1'b0}};
reg ctrl_reg_rd_ack_reg = 1'b0;

reg sfp_tx_disable_reg = 1'b0;

reg sfp_i2c_scl_o_reg = 1'b1;
reg sfp_i2c_sda_o_reg = 1'b1;

assign ctrl_reg_wr_wait = sfp_drp_reg_wr_wait;
assign ctrl_reg_wr_ack = ctrl_reg_wr_ack_reg | sfp_drp_reg_wr_ack;
assign ctrl_reg_rd_data = ctrl_reg_rd_data_reg | sfp_drp_reg_rd_data;
assign ctrl_reg_rd_wait = sfp_drp_reg_rd_wait;
assign ctrl_reg_rd_ack = ctrl_reg_rd_ack_reg | sfp_drp_reg_rd_ack;

assign sfp_tx_disable = sfp_tx_disable_reg;

assign sfp_i2c_scl_o = sfp_i2c_scl_o_reg;
assign sfp_i2c_scl_t = sfp_i2c_scl_o_reg;
assign sfp_i2c_sda_o = sfp_i2c_sda_o_reg;
assign sfp_i2c_sda_t = sfp_i2c_sda_o_reg;

always @(posedge clk_250mhz) begin
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
                    sfp_i2c_scl_o_reg <= ctrl_reg_wr_data[1];
                end
                if (ctrl_reg_wr_strb[1]) begin
                    sfp_i2c_sda_o_reg <= ctrl_reg_wr_data[9];
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
                ctrl_reg_rd_data_reg[0] <= sfp_i2c_scl_i;
                ctrl_reg_rd_data_reg[1] <= sfp_i2c_scl_o_reg;
                ctrl_reg_rd_data_reg[8] <= sfp_i2c_sda_i;
                ctrl_reg_rd_data_reg[9] <= sfp_i2c_sda_o_reg;
            end
            // XCVR GPIO
            RBB+8'h10: ctrl_reg_rd_data_reg <= 32'h0000C101;             // XCVR GPIO: Type
            RBB+8'h14: ctrl_reg_rd_data_reg <= 32'h00000100;             // XCVR GPIO: Version
            RBB+8'h18: ctrl_reg_rd_data_reg <= RB_DRP_SFP_BASE;          // XCVR GPIO: Next header
            RBB+8'h1C: begin
                // XCVR GPIO: control 0123
                ctrl_reg_rd_data_reg[0] <= !sfp_mod_abs;
                ctrl_reg_rd_data_reg[1] <= sfp_tx_fault;
                ctrl_reg_rd_data_reg[2] <= sfp_rx_los;
                ctrl_reg_rd_data_reg[5] <= sfp_tx_disable_reg;
            end
            default: ctrl_reg_rd_ack_reg <= 1'b0;
        endcase
    end

    if (rst_250mhz) begin
        ctrl_reg_wr_ack_reg <= 1'b0;
        ctrl_reg_rd_ack_reg <= 1'b0;

        sfp_tx_disable_reg <= 1'b0;

        sfp_i2c_scl_o_reg <= 1'b1;
        sfp_i2c_sda_o_reg <= 1'b1;
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
)
sfp_rb_drp_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

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
    .drp_rdy(sfp_drp_rdy)
);



mqnic_core_axi #(
    // FW and board IDs
    .FPGA_ID(FPGA_ID),
    .FW_ID(FW_ID),
    .FW_VER(FW_VER),
    .BOARD_ID(BOARD_ID),
    .BOARD_VER(BOARD_VER),
    .BUILD_DATE(BUILD_DATE),
    .GIT_HASH(GIT_HASH),
    .RELEASE_INFO(RELEASE_INFO),

    // Structural configuration
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .SCHED_PER_IF(SCHED_PER_IF),

    .PORT_COUNT(PORT_COUNT),

    // Clock configuration
    .CLK_PERIOD_NS_NUM(CLK_PERIOD_NS_NUM),
    .CLK_PERIOD_NS_DENOM(CLK_PERIOD_NS_DENOM),

    // PTP configuration
    .PTP_CLK_PERIOD_NS_NUM(PTP_CLK_PERIOD_NS_NUM),
    .PTP_CLK_PERIOD_NS_DENOM(PTP_CLK_PERIOD_NS_DENOM),
    .PTP_CLOCK_PIPELINE(PTP_CLOCK_PIPELINE),
    .PTP_CLOCK_CDC_PIPELINE(PTP_CLOCK_CDC_PIPELINE),
    .PTP_SEPARATE_TX_CLOCK(0),
    .PTP_SEPARATE_RX_CLOCK(0),
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
    .PTP_TS_FMT_TOD(PTP_TS_FMT_TOD),
    .PTP_TS_WIDTH(PTP_TS_WIDTH),
    .TX_CPL_ENABLE(PTP_TS_ENABLE),
    .TX_CPL_FIFO_DEPTH(TX_CPL_FIFO_DEPTH),
    .TX_TAG_WIDTH(TX_TAG_WIDTH),
    .TX_CHECKSUM_ENABLE(TX_CHECKSUM_ENABLE),
    .RX_HASH_ENABLE(RX_HASH_ENABLE),
    .RX_CHECKSUM_ENABLE(RX_CHECKSUM_ENABLE),
    .PFC_ENABLE(PFC_ENABLE),
    .LFC_ENABLE(LFC_ENABLE),
    .MAC_CTRL_ENABLE(0),
    .TX_FIFO_DEPTH(TX_FIFO_DEPTH),
    .RX_FIFO_DEPTH(RX_FIFO_DEPTH),
    .MAX_TX_SIZE(MAX_TX_SIZE),
    .MAX_RX_SIZE(MAX_RX_SIZE),
    .TX_RAM_SIZE(TX_RAM_SIZE),
    .RX_RAM_SIZE(RX_RAM_SIZE),

    // RAM configuration
    .DDR_ENABLE(0),
    .HBM_ENABLE(0),

    // Application block configuration
    .APP_ID(APP_ID),
    .APP_ENABLE(APP_ENABLE),
    .APP_CTRL_ENABLE(APP_CTRL_ENABLE),
    .APP_DMA_ENABLE(APP_DMA_ENABLE),
    .APP_AXIS_DIRECT_ENABLE(APP_AXIS_DIRECT_ENABLE),
    .APP_AXIS_SYNC_ENABLE(APP_AXIS_SYNC_ENABLE),
    .APP_AXIS_IF_ENABLE(APP_AXIS_IF_ENABLE),
    .APP_STAT_ENABLE(APP_STAT_ENABLE),
    .APP_GPIO_IN_WIDTH(32),
    .APP_GPIO_OUT_WIDTH(32),

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
    .AXIL_IF_CTRL_ADDR_WIDTH(AXIL_IF_CTRL_ADDR_WIDTH),
    .AXIL_CSR_ADDR_WIDTH(AXIL_CSR_ADDR_WIDTH),
    .AXIL_CSR_PASSTHROUGH_ENABLE(AXIL_CSR_PASSTHROUGH_ENABLE),
    .RB_NEXT_PTR(RB_BASE_ADDR),

    // AXI lite interface configuration (application control)
    .AXIL_APP_CTRL_DATA_WIDTH(AXIL_APP_CTRL_DATA_WIDTH),
    .AXIL_APP_CTRL_ADDR_WIDTH(AXIL_APP_CTRL_ADDR_WIDTH),

    // Ethernet interface configuration
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_SYNC_DATA_WIDTH(AXIS_SYNC_DATA_WIDTH),
    .AXIS_TX_USER_WIDTH(AXIS_TX_USER_WIDTH),
    .AXIS_RX_USER_WIDTH(AXIS_RX_USER_WIDTH),
    .AXIS_RX_USE_READY(0),
    .AXIS_TX_PIPELINE(AXIS_TX_PIPELINE),
    .AXIS_TX_FIFO_PIPELINE(AXIS_TX_FIFO_PIPELINE),
    .AXIS_TX_TS_PIPELINE(AXIS_TX_TS_PIPELINE),
    .AXIS_RX_PIPELINE(AXIS_RX_PIPELINE),
    .AXIS_RX_FIFO_PIPELINE(AXIS_RX_FIFO_PIPELINE),

    // Statistics counter subsystem
    .STAT_ENABLE(STAT_ENABLE),
    .STAT_DMA_ENABLE(STAT_DMA_ENABLE),
    .STAT_AXI_ENABLE(STAT_AXI_ENABLE),
    .STAT_INC_WIDTH(STAT_INC_WIDTH),
    .STAT_ID_WIDTH(STAT_ID_WIDTH)
)
core_inst (
    .clk(clk_250mhz),
    .rst(rst_250mhz),

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
     * AXI-Lite slave interface (control)
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
     * AXI-Lite slave interface (application control)
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
     * AXI-Lite master interface (passthrough for NIC control and status)
     */
    .m_axil_csr_awaddr(axil_csr_awaddr),
    .m_axil_csr_awprot(axil_csr_awprot),
    .m_axil_csr_awvalid(axil_csr_awvalid),
    .m_axil_csr_awready(axil_csr_awready),
    .m_axil_csr_wdata(axil_csr_wdata),
    .m_axil_csr_wstrb(axil_csr_wstrb),
    .m_axil_csr_wvalid(axil_csr_wvalid),
    .m_axil_csr_wready(axil_csr_wready),
    .m_axil_csr_bresp(axil_csr_bresp),
    .m_axil_csr_bvalid(axil_csr_bvalid),
    .m_axil_csr_bready(axil_csr_bready),
    .m_axil_csr_araddr(axil_csr_araddr),
    .m_axil_csr_arprot(axil_csr_arprot),
    .m_axil_csr_arvalid(axil_csr_arvalid),
    .m_axil_csr_arready(axil_csr_arready),
    .m_axil_csr_rdata(axil_csr_rdata),
    .m_axil_csr_rresp(axil_csr_rresp),
    .m_axil_csr_rvalid(axil_csr_rvalid),
    .m_axil_csr_rready(axil_csr_rready),

    /*
     * Control register interface
     */
    .ctrl_reg_wr_addr(ctrl_reg_wr_addr),
    .ctrl_reg_wr_data(ctrl_reg_wr_data),
    .ctrl_reg_wr_strb(ctrl_reg_wr_strb),
    .ctrl_reg_wr_en(ctrl_reg_wr_en),
    .ctrl_reg_wr_wait(ctrl_reg_wr_wait),
    .ctrl_reg_wr_ack(ctrl_reg_wr_ack),
    .ctrl_reg_rd_addr(ctrl_reg_rd_addr),
    .ctrl_reg_rd_en(ctrl_reg_rd_en),
    .ctrl_reg_rd_data(ctrl_reg_rd_data),
    .ctrl_reg_rd_wait(ctrl_reg_rd_wait),
    .ctrl_reg_rd_ack(ctrl_reg_rd_ack),

    /*
     * PTP clock
     */
    .ptp_clk(ptp_clk),
    .ptp_rst(ptp_rst),
    .ptp_sample_clk(ptp_sample_clk),
    .ptp_td_sd(ptp_td_sd),
    .ptp_pps(ptp_pps),
    .ptp_pps_str(ptp_pps_str),
    .ptp_sync_locked(ptp_sync_locked),
    .ptp_sync_ts_rel(ptp_sync_ts_rel),
    .ptp_sync_ts_rel_step(ptp_sync_ts_rel_step),
    .ptp_sync_ts_tod(ptp_sync_ts_tod),
    .ptp_sync_ts_tod_step(ptp_sync_ts_tod_step),
    .ptp_sync_pps(ptp_sync_pps),
    .ptp_sync_pps_str(ptp_sync_pps_str),
    .ptp_perout_locked(ptp_perout_locked),
    .ptp_perout_error(ptp_perout_error),
    .ptp_perout_pulse(ptp_perout_pulse),

    /*
     * Ethernet
     */
    .tx_clk(tx_clk),
    .tx_rst(tx_rst),

    .tx_ptp_clk(0),
    .tx_ptp_rst(0),
    .tx_ptp_ts(tx_ptp_ts),
    .tx_ptp_ts_step(tx_ptp_ts_step),

    .m_axis_tx_tdata(axis_eth_tx_tdata),
    .m_axis_tx_tkeep(axis_eth_tx_tkeep),
    .m_axis_tx_tvalid(axis_eth_tx_tvalid),
    .m_axis_tx_tready(axis_eth_tx_tready),
    .m_axis_tx_tlast(axis_eth_tx_tlast),
    .m_axis_tx_tuser(axis_eth_tx_tuser),

    .s_axis_tx_cpl_ts(axis_eth_tx_ptp_ts),
    .s_axis_tx_cpl_tag(axis_eth_tx_ptp_ts_tag),
    .s_axis_tx_cpl_valid(axis_eth_tx_ptp_ts_valid),
    .s_axis_tx_cpl_ready(axis_eth_tx_ptp_ts_ready),

    .tx_enable(eth_tx_enable),
    .tx_status(eth_tx_status),

    .tx_lfc_en(eth_tx_lfc_en),
    .tx_lfc_req(eth_tx_lfc_req),
    .tx_pfc_en(eth_tx_pfc_en),
    .tx_pfc_req(eth_tx_pfc_req),
    .tx_fc_quanta_clk_en(0),

    .rx_clk(eth_rx_clk),
    .rx_rst(eth_rx_rst),

    .rx_ptp_clk(0),
    .rx_ptp_rst(0),
    .rx_ptp_ts(rx_ptp_ts),
    .rx_ptp_ts_step(rx_ptp_ts_step),

    .s_axis_rx_tdata(axis_eth_rx_tdata),
    .s_axis_rx_tkeep(axis_eth_rx_tkeep),
    .s_axis_rx_tvalid(axis_eth_rx_tvalid),
    .s_axis_rx_tready(axis_eth_rx_tready),
    .s_axis_rx_tlast(axis_eth_rx_tlast),
    .s_axis_rx_tuser(axis_eth_rx_tuser),

    .rx_enable(eth_rx_enable),
    .rx_status(eth_rx_status),
    .rx_lfc_en(eth_rx_lfc_en),
    .rx_lfc_req(eth_rx_lfc_req),
    .rx_lfc_ack(eth_rx_lfc_ack),
    .rx_pfc_en(eth_rx_pfc_en),
    .rx_pfc_req(eth_rx_pfc_req),
    .rx_pfc_ack(eth_rx_pfc_ack),
    .rx_fc_quanta_clk_en(0),

    /*
     * DDR
     */
    .ddr_clk(0),
    .ddr_rst(0),

    .m_axi_ddr_awid(),
    .m_axi_ddr_awaddr(),
    .m_axi_ddr_awlen(),
    .m_axi_ddr_awsize(),
    .m_axi_ddr_awburst(),
    .m_axi_ddr_awlock(),
    .m_axi_ddr_awcache(),
    .m_axi_ddr_awprot(),
    .m_axi_ddr_awqos(),
    .m_axi_ddr_awuser(),
    .m_axi_ddr_awvalid(),
    .m_axi_ddr_awready(0),
    .m_axi_ddr_wdata(),
    .m_axi_ddr_wstrb(),
    .m_axi_ddr_wlast(),
    .m_axi_ddr_wuser(),
    .m_axi_ddr_wvalid(),
    .m_axi_ddr_wready(0),
    .m_axi_ddr_bid(0),
    .m_axi_ddr_bresp(0),
    .m_axi_ddr_buser(0),
    .m_axi_ddr_bvalid(0),
    .m_axi_ddr_bready(),
    .m_axi_ddr_arid(),
    .m_axi_ddr_araddr(),
    .m_axi_ddr_arlen(),
    .m_axi_ddr_arsize(),
    .m_axi_ddr_arburst(),
    .m_axi_ddr_arlock(),
    .m_axi_ddr_arcache(),
    .m_axi_ddr_arprot(),
    .m_axi_ddr_arqos(),
    .m_axi_ddr_aruser(),
    .m_axi_ddr_arvalid(),
    .m_axi_ddr_arready(0),
    .m_axi_ddr_rid(0),
    .m_axi_ddr_rdata(0),
    .m_axi_ddr_rresp(0),
    .m_axi_ddr_rlast(0),
    .m_axi_ddr_ruser(0),
    .m_axi_ddr_rvalid(0),
    .m_axi_ddr_rready(),

    .ddr_status(0),

    /*
     * HBM
     */
    .hbm_clk(0),
    .hbm_rst(0),

    .m_axi_hbm_awid(),
    .m_axi_hbm_awaddr(),
    .m_axi_hbm_awlen(),
    .m_axi_hbm_awsize(),
    .m_axi_hbm_awburst(),
    .m_axi_hbm_awlock(),
    .m_axi_hbm_awcache(),
    .m_axi_hbm_awprot(),
    .m_axi_hbm_awqos(),
    .m_axi_hbm_awuser(),
    .m_axi_hbm_awvalid(),
    .m_axi_hbm_awready(0),
    .m_axi_hbm_wdata(),
    .m_axi_hbm_wstrb(),
    .m_axi_hbm_wlast(),
    .m_axi_hbm_wuser(),
    .m_axi_hbm_wvalid(),
    .m_axi_hbm_wready(0),
    .m_axi_hbm_bid(0),
    .m_axi_hbm_bresp(0),
    .m_axi_hbm_buser(0),
    .m_axi_hbm_bvalid(0),
    .m_axi_hbm_bready(),
    .m_axi_hbm_arid(),
    .m_axi_hbm_araddr(),
    .m_axi_hbm_arlen(),
    .m_axi_hbm_arsize(),
    .m_axi_hbm_arburst(),
    .m_axi_hbm_arlock(),
    .m_axi_hbm_arcache(),
    .m_axi_hbm_arprot(),
    .m_axi_hbm_arqos(),
    .m_axi_hbm_aruser(),
    .m_axi_hbm_arvalid(),
    .m_axi_hbm_arready(0),
    .m_axi_hbm_rid(0),
    .m_axi_hbm_rdata(0),
    .m_axi_hbm_rresp(0),
    .m_axi_hbm_rlast(0),
    .m_axi_hbm_ruser(0),
    .m_axi_hbm_rvalid(0),
    .m_axi_hbm_rready(),

    .hbm_status(0),

    /*
     * Statistics input
     */
    .s_axis_stat_tdata(0),
    .s_axis_stat_tid(0),
    .s_axis_stat_tvalid(1'b0),
    .s_axis_stat_tready(),

    /*
     * GPIO
     */
    .app_gpio_in(0),
    .app_gpio_out(),

    /*
     * JTAG
     */
    .app_jtag_tdi(1'b0),
    .app_jtag_tdo(),
    .app_jtag_tms(1'b0),
    .app_jtag_tck(1'b0)
);

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
    )
    tdma_ber_inst (
        .clk(clk_250mhz),
        .rst(rst_250mhz),
        .phy_tx_clk({sfp_tx_clk}),
        .phy_rx_clk({sfp_rx_clk}),
        .phy_rx_error_count({sfp_rx_error_count}),
        .phy_cfg_tx_prbs31_enable({sfp_cfg_tx_prbs31_enable}),
        .phy_cfg_rx_prbs31_enable({sfp_cfg_rx_prbs31_enable}),
        .s_axil_awaddr(axil_csr_awaddr),
        .s_axil_awprot(axil_csr_awprot),
        .s_axil_awvalid(axil_csr_awvalid),
        .s_axil_awready(axil_csr_awready),
        .s_axil_wdata(axil_csr_wdata),
        .s_axil_wstrb(axil_csr_wstrb),
        .s_axil_wvalid(axil_csr_wvalid),
        .s_axil_wready(axil_csr_wready),
        .s_axil_bresp(axil_csr_bresp),
        .s_axil_bvalid(axil_csr_bvalid),
        .s_axil_bready(axil_csr_bready),
        .s_axil_araddr(axil_csr_araddr),
        .s_axil_arprot(axil_csr_arprot),
        .s_axil_arvalid(axil_csr_arvalid),
        .s_axil_arready(axil_csr_arready),
        .s_axil_rdata(axil_csr_rdata),
        .s_axil_rresp(axil_csr_rresp),
        .s_axil_rvalid(axil_csr_rvalid),
        .s_axil_rready(axil_csr_rready),
        .ptp_ts_96(ptp_sync_ts_tod),
        .ptp_ts_step(ptp_sync_ts_tod_step)
    );

end else begin

    assign sfp_cfg_tx_prbs31_enable = 1'b0;
    assign sfp_cfg_rx_prbs31_enable = 1'b0;

end

endgenerate

endmodule
