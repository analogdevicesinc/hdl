###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_reg
adi_ip_files util_reg [list \
	"$ad_hdl_dir/library/common/util_reg.v" \
]

adi_ip_properties_lite util_reg

set cc [ipx::current_core]

set_property display_name "ADI Util REG" $cc
set_property description  "Universal Register" $cc
#set_property company_url {https://analogdevicesinc.github.io/hdl/library/util_axis_fifo/index.html} $cc

adi_set_ports_dependency "clk" \
	"(spirit:decode(id('MODELPARAM_VALUE.IS_FF')) = 1) "
adi_set_ports_dependency "gate" \
	"(spirit:decode(id('MODELPARAM_VALUE.IS_FF')) = 0) && \
   (spirit:decode(id('MODELPARAM_VALUE.ACTIVE_GATE')) = 1)"
adi_set_ports_dependency "gaten" \
	"(spirit:decode(id('MODELPARAM_VALUE.IS_FF')) = 0) && \
   (spirit:decode(id('MODELPARAM_VALUE.ACTIVE_GATE')) = 0)"
adi_set_ports_dependency "reset" \
	"(spirit:decode(id('MODELPARAM_VALUE.ACTIVE_RESET')) = 1)"
adi_set_ports_dependency "resetn" \
	"(spirit:decode(id('MODELPARAM_VALUE.ACTIVE_RESET')) = 0)"

#clk and reset

ipx::add_bus_interface clk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:clock:1.0 [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
ipx::add_port_map CLK [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
set_property physical_name clk [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]]

ipx::add_bus_interface reset [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:reset:1.0 [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]
ipx::add_port_map RST [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]
set_property physical_name reset [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]]
ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]
set_property value ACTIVE_HIGH [ipx::get_bus_parameters POLARITY -of_objects [ipx::get_bus_interfaces reset -of_objects [ipx::current_core]]]


ipx::add_bus_interface resetn [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:reset:1.0 [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]
ipx::add_port_map RST [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]
set_property physical_name resetn [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]]
ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]
set_property value ACTIVE_LOW [ipx::get_bus_parameters POLARITY -of_objects [ipx::get_bus_interfaces resetn -of_objects [ipx::current_core]]]


ipx::associate_bus_interfaces -clock clk -reset reset [ipx::current_core]
ipx::associate_bus_interfaces -clock clk -reset resetn [ipx::current_core]




## Parameter validation

set_property -dict [list \
  "enablement_tcl_expr" "\$IS_FF== 0" \
] \
[ipx::get_user_parameters ACTIVE_GATE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$IS_FF== 1" \
] \
[ipx::get_user_parameters CLK_EDGE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$IS_FF== 1" \
] \
[ipx::get_user_parameters RESET_ASYNC -of_objects $cc]


set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Latch"  "0" \
		"Flip-Flop" "1" \
	} \
] [ipx::get_user_parameters IS_FF -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
] [ipx::get_user_parameters NUM_OF_BITS -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Falling"  "0" \
		"Riseing" "1" \
	} \
] [ipx::get_user_parameters CLK_EDGE -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Low"  "0" \
		"High" "1" \
	} \
] [ipx::get_user_parameters ACTIVE_RESET -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Low"  "0" \
		"High" "1" \
	} \
] [ipx::get_user_parameters ACTIVE_GATE -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Synchronous"  "0" \
		"Asynchronous" "1" \
	} \
] [ipx::get_user_parameters RESET_ASYNC -of_objects $cc]

## Default driver value for ports

set_property driver_value 1 [ipx::get_ports reset -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports resetn -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports gate -of_objects [ipx::current_core]]
set_property driver_value 1 [ipx::get_ports gaten -of_objects [ipx::current_core]]



# set_property -dict [list \
# 	"value_validation_type" "range_long" \
# 	"value_validation_range_minimum" "0" \
# ] [ipx::get_user_parameters INIT -of_objects $cc]


# set_property -dict [list \
# 	"value_validation_type" "range_long" \
# 	"value_validation_range_minimum" "0" \
# ] [ipx::get_user_parameters RESET_VALUE -of_objects $cc]


## Customize IP layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page
ipgui::add_page -name {ADI Util REG} -component $cc -display_name {ADI Util REG}
set page0 [ipgui::get_pagespec -name "ADI Util REG" -component $cc]

set all_group [ipgui::add_group -name "Configurations" -component $cc \
	-parent $page0 -display_name "Configurations" ]

ipgui::add_param -name "IS_FF" -component $cc -parent $all_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Register Type" \
	"tooltip" "\[IS_FF\] Selects whether the register is implemented as a flip-flop or a latch. Flip-flops are edge-triggered (synchronous); latches are level-sensitive (transparent)."
] [ipgui::get_guiparamspec -name "IS_FF" -component $cc]

ipgui::add_param -name "NUM_OF_BITS" -component $cc -parent $all_group
set_property -dict [list \
	"display_name" "Number of Bits" \
	"tooltip" "\[NUM_OF_BITS \] Specifies the number of bits used to represent the data value." \
] [ipgui::get_guiparamspec -name "NUM_OF_BITS" -component $cc]

ipgui::add_param -name "CLK_EDGE" -component $cc -parent $all_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Clock Edge" \
	"tooltip" "\[CLK_EDGE\]Selects which clock edge triggers the register. Rising edge triggers on the low-to-high transition; falling edge triggers on the high-to-low transition."
] [ipgui::get_guiparamspec -name "CLK_EDGE" -component $cc]

ipgui::add_param -name "ACTIVE_RESET" -component $cc -parent $all_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Reset Polarit" \
	"tooltip" "\[ACTIVE_RESET\]Selects the active polarity of the reset signal. Active-high reset asserts when the reset signal is high; active-low reset asserts when the reset signal is low."
] [ipgui::get_guiparamspec -name "ACTIVE_RESET" -component $cc]

ipgui::add_param -name "ACTIVE_GATE" -component $cc -parent $all_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Gate Polarity" \
	"tooltip" "\[ACTIVE_GATE\]Selects the active polarity of the latch gate. Active-high gate makes the latch transparent when the gate is high; active-low gate makes the latch transparent when the gate is low."
] [ipgui::get_guiparamspec -name "ACTIVE_GATE" -component $cc]

ipgui::add_param -name "RESET_ASYNC" -component $cc -parent $all_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Reset Type" \
	"tooltip" "\[RESET_ASYNC\]Selects how the reset is applied. Asynchronous reset takes effect immediately, independent of the clock; synchronous reset takes effect on the active clock edge."
] [ipgui::get_guiparamspec -name "RESET_ASYNC" -component $cc]

ipgui::add_param -name "INIT" -component $cc -parent $all_group
set_property -dict [list \
	"display_name" "Initial Value" \
	"tooltip" "\[INIT \] Specifies the initial value of the register. The value must fit within the configured Number of Bits parameter; values exceeding the data width will be truncated." \
] [ipgui::get_guiparamspec -name "INIT" -component $cc]

ipgui::add_param -name "RESET_VALUE" -component $cc -parent $all_group
set_property -dict [list \
	"display_name" "Reset Value" \
	"tooltip" "\[RESET_VALUE \] Specifies the value loaded into the register when reset is asserted. The value must fit within the configured Number of Bits parameter; values exceeding the data width will be truncated." \
] [ipgui::get_guiparamspec -name "RESET_VALUE" -component $cc]


## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc