###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the util_upack2 HDL sources for later HDL+ core packaging.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir util_upack2_mc.v]

import_files \
  -library work \
  -hdl_source $src_file \
  -hdl_source [file join $script_dir util_upack2.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_perfect_shuffle.v] \
  -hdl_source [file join $ad_hdl_dir library common util_pipeline_stage.v] \
  -hdl_source [file join $ad_hdl_dir library util_pack util_pack_common pack_ctrl.v] \
  -hdl_source [file join $ad_hdl_dir library util_pack util_pack_common pack_interconnect.v] \
  -hdl_source [file join $ad_hdl_dir library util_pack util_pack_common pack_network.v] \
  -hdl_source [file join $ad_hdl_dir library util_pack util_pack_common pack_shell.v] \
  -hdl_source [file join $script_dir util_upack2_impl.v]
build_design_hierarchy
