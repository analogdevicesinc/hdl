###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rb_drp.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_hash.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_checksum.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_counter.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_collect.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_if_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_latency.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_tx_scheduler_block_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_scheduler_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_scheduler.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_ber.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_ber_ch.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_perout.v" \
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
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_clock.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_clock_cdc.v" \
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
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_phc.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_leaf.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_td_rel2tod.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v" \
  "mqnic_app_block.v" \
  "mqnic_app_custom_ports.vh" \
  "mqnic_app_custom_params.vh" \
]


set_property verilog_define {APP_CUSTOM_PARAMS_ENABLE APP_CUSTOM_PORTS_ENABLE} [current_fileset]

adi_ip_properties_lite corundum_core
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

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

ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 $cc

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

adi_add_bus "m_axis_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_tx_tdata" "TDATA"} \
    {"axis_eth_tx_tkeep" "TKEEP"} \
    {"axis_eth_tx_tvalid" "TVALID"} \
    {"axis_eth_tx_tready" "TREADY"} \
    {"axis_eth_tx_tlast" "TLAST"} \
    {"axis_eth_tx_tuser" "TUSER"} ]

adi_add_bus "s_axis_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_rx_tdata" "TDATA"} \
    {"axis_eth_rx_tkeep" "TKEEP"} \
    {"axis_eth_rx_tvalid" "TVALID"} \
    {"axis_eth_rx_tready" "TREADY"} \
    {"axis_eth_rx_tlast" "TLAST"} \
    {"axis_eth_rx_tuser" "TUSER"} ]

adi_if_infer_bus analog.com:interface:if_flow_control_tx master flow_control_tx [list \
  "tx_enable           eth_tx_enable" \
  "tx_status           eth_tx_status" \
  "tx_lfc_en           eth_tx_lfc_en" \
  "tx_lfc_req          eth_tx_lfc_req" \
  "tx_pfc_en           eth_tx_pfc_en" \
  "tx_pfc_req          eth_tx_pfc_req" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx master flow_control_rx [list \
  "rx_enable           eth_rx_enable" \
  "rx_status           eth_rx_status" \
  "rx_lfc_en           eth_rx_lfc_en" \
  "rx_lfc_req          eth_rx_lfc_req" \
  "rx_lfc_ack          eth_rx_lfc_ack" \
  "rx_pfc_en           eth_rx_pfc_en" \
  "rx_pfc_req          eth_rx_pfc_req" \
  "rx_pfc_ack          eth_rx_pfc_ack" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master axis_tx_ptp [list \
  "ts    axis_eth_tx_ptp_ts" \
  "tag   axis_eth_tx_ptp_ts_tag" \
  "valid axis_eth_tx_ptp_ts_valid" \
  "ready axis_eth_tx_ptp_ts_ready" \
]

adi_add_bus "iic" "master" \
  "xilinx.com:interface:iic_rtl:1.0" \
  "xilinx.com:interface:iic:1.0" \
  [ list \
    {"sfp_i2c_scl_i" "SCL_I"} \
    {"sfp_i2c_scl_o" "SCL_O"} \
    {"sfp_i2c_scl_t" "SCL_T"} \
    {"sfp_i2c_sda_i" "SDA_I"} \
    {"sfp_i2c_sda_o" "SDA_O"} \
    {"sfp_i2c_sda_t" "SDA_T"} ]

# Application interfaces

adi_add_bus "s_axil_app_ctrl" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"s_axil_app_ctrl_awaddr" "AWADDR"} \
    {"s_axil_app_ctrl_awprot" "AWPROT"} \
    {"s_axil_app_ctrl_awvalid" "AWVALID"} \
    {"s_axil_app_ctrl_awready" "AWREADY"} \
    {"s_axil_app_ctrl_wdata" "WDATA"} \
    {"s_axil_app_ctrl_wstrb" "WSTRB"} \
    {"s_axil_app_ctrl_wvalid" "WVALID"} \
    {"s_axil_app_ctrl_wready" "WREADY"} \
    {"s_axil_app_ctrl_bresp" "BRESP"} \
    {"s_axil_app_ctrl_bvalid" "BVALID"} \
    {"s_axil_app_ctrl_bready" "BREADY"} \
    {"s_axil_app_ctrl_araddr" "ARADDR"} \
    {"s_axil_app_ctrl_arprot" "ARPROT"} \
    {"s_axil_app_ctrl_arvalid" "ARVALID"} \
    {"s_axil_app_ctrl_arready" "ARREADY"} \
    {"s_axil_app_ctrl_rdata" "RDATA"} \
    {"s_axil_app_ctrl_rresp" "RRESP"} \
    {"s_axil_app_ctrl_rvalid" "RVALID"} \
    {"s_axil_app_ctrl_rready" "RREADY"} \
  }

# Bus-clock association

# adi_add_bus_clock "clk_250mhz" "m_axi:s_axil_app_ctrl:s_axil_ctrl" "rst_250mhz"
# adi_add_bus_clock "tx_clk" "m_axis_tx" "tx_rst"
# adi_add_bus_clock "rx_clk" "s_axis_rx" "rx_rst"

## Parameter validation

proc log2 {x} {
  return [tcl::mathfunc::int [tcl::mathfunc::ceil [expr [tcl::mathfunc::log $x] / [tcl::mathfunc::log 2]]]]
}


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

# set_property -dict [list \
#   "enablement_tcl_expr" "\$DMA_IMM_ENABLE == 1" \
# ] \
# [ipx::get_user_parameters DMA_IMM_WIDTH -of_objects $cc]

# set_property -dict [list \
#   "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
# ] \
# [ipx::get_user_parameters STAT_DMA_ENABLE -of_objects $cc]

# set_property -dict [list \
#   "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
# ] \
# [ipx::get_user_parameters STAT_AXI_ENABLE -of_objects $cc]

# set_property -dict [list \
#   "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
# ] \
# [ipx::get_user_parameters STAT_INC_WIDTH -of_objects $cc]

# set_property -dict [list \
#   "enablement_tcl_expr" "\$STAT_ENABLE == 1" \
# ] \
# [ipx::get_user_parameters STAT_ID_WIDTH -of_objects $cc]

# Additional parameters

# ipx::add_user_parameter -name "AXIL_CSR_ENABLE" -component $cc
# set_property value_resolve_type user [ipx::get_user_parameters "AXIL_CSR_ENABLE" -of_objects $cc]
# set_property -dict [list \
#   "value_resolve_type" "user" \
#   "value_format" "long" \
#   "value" "0" \
# ] \
# [ipx::get_user_parameters AXIL_CSR_ENABLE -of_objects $cc]

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

ipgui::add_param -name "PTP_PORT_CDC_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PORT_CDC_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP port CDC pipeline" \
] $p

ipgui::add_param -name "PTP_PEROUT_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP perout enable" \
] $p

ipgui::add_param -name "PTP_PEROUT_COUNT" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_COUNT" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP perout count" \
] $p

ipgui::add_param -name "PTP_TS_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP TS enable" \
] $p

ipgui::add_param -name "PTP_TS_FMT_TOD" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_FMT_TOD" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP TS FMT TOD" \
] $p

# ipgui::add_param -name "PTP_TS_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "PTP_TS_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 9 $p -parent $group
# set_property  -dict [list \
#   "display_name" "PTP TS width" \
#   "tooltip" { if {PTP_TS_FMT_TOD} {96} else {64} } \
# ] $p

set group [ipgui::add_group -name "Ethernet interface configuration" -component $cc \
  -parent $page1 -display_name "Ethernet interface configuration"]

# ipgui::add_param -name "AXIS_DATA_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_DATA_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 0 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream data width" \
# ] $p

# ipgui::add_param -name "AXIS_KEEP_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_KEEP_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 1 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream keep width" \
#   "tooltip" { AXIS_DATA_WIDTH/8 } \
# ] $p

# ipgui::add_param -name "AXIS_SYNC_DATA_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_SYNC_DATA_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream sync data width" \
#   "tooltip" { AXIS_DATA_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIS_IF_DATA_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_IF_DATA_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 3 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface data width" \
#   "tooltip" { AXIS_SYNC_DATA_WIDTH * pow(2, log2(PORTS_PER_IF)) } \
# ] $p

# ipgui::add_param -name "AXIS_TX_USER_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_TX_USER_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 3 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream TX user width" \
#   "tooltip" { TX_TAG_WIDTH + 1 } \
# ] $p

# ipgui::add_param -name "AXIS_RX_USER_WIDTH" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_RX_USER_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 4 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream RX user width" \
#   "tooltip" { if {PTP_TS_ENABLE} {PTP_TS_WIDTH} else {0} + 1 } \
# ] $p

# ipgui::add_param -name "AXIS_RX_USE_READY" -component $cc -parent $page1
# set p [ipgui::get_guiparamspec -name "AXIS_RX_USE_READY" -component $cc]
# ipgui::move_param -component $cc -order 5 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "AXI4 Stream RX use ready" \
# ] $p

ipgui::add_param -name "AXIS_TX_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX pipeline" \
] $p

ipgui::add_param -name "AXIS_TX_FIFO_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX FIFO pipeline" \
] $p

ipgui::add_param -name "AXIS_TX_TS_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_TX_TS_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream TX TS pipeline" \
] $p

ipgui::add_param -name "AXIS_RX_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI4 Stream RX pipeline" \
] $p

ipgui::add_param -name "AXIS_RX_FIFO_PIPELINE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "AXIS_RX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
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

# ipgui::add_param -name "CQN_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "CQN_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 7 $p -parent $group
# set_property  -dict [list \
#   "display_name" "Completion queue number width" \
#   "tooltip" { {if {TX_QUEUE_INDEX_WIDTH > RX_QUEUE_INDEX_WIDTH} {TX_QUEUE_INDEX_WIDTH} else {RX_QUEUE_INDEX_WIDTH}} + 1 } \
# ] $p

ipgui::add_param -name "EQ_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "EQ_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "Event queue pipeline" \
] $p

# ipgui::add_param -name "TX_QUEUE_PIPELINE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "TX_QUEUE_PIPELINE" -component $cc]
# ipgui::move_param -component $cc -order 9 $p -parent $group
# set_property  -dict [list \
#   "display_name" "TX queue pipeline" \
#   "tooltip" { 3 + if {TX_QUEUE_INDEX_WIDTH > 12} {TX_QUEUE_INDEX_WIDTH-12} else {0} } \
# ] $p

# ipgui::add_param -name "RX_QUEUE_PIPELINE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "RX_QUEUE_PIPELINE" -component $cc]
# ipgui::move_param -component $cc -order 10 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RX queue pipeline" \
#   "tooltip" { 3 + if {RX_QUEUE_INDEX_WIDTH > 12} {RX_QUEUE_INDEX_WIDTH-12} else {0} } \
# ] $p

# ipgui::add_param -name "CQ_PIPELINE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "CQ_PIPELINE" -component $cc]
# ipgui::move_param -component $cc -order 11 $p -parent $group
# set_property  -dict [list \
#   "display_name" "Completion queue pipeline" \
#   "tooltip" { 3 + if {CQN_WIDTH > 12} {CQN_WIDTH-12} else {0} } \
# ] $p

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

# ipgui::add_param -name "RX_INDIR_TBL_ADDR_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "RX_INDIR_TBL_ADDR_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RX indirect table address width" \
#   "tooltip" { if {RX_QUEUE_INDEX_WIDTH > 8} {8} else {RX_QUEUE_INDEX_WIDTH} } \
# ] $p

set group [ipgui::add_group -name "Scheduler configuration" -component $cc \
  -parent $page2 -display_name "Scheduler configuration"]

# ipgui::add_param -name "TX_SCHEDULER_OP_TABLE_SIZE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "TX_SCHEDULER_OP_TABLE_SIZE" -component $cc]
# ipgui::move_param -component $cc -order 0 $p -parent $group
# set_property  -dict [list \
#   "display_name" "TX scheduler operation table size" \
#   "tooltip" { TX_DESC_TABLE_SIZE } \
# ] $p

# ipgui::add_param -name "TX_SCHEDULER_PIPELINE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "TX_SCHEDULER_PIPELINE" -component $cc]
# ipgui::move_param -component $cc -order 1 $p -parent $group
# set_property  -dict [list \
#   "display_name" "TX scheduler pipeline" \
#   "tooltip" { TX_QUEUE_PIPELINE } \
# ] $p

ipgui::add_param -name "TDMA_INDEX_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "TDMA_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
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

# ipgui::add_param -name "AXI_STRB_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXI_STRB_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI strobe width" \
#   "tooltip" { AXI_DATA_WIDTH/8 } \
# ] $p

ipgui::add_param -name "AXI_ID_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
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

# ipgui::add_param -name "RAM_ADDR_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "RAM_ADDR_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 4 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM address width" \
#   "tooltip" { log2(if {TX_RAM_SIZE > RX_RAM_SIZE} {TX_RAM_SIZE} else {RX_RAM_SIZE}) } \
# ] $p

ipgui::add_param -name "RAM_PIPELINE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "RAM_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "display_name" "RAM pipeline" \
] $p

ipgui::add_param -name "AXI_DMA_MAX_BURST_LEN" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXI_DMA_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "display_name" "AXI DMA Max burst length" \
] $p

# ipgui::add_param -name "AXI_DMA_READ_USE_ID" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXI_DMA_READ_USE_ID" -component $cc]
# ipgui::move_param -component $cc -order 7 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "AXI DMA read use ID" \
# ] $p

# ipgui::add_param -name "AXI_DMA_WRITE_USE_ID" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXI_DMA_WRITE_USE_ID" -component $cc]
# ipgui::move_param -component $cc -order 8 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "AXI DMA write use ID" \
# ] $p

# ipgui::add_param -name "AXI_DMA_READ_OP_TABLE_SIZE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXI_DMA_READ_OP_TABLE_SIZE" -component $cc]
# ipgui::move_param -component $cc -order 9 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI DMA read operation table size" \
#   "tooltip" { pow(2, AXI_ID_WIDTH) } \
# ] $p

# ipgui::add_param -name "AXI_DMA_WRITE_OP_TABLE_SIZE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXI_DMA_WRITE_OP_TABLE_SIZE" -component $cc]
# ipgui::move_param -component $cc -order 10 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI DMA write operation table size" \
#   "tooltip" { pow(2, AXI_ID_WIDTH) } \
# ] $p

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

# ipgui::add_param -name "AXIL_CTRL_STRB_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXIL_CTRL_STRB_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite control strobe width" \
#   "tooltip" { AXIL_CTRL_DATA_WIDTH/8 } \
# ] $p

# ipgui::add_param -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 3 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite interface control address width" \
#   "tooltip" { AXIL_CTRL_ADDR_WIDTH - log2(IF_COUNT) } \
# ] $p

# ipgui::add_param -name "AXIL_CSR_ENABLE" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXIL_CSR_ENABLE" -component $cc]
# ipgui::move_param -component $cc -order 4 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "AXI4 Lite CSR enable" \
# ] $p

# ipgui::add_param -name "AXIL_CSR_ADDR_WIDTH" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "AXIL_CSR_ADDR_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 4 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite CSR address width" \
#   "tooltip" { AXIL_IF_CTRL_ADDR_WIDTH - 5 - log2({SCHED_PER_IF + 4 + 7} / 8) } \
# ] $p

ipgui::add_param -name "AXIL_CSR_PASSTHROUGH_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CSR_PASSTHROUGH_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI4 Lite CSR passthrough enable" \
] $p

# ipgui::add_param -name "RB_NEXT_PTR" -component $cc -parent $page2
# set p [ipgui::get_guiparamspec -name "RB_NEXT_PTR" -component $cc]
# ipgui::move_param -component $cc -order 6 $p -parent $group
# set_property  -dict [list \
#   "display_name" "Register base next pointer" \
# ] $p

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

# ipgui::add_param -name "TX_CPL_ENABLE" -component $cc -parent $page3
# set p [ipgui::get_guiparamspec -name "TX_CPL_ENABLE" -component $cc]
# ipgui::move_param -component $cc -order 0 $p -parent $group
# set_property  -dict [list \
#   "display_name" "TX CPL enable" \
#   "tooltip" { PTP_TS_ENABLE } \
# ] $p

ipgui::add_param -name "TX_CPL_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_CPL_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "TX CPL FIFO depth" \
] $p

ipgui::add_param -name "TX_TAG_WIDTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "TX tag width" \
  "tooltip" { log2(TX_DESC_TABLE_SIZE)+1 } \
] $p

ipgui::add_param -name "TX_CHECKSUM_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "TX checksum enable" \
] $p

ipgui::add_param -name "RX_HASH_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_HASH_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "RX hash enable" \
] $p

ipgui::add_param -name "RX_CHECKSUM_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "RX checksum enable" \
] $p

ipgui::add_param -name "PFC_ENABLE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "PFC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property  -dict [list \
  "widget" "checkBox" \
  "display_name" "PFC enable" \
] $p

# ipgui::add_param -name "LFC_ENABLE" -component $cc -parent $page3
# set p [ipgui::get_guiparamspec -name "LFC_ENABLE" -component $cc]
# ipgui::move_param -component $cc -order 6 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "LFC enable" \
#   "tooltip" { PFC_ENABLE } \
# ] $p

# ipgui::add_param -name "MAC_CTRL_ENABLE" -component $cc -parent $page3
# set p [ipgui::get_guiparamspec -name "MAC_CTRL_ENABLE" -component $cc]
# ipgui::move_param -component $cc -order 7 $p -parent $group
# set_property  -dict [list \
#   "widget" "checkBox" \
#   "display_name" "MAC control enable" \
# ] $p

ipgui::add_param -name "TX_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property  -dict [list \
  "display_name" "TX FIFO depth" \
] $p

ipgui::add_param -name "RX_FIFO_DEPTH" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property  -dict [list \
  "display_name" "RX FIFO depth" \
] $p

ipgui::add_param -name "MAX_TX_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "MAX_TX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property  -dict [list \
  "display_name" "Max TX size" \
] $p

ipgui::add_param -name "MAX_RX_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "MAX_RX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property  -dict [list \
  "display_name" "Max RX size" \
] $p

ipgui::add_param -name "TX_RAM_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "TX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property  -dict [list \
  "display_name" "TX RAM size" \
] $p

ipgui::add_param -name "RX_RAM_SIZE" -component $cc -parent $page3
set p [ipgui::get_guiparamspec -name "RX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 11 $p -parent $group
set_property  -dict [list \
  "display_name" "RX RAM size" \
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

# set group [ipgui::add_group -name "AXI lite interface configuration (application control)" -component $cc \
#   -parent $page4 -display_name "AXI lite interface configuration (application control)"]

# ipgui::add_param -name "AXIL_APP_CTRL_DATA_WIDTH" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_DATA_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 0 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite application control data width" \
#   "tooltip" { AXIL_CTRL_DATA_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 1 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite application control address width" \
# ] $p

# ipgui::add_param -name "AXIL_APP_CTRL_STRB_WIDTH" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_STRB_WIDTH" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Lite application control strobe width" \
#   "tooltip" { AXIL_APP_CTRL_DATA_WIDTH/8 } \
# ] $p

# set group [ipgui::add_group -name "Application parameters" -component $cc \
#   -parent $page4 -display_name "Application parameters"]

# ipgui::add_param -name "DMA_ADDR_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "DMA_ADDR_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 0 $p -parent $group
# set_property  -dict [list \
#   "display_name" "DMA address width" \
#   "tooltip" { AXI_ADDR_WIDTH } \
# ] $p

# ipgui::add_param -name "RAM_SEL_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "RAM_SEL_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 1 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM select width" \
#   "tooltip" { $clog2(IF_COUNT+(APP_ENABLE && APP_DMA_ENABLE ? 1 : 0))+2 } \
# ] $p

# ipgui::add_param -name "RAM_SEG_COUNT_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "RAM_SEG_COUNT_APP" -component $cc]
# ipgui::move_param -component $cc -order 2 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM segment count" \
#   "tooltip" { 2 } \
# ] $p

# ipgui::add_param -name "RAM_SEG_DATA_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "RAM_SEG_DATA_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 3 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM segment data width" \
#   "tooltip" { AXI_DATA_WIDTH } \
# ] $p

# ipgui::add_param -name "RAM_SEG_BE_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "RAM_SEG_BE_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 4 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM segment byte enable width" \
#   "tooltip" { RAM_SEG_DATA_WIDTH_APP/8 } \
# ] $p

# ipgui::add_param -name "RAM_SEG_ADDR_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "RAM_SEG_ADDR_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 5 $p -parent $group
# set_property  -dict [list \
#   "display_name" "RAM segment address width" \
#   "tooltip" { RAM_ADDR_WIDTH-$clog2(2*RAM_SEG_BE_WIDTH_APP) } \
# ] $p

# ipgui::add_param -name "AXIS_SYNC_KEEP_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_SYNC_KEEP_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 6 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream sync keep width" \
#   "tooltip" { AXIS_SYNC_DATA_WIDTH/(AXIS_DATA_WIDTH/AXIS_KEEP_WIDTH) } \
# ] $p

# ipgui::add_param -name "AXIS_SYNC_TX_USER_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_SYNC_TX_USER_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 7 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream sync TX user width" \
#   "tooltip" { AXIS_TX_USER_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIS_SYNC_RX_USER_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_SYNC_RX_USER_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 8 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream sync RX user width" \
#   "tooltip" { AXIS_RX_USER_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIS_IF_KEEP_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_KEEP_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 9 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface keep width" \
#   "tooltip" { AXIS_IF_DATA_WIDTH/(AXIS_DATA_WIDTH/AXIS_KEEP_WIDTH) } \
# ] $p

# ipgui::add_param -name "AXIS_IF_TX_ID_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_ID_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 10 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface TX ID width" \
#   "tooltip" { TX_QUEUE_INDEX_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIS_IF_RX_ID_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_ID_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 11 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface RX ID width" \
#   "tooltip" { PORTS_PER_IF > 1 ? $clog2(PORTS_PER_IF) : 1 } \
# ] $p

# ipgui::add_param -name "AXIS_IF_TX_DEST_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_DEST_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 12 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface TX destination width" \
#   "tooltip" { $clog2(PORTS_PER_IF)+4 } \
# ] $p

# ipgui::add_param -name "AXIS_IF_RX_DEST_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_DEST_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 13 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface RX destination width" \
#   "tooltip" { RX_QUEUE_INDEX_WIDTH+1 } \
# ] $p

# ipgui::add_param -name "AXIS_IF_TX_USER_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_TX_USER_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 14 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface TX user width" \
#   "tooltip" { AXIS_TX_USER_WIDTH } \
# ] $p

# ipgui::add_param -name "AXIS_IF_RX_USER_WIDTH_APP" -component $cc -parent $page4
# set p [ipgui::get_guiparamspec -name "AXIS_IF_RX_USER_WIDTH_APP" -component $cc]
# ipgui::move_param -component $cc -order 15 $p -parent $group
# set_property  -dict [list \
#   "display_name" "AXI4 Stream interface RX user width" \
#   "tooltip" { AXIS_RX_USER_WIDTH } \
# ] $p

## Dependencies

# Base IP dependencies


## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
