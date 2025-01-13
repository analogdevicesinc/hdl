// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 The Regents of the University of California
 * Copyright (c) 2024 - 2025 Analog Devices, Inc. All rights reserved
 */
/*
 * This file repackages Corundum MQNIC Core AXI with the sole purpose of
 * providing it as an IP Core.
 * The original file can be refereed at:
 * https://github.com/ucsdsysnet/corundum/blob/master/fpga/common/rtl/mqnic_core_axi.v
 */

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Application block
 */
module application_core_udp #
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
    parameter STAT_ID_WIDTH = 12
)
(
    input  wire                                           clk,
    input  wire                                           rst,

    /*
     * AXI-Lite slave interface (control from host)
     */
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

    /*
     * AXI-Lite master interface (control to NIC)
     */
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

    /*
     * DMA read descriptor output (control)
     */
    output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_read_desc_dma_addr,
    output wire [RAM_SEL_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_ram_sel,
    output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_read_desc_ram_addr,
    output wire [DMA_LEN_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_len,
    output wire [DMA_TAG_WIDTH-1:0]                       m_axis_ctrl_dma_read_desc_tag,
    output wire                                           m_axis_ctrl_dma_read_desc_valid,
    input  wire                                           m_axis_ctrl_dma_read_desc_ready,

    /*
     * DMA read descriptor status input (control)
     */
    input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_ctrl_dma_read_desc_status_tag,
    input  wire [3:0]                                     s_axis_ctrl_dma_read_desc_status_error,
    input  wire                                           s_axis_ctrl_dma_read_desc_status_valid,

    /*
     * DMA write descriptor output (control)
     */
    output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_write_desc_dma_addr,
    output wire [RAM_SEL_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_ram_sel,
    output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_ctrl_dma_write_desc_ram_addr,
    output wire [DMA_IMM_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_imm,
    output wire                                           m_axis_ctrl_dma_write_desc_imm_en,
    output wire [DMA_LEN_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_len,
    output wire [DMA_TAG_WIDTH-1:0]                       m_axis_ctrl_dma_write_desc_tag,
    output wire                                           m_axis_ctrl_dma_write_desc_valid,
    input  wire                                           m_axis_ctrl_dma_write_desc_ready,

    /*
     * DMA write descriptor status input (control)
     */
    input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_ctrl_dma_write_desc_status_tag,
    input  wire [3:0]                                     s_axis_ctrl_dma_write_desc_status_error,
    input  wire                                           s_axis_ctrl_dma_write_desc_status_valid,

    /*
     * DMA read descriptor output (data)
     */
    output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_data_dma_read_desc_dma_addr,
    output wire [RAM_SEL_WIDTH-1:0]                       m_axis_data_dma_read_desc_ram_sel,
    output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_data_dma_read_desc_ram_addr,
    output wire [DMA_LEN_WIDTH-1:0]                       m_axis_data_dma_read_desc_len,
    output wire [DMA_TAG_WIDTH-1:0]                       m_axis_data_dma_read_desc_tag,
    output wire                                           m_axis_data_dma_read_desc_valid,
    input  wire                                           m_axis_data_dma_read_desc_ready,

    /*
     * DMA read descriptor status input (data)
     */
    input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_data_dma_read_desc_status_tag,
    input  wire [3:0]                                     s_axis_data_dma_read_desc_status_error,
    input  wire                                           s_axis_data_dma_read_desc_status_valid,

    /*
     * DMA write descriptor output (data)
     */
    output wire [DMA_ADDR_WIDTH-1:0]                      m_axis_data_dma_write_desc_dma_addr,
    output wire [RAM_SEL_WIDTH-1:0]                       m_axis_data_dma_write_desc_ram_sel,
    output wire [RAM_ADDR_WIDTH-1:0]                      m_axis_data_dma_write_desc_ram_addr,
    output wire [DMA_IMM_WIDTH-1:0]                       m_axis_data_dma_write_desc_imm,
    output wire                                           m_axis_data_dma_write_desc_imm_en,
    output wire [DMA_LEN_WIDTH-1:0]                       m_axis_data_dma_write_desc_len,
    output wire [DMA_TAG_WIDTH-1:0]                       m_axis_data_dma_write_desc_tag,
    output wire                                           m_axis_data_dma_write_desc_valid,
    input  wire                                           m_axis_data_dma_write_desc_ready,

    /*
     * DMA write descriptor status input (data)
     */
    input  wire [DMA_TAG_WIDTH-1:0]                       s_axis_data_dma_write_desc_status_tag,
    input  wire [3:0]                                     s_axis_data_dma_write_desc_status_error,
    input  wire                                           s_axis_data_dma_write_desc_status_valid,

    /*
     * DMA RAM interface (control)
     */
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

    /*
     * DMA RAM interface (data)
     */
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

    /*
     * PTP clock
     */
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

    /*
     * Ethernet (direct MAC interface - lowest latency raw traffic)
     */
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

    /*
     * Ethernet (synchronous MAC interface - low latency raw traffic)
     */
    input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_DATA_WIDTH-1:0]     s_axis_sync_tx_tdata,
    input  wire [IF_COUNT*PORTS_PER_IF*AXIS_SYNC_KEEP_WIDTH-1:0]     s_axis_sync_tx_tkeep,
    input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_tvalid,
    output reg  [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_sync_tx_tready,
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

    /*
     * Ethernet (internal at interface module)
     */
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

    /*
     * DDR
     */
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

    /*
     * HBM
     */
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

    /*
     * Statistics increment output
     */
    output wire [STAT_INC_WIDTH-1:0]                      m_axis_stat_tdata,
    output wire [STAT_ID_WIDTH-1:0]                       m_axis_stat_tid,
    output wire                                           m_axis_stat_tvalid,
    input  wire                                           m_axis_stat_tready,

    /*
     * GPIO
     */
    input  wire [APP_GPIO_IN_WIDTH-1:0]                   gpio_in,
    output wire [APP_GPIO_OUT_WIDTH-1:0]                  gpio_out,

    /*
     * JTAG
     */
    input  wire                                           jtag_tdi,
    output wire                                           jtag_tdo,
    input  wire                                           jtag_tms,
    input  wire                                           jtag_tck,

    input  wire                                           input_clk,
    input  wire                                           input_rstn
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
  localparam             INPUT_WIDTH = 2048;

  reg                    start_generator;
  reg                    start_generator_reg;
  wire                   start_generator_reg_cdc;
  reg  [7:0]             gen_data;

  reg  [INPUT_WIDTH-1:0] input_axis_tdata;
  reg                    input_axis_tvalid;
  wire                   input_axis_tready;

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_start_generator_reg (
    .in_bits(start_generator_reg),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(start_generator_reg_cdc)
  );

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      start_generator <= 1'b0;
    end else begin
      if (start_generator_reg_cdc) begin
        start_generator <= 1'b1;
      end else if (gen_data == 8'h0F) begin
        start_generator <= 1'b0;
      end
    end
  end

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      gen_data <= 8'd0;
    end else begin
      if (start_generator) begin
        if (input_axis_tready) begin
          gen_data <= gen_data + 1;
        end
      end else begin
        gen_data <= 8'd0;
      end
    end
  end

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_axis_tdata <= {INPUT_WIDTH{1'b0}};
      input_axis_tvalid <= 1'b0;
    end else begin
      input_axis_tdata <= {INPUT_WIDTH/8{gen_data}};
      input_axis_tvalid <= start_generator;
    end
  end

  ////----------------------------------------Packetizer--------------------//
  //////////////////////////////////////////////////
  reg  [7:0] sample_counter;
  reg  [7:0] packet_size;
  wire [7:0] packet_size_cdc;
  reg        packet_tlast;

  sync_bits #(
    .NUM_OF_BITS(8)
  ) sync_bits_packet_size (
    .in_bits(packet_size),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(packet_size_cdc)
  );

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      sample_counter <= 8'd1;
      packet_tlast <= 1'b0;
    end else begin
      if (input_axis_tvalid) begin
        if (sample_counter < packet_size_cdc-1) begin
          sample_counter <= sample_counter + 1;
          packet_tlast <= 1'b0;
        end else begin
          sample_counter <= 8'd0;
          packet_tlast <= 1'b1;
        end
      end
    end
  end
  
  ////----------------------------------------CDC and Scaling FIFO----------//
  //////////////////////////////////////////////////
  wire                       cdc_axis_tvalid;
  wire                       cdc_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0] cdc_axis_tdata;
  wire                       cdc_axis_tlast;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(INPUT_WIDTH),
    .ADDRESS_WIDTH(4),
    .M_DATA_WIDTH(AXIS_DATA_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
    .TLAST_EN(1),
    .TKEEP_EN(0),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) cdc_scale_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(cdc_axis_tready),
    .m_axis_valid(cdc_axis_tvalid),
    .m_axis_data(cdc_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(cdc_axis_tlast),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_level(),
  
    .s_axis_aclk(input_clk),
    .s_axis_aresetn(input_rstn),
    .s_axis_ready(input_axis_tready),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep(),
    .s_axis_tlast(packet_tlast),
    .s_axis_full(),
    .s_axis_almost_full(),
    .s_axis_room()
  );
  
  ////----------------------------------------Header Inserter---------------//
  //////////////////////////////////////////////////
  // Ethernet header
  reg [48-1:0] ethernet_destination_MAC;
  reg [48-1:0] ethernet_source_MAC;
  reg [16-1:0] ethernet_type;

  // IPv4 header
  reg [4-1:0]  ip_version;
  reg [4-1:0]  ip_header_length;
  reg [8-1:0]  ip_type_of_service;
  reg [16-1:0] ip_total_length;
  reg [16-1:0] ip_identification;
  reg [3-1:0]  ip_flags;
  reg [13-1:0] ip_fragment_offset;
  reg [8-1:0]  ip_time_to_live;
  reg [8-1:0]  ip_protocol;
  reg [16-1:0] ip_header_checksum;
  reg [32-1:0] ip_source_IP_address;
  reg [32-1:0] ip_destination_IP_address;

  reg [32-1:0] ip_header_checksum_reg0;
  reg [32-1:0] ip_header_checksum_reg1;

  // UDP header
  reg [16-1:0] udp_source;
  reg [16-1:0] udp_destination;
  reg [16-1:0] udp_length;
  reg [16-1:0] udp_checksum;

  localparam HEADER_LENGTH = 336;

  wire [HEADER_LENGTH-1:0]     header;

  reg  [31:0]                  cdc_axis_tdata_reg;

  reg                          new_packet;
  reg                          tlast_sig;

  reg                          packet_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0]   packet_axis_tdata;
  reg  [AXIS_DATA_WIDTH/8-1:0] packet_axis_tkeep;
  reg                          packet_axis_tlast;

  reg                          output_axis_tready;
  reg                          output_axis_tvalid;
  reg  [AXIS_DATA_WIDTH-1:0]   output_axis_tdata;
  reg                          output_axis_tlast;
  reg  [AXIS_DATA_WIDTH/8-1:0] output_axis_tkeep;

  // temporary storage
  always @(posedge clk)
  begin
    if (!rstn) begin
      cdc_axis_tdata_reg <= 32'b0;
    end else begin
      if (cdc_axis_tvalid && output_axis_tready) begin
        cdc_axis_tdata_reg <= cdc_axis_tdata[AXIS_DATA_WIDTH-1:AXIS_DATA_WIDTH-32];
      end
    end
  end

  // ready signal generation
  assign cdc_axis_tready = ~tlast_sig && output_axis_tready;

  // hton implementation for dynamic byte range
  `define HTOND(length) \
    function [length-1:0] htond_``length``(input [length-1:0] data_in); \
      integer i; \
      begin \
        for (i=0; i<length/8; i=i+1) \
        begin \
          htond_``length``[i*8+:8] = data_in[(length/8-1-i)*8+:8]; \
        end \
      end \
    endfunction \

  `HTOND(16)
  `HTOND(32)
  `HTOND(48)

  // header concatenation
  assign header = {
    htond_48(ethernet_destination_MAC),
    htond_48(ethernet_source_MAC),
    htond_16(ethernet_type),
    htond_16({ip_version, ip_header_length, ip_type_of_service}),
    htond_16(ip_total_length),
    htond_16(ip_identification),
    htond_16({ip_flags, ip_fragment_offset}),
    htond_16({ip_time_to_live, ip_protocol}),
    htond_16(ip_header_checksum),
    htond_32(ip_source_IP_address),
    htond_32(ip_destination_IP_address),
    htond_16(udp_source),
    htond_16(udp_destination),
    htond_16(udp_length),
    htond_16(udp_checksum)
  };

  // ip header checksum calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      ip_header_checksum_reg0 <= 'd0;
      ip_header_checksum_reg1 <= 'd0;
      ip_header_checksum <= 'd0;
    end else begin
      ip_header_checksum_reg0 <= {16'h0000, {ip_version, ip_header_length, ip_type_of_service}} + 
        {16'h0000, ip_total_length} + 
        {16'h0000, ip_identification} + 
        {16'h0000, {ip_flags, ip_fragment_offset}} + 
        {16'h0000, {ip_time_to_live, ip_protocol}} + 
        {16'h0000, ip_source_IP_address[31:16]} + 
        {16'h0000, ip_source_IP_address[15:0]} + 
        {16'h0000, ip_destination_IP_address[31:16]} + 
        {16'h0000, ip_destination_IP_address[15:0]};

      ip_header_checksum_reg1 <= ip_header_checksum_reg0[31:16] + ip_header_checksum_reg0[15:0];

      ip_header_checksum <= ~ip_header_checksum_reg1;
    end
  end

  // ip total length calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      ip_total_length <= 16'h0;
    end else begin
      ip_total_length <= ip_header_length + udp_length;
    end
  end
  
  // udp total length calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      udp_length <= 'd0;
    end else begin
      udp_length <= 16'h8 + INPUT_WIDTH*packet_size;
    end
  end

  // tlast signal generation
  always @(posedge clk)
  begin
    if (!rstn) begin
      tlast_sig <= 1'b0;
    end else begin
      if (output_axis_tready) begin
        if (cdc_axis_tvalid) begin
          tlast_sig <= cdc_axis_tlast;
        end else begin
          tlast_sig <= 1'b0;
        end
      end
    end
  end

  // new packet marking
  always @(posedge clk)
  begin
    if (!rstn) begin
      new_packet <= 1'b1;
    end else begin
      if (output_axis_tready) begin
        if (tlast_sig) begin
          new_packet <= 1'b1;
        end else if (cdc_axis_tvalid) begin
          new_packet <= 1'b0;
        end
      end
    end
  end

  // header insertion
  always @(posedge clk)
  begin
    if (!rstn) begin
      packet_axis_tvalid <= 1'b0;
      packet_axis_tdata <= {AXIS_DATA_WIDTH-1{1'b0}};
      packet_axis_tkeep <= {AXIS_DATA_WIDTH/8-1{1'b0}};
      packet_axis_tlast <= 1'b0;
    end else begin
      if (output_axis_tready) begin
        // valid
        if (cdc_axis_tvalid || tlast_sig) begin
          packet_axis_tvalid <= 1'b1;
        end else begin
          packet_axis_tvalid <= 1'b0;
        end
        // last
        packet_axis_tlast <= tlast_sig;
        // data and keep
        if (cdc_axis_tvalid) begin
          if (new_packet) begin
            packet_axis_tdata <= {cdc_axis_tdata[AXIS_DATA_WIDTH-1-HEADER_LENGTH:0], header};
            packet_axis_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
          end else begin
            packet_axis_tdata <= {cdc_axis_tdata[AXIS_DATA_WIDTH-1-HEADER_LENGTH:0], cdc_axis_tdata_reg};
            packet_axis_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
          end
        end else if (tlast_sig) begin
          packet_axis_tdata <= {{AXIS_DATA_WIDTH-HEADER_LENGTH{1'b0}}, cdc_axis_tdata_reg};
          packet_axis_tkeep <= {{AXIS_DATA_WIDTH-HEADER_LENGTH{1'b0}}, {32/8{1'b1}}};
        end
      end
    end
  end
  
  ////----------------------------------------Register----------------------//
  //////////////////////////////////////////////////
  always @(posedge clk)
  begin
    output_axis_tvalid <= packet_axis_tvalid;
    output_axis_tdata <= packet_axis_tdata;
    output_axis_tkeep <= packet_axis_tkeep;
    output_axis_tlast <= packet_axis_tlast;
  end

  ////----------------------------------------AXI Interface-----------------//
  //////////////////////////////////////////////////
  wire                              up_wreq;
  wire [(AXIL_CTRL_ADDR_WIDTH-3):0] up_waddr;
  wire [31:0]                       up_wdata;
  reg                               up_wack;
  wire                              up_rreq;
  wire [(AXIL_CTRL_ADDR_WIDTH-3):0] up_raddr;
  reg  [31:0]                       up_rdata;
  reg                               up_rack;

  // Generic
  reg [31:0] version_reg = 'h1234ABCD;
  reg [31:0] scratch_reg;
  reg start_counter_reg;
  reg stop_counter_reg;
  reg clear_counter_reg;
  reg [31:0] counter_reg;
  // Switch
  reg switch;

  always @(posedge clk)
  begin
    if (rstn == 1'b0)
    begin
      up_wack <= 1'b0;
      up_rack <= 1'b0;

      // Generic
      scratch_reg <= 'h0;
      clear_counter_reg <= 1'b0;
      // Data generator
      start_generator_reg <= 1'b0;
      // Packetizer
      packet_size <= 8'd4;
      // Ethernet header
      ethernet_destination_MAC <= 48'h000A35000102;
      ethernet_source_MAC <= 48'h000A35000102;
      ethernet_type <= 16'h0800;
      // IPv4 header
      ip_version <= 4'h4;
      ip_header_length <= 4'h5;
      ip_type_of_service <= 8'h00;
      ip_identification <= 16'h0000;
      ip_flags <= 3'h0;
      ip_fragment_offset <= 13'h0000;
      ip_time_to_live <= 8'h80;
      ip_protocol <= 8'h11;
      ip_source_IP_address <= 32'hC0A8010A;
      ip_destination_IP_address <= 32'hC0A8010B;
      // UDP header
      udp_source <= 16'h0EBA;
      udp_destination <= 16'h000E;
      udp_checksum <= 16'h0000;
      // output data stream switch
      switch <= 1'b0;
    end else begin
      up_wack <= up_wreq;
      up_rack <= up_rreq;

      if (up_wreq == 1'b1) begin
        case (up_waddr)
          // Generic
          'h1: scratch_reg <= up_wdata;
          'h2: begin
            start_counter_reg <= up_wdata[0];
            stop_counter_reg <= up_wdata[1];
          end
          'h3: clear_counter_reg <= up_wdata[0];
          // Data generator
          'h5: start_generator_reg <= up_wdata[0];
          // Packetizer
          'h6: packet_size <= up_wdata[7:0];
          // Ethernet header
          'h7: ethernet_destination_MAC[48-1:32] <= up_wdata[16-1:0];
          'h8: ethernet_destination_MAC[31:0] <= up_wdata;
          'h9: ethernet_source_MAC[48-1:32] <= up_wdata[16-1:0];
          'hA: ethernet_source_MAC[31:0] <= up_wdata;
          'hB: ethernet_type <= up_wdata[16-1:0];
          // IPv4 header
          'hC: ip_version <= up_wdata[4-1:0];
          'hD: ip_header_length <= up_wdata[4-1:0];
          'hE: ip_type_of_service <= up_wdata[8-1:0];
          'h10: ip_identification <= up_wdata[16-1:0];
          'h11: ip_flags <= up_wdata[3-1:0];
          'h12: ip_fragment_offset <= up_wdata[13-1:0];
          'h13: ip_time_to_live <= up_wdata[8-1:0];
          'h14: ip_protocol <= up_wdata[8-1:0];
          'h16: ip_source_IP_address <= up_wdata[32-1:0];
          'h17: ip_destination_IP_address <= up_wdata[32-1:0];
          // UDP header
          'h18: udp_source <= up_wdata[16-1:0];
          'h19: udp_destination <= up_wdata[16-1:0];
          'h1B: udp_checksum <= up_wdata[16-1:0];
          // Switch
          'h1C: switch <= up_wdata[0];
          default: ;
        endcase
      end else begin
        clear_counter_reg <= 1'b0;
      end

      if (up_rreq == 1'b1) begin
        case (up_raddr)
          // Generic
          'h0: up_rdata <= version_reg;
          'h1: up_rdata <= scratch_reg;
          'h2: up_rdata <= {{30{1'b0}}, stop_counter_reg, start_counter_reg};
          'h3: up_rdata <= {{31{1'b0}}, clear_counter_reg};
          'h4: up_rdata <= counter_reg;
          // Data generator
          'h5: up_rdata <= {{31{1'b0}}, start_generator_reg};
          // Packetizer
          'h6: up_rdata <= {{24{1'b0}}, packet_size};
          // Ethernet header
          'h7: up_rdata <= {{16{1'b0}}, ethernet_destination_MAC[48-1:32]};
          'h8: up_rdata <= ethernet_destination_MAC[31:0];
          'h9: up_rdata <= {{16{1'b0}}, ethernet_source_MAC[48-1:32]};
          'hA: up_rdata <= ethernet_source_MAC[31:0];
          'hB: up_rdata <= {{16{1'b0}}, ethernet_type};
          // IPv4 header
          'hC: up_rdata <= {{28{1'b0}}, ip_version};
          'hD: up_rdata <= {{28{1'b0}}, ip_header_length};
          'hE: up_rdata <= {{24{1'b0}}, ip_type_of_service};
          'hF: up_rdata <= {{16{1'b0}}, ip_total_length};
          'h10: up_rdata <= {{16{1'b0}}, ip_identification};
          'h11: up_rdata <= {{29{1'b0}}, ip_flags};
          'h12: up_rdata <= {{19{1'b0}}, ip_fragment_offset};
          'h13: up_rdata <= {{24{1'b0}}, ip_time_to_live};
          'h14: up_rdata <= {{24{1'b0}}, ip_protocol};
          'h15: up_rdata <= {{16{1'b0}}, ip_header_checksum};
          'h16: up_rdata <= ip_source_IP_address;
          'h17: up_rdata <= ip_destination_IP_address;
          // UDP header
          'h18: up_rdata <= {{16{1'b0}}, udp_source};
          'h19: up_rdata <= {{16{1'b0}}, udp_destination};
          'h1A: up_rdata <= {{16{1'b0}}, udp_length};
          'h1B: up_rdata <= {{16{1'b0}}, udp_checksum};
          // Switch
          'h1C: up_rdata <= {{31{1'b0}}, switch};
          default: up_rdata <= 32'd0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  up_axi #(
    .AXI_ADDRESS_WIDTH(AXIL_CTRL_ADDR_WIDTH)
  ) i_up_axi (
    .up_rstn            (rstn),
    .up_clk             (clk),
    .up_axi_awvalid     (s_axil_ctrl_awvalid),
    .up_axi_awaddr      (s_axil_ctrl_awaddr),
    .up_axi_awready     (s_axil_ctrl_awready),
    .up_axi_wvalid      (s_axil_ctrl_wvalid),
    .up_axi_wdata       (s_axil_ctrl_wdata),
    .up_axi_wstrb       (s_axil_ctrl_wstrb),
    .up_axi_wready      (s_axil_ctrl_wready),
    .up_axi_bvalid      (s_axil_ctrl_bvalid),
    .up_axi_bresp       (s_axil_ctrl_bresp),
    .up_axi_bready      (s_axil_ctrl_bready),
    .up_axi_arvalid     (s_axil_ctrl_arvalid),
    .up_axi_araddr      (s_axil_ctrl_araddr),
    .up_axi_arready     (s_axil_ctrl_arready),
    .up_axi_rvalid      (s_axil_ctrl_rvalid),
    .up_axi_rresp       (s_axil_ctrl_rresp),
    .up_axi_rdata       (s_axil_ctrl_rdata),
    .up_axi_rready      (s_axil_ctrl_rready),
    .up_wreq            (up_wreq),
    .up_waddr           (up_waddr),
    .up_wdata           (up_wdata),
    .up_wack            (up_wack),
    .up_rreq            (up_rreq),
    .up_raddr           (up_raddr),
    .up_rdata           (up_rdata),
    .up_rack            (up_rack)
  );

  always @(posedge clk) begin
    if (rst || clear_counter_reg) begin
      counter_reg <= 'h0;
    end
    else
    begin
      if (start_counter_reg && !stop_counter_reg && m_axis_if_tx_tvalid && m_axis_if_tx_tready && m_axis_if_tx_tlast)
        counter_reg <= counter_reg + 1'b1;
    end
  end

  /*
  * AXI-Lite master interface (control to NIC)
  */
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

  /*
  * DMA interface (control)
  */
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

  /*
  * DMA interface (data)
  */
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

  /*
  * Ethernet (direct MAC interface - lowest latency raw traffic)
  */
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

  /*
  * Ethernet (synchronous MAC interface - low latency raw traffic)
  */
  always @(*)
  begin
    if (switch) begin
      m_axis_sync_tx_tdata = s_axis_sync_tx_tdata;
      m_axis_sync_tx_tkeep = s_axis_sync_tx_tkeep;
      m_axis_sync_tx_tvalid = s_axis_sync_tx_tvalid;
      s_axis_sync_tx_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = s_axis_sync_tx_tlast;
      m_axis_sync_tx_tuser = s_axis_sync_tx_tuser;

      output_axis_tready = 1'b0;
    end else begin
      m_axis_sync_tx_tdata = output_axis_tdata;
      m_axis_sync_tx_tkeep = output_axis_tkeep;
      m_axis_sync_tx_tvalid = output_axis_tvalid;
      output_axis_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = output_axis_tlast;
      m_axis_sync_tx_tuser = 1'b0;

      s_axis_sync_tx_tready = 1'b0;
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

  /*
  * Ethernet (internal at interface module)
  */
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

  /*
  * DDR
  */
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

  /*
  * HBM
  */
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

  /*
  * Statistics increment output
  */
  assign m_axis_stat_tdata = 0;
  assign m_axis_stat_tid = 0;
  assign m_axis_stat_tvalid = 1'b0;

  /*
  * GPIO
  */
  assign gpio_out = 0;

  /*
  * JTAG
  */
  assign jtag_tdo = jtag_tdi;

endmodule

`resetall
