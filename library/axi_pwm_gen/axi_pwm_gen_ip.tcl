###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_pwm_gen
adi_ip_files axi_pwm_gen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_pwm_gen_constr.ttcl" \
  "axi_pwm_gen_regmap.sv" \
  "axi_pwm_gen_1.v" \
  "axi_pwm_gen.sv"]

adi_ip_properties axi_pwm_gen
adi_ip_ttcl axi_pwm_gen "axi_pwm_gen_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_pwm_gen} [ipx::current_core]

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

set_property display_name "ADI AXI PWM Generator" $cc
set_property description  "ADI AXI PWM Generator" $cc

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

## Customize XGUI layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page

ipgui::add_page -name {AXI PWM Generator} -component $cc -display_name {AXI PWM Generator}
set page0 [ipgui::get_pagespec -name "AXI PWM Generator" -component $cc]

ipgui::add_param -name "ASYNC_CLK_EN" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ASYNC_CLK_EN" \
  "tooltip" "External clock for the counter" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "ASYNC_CLK_EN" -component $cc]

ipgui::add_param -name "EXT_ASYNC_SYNC" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External sync signal is asynchronous" \
  "tooltip" "NOTE: If active the ext_sync will be delayed 2 clock cycles." \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXT_ASYNC_SYNC" -component $cc]

ipgui::add_param -name "N_PWMS" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Number of pwms" \
] [ipgui::get_guiparamspec -name "N_PWMS" -component $cc]

ipgui::add_param -name "PWM_EXT_SYNC" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External sync" \
  "tooltip" "NOTE: If active the whole pwm gen module will be waiting for the ext_sync to be set low. A load config or reset must be used before deaserting the ext_sync" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "PWM_EXT_SYNC" -component $cc]

ipgui::add_param -name "EXT_ASYNC_SYNC" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External sync signal is asynchronous" \
  "tooltip" "NOTE: If active the ext_sync will be delayed 2 clock cycles." \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXT_ASYNC_SYNC" -component $cc]

ipgui::add_param -name "EXT_SYNC_NO_LOAD_CONFIG" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External synchronization without load_config" \
  "tooltip" "NOTE: If active the external synchronization would be made without load_config." \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXT_SYNC_NO_LOAD_CONFIG" -component $cc]

ipgui::add_param -name "EXT_SYNC_FASTER_CLK" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External sync based on a faster clock" \
  "tooltip" "NOTE: If active the external sync would be based on a faster clock than the pwm_gen logic." \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXT_SYNC_FASTER_CLK" -component $cc]

# Maximum 16 pwms
for {set i 0} {$i < 16} {incr i} {
  ipgui::add_param -name "PULSE_${i}_WIDTH" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "PULSE $i width" \
    "tooltip" "PULSE width of the generated signal. The unit interval is the system or external clock period." \
  ] [ipgui::get_guiparamspec -name "PULSE_${i}_WIDTH" -component $cc]

  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "2147483647" \
   ] \
  [ipx::get_user_parameters PULSE_${i}_WIDTH -of_objects $cc]

  ipgui::add_param -name "PULSE_${i}_PERIOD" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "PULSE ${i} period" \
    "tooltip" "Period of the generated signal. The unit interval is the system or external clock period." \
  ] [ipgui::get_guiparamspec -name "PULSE_${i}_PERIOD" -component $cc]

  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "2147483647" \
   ] \
  [ipx::get_user_parameters PULSE_${i}_PERIOD -of_objects $cc]

  ipgui::add_param -name "PULSE_${i}_OFFSET" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "PULSE ${i} offset" \
    "tooltip" "Offset of the generated signal referenced to PULSE 1. The unit interval is the system or external clock period." \
  ] [ipgui::get_guiparamspec -name "PULSE_${i}_OFFSET" -component $cc]

  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "2147483647" \
   ] \
  [ipx::get_user_parameters PULSE_${i}_OFFSET -of_objects $cc]
}

for {set i 0} {$i < 16} {incr i} {
	adi_set_ports_dependency "pwm_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.N_PWMS')) > $i)"
}

adi_set_ports_dependency "ext_sync" \
	"(spirit:decode(id('MODELPARAM_VALUE.PWM_EXT_SYNC')) == 1)"

adi_set_ports_dependency "ext_sync_faster_clk" \
	"(spirit:decode(id('MODELPARAM_VALUE.EXT_SYNC_FASTER_CLK')) == 1)"

adi_set_ports_dependency "clk_ext_sync" \
	"(spirit:decode(id('MODELPARAM_VALUE.EXT_SYNC_FASTER_CLK')) == 1)"

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects $cc]

## Save the modifications

ipx::create_xgui_files $cc
ipx::save_core $cc