###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_hbm
adi_ip_files util_hbm [list \
  "util_hbm_constr.xdc" \
  "util_hbm_ooc.ttcl" \
  "util_hbm.v" \
  "bd/bd.tcl" \
]

adi_ip_properties_lite util_hbm
adi_ip_ttcl util_dacfifo "util_hbm_ooc.ttcl"
adi_ip_bd util_hbm "bd/bd.tcl"

set_property PROCESSING_ORDER LATE [ipx::get_files util_hbm_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_add_core_dependencies { \
  analog.com:user:util_cdc:1.0 \
  analog.com:user:axi_dmac:1.0 \
}

set_property display_name "ADI AXIS to HBM/DDR AXI bridge" [ipx::current_core]
set_property description "Bridge between a AXI Stream master/slave interface and an AXI Memory Mapped interface" [ipx::current_core]

set max_axi_ifc 16
set cc [ipx::current_core]

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"} \
    {"s_axis_strb" "TSTRB"} \
    {"s_axis_keep" "TKEEP"} \
    {"s_axis_user" "TUSER"} \
    {"s_axis_last" "TLAST"}]

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"} \
    {"m_axis_strb" "TSTRB"} \
    {"m_axis_keep" "TKEEP"} \
    {"m_axis_user" "TUSER"} \
    {"m_axis_last" "TLAST"}]

adi_add_multi_bus $max_axi_ifc "MAXI_" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  [list \
    { "m_axi_araddr"  "ARADDR"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ADDR_WIDTH')))"} \
    { "m_axi_arburst" "ARBURST"  2 } \
    { "m_axi_arlen"   "ARLEN"    4 "8-(spirit:decode(id('MODELPARAM_VALUE.AXI_PROTOCOL')) * 4)"} \
    { "m_axi_arready" "ARREADY"  1 } \
    { "m_axi_arsize"  "ARSIZE"   3 } \
    { "m_axi_arvalid" "ARVALID"  1 } \
    { "m_axi_awaddr"  "AWADDR"  32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ADDR_WIDTH')) * 1)"} \
    { "m_axi_awburst" "AWBURST"  2 } \
    { "m_axi_awlen"   "AWLEN"    4 "8-(spirit:decode(id('MODELPARAM_VALUE.AXI_PROTOCOL')) * 4)"} \
    { "m_axi_awready" "AWREADY"  1 } \
    { "m_axi_awsize"  "AWSIZE"   3 } \
    { "m_axi_awvalid" "AWVALID"  1 } \
    { "m_axi_bready"  "BREADY"   1 } \
    { "m_axi_bresp"   "BRESP"    2 } \
    { "m_axi_bvalid"  "BVALID"   1 } \
    { "m_axi_rdata"   "RDATA"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH')))"} \
    { "m_axi_rlast"   "RLAST"    1 } \
    { "m_axi_rready"  "RREADY"   1 } \
    { "m_axi_rresp"   "RRESP"    2 } \
    { "m_axi_rvalid"  "RVALID"   1 } \
    { "m_axi_wdata"   "WDATA"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH')))"} \
    { "m_axi_wlast"   "WLAST"    1 } \
    { "m_axi_wready"  "WREADY"   1 } \
    { "m_axi_wstrb"   "WSTRB"    4 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH'))/8)"} \
    { "m_axi_wvalid"  "WVALID"   1 } \
  ] \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_M')) > {i})"

set ifc_list ""
for {set idx 0} {$idx < $max_axi_ifc} {incr idx} {
  set ifc_list $ifc_list:MAXI_$idx

  ipx::add_address_space MAXI_$idx [ipx::current_core]
  set_property master_address_space_ref MAXI_${idx} \
    [ipx::get_bus_interfaces MAXI_$idx \
    -of_objects [ipx::current_core]]
  set_property range 4G [ipx::get_address_spaces MAXI_${idx}]

}
adi_add_bus_clock "m_axi_aclk" $ifc_list "m_axi_aresetn"

adi_add_bus "wr_ctrl" "slave" \
  "analog.com:interface:if_do_ctrl_rtl:1.0" \
  "analog.com:interface:if_do_ctrl:1.0" \
  [list {"wr_request_enable" "request_enable"} \
        {"wr_request_valid" "request_valid"} \
        {"wr_request_ready" "request_ready"} \
        {"wr_request_length" "request_length"} \
        {"wr_response_measured_length" "response_measured_length"} \
        {"wr_response_eot" "response_eot"} \
        {"wr_overflow" "status_overflow"} \
    ]

adi_add_bus "rd_ctrl" "slave" \
  "analog.com:interface:if_do_ctrl_rtl:1.0" \
  "analog.com:interface:if_do_ctrl:1.0" \
  [list {"rd_request_enable" "request_enable"} \
        {"rd_request_valid" "request_valid"} \
        {"rd_request_ready" "request_ready"} \
        {"rd_request_length" "request_length"} \
        {"rd_response_eot" "response_eot"} \
        {"rd_underflow" "status_underflow"} \
    ]

adi_add_bus_clock "s_axis_aclk" "s_axis:wr_ctrl" "s_axis_aresetn"
adi_add_bus_clock "m_axis_aclk" "m_axis:rd_ctrl" "m_axis_aresetn"

# The core does not issue narrow bursts
foreach intf [ipx::get_bus_interfaces MAXI_* -of_objects $cc] {
  set para [ipx::add_bus_parameter SUPPORTS_NARROW_BURST $intf]
  set_property "VALUE" "0" $para
}

#
#  Parameters description
#
set_property  -dict [list \
    "value_resolve_type" "user" \
    "value" 1 \
    "value_validation_type" "pairs" \
    "value_validation_pairs" {"TX (DAC)" 1 "RX (ADC)" 0} \
  ] \
  [ipx::get_user_parameters TX_RX_N -of_objects $cc]

foreach dir {"SRC" "DST"} {
  set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "16 32 64 128 256 512 1024 2048 4096" \
  ] \
  [ipx::get_user_parameters ${dir}_DATA_WIDTH -of_objects $cc]
}

set_property -dict [list \
    "value_validation_type" "pairs" \
    "value" "28" \
    "value_validation_pairs" {\
      "256MB" "28" \
      "512MB" "29" \
      "1GB" "30" \
      "2GB" "31" \
      "4GB" "32" \
      "8GB" "33" \
      "16GB" "34" \
    } \
 ] \
 [ipx::get_user_parameters LENGTH_WIDTH -of_objects $cc]

set_property  -dict [list \
    "value_resolve_type" "user" \
    "value" 2 \
    "value_validation_type" "pairs" \
    "value_validation_pairs" {"HBM" 2 "DDR" 1} \
  ] \
  [ipx::get_user_parameters MEM_TYPE -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "pairs" \
    "value" "0" \
    "value_validation_pairs" {"AXI3" "1" "AXI4" "0"} \
  ] \
  [ipx::get_user_parameters AXI_PROTOCOL -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "32 64 128 256 512 1024" \
  ] \
  [ipx::get_user_parameters AXI_DATA_WIDTH -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "1 2 4 8 16" \
  ] \
  [ipx::get_user_parameters NUM_M -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "2 4 8 16 32" \
  ] \
  [ipx::get_user_parameters SRC_FIFO_SIZE -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "2 4 8 16 32" \
  ] \
  [ipx::get_user_parameters DST_FIFO_SIZE -of_objects $cc]

# 1 segment = 256MB
# HBM_SEGMENTS_PER_MASTER = Storage size (MB) / 256 (MB) / number of masters
set_property -dict [list \
    "enablement_value" "false" \
    "value_tcl_expr" { ceil(2**($LENGTH_WIDTH-28) / ${NUM_M}) } \
  ] \
  [ipx::get_user_parameters HBM_SEGMENTS_PER_MASTER -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "15" \
    "enablement_tcl_expr" "\$MEM_TYPE == 2" \
  ] \
  [ipx::get_user_parameters HBM_SEGMENT_INDEX -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "4294967296" \
    "enablement_tcl_expr" "\$MEM_TYPE == 1" \
  ] \
  [ipx::get_user_parameters DDR_BASE_ADDDRESS -of_objects $cc]

#
# GUI formatting
#

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

# General settings group
set group [ipgui::add_group -name "General Settings" -component $cc \
 -parent $page0 -display_name "General Settings"]

set p [ipgui::get_guiparamspec -name "TX_RX_N" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property  -dict [list \
  "display_name" "Datapath type" \
  "widget" "comboBox" \
 ] $p

set p [ipgui::get_guiparamspec -name "LENGTH_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property  -dict [list \
  "display_name" "Storage size" \
  "tooltip" "Defines the amount of data can be stored starting from the base address of the storage."\
 ] $p

# Offload interface group
set group [ipgui::add_group -name "Data Offload Interface" -component $cc \
    -parent $page0 -display_name "Data Offload Interface"]

set p [ipgui::get_guiparamspec -name "SRC_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
    "display_name" "Source AXIS Bus Width" \
    "tooltip"      "Source AXIS Bus Width (s_axis)" \
  ] $p

set p [ipgui::get_guiparamspec -name "SRC_FIFO_SIZE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "Write Buffer Size" \
  "tooltip" "Size of internal data mover buffer used for write to external memory. In AXI bursts, where one burst is max 4096 bytes or 2*AXI_DATA_WIDTH bytes for AXI3 or 32*AXI_DATA_WIDTH bytes for AXI4." \
  "widget" "comboBox" \
] $p

set p [ipgui::get_guiparamspec -name "DST_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
    "display_name" "Destination AXIS Bus Width" \
    "tooltip"      "Destination AXIS Bus Width (m_axis)" \
  ] $p

set p [ipgui::get_guiparamspec -name "DST_FIFO_SIZE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "Read Buffer Size" \
  "tooltip" "Size of internal data mover buffer used for read from the external memory. In AXI bursts, where one burst is max 4096 bytes or 2*AXI_DATA_WIDTH bytes for AXI3 or 32*AXI_DATA_WIDTH bytes for AXI4." \
  "widget" "comboBox" \
] $p

# Memory interface group
set group [ipgui::add_group -name "External Memory Interface" -component $cc \
    -parent $page0 -display_name "External Memory Interface"]

set p [ipgui::get_guiparamspec -name "MEM_TYPE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "External Storage Type" \
  "tooltip" "External Storage Type" \
  "widget" "comboBox" \
] $p

set p [ipgui::get_guiparamspec -name "NUM_M" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "Number of AXI Masters" \
  "tooltip" "Number of AXI masters the data stream bus is split" \
  "widget" "comboBox" \
] $p

set p [ipgui::get_guiparamspec -name "AXI_PROTOCOL" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "AXI Protocol" \
] $p

set p [ipgui::get_guiparamspec -name "AXI_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "AXI Data Bus Width" \
  "tooltip" "Bus Width: Memory-Mapped interface with valid range of 32-1024 bits" \
] $p

# HBM  sub group
set hbm_group [ipgui::add_group -name "HBM Interface" -component $cc \
    -parent $group -display_name "HBM Interface"]

set p [ipgui::get_guiparamspec -name "HBM_SEGMENTS_PER_MASTER" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $hbm_group
set_property -dict [list \
  "widget" {textEdit} \
  "display_name" "HBM sections per master" \
  "tooltip" "HBM sections (2Gb/256MB pseudo channels) per master" \
] $p

set p [ipgui::get_guiparamspec -name "HBM_SEGMENT_INDEX" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $hbm_group
set_property -dict [list \
  "display_name" "First HBM section index" \
  "tooltip" "First used HBM section (2Gb pseudo channels).The base address where data is stored is generated based on this parameter" \
  "widget" "comboBox" \
] $p

# DDR sub group
set hbm_group [ipgui::add_group -name "DDR Interface" -component $cc \
    -parent $group -display_name "DDR Interface"]

set p [ipgui::get_guiparamspec -name "DDR_BASE_ADDDRESS" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $hbm_group
set_property -dict [list \
  "display_name" "DDR base address" \
  "tooltip" "The base address where data is stored is generated based on this parameter" \
] $p

ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "AXI_ADDR_WIDTH" -component $cc]

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
