###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create sync_gray
adi_ip_files sync_gray [list \
	"../sync_bits.v" \
	"../sync_gray.v" \
]

adi_ip_properties_lite sync_gray

set_property name "sync_gray" [ipx::current_core]
set_property display_name "ADI Synchronize Gray Code" [ipx::current_core]
set_property description "ADI Clock-Domain-Crossing Utils" [ipx::current_core]

ipx::save_core [ipx::current_core]
