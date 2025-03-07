// SPDX-License-Identifier: BSD-2-Clause-Views

 // Copyright (c) 2023 The Regents of the University of California
 // Copyright (c) 2024 - 2025 Analog Devices, Inc. All rights reserved


 // This file repackages Corundum MQNIC Core AXI with the sole purpose of
 // providing it as an IP Core.
 // The original file can be refereed at:
 // https://github.com/ucsdsysnet/corundum/blob/master/fpga/common/rtl/mqnic_core_axi.v


// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none


 // Application block

module application_core #
(
  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // PTP configuration
  parameter PTP_PEROUT_COUNT = 1,

  // Interface configuration
  parameter PTP_TS_ENABLE = 1,
  parameter PTP_TS_FMT_TOD = 1,
  parameter PTP_TS_WIDTH = PTP_TS_FMT_TOD ? 96 : 64,
  parameter TX_TAG_WIDTH = 16,

  // RAM configuration
  parameter DDR_CH = 1,
  parameter AXI_DDR_DATA_WIDTH = 256,
  parameter AXI_DDR_ADDR_WIDTH = 32,
  parameter AXI_DDR_STRB_WIDTH = (AXI_DDR_DATA_WIDTH/8),
  parameter AXI_DDR_ID_WIDTH = 8,
  parameter AXI_DDR_AWUSER_ENABLE = 0,
  parameter AXI_DDR_AWUSER_WIDTH = 1,
  parameter AXI_DDR_WUSER_ENABLE = 0,
  parameter AXI_DDR_WUSER_WIDTH = 1,
  parameter AXI_DDR_BUSER_ENABLE = 0,
  parameter AXI_DDR_BUSER_WIDTH = 1,
  parameter AXI_DDR_ARUSER_ENABLE = 0,
  parameter AXI_DDR_ARUSER_WIDTH = 1,
  parameter AXI_DDR_RUSER_ENABLE = 0,
  parameter AXI_DDR_RUSER_WIDTH = 1,
  parameter HBM_CH = 1,
  parameter AXI_HBM_DATA_WIDTH = 256,
  parameter AXI_HBM_ADDR_WIDTH = 32,
  parameter AXI_HBM_STRB_WIDTH = (AXI_HBM_DATA_WIDTH/8),
  parameter AXI_HBM_ID_WIDTH = 8,
  parameter AXI_HBM_AWUSER_ENABLE = 0,
  parameter AXI_HBM_AWUSER_WIDTH = 1,
  parameter AXI_HBM_WUSER_ENABLE = 0,
  parameter AXI_HBM_WUSER_WIDTH = 1,
  parameter AXI_HBM_BUSER_ENABLE = 0,
  parameter AXI_HBM_BUSER_WIDTH = 1,
  parameter AXI_HBM_ARUSER_ENABLE = 0,
  parameter AXI_HBM_ARUSER_WIDTH = 1,
  parameter AXI_HBM_RUSER_ENABLE = 0,
  parameter AXI_HBM_RUSER_WIDTH = 1,

  // Application configuration
  parameter APP_ID = 32'h12340001,
  parameter APP_GPIO_IN_WIDTH = 32,
  parameter APP_GPIO_OUT_WIDTH = 32,

  // DMA interface configuration
  parameter DMA_ADDR_WIDTH = 64,
  parameter DMA_IMM_WIDTH = 32,
  parameter DMA_LEN_WIDTH = 16,
  parameter DMA_TAG_WIDTH = 16,
  parameter RAM_SEL_WIDTH = 4,
  parameter RAM_ADDR_WIDTH = 16,
  parameter RAM_SEG_COUNT = 2,
  parameter RAM_SEG_DATA_WIDTH = 256*2/RAM_SEG_COUNT,
  parameter RAM_SEG_BE_WIDTH = RAM_SEG_DATA_WIDTH/8,
  parameter RAM_SEG_ADDR_WIDTH = RAM_ADDR_WIDTH-$clog2(RAM_SEG_COUNT*RAM_SEG_BE_WIDTH),

  // AXI lite interface (control to NIC)
  parameter AXIL_CTRL_DATA_WIDTH = 32,
  parameter AXIL_CTRL_ADDR_WIDTH = 16,
  parameter AXIL_CTRL_STRB_WIDTH = (AXIL_CTRL_DATA_WIDTH/8),

  // Ethernet interface configuration (direct, async)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = TX_TAG_WIDTH + 1,
  parameter AXIS_RX_USER_WIDTH = (PTP_TS_ENABLE ? PTP_TS_WIDTH : 0) + 1,

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_SYNC_DATA_WIDTH = AXIS_DATA_WIDTH,
  parameter AXIS_SYNC_KEEP_WIDTH = AXIS_SYNC_DATA_WIDTH/8,
  parameter AXIS_SYNC_TX_USER_WIDTH = AXIS_TX_USER_WIDTH,
  parameter AXIS_SYNC_RX_USER_WIDTH = AXIS_RX_USER_WIDTH,

  // Ethernet interface configuration (interface)
  parameter AXIS_IF_DATA_WIDTH = AXIS_SYNC_DATA_WIDTH*2**$clog2(PORTS_PER_IF),
  parameter AXIS_IF_KEEP_WIDTH = AXIS_IF_DATA_WIDTH/8,
  parameter AXIS_IF_TX_ID_WIDTH = 12,
  parameter AXIS_IF_RX_ID_WIDTH = PORTS_PER_IF > 1 ? $clog2(PORTS_PER_IF) : 1,
  parameter AXIS_IF_TX_DEST_WIDTH = $clog2(PORTS_PER_IF)+4,
  parameter AXIS_IF_RX_DEST_WIDTH = 8,
  parameter AXIS_IF_TX_USER_WIDTH = AXIS_SYNC_TX_USER_WIDTH,
  parameter AXIS_IF_RX_USER_WIDTH = AXIS_SYNC_RX_USER_WIDTH,

  // Statistics counter subsystem
  parameter STAT_INC_WIDTH = 24,
  parameter STAT_ID_WIDTH = 12,

  // Input stream
  parameter INPUT_WIDTH = 2048,
  parameter JESD_M = 4
)
(
  input  wire                                           clk,
  input  wire                                           rst,

  // AXI-Lite slave interface (control from host)
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]                s_axil_ctrl_awaddr,
  input  wire [2:0]                                     s_axil_ctrl_awprot,
  input  wire                                           s_axil_ctrl_awvalid,
  output wire                                           s_axil_ctrl_awready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]                s_axil_ctrl_wdata,
  input  wire [AXIL_CTRL_STRB_WIDTH-1:0]                s_axil_ctrl_wstrb,
  input  wire                                           s_axil_ctrl_wvalid,
  output wire                                           s_axil_ctrl_wready,
  output wire [1:0]                                     s_axil_ctrl_bresp,
  output wire                                           s_axil_ctrl_bvalid,
  input  wire                                           s_axil_ctrl_bready,
  input  wire [AXIL_CTRL_ADDR_WIDTH-1:0]                s_axil_ctrl_araddr,
  input  wire [2:0]                                     s_axil_ctrl_arprot,
  input  wire                                           s_axil_ctrl_arvalid,
  output wire                                           s_axil_ctrl_arready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]                s_axil_ctrl_rdata,
  output wire [1:0]                                     s_axil_ctrl_rresp,
  output wire                                           s_axil_ctrl_rvalid,
  input  wire                                           s_axil_ctrl_rready,

  // AXI-Lite master interface (control to NIC)
  output wire [AXIL_CTRL_ADDR_WIDTH-1:0]                m_axil_ctrl_awaddr,
  output wire [2:0]                                     m_axil_ctrl_awprot,
  output wire                                           m_axil_ctrl_awvalid,
  input  wire                                           m_axil_ctrl_awready,
  output wire [AXIL_CTRL_DATA_WIDTH-1:0]                m_axil_ctrl_wdata,
  output wire [AXIL_CTRL_STRB_WIDTH-1:0]                m_axil_ctrl_wstrb,
  output wire                                           m_axil_ctrl_wvalid,
  input  wire                                           m_axil_ctrl_wready,
  input  wire [1:0]                                     m_axil_ctrl_bresp,
  input  wire                                           m_axil_ctrl_bvalid,
  output wire                                           m_axil_ctrl_bready,
  output wire [AXIL_CTRL_ADDR_WIDTH-1:0]                m_axil_ctrl_araddr,
  output wire [2:0]                                     m_axil_ctrl_arprot,
  output wire                                           m_axil_ctrl_arvalid,
  input  wire                                           m_axil_ctrl_arready,
  input  wire [AXIL_CTRL_DATA_WIDTH-1:0]                m_axil_ctrl_rdata,
  input  wire [1:0]                                     m_axil_ctrl_rresp,
  input  wire                                           m_axil_ctrl_rvalid,
  output wire                                           m_axil_ctrl_rready,

  // DMA read descriptor output (control)
  output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_read_desc_dma_addr,
  output wire [RAM_SEL_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_ram_sel,
  output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_read_desc_ram_addr,
  output wire [DMA_LEN_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_len,
  output wire [DMA_TAG_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_tag,
  output wire                                           m_axis_ctrl_dma_read_desc_valid,
  input  wire                                           m_axis_ctrl_dma_read_desc_ready,

  // DMA read descriptor status input (control)
  input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_ctrl_dma_read_desc_status_tag,
  input  wire [3:0]                                     s_axis_ctrl_dma_read_desc_status_error,
  input  wire                                           s_axis_ctrl_dma_read_desc_status_valid,

  // DMA write descriptor output (control)
  output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_write_desc_dma_addr,
  output wire [RAM_SEL_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_ram_sel,
  output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_write_desc_ram_addr,
  output wire [DMA_IMM_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_imm,
  output wire                                           m_axis_ctrl_dma_write_desc_imm_en,
  output wire [DMA_LEN_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_len,
  output wire [DMA_TAG_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_tag,
  output wire                                           m_axis_ctrl_dma_write_desc_valid,
  input  wire                                           m_axis_ctrl_dma_write_desc_ready,

  // DMA write descriptor status input (control)
  input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_ctrl_dma_write_desc_status_tag,
  input  wire [3:0]                                     s_axis_ctrl_dma_write_desc_status_error,
  input  wire                                           s_axis_ctrl_dma_write_desc_status_valid,

  // DMA read descriptor output (data)
  output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_data_dma_read_desc_dma_addr,
  output wire [RAM_SEL_WIDTH-1:0]                       m_axis_data_dma_read_desc_ram_sel,
  output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_data_dma_read_desc_ram_addr,
  output wire [DMA_LEN_WIDTH-1:0]                       m_axis_data_dma_read_desc_len,
  output wire [DMA_TAG_WIDTH-1:0]                       m_axis_data_dma_read_desc_tag,
  output wire                                           m_axis_data_dma_read_desc_valid,
  input  wire                                           m_axis_data_dma_read_desc_ready,

  // DMA read descriptor status input (data)
  input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_data_dma_read_desc_status_tag,
  input  wire [3:0]                                     s_axis_data_dma_read_desc_status_error,
  input  wire                                           s_axis_data_dma_read_desc_status_valid,

  // DMA write descriptor output (data)
  output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_data_dma_write_desc_dma_addr,
  output wire [RAM_SEL_WIDTH-1:0]                       m_axis_data_dma_write_desc_ram_sel,
  output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_data_dma_write_desc_ram_addr,
  output wire [DMA_IMM_WIDTH-1:0]                       m_axis_data_dma_write_desc_imm,
  output wire                                           m_axis_data_dma_write_desc_imm_en,
  output wire [DMA_LEN_WIDTH-1:0]                       m_axis_data_dma_write_desc_len,
  output wire [DMA_TAG_WIDTH-1:0]                       m_axis_data_dma_write_desc_tag,
  output wire                                           m_axis_data_dma_write_desc_valid,
  input  wire                                           m_axis_data_dma_write_desc_ready,

  // DMA write descriptor status input (data)
  input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_data_dma_write_desc_status_tag,
  input  wire [3:0]                                     s_axis_data_dma_write_desc_status_error,
  input  wire                                           s_axis_data_dma_write_desc_status_valid,

  // DMA RAM interface (control)
  input  wire [RAM_SEG_COUNT*RAM_SEL_WIDTH-1:0]         ctrl_dma_ram_wr_cmd_sel,
  input  wire [RAM_SEG_COUNT*RAM_SEG_BE_WIDTH-1:0]      ctrl_dma_ram_wr_cmd_be,
  input  wire [RAM_SEG_COUNT*RAM_SEG_ADDR_WIDTH-1:0]    ctrl_dma_ram_wr_cmd_addr,
  input  wire [RAM_SEG_COUNT*RAM_SEG_DATA_WIDTH-1:0]    ctrl_dma_ram_wr_cmd_data,
  input  wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_wr_cmd_valid,
  output wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_wr_cmd_ready,
  output wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_wr_done,
  input  wire [RAM_SEG_COUNT*RAM_SEL_WIDTH-1:0]         ctrl_dma_ram_rd_cmd_sel,
  input  wire [RAM_SEG_COUNT*RAM_SEG_ADDR_WIDTH-1:0]    ctrl_dma_ram_rd_cmd_addr,
  input  wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_rd_cmd_valid,
  output wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_rd_cmd_ready,
  output wire [RAM_SEG_COUNT*RAM_SEG_DATA_WIDTH-1:0]    ctrl_dma_ram_rd_resp_data,
  output wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_rd_resp_valid,
  input  wire [RAM_SEG_COUNT-1:0]                       ctrl_dma_ram_rd_resp_ready,

  // DMA RAM interface (data)
  input  wire [RAM_SEG_COUNT*RAM_SEL_WIDTH-1:0]         data_dma_ram_wr_cmd_sel,
  input  wire [RAM_SEG_COUNT*RAM_SEG_BE_WIDTH-1:0]      data_dma_ram_wr_cmd_be,
  input  wire [RAM_SEG_COUNT*RAM_SEG_ADDR_WIDTH-1:0]    data_dma_ram_wr_cmd_addr,
  input  wire [RAM_SEG_COUNT*RAM_SEG_DATA_WIDTH-1:0]    data_dma_ram_wr_cmd_data,
  input  wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_wr_cmd_valid,
  output wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_wr_cmd_ready,
  output wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_wr_done,
  input  wire [RAM_SEG_COUNT*RAM_SEL_WIDTH-1:0]         data_dma_ram_rd_cmd_sel,
  input  wire [RAM_SEG_COUNT*RAM_SEG_ADDR_WIDTH-1:0]    data_dma_ram_rd_cmd_addr,
  input  wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_rd_cmd_valid,
  output wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_rd_cmd_ready,
  output wire [RAM_SEG_COUNT*RAM_SEG_DATA_WIDTH-1:0]    data_dma_ram_rd_resp_data,
  output wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_rd_resp_valid,
  input  wire [RAM_SEG_COUNT-1:0]                       data_dma_ram_rd_resp_ready,

  // PTP clock
  input  wire                                           ptp_clk,
  input  wire                                           ptp_rst,
  input  wire                                           ptp_sample_clk,
  input  wire                                           ptp_td_sd,
  input  wire                                           ptp_pps,
  input  wire                                           ptp_pps_str,
  input  wire                                           ptp_sync_locked,
  input  wire [PTP_TS_WIDTH-1:0]                        ptp_sync_ts_rel,
  input  wire                                           ptp_sync_ts_rel_step,
  input  wire [PTP_TS_WIDTH-1:0]                        ptp_sync_ts_tod,
  input  wire                                           ptp_sync_ts_tod_step,
  input  wire                                           ptp_sync_pps,
  input  wire                                           ptp_sync_pps_str,
  input  wire [PTP_PEROUT_COUNT-1:0]                    ptp_perout_locked,
  input  wire [PTP_PEROUT_COUNT-1:0]                    ptp_perout_error,
  input  wire [PTP_PEROUT_COUNT-1:0]                    ptp_perout_pulse,

  // Ethernet (direct MAC interface - lowest latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_tx_clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_tx_rst,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          s_axis_direct_tx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          s_axis_direct_tx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]       s_axis_direct_tx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_direct_tx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_direct_tx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]       m_axis_direct_tx_tuser,

  input  wire [IF_COUNT*PORTS_PER_IF*PTP_TS_WIDTH-1:0]             s_axis_direct_tx_cpl_ts,
  input  wire [IF_COUNT*PORTS_PER_IF*TX_TAG_WIDTH-1:0]             s_axis_direct_tx_cpl_tag,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_cpl_valid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_cpl_ready,

  output wire [IF_COUNT*PORTS_PER_IF*PTP_TS_WIDTH-1:0]             m_axis_direct_tx_cpl_ts,
  output wire [IF_COUNT*PORTS_PER_IF*TX_TAG_WIDTH-1:0]             m_axis_direct_tx_cpl_tag,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_cpl_valid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_cpl_ready,

  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_rst,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          s_axis_direct_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          s_axis_direct_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       s_axis_direct_rx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_direct_rx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_direct_rx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       m_axis_direct_rx_tuser,

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_DATA_WIDTH-1:0]     s_axis_sync_tx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_KEEP_WIDTH-1:0]     s_axis_sync_tx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_TX_USER_WIDTH-1:0]  s_axis_sync_tx_tuser,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_DATA_WIDTH-1:0]     m_axis_sync_tx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_KEEP_WIDTH-1:0]     m_axis_sync_tx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_tx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_tx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_tx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_TX_USER_WIDTH-1:0]  m_axis_sync_tx_tuser,

  input  wire [IF_COUNT*PORTS_PER_IF*PTP_TS_WIDTH-1:0]             s_axis_sync_tx_cpl_ts,
  input  wire [IF_COUNT*PORTS_PER_IF*TX_TAG_WIDTH-1:0]             s_axis_sync_tx_cpl_tag,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_cpl_valid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_cpl_ready,

  output wire [IF_COUNT*PORTS_PER_IF*PTP_TS_WIDTH-1:0]             m_axis_sync_tx_cpl_ts,
  output wire [IF_COUNT*PORTS_PER_IF*TX_TAG_WIDTH-1:0]             m_axis_sync_tx_cpl_tag,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_tx_cpl_valid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_tx_cpl_ready,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_DATA_WIDTH-1:0]     s_axis_sync_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_KEEP_WIDTH-1:0]     s_axis_sync_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_rx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_RX_USER_WIDTH-1:0]  s_axis_sync_rx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_DATA_WIDTH-1:0]     m_axis_sync_rx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_KEEP_WIDTH-1:0]     m_axis_sync_rx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_rx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_sync_rx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_RX_USER_WIDTH-1:0]  m_axis_sync_rx_tuser,

  // Ethernet (internal at interface module)
  input  wire [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]         s_axis_if_tx_tdata,
  input  wire [IF_COUNT*AXIS_IF_KEEP_WIDTH-1:0]         s_axis_if_tx_tkeep,
  input  wire [IF_COUNT-1:0]                            s_axis_if_tx_tvalid,
  output wire [IF_COUNT-1:0]                            s_axis_if_tx_tready,
  input  wire [IF_COUNT-1:0]                            s_axis_if_tx_tlast,
  input  wire [IF_COUNT*AXIS_IF_TX_ID_WIDTH-1:0]        s_axis_if_tx_tid,
  input  wire [IF_COUNT*AXIS_IF_TX_DEST_WIDTH-1:0]      s_axis_if_tx_tdest,
  input  wire [IF_COUNT*AXIS_IF_TX_USER_WIDTH-1:0]      s_axis_if_tx_tuser,

  output wire [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]         m_axis_if_tx_tdata,
  output wire [IF_COUNT*AXIS_IF_KEEP_WIDTH-1:0]         m_axis_if_tx_tkeep,
  output wire [IF_COUNT-1:0]                            m_axis_if_tx_tvalid,
  input  wire [IF_COUNT-1:0]                            m_axis_if_tx_tready,
  output wire [IF_COUNT-1:0]                            m_axis_if_tx_tlast,
  output wire [IF_COUNT*AXIS_IF_TX_ID_WIDTH-1:0]        m_axis_if_tx_tid,
  output wire [IF_COUNT*AXIS_IF_TX_DEST_WIDTH-1:0]      m_axis_if_tx_tdest,
  output wire [IF_COUNT*AXIS_IF_TX_USER_WIDTH-1:0]      m_axis_if_tx_tuser,

  input  wire [IF_COUNT*PTP_TS_WIDTH-1:0]               s_axis_if_tx_cpl_ts,
  input  wire [IF_COUNT*TX_TAG_WIDTH-1:0]               s_axis_if_tx_cpl_tag,
  input  wire [IF_COUNT-1:0]                            s_axis_if_tx_cpl_valid,
  output wire [IF_COUNT-1:0]                            s_axis_if_tx_cpl_ready,

  output wire [IF_COUNT*PTP_TS_WIDTH-1:0]               m_axis_if_tx_cpl_ts,
  output wire [IF_COUNT*TX_TAG_WIDTH-1:0]               m_axis_if_tx_cpl_tag,
  output wire [IF_COUNT-1:0]                            m_axis_if_tx_cpl_valid,
  input  wire [IF_COUNT-1:0]                            m_axis_if_tx_cpl_ready,

  input  wire [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]         s_axis_if_rx_tdata,
  input  wire [IF_COUNT*AXIS_IF_KEEP_WIDTH-1:0]         s_axis_if_rx_tkeep,
  input  wire [IF_COUNT-1:0]                            s_axis_if_rx_tvalid,
  output wire [IF_COUNT-1:0]                            s_axis_if_rx_tready,
  input  wire [IF_COUNT-1:0]                            s_axis_if_rx_tlast,
  input  wire [IF_COUNT*AXIS_IF_RX_ID_WIDTH-1:0]        s_axis_if_rx_tid,
  input  wire [IF_COUNT*AXIS_IF_RX_DEST_WIDTH-1:0]      s_axis_if_rx_tdest,
  input  wire [IF_COUNT*AXIS_IF_RX_USER_WIDTH-1:0]      s_axis_if_rx_tuser,

  output wire [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]         m_axis_if_rx_tdata,
  output wire [IF_COUNT*AXIS_IF_KEEP_WIDTH-1:0]         m_axis_if_rx_tkeep,
  output wire [IF_COUNT-1:0]                            m_axis_if_rx_tvalid,
  input  wire [IF_COUNT-1:0]                            m_axis_if_rx_tready,
  output wire [IF_COUNT-1:0]                            m_axis_if_rx_tlast,
  output wire [IF_COUNT*AXIS_IF_RX_ID_WIDTH-1:0]        m_axis_if_rx_tid,
  output wire [IF_COUNT*AXIS_IF_RX_DEST_WIDTH-1:0]      m_axis_if_rx_tdest,
  output wire [IF_COUNT*AXIS_IF_RX_USER_WIDTH-1:0]      m_axis_if_rx_tuser,

  // DDR
  input  wire [DDR_CH-1:0]                              ddr_clk,
  input  wire [DDR_CH-1:0]                              ddr_rst,

  output wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]             m_axi_ddr_awid,
  output wire [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]           m_axi_ddr_awaddr,
  output wire [DDR_CH*8-1:0]                            m_axi_ddr_awlen,
  output wire [DDR_CH*3-1:0]                            m_axi_ddr_awsize,
  output wire [DDR_CH*2-1:0]                            m_axi_ddr_awburst,
  output wire [DDR_CH-1:0]                              m_axi_ddr_awlock,
  output wire [DDR_CH*4-1:0]                            m_axi_ddr_awcache,
  output wire [DDR_CH*3-1:0]                            m_axi_ddr_awprot,
  output wire [DDR_CH*4-1:0]                            m_axi_ddr_awqos,
  output wire [DDR_CH*AXI_DDR_AWUSER_WIDTH-1:0]         m_axi_ddr_awuser,
  output wire [DDR_CH-1:0]                              m_axi_ddr_awvalid,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_awready,
  output wire [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]           m_axi_ddr_wdata,
  output wire [DDR_CH*AXI_DDR_STRB_WIDTH-1:0]           m_axi_ddr_wstrb,
  output wire [DDR_CH-1:0]                              m_axi_ddr_wlast,
  output wire [DDR_CH*AXI_DDR_WUSER_WIDTH-1:0]          m_axi_ddr_wuser,
  output wire [DDR_CH-1:0]                              m_axi_ddr_wvalid,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_wready,
  input  wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]             m_axi_ddr_bid,
  input  wire [DDR_CH*2-1:0]                            m_axi_ddr_bresp,
  input  wire [DDR_CH*AXI_DDR_BUSER_WIDTH-1:0]          m_axi_ddr_buser,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_bvalid,
  output wire [DDR_CH-1:0]                              m_axi_ddr_bready,
  output wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]             m_axi_ddr_arid,
  output wire [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]           m_axi_ddr_araddr,
  output wire [DDR_CH*8-1:0]                            m_axi_ddr_arlen,
  output wire [DDR_CH*3-1:0]                            m_axi_ddr_arsize,
  output wire [DDR_CH*2-1:0]                            m_axi_ddr_arburst,
  output wire [DDR_CH-1:0]                              m_axi_ddr_arlock,
  output wire [DDR_CH*4-1:0]                            m_axi_ddr_arcache,
  output wire [DDR_CH*3-1:0]                            m_axi_ddr_arprot,
  output wire [DDR_CH*4-1:0]                            m_axi_ddr_arqos,
  output wire [DDR_CH*AXI_DDR_ARUSER_WIDTH-1:0]         m_axi_ddr_aruser,
  output wire [DDR_CH-1:0]                              m_axi_ddr_arvalid,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_arready,
  input  wire [DDR_CH*AXI_DDR_ID_WIDTH-1:0]             m_axi_ddr_rid,
  input  wire [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]           m_axi_ddr_rdata,
  input  wire [DDR_CH*2-1:0]                            m_axi_ddr_rresp,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_rlast,
  input  wire [DDR_CH*AXI_DDR_RUSER_WIDTH-1:0]          m_axi_ddr_ruser,
  input  wire [DDR_CH-1:0]                              m_axi_ddr_rvalid,
  output wire [DDR_CH-1:0]                              m_axi_ddr_rready,

  input  wire [DDR_CH-1:0]                              ddr_status,

  // HBM
  input  wire [HBM_CH-1:0]                              hbm_clk,
  input  wire [HBM_CH-1:0]                              hbm_rst,

  output wire [HBM_CH*AXI_HBM_ID_WIDTH-1:0]             m_axi_hbm_awid,
  output wire [HBM_CH*AXI_HBM_ADDR_WIDTH-1:0]           m_axi_hbm_awaddr,
  output wire [HBM_CH*8-1:0]                            m_axi_hbm_awlen,
  output wire [HBM_CH*3-1:0]                            m_axi_hbm_awsize,
  output wire [HBM_CH*2-1:0]                            m_axi_hbm_awburst,
  output wire [HBM_CH-1:0]                              m_axi_hbm_awlock,
  output wire [HBM_CH*4-1:0]                            m_axi_hbm_awcache,
  output wire [HBM_CH*3-1:0]                            m_axi_hbm_awprot,
  output wire [HBM_CH*4-1:0]                            m_axi_hbm_awqos,
  output wire [HBM_CH*AXI_HBM_AWUSER_WIDTH-1:0]         m_axi_hbm_awuser,
  output wire [HBM_CH-1:0]                              m_axi_hbm_awvalid,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_awready,
  output wire [HBM_CH*AXI_HBM_DATA_WIDTH-1:0]           m_axi_hbm_wdata,
  output wire [HBM_CH*AXI_HBM_STRB_WIDTH-1:0]           m_axi_hbm_wstrb,
  output wire [HBM_CH-1:0]                              m_axi_hbm_wlast,
  output wire [HBM_CH*AXI_HBM_WUSER_WIDTH-1:0]          m_axi_hbm_wuser,
  output wire [HBM_CH-1:0]                              m_axi_hbm_wvalid,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_wready,
  input  wire [HBM_CH*AXI_HBM_ID_WIDTH-1:0]             m_axi_hbm_bid,
  input  wire [HBM_CH*2-1:0]                            m_axi_hbm_bresp,
  input  wire [HBM_CH*AXI_HBM_BUSER_WIDTH-1:0]          m_axi_hbm_buser,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_bvalid,
  output wire [HBM_CH-1:0]                              m_axi_hbm_bready,
  output wire [HBM_CH*AXI_HBM_ID_WIDTH-1:0]             m_axi_hbm_arid,
  output wire [HBM_CH*AXI_HBM_ADDR_WIDTH-1:0]           m_axi_hbm_araddr,
  output wire [HBM_CH*8-1:0]                            m_axi_hbm_arlen,
  output wire [HBM_CH*3-1:0]                            m_axi_hbm_arsize,
  output wire [HBM_CH*2-1:0]                            m_axi_hbm_arburst,
  output wire [HBM_CH-1:0]                              m_axi_hbm_arlock,
  output wire [HBM_CH*4-1:0]                            m_axi_hbm_arcache,
  output wire [HBM_CH*3-1:0]                            m_axi_hbm_arprot,
  output wire [HBM_CH*4-1:0]                            m_axi_hbm_arqos,
  output wire [HBM_CH*AXI_HBM_ARUSER_WIDTH-1:0]         m_axi_hbm_aruser,
  output wire [HBM_CH-1:0]                              m_axi_hbm_arvalid,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_arready,
  input  wire [HBM_CH*AXI_HBM_ID_WIDTH-1:0]             m_axi_hbm_rid,
  input  wire [HBM_CH*AXI_HBM_DATA_WIDTH-1:0]           m_axi_hbm_rdata,
  input  wire [HBM_CH*2-1:0]                            m_axi_hbm_rresp,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_rlast,
  input  wire [HBM_CH*AXI_HBM_RUSER_WIDTH-1:0]          m_axi_hbm_ruser,
  input  wire [HBM_CH-1:0]                              m_axi_hbm_rvalid,
  output wire [HBM_CH-1:0]                              m_axi_hbm_rready,

  input  wire [HBM_CH-1:0]                              hbm_status,

  // Statistics increment output
  output wire [STAT_INC_WIDTH-1:0]                      m_axis_stat_tdata,
  output wire [STAT_ID_WIDTH-1:0]                       m_axis_stat_tid,
  output wire                                           m_axis_stat_tvalid,
  input  wire                                           m_axis_stat_tready,

  // GPIO
  input  wire [APP_GPIO_IN_WIDTH-1:0]                   gpio_in,
  output wire [APP_GPIO_OUT_WIDTH-1:0]                  gpio_out,

  // JTAG
  input  wire                                           jtag_tdi,
  output wire                                           jtag_tdo,
  input  wire                                           jtag_tms,
  input  wire                                           jtag_tck,

  // Input data
  input  wire                                           input_clk,
  input  wire                                           input_rstn,

  input  wire [INPUT_WIDTH-1:0]                         input_axis_tdata,
  input  wire                                           input_axis_tvalid,
  output wire                                           input_axis_tready,

  input  wire [JESD_M-1:0]                              input_enable
);

  // check configuration
  initial begin
    if (APP_ID != 32'h12340001) begin
      $error("Error: Invalid APP_ID (expected 32'h12340001, got 32'h%x) (instance %m)", APP_ID);
      $finish;
    end
  end

  wire rstn;

  ad_rst ad_rst_fifo_rstn_m(
    .rst_async(rst),
    .clk(clk),
    .rst(),
    .rstn(rstn)
  );

  ////----------------------------------------Data generation---------------//
  //////////////////////////////////////////////////
  // reg  [7:0]             gen_data;

  // reg  [INPUT_WIDTH-1:0] input_axis_tdata;
  // reg                    input_axis_tvalid;
  // wire                   input_axis_tready;

  // always @(posedge input_clk)
  // begin
  //   if (!input_rstn) begin
  //     gen_data <= 8'd0;
  //   end else begin
  //     if (input_axis_tready) begin
  //       gen_data <= gen_data + 1;
  //     end
  //   end
  // end

  // always @(posedge input_clk)
  // begin
  //   if (!input_rstn) begin
  //     input_axis_tdata <= {INPUT_WIDTH{1'b0}};
  //     input_axis_tvalid <= 1'b0;
  //   end else begin
  //     input_axis_tdata <= {INPUT_WIDTH/8{gen_data}};
  //     input_axis_tvalid <= 1'b1;
  //   end
  // end

  ////----------------------------------------Start application---------------//
  //////////////////////////////////////////////////
  wire start_app;
  reg  run_packetizer;
  wire run_packetizer_cdc;

  wire input_rstn_gated;
  wire rstn_gated;

  wire input_axis_tready_buffered;

  reg  packet_tlast;

  always @(posedge clk)
  begin
    if (rst) begin
      run_packetizer <= 1'b0;
    end else begin
      if (start_app) begin
        run_packetizer <= 1'b1;
      end else if (packet_tlast) begin
        run_packetizer <= 1'b0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_run_packetizer (
    .in_bits(run_packetizer),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(run_packetizer_cdc)
  );

  assign input_rstn_gated = input_rstn && run_packetizer_cdc;
  assign rstn_gated = rstn && run_packetizer;

  assign input_axis_tready = input_axis_tready_buffered && run_packetizer_cdc;

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////
  wire                       cdc_axis_tvalid;
  wire                       cdc_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0] cdc_axis_tdata;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(INPUT_WIDTH),
    .ADDRESS_WIDTH($clog2(8192/INPUT_WIDTH)+1),
    .M_DATA_WIDTH(AXIS_DATA_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
    .TLAST_EN(0),
    .TKEEP_EN(0),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) cdc_scale_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn_gated),
    .m_axis_ready(cdc_axis_tready),
    .m_axis_valid(cdc_axis_tvalid),
    .m_axis_data(cdc_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_level(),

    .s_axis_aclk(input_clk),
    .s_axis_aresetn(input_rstn_gated),
    .s_axis_ready(input_axis_tready_buffered),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep({INPUT_WIDTH/8{1'b0}}),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .s_axis_room());

  ////----------------------------------------Packetizer--------------------//
  //////////////////////////////////////////////////
  reg  [15:0] sample_counter;
  wire [15:0] packet_size;
  reg  [15:0] packet_size_dynamic;
  wire [15:0] packet_size_dynamic_calc;

  reg  [JESD_M-1:0] input_enable_old;
  reg               input_enable_ff;
  wire              input_enable_ff_cdc;
  reg               input_enable_ff_cdc2;
  reg  [JESD_M-1:0] input_enable_cdc;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_enable_ff <= 1'b0;
    end else begin
      input_enable_old <= input_enable;
      if (input_enable_old != input_enable) begin
        input_enable_ff <= ~input_enable_ff;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_input_enable_ff (
    .in_bits(input_enable_ff),
    .out_resetn(rstn),
    .out_clk(clk),
    .out_bits(input_enable_ff_cdc)
  );

  always @(posedge clk)
  begin
    if (!rstn) begin
      input_enable_ff_cdc2 <= 1'b0;
    end else begin
      input_enable_ff_cdc2 <= input_enable_ff_cdc;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      input_enable_cdc <= {JESD_M{1'b0}};
    end else begin
      if (input_enable_ff_cdc2 ^ input_enable_ff_cdc) begin
        input_enable_cdc <= input_enable;
      end
    end
  end

  function [$clog2(JESD_M):0] converters(input [JESD_M-1:0] input_enable);
    integer i;
    begin
      converters = 0;
      for (i=0; i<JESD_M; i=i+1) begin
        converters = converters + input_enable[i];
      end
    end
  endfunction

  assign packet_size_dynamic_calc = (packet_size/AXIS_DATA_WIDTH*8/(2**$clog2(JESD_M)))*converters(input_enable_cdc);

  always @(posedge clk)
  begin
    if (!rstn) begin
      packet_size_dynamic <= packet_size;
    end else begin
      packet_size_dynamic <= packet_size_dynamic_calc;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      sample_counter <= 8'd0;
      packet_tlast <= 1'b0;
    end else begin
      if (cdc_axis_tvalid && cdc_axis_tready) begin
        if (sample_counter < packet_size_dynamic-1) begin
          sample_counter <= sample_counter + 1;
        end else begin
          sample_counter <= 8'd0;
          packet_tlast <= 1'b1;
        end
      end else begin
        packet_tlast <= 1'b0;
      end
    end
  end

  ////----------------------------------------Header Inserter---------------//
  //////////////////////////////////////////////////
  wire                         packet_axis_tready;
  wire                         packet_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0]   packet_axis_tdata;
  wire [AXIS_DATA_WIDTH/8-1:0] packet_axis_tkeep;
  wire                         packet_axis_tlast;

  reg                          packet_buffer_axis_tready;
  wire                         packet_buffer_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0]   packet_buffer_axis_tdata;
  wire                         packet_buffer_axis_tlast;
  wire [AXIS_DATA_WIDTH/8-1:0] packet_buffer_axis_tkeep;


  // Ethernet header
  wire [48-1:0] ethernet_destination_MAC;
  wire [48-1:0] ethernet_source_MAC;
  wire [16-1:0] ethernet_type;

  // IPv4 header
  wire [4-1:0]  ip_version;
  wire [4-1:0]  ip_header_length;
  wire [8-1:0]  ip_type_of_service;
  wire [16-1:0] ip_total_length;
  wire [16-1:0] ip_identification;
  wire [3-1:0]  ip_flags;
  wire [13-1:0] ip_fragment_offset;
  wire [8-1:0]  ip_time_to_live;
  wire [8-1:0]  ip_protocol;
  wire [16-1:0] ip_header_checksum;
  wire [32-1:0] ip_source_IP_address;
  wire [32-1:0] ip_destination_IP_address;

  // UDP header
  wire [16-1:0] udp_source;
  wire [16-1:0] udp_destination;
  wire [16-1:0] udp_length;
  wire [16-1:0] udp_checksum;

  wire packet_sent;

  assign packet_sent = packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast;

  header_inserter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .INPUT_WIDTH(INPUT_WIDTH)
  ) header_inserter_inst (
    .clk(clk),
    .rstn(rstn),
    .ethernet_destination_MAC(ethernet_destination_MAC),
    .ethernet_source_MAC(ethernet_source_MAC),
    .ethernet_type(ethernet_type),
    .ip_version(ip_version),
    .ip_header_length(ip_header_length),
    .ip_type_of_service(ip_type_of_service),
    .ip_total_length(ip_total_length),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_header_checksum(ip_header_checksum),
    .ip_source_IP_address(ip_source_IP_address),
    .ip_destination_IP_address(ip_destination_IP_address),
    .udp_source(udp_source),
    .udp_destination(udp_destination),
    .udp_length(udp_length),
    .udp_checksum(udp_checksum),
    .packet_size(packet_size),
    .run_packetizer(run_packetizer),
    .packet_sent(packet_sent),
    .input_tvalid(cdc_axis_tvalid),
    .input_tready(cdc_axis_tready),
    .input_tdata(cdc_axis_tdata),
    .packet_tlast(packet_tlast),
    .output_tready(packet_axis_tready),
    .output_tvalid(packet_axis_tvalid),
    .output_tdata(packet_axis_tdata),
    .output_tkeep(packet_axis_tkeep),
    .output_tlast(packet_axis_tlast));

  ////----------------------------------------Packet Buffer FIFO----------------------//
  //////////////////////////////////////////////////
  wire packet_buffer_almost_full;
  wire packet_buffer_almost_empty;

  wire packet_fifo_rstn;

  assign packet_fifo_rstn = rstn && !(!run_packetizer && packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast);

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(8192/AXIS_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .ALMOST_FULL_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) packet_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(packet_fifo_rstn),
    .m_axis_ready(packet_buffer_axis_tready),
    .m_axis_valid(packet_buffer_axis_tvalid),
    .m_axis_data(packet_buffer_axis_tdata),
    .m_axis_tkeep(packet_buffer_axis_tkeep),
    .m_axis_tlast(packet_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(packet_buffer_almost_empty),

    .s_axis_aclk(clk),
    .s_axis_aresetn(packet_fifo_rstn),
    .s_axis_ready(packet_axis_tready),
    .s_axis_valid(packet_axis_tvalid),
    .s_axis_data(packet_axis_tdata),
    .s_axis_tkeep(packet_axis_tkeep),
    .s_axis_tlast(packet_axis_tlast),
    .s_axis_room(),
    .s_axis_full(),
    .s_axis_almost_full(packet_buffer_almost_full));

  ////----------------------------------------OS Buffer FIFO----------------------//
  //////////////////////////////////////////////////
  reg                                os_buffer_axis_tready;
  wire                               os_buffer_axis_tvalid;
  wire [AXIS_SYNC_DATA_WIDTH-1:0]    os_buffer_axis_tdata;
  wire                               os_buffer_axis_tlast;
  wire [AXIS_SYNC_DATA_WIDTH/8-1:0]  os_buffer_axis_tkeep;
  wire [AXIS_SYNC_TX_USER_WIDTH-1:0] os_buffer_axis_tuser;

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_SYNC_DATA_WIDTH/8*9 + AXIS_SYNC_TX_USER_WIDTH),
    .ADDRESS_WIDTH($clog2(12288/AXIS_SYNC_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(0),
    .REMOVE_NULL_BEAT_EN(0)
  ) os_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(os_buffer_axis_tready),
    .m_axis_valid(os_buffer_axis_tvalid),
    .m_axis_data({os_buffer_axis_tdata, os_buffer_axis_tkeep, os_buffer_axis_tuser}),
    .m_axis_tkeep(),
    .m_axis_tlast(os_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(s_axis_sync_tx_tready),
    .s_axis_valid(s_axis_sync_tx_tvalid),
    .s_axis_data({s_axis_sync_tx_tdata, s_axis_sync_tx_tkeep, s_axis_sync_tx_tuser}),
    .s_axis_tkeep(),
    .s_axis_tlast(s_axis_sync_tx_tlast),
    .s_axis_room(),
    .s_axis_full(),
    .s_axis_almost_full());

  ////----------------------------------------AXI Interface-----------------//
  //////////////////////////////////////////////////

  wire                            start_counter_reg;
  wire                            stop_counter_reg;
  wire                            clear_counter_reg;
  reg  [31:0]                     counter_reg;

  application_regmap #(
    .AXIL_CTRL_DATA_WIDTH(AXIL_CTRL_DATA_WIDTH),
    .AXIL_CTRL_ADDR_WIDTH(AXIL_CTRL_ADDR_WIDTH),
    .AXIL_CTRL_STRB_WIDTH(AXIL_CTRL_STRB_WIDTH)
  ) application_regmap_inst (
    .clk(clk),
    .rstn(rstn),

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

    .start_app(start_app),
    .start_counter_reg(start_counter_reg),
    .stop_counter_reg(stop_counter_reg),
    .clear_counter_reg(clear_counter_reg),
    .counter_reg(counter_reg),
    .packet_size(packet_size),

    .ethernet_destination_MAC(ethernet_destination_MAC),
    .ethernet_source_MAC(ethernet_source_MAC),
    .ethernet_type(ethernet_type),
    .ip_version(ip_version),
    .ip_header_length(ip_header_length),
    .ip_type_of_service(ip_type_of_service),
    .ip_total_length(ip_total_length),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_header_checksum(ip_header_checksum),
    .ip_source_IP_address(ip_source_IP_address),
    .ip_destination_IP_address(ip_destination_IP_address),
    .udp_source(udp_source),
    .udp_destination(udp_destination),
    .udp_length(udp_length),
    .udp_checksum(udp_checksum));

  // Count packets sent in 1 second
  reg [31:0] timer;

  always @(posedge clk) begin
    if (rst || clear_counter_reg) begin
      counter_reg <= 32'd0;
      timer <= 32'd0;
    end else begin
      if (start_counter_reg || timer != 32'd0) begin
        if (m_axis_sync_tx_tvalid && m_axis_sync_tx_tready && m_axis_sync_tx_tlast) begin
          counter_reg <= counter_reg + 1'b1;
          timer <= timer + 1;
        end
        if (timer == 32'd250000000) begin
          timer <= 32'd0;
        end
      end
    end
  end

  // AXI-Lite master interface (control to NIC)
  assign m_axil_ctrl_awaddr = 0;
  assign m_axil_ctrl_awprot = 0;
  assign m_axil_ctrl_awvalid = 1'b0;
  assign m_axil_ctrl_wdata = 0;
  assign m_axil_ctrl_wstrb = 0;
  assign m_axil_ctrl_wvalid = 1'b0;
  assign m_axil_ctrl_bready = 1'b1;
  assign m_axil_ctrl_araddr = 0;
  assign m_axil_ctrl_arprot = 0;
  assign m_axil_ctrl_arvalid = 1'b0;
  assign m_axil_ctrl_rready = 1'b1;

  // DMA interface (control)
  assign m_axis_ctrl_dma_read_desc_dma_addr = 0;
  assign m_axis_ctrl_dma_read_desc_ram_sel = 0;
  assign m_axis_ctrl_dma_read_desc_ram_addr = 0;
  assign m_axis_ctrl_dma_read_desc_len = 0;
  assign m_axis_ctrl_dma_read_desc_tag = 0;
  assign m_axis_ctrl_dma_read_desc_valid = 1'b0;
  assign m_axis_ctrl_dma_write_desc_dma_addr = 0;
  assign m_axis_ctrl_dma_write_desc_ram_sel = 0;
  assign m_axis_ctrl_dma_write_desc_ram_addr = 0;
  assign m_axis_ctrl_dma_write_desc_imm = 0;
  assign m_axis_ctrl_dma_write_desc_imm_en = 0;
  assign m_axis_ctrl_dma_write_desc_len = 0;
  assign m_axis_ctrl_dma_write_desc_tag = 0;
  assign m_axis_ctrl_dma_write_desc_valid = 1'b0;

  assign ctrl_dma_ram_wr_cmd_ready = 1'b1;
  assign ctrl_dma_ram_wr_done = ctrl_dma_ram_wr_cmd_valid;
  assign ctrl_dma_ram_rd_cmd_ready = ctrl_dma_ram_rd_resp_ready;
  assign ctrl_dma_ram_rd_resp_data = 0;
  assign ctrl_dma_ram_rd_resp_valid = ctrl_dma_ram_rd_cmd_valid;

  // DMA interface (data)
  assign m_axis_data_dma_read_desc_dma_addr = 0;
  assign m_axis_data_dma_read_desc_ram_sel = 0;
  assign m_axis_data_dma_read_desc_ram_addr = 0;
  assign m_axis_data_dma_read_desc_len = 0;
  assign m_axis_data_dma_read_desc_tag = 0;
  assign m_axis_data_dma_read_desc_valid = 1'b0;
  assign m_axis_data_dma_write_desc_dma_addr = 0;
  assign m_axis_data_dma_write_desc_ram_sel = 0;
  assign m_axis_data_dma_write_desc_ram_addr = 0;
  assign m_axis_data_dma_write_desc_imm = 0;
  assign m_axis_data_dma_write_desc_imm_en = 0;
  assign m_axis_data_dma_write_desc_len = 0;
  assign m_axis_data_dma_write_desc_tag = 0;
  assign m_axis_data_dma_write_desc_valid = 1'b0;

  assign data_dma_ram_wr_cmd_ready = 1'b1;
  assign data_dma_ram_wr_done = data_dma_ram_wr_cmd_valid;
  assign data_dma_ram_rd_cmd_ready = data_dma_ram_rd_resp_ready;
  assign data_dma_ram_rd_resp_data = 0;
  assign data_dma_ram_rd_resp_valid = data_dma_ram_rd_cmd_valid;

  // Ethernet (direct MAC interface - lowest latency raw traffic)
  assign m_axis_direct_tx_tdata = s_axis_direct_tx_tdata;
  assign m_axis_direct_tx_tkeep = s_axis_direct_tx_tkeep;
  assign m_axis_direct_tx_tvalid = s_axis_direct_tx_tvalid;
  assign s_axis_direct_tx_tready = m_axis_direct_tx_tready;
  assign m_axis_direct_tx_tlast = s_axis_direct_tx_tlast;
  assign m_axis_direct_tx_tuser = s_axis_direct_tx_tuser;

  assign m_axis_direct_tx_cpl_ts = s_axis_direct_tx_cpl_ts;
  assign m_axis_direct_tx_cpl_tag = s_axis_direct_tx_cpl_tag;
  assign m_axis_direct_tx_cpl_valid = s_axis_direct_tx_cpl_valid;
  assign s_axis_direct_tx_cpl_ready = m_axis_direct_tx_cpl_ready;

  assign m_axis_direct_rx_tdata = s_axis_direct_rx_tdata;
  assign m_axis_direct_rx_tkeep = s_axis_direct_rx_tkeep;
  assign m_axis_direct_rx_tvalid = s_axis_direct_rx_tvalid;
  assign s_axis_direct_rx_tready = m_axis_direct_rx_tready;
  assign m_axis_direct_rx_tlast = s_axis_direct_rx_tlast;
  assign m_axis_direct_rx_tuser = s_axis_direct_rx_tuser;

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  reg datapath_switch; // 0 - OS
                       // 1 - Packet

  always @(posedge clk)
  begin
    if (!rstn) begin
      datapath_switch <= 1'b0;
    end else begin
      if ((packet_buffer_almost_empty || !run_packetizer) && (packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast) || !packet_fifo_rstn) begin
        datapath_switch <= 1'b0;
      end else if (packet_buffer_almost_full && (!os_buffer_axis_tvalid || (os_buffer_axis_tready && os_buffer_axis_tvalid && os_buffer_axis_tlast))) begin
        datapath_switch <= 1'b1;
      end
    end
  end

  always @(*)
  begin
    if (!datapath_switch) begin
      m_axis_sync_tx_tdata = os_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = os_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = os_buffer_axis_tvalid;
      os_buffer_axis_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = os_buffer_axis_tlast;
      m_axis_sync_tx_tuser = s_axis_sync_tx_tuser;

      packet_buffer_axis_tready = 1'b0;
    end else begin
      m_axis_sync_tx_tdata = packet_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = packet_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = packet_buffer_axis_tvalid;
      packet_buffer_axis_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = packet_buffer_axis_tlast;
      m_axis_sync_tx_tuser = 1'b0;

      os_buffer_axis_tready = 1'b0;
    end
  end

  assign m_axis_sync_tx_cpl_ts = s_axis_sync_tx_cpl_ts;
  assign m_axis_sync_tx_cpl_tag = s_axis_sync_tx_cpl_tag;
  assign m_axis_sync_tx_cpl_valid = s_axis_sync_tx_cpl_valid;
  assign s_axis_sync_tx_cpl_ready = m_axis_sync_tx_cpl_ready;

  assign m_axis_sync_rx_tdata = s_axis_sync_rx_tdata;
  assign m_axis_sync_rx_tkeep = s_axis_sync_rx_tkeep;
  assign m_axis_sync_rx_tvalid = s_axis_sync_rx_tvalid;
  assign s_axis_sync_rx_tready = m_axis_sync_rx_tready;
  assign m_axis_sync_rx_tlast = s_axis_sync_rx_tlast;
  assign m_axis_sync_rx_tuser = s_axis_sync_rx_tuser;

  // Ethernet (internal at interface module)
  assign m_axis_if_tx_tdata = s_axis_if_tx_tdata;
  assign m_axis_if_tx_tkeep = s_axis_if_tx_tkeep;
  assign m_axis_if_tx_tvalid = s_axis_if_tx_tvalid;
  assign s_axis_if_tx_tready = m_axis_if_tx_tready;
  assign m_axis_if_tx_tlast = s_axis_if_tx_tlast;
  assign m_axis_if_tx_tid = s_axis_if_tx_tid;
  assign m_axis_if_tx_tdest = s_axis_if_tx_tdest;
  assign m_axis_if_tx_tuser = s_axis_if_tx_tuser;

  assign m_axis_if_tx_cpl_ts = s_axis_if_tx_cpl_ts;
  assign m_axis_if_tx_cpl_tag = s_axis_if_tx_cpl_tag;
  assign m_axis_if_tx_cpl_valid = s_axis_if_tx_cpl_valid;
  assign s_axis_if_tx_cpl_ready = m_axis_if_tx_cpl_ready;

  assign m_axis_if_rx_tdata = s_axis_if_rx_tdata;
  assign m_axis_if_rx_tkeep = s_axis_if_rx_tkeep;
  assign m_axis_if_rx_tvalid = s_axis_if_rx_tvalid;
  assign s_axis_if_rx_tready = m_axis_if_rx_tready;
  assign m_axis_if_rx_tlast = s_axis_if_rx_tlast;
  assign m_axis_if_rx_tid = s_axis_if_rx_tid;
  assign m_axis_if_rx_tdest = s_axis_if_rx_tdest;
  assign m_axis_if_rx_tuser = s_axis_if_rx_tuser;

  // DDR
  assign m_axi_ddr_awid = 0;
  assign m_axi_ddr_awaddr = 0;
  assign m_axi_ddr_awlen = 0;
  assign m_axi_ddr_awsize = 0;
  assign m_axi_ddr_awburst = 0;
  assign m_axi_ddr_awlock = 0;
  assign m_axi_ddr_awcache = 0;
  assign m_axi_ddr_awprot = 0;
  assign m_axi_ddr_awqos = 0;
  assign m_axi_ddr_awuser = 0;
  assign m_axi_ddr_awvalid = 0;
  assign m_axi_ddr_wdata = 0;
  assign m_axi_ddr_wstrb = 0;
  assign m_axi_ddr_wlast = 0;
  assign m_axi_ddr_wuser = 0;
  assign m_axi_ddr_wvalid = 0;
  assign m_axi_ddr_bready = 0;
  assign m_axi_ddr_arid = 0;
  assign m_axi_ddr_araddr = 0;
  assign m_axi_ddr_arlen = 0;
  assign m_axi_ddr_arsize = 0;
  assign m_axi_ddr_arburst = 0;
  assign m_axi_ddr_arlock = 0;
  assign m_axi_ddr_arcache = 0;
  assign m_axi_ddr_arprot = 0;
  assign m_axi_ddr_arqos = 0;
  assign m_axi_ddr_aruser = 0;
  assign m_axi_ddr_arvalid = 0;
  assign m_axi_ddr_rready = 0;

  // HBM
  assign m_axi_hbm_awid = 0;
  assign m_axi_hbm_awaddr = 0;
  assign m_axi_hbm_awlen = 0;
  assign m_axi_hbm_awsize = 0;
  assign m_axi_hbm_awburst = 0;
  assign m_axi_hbm_awlock = 0;
  assign m_axi_hbm_awcache = 0;
  assign m_axi_hbm_awprot = 0;
  assign m_axi_hbm_awqos = 0;
  assign m_axi_hbm_awuser = 0;
  assign m_axi_hbm_awvalid = 0;
  assign m_axi_hbm_wdata = 0;
  assign m_axi_hbm_wstrb = 0;
  assign m_axi_hbm_wlast = 0;
  assign m_axi_hbm_wuser = 0;
  assign m_axi_hbm_wvalid = 0;
  assign m_axi_hbm_bready = 0;
  assign m_axi_hbm_arid = 0;
  assign m_axi_hbm_araddr = 0;
  assign m_axi_hbm_arlen = 0;
  assign m_axi_hbm_arsize = 0;
  assign m_axi_hbm_arburst = 0;
  assign m_axi_hbm_arlock = 0;
  assign m_axi_hbm_arcache = 0;
  assign m_axi_hbm_arprot = 0;
  assign m_axi_hbm_arqos = 0;
  assign m_axi_hbm_aruser = 0;
  assign m_axi_hbm_arvalid = 0;
  assign m_axi_hbm_rready = 0;

  // Statistics increment output
  assign m_axis_stat_tdata = 0;
  assign m_axis_stat_tid = 0;
  assign m_axis_stat_tvalid = 1'b0;

  // GPIO
  assign gpio_out = 0;

  // JTAG
  assign jtag_tdo = jtag_tdi;

endmodule

`resetall
