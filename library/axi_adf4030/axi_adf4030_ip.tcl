###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip

if [info exists ::env(ADI_HDL_DIR)] {
  set ADI_HDL_DIR $::env(ADI_HDL_DIR)
  source $ADI_HDL_DIR/scripts/adi_env.tcl
} else {
  source ../../scripts/adi_env.tcl
}

source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_adf4030
adi_ip_files axi_adf4030 [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "bsync_generator.sv" \
  "trigger_channel.sv" \
  "axi_adf4030_regmap.sv" \
  "axi_adf4030.sv" ]

adi_ip_properties axi_adf4030
adi_ip_ttcl axi_adf4030 "axi_adf4030_constr.ttcl"
set_property display_name "ADI AXI ADF4030" [ipx::current_core]
set_property description "ADI AXI ADF4030" [ipx::current_core]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface device_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset rstn ACTIVE_LOW
add_reset s_axi_aresetn ACTIVE_LOW

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "1" \
        "value_validation_range_maximum" "8" \
        ] \
        [ipx::get_user_parameters CHANNEL_COUNT -of_objects [ipx::current_core]]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

