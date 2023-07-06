###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_pulse_gen
adi_ip_files util_pulse_gen [list \
	"$ad_hdl_dir/library/common/util_pulse_gen.v"]

adi_ip_properties_lite util_pulse_gen
ipx::remove_all_bus_interface [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface rstn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

