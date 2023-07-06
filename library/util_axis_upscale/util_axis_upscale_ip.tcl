###############################################################################
## Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_axis_upscale
adi_ip_files util_axis_upscale [list \
	"$ad_hdl_dir/library/common/util_axis_upscale.v"]

adi_ip_properties_lite util_axis_upscale

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_valid" "TVALID"} \
		{"s_axis_ready" "TREADY"} \
		{"s_axis_data" "TDATA"} \
	}
adi_add_bus_clock "clk" "s_axis" "resetn"

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data" "TDATA"} \
	}
ipx::associate_bus_interfaces -busif m_axis -clock s_axis_signal_clock [ipx::current_core]

ipx::save_core [ipx::current_core]

