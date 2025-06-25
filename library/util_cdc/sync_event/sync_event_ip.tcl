###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create sync_event
adi_ip_files sync_event [list \
	"../sync_bits.v" \
	"../sync_event.v" \
]

adi_ip_properties_lite sync_event

set_property name "sync_event" [ipx::current_core]
set_property display_name "ADI Synchronize Events" [ipx::current_core]
set_property description "ADI Clock-Domain-Crossing Utils" [ipx::current_core]

ipx::save_core [ipx::current_core]
