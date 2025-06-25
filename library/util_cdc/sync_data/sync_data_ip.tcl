###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create sync_data
adi_ip_files sync_data [list \
	"../sync_bits.v" \
	"../sync_data.v" \
]

adi_ip_properties_lite sync_data

set_property name "sync_data" [ipx::current_core]
set_property display_name "ADI Synchronize Data" [ipx::current_core]
set_property description "ADI Clock-Domain-Crossing Utils" [ipx::current_core]

ipx::save_core [ipx::current_core]
