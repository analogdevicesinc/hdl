###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_axis_fifo
adi_ip_files util_axis_fifo [list \
	"util_axis_fifo_address_generator.v" \
	"../common/ad_mem.v" \
	"../common/ad_mem_asym.v" \
	"util_axis_fifo.v" \
]

adi_ip_properties_lite util_axis_fifo

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property display_name "ADI AXI Stream FIFO" [ipx::current_core]
set_property description  "ADI AXI Stream FIFO" [ipx::current_core]
set_property company_url {https://wiki.analog.com/resources/fpga/docs/util_axis_fifo} [ipx::current_core]

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
	}

adi_set_ports_dependency "s_axis_tlast" \
		"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
adi_set_ports_dependency "s_axis_tkeep" \
		"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data"  "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
		{"m_axis_tkeep" "TKEEP"} \
	}

adi_set_ports_dependency "m_axis_tlast" \
		"(spirit:decode(id('MODELPARAM_VALUE.TLAST_EN')) = 1)"
adi_set_ports_dependency "m_axis_tkeep" \
		"(spirit:decode(id('MODELPARAM_VALUE.TKEEP_EN')) = 1)"

adi_add_bus_clock "m_axis_aclk" "m_axis" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_aresetn"

## Parameter validation

set_property -dict [list \
	  "value_validation_type" "list" \
	  "value_validation_list" "8 16 32 64 128 256 512 1024 2048 4096" \
	  ] \
[ipx::get_user_parameters DATA_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
	  "value_validation_type" "range_long" \
	  "value_validation_range_minimum" "0" \
	  "value_validation_range_maximum" "4096" \
	  ] \
[ipx::get_user_parameters ADDRESS_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
	  "value_validation_type" "range_long" \
	  "value_validation_range_minimum" "0" \
	  ] \
[ipx::get_user_parameters ALMOST_FULL_THRESHOLD -of_objects [ipx::current_core]]

set_property -dict [list \
	  "value_validation_type" "range_long" \
	  "value_validation_range_minimum" "0" \
	  ] \
[ipx::get_user_parameters ALMOST_EMPTY_THRESHOLD -of_objects [ipx::current_core]]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Synchronous"  "0" \
		"Asynchronous" "1" \
	} \
] \
[ipx::get_user_parameters ASYNC_CLK -of_objects [ipx::current_core]]

foreach {k v} { \
	    "M_AXIS_REGISTERED"   "true" \
	    "TLAST_EN"            "false" \
	    "TKEEP_EN"            "true" \
	    "REMOVE_NULL_BEAT_EN" "false" \
} { \
  set_property -dict [list \
		      "value_format" "bool" \
                      "value" $v \
	             ] \
	    [ipx::get_user_parameters $k -of_objects [ipx::current_core]]
  set_property -dict [list \
        	      "value_format" "bool" \
		      "value" $v \
		     ] \
       	    [ipx::get_hdl_parameters $k -of_objects [ipx::current_core]]
}

## Customize IP layout

## Remove the automatically generated GUI page
ipgui::remove_page -component [ipx::current_core] [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipx::save_core [ipx::current_core]

## Create a new GUI page
ipgui::add_page -name {AXI Stream FIFO} -component [ipx::current_core] -display_name {AXI Stream FIFO}
set page0 [ipgui::get_pagespec -name "AXI Stream FIFO" -component [ipx::current_core]]

set clock_group [ipgui::add_group -name "Clock Configuration" -component [ipx::current_core] \
	    -parent $page0 -display_name "Clock Configuration" ]

ipgui::add_param -name "ASYNC_CLK" -component [ipx::current_core] -parent $clock_group
set_property -dict [list \
	  "widget" "comboBox" \
	  "display_name" "Clocking mode" \
	  "tooltip" "\[ASYNC_CLK\] If enabled the readn and write interface of the FIFO is asynchronous (its clocks are from different clock domain)."
	  ] [ipgui::get_guiparamspec -name "ASYNC_CLK" -component [ipx::current_core]]

set interface_group [ipgui::add_group -name "Interface Configuration" -component [ipx::current_core] \
	    -parent $page0 -display_name "Interface Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "Data width" \
	  "tooltip" "\[DATA_WIDTH\] Data width of the AXI stream interfaces." \
	  ] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component [ipx::current_core]]

ipgui::add_param -name "ADDRESS_WIDTH" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "Address width" \
	  "tooltip" "\[ADDRESS_WIDTH\] Address width of the read and write address pointers. It defines the depth of the FIFO : DATA_WIDTH/8 * (2 ^ ADDRESS_WIDTH)" \
	  ] [ipgui::get_guiparamspec -name "ADDRESS_WIDTH" -component [ipx::current_core]]

ipgui::add_param -name "ALMOST_FULL_THRESHOLD" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "Almost full threshold" \
	  "tooltip" "\[ALMOST_FULL_THRESHOLD\] The offset between the almost full assertion and full assertion in number of FIFO words." \
	  ] [ipgui::get_guiparamspec -name "ALMOST_FULL_THRESHOLD" -component [ipx::current_core]]

ipgui::add_param -name "ALMOST_EMPTY_THRESHOLD" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "Almost empty threshold" \
	  "tooltip" "\[ALMOST_EMPTY_THRESHOLD\] The offset between the almost empty assertion and empty assertion in number of FIFO words." \
	  ] [ipgui::get_guiparamspec -name "ALMOST_EMPTY_THRESHOLD" -component [ipx::current_core]]

ipgui::add_param -name "TLAST_EN" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "TLAST Enable" \
	  "tooltip" "\[TLAST_EN\] Enable the TLAST for the AXI stream interface, signaling packet boundaries." \
	  ] [ipgui::get_guiparamspec -name "TLAST_EN" -component [ipx::current_core]]

ipgui::add_param -name "TKEEP_EN" -component [ipx::current_core] -parent $interface_group
set_property -dict [list \
	  "display_name" "TKEEP Enable" \
	  "tooltip" "\[TKEEP_EN\] Enable the TKEEP for the AXI stream interface, for data byte qualification for each AXIS beat." \
	  ] [ipgui::get_guiparamspec -name "TKEEP_EN" -component [ipx::current_core]]

set other_group [ipgui::add_group -name "Other Features" -component [ipx::current_core] \
	    -parent $page0 -display_name "Other Features" ]

ipgui::add_param -name "M_AXIS_REGISTERED" -component [ipx::current_core] -parent $other_group
set_property -dict [list \
	  "display_name" "Master AXIS Registered output" \
	  "tooltip" "\[M_AXIS_REGISTERED\] Add an additional register stage to the master AXI stream data output." \
	  ] [ipgui::get_guiparamspec -name "M_AXIS_REGISTERED" -component [ipx::current_core]]

ipgui::add_param -name "REMOVE_NULL_BEAT_EN" -component [ipx::current_core] -parent $other_group
set_property -dict [list \
	  "display_name" "REMOVE_NULL_BEAT_EN Enable" \
	  "tooltip" "\[REMOVE_NULL_BEAT_EN\] Filteres out all the beats with a null TKEEP qualifier." \
	  ] [ipgui::get_guiparamspec -name "REMOVE_NULL_BEAT_EN" -component [ipx::current_core]]
set_property enablement_tcl_expr {$TKEEP_EN == "true"} [ipx::get_user_parameters REMOVE_NULL_BEAT_EN -of_objects [ipx::current_core]]

## Create and save the XGUI file
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]
