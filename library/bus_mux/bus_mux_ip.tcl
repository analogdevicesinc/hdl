###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create bus_mux
adi_ip_files bus_mux [list "bus_mux.v" ]

adi_ip_properties_lite bus_mux

adi_init_bd_tcl
adi_ip_bd bus_mux "bd/bd.tcl"

set cc [ipx::current_core]
# ipx::remove_all_bus_interface $cc
set_property display_name "Bus Mux" $cc
set_property description "Simple Bus Multiplexer" $cc
set_property driver_value 0 [ipx::get_ports *data* -of_objects [ipx::current_core]]
ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 $cc

ipx::create_xgui_files $cc
ipx::save_core $cc
