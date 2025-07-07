###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ltc2387

adi_ip_files axi_ltc2387 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "axi_ltc2387_if.v" \
  "axi_ltc2387_channel.v" \
  "axi_ltc2387.v" ]

adi_ip_properties axi_ltc2387

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface dco_p xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface dco_n xilinx.com:signal:clock_rtl:1.0 $cc

ipgui::add_static_text -name {Warning} -component $cc -parent $page0 -text {In one-lane mode, only 18-bit resolution is supported!}

ipx::add_user_parameter ADC_RES $cc
set_property value_resolve_type user [ipx::get_user_parameters ADC_RES -of_objects $cc]
ipgui::add_param -name "ADC_RES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ADC_RES" \
  "layout" "horizontal" \
  "tooltip" "ADC resolution" \
  "widget" "radioGroup" \
] [ipgui::get_guiparamspec -name "ADC_RES" -component $cc]

set_property -dict [list \
  "value" "18" \
  "value_format" "long" \
  "value_validation_type" "list" \
  "value_validation_list" "18 16" \
] [ipx::get_user_parameters ADC_RES -of_objects $cc]

ipx::add_user_parameter TWOLANES $cc
set_property value_resolve_type user [ipx::get_user_parameters TWOLANES -of_objects $cc]
ipgui::add_param -name "TWOLANES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "TWOLANES" \
  "layout" "horizontal" \
  "tooltip" "Two-lane mode (1) or one-lane mode (0)" \
  "widget" "radioGroup" \
] [ipgui::get_guiparamspec -name "TWOLANES" -component $cc]

set_property -dict [list \
  "value" "1" \
  "value_format" "long" \
  "value_validation_type" "list" \
  "value_validation_list" "1 0" \
] [ipx::get_user_parameters TWOLANES -of_objects $cc]

ipx::create_xgui_files $cc
ipx::update_checksums $cc
ipx::save_core $cc
