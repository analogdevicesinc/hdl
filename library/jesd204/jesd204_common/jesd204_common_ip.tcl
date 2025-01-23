###############################################################################
## Copyright (C) 2017-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_common

add_files -fileset [get_filesets sources_1] [list \
  "jesd204_lmfc.v" \
  "jesd204_scrambler.v" \
  "jesd204_scrambler_64b.v" \
  "jesd204_crc12.v" \
  "jesd204_eof_generator.v" \
  "jesd204_frame_mark.v" \
  "jesd204_frame_align_replace.v" \
  "../../common/util_pipeline_stage.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite jesd204_common

set_property display_name "ADI JESD204C Common Library" [ipx::current_core]
set_property description "ADI JESD204C Common Library" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
