###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_clkdiv
adi_ip_files util_clkdiv [list \
  "util_clkdiv_constr.xdc" \
  "util_clkdiv_ooc.ttcl" \
  "util_clkdiv.v" ]

adi_ip_properties_lite util_clkdiv

adi_ip_ttcl util_clkdiv "util_clkdiv_ooc.ttcl"

set_property processing_order LATE [ipx::get_files "util_clkdiv_constr.xdc" \
                  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] -filter {NAME =~ *synthesis*}]]

set_property driver_value 0 [ipx::get_ports clk_sel -of_objects [ipx::current_core]]

set_property value_validation_type list [ipx::get_user_parameters SIM_DEVICE -of_objects [ipx::current_core]]
set_property value_validation_list {7SERIES ULTRASCALE} [ipx::get_user_parameters SIM_DEVICE -of_objects [ipx::current_core]]

set_property value_validation_type list [ipx::get_user_parameters SEL_0_DIV -of_objects [ipx::current_core]]
set_property value_validation_list {1 2 3 4 5 6 7 8} [ipx::get_user_parameters SEL_0_DIV -of_objects [ipx::current_core]]

set_property value_validation_type list [ipx::get_user_parameters SEL_1_DIV -of_objects [ipx::current_core]]
set_property value_validation_list {1 2 3 4 5 6 7 8} [ipx::get_user_parameters SEL_1_DIV -of_objects [ipx::current_core]]

adi_add_bus clk_out master "xilinx.com:signal:clock_rtl:1.0" "xilinx.com:signal:clock:1.0" \
  [list {"clk_out" "CLK"}]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]
