###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create ethernet

if [info exists ::env(BOARD)] {
  set board $::env(BOARD)
  if [string equal $board VCU118] {
    set_property part xcvu9p-flga2104-2L-e [current_project]
    source "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_usplus.tcl"
    source "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_gty.tcl"
  } elseif [string equal $board K26] {
    set_property part xck26-sfvc784-2LVI-i [current_project]
    source "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl"
  } else {
    error "$board board is not supported!"
  }
} else {
  error "Missing BOARD environment variable definition from makefile!"
}

if [string equal $board VCU118] {
# Corundum sources
adi_ip_files ethernet [list \
  "ethernet_core_vcu118.v" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/rtl/sync_signal.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cmac_gty_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cmac_gty_ch_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rb_drp.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cmac_pad.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mac_ts_insert.v" \
]
} elseif [string equal $board K26] {
adi_ip_files ethernet [list \
  "ethernet_core_k26.v" \
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
} else {
  error "Missing board type"
}

adi_ip_properties_lite ethernet
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Corundum Ethernet" $cc
set_property description "Corundum Ethernet Core IP" $cc

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
    {"axis_eth_tx_tuser" "TUSER"} ]

# adi_add_bus_clock "eth_tx_clk" "axis_eth_tx" "eth_tx_rst"

adi_add_bus "axis_eth_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"axis_eth_rx_tdata" "TDATA"} \
    {"axis_eth_rx_tkeep" "TKEEP"} \
    {"axis_eth_rx_tvalid" "TVALID"} \
    {"axis_eth_rx_tready" "TREADY"} \
    {"axis_eth_rx_tlast" "TLAST"} \
    {"axis_eth_rx_tuser" "TUSER"} ]

# adi_add_bus_clock "eth_rx_clk" "axis_eth_rx" "eth_rx_rst"

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

adi_if_infer_bus analog.com:interface:if_sfp master m_sfp [list \
    "rx_p  sfp_rx_p" \
    "rx_n  sfp_rx_n" \
    "tx_p  sfp_tx_p" \
    "tx_n  sfp_tx_n" \
    "mgt_refclk_p  sfp_mgt_refclk_p" \
    "mgt_refclk_n  sfp_mgt_refclk_n" \
]

adi_add_bus "s_iic" "slave" \
  "xilinx.com:interface:iic_rtl:1.0" \
  "xilinx.com:interface:iic:1.0" \
  [ list \
    {"sfp_iic_scl_i_w" "SCL_I"} \
    {"sfp_iic_scl_o_w" "SCL_O"} \
    {"sfp_iic_scl_t_w" "SCL_T"} \
    {"sfp_iic_sda_i_w" "SDA_I"} \
    {"sfp_iic_sda_o_w" "SDA_O"} \
    {"sfp_iic_sda_t_w" "SDA_T"} ]

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
set_property  -dict [list \
  "display_name" "Interface count" \
] $p

ipgui::add_param -name "PORTS_PER_IF" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Ports per interface" \
] $p

ipgui::add_param -name "PORT_MASK" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "Port mask" \
] $p

ipgui::add_page -name {PTP} -component $cc -display_name {PTP Setup}
set page1 [ipgui::get_pagespec -name "PTP" -component $cc]

set group [ipgui::add_group -name "PTP-related configuration" -component $cc \
  -parent $page1 -display_name "PTP-related configuration"]

ipgui::add_param -name "PTP_TS_ENABLE" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP Timestamp Enable" \
] $p

ipgui::add_param -name "PTP_TS_FMT_TOD" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PTP_TS_FMT_TOD" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "PTP_TS_FMT_TOD" \
] $p

ipgui::add_param -name "TX_TAG_WIDTH" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "TX_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "TX_TAG_WIDTH" \
] $p

ipgui::add_page -name {Ethernet} -component $cc -display_name {Ethernet Interface Configuration}
set page2 [ipgui::get_pagespec -name "Ethernet" -component $cc]

set group [ipgui::add_group -name "ETH Interface configuration" -component $cc \
  -parent $page2 -display_name "ETH Interface configuration"]

ipgui::add_param -name "ENABLE_PADDING" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "ENABLE_PADDING" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "ENABLE_PADDING" \
] $p

ipgui::add_param -name "ENABLE_DIC" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "ENABLE_DIC" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "ENABLE_DIC" \
] $p

ipgui::add_param -name "MIN_FRAME_LENGTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "MIN_FRAME_LENGTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "MIN_FRAME_LENGTH" \
] $p

ipgui::add_param -name "PFC_ENABLE" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "PFC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property  -dict [list \
  "display_name" "PFC_ENABLE" \
] $p


ipgui::add_page -name {Physical} -component $cc -display_name {Physical}
set page3 [ipgui::get_pagespec -name "Physical" -component $cc]

set group [ipgui::add_group -name "Structural configuration" -component $cc \
  -parent $page3 -display_name "Structural configuration"]

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
  "display_name" "PORTS_PER_IF" \
] $p

ipgui::add_param -name "PORT_MASK" -component $cc -parent $page1
set p [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property  -dict [list \
  "display_name" "PORT_MASK" \
] $p

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
