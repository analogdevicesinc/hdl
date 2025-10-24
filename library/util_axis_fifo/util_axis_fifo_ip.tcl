###############################################################################
## Copyright (C) 2015-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_axis_fifo
adi_ip_files util_axis_fifo [list \
	"util_axis_fifo.v" \
	"util_axis_fifo_address_generator.v" \
	"$ad_hdl_dir/library/common/ad_mem.v" \
	"$ad_hdl_dir/library/util_cdc/sync_bits.v" \
	"$ad_hdl_dir/library/util_cdc/sync_gray.v" \
	"bd/bd.tcl" \
]

set_property used_in_simulation false [get_files ./bd/bd.tcl]
set_property used_in_synthesis false [get_files ./bd/bd.tcl]

adi_ip_properties_lite util_axis_fifo
adi_ip_bd util_axis_fifo "bd/bd.tcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

set_property display_name "ADI AXI Stream FIFO" $cc
set_property description  "AXI Stream FIFO" $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/util_axis_fifo/index.html} $cc

## Interface definitions

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_valid" "TVALID"} \
		{"s_axis_ready" "TREADY"} \
		{"s_axis_data"  "TDATA"} \
		{"s_axis_tlast" "TLAST"} \
		{"s_axis_tkeep" "TKEEP"} \
		{"s_axis_tstrb" "TSTRB"} \
		{"s_axis_tuser" "TUSER"} \
		{"s_axis_tid" 	"TID"} \
		{"s_axis_tdest" "TDEST"} \
	}

adi_set_ports_dependency "s_axis_tlast" \
	"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
adi_set_ports_dependency "s_axis_tkeep" \
	"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"
adi_set_ports_dependency "s_axis_tstrb" \
	"(spirit:decode(id('MODELPARAM_VALUE.TSTRB_EN')) = 1)"
adi_set_ports_dependency "s_axis_tuser" \
	"(spirit:decode(id('MODELPARAM_VALUE.TUSER_EN')) = 1)"
adi_set_ports_dependency "s_axis_tid" \
	"(spirit:decode(id('MODELPARAM_VALUE.TID_EN')) = 1)"
adi_set_ports_dependency "s_axis_tdest" \
	"(spirit:decode(id('MODELPARAM_VALUE.TDEST_EN')) = 1)"

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data"  "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
		{"m_axis_tkeep" "TKEEP"} \
		{"m_axis_tstrb" "TSTRB"} \
		{"m_axis_tuser" "TUSER"} \
		{"m_axis_tid" 	"TID"} \
		{"m_axis_tdest" "TDEST"} \
	}

adi_set_ports_dependency "m_axis_tlast" \
	"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
adi_set_ports_dependency "m_axis_tkeep" \
	"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"
adi_set_ports_dependency "m_axis_tstrb" \
	"(spirit:decode(id('MODELPARAM_VALUE.TSTRB_EN')) = 1)"
adi_set_ports_dependency "m_axis_tuser" \
	"(spirit:decode(id('MODELPARAM_VALUE.TUSER_EN')) = 1)"
adi_set_ports_dependency "m_axis_tid" \
	"(spirit:decode(id('MODELPARAM_VALUE.TID_EN')) = 1)"
adi_set_ports_dependency "m_axis_tdest" \
	"(spirit:decode(id('MODELPARAM_VALUE.TDEST_EN')) = 1)"

adi_add_bus_clock "m_axis_aclk" "m_axis" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_aresetn"

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_signal_clock -of_objects $cc]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis_signal_clock -of_objects $cc]

## Parameter validation

set_property -dict [list \
	"value_validation_type" "list" \
	"value_validation_list" "8 16 32 64 128 256 512 1024 2048 4096" \
] [ipx::get_user_parameters DATA_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
	"value_validation_range_maximum" "4096" \
] [ipx::get_user_parameters ADDRESS_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
] [ipx::get_user_parameters ALMOST_FULL_THRESHOLD -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
] [ipx::get_user_parameters ALMOST_EMPTY_THRESHOLD -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
] [ipx::get_user_parameters TUSER_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
] [ipx::get_user_parameters TID_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
] [ipx::get_user_parameters TDEST_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Synchronous"  "0" \
		"Asynchronous" "1" \
	} \
] [ipx::get_user_parameters ASYNC_CLK -of_objects $cc]

foreach {k v} { \
	"TKEEP_EN"            "false" \
	"TSTRB_EN"            "false" \
	"TLAST_EN"            "false" \
	"TUSER_EN"            "false" \
	"TID_EN"              "false" \
	"TDEST_EN"            "false" \
	"M_AXIS_REGISTERED"   "true" \
} { \
  set_property -dict [list \
		"value_format" "bool" \
		"value" $v \
	] [ipx::get_user_parameters $k -of_objects $cc]
  set_property -dict [list \
		"value_format" "bool" \
		"value" $v \
	] [ipx::get_hdl_parameters $k -of_objects $cc]
}

## Customize IP layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page
ipgui::add_page -name {AXI Stream FIFO} -component $cc -display_name {AXI Stream FIFO}
set page0 [ipgui::get_pagespec -name "AXI Stream FIFO" -component $cc]

set clock_group [ipgui::add_group -name "Clock Configuration" -component $cc \
	-parent $page0 -display_name "Clock Configuration" ]

ipgui::add_param -name "ASYNC_CLK" -component $cc -parent $clock_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Clocking mode" \
	"tooltip" "\[ASYNC_CLK\] If enabled the read and write interface of the FIFO is asynchronous (its clocks are from different clock domain)."
] [ipgui::get_guiparamspec -name "ASYNC_CLK" -component $cc]

set interface_group [ipgui::add_group -name "Interface Configuration" -component $cc \
	-parent $page0 -display_name "Interface Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "Data width" \
	"tooltip" "\[DATA_WIDTH\] Data width of the AXI stream interfaces." \
] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component $cc]

ipgui::add_param -name "ADDRESS_WIDTH" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "Address width" \
	"tooltip" "\[ADDRESS_WIDTH\] Address width of the read and write address pointers. It defines the depth of the FIFO: 2 ^ ADDRESS_WIDTH" \
] [ipgui::get_guiparamspec -name "ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "ALMOST_FULL_THRESHOLD" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "Almost full threshold" \
	"tooltip" "\[ALMOST_FULL_THRESHOLD\] The offset between the almost full assertion and full assertion in number of FIFO words." \
] [ipgui::get_guiparamspec -name "ALMOST_FULL_THRESHOLD" -component $cc]

ipgui::add_param -name "ALMOST_EMPTY_THRESHOLD" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "Almost empty threshold" \
	"tooltip" "\[ALMOST_EMPTY_THRESHOLD\] The offset between the almost empty assertion and empty assertion in number of FIFO words." \
] [ipgui::get_guiparamspec -name "ALMOST_EMPTY_THRESHOLD" -component $cc]

ipgui::add_param -name "TKEEP_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TKEEP Enable" \
	"tooltip" "\[TKEEP_EN\] Enable the TKEEP for the AXI stream interface, for data byte qualification for each AXIS transaction, indicating if bytes are part of the data stream." \
] [ipgui::get_guiparamspec -name "TKEEP_EN" -component $cc]
set_property driver_value 0 [ipx::get_ports s_axis_tkeep -of_objects $cc]

ipgui::add_param -name "TSTRB_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TSTRB Enable" \
	"tooltip" "\[TSTRB_EN\] Enable the TSTRB for the AXI stream interface, for data byte qualification for each AXIS transaction, indicating data or position bytes." \
] [ipgui::get_guiparamspec -name "TSTRB_EN" -component $cc]
set_property driver_value 0 [ipx::get_ports s_axis_tstrb -of_objects $cc]

ipgui::add_param -name "TLAST_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TLAST Enable" \
	"tooltip" "\[TLAST_EN\] Enable the TLAST for the AXI stream interface, signaling packet boundaries." \
] [ipgui::get_guiparamspec -name "TLAST_EN" -component $cc]
set_property driver_value 1 [ipx::get_ports s_axis_tlast -of_objects $cc]

ipgui::add_param -name "TUSER_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TUSER Enable" \
	"tooltip" "\[TUSER_EN\] Enable the TUSER for the AXI stream interface, which is a user-defined sideband information that can be byte or transaction specific." \
] [ipgui::get_guiparamspec -name "TUSER_EN" -component $cc]
ipgui::add_param -name "TUSER_WIDTH" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "User signal width" \
	"tooltip" "\[TUSER_WIDTH\] TUSER signal bus width." \
] [ipgui::get_guiparamspec -name "TUSER_WIDTH" -component $cc]
set_property driver_value 1 [ipx::get_ports s_axis_tuser -of_objects $cc]

ipgui::add_param -name "TID_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TID Enable" \
	"tooltip" "\[TID_EN\] Enable the TID for the AXI stream interface, which is a data stream identifier." \
] [ipgui::get_guiparamspec -name "TID_EN" -component $cc]
ipgui::add_param -name "TID_WIDTH" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "ID signal width" \
	"tooltip" "\[TID_WIDTH\] TID signal bus width." \
] [ipgui::get_guiparamspec -name "TID_WIDTH" -component $cc]
set_property driver_value 1 [ipx::get_ports s_axis_tid -of_objects $cc]

ipgui::add_param -name "TDEST_EN" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "TDEST Enable" \
	"tooltip" "\[TDEST_EN\] Enable the TDEST for the AXI stream interface, which provides routing information for the data stream." \
] [ipgui::get_guiparamspec -name "TDEST_EN" -component $cc]
ipgui::add_param -name "TDEST_WIDTH" -component $cc -parent $interface_group
set_property -dict [list \
	"display_name" "Destination signal width" \
	"tooltip" "\[TDEST_WIDTH\] TDEST signal bus width." \
] [ipgui::get_guiparamspec -name "TDEST_WIDTH" -component $cc]
set_property driver_value 1 [ipx::get_ports s_axis_tdest -of_objects $cc]

set other_group [ipgui::add_group -name "Other Features" -component $cc \
	-parent $page0 -display_name "Other Features" ]

ipgui::add_param -name "M_AXIS_REGISTERED" -component $cc -parent $other_group
set_property -dict [list \
	"display_name" "Master AXIS Registered output" \
	"tooltip" "\[M_AXIS_REGISTERED\] Add an additional register stage to the master AXI stream data output." \
] [ipgui::get_guiparamspec -name "M_AXIS_REGISTERED" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
