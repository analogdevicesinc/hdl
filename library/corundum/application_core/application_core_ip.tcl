###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create application_core

# Corundum sources
adi_ip_files application_core [list \
  "application_core.v" \
  "application_tx.v" \
  "application_rx.v" \
  "header_checker.v" \
  "header_inserter.v" \
  "header_extractor.v" \
  "packetizer.v" \
  "udp_header.v" \
  "ip_header.v" \
  "ethernet_header.v" \
  "udp_header_mask.v" \
  "ip_header_mask.v" \
  "ethernet_header_mask.v" \
  "prbs.v" \
  "prbs_gen.v" \
  "prbs_mon.v" \
  "ber_tester_tx.v" \
  "ber_tester_rx.v" \
  "ber_tester.v" \
  "application_regmap.v" \
  "macro_definitions.vh" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "application_core_constr.ttcl" \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/util_cdc/sync_gray.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "$ad_hdl_dir/library/util_cdc/sync_event.v" \
  "$ad_hdl_dir/library/util_axis_fifo_asym/util_axis_fifo_asym.v" \
  "$ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v" \
  "$ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v" \
]

set_property verilog_define {APP_CUSTOM_PARAMS_ENABLE APP_CUSTOM_PORTS_ENABLE} [current_fileset]

adi_ip_properties_lite application_core
adi_ip_ttcl application_core "application_core_constr.ttcl"

set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Application Core" $cc
set_property description "Application Core AXI IP" $cc

# Remove all inferred interfaces and address spaces
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

## Interface definitions

adi_add_bus "s_axil_ctrl" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"s_axil_ctrl_awaddr" "AWADDR"} \
    {"s_axil_ctrl_awprot" "AWPROT"} \
    {"s_axil_ctrl_awvalid" "AWVALID"} \
    {"s_axil_ctrl_awready" "AWREADY"} \
    {"s_axil_ctrl_wdata" "WDATA"} \
    {"s_axil_ctrl_wstrb" "WSTRB"} \
    {"s_axil_ctrl_wvalid" "WVALID"} \
    {"s_axil_ctrl_wready" "WREADY"} \
    {"s_axil_ctrl_bresp" "BRESP"} \
    {"s_axil_ctrl_bvalid" "BVALID"} \
    {"s_axil_ctrl_bready" "BREADY"} \
    {"s_axil_ctrl_araddr" "ARADDR"} \
    {"s_axil_ctrl_arprot" "ARPROT"} \
    {"s_axil_ctrl_arvalid" "ARVALID"} \
    {"s_axil_ctrl_arready" "ARREADY"} \
    {"s_axil_ctrl_rdata" "RDATA"} \
    {"s_axil_ctrl_rresp" "RRESP"} \
    {"s_axil_ctrl_rvalid" "RVALID"} \
    {"s_axil_ctrl_rready" "RREADY"} \
  }

adi_add_bus "m_axi_ddr" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_ddr_awid" "AWID"} \
    {"m_axi_ddr_awaddr" "AWADDR"} \
    {"m_axi_ddr_awlen" "AWLEN"} \
    {"m_axi_ddr_awsize" "AWSIZE"} \
    {"m_axi_ddr_awuser" "AWUSER"} \
    {"m_axi_ddr_awburst" "AWBURST"} \
    {"m_axi_ddr_awlock" "AWLOCK"} \
    {"m_axi_ddr_awcache" "AWCACHE"} \
    {"m_axi_ddr_awprot" "AWPROT"} \
    {"m_axi_ddr_awqos" "AWQOS"} \
    {"m_axi_ddr_awvalid" "AWVALID"} \
    {"m_axi_ddr_awready" "AWREADY"} \
    {"m_axi_ddr_wdata" "WDATA"} \
    {"m_axi_ddr_wstrb" "WSTRB"} \
    {"m_axi_ddr_wlast" "WLAST"} \
    {"m_axi_ddr_wvalid" "WVALID"} \
    {"m_axi_ddr_wready" "WREADY"} \
    {"m_axi_ddr_wuser" "WUSER"} \
    {"m_axi_ddr_bid" "BID"} \
    {"m_axi_ddr_bresp" "BRESP"} \
    {"m_axi_ddr_buser" "BUSER"} \
    {"m_axi_ddr_bvalid" "BVALID"} \
    {"m_axi_ddr_bready" "BREADY"} \
    {"m_axi_ddr_arid" "ARID"} \
    {"m_axi_ddr_araddr" "ARADDR"} \
    {"m_axi_ddr_arlen" "ARLEN"} \
    {"m_axi_ddr_arsize" "ARSIZE"} \
    {"m_axi_ddr_aruser" "ARUSER"} \
    {"m_axi_ddr_arburst" "ARBURST"} \
    {"m_axi_ddr_arlock" "ARLOCK"} \
    {"m_axi_ddr_arcache" "ARCACHE"} \
    {"m_axi_ddr_arprot" "ARPROT"} \
    {"m_axi_ddr_arqos" "ARQOS"} \
    {"m_axi_ddr_arvalid" "ARVALID"} \
    {"m_axi_ddr_arready" "ARREADY"} \
    {"m_axi_ddr_rid" "RID"} \
    {"m_axi_ddr_rdata" "RDATA"} \
    {"m_axi_ddr_rresp" "RRESP"} \
    {"m_axi_ddr_ruser" "RUSER"} \
    {"m_axi_ddr_rlast" "RLAST"} \
    {"m_axi_ddr_rvalid" "RVALID"} \
    {"m_axi_ddr_rready" "RREADY"} \
  }

adi_add_bus "m_axi_hbm" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_hbm_awid" "AWID"} \
    {"m_axi_hbm_awaddr" "AWADDR"} \
    {"m_axi_hbm_awlen" "AWLEN"} \
    {"m_axi_hbm_awsize" "AWSIZE"} \
    {"m_axi_hbm_awuser" "AWUSER"} \
    {"m_axi_hbm_awburst" "AWBURST"} \
    {"m_axi_hbm_awlock" "AWLOCK"} \
    {"m_axi_hbm_awcache" "AWCACHE"} \
    {"m_axi_hbm_awprot" "AWPROT"} \
    {"m_axi_hbm_awqos" "AWQOS"} \
    {"m_axi_hbm_awvalid" "AWVALID"} \
    {"m_axi_hbm_awready" "AWREADY"} \
    {"m_axi_hbm_wdata" "WDATA"} \
    {"m_axi_hbm_wstrb" "WSTRB"} \
    {"m_axi_hbm_wlast" "WLAST"} \
    {"m_axi_hbm_wvalid" "WVALID"} \
    {"m_axi_hbm_wready" "WREADY"} \
    {"m_axi_hbm_wuser" "WUSER"} \
    {"m_axi_hbm_bid" "BID"} \
    {"m_axi_hbm_bresp" "BRESP"} \
    {"m_axi_hbm_buser" "BUSER"} \
    {"m_axi_hbm_bvalid" "BVALID"} \
    {"m_axi_hbm_bready" "BREADY"} \
    {"m_axi_hbm_arid" "ARID"} \
    {"m_axi_hbm_araddr" "ARADDR"} \
    {"m_axi_hbm_arlen" "ARLEN"} \
    {"m_axi_hbm_arsize" "ARSIZE"} \
    {"m_axi_hbm_aruser" "ARUSER"} \
    {"m_axi_hbm_arburst" "ARBURST"} \
    {"m_axi_hbm_arlock" "ARLOCK"} \
    {"m_axi_hbm_arcache" "ARCACHE"} \
    {"m_axi_hbm_arprot" "ARPROT"} \
    {"m_axi_hbm_arqos" "ARQOS"} \
    {"m_axi_hbm_arvalid" "ARVALID"} \
    {"m_axi_hbm_arready" "ARREADY"} \
    {"m_axi_hbm_rid" "RID"} \
    {"m_axi_hbm_rdata" "RDATA"} \
    {"m_axi_hbm_rresp" "RRESP"} \
    {"m_axi_hbm_ruser" "RUSER"} \
    {"m_axi_hbm_rlast" "RLAST"} \
    {"m_axi_hbm_rvalid" "RVALID"} \
    {"m_axi_hbm_rready" "RREADY"} \
  }

adi_add_bus "s_axis_direct_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_direct_tx_tdata" "TDATA"} \
    {"s_axis_direct_tx_tkeep" "TKEEP"} \
    {"s_axis_direct_tx_tvalid" "TVALID"} \
    {"s_axis_direct_tx_tready" "TREADY"} \
    {"s_axis_direct_tx_tlast" "TLAST"} \
    {"s_axis_direct_tx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_direct_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_direct_tx_tdata" "TDATA"} \
    {"m_axis_direct_tx_tkeep" "TKEEP"} \
    {"m_axis_direct_tx_tvalid" "TVALID"} \
    {"m_axis_direct_tx_tready" "TREADY"} \
    {"m_axis_direct_tx_tlast" "TLAST"} \
    {"m_axis_direct_tx_tuser" "TUSER"} \
  }

adi_add_bus "s_axis_direct_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_direct_rx_tdata" "TDATA"} \
    {"s_axis_direct_rx_tkeep" "TKEEP"} \
    {"s_axis_direct_rx_tvalid" "TVALID"} \
    {"s_axis_direct_rx_tready" "TREADY"} \
    {"s_axis_direct_rx_tlast" "TLAST"} \
    {"s_axis_direct_rx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_direct_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_direct_rx_tdata" "TDATA"} \
    {"m_axis_direct_rx_tkeep" "TKEEP"} \
    {"m_axis_direct_rx_tvalid" "TVALID"} \
    {"m_axis_direct_rx_tready" "TREADY"} \
    {"m_axis_direct_rx_tlast" "TLAST"} \
    {"m_axis_direct_rx_tuser" "TUSER"} \
  }

adi_add_bus "s_axis_sync_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_sync_tx_tdata" "TDATA"} \
    {"s_axis_sync_tx_tkeep" "TKEEP"} \
    {"s_axis_sync_tx_tvalid" "TVALID"} \
    {"s_axis_sync_tx_tready" "TREADY"} \
    {"s_axis_sync_tx_tlast" "TLAST"} \
    {"s_axis_sync_tx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_sync_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_sync_tx_tdata" "TDATA"} \
    {"m_axis_sync_tx_tkeep" "TKEEP"} \
    {"m_axis_sync_tx_tvalid" "TVALID"} \
    {"m_axis_sync_tx_tready" "TREADY"} \
    {"m_axis_sync_tx_tlast" "TLAST"} \
    {"m_axis_sync_tx_tuser" "TUSER"} \
  }

adi_add_bus "s_axis_sync_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_sync_rx_tdata" "TDATA"} \
    {"s_axis_sync_rx_tkeep" "TKEEP"} \
    {"s_axis_sync_rx_tvalid" "TVALID"} \
    {"s_axis_sync_rx_tready" "TREADY"} \
    {"s_axis_sync_rx_tlast" "TLAST"} \
    {"s_axis_sync_rx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_sync_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_sync_rx_tdata" "TDATA"} \
    {"m_axis_sync_rx_tkeep" "TKEEP"} \
    {"m_axis_sync_rx_tvalid" "TVALID"} \
    {"m_axis_sync_rx_tready" "TREADY"} \
    {"m_axis_sync_rx_tlast" "TLAST"} \
    {"m_axis_sync_rx_tuser" "TUSER"} \
  }

adi_add_bus "s_axis_if_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_if_tx_tdata" "TDATA"} \
    {"s_axis_if_tx_tkeep" "TKEEP"} \
    {"s_axis_if_tx_tvalid" "TVALID"} \
    {"s_axis_if_tx_tready" "TREADY"} \
    {"s_axis_if_tx_tlast" "TLAST"} \
    {"s_axis_if_tx_tid" "TID"} \
    {"s_axis_if_tx_tdest" "TDEST"} \
    {"s_axis_if_tx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_if_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_if_tx_tdata" "TDATA"} \
    {"m_axis_if_tx_tkeep" "TKEEP"} \
    {"m_axis_if_tx_tvalid" "TVALID"} \
    {"m_axis_if_tx_tready" "TREADY"} \
    {"m_axis_if_tx_tlast" "TLAST"} \
    {"m_axis_if_tx_tid" "TID"} \
    {"m_axis_if_tx_tdest" "TDEST"} \
    {"m_axis_if_tx_tuser" "TUSER"} \
  }

adi_add_bus "s_axis_if_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_if_rx_tdata" "TDATA"} \
    {"s_axis_if_rx_tkeep" "TKEEP"} \
    {"s_axis_if_rx_tvalid" "TVALID"} \
    {"s_axis_if_rx_tready" "TREADY"} \
    {"s_axis_if_rx_tlast" "TLAST"} \
    {"s_axis_if_rx_tid" "TID"} \
    {"s_axis_if_rx_tdest" "TDEST"} \
    {"s_axis_if_rx_tuser" "TUSER"} \
  }

adi_add_bus "m_axis_if_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_if_rx_tdata" "TDATA"} \
    {"m_axis_if_rx_tkeep" "TKEEP"} \
    {"m_axis_if_rx_tvalid" "TVALID"} \
    {"m_axis_if_rx_tready" "TREADY"} \
    {"m_axis_if_rx_tlast" "TLAST"} \
    {"m_axis_if_rx_tid" "TID"} \
    {"m_axis_if_rx_tdest" "TDEST"} \
    {"m_axis_if_rx_tuser" "TUSER"} \
  }

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master s_axis_direct_tx_cpl [list \
  "ts    s_axis_direct_tx_cpl_ts" \
  "tag   s_axis_direct_tx_cpl_tag" \
  "valid s_axis_direct_tx_cpl_valid" \
  "ready s_axis_direct_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave m_axis_direct_tx_cpl [list \
  "ts    m_axis_direct_tx_cpl_ts" \
  "tag   m_axis_direct_tx_cpl_tag" \
  "valid m_axis_direct_tx_cpl_valid" \
  "ready m_axis_direct_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master s_axis_sync_tx_cpl [list \
  "ts    s_axis_sync_tx_cpl_ts" \
  "tag   s_axis_sync_tx_cpl_tag" \
  "valid s_axis_sync_tx_cpl_valid" \
  "ready s_axis_sync_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave m_axis_sync_tx_cpl [list \
  "ts    m_axis_sync_tx_cpl_ts" \
  "tag   m_axis_sync_tx_cpl_tag" \
  "valid m_axis_sync_tx_cpl_valid" \
  "ready m_axis_sync_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master s_axis_if_tx_cpl [list \
  "ts    s_axis_if_tx_cpl_ts" \
  "tag   s_axis_if_tx_cpl_tag" \
  "valid s_axis_if_tx_cpl_valid" \
  "ready s_axis_if_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave m_axis_if_tx_cpl [list \
  "ts    m_axis_if_tx_cpl_ts" \
  "tag   m_axis_if_tx_cpl_tag" \
  "valid m_axis_if_tx_cpl_valid" \
  "ready m_axis_if_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_ptp slave ptp_clock [list \
  "ptp_td_sd            ptp_td_sd" \
  "ptp_pps              ptp_pps" \
  "ptp_pps_str          ptp_pps_str" \
  "ptp_sync_locked      ptp_sync_locked" \
  "ptp_sync_ts_rel      ptp_sync_ts_rel" \
  "ptp_sync_ts_rel_step ptp_sync_ts_rel_step" \
  "ptp_sync_ts_tod      ptp_sync_ts_tod" \
  "ptp_sync_ts_tod_step ptp_sync_ts_tod_step" \
  "ptp_sync_pps         ptp_sync_pps" \
  "ptp_sync_pps_str     ptp_sync_pps_str" \
  "ptp_perout_locked    ptp_perout_locked" \
  "ptp_perout_error     ptp_perout_error" \
  "ptp_perout_pulse     ptp_perout_pulse" \
]

adi_add_bus "m_axil_ctrl" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axil_ctrl_awaddr" "AWADDR"} \
    {"m_axil_ctrl_awprot" "AWPROT"} \
    {"m_axil_ctrl_awvalid" "AWVALID"} \
    {"m_axil_ctrl_awready" "AWREADY"} \
    {"m_axil_ctrl_wdata" "WDATA"} \
    {"m_axil_ctrl_wstrb" "WSTRB"} \
    {"m_axil_ctrl_wvalid" "WVALID"} \
    {"m_axil_ctrl_wready" "WREADY"} \
    {"m_axil_ctrl_bresp" "BRESP"} \
    {"m_axil_ctrl_bvalid" "BVALID"} \
    {"m_axil_ctrl_bready" "BREADY"} \
    {"m_axil_ctrl_araddr" "ARADDR"} \
    {"m_axil_ctrl_arprot" "ARPROT"} \
    {"m_axil_ctrl_arvalid" "ARVALID"} \
    {"m_axil_ctrl_arready" "ARREADY"} \
    {"m_axil_ctrl_rdata" "RDATA"} \
    {"m_axil_ctrl_rresp" "RRESP"} \
    {"m_axil_ctrl_rvalid" "RVALID"} \
    {"m_axil_ctrl_rready" "RREADY"} \
  }

adi_if_infer_bus analog.com:interface:if_axis_dma_desc master m_axis_ctrl_dma_read_desc [list \
  "dma_addr m_axis_ctrl_dma_read_desc_dma_addr" \
  "ram_sel  m_axis_ctrl_dma_read_desc_ram_sel" \
  "ram_addr m_axis_ctrl_dma_read_desc_ram_addr" \
  "len      m_axis_ctrl_dma_read_desc_len" \
  "tag      m_axis_ctrl_dma_read_desc_tag" \
  "valid    m_axis_ctrl_dma_read_desc_valid" \
  "ready    m_axis_ctrl_dma_read_desc_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc master m_axis_ctrl_dma_write_desc [list \
  "dma_addr m_axis_ctrl_dma_write_desc_dma_addr" \
  "ram_sel  m_axis_ctrl_dma_write_desc_ram_sel" \
  "ram_addr m_axis_ctrl_dma_write_desc_ram_addr" \
  "imm      m_axis_ctrl_dma_write_desc_imm" \
  "imm_en   m_axis_ctrl_dma_write_desc_imm_en" \
  "len      m_axis_ctrl_dma_write_desc_len" \
  "tag      m_axis_ctrl_dma_write_desc_tag" \
  "valid    m_axis_ctrl_dma_write_desc_valid" \
  "ready    m_axis_ctrl_dma_write_desc_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc master m_axis_data_dma_read_desc [list \
  "dma_addr m_axis_data_dma_read_desc_dma_addr" \
  "ram_sel  m_axis_data_dma_read_desc_ram_sel" \
  "ram_addr m_axis_data_dma_read_desc_ram_addr" \
  "len      m_axis_data_dma_read_desc_len" \
  "tag      m_axis_data_dma_read_desc_tag" \
  "valid    m_axis_data_dma_read_desc_valid" \
  "ready    m_axis_data_dma_read_desc_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc master m_axis_data_dma_write_desc [list \
  "dma_addr m_axis_data_dma_write_desc_dma_addr" \
  "ram_sel  m_axis_data_dma_write_desc_ram_sel" \
  "ram_addr m_axis_data_dma_write_desc_ram_addr" \
  "imm      m_axis_data_dma_write_desc_imm" \
  "imm_en   m_axis_data_dma_write_desc_imm_en" \
  "len      m_axis_data_dma_write_desc_len" \
  "tag      m_axis_data_dma_write_desc_tag" \
  "valid    m_axis_data_dma_write_desc_valid" \
  "ready    m_axis_data_dma_write_desc_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status slave s_axis_ctrl_dma_read_desc_status [list \
  "tag   s_axis_ctrl_dma_read_desc_status_tag" \
  "error s_axis_ctrl_dma_read_desc_status_error" \
  "valid s_axis_ctrl_dma_read_desc_status_valid" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status slave s_axis_ctrl_dma_write_desc_status [list \
  "tag   s_axis_ctrl_dma_write_desc_status_tag" \
  "error s_axis_ctrl_dma_write_desc_status_error" \
  "valid s_axis_ctrl_dma_write_desc_status_valid" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status slave s_axis_data_dma_read_desc_status [list \
  "tag   s_axis_data_dma_read_desc_status_tag" \
  "error s_axis_data_dma_read_desc_status_error" \
  "valid s_axis_data_dma_read_desc_status_valid" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status slave s_axis_data_dma_write_desc_status [list \
  "tag   s_axis_data_dma_write_desc_status_tag" \
  "error s_axis_data_dma_write_desc_status_error" \
  "valid s_axis_data_dma_write_desc_status_valid" \
]

adi_if_infer_bus analog.com:interface:if_dma_ram master ctrl_dma_ram [list \
  "wr_cmd_sel    ctrl_dma_ram_wr_cmd_sel" \
  "wr_cmd_be     ctrl_dma_ram_wr_cmd_be" \
  "wr_cmd_addr   ctrl_dma_ram_wr_cmd_addr" \
  "wr_cmd_data   ctrl_dma_ram_wr_cmd_data" \
  "wr_cmd_valid  ctrl_dma_ram_wr_cmd_valid" \
  "wr_cmd_ready  ctrl_dma_ram_wr_cmd_ready" \
  "wr_done       ctrl_dma_ram_wr_done" \
  "rd_cmd_sel    ctrl_dma_ram_rd_cmd_sel" \
  "rd_cmd_addr   ctrl_dma_ram_rd_cmd_addr" \
  "rd_cmd_valid  ctrl_dma_ram_rd_cmd_valid" \
  "rd_cmd_ready  ctrl_dma_ram_rd_cmd_ready" \
  "rd_resp_data  ctrl_dma_ram_rd_resp_data" \
  "rd_resp_valid ctrl_dma_ram_rd_resp_valid" \
  "rd_resp_ready ctrl_dma_ram_rd_resp_ready" \
]

adi_if_infer_bus analog.com:interface:if_dma_ram master data_dma_ram [list \
  "wr_cmd_sel    data_dma_ram_wr_cmd_sel" \
  "wr_cmd_be     data_dma_ram_wr_cmd_be" \
  "wr_cmd_addr   data_dma_ram_wr_cmd_addr" \
  "wr_cmd_data   data_dma_ram_wr_cmd_data" \
  "wr_cmd_valid  data_dma_ram_wr_cmd_valid" \
  "wr_cmd_ready  data_dma_ram_wr_cmd_ready" \
  "wr_done       data_dma_ram_wr_done" \
  "rd_cmd_sel    data_dma_ram_rd_cmd_sel" \
  "rd_cmd_addr   data_dma_ram_rd_cmd_addr" \
  "rd_cmd_valid  data_dma_ram_rd_cmd_valid" \
  "rd_cmd_ready  data_dma_ram_rd_cmd_ready" \
  "rd_resp_data  data_dma_ram_rd_resp_data" \
  "rd_resp_valid data_dma_ram_rd_resp_valid" \
  "rd_resp_ready data_dma_ram_rd_resp_ready" \
]

adi_if_infer_bus analog.com:interface:if_axis_stat master m_axis_stat [list \
  "tdata  m_axis_stat_tdata" \
  "tid    m_axis_stat_tid" \
  "tvalid m_axis_stat_tvalid" \
  "tready m_axis_stat_tready" \
]

adi_if_infer_bus analog.com:interface:if_jtag master jtag [list \
  "tdi jtag_tdi" \
  "tdo jtag_tdo" \
  "tms jtag_tms" \
  "tck jtag_tck" \
]

adi_if_infer_bus analog.com:interface:if_gpio master gpio [list \
  "gpio_in  gpio_in" \
  "gpio_out gpio_out" \
]

adi_add_bus "input_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"input_axis_tdata" "TDATA"} \
    {"input_axis_tvalid" "TVALID"} \
    {"input_axis_tready" "TREADY"} \
  }

adi_add_bus "output_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"output_axis_tdata" "TDATA"} \
    {"output_axis_tvalid" "TVALID"} \
    {"output_axis_tready" "TREADY"} \
  }

# Bus-clock association

adi_add_bus_clock "clk" "s_axil_ctrl:s_axis_sync_tx:m_axis_sync_tx:s_axis_sync_rx:m_axis_sync_rx:s_axis_if_tx:m_axis_if_tx:s_axis_if_rx:m_axis_if_rx:m_axil_ctrl" "rst"
adi_add_bus_clock "ddr_clk" "m_axi_ddr" "ddr_rst"
adi_add_bus_clock "hbm_clk" "m_axi_hbm" "hbm_rst"
adi_add_bus_clock "direct_tx_clk" "s_axis_direct_tx:m_axis_direct_tx" "direct_tx_rst"
adi_add_bus_clock "direct_rx_clk" "s_axis_direct_rx:m_axis_direct_rx" "direct_rx_rst"
adi_add_bus_clock "input_clk" "input_axis" "input_rstn"
adi_add_bus_clock "output_clk" "output_axis" "output_rstn"

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
