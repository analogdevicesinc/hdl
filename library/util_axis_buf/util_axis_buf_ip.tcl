###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_axis_buf
adi_ip_files util_axis_buf [list \
  "util_axis_buf.v" ]

adi_ip_properties_lite util_axis_buf

set_property display_name "ADI AXI Stream Buffer" [ipx::current_core]
set_property description  "ADI AXI Stream Buffer for One Data Point, Useful for Breaking Long Combinational TValid Paths" [ipx::current_core]

## Interface definitions

## destination interface (e.g. RX_DMA or DAC core)

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"} \
    {"m_axis_last" "TLAST"} \
    {"m_axis_keep" "TKEEP"} ]

## adi_set_ports_dependency "m_axis_last" \
## 		"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
## adi_set_ports_dependency "m_axis_keep" \
## 		"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"


## source interface (e.g. TX_DMA or ADC core)

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"} \
    {"s_axis_last" "TLAST"} \
    {"s_axis_keep" "TKEEP"} ]

## adi_set_ports_dependency "s_axis_last" \
## 		"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
## adi_set_ports_dependency "s_axis_keep" \
## 		"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"

adi_add_bus_clock "m_axis_aclk" "m_axis:s_axis" "m_axis_aresetn"


## Parameter validation

set_property -dict [list \
	  "value_validation_type" "list" \
	  "value_validation_list" "8 16 32 64 128 256 512 1024 2048 4096" \
	  ] \
[ipx::get_user_parameters DATA_WIDTH -of_objects [ipx::current_core]]


## Remove the automatically generated GUI page
ipgui::remove_page -component [ipx::current_core] [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipx::save_core [ipx::current_core]

## Create a new GUI page
ipgui::add_page -name {AXI Stream Buffer} -component [ipx::current_core] -display_name {AXI Stream Buffer}
set page0 [ipgui::get_pagespec -name "AXI Stream Buffer" -component [ipx::current_core]]

set interface_group [ipgui::add_group -name "Interface Configuration" -component [ipx::current_core] \
	    -parent $page0 -display_name "Interface Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "Data width" \
	  "tooltip" "\[DATA_WIDTH\] Data width of the AXI stream interfaces." \
	  ] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component [ipx::current_core]]

## Create and save the XGUI file
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]



