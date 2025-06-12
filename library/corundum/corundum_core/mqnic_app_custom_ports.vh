// SPDX-License-Identifier: BSD-2-Clause-Views
/*
 * Copyright (c) 2023 Missing Link Electronics, Inc.
 *
 * Template verilog header containing definitions for custom app ports.
 * See fpga/mqnic/ZCU102/fpga/fpga_app_custom_port_demo for an example design.
 *
 * The macros defined within this file and mqnic_app_custom_params.vh allow
 * users to add custom ports and parameters to the mqnic_app_block. The
 * additional ports and parameters are added and propagated throughout
 * hierarchical modules of mqnic, starting from the toplevel mqnic_core modules:
 *   - mqnic_core_axi
 *   - mqnic_core_pcie_ptile
 *   - mqnic_core_pcie_s10
 *   - mqnic_core_pcie_us
 *
 * Usage:
 * 1. Enable custom app ports by adding the following line to config.tcl:
 *        set_property VERILOG_DEFINE  {APP_CUSTOM_PORTS_ENABLE} [get_filesets sources_1]
 *    For custom parameters, add:
 *        set_property VERILOG_DEFINE  {APP_CUSTOM_PARAMS_ENABLE} [get_filesets sources_1]
 *    Enable both custom ports and parameters by adding:
 *         set_property VERILOG_DEFINE  {APP_CUSTOM_PORTS_ENABLE APP_CUSTOM_PARAMS_ENABLE} [get_filesets sources_1]
 *    Be aware that this overwrites the property VERILOG_DEFINE of the fileset.
 * 2. Custom ports must be defined in a verilog header file named "mqnic_app_custom_ports.vh".
 *    Custom parameters must be defined in "mqnic_app_custom_params.vh". When
 *    using custom ports/parameters, add the respective header file to the
 *    synthesis sources.
 * 3. For custom ports, define the following macros:
 *    - APP_CUSTOM_PORTS_DECL: port declarations, inserted into port lists of
 *        hierarchical modules up to mqnic_core_*
 *    - APP_CUSTOM_PORTS_MAP: port assignments, inserted into instantiation of
 *        hierarchical modules
 *    - (optional) APP_CUSTOM_PORTS_WIRE: wire declarations matching the ports,
 *        can be used in conjunction with APP_CUSTOM_INTF_PORT_MAP at toplevel,
 *        where mqnic is instantiated
 *    For custom parameters, define the following macros:
 *    - APP_CUSTOM_PARAMS_DECL: parameter declarations, inserted into parameter
 *        lists of hierarchical modules up to mqnic_core_*
 *    - APP_CUSTOM_PARAMS_MAP: parameter massignments, inserted into instantiation
 *        of hierarchical modules
 *
 * Ports may use existing or custom parameters for their dimension; when using
 * existing parameters, make sure they are available at every hierarchical level,
 * otherwise define a new custom parameter with a suitable value.
 *
 * Custom parameters may be overridden via config.tcl, just like all other
 * parameters. To enable this, the custom parameters must be passed through all
 * hierarchical modules from the design top to the instantiation of mqnic_core_*.
 *
 * The template headers are implemented with nested 'X macros', so ports and
 * parameters only have to be defined once in APP_CUSTOM_PORTS and APP_CUSTOM_PARAMS,
 * respectively. If nested macros are not properly supported by your tool, define
 * the necessary macros by manually typing out the lists of port declarations,
 * port mappings, etc., for example:
 *
 * `define APP_CUSTOM_PORTS_DECL \
 *   input        custom_port_a, \
 *   output [3:0] custom_port_b,
 *
 * `define APP_CUSTOM_PORTS_MAP \
 *   .custom_port_a(custom_port_a), \
 *   .custom_port_b(custom_port_b),
 */

// Custom port list (direction, dimension (empty for regular 1-bit wire), name)
`define APP_CUSTOM_PORTS_DECL \
  input  wire  [AXIL_CTRL_ADDR_WIDTH-1:0]                      m_axil_ctrl_awaddr_app, \
  input  wire  [2:0]                                           m_axil_ctrl_awprot_app, \
  input  wire                                                  m_axil_ctrl_awvalid_app, \
  output wire                                                  m_axil_ctrl_awready_app, \
  input  wire  [AXIL_CTRL_DATA_WIDTH-1:0]                      m_axil_ctrl_wdata_app, \
  input  wire  [AXIL_CTRL_STRB_WIDTH-1:0]                      m_axil_ctrl_wstrb_app, \
  input  wire                                                  m_axil_ctrl_wvalid_app, \
  output wire                                                  m_axil_ctrl_wready_app, \
  output wire   [1:0]                                          m_axil_ctrl_bresp_app, \
  output wire                                                  m_axil_ctrl_bvalid_app, \
  input  wire                                                  m_axil_ctrl_bready_app, \
  input  wire  [AXIL_CTRL_ADDR_WIDTH-1:0]                      m_axil_ctrl_araddr_app, \
  input  wire  [2:0]                                           m_axil_ctrl_arprot_app, \
  input  wire                                                  m_axil_ctrl_arvalid_app, \
  output wire                                                  m_axil_ctrl_arready_app, \
  output wire   [AXIL_CTRL_DATA_WIDTH-1:0]                     m_axil_ctrl_rdata_app, \
  output wire   [1:0]                                          m_axil_ctrl_rresp_app, \
  output wire                                                  m_axil_ctrl_rvalid_app, \
  input  wire                                                  m_axil_ctrl_rready_app, \
  input  wire  [DMA_ADDR_WIDTH_APP-1:0]                        m_axis_ctrl_dma_read_desc_dma_addr_app, \
  input  wire  [RAM_SEL_WIDTH_APP-1:0]                         m_axis_ctrl_dma_read_desc_ram_sel_app, \
  input  wire  [RAM_ADDR_WIDTH-1:0]                            m_axis_ctrl_dma_read_desc_ram_addr_app, \
  input  wire  [DMA_LEN_WIDTH-1:0]                             m_axis_ctrl_dma_read_desc_len_app, \
  input  wire  [DMA_TAG_WIDTH-1:0]                             m_axis_ctrl_dma_read_desc_tag_app, \
  input  wire                                                  m_axis_ctrl_dma_read_desc_valid_app, \
  output wire                                                  m_axis_ctrl_dma_read_desc_ready_app, \
  output wire   [DMA_TAG_WIDTH-1:0]                            s_axis_ctrl_dma_read_desc_status_tag_app, \
  output wire   [3:0]                                          s_axis_ctrl_dma_read_desc_status_error_app, \
  output wire                                                  s_axis_ctrl_dma_read_desc_status_valid_app, \
  input  wire  [DMA_ADDR_WIDTH_APP-1:0]                        m_axis_ctrl_dma_write_desc_dma_addr_app, \
  input  wire  [RAM_SEL_WIDTH_APP-1:0]                         m_axis_ctrl_dma_write_desc_ram_sel_app, \
  input  wire  [RAM_ADDR_WIDTH-1:0]                            m_axis_ctrl_dma_write_desc_ram_addr_app, \
  input  wire  [DMA_IMM_WIDTH-1:0]                             m_axis_ctrl_dma_write_desc_imm_app, \
  input  wire                                                  m_axis_ctrl_dma_write_desc_imm_en_app, \
  input  wire  [DMA_LEN_WIDTH-1:0]                             m_axis_ctrl_dma_write_desc_len_app, \
  input  wire  [DMA_TAG_WIDTH-1:0]                             m_axis_ctrl_dma_write_desc_tag_app, \
  input  wire                                                  m_axis_ctrl_dma_write_desc_valid_app, \
  output wire                                                  m_axis_ctrl_dma_write_desc_ready_app, \
  output wire   [DMA_TAG_WIDTH-1:0]                            s_axis_ctrl_dma_write_desc_status_tag_app, \
  output wire   [3:0]                                          s_axis_ctrl_dma_write_desc_status_error_app, \
  output wire                                                  s_axis_ctrl_dma_write_desc_status_valid_app, \
  input  wire  [DMA_ADDR_WIDTH_APP-1:0]                        m_axis_data_dma_read_desc_dma_addr_app, \
  input  wire  [RAM_SEL_WIDTH_APP-1:0]                         m_axis_data_dma_read_desc_ram_sel_app, \
  input  wire  [RAM_ADDR_WIDTH-1:0]                            m_axis_data_dma_read_desc_ram_addr_app, \
  input  wire  [DMA_LEN_WIDTH-1:0]                             m_axis_data_dma_read_desc_len_app, \
  input  wire  [DMA_TAG_WIDTH-1:0]                             m_axis_data_dma_read_desc_tag_app, \
  input  wire                                                  m_axis_data_dma_read_desc_valid_app, \
  output wire                                                  m_axis_data_dma_read_desc_ready_app, \
  output wire   [DMA_TAG_WIDTH-1:0]                            s_axis_data_dma_read_desc_status_tag_app, \
  output wire   [3:0]                                          s_axis_data_dma_read_desc_status_error_app, \
  output wire                                                  s_axis_data_dma_read_desc_status_valid_app, \
  input  wire  [DMA_ADDR_WIDTH_APP-1:0]                        m_axis_data_dma_write_desc_dma_addr_app, \
  input  wire  [RAM_SEL_WIDTH_APP-1:0]                         m_axis_data_dma_write_desc_ram_sel_app, \
  input  wire  [RAM_ADDR_WIDTH-1:0]                            m_axis_data_dma_write_desc_ram_addr_app, \
  input  wire  [DMA_IMM_WIDTH-1:0]                             m_axis_data_dma_write_desc_imm_app, \
  input  wire                                                  m_axis_data_dma_write_desc_imm_en_app, \
  input  wire  [DMA_LEN_WIDTH-1:0]                             m_axis_data_dma_write_desc_len_app, \
  input  wire  [DMA_TAG_WIDTH-1:0]                             m_axis_data_dma_write_desc_tag_app, \
  input  wire                                                  m_axis_data_dma_write_desc_valid_app, \
  output wire                                                  m_axis_data_dma_write_desc_ready_app, \
  output wire   [DMA_TAG_WIDTH-1:0]                            s_axis_data_dma_write_desc_status_tag_app, \
  output wire   [3:0]                                          s_axis_data_dma_write_desc_status_error_app, \
  output wire                                                  s_axis_data_dma_write_desc_status_valid_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEL_WIDTH_APP-1:0]      ctrl_dma_ram_wr_cmd_sel_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_BE_WIDTH_APP-1:0]   ctrl_dma_ram_wr_cmd_be_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_ADDR_WIDTH_APP-1:0] ctrl_dma_ram_wr_cmd_addr_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_DATA_WIDTH_APP-1:0] ctrl_dma_ram_wr_cmd_data_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        ctrl_dma_ram_wr_cmd_valid_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         ctrl_dma_ram_wr_cmd_ready_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         ctrl_dma_ram_wr_done_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEL_WIDTH_APP-1:0]      ctrl_dma_ram_rd_cmd_sel_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_ADDR_WIDTH_APP-1:0] ctrl_dma_ram_rd_cmd_addr_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        ctrl_dma_ram_rd_cmd_valid_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         ctrl_dma_ram_rd_cmd_ready_app, \
  input  wire  [RAM_SEG_COUNT_APP*RAM_SEG_DATA_WIDTH_APP-1:0]  ctrl_dma_ram_rd_resp_data_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         ctrl_dma_ram_rd_resp_valid_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        ctrl_dma_ram_rd_resp_ready_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEL_WIDTH_APP-1:0]      data_dma_ram_wr_cmd_sel_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_BE_WIDTH_APP-1:0]   data_dma_ram_wr_cmd_be_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_ADDR_WIDTH_APP-1:0] data_dma_ram_wr_cmd_addr_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_DATA_WIDTH_APP-1:0] data_dma_ram_wr_cmd_data_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        data_dma_ram_wr_cmd_valid_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         data_dma_ram_wr_cmd_ready_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         data_dma_ram_wr_done_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEL_WIDTH_APP-1:0]      data_dma_ram_rd_cmd_sel_app, \
  output wire   [RAM_SEG_COUNT_APP*RAM_SEG_ADDR_WIDTH_APP-1:0] data_dma_ram_rd_cmd_addr_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        data_dma_ram_rd_cmd_valid_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         data_dma_ram_rd_cmd_ready_app, \
  input  wire  [RAM_SEG_COUNT_APP*RAM_SEG_DATA_WIDTH_APP-1:0]  data_dma_ram_rd_resp_data_app, \
  input  wire  [RAM_SEG_COUNT_APP-1:0]                         data_dma_ram_rd_resp_valid_app, \
  output wire   [RAM_SEG_COUNT_APP-1:0]                        data_dma_ram_rd_resp_ready_app, \
  output wire                                                  ptp_td_sd_app, \
  output wire                                                  ptp_pps_app, \
  output wire                                                  ptp_pps_str_app, \
  output wire                                                  ptp_sync_locked_app, \
  output wire   [PTP_TS_WIDTH-1:0]                             ptp_sync_ts_rel_app, \
  output wire                                                  ptp_sync_ts_rel_step_app, \
  output wire   [PTP_TS_WIDTH-1:0]                             ptp_sync_ts_tod_app, \
  output wire                                                  ptp_sync_ts_tod_step_app, \
  output wire                                                  ptp_sync_pps_app, \
  output wire                                                  ptp_sync_pps_str_app, \
  output wire   [PTP_PEROUT_COUNT-1:0]                         ptp_perout_locked_app, \
  output wire   [PTP_PEROUT_COUNT-1:0]                         ptp_perout_error_app, \
  output wire   [PTP_PEROUT_COUNT-1:0]                         ptp_perout_pulse_app, \
  output wire   [PORT_COUNT*AXIS_DATA_WIDTH-1:0]               s_axis_direct_tx_tdata_app, \
  output wire   [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]               s_axis_direct_tx_tkeep_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_direct_tx_tvalid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_direct_tx_tready_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_direct_tx_tlast_app, \
  output wire   [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0]            s_axis_direct_tx_tuser_app, \
  input  wire  [PORT_COUNT*AXIS_DATA_WIDTH-1:0]                m_axis_direct_tx_tdata_app, \
  input  wire  [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]                m_axis_direct_tx_tkeep_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_direct_tx_tvalid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_direct_tx_tready_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_direct_tx_tlast_app, \
  input  wire  [PORT_COUNT*AXIS_TX_USER_WIDTH-1:0]             m_axis_direct_tx_tuser_app, \
  output wire   [PORT_COUNT*PTP_TS_WIDTH-1:0]                  s_axis_direct_tx_cpl_ts_app, \
  output wire   [PORT_COUNT*TX_TAG_WIDTH-1:0]                  s_axis_direct_tx_cpl_tag_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_direct_tx_cpl_valid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_direct_tx_cpl_ready_app, \
  input  wire  [PORT_COUNT*PTP_TS_WIDTH-1:0]                   m_axis_direct_tx_cpl_ts_app, \
  input  wire  [PORT_COUNT*TX_TAG_WIDTH-1:0]                   m_axis_direct_tx_cpl_tag_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_direct_tx_cpl_valid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_direct_tx_cpl_ready_app, \
  output wire   [PORT_COUNT*AXIS_DATA_WIDTH-1:0]               s_axis_direct_rx_tdata_app, \
  output wire   [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]               s_axis_direct_rx_tkeep_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_direct_rx_tvalid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_direct_rx_tready_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_direct_rx_tlast_app, \
  output wire   [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0]            s_axis_direct_rx_tuser_app, \
  input  wire  [PORT_COUNT*AXIS_DATA_WIDTH-1:0]                m_axis_direct_rx_tdata_app, \
  input  wire  [PORT_COUNT*AXIS_KEEP_WIDTH-1:0]                m_axis_direct_rx_tkeep_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_direct_rx_tvalid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_direct_rx_tready_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_direct_rx_tlast_app, \
  input  wire  [PORT_COUNT*AXIS_RX_USER_WIDTH-1:0]             m_axis_direct_rx_tuser_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_DATA_WIDTH-1:0]          s_axis_sync_tx_tdata_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_KEEP_WIDTH_APP-1:0]      s_axis_sync_tx_tkeep_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_sync_tx_tvalid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_sync_tx_tready_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_sync_tx_tlast_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_TX_USER_WIDTH_APP-1:0]   s_axis_sync_tx_tuser_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_DATA_WIDTH-1:0]           m_axis_sync_tx_tdata_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_KEEP_WIDTH_APP-1:0]       m_axis_sync_tx_tkeep_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_sync_tx_tvalid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_sync_tx_tready_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_sync_tx_tlast_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_TX_USER_WIDTH_APP-1:0]    m_axis_sync_tx_tuser_app, \
  output wire   [PORT_COUNT*PTP_TS_WIDTH-1:0]                  s_axis_sync_tx_cpl_ts_app, \
  output wire   [PORT_COUNT*TX_TAG_WIDTH-1:0]                  s_axis_sync_tx_cpl_tag_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_sync_tx_cpl_valid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_sync_tx_cpl_ready_app, \
  input  wire  [PORT_COUNT*PTP_TS_WIDTH-1:0]                   m_axis_sync_tx_cpl_ts_app, \
  input  wire  [PORT_COUNT*TX_TAG_WIDTH-1:0]                   m_axis_sync_tx_cpl_tag_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_sync_tx_cpl_valid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_sync_tx_cpl_ready_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_DATA_WIDTH-1:0]          s_axis_sync_rx_tdata_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_KEEP_WIDTH_APP-1:0]      s_axis_sync_rx_tkeep_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_sync_rx_tvalid_app, \
  input  wire  [PORT_COUNT-1:0]                                s_axis_sync_rx_tready_app, \
  output wire   [PORT_COUNT-1:0]                               s_axis_sync_rx_tlast_app, \
  output wire   [PORT_COUNT*AXIS_SYNC_RX_USER_WIDTH_APP-1:0]   s_axis_sync_rx_tuser_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_DATA_WIDTH-1:0]           m_axis_sync_rx_tdata_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_KEEP_WIDTH_APP-1:0]       m_axis_sync_rx_tkeep_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_sync_rx_tvalid_app, \
  output wire   [PORT_COUNT-1:0]                               m_axis_sync_rx_tready_app, \
  input  wire  [PORT_COUNT-1:0]                                m_axis_sync_rx_tlast_app, \
  input  wire  [PORT_COUNT*AXIS_SYNC_RX_USER_WIDTH_APP-1:0]    m_axis_sync_rx_tuser_app, \
  output wire   [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]              s_axis_if_tx_tdata_app, \
  output wire   [IF_COUNT*AXIS_IF_KEEP_WIDTH_APP-1:0]          s_axis_if_tx_tkeep_app, \
  output wire   [IF_COUNT-1:0]                                 s_axis_if_tx_tvalid_app, \
  input  wire  [IF_COUNT-1:0]                                  s_axis_if_tx_tready_app, \
  output wire   [IF_COUNT-1:0]                                 s_axis_if_tx_tlast_app, \
  output wire   [IF_COUNT*AXIS_IF_TX_ID_WIDTH_APP-1:0]         s_axis_if_tx_tid_app, \
  output wire   [IF_COUNT*AXIS_IF_TX_DEST_WIDTH_APP-1:0]       s_axis_if_tx_tdest_app, \
  output wire   [IF_COUNT*AXIS_IF_TX_USER_WIDTH_APP-1:0]       s_axis_if_tx_tuser_app, \
  input  wire  [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]               m_axis_if_tx_tdata_app, \
  input  wire  [IF_COUNT*AXIS_IF_KEEP_WIDTH_APP-1:0]           m_axis_if_tx_tkeep_app, \
  input  wire  [IF_COUNT-1:0]                                  m_axis_if_tx_tvalid_app, \
  output wire   [IF_COUNT-1:0]                                 m_axis_if_tx_tready_app, \
  input  wire  [IF_COUNT-1:0]                                  m_axis_if_tx_tlast_app, \
  input  wire  [IF_COUNT*AXIS_IF_TX_ID_WIDTH_APP-1:0]          m_axis_if_tx_tid_app, \
  input  wire  [IF_COUNT*AXIS_IF_TX_DEST_WIDTH_APP-1:0]        m_axis_if_tx_tdest_app, \
  input  wire  [IF_COUNT*AXIS_IF_TX_USER_WIDTH_APP-1:0]        m_axis_if_tx_tuser_app, \
  output wire   [IF_COUNT*PTP_TS_WIDTH-1:0]                    s_axis_if_tx_cpl_ts_app, \
  output wire   [IF_COUNT*TX_TAG_WIDTH-1:0]                    s_axis_if_tx_cpl_tag_app, \
  output wire   [IF_COUNT-1:0]                                 s_axis_if_tx_cpl_valid_app, \
  input  wire  [IF_COUNT-1:0]                                  s_axis_if_tx_cpl_ready_app, \
  input  wire  [IF_COUNT*PTP_TS_WIDTH-1:0]                     m_axis_if_tx_cpl_ts_app, \
  input  wire  [IF_COUNT*TX_TAG_WIDTH-1:0]                     m_axis_if_tx_cpl_tag_app, \
  input  wire  [IF_COUNT-1:0]                                  m_axis_if_tx_cpl_valid_app, \
  output wire   [IF_COUNT-1:0]                                 m_axis_if_tx_cpl_ready_app, \
  output wire   [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]              s_axis_if_rx_tdata_app, \
  output wire   [IF_COUNT*AXIS_IF_KEEP_WIDTH_APP-1:0]          s_axis_if_rx_tkeep_app, \
  output wire   [IF_COUNT-1:0]                                 s_axis_if_rx_tvalid_app, \
  input  wire  [IF_COUNT-1:0]                                  s_axis_if_rx_tready_app, \
  output wire   [IF_COUNT-1:0]                                 s_axis_if_rx_tlast_app, \
  output wire   [IF_COUNT*AXIS_IF_RX_ID_WIDTH_APP-1:0]         s_axis_if_rx_tid_app, \
  output wire   [IF_COUNT*AXIS_IF_RX_DEST_WIDTH_APP-1:0]       s_axis_if_rx_tdest_app, \
  output wire   [IF_COUNT*AXIS_IF_RX_USER_WIDTH_APP-1:0]       s_axis_if_rx_tuser_app, \
  input  wire  [IF_COUNT*AXIS_IF_DATA_WIDTH-1:0]               m_axis_if_rx_tdata_app, \
  input  wire  [IF_COUNT*AXIS_IF_KEEP_WIDTH_APP-1:0]           m_axis_if_rx_tkeep_app, \
  input  wire  [IF_COUNT-1:0]                                  m_axis_if_rx_tvalid_app, \
  output wire   [IF_COUNT-1:0]                                 m_axis_if_rx_tready_app, \
  input  wire  [IF_COUNT-1:0]                                  m_axis_if_rx_tlast_app, \
  input  wire  [IF_COUNT*AXIS_IF_RX_ID_WIDTH_APP-1:0]          m_axis_if_rx_tid_app, \
  input  wire  [IF_COUNT*AXIS_IF_RX_DEST_WIDTH_APP-1:0]        m_axis_if_rx_tdest_app, \
  input  wire  [IF_COUNT*AXIS_IF_RX_USER_WIDTH_APP-1:0]        m_axis_if_rx_tuser_app, \
  input  wire  [DDR_CH*AXI_DDR_ID_WIDTH-1:0]                   m_axi_ddr_awid_app, \
  input  wire  [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]                 m_axi_ddr_awaddr_app, \
  input  wire  [DDR_CH*8-1:0]                                  m_axi_ddr_awlen_app, \
  input  wire  [DDR_CH*3-1:0]                                  m_axi_ddr_awsize_app, \
  input  wire  [DDR_CH*2-1:0]                                  m_axi_ddr_awburst_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_awlock_app, \
  input  wire  [DDR_CH*4-1:0]                                  m_axi_ddr_awcache_app, \
  input  wire  [DDR_CH*3-1:0]                                  m_axi_ddr_awprot_app, \
  input  wire  [DDR_CH*4-1:0]                                  m_axi_ddr_awqos_app, \
  input  wire  [DDR_CH*AXI_DDR_AWUSER_WIDTH-1:0]               m_axi_ddr_awuser_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_awvalid_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_awready_app, \
  input  wire  [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]                 m_axi_ddr_wdata_app, \
  input  wire  [DDR_CH*AXI_DDR_STRB_WIDTH-1:0]                 m_axi_ddr_wstrb_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_wlast_app, \
  input  wire  [DDR_CH*AXI_DDR_WUSER_WIDTH-1:0]                m_axi_ddr_wuser_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_wvalid_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_wready_app, \
  output wire   [DDR_CH*AXI_DDR_ID_WIDTH-1:0]                  m_axi_ddr_bid_app, \
  output wire   [DDR_CH*2-1:0]                                 m_axi_ddr_bresp_app, \
  output wire   [DDR_CH*AXI_DDR_BUSER_WIDTH-1:0]               m_axi_ddr_buser_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_bvalid_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_bready_app, \
  input  wire  [DDR_CH*AXI_DDR_ID_WIDTH-1:0]                   m_axi_ddr_arid_app, \
  input  wire  [DDR_CH*AXI_DDR_ADDR_WIDTH-1:0]                 m_axi_ddr_araddr_app, \
  input  wire  [DDR_CH*8-1:0]                                  m_axi_ddr_arlen_app, \
  input  wire  [DDR_CH*3-1:0]                                  m_axi_ddr_arsize_app, \
  input  wire  [DDR_CH*2-1:0]                                  m_axi_ddr_arburst_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_arlock_app, \
  input  wire  [DDR_CH*4-1:0]                                  m_axi_ddr_arcache_app, \
  input  wire  [DDR_CH*3-1:0]                                  m_axi_ddr_arprot_app, \
  input  wire  [DDR_CH*4-1:0]                                  m_axi_ddr_arqos_app, \
  input  wire  [DDR_CH*AXI_DDR_ARUSER_WIDTH-1:0]               m_axi_ddr_aruser_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_arvalid_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_arready_app, \
  output wire   [DDR_CH*AXI_DDR_ID_WIDTH-1:0]                  m_axi_ddr_rid_app, \
  output wire   [DDR_CH*AXI_DDR_DATA_WIDTH-1:0]                m_axi_ddr_rdata_app, \
  output wire   [DDR_CH*2-1:0]                                 m_axi_ddr_rresp_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_rlast_app, \
  output wire   [DDR_CH*AXI_DDR_RUSER_WIDTH-1:0]               m_axi_ddr_ruser_app, \
  output wire   [DDR_CH-1:0]                                   m_axi_ddr_rvalid_app, \
  input  wire  [DDR_CH-1:0]                                    m_axi_ddr_rready_app, \
  output wire   [DDR_CH-1:0]                                   ddr_status_app, \
  input  wire  [HBM_CH*AXI_HBM_ID_WIDTH-1:0]                   m_axi_hbm_awid_app, \
  input  wire  [HBM_CH*AXI_HBM_ADDR_WIDTH-1:0]                 m_axi_hbm_awaddr_app, \
  input  wire  [HBM_CH*8-1:0]                                  m_axi_hbm_awlen_app, \
  input  wire  [HBM_CH*3-1:0]                                  m_axi_hbm_awsize_app, \
  input  wire  [HBM_CH*2-1:0]                                  m_axi_hbm_awburst_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_awlock_app, \
  input  wire  [HBM_CH*4-1:0]                                  m_axi_hbm_awcache_app, \
  input  wire  [HBM_CH*3-1:0]                                  m_axi_hbm_awprot_app, \
  input  wire  [HBM_CH*4-1:0]                                  m_axi_hbm_awqos_app, \
  input  wire  [HBM_CH*AXI_HBM_AWUSER_WIDTH-1:0]               m_axi_hbm_awuser_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_awvalid_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_awready_app, \
  input  wire  [HBM_CH*AXI_HBM_DATA_WIDTH-1:0]                 m_axi_hbm_wdata_app, \
  input  wire  [HBM_CH*AXI_HBM_STRB_WIDTH-1:0]                 m_axi_hbm_wstrb_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_wlast_app, \
  input  wire  [HBM_CH*AXI_HBM_WUSER_WIDTH-1:0]                m_axi_hbm_wuser_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_wvalid_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_wready_app, \
  output wire   [HBM_CH*AXI_HBM_ID_WIDTH-1:0]                  m_axi_hbm_bid_app, \
  output wire   [HBM_CH*2-1:0]                                 m_axi_hbm_bresp_app, \
  output wire   [HBM_CH*AXI_HBM_BUSER_WIDTH-1:0]               m_axi_hbm_buser_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_bvalid_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_bready_app, \
  input  wire  [HBM_CH*AXI_HBM_ID_WIDTH-1:0]                   m_axi_hbm_arid_app, \
  input  wire  [HBM_CH*AXI_HBM_ADDR_WIDTH-1:0]                 m_axi_hbm_araddr_app, \
  input  wire  [HBM_CH*8-1:0]                                  m_axi_hbm_arlen_app, \
  input  wire  [HBM_CH*3-1:0]                                  m_axi_hbm_arsize_app, \
  input  wire  [HBM_CH*2-1:0]                                  m_axi_hbm_arburst_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_arlock_app, \
  input  wire  [HBM_CH*4-1:0]                                  m_axi_hbm_arcache_app, \
  input  wire  [HBM_CH*3-1:0]                                  m_axi_hbm_arprot_app, \
  input  wire  [HBM_CH*4-1:0]                                  m_axi_hbm_arqos_app, \
  input  wire  [HBM_CH*AXI_HBM_ARUSER_WIDTH-1:0]               m_axi_hbm_aruser_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_arvalid_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_arready_app, \
  output wire   [HBM_CH*AXI_HBM_ID_WIDTH-1:0]                  m_axi_hbm_rid_app, \
  output wire   [HBM_CH*AXI_HBM_DATA_WIDTH-1:0]                m_axi_hbm_rdata_app, \
  output wire   [HBM_CH*2-1:0]                                 m_axi_hbm_rresp_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_rlast_app, \
  output wire   [HBM_CH*AXI_HBM_RUSER_WIDTH-1:0]               m_axi_hbm_ruser_app, \
  output wire   [HBM_CH-1:0]                                   m_axi_hbm_rvalid_app, \
  input  wire  [HBM_CH-1:0]                                    m_axi_hbm_rready_app, \
  output wire   [HBM_CH-1:0]                                   hbm_status_app, \
  input  wire  [STAT_INC_WIDTH-1:0]                            m_axis_stat_tdata_app, \
  input  wire  [STAT_ID_WIDTH-1:0]                             m_axis_stat_tid_app, \
  input  wire                                                  m_axis_stat_tvalid_app, \
  output wire                                                  m_axis_stat_tready_app,

`define APP_CUSTOM_PORTS_MAP \
  .m_axil_ctrl_awaddr_app(m_axil_ctrl_awaddr_app), \
  .m_axil_ctrl_awprot_app(m_axil_ctrl_awprot_app), \
  .m_axil_ctrl_awvalid_app(m_axil_ctrl_awvalid_app), \
  .m_axil_ctrl_awready_app(m_axil_ctrl_awready_app), \
  .m_axil_ctrl_wdata_app(m_axil_ctrl_wdata_app), \
  .m_axil_ctrl_wstrb_app(m_axil_ctrl_wstrb_app), \
  .m_axil_ctrl_wvalid_app(m_axil_ctrl_wvalid_app), \
  .m_axil_ctrl_wready_app(m_axil_ctrl_wready_app), \
  .m_axil_ctrl_bresp_app(m_axil_ctrl_bresp_app), \
  .m_axil_ctrl_bvalid_app(m_axil_ctrl_bvalid_app), \
  .m_axil_ctrl_bready_app(m_axil_ctrl_bready_app), \
  .m_axil_ctrl_araddr_app(m_axil_ctrl_araddr_app), \
  .m_axil_ctrl_arprot_app(m_axil_ctrl_arprot_app), \
  .m_axil_ctrl_arvalid_app(m_axil_ctrl_arvalid_app), \
  .m_axil_ctrl_arready_app(m_axil_ctrl_arready_app), \
  .m_axil_ctrl_rdata_app(m_axil_ctrl_rdata_app), \
  .m_axil_ctrl_rresp_app(m_axil_ctrl_rresp_app), \
  .m_axil_ctrl_rvalid_app(m_axil_ctrl_rvalid_app), \
  .m_axil_ctrl_rready_app(m_axil_ctrl_rready_app), \
  .m_axis_ctrl_dma_read_desc_dma_addr_app(m_axis_ctrl_dma_read_desc_dma_addr_app), \
  .m_axis_ctrl_dma_read_desc_ram_sel_app(m_axis_ctrl_dma_read_desc_ram_sel_app), \
  .m_axis_ctrl_dma_read_desc_ram_addr_app(m_axis_ctrl_dma_read_desc_ram_addr_app), \
  .m_axis_ctrl_dma_read_desc_len_app(m_axis_ctrl_dma_read_desc_len_app), \
  .m_axis_ctrl_dma_read_desc_tag_app(m_axis_ctrl_dma_read_desc_tag_app), \
  .m_axis_ctrl_dma_read_desc_valid_app(m_axis_ctrl_dma_read_desc_valid_app), \
  .m_axis_ctrl_dma_read_desc_ready_app(m_axis_ctrl_dma_read_desc_ready_app), \
  .s_axis_ctrl_dma_read_desc_status_tag_app(s_axis_ctrl_dma_read_desc_status_tag_app), \
  .s_axis_ctrl_dma_read_desc_status_error_app(s_axis_ctrl_dma_read_desc_status_error_app), \
  .s_axis_ctrl_dma_read_desc_status_valid_app(s_axis_ctrl_dma_read_desc_status_valid_app), \
  .m_axis_ctrl_dma_write_desc_dma_addr_app(m_axis_ctrl_dma_write_desc_dma_addr_app), \
  .m_axis_ctrl_dma_write_desc_ram_sel_app(m_axis_ctrl_dma_write_desc_ram_sel_app), \
  .m_axis_ctrl_dma_write_desc_ram_addr_app(m_axis_ctrl_dma_write_desc_ram_addr_app), \
  .m_axis_ctrl_dma_write_desc_imm_app(m_axis_ctrl_dma_write_desc_imm_app), \
  .m_axis_ctrl_dma_write_desc_imm_en_app(m_axis_ctrl_dma_write_desc_imm_en_app), \
  .m_axis_ctrl_dma_write_desc_len_app(m_axis_ctrl_dma_write_desc_len_app), \
  .m_axis_ctrl_dma_write_desc_tag_app(m_axis_ctrl_dma_write_desc_tag_app), \
  .m_axis_ctrl_dma_write_desc_valid_app(m_axis_ctrl_dma_write_desc_valid_app), \
  .m_axis_ctrl_dma_write_desc_ready_app(m_axis_ctrl_dma_write_desc_ready_app), \
  .s_axis_ctrl_dma_write_desc_status_tag_app(s_axis_ctrl_dma_write_desc_status_tag_app), \
  .s_axis_ctrl_dma_write_desc_status_error_app(s_axis_ctrl_dma_write_desc_status_error_app), \
  .s_axis_ctrl_dma_write_desc_status_valid_app(s_axis_ctrl_dma_write_desc_status_valid_app), \
  .m_axis_data_dma_read_desc_dma_addr_app(m_axis_data_dma_read_desc_dma_addr_app), \
  .m_axis_data_dma_read_desc_ram_sel_app(m_axis_data_dma_read_desc_ram_sel_app), \
  .m_axis_data_dma_read_desc_ram_addr_app(m_axis_data_dma_read_desc_ram_addr_app), \
  .m_axis_data_dma_read_desc_len_app(m_axis_data_dma_read_desc_len_app), \
  .m_axis_data_dma_read_desc_tag_app(m_axis_data_dma_read_desc_tag_app), \
  .m_axis_data_dma_read_desc_valid_app(m_axis_data_dma_read_desc_valid_app), \
  .m_axis_data_dma_read_desc_ready_app(m_axis_data_dma_read_desc_ready_app), \
  .s_axis_data_dma_read_desc_status_tag_app(s_axis_data_dma_read_desc_status_tag_app), \
  .s_axis_data_dma_read_desc_status_error_app(s_axis_data_dma_read_desc_status_error_app), \
  .s_axis_data_dma_read_desc_status_valid_app(s_axis_data_dma_read_desc_status_valid_app), \
  .m_axis_data_dma_write_desc_dma_addr_app(m_axis_data_dma_write_desc_dma_addr_app), \
  .m_axis_data_dma_write_desc_ram_sel_app(m_axis_data_dma_write_desc_ram_sel_app), \
  .m_axis_data_dma_write_desc_ram_addr_app(m_axis_data_dma_write_desc_ram_addr_app), \
  .m_axis_data_dma_write_desc_imm_app(m_axis_data_dma_write_desc_imm_app), \
  .m_axis_data_dma_write_desc_imm_en_app(m_axis_data_dma_write_desc_imm_en_app), \
  .m_axis_data_dma_write_desc_len_app(m_axis_data_dma_write_desc_len_app), \
  .m_axis_data_dma_write_desc_tag_app(m_axis_data_dma_write_desc_tag_app), \
  .m_axis_data_dma_write_desc_valid_app(m_axis_data_dma_write_desc_valid_app), \
  .m_axis_data_dma_write_desc_ready_app(m_axis_data_dma_write_desc_ready_app), \
  .s_axis_data_dma_write_desc_status_tag_app(s_axis_data_dma_write_desc_status_tag_app), \
  .s_axis_data_dma_write_desc_status_error_app(s_axis_data_dma_write_desc_status_error_app), \
  .s_axis_data_dma_write_desc_status_valid_app(s_axis_data_dma_write_desc_status_valid_app), \
  .ctrl_dma_ram_wr_cmd_sel_app(ctrl_dma_ram_wr_cmd_sel_app), \
  .ctrl_dma_ram_wr_cmd_be_app(ctrl_dma_ram_wr_cmd_be_app), \
  .ctrl_dma_ram_wr_cmd_addr_app(ctrl_dma_ram_wr_cmd_addr_app), \
  .ctrl_dma_ram_wr_cmd_data_app(ctrl_dma_ram_wr_cmd_data_app), \
  .ctrl_dma_ram_wr_cmd_valid_app(ctrl_dma_ram_wr_cmd_valid_app), \
  .ctrl_dma_ram_wr_cmd_ready_app(ctrl_dma_ram_wr_cmd_ready_app), \
  .ctrl_dma_ram_wr_done_app(ctrl_dma_ram_wr_done_app), \
  .ctrl_dma_ram_rd_cmd_sel_app(ctrl_dma_ram_rd_cmd_sel_app), \
  .ctrl_dma_ram_rd_cmd_addr_app(ctrl_dma_ram_rd_cmd_addr_app), \
  .ctrl_dma_ram_rd_cmd_valid_app(ctrl_dma_ram_rd_cmd_valid_app), \
  .ctrl_dma_ram_rd_cmd_ready_app(ctrl_dma_ram_rd_cmd_ready_app), \
  .ctrl_dma_ram_rd_resp_data_app(ctrl_dma_ram_rd_resp_data_app), \
  .ctrl_dma_ram_rd_resp_valid_app(ctrl_dma_ram_rd_resp_valid_app), \
  .ctrl_dma_ram_rd_resp_ready_app(ctrl_dma_ram_rd_resp_ready_app), \
  .data_dma_ram_wr_cmd_sel_app(data_dma_ram_wr_cmd_sel_app), \
  .data_dma_ram_wr_cmd_be_app(data_dma_ram_wr_cmd_be_app), \
  .data_dma_ram_wr_cmd_addr_app(data_dma_ram_wr_cmd_addr_app), \
  .data_dma_ram_wr_cmd_data_app(data_dma_ram_wr_cmd_data_app), \
  .data_dma_ram_wr_cmd_valid_app(data_dma_ram_wr_cmd_valid_app), \
  .data_dma_ram_wr_cmd_ready_app(data_dma_ram_wr_cmd_ready_app), \
  .data_dma_ram_wr_done_app(data_dma_ram_wr_done_app), \
  .data_dma_ram_rd_cmd_sel_app(data_dma_ram_rd_cmd_sel_app), \
  .data_dma_ram_rd_cmd_addr_app(data_dma_ram_rd_cmd_addr_app), \
  .data_dma_ram_rd_cmd_valid_app(data_dma_ram_rd_cmd_valid_app), \
  .data_dma_ram_rd_cmd_ready_app(data_dma_ram_rd_cmd_ready_app), \
  .data_dma_ram_rd_resp_data_app(data_dma_ram_rd_resp_data_app), \
  .data_dma_ram_rd_resp_valid_app(data_dma_ram_rd_resp_valid_app), \
  .data_dma_ram_rd_resp_ready_app(data_dma_ram_rd_resp_ready_app), \
  .ptp_td_sd_app(ptp_td_sd_app), \
  .ptp_pps_app(ptp_pps_app), \
  .ptp_pps_str_app(ptp_pps_str_app), \
  .ptp_sync_locked_app(ptp_sync_locked_app), \
  .ptp_sync_ts_rel_app(ptp_sync_ts_rel_app), \
  .ptp_sync_ts_rel_step_app(ptp_sync_ts_rel_step_app), \
  .ptp_sync_ts_tod_app(ptp_sync_ts_tod_app), \
  .ptp_sync_ts_tod_step_app(ptp_sync_ts_tod_step_app), \
  .ptp_sync_pps_app(ptp_sync_pps_app), \
  .ptp_sync_pps_str_app(ptp_sync_pps_str_app), \
  .ptp_perout_locked_app(ptp_perout_locked_app), \
  .ptp_perout_error_app(ptp_perout_error_app), \
  .ptp_perout_pulse_app(ptp_perout_pulse_app), \
  .s_axis_direct_tx_tdata_app(s_axis_direct_tx_tdata_app), \
  .s_axis_direct_tx_tkeep_app(s_axis_direct_tx_tkeep_app), \
  .s_axis_direct_tx_tvalid_app(s_axis_direct_tx_tvalid_app), \
  .s_axis_direct_tx_tready_app(s_axis_direct_tx_tready_app), \
  .s_axis_direct_tx_tlast_app(s_axis_direct_tx_tlast_app), \
  .s_axis_direct_tx_tuser_app(s_axis_direct_tx_tuser_app), \
  .m_axis_direct_tx_tdata_app(m_axis_direct_tx_tdata_app), \
  .m_axis_direct_tx_tkeep_app(m_axis_direct_tx_tkeep_app), \
  .m_axis_direct_tx_tvalid_app(m_axis_direct_tx_tvalid_app), \
  .m_axis_direct_tx_tready_app(m_axis_direct_tx_tready_app), \
  .m_axis_direct_tx_tlast_app(m_axis_direct_tx_tlast_app), \
  .m_axis_direct_tx_tuser_app(m_axis_direct_tx_tuser_app), \
  .s_axis_direct_tx_cpl_ts_app(s_axis_direct_tx_cpl_ts_app), \
  .s_axis_direct_tx_cpl_tag_app(s_axis_direct_tx_cpl_tag_app), \
  .s_axis_direct_tx_cpl_valid_app(s_axis_direct_tx_cpl_valid_app), \
  .s_axis_direct_tx_cpl_ready_app(s_axis_direct_tx_cpl_ready_app), \
  .m_axis_direct_tx_cpl_ts_app(m_axis_direct_tx_cpl_ts_app), \
  .m_axis_direct_tx_cpl_tag_app(m_axis_direct_tx_cpl_tag_app), \
  .m_axis_direct_tx_cpl_valid_app(m_axis_direct_tx_cpl_valid_app), \
  .m_axis_direct_tx_cpl_ready_app(m_axis_direct_tx_cpl_ready_app), \
  .s_axis_direct_rx_tdata_app(s_axis_direct_rx_tdata_app), \
  .s_axis_direct_rx_tkeep_app(s_axis_direct_rx_tkeep_app), \
  .s_axis_direct_rx_tvalid_app(s_axis_direct_rx_tvalid_app), \
  .s_axis_direct_rx_tready_app(s_axis_direct_rx_tready_app), \
  .s_axis_direct_rx_tlast_app(s_axis_direct_rx_tlast_app), \
  .s_axis_direct_rx_tuser_app(s_axis_direct_rx_tuser_app), \
  .m_axis_direct_rx_tdata_app(m_axis_direct_rx_tdata_app), \
  .m_axis_direct_rx_tkeep_app(m_axis_direct_rx_tkeep_app), \
  .m_axis_direct_rx_tvalid_app(m_axis_direct_rx_tvalid_app), \
  .m_axis_direct_rx_tready_app(m_axis_direct_rx_tready_app), \
  .m_axis_direct_rx_tlast_app(m_axis_direct_rx_tlast_app), \
  .m_axis_direct_rx_tuser_app(m_axis_direct_rx_tuser_app), \
  .s_axis_sync_tx_tdata_app(s_axis_sync_tx_tdata_app), \
  .s_axis_sync_tx_tkeep_app(s_axis_sync_tx_tkeep_app), \
  .s_axis_sync_tx_tvalid_app(s_axis_sync_tx_tvalid_app), \
  .s_axis_sync_tx_tready_app(s_axis_sync_tx_tready_app), \
  .s_axis_sync_tx_tlast_app(s_axis_sync_tx_tlast_app), \
  .s_axis_sync_tx_tuser_app(s_axis_sync_tx_tuser_app), \
  .m_axis_sync_tx_tdata_app(m_axis_sync_tx_tdata_app), \
  .m_axis_sync_tx_tkeep_app(m_axis_sync_tx_tkeep_app), \
  .m_axis_sync_tx_tvalid_app(m_axis_sync_tx_tvalid_app), \
  .m_axis_sync_tx_tready_app(m_axis_sync_tx_tready_app), \
  .m_axis_sync_tx_tlast_app(m_axis_sync_tx_tlast_app), \
  .m_axis_sync_tx_tuser_app(m_axis_sync_tx_tuser_app), \
  .s_axis_sync_tx_cpl_ts_app(s_axis_sync_tx_cpl_ts_app), \
  .s_axis_sync_tx_cpl_tag_app(s_axis_sync_tx_cpl_tag_app), \
  .s_axis_sync_tx_cpl_valid_app(s_axis_sync_tx_cpl_valid_app), \
  .s_axis_sync_tx_cpl_ready_app(s_axis_sync_tx_cpl_ready_app), \
  .m_axis_sync_tx_cpl_ts_app(m_axis_sync_tx_cpl_ts_app), \
  .m_axis_sync_tx_cpl_tag_app(m_axis_sync_tx_cpl_tag_app), \
  .m_axis_sync_tx_cpl_valid_app(m_axis_sync_tx_cpl_valid_app), \
  .m_axis_sync_tx_cpl_ready_app(m_axis_sync_tx_cpl_ready_app), \
  .s_axis_sync_rx_tdata_app(s_axis_sync_rx_tdata_app), \
  .s_axis_sync_rx_tkeep_app(s_axis_sync_rx_tkeep_app), \
  .s_axis_sync_rx_tvalid_app(s_axis_sync_rx_tvalid_app), \
  .s_axis_sync_rx_tready_app(s_axis_sync_rx_tready_app), \
  .s_axis_sync_rx_tlast_app(s_axis_sync_rx_tlast_app), \
  .s_axis_sync_rx_tuser_app(s_axis_sync_rx_tuser_app), \
  .m_axis_sync_rx_tdata_app(m_axis_sync_rx_tdata_app), \
  .m_axis_sync_rx_tkeep_app(m_axis_sync_rx_tkeep_app), \
  .m_axis_sync_rx_tvalid_app(m_axis_sync_rx_tvalid_app), \
  .m_axis_sync_rx_tready_app(m_axis_sync_rx_tready_app), \
  .m_axis_sync_rx_tlast_app(m_axis_sync_rx_tlast_app), \
  .m_axis_sync_rx_tuser_app(m_axis_sync_rx_tuser_app), \
  .s_axis_if_tx_tdata_app(s_axis_if_tx_tdata_app), \
  .s_axis_if_tx_tkeep_app(s_axis_if_tx_tkeep_app), \
  .s_axis_if_tx_tvalid_app(s_axis_if_tx_tvalid_app), \
  .s_axis_if_tx_tready_app(s_axis_if_tx_tready_app), \
  .s_axis_if_tx_tlast_app(s_axis_if_tx_tlast_app), \
  .s_axis_if_tx_tid_app(s_axis_if_tx_tid_app), \
  .s_axis_if_tx_tdest_app(s_axis_if_tx_tdest_app), \
  .s_axis_if_tx_tuser_app(s_axis_if_tx_tuser_app), \
  .m_axis_if_tx_tdata_app(m_axis_if_tx_tdata_app), \
  .m_axis_if_tx_tkeep_app(m_axis_if_tx_tkeep_app), \
  .m_axis_if_tx_tvalid_app(m_axis_if_tx_tvalid_app), \
  .m_axis_if_tx_tready_app(m_axis_if_tx_tready_app), \
  .m_axis_if_tx_tlast_app(m_axis_if_tx_tlast_app), \
  .m_axis_if_tx_tid_app(m_axis_if_tx_tid_app), \
  .m_axis_if_tx_tdest_app(m_axis_if_tx_tdest_app), \
  .m_axis_if_tx_tuser_app(m_axis_if_tx_tuser_app), \
  .s_axis_if_tx_cpl_ts_app(s_axis_if_tx_cpl_ts_app), \
  .s_axis_if_tx_cpl_tag_app(s_axis_if_tx_cpl_tag_app), \
  .s_axis_if_tx_cpl_valid_app(s_axis_if_tx_cpl_valid_app), \
  .s_axis_if_tx_cpl_ready_app(s_axis_if_tx_cpl_ready_app), \
  .m_axis_if_tx_cpl_ts_app(m_axis_if_tx_cpl_ts_app), \
  .m_axis_if_tx_cpl_tag_app(m_axis_if_tx_cpl_tag_app), \
  .m_axis_if_tx_cpl_valid_app(m_axis_if_tx_cpl_valid_app), \
  .m_axis_if_tx_cpl_ready_app(m_axis_if_tx_cpl_ready_app), \
  .s_axis_if_rx_tdata_app(s_axis_if_rx_tdata_app), \
  .s_axis_if_rx_tkeep_app(s_axis_if_rx_tkeep_app), \
  .s_axis_if_rx_tvalid_app(s_axis_if_rx_tvalid_app), \
  .s_axis_if_rx_tready_app(s_axis_if_rx_tready_app), \
  .s_axis_if_rx_tlast_app(s_axis_if_rx_tlast_app), \
  .s_axis_if_rx_tid_app(s_axis_if_rx_tid_app), \
  .s_axis_if_rx_tdest_app(s_axis_if_rx_tdest_app), \
  .s_axis_if_rx_tuser_app(s_axis_if_rx_tuser_app), \
  .m_axis_if_rx_tdata_app(m_axis_if_rx_tdata_app), \
  .m_axis_if_rx_tkeep_app(m_axis_if_rx_tkeep_app), \
  .m_axis_if_rx_tvalid_app(m_axis_if_rx_tvalid_app), \
  .m_axis_if_rx_tready_app(m_axis_if_rx_tready_app), \
  .m_axis_if_rx_tlast_app(m_axis_if_rx_tlast_app), \
  .m_axis_if_rx_tid_app(m_axis_if_rx_tid_app), \
  .m_axis_if_rx_tdest_app(m_axis_if_rx_tdest_app), \
  .m_axis_if_rx_tuser_app(m_axis_if_rx_tuser_app), \
  .m_axi_ddr_awid_app(m_axi_ddr_awid_app), \
  .m_axi_ddr_awaddr_app(m_axi_ddr_awaddr_app), \
  .m_axi_ddr_awlen_app(m_axi_ddr_awlen_app), \
  .m_axi_ddr_awsize_app(m_axi_ddr_awsize_app), \
  .m_axi_ddr_awburst_app(m_axi_ddr_awburst_app), \
  .m_axi_ddr_awlock_app(m_axi_ddr_awlock_app), \
  .m_axi_ddr_awcache_app(m_axi_ddr_awcache_app), \
  .m_axi_ddr_awprot_app(m_axi_ddr_awprot_app), \
  .m_axi_ddr_awqos_app(m_axi_ddr_awqos_app), \
  .m_axi_ddr_awuser_app(m_axi_ddr_awuser_app), \
  .m_axi_ddr_awvalid_app(m_axi_ddr_awvalid_app), \
  .m_axi_ddr_awready_app(m_axi_ddr_awready_app), \
  .m_axi_ddr_wdata_app(m_axi_ddr_wdata_app), \
  .m_axi_ddr_wstrb_app(m_axi_ddr_wstrb_app), \
  .m_axi_ddr_wlast_app(m_axi_ddr_wlast_app), \
  .m_axi_ddr_wuser_app(m_axi_ddr_wuser_app), \
  .m_axi_ddr_wvalid_app(m_axi_ddr_wvalid_app), \
  .m_axi_ddr_wready_app(m_axi_ddr_wready_app), \
  .m_axi_ddr_bid_app(m_axi_ddr_bid_app), \
  .m_axi_ddr_bresp_app(m_axi_ddr_bresp_app), \
  .m_axi_ddr_buser_app(m_axi_ddr_buser_app), \
  .m_axi_ddr_bvalid_app(m_axi_ddr_bvalid_app), \
  .m_axi_ddr_bready_app(m_axi_ddr_bready_app), \
  .m_axi_ddr_arid_app(m_axi_ddr_arid_app), \
  .m_axi_ddr_araddr_app(m_axi_ddr_araddr_app), \
  .m_axi_ddr_arlen_app(m_axi_ddr_arlen_app), \
  .m_axi_ddr_arsize_app(m_axi_ddr_arsize_app), \
  .m_axi_ddr_arburst_app(m_axi_ddr_arburst_app), \
  .m_axi_ddr_arlock_app(m_axi_ddr_arlock_app), \
  .m_axi_ddr_arcache_app(m_axi_ddr_arcache_app), \
  .m_axi_ddr_arprot_app(m_axi_ddr_arprot_app), \
  .m_axi_ddr_arqos_app(m_axi_ddr_arqos_app), \
  .m_axi_ddr_aruser_app(m_axi_ddr_aruser_app), \
  .m_axi_ddr_arvalid_app(m_axi_ddr_arvalid_app), \
  .m_axi_ddr_arready_app(m_axi_ddr_arready_app), \
  .m_axi_ddr_rid_app(m_axi_ddr_rid_app), \
  .m_axi_ddr_rdata_app(m_axi_ddr_rdata_app), \
  .m_axi_ddr_rresp_app(m_axi_ddr_rresp_app), \
  .m_axi_ddr_rlast_app(m_axi_ddr_rlast_app), \
  .m_axi_ddr_ruser_app(m_axi_ddr_ruser_app), \
  .m_axi_ddr_rvalid_app(m_axi_ddr_rvalid_app), \
  .m_axi_ddr_rready_app(m_axi_ddr_rready_app), \
  .ddr_status_app(ddr_status_app), \
  .m_axi_hbm_awid_app(m_axi_hbm_awid_app), \
  .m_axi_hbm_awaddr_app(m_axi_hbm_awaddr_app), \
  .m_axi_hbm_awlen_app(m_axi_hbm_awlen_app), \
  .m_axi_hbm_awsize_app(m_axi_hbm_awsize_app), \
  .m_axi_hbm_awburst_app(m_axi_hbm_awburst_app), \
  .m_axi_hbm_awlock_app(m_axi_hbm_awlock_app), \
  .m_axi_hbm_awcache_app(m_axi_hbm_awcache_app), \
  .m_axi_hbm_awprot_app(m_axi_hbm_awprot_app), \
  .m_axi_hbm_awqos_app(m_axi_hbm_awqos_app), \
  .m_axi_hbm_awuser_app(m_axi_hbm_awuser_app), \
  .m_axi_hbm_awvalid_app(m_axi_hbm_awvalid_app), \
  .m_axi_hbm_awready_app(m_axi_hbm_awready_app), \
  .m_axi_hbm_wdata_app(m_axi_hbm_wdata_app), \
  .m_axi_hbm_wstrb_app(m_axi_hbm_wstrb_app), \
  .m_axi_hbm_wlast_app(m_axi_hbm_wlast_app), \
  .m_axi_hbm_wuser_app(m_axi_hbm_wuser_app), \
  .m_axi_hbm_wvalid_app(m_axi_hbm_wvalid_app), \
  .m_axi_hbm_wready_app(m_axi_hbm_wready_app), \
  .m_axi_hbm_bid_app(m_axi_hbm_bid_app), \
  .m_axi_hbm_bresp_app(m_axi_hbm_bresp_app), \
  .m_axi_hbm_buser_app(m_axi_hbm_buser_app), \
  .m_axi_hbm_bvalid_app(m_axi_hbm_bvalid_app), \
  .m_axi_hbm_bready_app(m_axi_hbm_bready_app), \
  .m_axi_hbm_arid_app(m_axi_hbm_arid_app), \
  .m_axi_hbm_araddr_app(m_axi_hbm_araddr_app), \
  .m_axi_hbm_arlen_app(m_axi_hbm_arlen_app), \
  .m_axi_hbm_arsize_app(m_axi_hbm_arsize_app), \
  .m_axi_hbm_arburst_app(m_axi_hbm_arburst_app), \
  .m_axi_hbm_arlock_app(m_axi_hbm_arlock_app), \
  .m_axi_hbm_arcache_app(m_axi_hbm_arcache_app), \
  .m_axi_hbm_arprot_app(m_axi_hbm_arprot_app), \
  .m_axi_hbm_arqos_app(m_axi_hbm_arqos_app), \
  .m_axi_hbm_aruser_app(m_axi_hbm_aruser_app), \
  .m_axi_hbm_arvalid_app(m_axi_hbm_arvalid_app), \
  .m_axi_hbm_arready_app(m_axi_hbm_arready_app), \
  .m_axi_hbm_rid_app(m_axi_hbm_rid_app), \
  .m_axi_hbm_rdata_app(m_axi_hbm_rdata_app), \
  .m_axi_hbm_rresp_app(m_axi_hbm_rresp_app), \
  .m_axi_hbm_rlast_app(m_axi_hbm_rlast_app), \
  .m_axi_hbm_ruser_app(m_axi_hbm_ruser_app), \
  .m_axi_hbm_rvalid_app(m_axi_hbm_rvalid_app), \
  .m_axi_hbm_rready_app(m_axi_hbm_rready_app), \
  .hbm_status_app(hbm_status_app), \
  .m_axis_stat_tdata_app(m_axis_stat_tdata_app), \
  .m_axis_stat_tid_app(m_axis_stat_tid_app), \
  .m_axis_stat_tvalid_app(m_axis_stat_tvalid_app), \
  .m_axis_stat_tready_app(m_axis_stat_tready_app),
