###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create ethernet_vck190

set _cand [lsort [get_parts -quiet xcvc1902*]]
if {[llength $_cand] > 0} {
  set_property part [lindex $_cand 0] [current_project]
  puts "INFO: ethernet_vck190 packaged against part [lindex $_cand 0]"
} else {
  set_property part xcvu9p-flga2104-2L-e [current_project]
  puts "CRITICAL WARNING: no xcvc1902 part found; packaged against xcvu9p-flga2104-2L-e"
}

adi_ip_files ethernet_vck190 [list \
  "ethernet_vck190.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_gty_wrapper.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_tx_adapt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_rx_adapt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_ptp_ts_cvt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_ptp_sync.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mac_ts_insert.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cmac_pad.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_map_mac_axis.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rb_drp.v" \
]

adi_ip_properties_lite ethernet_vck190

set cc [ipx::current_core]

set_property display_name "Corundum Ethernet VCK190 (MRMAC)" $cc
set_property description "Corundum Ethernet MAC wrapper for the AMD Versal MRMAC (1x100GE CAUI-4 or 4x25GE)" $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum/ethernet/ethernet_vck190} $cc

set_property value_tcl_expr {expr {48 + 48 * $PTP_TS_FMT_TOD}} \
  [ipx::get_user_parameters PTP_TS_WIDTH -of_objects $cc]
set_property value_tcl_expr {expr {$PTP_TS_ENABLE * $PTP_TS_WIDTH + 1}} \
  [ipx::get_user_parameters AXIS_RX_USER_WIDTH -of_objects $cc]
set_property value_dependency {} \
  [ipx::get_hdl_parameters AXIS_RX_USER_WIDTH -of_objects $cc]

set_property value_tcl_expr {expr {$MODE == "4x25G" ? 64 : $MODE == "1x40G" ? 256 : 512}} \
  [ipx::get_user_parameters AXIS_DATA_WIDTH -of_objects $cc]
set_property value_tcl_expr {expr {$AXIS_DATA_WIDTH / 8}} \
  [ipx::get_user_parameters AXIS_KEEP_WIDTH -of_objects $cc]
set_property value_tcl_expr {expr {$MODE == "4x25G" ? 64 : $MODE == "1x40G" ? 256 : 384}} \
  [ipx::get_user_parameters MRMAC_PORT_DATA_W -of_objects $cc]
set_property value_tcl_expr {expr {$MODE == "4x25G" ? 11 : $MODE == "1x40G" ? 44 : 66}} \
  [ipx::get_user_parameters MRMAC_PORT_KUSER_W -of_objects $cc]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

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

adi_add_bus_clock "eth_tx_clk" "axis_eth_tx:axis_tx_ptp" "eth_tx_rst" "master" "master"
adi_add_bus_clock "eth_rx_clk" "axis_eth_rx" "eth_rx_rst" "master" "master"
adi_add_bus_clock "eth_tx_ptp_clk" "ethernet_ptp_tx" "eth_tx_ptp_rst" "master" "master"
adi_add_bus_clock "eth_rx_ptp_clk" "ethernet_ptp_rx" "eth_rx_ptp_rst" "master" "master"

ipx::infer_bus_interface mrmac_tx_axi_clk   xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface mrmac_rx_axi_clk   xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface mrmac_tx_reset_in  xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface mrmac_rx_reset_in  xilinx.com:signal:reset_rtl:1.0 $cc

foreach _clk {mrmac_tx_axi_clk mrmac_rx_axi_clk} {
  set _bif [ipx::get_bus_interfaces ${_clk} -quiet -of_objects $cc]
  if {$_bif ne ""} {
    set _p [ipx::get_bus_parameters ASSOCIATED_BUSIF -quiet -of_objects $_bif]
    if {$_p ne ""} { set_property value {} $_p }
  }
}

ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

ipgui::add_page -name {Physical} -component $cc -display_name {Physical}
set page0 [ipgui::get_pagespec -name "Physical" -component $cc]

set group [ipgui::add_group -name "Structural configuration" -component $cc \
  -parent $page0 -display_name "Structural configuration"]

ipgui::add_param -name "MODE" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "MODE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "Mode" \
  "tooltip" "1x100G: one 100GE port (AXIS_DATA_WIDTH 512). 4x25G: four 25GBASE-R ports (AXIS_DATA_WIDTH 64, PORTS_PER_IF 4). 1x40G: one 40GBASE-R4 port (AXIS_DATA_WIDTH 256)" \
  "widget" "comboBox" \
] $p
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1x100G 4x25G 1x40G" \
] [ipx::get_user_parameters MODE -of_objects $cc]

ipgui::add_param -name "IF_COUNT" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "IF_COUNT" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "Interface count" \
] $p

ipgui::add_param -name "PORTS_PER_IF" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "Ports per interface" \
] $p

ipgui::add_param -name "PORT_MASK" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
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
  "display_name" "Enable RS FEC (in MRMAC hard IP)" \
] $p

ipgui::add_param -name "AXIS_DATA_WIDTH" -component $cc -parent $page2
set p [ipgui::get_guiparamspec -name "AXIS_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "AXI4 Stream data width" \
  "tooltip" { 512 for 1x100G, 64 for 4x25G } \
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
  "tooltip" { if {PTP_TS_ENABLE} {PTP_TS_WIDTH} else {0} + 1; must be <= 81 (shim tuser) } \
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

ipx::create_xgui_files $cc
ipx::save_core $cc
