###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

if [info exists ::env(BOARD)] {
  set board $::env(BOARD)
  set board_lowercase [string tolower $board]
  set ethernet_ip "ethernet_$board_lowercase"

  adi_ip_create $ethernet_ip $board_lowercase

  cd ./$board_lowercase

  if [string equal $board VCU118] {
    set_property part xcvu9p-flga2104-2L-e [current_project]
    source "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_usplus.tcl"
    source "$ad_hdl_dir/../corundum/fpga/mqnic/VCU118/fpga_100g/ip/cmac_gty.tcl"
  } elseif [string equal $board K26] {
    set_property part xck26-sfvc784-2LVI-i [current_project]
    # Corundum instantiates both eth_xcvr_gth_full and eth_xcvr_gth_channel,
    # but only the latter is used at our target configuration
    source $ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl
    set rm_gth_chn eth_xcvr_gth_channel
    set rm_gth_chn [ \
      get_files "[pwd]/ethernet_k26.srcs/sources_1/ip/$rm_gth_chn/$rm_gth_chn.xci"
    ]
    if {$rm_gth_chn ne ""} {
      export_ip_user_files -of_objects $rm_gth_chn -no_script -reset -force -quiet
      remove_files $rm_gth_chn
    }
  } else {
    error "$board board is not supported!"
  }
} else {
  error "Missing BOARD environment variable definition from makefile!"
}

if [string equal $board VCU118] {
# Corundum sources
  adi_ip_files ethernet [list \
    "../ethernet_core_vcu118.v" \
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
  add_file -norecurse -scan_for_includes -filese [get_filesets sources_1] [list \
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
    "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v"
  ]

  adi_ip_files ethernet [list \
    "../ethernet_core_k26.v"
  ]
} else {
  error "Missing board type"
}

adi_ip_properties_lite $ethernet_ip
set cc [ipx::current_core]
set_property display_name "Corundum Ethernet $board" $cc
set_property description "Corundum Ethernet Core IP" $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

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

if [string equal $board VCU118] {
  adi_if_infer_bus analog.com:interface:if_qspi master qspi0 [list \
    "dq_i  qspi_0_dq_i" \
    "dq_o  qspi_0_dq_o" \
    "dq_oe qspi_0_dq_oe" \
    "cs    qspi_0_cs" \
  ]

  adi_if_infer_bus analog.com:interface:if_qspi master qspi1 [list \
    "dq_i  qspi_1_dq_i" \
    "dq_o  qspi_1_dq_o" \
    "dq_oe qspi_1_dq_oe" \
    "cs    qspi_1_cs" \
  ]

  adi_if_infer_bus analog.com:interface:if_qsfp master qsfp [list \
    "tx_p        qsfp_tx_p" \
    "tx_n        qsfp_tx_n" \
    "rx_p        qsfp_rx_p" \
    "rx_n        qsfp_rx_n" \
    "modsell     qsfp_modsell" \
    "resetl      qsfp_resetl" \
    "modprsl     qsfp_modprsl" \
    "intl        qsfp_intl" \
    "lpmode      qsfp_lpmode" \
    "gtpowergood qsfp_gtpowergood" \
  ]

  adi_if_infer_bus analog.com:interface:if_i2c master i2c [list \
    "scl_i i2c_scl_i" \
    "scl_o i2c_scl_o" \
    "scl_t i2c_scl_t" \
    "sda_i i2c_sda_i" \
    "sda_o i2c_sda_o" \
    "sda_t i2c_sda_t" \
  ]

  adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_tx [list \
    "ptp_clk     eth_tx_ptp_clk" \
    "ptp_rst     eth_tx_ptp_rst" \
    "ptp_ts      eth_tx_ptp_ts" \
    "ptp_ts_step eth_tx_ptp_ts_step" \
  ]

  adi_if_infer_bus analog.com:interface:if_ethernet_ptp slave ethernet_ptp_rx [list \
    "ptp_clk     eth_rx_ptp_clk" \
    "ptp_rst     eth_rx_ptp_rst" \
    "ptp_ts      eth_rx_ptp_ts" \
    "ptp_ts_step eth_rx_ptp_ts_step" \
  ]

  adi_add_bus_clock "eth_tx_ptp_clk" "ethernet_ptp_tx" "eth_tx_ptp_rst" "master" "master"
  adi_add_bus_clock "eth_rx_ptp_clk" "ethernet_ptp_rx" "eth_rx_ptp_rst" "master" "master"
} elseif [string equal $board K26] {
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
}

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

if [string equal $board K26] {
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

  adi_set_bus_dependency "s_axil_csr" "s_axil_csr" \
    "(spirit:decode(id('PARAM_VALUE.AXIL_CSR_ENABLE')) = 1)"
} elseif [string equal $board VCU118] {
  ipgui::add_param -name "ETH_RX_CLK_FROM_TX" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "ETH_RX_CLK_FROM_TX" -component $cc]
  ipgui::move_param -component $cc -order 0 $p -parent $group
  set_property -dict [list \
    "widget" "checkBox" \
    "display_name" "Use TX clock for RX" \
  ] $p

  ipgui::add_param -name "ETH_RS_FEC_ENABLE" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "ETH_RS_FEC_ENABLE" -component $cc]
  ipgui::move_param -component $cc -order 1 $p -parent $group
  set_property -dict [list \
    "widget" "checkBox" \
    "display_name" "Enable RS FEC" \
  ] $p

  ipgui::add_param -name "AXIS_DATA_WIDTH" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "AXIS_DATA_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 2 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Stream data width" \
  ] $p

  ipgui::add_param -name "AXIS_KEEP_WIDTH" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "AXIS_KEEP_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 3 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Stream keep width" \
    "tooltip" { AXIS_DATA_WIDTH/8 } \
  ] $p

  ipgui::add_param -name "AXIS_TX_USER_WIDTH" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "AXIS_TX_USER_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 4 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Stream TX user width" \
    "tooltip" { TX_TAG_WIDTH + 1 } \
  ] $p

  ipgui::add_param -name "AXIS_RX_USER_WIDTH" -component $cc -parent $page2
  set p [ipgui::get_guiparamspec -name "AXIS_RX_USER_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 5 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Stream RX user width" \
    "tooltip" { if {PTP_TS_ENABLE} {PTP_TS_WIDTH} else {0} + 1 } \
  ] $p

  ipgui::add_page -name {AXILite} -component $cc -display_name {AXI lite interface configuration}
  set page3 [ipgui::get_pagespec -name "AXILite" -component $cc]

  set group [ipgui::add_group -name "Ethernet control" -component $cc \
    -parent $page3 -display_name "Ethernet control"]

  ipgui::add_param -name "AXIL_CTRL_DATA_WIDTH" -component $cc -parent $page3
  set p [ipgui::get_guiparamspec -name "AXIL_CTRL_DATA_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 0 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Lite control data width" \
  ] $p

  ipgui::add_param -name "AXIL_CTRL_ADDR_WIDTH" -component $cc -parent $page3
  set p [ipgui::get_guiparamspec -name "AXIL_CTRL_ADDR_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 1 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Lite control address width" \
  ] $p

  ipgui::add_param -name "AXIL_CTRL_STRB_WIDTH" -component $cc -parent $page3
  set p [ipgui::get_guiparamspec -name "AXIL_CTRL_STRB_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 2 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Lite control strobe width" \
    "tooltip" { AXIL_CTRL_DATA_WIDTH/8 } \
  ] $p

  set group [ipgui::add_group -name "Application control" -component $cc \
    -parent $page3 -display_name "Application control"]

  ipgui::add_param -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc -parent $page3
  set p [ipgui::get_guiparamspec -name "AXIL_IF_CTRL_ADDR_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 0 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Lite interface control address width" \
    "tooltip" { AXIL_CTRL_ADDR_WIDTH - log2(IF_COUNT) } \
  ] $p

  ipgui::add_param -name "AXIL_CSR_ADDR_WIDTH" -component $cc -parent $page3
  set p [ipgui::get_guiparamspec -name "AXIL_CSR_ADDR_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 1 $p -parent $group
  set_property -dict [list \
    "display_name" "AXI4 Lite CSR address width" \
    "tooltip" { AXIL_IF_CTRL_ADDR_WIDTH - 5 - log2({SCHED_PER_IF + 4 + 7} / 8) } \
  ] $p

  ipgui::add_page -name {Scheduler} -component $cc -display_name {Scheduler configuration}
  set page4 [ipgui::get_pagespec -name "Scheduler" -component $cc]

  set group [ipgui::add_group -name "Scheduler configuration" -component $cc \
    -parent $page4 -display_name "Scheduler configuration"]

  ipgui::add_param -name "TDMA_BER_ENABLE" -component $cc -parent $page4
  set p [ipgui::get_guiparamspec -name "TDMA_BER_ENABLE" -component $cc]
  ipgui::move_param -component $cc -order 0 $p -parent $group
  set_property -dict [list \
    "widget" "checkBox" \
    "display_name" "TDMA BER enable" \
  ] $p

  ipgui::add_param -name "TDMA_INDEX_WIDTH" -component $cc -parent $page4
  set p [ipgui::get_guiparamspec -name "TDMA_INDEX_WIDTH" -component $cc]
  ipgui::move_param -component $cc -order 1 $p -parent $group
  set_property -dict [list \
    "display_name" "TDMA index width" \
  ] $p
}

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc

