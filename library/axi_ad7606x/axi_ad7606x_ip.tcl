###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_ad7606x

adi_ip_files axi_ad7606x [list \
    "$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
    "$ad_hdl_dir/library/common/ad_datafmt.v" \
    "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
    "$ad_hdl_dir/library/common/up_xfer_status.v" \
    "$ad_hdl_dir/library/common/up_clock_mon.v" \
    "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
    "$ad_hdl_dir/library/common/up_adc_channel.v" \
    "$ad_hdl_dir/library/common/up_adc_common.v" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
    "axi_ad7606x_16b_pif.v" \
    "axi_ad7606x_18b_pif.v" \
    "axi_ad7606x.v" ]

adi_ip_properties axi_ad7606x

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad7606x} [ipx::current_core]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
set reset_intf [ipx::infer_bus_interface adc_reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
set_property value "ACTIVE_HIGH" $reset_polarity

set cc [ipx::current_core]

set_property display_name "AXI AD7606X" $cc
set_property description "AXI AD7606X HDL interface" $cc

## define external_clk port as clock interface
adi_add_bus external_clk slave \
  "xilinx.com:signal:clock_rtl:1.0" \
  "xilinx.com:signal:clock:1.0" \
  [list {"external_clk" "CLK"} ]

adi_set_ports_dependency "external_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.EXTERNAL_CLK')) = 1)" 0

## parameter validation

set_property -dict [list \
  "value_format" "bool" \
  "value" "true" \
  ] \
[ipx::get_hdl_parameters EXTERNAL_CLK -of_objects $cc]

## customize XGUI layout

## remove the automatically generated GUI page

ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## create a new GUI page

ipgui::add_page -name {AXI AD7606X} -component $cc -display_name {AXI AD7606X}
set page0 [ipgui::get_pagespec -name "AXI AD7606X" -component $cc]

ipgui::add_param -name "EXTERNAL_CLK" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "EXTERNAL_CLK" \
  "tooltip" "External clock for the ADC" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXTERNAL_CLK" -component $cc]

ipgui::add_param -name "DEV_CONFIG" -component $cc -parent $page0
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Device Type Selection" \
] [ipgui::get_guiparamspec -name "DEV_CONFIG" -component $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "AD7606B" "0" \
    "AD7606C-16" "1" \
    "AD7606C-18" "2" \
  } \
] [ipx::get_user_parameters DEV_CONFIG -of_objects $cc]

adi_add_auto_fpga_spec_params

## save the modifications

ipx::create_xgui_files  $cc
ipx::save_core $cc
