###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface dco_p xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface dco_n xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

ipgui::add_param -name "ADC_RES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ADC resolution" \
  "tooltip" "ADC resolution" \
] [ipgui::get_guiparamspec -name "ADC_RES" -component $cc]

set_property -dict [list \
	"value_validation_type" "list" \
	"value_validation_list" "16 18" \
 ] \
[ipx::get_user_parameters ADC_RES -of_objects $cc]

ipgui::add_param -name "OUT_RES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Output data width" \
  "tooltip" "Memory interface" \
] [ipgui::get_guiparamspec -name "OUT_RES" -component $cc]

set_property -dict [list \
	"value_validation_type" "list" \
	"value_validation_list" "16 32" \
 ] \
[ipx::get_user_parameters OUT_RES -of_objects $cc]

ipx::save_core [ipx::current_core]
