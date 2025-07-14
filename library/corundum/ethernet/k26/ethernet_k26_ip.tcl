###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create ethernet_k26

set_property part xck26-sfvc784-2LVI-i [current_project]

source $ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl
set rm_gth_chn eth_xcvr_gth_channel
set rm_gth_chn [ \
  get_files "[pwd]/ethernet_k26.srcs/sources_1/ip/$rm_gth_chn/$rm_gth_chn.xci"
]
if {$rm_gth_chn ne ""} {
  export_ip_user_files -of_objects $rm_gth_chn -no_script -reset -force -quiet
  remove_files $rm_gth_chn
}

# Corundum sources
adi_ip_files ethernet_k26 [list \
  "ethernet_k26.v" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/rtl/sync_signal.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_quad_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_frame_sync.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_ber_mon.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_watchdog.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/xgmii_baser_dec_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/xgmii_baser_enc_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_rx_32.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_tx_32.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_map_phy_xgmii.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rb_drp.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_mac_10g.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_rx_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_tx_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/lfsr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_ctrl_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v" \
]

adi_ip_properties_lite ethernet_k26

set cc [ipx::current_core]

set_property display_name "Corundum Ethernet K26" $cc
set_property description "Corundum Ethernet Core IP" $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum/ethernet/ethernet_k26} [ipx::current_core]

# Remove all inferred interfaces and address spaces
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

# Interface definitions

adi_add_bus "axis_eth_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_tx_tdata" "TDATA"} \
    {"axis_eth_tx_tkeep" "TKEEP"} \
    {"axis_eth_tx_tvalid" "TVALID"} \
    {"axis_eth_tx_tready" "TREADY"} \
    {"axis_eth_tx_tlast" "TLAST"} \
    {"axis_eth_tx_tuser" "TUSER"} \
  ]

adi_add_bus_clock "eth_tx_clk" "axis_eth_tx" "eth_tx_rst" "master" "master"

adi_add_bus "axis_eth_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_rx_tdata" "TDATA"} \
    {"axis_eth_rx_tkeep" "TKEEP"} \
    {"axis_eth_rx_tvalid" "TVALID"} \
    {"axis_eth_rx_tready" "TREADY"} \
    {"axis_eth_rx_tlast" "TLAST"} \
    {"axis_eth_rx_tuser" "TUSER"} \
  ]

adi_add_bus_clock "eth_rx_clk" "axis_eth_rx" "eth_rx_rst" "master" "master"

adi_if_infer_bus analog.com:interface:if_ctrl_reg slave ctrl_reg [list \
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

adi_if_infer_bus analog.com:interface:if_flow_control_tx slave flow_control_tx [list \
  "tx_enable           eth_tx_enable" \
  "tx_status           eth_tx_status" \
  "tx_lfc_en           eth_tx_lfc_en" \
  "tx_lfc_req          eth_tx_lfc_req" \
  "tx_pfc_en           eth_tx_pfc_en" \
  "tx_pfc_req          eth_tx_pfc_req" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx slave flow_control_rx [list \
  "rx_enable           eth_rx_enable" \
  "rx_status           eth_rx_status" \
  "rx_lfc_en           eth_rx_lfc_en" \
  "rx_lfc_req          eth_rx_lfc_req" \
  "rx_lfc_ack          eth_rx_lfc_ack" \
  "rx_pfc_en           eth_rx_pfc_en" \
  "rx_pfc_req          eth_rx_pfc_req" \
  "rx_pfc_ack          eth_rx_pfc_ack" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp slave axis_tx_ptp [list \
  "ts    axis_eth_tx_ptp_ts" \
  "tag   axis_eth_tx_ptp_ts_tag" \
  "valid axis_eth_tx_ptp_ts_valid" \
  "ready axis_eth_tx_ptp_ts_ready" \
]

adi_add_bus_clock "eth_tx_clk" "axis_tx_ptp" "eth_tx_rst" "master" "master"

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
set reset_intf_main [ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set reset_polarity_main [ipx::add_bus_parameter "POLARITY" $reset_intf_main]
set_property value "ACTIVE_HIGH" $reset_polarity_main

ipx::infer_bus_interface ptp_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface ptp_sample_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface eth_tx_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface eth_rx_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set reset_intf_ptp [ipx::infer_bus_interface ptp_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set reset_polarity_ptp [ipx::add_bus_parameter "POLARITY" $reset_intf_ptp]
set_property value "ACTIVE_HIGH" $reset_polarity_ptp

set eth_tx_rst_intf [ipx::infer_bus_interface eth_tx_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set eth_tx_rst_polarity [ipx::add_bus_parameter "POLARITY" $eth_tx_rst_intf]
set_property value "ACTIVE_HIGH" $eth_tx_rst_polarity
set eth_rx_rst_intf [ipx::infer_bus_interface eth_rx_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set eth_rx_rst_polarity [ipx::add_bus_parameter "POLARITY" $eth_rx_rst_intf]
set_property value "ACTIVE_HIGH" $eth_rx_rst_polarity

adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_tx [list \
  "ptp_clk     eth_tx_clk" \
  "ptp_rst     eth_tx_rst" \
  "ptp_ts      eth_tx_ptp_ts" \
  "ptp_ts_step eth_tx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_rx [list \
  "ptp_clk     eth_rx_clk" \
  "ptp_rst     eth_rx_rst" \
  "ptp_ts      eth_rx_ptp_ts" \
  "ptp_ts_step eth_rx_ptp_ts_step" \
]

adi_add_bus_clock "eth_tx_clk" "ethernet_ptp_tx" "eth_tx_rst" "master" "master"
adi_add_bus_clock "eth_rx_clk" "ethernet_ptp_rx" "eth_rx_rst" "master" "master"

adi_if_infer_bus analog.com:interface:if_flow_control_tx slave flow_control_tx [list \
  "tx_enable           eth_tx_enable" \
  "tx_status           eth_tx_status" \
  "tx_lfc_en           eth_tx_lfc_en" \
  "tx_lfc_req          eth_tx_lfc_req" \
  "tx_pfc_en           eth_tx_pfc_en" \
  "tx_pfc_req          eth_tx_pfc_req" \
  "tx_fc_quanta_clk_en eth_tx_fc_quanta_clk_en" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx slave flow_control_rx [list \
  "rx_enable           eth_rx_enable" \
  "rx_status           eth_rx_status" \
  "rx_lfc_en           eth_rx_lfc_en" \
  "rx_lfc_req          eth_rx_lfc_req" \
  "rx_lfc_ack          eth_rx_lfc_ack" \
  "rx_pfc_en           eth_rx_pfc_en" \
  "rx_pfc_req          eth_rx_pfc_req" \
  "rx_pfc_ack          eth_rx_pfc_ack" \
  "rx_fc_quanta_clk_en eth_rx_fc_quanta_clk_en" \
]

adi_add_bus "m_axis_stat" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_stat_tdata" "TDATA"} \
    {"s_axis_stat_tid" "TID"} \
    {"s_axis_stat_tvalid" "TVALID"} \
    {"s_axis_stat_tready" "TREADY"} \
  ]

adi_if_infer_bus analog.com:interface:if_sfp master m_sfp [list \
  "rx_p  sfp_rx_p" \
  "rx_n  sfp_rx_n" \
  "tx_p  sfp_tx_p" \
  "tx_n  sfp_tx_n" \
  "mgt_refclk_p  sfp_mgt_refclk_p" \
  "mgt_refclk_n  sfp_mgt_refclk_n" \
]

adi_add_bus "iic" "master" \
"xilinx.com:interface:iic_rtl:1.0" \
"xilinx.com:interface:iic:1.0" \
{
  {"scl_i" "SCL_I"} \
  {"scl_o" "SCL_O"} \
  {"scl_t" "SCL_T"} \
  {"sda_i" "SDA_I"} \
  {"sda_o" "SDA_O"} \
  {"sda_t" "SDA_T"} \
}

adi_add_bus "s_axil_csr" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"s_axil_csr_awaddr" "AWADDR"} \
    {"s_axil_csr_awprot" "AWPROT"} \
    {"s_axil_csr_awvalid" "AWVALID"} \
    {"s_axil_csr_awready" "AWREADY"} \
    {"s_axil_csr_wdata" "WDATA"} \
    {"s_axil_csr_wstrb" "WSTRB"} \
    {"s_axil_csr_wvalid" "WVALID"} \
    {"s_axil_csr_wready" "WREADY"} \
    {"s_axil_csr_bresp" "BRESP"} \
    {"s_axil_csr_bvalid" "BVALID"} \
    {"s_axil_csr_bready" "BREADY"} \
    {"s_axil_csr_araddr" "ARADDR"} \
    {"s_axil_csr_arprot" "ARPROT"} \
    {"s_axil_csr_arvalid" "ARVALID"} \
    {"s_axil_csr_arready" "ARREADY"} \
    {"s_axil_csr_rdata" "RDATA"} \
    {"s_axil_csr_rresp" "RRESP"} \
    {"s_axil_csr_rvalid" "RVALID"} \
    {"s_axil_csr_rready" "RREADY"} \
  }

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

## Customize GUI page

# Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

# Physical
ipgui::add_page -name {Physical} -component $cc -display_name {Physical}
set page0 [ipgui::get_pagespec -name "Physical" -component $cc]

set group [ipgui::add_group -name "Structural configuration" -component $cc \
  -parent $page0 -display_name "Structural configuration"]

ipgui::add_param -name "IF_COUNT" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "IF_COUNT" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "Interface count" \
] $p

ipgui::add_param -name "PORTS_PER_IF" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "Ports per interface" \
] $p

ipgui::add_param -name "PORT_MASK" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "Port mask" \
] $p

ipgui::add_page -name {PTP} -component $cc -display_name {PTP Setup}
set page1 [ipgui::get_pagespec -name "PTP" -component $cc]

set group [ipgui::add_group -name "PTP-related configuration" -component $cc \
-parent $page1 -display_name "PTP-related configuration"]

ipgui::add_param -name "PTP_TS_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "PTP Timestamp Enable" \
] $p

ipgui::add_param -name "PTP_TS_FMT_TOD" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_FMT_TOD" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_TS_FMT_TOD" \
] $p

ipgui::add_page -name {Ethernet} -component $cc -display_name {Ethernet Interface Configuration}
set page2 [ipgui::get_pagespec -name "Ethernet" -component $cc]

set group [ipgui::add_group -name "ETH Interface configuration" -component $cc \
  -parent $page2 -display_name "ETH Interface configuration"]

ipgui::add_param -name "ENABLE_PADDING" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "ENABLE_PADDING" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "ENABLE_PADDING" \
] $p

ipgui::add_param -name "ENABLE_DIC" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "ENABLE_DIC" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "ENABLE_DIC" \
] $p

ipgui::add_param -name "MIN_FRAME_LENGTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "MIN_FRAME_LENGTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "MIN_FRAME_LENGTH" \
] $p

ipgui::add_param -name "PFC_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "PFC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "PFC_ENABLE" \
] $p

ipgui::add_param -name "AXIL_CSR_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIL_CSR_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "AXI4 Lite CSR enable" \
] $p

## Dependencies

adi_set_bus_dependency "s_axil_csr" "s_axil_csr" \
  "(spirit:decode(id('PARAM_VALUE.AXIL_CSR_ENABLE')) = 1)"

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
