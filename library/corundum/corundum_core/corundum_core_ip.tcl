###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create corundum_core

# Corundum sources
adi_ip_files corundum_core [list \
  "corundum_core.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_core_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_core.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_dram_if.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_egress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ingress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_l2_egress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_l2_ingress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_rx_queue_map.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp_clock.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp_perout.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_rb_clk_info.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_write.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_op_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/desc_fetch.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/desc_op_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/queue_manager.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_queue_manager.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_req_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_engine.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_engine.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_checksum.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_hash.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_checksum.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_counter.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_collect.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_if_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_latency.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_tx_scheduler_block_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_scheduler_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_perout.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_phc.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_leaf.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_rel2tod.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_addr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_register_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_register_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/arbiter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/priority_encoder.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_arb_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_demux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_pipeline_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/irq_rate_limit.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_desc_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_ram_demux_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_ram_demux_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_psdpram.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_client_axis_sink.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_client_axis_source.v" \
  "mqnic_app_block.v" \
  "mqnic_app_custom_ports.vh" \
  "mqnic_app_custom_params.vh" \
]

set_property verilog_define {APP_CUSTOM_PARAMS_ENABLE APP_CUSTOM_PORTS_ENABLE} [current_fileset]

adi_ip_properties_lite corundum_core
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum/corundum_core} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Corundum Core" $cc
set_property description "Corundum MQNIC Core AXI IP" $cc

# Remove all inferred interfaces and address spaces
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

## Interface definitions

# Base IP interfaces

adi_add_bus "m_axi" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_awid" "AWID"} \
    {"m_axi_awaddr" "AWADDR"} \
    {"m_axi_awlen" "AWLEN"} \
    {"m_axi_awsize" "AWSIZE"} \
    {"m_axi_awburst" "AWBURST"} \
    {"m_axi_awlock" "AWLOCK"} \
    {"m_axi_awcache" "AWCACHE"} \
    {"m_axi_awprot" "AWPROT"} \
    {"m_axi_awvalid" "AWVALID"} \
    {"m_axi_awready" "AWREADY"} \
    {"m_axi_wdata" "WDATA"} \
    {"m_axi_wstrb" "WSTRB"} \
    {"m_axi_wlast" "WLAST"} \
    {"m_axi_wvalid" "WVALID"} \
    {"m_axi_wready" "WREADY"} \
    {"m_axi_bid" "BID"} \
    {"m_axi_bresp" "BRESP"} \
    {"m_axi_bvalid" "BVALID"} \
    {"m_axi_bready" "BREADY"} \
    {"m_axi_arid" "ARID"} \
    {"m_axi_araddr" "ARADDR"} \
    {"m_axi_arlen" "ARLEN"} \
    {"m_axi_arsize" "ARSIZE"} \
    {"m_axi_arburst" "ARBURST"} \
    {"m_axi_arlock" "ARLOCK"} \
    {"m_axi_arcache" "ARCACHE"} \
    {"m_axi_arprot" "ARPROT"} \
    {"m_axi_arvalid" "ARVALID"} \
    {"m_axi_arready" "ARREADY"} \
    {"m_axi_rid" "RID"} \
    {"m_axi_rdata" "RDATA"} \
    {"m_axi_rresp" "RRESP"} \
    {"m_axi_rlast" "RLAST"} \
    {"m_axi_rvalid" "RVALID"} \
    {"m_axi_rready" "RREADY"} \
  }
ipx::infer_address_space [ipx::get_bus_interfaces m_axi -of_objects $cc]

# ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 $cc

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

adi_add_bus "m_axil_csr" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axil_csr_awaddr" "AWADDR"} \
    {"m_axil_csr_awprot" "AWPROT"} \
    {"m_axil_csr_awvalid" "AWVALID"} \
    {"m_axil_csr_awready" "AWREADY"} \
    {"m_axil_csr_wdata" "WDATA"} \
    {"m_axil_csr_wstrb" "WSTRB"} \
    {"m_axil_csr_wvalid" "WVALID"} \
    {"m_axil_csr_wready" "WREADY"} \
    {"m_axil_csr_bresp" "BRESP"} \
    {"m_axil_csr_bvalid" "BVALID"} \
    {"m_axil_csr_bready" "BREADY"} \
    {"m_axil_csr_araddr" "ARADDR"} \
    {"m_axil_csr_arprot" "ARPROT"} \
    {"m_axil_csr_arvalid" "ARVALID"} \
    {"m_axil_csr_arready" "ARREADY"} \
    {"m_axil_csr_rdata" "RDATA"} \
    {"m_axil_csr_rresp" "RRESP"} \
    {"m_axil_csr_rvalid" "RVALID"} \
    {"m_axil_csr_rready" "RREADY"} \
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
ipx::infer_address_space [ipx::get_bus_interfaces m_axi_ddr -of_objects $cc]

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
ipx::infer_address_space [ipx::get_bus_interfaces m_axi_hbm -of_objects $cc]

adi_add_bus "m_axis_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"m_axis_tx_tdata" "TDATA"} \
    {"m_axis_tx_tkeep" "TKEEP"} \
    {"m_axis_tx_tvalid" "TVALID"} \
    {"m_axis_tx_tready" "TREADY"} \
    {"m_axis_tx_tlast" "TLAST"} \
    {"m_axis_tx_tuser" "TUSER"} ]

adi_add_bus "s_axis_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_rx_tdata" "TDATA"} \
    {"s_axis_rx_tkeep" "TKEEP"} \
    {"s_axis_rx_tvalid" "TVALID"} \
    {"s_axis_rx_tready" "TREADY"} \
    {"s_axis_rx_tlast" "TLAST"} \
    {"s_axis_rx_tuser" "TUSER"} ]

adi_add_bus "s_axis_stat" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_stat_tdata" "TDATA"} \
    {"s_axis_stat_tid" "TID"} \
    {"s_axis_stat_tvalid" "TVALID"} \
    {"s_axis_stat_tready" "TREADY"} ]

adi_if_infer_bus analog.com:interface:if_ctrl_reg master ctrl_reg [list \
  "ctrl_reg_wr_addr ctrl_reg_wr_addr" \
  "ctrl_reg_wr_data ctrl_reg_wr_data" \
  "ctrl_reg_wr_strb ctrl_reg_wr_strb" \
  "ctrl_reg_wr_en   ctrl_reg_wr_en" \
  "ctrl_reg_wr_wait ctrl_reg_wr_wait" \
  "ctrl_reg_wr_ack  ctrl_reg_wr_ack" \
  "ctrl_reg_rd_addr ctrl_reg_rd_addr" \
  "ctrl_reg_rd_data ctrl_reg_rd_data" \
  "ctrl_reg_rd_en   ctrl_reg_rd_en" \
  "ctrl_reg_rd_wait ctrl_reg_rd_wait" \
  "ctrl_reg_rd_ack  ctrl_reg_rd_ack" \
]

adi_if_infer_bus analog.com:interface:if_ptp master ptp_clock [list \
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

adi_if_infer_bus analog.com:interface:if_flow_control_tx master flow_control_tx [list \
  "tx_enable           tx_enable" \
  "tx_status           tx_status" \
  "tx_lfc_en           tx_lfc_en" \
  "tx_lfc_req          tx_lfc_req" \
  "tx_pfc_en           tx_pfc_en" \
  "tx_pfc_req          tx_pfc_req" \
  "tx_fc_quanta_clk_en tx_fc_quanta_clk_en" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx master flow_control_rx [list \
  "rx_enable           rx_enable" \
  "rx_status           rx_status" \
  "rx_lfc_en           rx_lfc_en" \
  "rx_lfc_req          rx_lfc_req" \
  "rx_lfc_ack          rx_lfc_ack" \
  "rx_pfc_en           rx_pfc_en" \
  "rx_pfc_req          rx_pfc_req" \
  "rx_pfc_ack          rx_pfc_ack" \
  "rx_fc_quanta_clk_en rx_fc_quanta_clk_en" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp master ethernet_ptp_tx [list \
  "ptp_clk     tx_ptp_clk" \
  "ptp_rst     tx_ptp_rst" \
  "ptp_ts      tx_ptp_ts" \
  "ptp_ts_step tx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp master ethernet_ptp_rx [list \
  "ptp_clk     rx_ptp_clk" \
  "ptp_rst     rx_ptp_rst" \
  "ptp_ts      rx_ptp_ts" \
  "ptp_ts_step rx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master axis_tx_ptp [list \
  "ts    s_axis_tx_cpl_ts" \
  "tag   s_axis_tx_cpl_tag" \
  "valid s_axis_tx_cpl_valid" \
  "ready s_axis_tx_cpl_ready" \
]

# Application interfaces

adi_add_bus "m_axi_ddr_app" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_ddr_awid_app" "AWID"} \
    {"m_axi_ddr_awaddr_app" "AWADDR"} \
    {"m_axi_ddr_awlen_app" "AWLEN"} \
    {"m_axi_ddr_awsize_app" "AWSIZE"} \
    {"m_axi_ddr_awuser_app" "AWUSER"} \
    {"m_axi_ddr_awburst_app" "AWBURST"} \
    {"m_axi_ddr_awlock_app" "AWLOCK"} \
    {"m_axi_ddr_awcache_app" "AWCACHE"} \
    {"m_axi_ddr_awprot_app" "AWPROT"} \
    {"m_axi_ddr_awqos_app" "AWQOS"} \
    {"m_axi_ddr_awvalid_app" "AWVALID"} \
    {"m_axi_ddr_awready_app" "AWREADY"} \
    {"m_axi_ddr_wdata_app" "WDATA"} \
    {"m_axi_ddr_wstrb_app" "WSTRB"} \
    {"m_axi_ddr_wlast_app" "WLAST"} \
    {"m_axi_ddr_wvalid_app" "WVALID"} \
    {"m_axi_ddr_wready_app" "WREADY"} \
    {"m_axi_ddr_wuser_app" "WUSER"} \
    {"m_axi_ddr_bid_app" "BID"} \
    {"m_axi_ddr_bresp_app" "BRESP"} \
    {"m_axi_ddr_buser_app" "BUSER"} \
    {"m_axi_ddr_bvalid_app" "BVALID"} \
    {"m_axi_ddr_bready_app" "BREADY"} \
    {"m_axi_ddr_arid_app" "ARID"} \
    {"m_axi_ddr_araddr_app" "ARADDR"} \
    {"m_axi_ddr_arlen_app" "ARLEN"} \
    {"m_axi_ddr_arsize_app" "ARSIZE"} \
    {"m_axi_ddr_aruser_app" "ARUSER"} \
    {"m_axi_ddr_arburst_app" "ARBURST"} \
    {"m_axi_ddr_arlock_app" "ARLOCK"} \
    {"m_axi_ddr_arcache_app" "ARCACHE"} \
    {"m_axi_ddr_arprot_app" "ARPROT"} \
    {"m_axi_ddr_arqos_app" "ARQOS"} \
    {"m_axi_ddr_arvalid_app" "ARVALID"} \
    {"m_axi_ddr_arready_app" "ARREADY"} \
    {"m_axi_ddr_rid_app" "RID"} \
    {"m_axi_ddr_rdata_app" "RDATA"} \
    {"m_axi_ddr_rresp_app" "RRESP"} \
    {"m_axi_ddr_ruser_app" "RUSER"} \
    {"m_axi_ddr_rlast_app" "RLAST"} \
    {"m_axi_ddr_rvalid_app" "RVALID"} \
    {"m_axi_ddr_rready_app" "RREADY"} \
  }

adi_add_bus "m_axi_hbm_app" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_hbm_awid_app" "AWID"} \
    {"m_axi_hbm_awaddr_app" "AWADDR"} \
    {"m_axi_hbm_awlen_app" "AWLEN"} \
    {"m_axi_hbm_awsize_app" "AWSIZE"} \
    {"m_axi_hbm_awuser_app" "AWUSER"} \
    {"m_axi_hbm_awburst_app" "AWBURST"} \
    {"m_axi_hbm_awlock_app" "AWLOCK"} \
    {"m_axi_hbm_awcache_app" "AWCACHE"} \
    {"m_axi_hbm_awprot_app" "AWPROT"} \
    {"m_axi_hbm_awqos_app" "AWQOS"} \
    {"m_axi_hbm_awvalid_app" "AWVALID"} \
    {"m_axi_hbm_awready_app" "AWREADY"} \
    {"m_axi_hbm_wdata_app" "WDATA"} \
    {"m_axi_hbm_wstrb_app" "WSTRB"} \
    {"m_axi_hbm_wlast_app" "WLAST"} \
    {"m_axi_hbm_wvalid_app" "WVALID"} \
    {"m_axi_hbm_wready_app" "WREADY"} \
    {"m_axi_hbm_wuser_app" "WUSER"} \
    {"m_axi_hbm_bid_app" "BID"} \
    {"m_axi_hbm_bresp_app" "BRESP"} \
    {"m_axi_hbm_buser_app" "BUSER"} \
    {"m_axi_hbm_bvalid_app" "BVALID"} \
    {"m_axi_hbm_bready_app" "BREADY"} \
    {"m_axi_hbm_arid_app" "ARID"} \
    {"m_axi_hbm_araddr_app" "ARADDR"} \
    {"m_axi_hbm_arlen_app" "ARLEN"} \
    {"m_axi_hbm_arsize_app" "ARSIZE"} \
    {"m_axi_hbm_aruser_app" "ARUSER"} \
    {"m_axi_hbm_arburst_app" "ARBURST"} \
    {"m_axi_hbm_arlock_app" "ARLOCK"} \
    {"m_axi_hbm_arcache_app" "ARCACHE"} \
    {"m_axi_hbm_arprot_app" "ARPROT"} \
    {"m_axi_hbm_arqos_app" "ARQOS"} \
    {"m_axi_hbm_arvalid_app" "ARVALID"} \
    {"m_axi_hbm_arready_app" "ARREADY"} \
    {"m_axi_hbm_rid_app" "RID"} \
    {"m_axi_hbm_rdata_app" "RDATA"} \
    {"m_axi_hbm_rresp_app" "RRESP"} \
    {"m_axi_hbm_ruser_app" "RUSER"} \
    {"m_axi_hbm_rlast_app" "RLAST"} \
    {"m_axi_hbm_rvalid_app" "RVALID"} \
    {"m_axi_hbm_rready_app" "RREADY"} \
  }

adi_add_bus "s_axis_direct_tx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_direct_tx_tdata_app" "TDATA"} \
    {"s_axis_direct_tx_tkeep_app" "TKEEP"} \
    {"s_axis_direct_tx_tvalid_app" "TVALID"} \
    {"s_axis_direct_tx_tready_app" "TREADY"} \
    {"s_axis_direct_tx_tlast_app" "TLAST"} \
    {"s_axis_direct_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_direct_tx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_direct_tx_tdata_app" "TDATA"} \
    {"m_axis_direct_tx_tkeep_app" "TKEEP"} \
    {"m_axis_direct_tx_tvalid_app" "TVALID"} \
    {"m_axis_direct_tx_tready_app" "TREADY"} \
    {"m_axis_direct_tx_tlast_app" "TLAST"} \
    {"m_axis_direct_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "s_axis_direct_rx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_direct_rx_tdata_app" "TDATA"} \
    {"s_axis_direct_rx_tkeep_app" "TKEEP"} \
    {"s_axis_direct_rx_tvalid_app" "TVALID"} \
    {"s_axis_direct_rx_tready_app" "TREADY"} \
    {"s_axis_direct_rx_tlast_app" "TLAST"} \
    {"s_axis_direct_rx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_direct_rx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_direct_rx_tdata_app" "TDATA"} \
    {"m_axis_direct_rx_tkeep_app" "TKEEP"} \
    {"m_axis_direct_rx_tvalid_app" "TVALID"} \
    {"m_axis_direct_rx_tready_app" "TREADY"} \
    {"m_axis_direct_rx_tlast_app" "TLAST"} \
    {"m_axis_direct_rx_tuser_app" "TUSER"} \
  }

adi_add_bus "s_axis_sync_tx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_sync_tx_tdata_app" "TDATA"} \
    {"s_axis_sync_tx_tkeep_app" "TKEEP"} \
    {"s_axis_sync_tx_tvalid_app" "TVALID"} \
    {"s_axis_sync_tx_tready_app" "TREADY"} \
    {"s_axis_sync_tx_tlast_app" "TLAST"} \
    {"s_axis_sync_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_sync_tx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_sync_tx_tdata_app" "TDATA"} \
    {"m_axis_sync_tx_tkeep_app" "TKEEP"} \
    {"m_axis_sync_tx_tvalid_app" "TVALID"} \
    {"m_axis_sync_tx_tready_app" "TREADY"} \
    {"m_axis_sync_tx_tlast_app" "TLAST"} \
    {"m_axis_sync_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "s_axis_sync_rx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_sync_rx_tdata_app" "TDATA"} \
    {"s_axis_sync_rx_tkeep_app" "TKEEP"} \
    {"s_axis_sync_rx_tvalid_app" "TVALID"} \
    {"s_axis_sync_rx_tready_app" "TREADY"} \
    {"s_axis_sync_rx_tlast_app" "TLAST"} \
    {"s_axis_sync_rx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_sync_rx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_sync_rx_tdata_app" "TDATA"} \
    {"m_axis_sync_rx_tkeep_app" "TKEEP"} \
    {"m_axis_sync_rx_tvalid_app" "TVALID"} \
    {"m_axis_sync_rx_tready_app" "TREADY"} \
    {"m_axis_sync_rx_tlast_app" "TLAST"} \
    {"m_axis_sync_rx_tuser_app" "TUSER"} \
  }

adi_add_bus "s_axis_if_tx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_if_tx_tdata_app" "TDATA"} \
    {"s_axis_if_tx_tkeep_app" "TKEEP"} \
    {"s_axis_if_tx_tvalid_app" "TVALID"} \
    {"s_axis_if_tx_tready_app" "TREADY"} \
    {"s_axis_if_tx_tlast_app" "TLAST"} \
    {"s_axis_if_tx_tid_app" "TID"} \
    {"s_axis_if_tx_tdest_app" "TDEST"} \
    {"s_axis_if_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_if_tx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_if_tx_tdata_app" "TDATA"} \
    {"m_axis_if_tx_tkeep_app" "TKEEP"} \
    {"m_axis_if_tx_tvalid_app" "TVALID"} \
    {"m_axis_if_tx_tready_app" "TREADY"} \
    {"m_axis_if_tx_tlast_app" "TLAST"} \
    {"m_axis_if_tx_tid_app" "TID"} \
    {"m_axis_if_tx_tdest_app" "TDEST"} \
    {"m_axis_if_tx_tuser_app" "TUSER"} \
  }

adi_add_bus "s_axis_if_rx_app" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"s_axis_if_rx_tdata_app" "TDATA"} \
    {"s_axis_if_rx_tkeep_app" "TKEEP"} \
    {"s_axis_if_rx_tvalid_app" "TVALID"} \
    {"s_axis_if_rx_tready_app" "TREADY"} \
    {"s_axis_if_rx_tlast_app" "TLAST"} \
    {"s_axis_if_rx_tid_app" "TID"} \
    {"s_axis_if_rx_tdest_app" "TDEST"} \
    {"s_axis_if_rx_tuser_app" "TUSER"} \
  }

adi_add_bus "m_axis_if_rx_app" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"m_axis_if_rx_tdata_app" "TDATA"} \
    {"m_axis_if_rx_tkeep_app" "TKEEP"} \
    {"m_axis_if_rx_tvalid_app" "TVALID"} \
    {"m_axis_if_rx_tready_app" "TREADY"} \
    {"m_axis_if_rx_tlast_app" "TLAST"} \
    {"m_axis_if_rx_tid_app" "TID"} \
    {"m_axis_if_rx_tdest_app" "TDEST"} \
    {"m_axis_if_rx_tuser_app" "TUSER"} \
  }

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave s_axis_direct_tx_cpl_app [list \
  "ts    s_axis_direct_tx_cpl_ts_app" \
  "tag   s_axis_direct_tx_cpl_tag_app" \
  "valid s_axis_direct_tx_cpl_valid_app" \
  "ready s_axis_direct_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master m_axis_direct_tx_cpl_app [list \
  "ts    m_axis_direct_tx_cpl_ts_app" \
  "tag   m_axis_direct_tx_cpl_tag_app" \
  "valid m_axis_direct_tx_cpl_valid_app" \
  "ready m_axis_direct_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave s_axis_sync_tx_cpl_app [list \
  "ts    s_axis_sync_tx_cpl_ts_app" \
  "tag   s_axis_sync_tx_cpl_tag_app" \
  "valid s_axis_sync_tx_cpl_valid_app" \
  "ready s_axis_sync_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master m_axis_sync_tx_cpl_app [list \
  "ts    m_axis_sync_tx_cpl_ts_app" \
  "tag   m_axis_sync_tx_cpl_tag_app" \
  "valid m_axis_sync_tx_cpl_valid_app" \
  "ready m_axis_sync_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave s_axis_if_tx_cpl_app [list \
  "ts    s_axis_if_tx_cpl_ts_app" \
  "tag   s_axis_if_tx_cpl_tag_app" \
  "valid s_axis_if_tx_cpl_valid_app" \
  "ready s_axis_if_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master m_axis_if_tx_cpl_app [list \
  "ts    m_axis_if_tx_cpl_ts_app" \
  "tag   m_axis_if_tx_cpl_tag_app" \
  "valid m_axis_if_tx_cpl_valid_app" \
  "ready m_axis_if_tx_cpl_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_ptp master ptp_clock_app [list \
  "ptp_td_sd            ptp_td_sd_app" \
  "ptp_pps              ptp_pps_app" \
  "ptp_pps_str          ptp_pps_str_app" \
  "ptp_sync_locked      ptp_sync_locked_app" \
  "ptp_sync_ts_rel      ptp_sync_ts_rel_app" \
  "ptp_sync_ts_rel_step ptp_sync_ts_rel_step_app" \
  "ptp_sync_ts_tod      ptp_sync_ts_tod_app" \
  "ptp_sync_ts_tod_step ptp_sync_ts_tod_step_app" \
  "ptp_sync_pps         ptp_sync_pps_app" \
  "ptp_sync_pps_str     ptp_sync_pps_str_app" \
  "ptp_perout_locked    ptp_perout_locked_app" \
  "ptp_perout_error     ptp_perout_error_app" \
  "ptp_perout_pulse     ptp_perout_pulse_app" \
]

adi_add_bus "m_axil_ctrl_app" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axil_ctrl_awaddr_app" "AWADDR"} \
    {"m_axil_ctrl_awprot_app" "AWPROT"} \
    {"m_axil_ctrl_awvalid_app" "AWVALID"} \
    {"m_axil_ctrl_awready_app" "AWREADY"} \
    {"m_axil_ctrl_wdata_app" "WDATA"} \
    {"m_axil_ctrl_wstrb_app" "WSTRB"} \
    {"m_axil_ctrl_wvalid_app" "WVALID"} \
    {"m_axil_ctrl_wready_app" "WREADY"} \
    {"m_axil_ctrl_bresp_app" "BRESP"} \
    {"m_axil_ctrl_bvalid_app" "BVALID"} \
    {"m_axil_ctrl_bready_app" "BREADY"} \
    {"m_axil_ctrl_araddr_app" "ARADDR"} \
    {"m_axil_ctrl_arprot_app" "ARPROT"} \
    {"m_axil_ctrl_arvalid_app" "ARVALID"} \
    {"m_axil_ctrl_arready_app" "ARREADY"} \
    {"m_axil_ctrl_rdata_app" "RDATA"} \
    {"m_axil_ctrl_rresp_app" "RRESP"} \
    {"m_axil_ctrl_rvalid_app" "RVALID"} \
    {"m_axil_ctrl_rready_app" "RREADY"} \
  }

adi_if_infer_bus analog.com:interface:if_axis_dma_desc slave m_axis_ctrl_dma_read_desc_app [list \
  "dma_addr m_axis_ctrl_dma_read_desc_dma_addr_app" \
  "ram_sel  m_axis_ctrl_dma_read_desc_ram_sel_app" \
  "ram_addr m_axis_ctrl_dma_read_desc_ram_addr_app" \
  "len      m_axis_ctrl_dma_read_desc_len_app" \
  "tag      m_axis_ctrl_dma_read_desc_tag_app" \
  "valid    m_axis_ctrl_dma_read_desc_valid_app" \
  "ready    m_axis_ctrl_dma_read_desc_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc slave m_axis_ctrl_dma_write_desc_app [list \
  "dma_addr m_axis_ctrl_dma_write_desc_dma_addr_app" \
  "ram_sel  m_axis_ctrl_dma_write_desc_ram_sel_app" \
  "ram_addr m_axis_ctrl_dma_write_desc_ram_addr_app" \
  "imm      m_axis_ctrl_dma_write_desc_imm_app" \
  "imm_en   m_axis_ctrl_dma_write_desc_imm_en_app" \
  "len      m_axis_ctrl_dma_write_desc_len_app" \
  "tag      m_axis_ctrl_dma_write_desc_tag_app" \
  "valid    m_axis_ctrl_dma_write_desc_valid_app" \
  "ready    m_axis_ctrl_dma_write_desc_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc slave m_axis_data_dma_read_desc_app [list \
  "dma_addr m_axis_data_dma_read_desc_dma_addr_app" \
  "ram_sel  m_axis_data_dma_read_desc_ram_sel_app" \
  "ram_addr m_axis_data_dma_read_desc_ram_addr_app" \
  "len      m_axis_data_dma_read_desc_len_app" \
  "tag      m_axis_data_dma_read_desc_tag_app" \
  "valid    m_axis_data_dma_read_desc_valid_app" \
  "ready    m_axis_data_dma_read_desc_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc slave m_axis_data_dma_write_desc_app [list \
  "dma_addr m_axis_data_dma_write_desc_dma_addr_app" \
  "ram_sel  m_axis_data_dma_write_desc_ram_sel_app" \
  "ram_addr m_axis_data_dma_write_desc_ram_addr_app" \
  "imm      m_axis_data_dma_write_desc_imm_app" \
  "imm_en   m_axis_data_dma_write_desc_imm_en_app" \
  "len      m_axis_data_dma_write_desc_len_app" \
  "tag      m_axis_data_dma_write_desc_tag_app" \
  "valid    m_axis_data_dma_write_desc_valid_app" \
  "ready    m_axis_data_dma_write_desc_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status master s_axis_ctrl_dma_read_desc_status_app [list \
  "tag   s_axis_ctrl_dma_read_desc_status_tag_app" \
  "error s_axis_ctrl_dma_read_desc_status_error_app" \
  "valid s_axis_ctrl_dma_read_desc_status_valid_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status master s_axis_ctrl_dma_write_desc_status_app [list \
  "tag   s_axis_ctrl_dma_write_desc_status_tag_app" \
  "error s_axis_ctrl_dma_write_desc_status_error_app" \
  "valid s_axis_ctrl_dma_write_desc_status_valid_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status master s_axis_data_dma_read_desc_status_app [list \
  "tag   s_axis_data_dma_read_desc_status_tag_app" \
  "error s_axis_data_dma_read_desc_status_error_app" \
  "valid s_axis_data_dma_read_desc_status_valid_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_dma_desc_status master s_axis_data_dma_write_desc_status_app [list \
  "tag   s_axis_data_dma_write_desc_status_tag_app" \
  "error s_axis_data_dma_write_desc_status_error_app" \
  "valid s_axis_data_dma_write_desc_status_valid_app" \
]

adi_if_infer_bus analog.com:interface:if_dma_ram slave ctrl_dma_ram_app [list \
  "wr_cmd_sel    ctrl_dma_ram_wr_cmd_sel_app" \
  "wr_cmd_be     ctrl_dma_ram_wr_cmd_be_app" \
  "wr_cmd_addr   ctrl_dma_ram_wr_cmd_addr_app" \
  "wr_cmd_data   ctrl_dma_ram_wr_cmd_data_app" \
  "wr_cmd_valid  ctrl_dma_ram_wr_cmd_valid_app" \
  "wr_cmd_ready  ctrl_dma_ram_wr_cmd_ready_app" \
  "wr_done       ctrl_dma_ram_wr_done_app" \
  "rd_cmd_sel    ctrl_dma_ram_rd_cmd_sel_app" \
  "rd_cmd_addr   ctrl_dma_ram_rd_cmd_addr_app" \
  "rd_cmd_valid  ctrl_dma_ram_rd_cmd_valid_app" \
  "rd_cmd_ready  ctrl_dma_ram_rd_cmd_ready_app" \
  "rd_resp_data  ctrl_dma_ram_rd_resp_data_app" \
  "rd_resp_valid ctrl_dma_ram_rd_resp_valid_app" \
  "rd_resp_ready ctrl_dma_ram_rd_resp_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_dma_ram slave data_dma_ram_app [list \
  "wr_cmd_sel    data_dma_ram_wr_cmd_sel_app" \
  "wr_cmd_be     data_dma_ram_wr_cmd_be_app" \
  "wr_cmd_addr   data_dma_ram_wr_cmd_addr_app" \
  "wr_cmd_data   data_dma_ram_wr_cmd_data_app" \
  "wr_cmd_valid  data_dma_ram_wr_cmd_valid_app" \
  "wr_cmd_ready  data_dma_ram_wr_cmd_ready_app" \
  "wr_done       data_dma_ram_wr_done_app" \
  "rd_cmd_sel    data_dma_ram_rd_cmd_sel_app" \
  "rd_cmd_addr   data_dma_ram_rd_cmd_addr_app" \
  "rd_cmd_valid  data_dma_ram_rd_cmd_valid_app" \
  "rd_cmd_ready  data_dma_ram_rd_cmd_ready_app" \
  "rd_resp_data  data_dma_ram_rd_resp_data_app" \
  "rd_resp_valid data_dma_ram_rd_resp_valid_app" \
  "rd_resp_ready data_dma_ram_rd_resp_ready_app" \
]

adi_if_infer_bus analog.com:interface:if_axis_stat slave m_axis_stat_app [list \
  "tdata  m_axis_stat_tdata_app" \
  "tid    m_axis_stat_tid_app" \
  "tvalid m_axis_stat_tvalid_app" \
  "tready m_axis_stat_tready_app" \
]

# Bus-clock association

adi_add_bus_clock "clk" "m_axi:s_axil_ctrl:m_axil_csr:s_axis_sync_tx_app:m_axis_sync_tx_app:s_axis_sync_rx_app:m_axis_sync_rx_app:s_axis_if_tx_app:m_axis_if_tx_app:s_axis_if_rx_app:m_axis_if_rx_app:m_axil_ctrl_app" "rst"
adi_add_bus_clock "ddr_clk" "m_axi_ddr:m_axi_ddr_app" "ddr_rst"
adi_add_bus_clock "hbm_clk" "m_axi_hbm:m_axi_hbm_app" "hbm_rst"
adi_add_bus_clock "tx_clk" "m_axis_tx:s_axis_direct_tx_app:m_axis_direct_tx_app" "tx_rst"
adi_add_bus_clock "rx_clk" "s_axis_rx:s_axis_stat:s_axis_direct_rx_app:m_axis_direct_rx_app" "rx_rst"

## Parameter validation

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters DDR_CH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters DDR_GROUP_SIZE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_DATA_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_ADDR_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_STRB_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_ID_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_AWUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1 && \$AXI_DDR_AWUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_AWUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_WUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1 && \$AXI_DDR_WUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_WUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_BUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1 && \$AXI_DDR_BUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_BUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_ARUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1 && \$AXI_DDR_ARUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_ARUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_RUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1 && \$AXI_DDR_RUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_RUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_MAX_BURST_LEN -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_NARROW_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_FIXED_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DDR_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_DDR_WRAP_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters HBM_CH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters HBM_GROUP_SIZE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_DATA_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_ADDR_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_STRB_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_ID_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_AWUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1 && \$AXI_HBM_AWUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_AWUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_WUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1 && \$AXI_HBM_WUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_WUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_BUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1 && \$AXI_HBM_BUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_BUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_ARUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1 && \$AXI_HBM_ARUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_ARUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_RUSER_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1 && \$AXI_HBM_RUSER_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_RUSER_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_MAX_BURST_LEN -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_NARROW_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_FIXED_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$HBM_ENABLE == 1" \
] \
[ipx::get_user_parameters AXI_HBM_WRAP_BURST -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_ID -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_CTRL_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_DMA_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_AXIS_DIRECT_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_AXIS_SYNC_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_AXIS_IF_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$APP_ENABLE == 1" \
] \
[ipx::get_user_parameters APP_STAT_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DMA_IMM_ENABLE == 1" \
] \
[ipx::get_user_parameters DMA_IMM_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
] \
[ipx::get_user_parameters STAT_DMA_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
] \
[ipx::get_user_parameters STAT_AXI_ENABLE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
] \
[ipx::get_user_parameters STAT_INC_WIDTH -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
] \
[ipx::get_user_parameters STAT_ID_WIDTH -of_objects $cc]

# Additional parameters

ipx::add_user_parameter -name "AXIL_CSR_ENABLE" -component $cc
set_property value_resolve_type user [ipx::get_user_parameters "AXIL_CSR_ENABLE" -of_objects $cc]
set_property -dict [list \
  "value_resolve_type" "user" \
  "value_format" "long" \
  "value" "0" \
] \
[ipx::get_user_parameters AXIL_CSR_ENABLE -of_objects $cc]

## Customize GUI page

# Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

# General
ipgui::add_page -name {General} -component $cc -display_name {General}
set page0 [ipgui::get_pagespec -name "General" -component $cc]

set group [ipgui::add_group -name "FW and board IDs" -component $cc \
  -parent $page0 -display_name "FW and board IDs"]

ipgui::add_param -name "FPGA_ID" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "FPGA_ID" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "FPGA ID" \
] $p

ipgui::add_param -name "FW_ID" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "FW_ID" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Firmware ID" \
] $p

ipgui::add_param -name "FW_VER" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "FW_VER" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "Firmware version" \
] $p

ipgui::add_param -name "BOARD_ID" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "BOARD_ID" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "Board ID" \
] $p
ipgui::add_param -name "BOARD_VER" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "BOARD_VER" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "Board version" \
] $p

ipgui::add_param -name "BUILD_DATE" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "BUILD_DATE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "Build date" \
] $p

ipgui::add_param -name "GIT_HASH" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "GIT_HASH" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "Git hash" \
] $p

ipgui::add_param -name "RELEASE_INFO" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "RELEASE_INFO" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "Release info" \
] $p

# Physical
ipgui::add_page -name {Physical} -component $cc -display_name {Physical}
set page1 [ipgui::get_pagespec -name "Physical" -component $cc]

set group [ipgui::add_group -name "Structural configuration" -component $cc \
  -parent $page1 -display_name "Structural configuration"]

ipgui::add_param -name "IF_COUNT" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "IF_COUNT" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "Interface count" \
] $p

ipgui::add_param -name "PORTS_PER_IF" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Ports per interface" \
] $p

ipgui::add_param -name "SCHED_PER_IF" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "SCHED_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "Schedulers per interface" \
  "tooltip" { PORTS_PER_IF } \
] $p

ipgui::add_param -name "PORT_COUNT" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PORT_COUNT" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "Port count" \
  "tooltip" { IF_COUNT*PORTS_PER_IF } \
] $p

set group [ipgui::add_group -name "Clock configuration" -component $cc \
  -parent $page1 -display_name "Clock configuration"]

ipgui::add_param -name "CLK_PERIOD_NS_NUM" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_NUM" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "Clock period nominator" \
] $p

ipgui::add_param -name "CLK_PERIOD_NS_DENOM" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_DENOM" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Clock period denominator" \
] $p

set group [ipgui::add_group -name "PTP configuration" -component $cc \
  -parent $page1 -display_name "PTP configuration"]

ipgui::add_param -name "PTP_CLK_PERIOD_NS_NUM" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_NUM" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP clock period denominator" \
] $p

ipgui::add_param -name "PTP_CLK_PERIOD_NS_DENOM" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_DENOM" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP clock denominator" \
] $p

ipgui::add_param -name "PTP_CLOCK_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_CLOCK_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP clock pipeline" \
] $p

ipgui::add_param -name "PTP_CLOCK_CDC_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_CLOCK_CDC_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP clock CDC pipeline" \
] $p

ipgui::add_param -name "PTP_SEPARATE_TX_CLOCK" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_SEPARATE_TX_CLOCK" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP separate TX clock" \
] $p

ipgui::add_param -name "PTP_SEPARATE_RX_CLOCK" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_SEPARATE_RX_CLOCK" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP separate RX clock" \
] $p

ipgui::add_param -name "PTP_PORT_CDC_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PORT_CDC_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP port CDC pipeline" \
] $p

ipgui::add_param -name "PTP_PEROUT_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP perout enable" \
] $p

ipgui::add_param -name "PTP_PEROUT_COUNT" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_COUNT" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP perout count" \
] $p

ipgui::add_param -name "PTP_TS_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP TS enable" \
] $p

ipgui::add_param -name "PTP_TS_FMT_TOD" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_FMT_TOD" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP TS FMT TOD" \
] $p

ipgui::add_param -name "PTP_TS_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP TS width" \
  "tooltip" { if {PTP_TS_FMT_TOD} {96} else {64} } \
] $p

set group [ipgui::add_group -name "Ethernet interface configuration" -component $cc \
  -parent $page1 -display_name "Ethernet interface configuration"]

ipgui::add_param -name "AXIS_DATA_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream data width" \
] $p

ipgui::add_param -name "AXIS_KEEP_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_KEEP_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream keep width" \
  "tooltip" { AXIS_DATA_WIDTH/8 } \
] $p

ipgui::add_param -name "AXIS_SYNC_DATA_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_SYNC_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream sync data width" \
  "tooltip" { AXIS_DATA_WIDTH } \
] $p

ipgui::add_param -name "AXIS_IF_DATA_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_IF_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface data width" \
  "tooltip" { AXIS_SYNC_DATA_WIDTH * pow(2, log2(PORTS_PER_IF)) } \
] $p

ipgui::add_param -name "AXIS_TX_USER_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_USER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX user width" \
  "tooltip" { TX_TAG_WIDTH + 1 } \
] $p

ipgui::add_param -name "AXIS_RX_USER_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_USER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream RX user width" \
  "tooltip" { if {PTP_TS_ENABLE} {PTP_TS_WIDTH} else {0} + 1 } \
] $p

ipgui::add_param -name "AXIS_RX_USE_READY" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_USE_READY" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI4 Stream RX use ready" \
] $p

ipgui::add_param -name "AXIS_TX_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX pipeline" \
] $p

ipgui::add_param -name "AXIS_TX_FIFO_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX FIFO pipeline" \
] $p

ipgui::add_param -name "AXIS_TX_TS_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_TS_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX TS pipeline" \
] $p

ipgui::add_param -name "AXIS_RX_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream RX pipeline" \
] $p

ipgui::add_param -name "AXIS_RX_FIFO_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream RX FIFO pipeline" \
] $p

# Corundum
ipgui::add_page -name {Corundum} -component $cc -display_name {Corundum}
set page2 [ipgui::get_pagespec -name "Corundum" -component $cc]

set group [ipgui::add_group -name "Queue manager configuration" -component $cc \
  -parent $page2 -display_name "Queue manager configuration"]

ipgui::add_param -name "EVENT_QUEUE_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "EVENT_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "Event queue operation table size" \
] $p

ipgui::add_param -name "TX_QUEUE_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "TX queue operation table size" \
] $p

ipgui::add_param -name "RX_QUEUE_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RX_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "RX queue operation table size" \
] $p

ipgui::add_param -name "CQ_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "CQ_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "Completion queue operation table size" \
] $p

ipgui::add_param -name "EQN_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "EQN_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "Event queue number width" \
] $p

ipgui::add_param -name "TX_QUEUE_INDEX_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_QUEUE_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "TX queue index width" \
] $p

ipgui::add_param -name "RX_QUEUE_INDEX_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RX_QUEUE_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "RX queue index width" \
] $p

ipgui::add_param -name "CQN_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "CQN_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "Completion queue number width" \
  "tooltip" { {if {TX_QUEUE_INDEX_WIDTH > RX_QUEUE_INDEX_WIDTH} {TX_QUEUE_INDEX_WIDTH} else {RX_QUEUE_INDEX_WIDTH}} + 1 } \
] $p

ipgui::add_param -name "EQ_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "EQ_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "Event queue pipeline" \
] $p

ipgui::add_param -name "TX_QUEUE_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_QUEUE_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "TX queue pipeline" \
  "tooltip" { 3 + if {TX_QUEUE_INDEX_WIDTH > 12} {TX_QUEUE_INDEX_WIDTH-12} else {0} } \
] $p

ipgui::add_param -name "RX_QUEUE_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RX_QUEUE_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "RX queue pipeline" \
  "tooltip" { 3 + if {RX_QUEUE_INDEX_WIDTH > 12} {RX_QUEUE_INDEX_WIDTH-12} else {0} } \
] $p

ipgui::add_param -name "CQ_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "CQ_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "Completion queue pipeline" \
  "tooltip" { 3 + if {CQN_WIDTH > 12} {CQN_WIDTH-12} else {0} } \
] $p

set group [ipgui::add_group -name "TX and RX engine configuration" -component $cc \
  -parent $page2 -display_name "TX and RX engine configuration"]

ipgui::add_param -name "TX_DESC_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_DESC_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "TX descriptor table size" \
] $p

ipgui::add_param -name "RX_DESC_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RX_DESC_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "RX descriptor table size" \
] $p

ipgui::add_param -name "RX_INDIR_TBL_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RX_INDIR_TBL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "RX indirect table address width" \
  "tooltip" { if {RX_QUEUE_INDEX_WIDTH > 8} {8} else {RX_QUEUE_INDEX_WIDTH} } \
] $p

set group [ipgui::add_group -name "Scheduler configuration" -component $cc \
  -parent $page2 -display_name "Scheduler configuration"]

ipgui::add_param -name "TX_SCHEDULER_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_SCHEDULER_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "TX scheduler operation table size" \
  "tooltip" { TX_DESC_TABLE_SIZE } \
] $p

ipgui::add_param -name "TX_SCHEDULER_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TX_SCHEDULER_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "TX scheduler pipeline" \
  "tooltip" { TX_QUEUE_PIPELINE } \
] $p

ipgui::add_param -name "TDMA_INDEX_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TDMA_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "TDMA index width" \
] $p

set group [ipgui::add_group -name "AXI interface configuration (DMA)" -component $cc \
  -parent $page2 -display_name "AXI interface configuration (DMA)"]

ipgui::add_param -name "AXI_DATA_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI data width" \
] $p

ipgui::add_param -name "AXI_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI address width" \
] $p

ipgui::add_param -name "AXI_STRB_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_STRB_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI strobe width" \
  "tooltip" { AXI_DATA_WIDTH/8 } \
] $p

ipgui::add_param -name "AXI_ID_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI ID width" \
] $p

set group [ipgui::add_group -name "DMA interface configuration" -component $cc \
  -parent $page2 -display_name "DMA interface configuration"]

ipgui::add_param -name "DMA_IMM_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "DMA_IMM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "DMA IMM enable" \
] $p

ipgui::add_param -name "DMA_IMM_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "DMA_IMM_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "DMA IMM width" \
] $p

ipgui::add_param -name "DMA_LEN_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "DMA_LEN_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "DMA length width" \
] $p

ipgui::add_param -name "DMA_TAG_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "DMA_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "DMA tag width" \
] $p

ipgui::add_param -name "RAM_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RAM_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM address width" \
  "tooltip" { log2(if {TX_RAM_SIZE > RX_RAM_SIZE} {TX_RAM_SIZE} else {RX_RAM_SIZE}) } \
] $p

ipgui::add_param -name "RAM_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RAM_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM pipeline" \
] $p

ipgui::add_param -name "AXI_DMA_MAX_BURST_LEN" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DMA Max burst length" \
] $p

ipgui::add_param -name "AXI_DMA_READ_USE_ID" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_READ_USE_ID" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DMA read use ID" \
] $p

ipgui::add_param -name "AXI_DMA_WRITE_USE_ID" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_WRITE_USE_ID" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DMA write use ID" \
] $p

ipgui::add_param -name "AXI_DMA_READ_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_READ_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DMA read operation table size" \
  "tooltip" { pow(2, AXI_ID_WIDTH) } \
] $p

ipgui::add_param -name "AXI_DMA_WRITE_OP_TABLE_SIZE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_WRITE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DMA write operation table size" \
  "tooltip" { pow(2, AXI_ID_WIDTH) } \
] $p

set group [ipgui::add_group -name "Interrupt configuration" -component $cc \
  -parent $page2 -display_name "Interrupt configuration"]

ipgui::add_param -name "IRQ_COUNT" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "IRQ_COUNT" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "Interrupt request count" \
] $p

set group [ipgui::add_group -name "AXI lite interface configuration (control)" -component $cc \
  -parent $page2 -display_name "AXI lite interface configuration (control)"]

ipgui::add_param -name "AXIL_CTRL_DATA_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CTRL_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite control data width" \
] $p

ipgui::add_param -name "AXIL_CTRL_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CTRL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite control address width" \
] $p

ipgui::add_param -name "AXIL_CTRL_STRB_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CTRL_STRB_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite control strobe width" \
  "tooltip" { AXIL_CTRL_DATA_WIDTH/8 } \
] $p

ipgui::add_param -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite interface control address width" \
  "tooltip" { AXIL_CTRL_ADDR_WIDTH - log2(IF_COUNT) } \
] $p

ipgui::add_param -name "AXIL_CSR_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CSR_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI4 Lite CSR enable" \
] $p

ipgui::add_param -name "AXIL_CSR_ADDR_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CSR_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite CSR address width" \
  "tooltip" { AXIL_IF_CTRL_ADDR_WIDTH - 5 - log2({SCHED_PER_IF + 4 + 7} / 8) } \
] $p

ipgui::add_param -name "AXIL_CSR_PASSTHROUGH_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CSR_PASSTHROUGH_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI4 Lite CSR passthrough enable" \
] $p

ipgui::add_param -name "RB_NEXT_PTR" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RB_NEXT_PTR" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "Register base next pointer" \
] $p

set group [ipgui::add_group -name "Statistics counter subsystem" -component $cc \
  -parent $page2 -display_name "Statistics counter subsystem"]

ipgui::add_param -name "STAT_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "STAT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Statistics enable" \
] $p

ipgui::add_param -name "STAT_DMA_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "STAT_DMA_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Statistics DMA enable" \
] $p

ipgui::add_param -name "STAT_AXI_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "STAT_AXI_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Statistics AXI enable" \
] $p

ipgui::add_param -name "STAT_INC_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "STAT_INC_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "Statistics increment width" \
] $p

ipgui::add_param -name "STAT_ID_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "STAT_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "Statistics ID width" \
] $p

# Memory
ipgui::add_page -name {Memory} -component $cc -display_name {Memory}
set page3 [ipgui::get_pagespec -name "Memory" -component $cc]

set group [ipgui::add_group -name "Interface configuration" -component $cc \
  -parent $page3 -display_name "Interface configuration"]

ipgui::add_param -name "TX_CPL_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_CPL_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "TX CPL enable" \
  "tooltip" { PTP_TS_ENABLE } \
] $p

ipgui::add_param -name "TX_CPL_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_CPL_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "TX CPL FIFO depth" \
] $p

ipgui::add_param -name "TX_TAG_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "TX tag width" \
  "tooltip" { log2(TX_DESC_TABLE_SIZE)+1 } \
] $p

ipgui::add_param -name "TX_CHECKSUM_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "TX checksum enable" \
] $p

ipgui::add_param -name "RX_HASH_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_HASH_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "RX hash enable" \
] $p

ipgui::add_param -name "RX_CHECKSUM_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "RX checksum enable" \
] $p

ipgui::add_param -name "PFC_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "PFC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PFC enable" \
] $p

ipgui::add_param -name "LFC_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "LFC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "LFC enable" \
  "tooltip" { PFC_ENABLE } \
] $p

ipgui::add_param -name "MAC_CTRL_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "MAC_CTRL_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "MAC control enable" \
] $p

ipgui::add_param -name "TX_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "TX FIFO depth" \
] $p

ipgui::add_param -name "RX_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "RX FIFO depth" \
] $p

ipgui::add_param -name "MAX_TX_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "MAX_TX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "Max TX size" \
] $p

ipgui::add_param -name "MAX_RX_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "MAX_RX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 12 $p -parent $group
set_property  -dict [list \
  "display_name" "Max RX size" \
] $p

ipgui::add_param -name "TX_RAM_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 13 $p -parent $group
set_property  -dict [list \
  "display_name" "TX RAM size" \
] $p

ipgui::add_param -name "RX_RAM_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 14 $p -parent $group
set_property  -dict [list \
  "display_name" "RX RAM size" \
] $p

set group [ipgui::add_group -name "DDR configuration" -component $cc \
  -parent $page3 -display_name "DDR configuration"]

ipgui::add_param -name "DDR_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "DDR_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "DDR enable" \
] $p

ipgui::add_param -name "DDR_CH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "DDR_CH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "DDR channels" \
] $p

ipgui::add_param -name "DDR_GROUP_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "DDR_GROUP_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "DDR group size" \
] $p

ipgui::add_param -name "AXI_DDR_DATA_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR data width" \
] $p

ipgui::add_param -name "AXI_DDR_ADDR_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR address width" \
] $p

ipgui::add_param -name "AXI_DDR_STRB_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_STRB_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR strobe width" \
  "tooltip" { AXI_DDR_DATA_WIDTH/8 } \
] $p

ipgui::add_param -name "AXI_DDR_ID_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR ID width" \
] $p

ipgui::add_param -name "AXI_DDR_AWUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_AWUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR awuser enable" \
] $p

ipgui::add_param -name "AXI_DDR_AWUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_AWUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR awuser width" \
] $p

ipgui::add_param -name "AXI_DDR_WUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_WUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR wuser enable" \
] $p

ipgui::add_param -name "AXI_DDR_WUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_WUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR wuser width" \
] $p

ipgui::add_param -name "AXI_DDR_BUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_BUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR buser enable" \
] $p

ipgui::add_param -name "AXI_DDR_BUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_BUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 12 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR buser width" \
] $p

ipgui::add_param -name "AXI_DDR_ARUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_ARUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 13 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR aruser enable" \
] $p

ipgui::add_param -name "AXI_DDR_ARUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_ARUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 14 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR aruser width" \
] $p

ipgui::add_param -name "AXI_DDR_RUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_RUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 15 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR ruser enable" \
] $p

ipgui::add_param -name "AXI_DDR_RUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_RUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 16 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR user width" \
] $p

ipgui::add_param -name "AXI_DDR_MAX_BURST_LEN" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 17 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DDR max burst length" \
] $p

ipgui::add_param -name "AXI_DDR_NARROW_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_NARROW_BURST" -component $cc]
ipgui::move_param -component $cc -order 18 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR narrow burst" \
] $p

ipgui::add_param -name "AXI_DDR_FIXED_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_FIXED_BURST" -component $cc]
ipgui::move_param -component $cc -order 19 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR fixed burst" \
] $p

ipgui::add_param -name "AXI_DDR_WRAP_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_DDR_WRAP_BURST" -component $cc]
ipgui::move_param -component $cc -order 20 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI DDR wrap burst" \
] $p

set group [ipgui::add_group -name "HBM configuration" -component $cc \
  -parent $page3 -display_name "HBM configuration"]

ipgui::add_param -name "HBM_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "HBM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "HBM enable" \
] $p

ipgui::add_param -name "HBM_CH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "HBM_CH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "HBM channels" \
] $p

ipgui::add_param -name "HBM_GROUP_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "HBM_GROUP_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "HBM group size" \
] $p

ipgui::add_param -name "AXI_HBM_DATA_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM data width" \
] $p

ipgui::add_param -name "AXI_HBM_ADDR_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM address width" \
] $p

ipgui::add_param -name "AXI_HBM_STRB_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_STRB_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM strobe width" \
  "tooltip" { AXI_HBM_DATA_WIDTH/8 } \
] $p

ipgui::add_param -name "AXI_HBM_ID_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM ID width" \
] $p

ipgui::add_param -name "AXI_HBM_AWUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_AWUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM awuser enable" \
] $p

ipgui::add_param -name "AXI_HBM_AWUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_AWUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM awuser width" \
] $p

ipgui::add_param -name "AXI_HBM_WUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_WUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM wuser enable" \
] $p

ipgui::add_param -name "AXI_HBM_WUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_WUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM wuser width" \
] $p

ipgui::add_param -name "AXI_HBM_BUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_BUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM buser enable" \
] $p

ipgui::add_param -name "AXI_HBM_BUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_BUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 12 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM buser width" \
] $p

ipgui::add_param -name "AXI_HBM_ARUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_ARUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 13 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM aruser enable" \
] $p

ipgui::add_param -name "AXI_HBM_ARUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_ARUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 14 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM aruser width" \
] $p

ipgui::add_param -name "AXI_HBM_RUSER_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_RUSER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 15 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM ruser enable" \
] $p

ipgui::add_param -name "AXI_HBM_RUSER_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_RUSER_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 16 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM ruser width" \
] $p

ipgui::add_param -name "AXI_HBM_MAX_BURST_LEN" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 17 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI HBM max burst length" \
] $p

ipgui::add_param -name "AXI_HBM_NARROW_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_NARROW_BURST" -component $cc]
ipgui::move_param -component $cc -order 18 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM narrow burst" \
] $p

ipgui::add_param -name "AXI_HBM_FIXED_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_FIXED_BURST" -component $cc]
ipgui::move_param -component $cc -order 19 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM fixed burst" \
] $p

ipgui::add_param -name "AXI_HBM_WRAP_BURST" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "AXI_HBM_WRAP_BURST" -component $cc]
ipgui::move_param -component $cc -order 20 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI HBM wrap burst" \
] $p

# Application
ipgui::add_page -name {Application} -component $cc -display_name {Application}
set page4 [ipgui::get_pagespec -name "Application" -component $cc]

set group [ipgui::add_group -name "Application block configuration" -component $cc \
  -parent $page4 -display_name "Application block configuration"]

ipgui::add_param -name "APP_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application enable" \
] $p

ipgui::add_param -name "APP_ID" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_ID" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Application ID" \
] $p

ipgui::add_param -name "APP_CTRL_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_CTRL_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application control enable" \
] $p

ipgui::add_param -name "APP_DMA_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_DMA_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application DMA enable" \
] $p

ipgui::add_param -name "APP_AXIS_DIRECT_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_AXIS_DIRECT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application AXI4 Stream direct enable" \
] $p

ipgui::add_param -name "APP_AXIS_SYNC_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_AXIS_SYNC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application AXI4 Stream sync enable" \
] $p

ipgui::add_param -name "APP_AXIS_IF_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_AXIS_IF_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application AXI4 Stream interface enable" \
] $p

ipgui::add_param -name "APP_STAT_ENABLE" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "APP_STAT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "Application statistics enable" \
] $p

set group [ipgui::add_group -name "AXI lite interface configuration (application control)" -component $cc \
  -parent $page4 -display_name "AXI lite interface configuration (application control)"]

ipgui::add_param -name "AXIL_APP_CTRL_DATA_WIDTH" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite application control data width" \
  "tooltip" { AXIL_CTRL_DATA_WIDTH } \
] $p

ipgui::add_param -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite application control address width" \
] $p

ipgui::add_param -name "AXIL_APP_CTRL_STRB_WIDTH" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_STRB_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Lite application control strobe width" \
  "tooltip" { AXIL_APP_CTRL_DATA_WIDTH/8 } \
] $p

set group [ipgui::add_group -name "Application parameters" -component $cc \
  -parent $page4 -display_name "Application parameters"]

ipgui::add_param -name "DMA_ADDR_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "DMA_ADDR_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "DMA address width" \
  "tooltip" { AXI_ADDR_WIDTH } \
] $p

ipgui::add_param -name "RAM_SEL_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "RAM_SEL_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM select width" \
  "tooltip" { $clog2(IF_COUNT+(APP_ENABLE && APP_DMA_ENABLE ? 1 : 0))+2 } \
] $p

ipgui::add_param -name "RAM_SEG_COUNT_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "RAM_SEG_COUNT_APP" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM segment count" \
  "tooltip" { 2 } \
] $p

ipgui::add_param -name "RAM_SEG_DATA_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "RAM_SEG_DATA_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM segment data width" \
  "tooltip" { AXI_DATA_WIDTH } \
] $p

ipgui::add_param -name "RAM_SEG_BE_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "RAM_SEG_BE_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM segment byte enable width" \
  "tooltip" { RAM_SEG_DATA_WIDTH_APP/8 } \
] $p

ipgui::add_param -name "RAM_SEG_ADDR_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "RAM_SEG_ADDR_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM segment address width" \
  "tooltip" { RAM_ADDR_WIDTH-$clog2(2*RAM_SEG_BE_WIDTH_APP) } \
] $p

ipgui::add_param -name "AXIS_SYNC_KEEP_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_SYNC_KEEP_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream sync keep width" \
  "tooltip" { AXIS_SYNC_DATA_WIDTH/(AXIS_DATA_WIDTH/AXIS_KEEP_WIDTH) } \
] $p

ipgui::add_param -name "AXIS_SYNC_TX_USER_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_SYNC_TX_USER_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream sync TX user width" \
  "tooltip" { AXIS_TX_USER_WIDTH } \
] $p

ipgui::add_param -name "AXIS_SYNC_RX_USER_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_SYNC_RX_USER_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream sync RX user width" \
  "tooltip" { AXIS_RX_USER_WIDTH } \
] $p

ipgui::add_param -name "AXIS_IF_KEEP_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_KEEP_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface keep width" \
  "tooltip" { AXIS_IF_DATA_WIDTH/(AXIS_DATA_WIDTH/AXIS_KEEP_WIDTH) } \
] $p

ipgui::add_param -name "AXIS_IF_TX_ID_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_ID_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface TX ID width" \
  "tooltip" { TX_QUEUE_INDEX_WIDTH } \
] $p

ipgui::add_param -name "AXIS_IF_RX_ID_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_ID_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface RX ID width" \
  "tooltip" { PORTS_PER_IF > 1 ? $clog2(PORTS_PER_IF) : 1 } \
] $p

ipgui::add_param -name "AXIS_IF_TX_DEST_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_DEST_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 12 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface TX destination width" \
  "tooltip" { $clog2(PORTS_PER_IF)+4 } \
] $p

ipgui::add_param -name "AXIS_IF_RX_DEST_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_DEST_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 13 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface RX destination width" \
  "tooltip" { RX_QUEUE_INDEX_WIDTH+1 } \
] $p

ipgui::add_param -name "AXIS_IF_TX_USER_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_USER_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 14 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface TX user width" \
  "tooltip" { AXIS_TX_USER_WIDTH } \
] $p

ipgui::add_param -name "AXIS_IF_RX_USER_WIDTH_APP" -component $cc -parent $page4
set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_USER_WIDTH_APP" -component $cc]
ipgui::move_param -component $cc -order 15 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream interface RX user width" \
  "tooltip" { AXIS_RX_USER_WIDTH } \
] $p

## Dependencies

# Base IP dependencies

adi_set_bus_dependency "m_axi_ddr" "m_axi_ddr" \
  "(spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)"

adi_set_ports_dependency "ddr_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)"

adi_set_ports_dependency "ddr_rst" \
  "(spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)" \
  "0"

adi_set_ports_dependency "ddr_status" \
  "(spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)" \
  "0"

adi_set_bus_dependency "m_axi_hbm" "m_axi_hbm" \
  "(spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)"

adi_set_ports_dependency "hbm_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)"

adi_set_ports_dependency "hbm_rst" \
  "(spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)" \
  "0"

adi_set_ports_dependency "hbm_status" \
  "(spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)" \
  "0"

adi_set_bus_dependency "m_axil_csr" "m_axil_csr" \
  "(spirit:decode(id('PARAM_VALUE.AXIL_CSR_ENABLE')) = 1)"

# Application dependencies

adi_set_bus_dependency "m_axi_ddr_app" "m_axi_ddr_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)"

adi_set_ports_dependency "ddr_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)"

adi_set_bus_dependency "m_axi_hbm_app" "m_axi_hbm_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)"

adi_set_ports_dependency "hbm_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.HBM_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_direct_tx_app" "s_axis_direct_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_direct_tx_app" "m_axis_direct_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_direct_tx_cpl_app" "s_axis_direct_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_direct_tx_cpl_app" "m_axis_direct_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_direct_rx_app" "s_axis_direct_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_direct_rx_app" "m_axis_direct_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_DIRECT_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_sync_tx_app" "s_axis_sync_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_sync_tx_app" "m_axis_sync_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_sync_tx_cpl_app" "s_axis_sync_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_sync_tx_cpl_app" "m_axis_sync_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_sync_rx_app" "s_axis_sync_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_sync_rx_app" "m_axis_sync_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_SYNC_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_if_tx_app" "s_axis_if_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_if_tx_app" "m_axis_if_tx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_if_tx_cpl_app" "s_axis_if_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_if_tx_cpl_app" "m_axis_if_tx_cpl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_if_rx_app" "s_axis_if_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_if_rx_app" "m_axis_if_rx_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_AXIS_IF_ENABLE')) = 1)"

adi_set_bus_dependency "m_axil_ctrl_app" "m_axil_ctrl_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_CTRL_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_ctrl_dma_read_desc_app" "m_axis_ctrl_dma_read_desc_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_ctrl_dma_write_desc_app" "m_axis_ctrl_dma_write_desc_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_data_dma_read_desc_app" "m_axis_data_dma_read_desc_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_data_dma_write_desc_app" "m_axis_data_dma_write_desc_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_ctrl_dma_read_desc_status_app" "s_axis_ctrl_dma_read_desc_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_ctrl_dma_write_desc_status_app" "s_axis_ctrl_dma_write_desc_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_data_dma_read_desc_status_app" "s_axis_data_dma_read_desc_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "s_axis_data_dma_write_desc_status_app" "s_axis_data_dma_write_desc_status_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "ctrl_dma_ram_app" "ctrl_dma_ram_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "data_dma_ram_app" "data_dma_ram_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_DMA_ENABLE')) = 1)"

adi_set_bus_dependency "m_axis_stat_app" "m_axis_stat_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.APP_STAT_ENABLE')) = 1)"

adi_set_bus_dependency "ptp_clock_app" "ptp_clock_app" \
  "(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1)"

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
