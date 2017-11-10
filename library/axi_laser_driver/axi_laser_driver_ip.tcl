# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_laser_driver
adi_ip_files axi_laser_driver [list \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "axi_laser_driver_constr.xdc" \
  "axi_laser_driver_regmap.v" \
  "axi_laser_driver.v"]

adi_ip_properties axi_laser_driver
adi_ip_ttcl axi_laser_driver "$ad_hdl_dir/library/axi_pulse_gen/axi_pulse_gen_constr.ttcl"

adi_ip_add_core_dependencies { \
	analog.com:user:util_cdc:1.0 \
	analog.com:user:axi_pulse_gen:1.0 \
}

set cc [ipx::current_core]

set_property display_name "ADI AXI Laser Driver" $cc
set_property description  "ADI AXI Laser Driver" $cc

## define ext_clk port as a clock interface
adi_add_bus ext_clk slave \
  "xilinx.com:signal:clock_rtl:1.0" \
  "xilinx.com:signal:clock:1.0" \
  [list {"ext_clk" "CLK"} ]

adi_set_ports_dependency "ext_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.ASYNC_CLK_EN')) = 1)" 0

## Parameter validation

set_property -dict [list \
  "value_format" "bool" \
  "value" "true" \
 ] \
[ipx::get_user_parameters ASYNC_CLK_EN -of_objects $cc]

set_property -dict [list \
  "value_format" "bool" \
  "value" "true" \
 ] \
[ipx::get_hdl_parameters ASYNC_CLK_EN -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "2147483647" \
 ] \
[ipx::get_user_parameters PULSE_WIDTH -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "2147483647" \
 ] \
[ipx::get_user_parameters PULSE_PERIOD -of_objects $cc]

## Customize XGUI layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page

ipgui::add_page -name {AXI Pulse Generator} -component $cc -display_name {AXI Pulse Generator}
set page0 [ipgui::get_pagespec -name "AXI Pulse Generator" -component $cc]

ipgui::add_param -name "ASYNC_CLK_EN" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ASYNC_CLK_EN" \
  "tooltip" "External clock for the counter" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "ASYNC_CLK_EN" -component $cc]

ipgui::add_param -name "PULSE_WIDTH" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Pulse width" \
  "tooltip" "Pulse width of the generated signal. The unit interval is the system or external clock period." \
] [ipgui::get_guiparamspec -name "PULSE_WIDTH" -component $cc]

ipgui::add_param -name "PULSE_PERIOD" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Pulse period" \
  "tooltip" "Period of the generated signal. The unit interval is the system or external clock period." \
] [ipgui::get_guiparamspec -name "PULSE_PERIOD" -component $cc]

## Save the modifications

ipx::create_xgui_files $cc
ipx::save_core $cc
