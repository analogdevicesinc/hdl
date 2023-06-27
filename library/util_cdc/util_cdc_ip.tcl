###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_cdc

add_files -fileset [get_filesets sources_1] [list \
  "sync_gray.v" \
  "sync_bits.v" \
  "sync_data.v" \
  "sync_event.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite util_cdc

set_property name "util_cdc" [ipx::current_core]
set_property display_name "ADI Clock-Domain-Crossing Utils" [ipx::current_core]
set_property description "ADI Clock-Domain-Crossing Utils" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::save_core [ipx::current_core]
