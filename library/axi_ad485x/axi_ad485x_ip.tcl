###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip

source ../../scripts/adi_env.tcl

source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_ad485x

adi_ip_files axi_ad485x [list \
    "$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/common/ad_datafmt.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/common/up_adc_common.v" \
    "$ad_hdl_dir/library/common/up_adc_channel.v" \
    "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
    "$ad_hdl_dir/library/common/up_xfer_status.v" \
    "$ad_hdl_dir/library/common/up_clock_mon.v" \
    "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_serdes_out.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "axi_ad485x_constr.ttcl" \
    "axi_ad485x_cmos.v" \
    "axi_ad485x_16b_channel.v" \
    "axi_ad485x_20b_channel.v" \
    "axi_ad485x_crc.v" \
    "axi_ad485x_lvds.v" \
    "axi_ad485x.v" ]

adi_ip_properties axi_ad485x

# Register the ttcl constraint template to be generated as XDC
adi_ip_ttcl axi_ad485x "axi_ad485x_constr.ttcl"

set cc [ipx::current_core]

## Customize XGUI layout

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

adi_init_bd_tcl
adi_ip_bd axi_ad485x "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad485x} $cc

ipgui::add_param -name "EXTERNAL_CLK" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "EXTERNAL_CLK_EN" \
  "tooltip" "External clock for interface logic, must be 2x faster than IF clk" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXTERNAL_CLK" -component $cc]

ipgui::add_param -name "ECHO_CLK_EN" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Echoed clock enabled" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "ECHO_CLK_EN" -component $cc]

ipgui::add_param -name "LVDS_CMOS_N" -component $cc -parent $page0
set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"CMOS" "0" \
		"LVDS" "1" \
	} \
] [ipx::get_user_parameters "LVDS_CMOS_N" -of_objects $cc]

set_property -dict [list \
	"display_name" "Interface type" \
	"widget" "comboBox" \
] [ipx::get_user_parameters "LVDS_CMOS_N" -of_objects $cc]

for {set i 0} {$i < 8} {incr i} {
  ipgui::add_param -name "LANE_${i}_ENABLE" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "LANE_${i}_ENABLE" \
    "tooltip" "Lane $i is used" \
    "widget" "checkBox" \
  ] [ipgui::get_guiparamspec -name "LANE_${i}_ENABLE" -component $cc]

  set_property value_format bool [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects $cc]
  set_property value_format bool [ipx::get_hdl_parameters LANE_${i}_ENABLE -of_objects $cc]
  set_property value true [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects $cc]
  set_property value true [ipx::get_hdl_parameters LANE_${i}_ENABLE -of_objects $cc]

  if { $i >= 4 } {
    set_property enablement_tcl_expr {expr {$LVDS_CMOS_N == 1 ? 0 : \
                                                  $DEVICE == {AD4854} ? 0 : \
                                                  $DEVICE == {AD4853} ? 0 : \
                                                  $DEVICE == {AD4852} ? 0 : \
                                                  $DEVICE == {AD4851} ? 0 : 1}
    } [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects $cc]
  } else {
    set_property enablement_tcl_expr {expr $LVDS_CMOS_N == 0
    } [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects $cc]
  }

  if { $i >= 4 } {
    adi_set_ports_dependency "lane_$i" \
      "((spirit:decode(id('MODELPARAM_VALUE.LANE_${i}_ENABLE')) == 1) and \
        (spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0)) and  \
       ((spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4858') or \
        (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4857') or \
        (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4856') or \
        (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4855'))"
  } else {
  adi_set_ports_dependency "lane_$i" \
    "(spirit:decode(id('MODELPARAM_VALUE.LANE_${i}_ENABLE')) == 1) and \
     (spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0)"
  }
  set_property DRIVER_VALUE "0" [ipx::get_ports lane_$i]

  set_property size_left_dependency {$DW} [ipx::get_ports adc_data_$i -of_objects $cc]
  if { $i >= 4 } {
    adi_set_ports_dependency "adc_enable_$i" \
      "(spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4858') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4857') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4856') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4855')"
    adi_set_ports_dependency "adc_data_$i" \
      "(spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4858') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4857') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4856') or \
       (spirit:decode(id('MODELPARAM_VALUE.DEVICE')) == 'AD4855')"
  }
}

ipgui::add_param -name "DEVICE" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Device" \
] [ipgui::get_guiparamspec -name "DEVICE" -component $cc]

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" { \
    "AD4858" \
    "AD4857" \
    "AD4856" \
    "AD4855" \
    "AD4854" \
    "AD4853" \
    "AD4852" \
    "AD4851" \
  } \
] \
[ipx::get_user_parameters DEVICE -of_objects $cc]

set_property value AD4858 [ipx::get_user_parameters DEVICE -of_objects $cc]
set_property value AD4858 [ipx::get_hdl_parameters DEVICE -of_objects $cc]
ipx::update_dependency [ipx::get_user_parameters DEVICE -of_objects $cc]


set_property display_name {Data width} [ipgui::get_guiparamspec -name "DW" -component [ipx::current_core] ]
set_property widget {textEdit} [ipgui::get_guiparamspec -name "DW" -component [ipx::current_core] ]

set_property value_tcl_expr {expr {[info exists DEVICE] ? \
                                                $DEVICE eq {AD4858} ? 31 : \
                                                $DEVICE eq {AD4857} ? 15 : \
                                                $DEVICE eq {AD4856} ? 31 : \
                                                $DEVICE eq {AD4855} ? 15 : \
                                                $DEVICE eq {AD4854} ? 31 : \
                                                $DEVICE eq {AD4853} ? 15 : \
                                                $DEVICE eq {AD4852} ? 31 : \
                                                $DEVICE eq {AD4851} ? 15 : 31 : 31}
} [ipx::get_user_parameters DW -of_objects $cc]
set_property enablement_value false [ipx::get_user_parameters DW -of_objects $cc]

# CMOS dependency
adi_set_ports_dependency "scki" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0)"
adi_set_ports_dependency "scko" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"

# LVDS dependency
adi_set_ports_dependency "scki_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"
adi_set_ports_dependency "scki_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"

adi_set_ports_dependency "scko_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"
adi_set_ports_dependency "scko_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"

adi_set_ports_dependency "sdo_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"
adi_set_ports_dependency "sdo_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"

adi_set_ports_dependency "external_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.EXTERNAL_CLK')) = 1)" 0

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects $cc]

adi_add_auto_fpga_spec_params

## Save the modifications

ipx::create_xgui_files $cc

ipx::save_core $cc
