###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_adaq8092

adi_ip_files axi_adaq8092 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_adaq8092_if.v" \
  "axi_adaq8092_channel.v" \
  "axi_adaq8092_apb_decode.v"\
  "axi_adaq8092_rand_decode.v"\
  "axi_adaq8092.v" ]

adi_ip_properties axi_adaq8092

adi_init_bd_tcl
adi_ip_bd axi_adaq8092 "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/adaq8092} [ipx::current_core]

set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *adc* -of_objects [ipx::current_core]]

set_property -dict [list \
  value_validation_type pairs \
  value_validation_pairs {LVDS 0 CMOS 1 } \
] [ipx::get_user_parameters OUTPUT_MODE -of_objects [ipx::current_core]]

set_property enablement_dependency { $OUTPUT_MODE == 0 } \
  [ipx::get_ports *lvds* -of_objects [ipx::current_core]]
set_property enablement_dependency { $OUTPUT_MODE == 1 } \
  [ipx::get_ports *cmos* -of_objects [ipx::current_core]]

set_property enablement_tcl_expr {$OUTPUT_MODE == 0} \
  [ipx::get_user_parameters POLARITY_MASK -of_objects [ipx::current_core]]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_clk_in_p xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_clk_in_n xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
set reset_intf [ipx::infer_bus_interface adc_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
set_property value "ACTIVE_HIGH" $reset_polarity

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]
