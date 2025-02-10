###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create ramp
adi_ip_files ramp [list "ramp.v" ]

adi_ip_properties_lite ramp

adi_init_bd_tcl
adi_ip_bd ramp "bd/bd.tcl"

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"ready" "TREADY"} \
    {"data_valid" "TVALID"} \
    {"data_out" "TDATA"}]

set cc [ipx::current_core]
# ipx::remove_all_bus_interface $cc
set_property display_name "Ramp" $cc
set_property description "Ramp Test" $cc
set_property driver_value 0 [ipx::get_ports *data* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *ready* -of_objects [ipx::current_core]]
ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 $cc

ipx::create_xgui_files $cc
ipx::save_core $cc
