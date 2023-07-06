###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_tdd
adi_ip_files axi_tdd [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "$ad_hdl_dir/library/util_cdc/sync_event.v" \
  "axi_tdd_pkg.sv" \
  "axi_tdd_channel.sv" \
  "axi_tdd_counter.sv" \
  "axi_tdd_regmap.sv" \
  "axi_tdd_sync_gen.sv" \
  "axi_tdd.sv" ]

adi_ip_properties axi_tdd
adi_ip_ttcl axi_tdd "axi_tdd_constr.ttcl"
set_property display_name "ADI AXI TDD Controller" [ipx::current_core]
set_property description "ADI AXI TDD Controller" [ipx::current_core]
set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_tdd} [ipx::current_core]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset rst ACTIVE_HIGH
add_reset s_axi_aresetn ACTIVE_LOW

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "1" \
        "value_validation_range_maximum" "32" \
        ] \
        [ipx::get_user_parameters CHANNEL_COUNT -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "8" \
        "value_validation_range_maximum" "32" \
        ] \
        [ipx::get_user_parameters REGISTER_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "8" \
        "value_validation_range_maximum" "32" \
        ] \
        [ipx::get_user_parameters BURST_COUNT_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "64" \
        ] \
        [ipx::get_user_parameters SYNC_COUNT_WIDTH -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "1" \
        ] \
        [ipx::get_user_parameters SYNC_INTERNAL -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "1" \
        ] \
        [ipx::get_user_parameters SYNC_EXTERNAL -of_objects [ipx::current_core]]

set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "1" \
        ] \
        [ipx::get_user_parameters SYNC_EXTERNAL_CDC -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

