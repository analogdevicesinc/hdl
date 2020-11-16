# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_pulse_gen
adi_ip_files axi_pulse_gen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/common/util_pulse_gen.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "$ad_hdl_dir/library/util_cdc/sync_event.v" \
  "axi_pulse_gen_tb.v" \
  "axi_pulse_gen_constr.ttcl" \
  "axi_pulse_gen_regmap.sv" \
  "axi_pulse_gen.sv"]


adi_ip_properties axi_pulse_gen
adi_ip_ttcl axi_pulse_gen "axi_pulse_gen_constr.ttcl"

adi_ip_add_core_dependencies { \
	analog.com:user:util_cdc:1.0 \
}

set cc [ipx::current_core]

set_property display_name "ADI AXI Pulse Generator" $cc
set_property description  "ADI AXI Pulse Generator" $cc

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

ipgui::add_page -name {AXI Pulse Generator} -component $cc -display_name {AXI Pulse Generator}
set page0 [ipgui::get_pagespec -name "AXI Pulse Generator" -component $cc]

ipgui::add_param -name "ASYNC_CLK_EN" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ASYNC_CLK_EN" \
  "tooltip" "External clock for the counter" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "ASYNC_CLK_EN" -component $cc]

ipgui::add_param -name "INCREMENTAL_COUNTER" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Incremental Counter" \
  "tooltip" "If active the pulse will have the first part of the period (described by width - duty cycle) high level, otherwise the first part will be low level and the last part described by width on high level" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "INCREMENTAL_COUNTER" -component $cc]

ipgui::add_param -name "N_PULSES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Number of pulses" \
] [ipgui::get_guiparamspec -name "N_PULSES" -component $cc]

# Maximum 16 pulses
for {set i 1} {$i <= 16} {incr i} {
  ipgui::add_param -name "PULSE_${i}_WIDTH" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "Pulse $i width" \
    "tooltip" "Pulse width of the generated signal. The unit interval is the system or external clock period." \
  ] [ipgui::get_guiparamspec -name "PULSE_${i}_WIDTH" -component $cc]

  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "2147483647" \
   ] \
  [ipx::get_user_parameters PULSE_${i}_WIDTH -of_objects $cc]

  ipgui::add_param -name "PULSE_${i}_PERIOD" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "Pulse ${i} period" \
    "tooltip" "Period of the generated signal. The unit interval is the system or external clock period." \
  ] [ipgui::get_guiparamspec -name "PULSE_${i}_PERIOD" -component $cc]

  set_property -dict [list \
    "value_validation_type" "range_long" \
    "value_validation_range_minimum" "0" \
    "value_validation_range_maximum" "2147483647" \
   ] \
  [ipx::get_user_parameters PULSE_${i}_PERIOD -of_objects $cc]

  if { $i == 1 } {
    ipgui::add_param -name "PULSE_1_EXT_SYNC" -component $cc -parent $page0
    set_property -dict [list \
      "display_name" "Main pulse(1) sync" \
      "tooltip" "NOTE: If active the whole pulse gen module will be waiting for the external_sync to be set high." \
      "widget" "checkBox" \
    ] [ipgui::get_guiparamspec -name "PULSE_1_EXT_SYNC" -component $cc]
  } else {
    ipgui::add_param -name "PULSE_${i}_OFFSET" -component $cc -parent $page0
    set_property -dict [list \
      "display_name" "Pulse ${i} offset" \
      "tooltip" "Offset of the generated signal referenced to Pulse 1. The unit interval is the system or external clock period." \
    ] [ipgui::get_guiparamspec -name "PULSE_${i}_OFFSET" -component $cc]

    set_property -dict [list \
      "value_validation_type" "range_long" \
      "value_validation_range_minimum" "0" \
      "value_validation_range_maximum" "2147483647" \
     ] \
    [ipx::get_user_parameters PULSE_${i}_OFFSET -of_objects $cc]
  }
}

for {set i 1} {$i < 16} {incr i} {
	adi_set_ports_dependency "pulse_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.N_PULSES')) > $i)"
}

adi_set_ports_dependency "external_sync" \
	"(spirit:decode(id('MODELPARAM_VALUE.PULSE_1_EXT_SYNC')) == 1)"

## Save the modifications

ipx::create_xgui_files $cc
ipx::save_core $cc
