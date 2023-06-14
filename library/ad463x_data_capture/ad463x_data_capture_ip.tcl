###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create ad463x_data_capture
adi_ip_files ad463x_data_capture [list \
	"ad463x_data_capture.v" \
]

adi_ip_properties_lite ad463x_data_capture
# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

# Interface definitions

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"m_axis_ready" "TREADY"} \
	      {"m_axis_valid" "TVALID"} \
	      {"m_axis_data" "TDATA"}]

adi_add_bus_clock "clk" "m_axis"

ipx::save_core [ipx::current_core]

