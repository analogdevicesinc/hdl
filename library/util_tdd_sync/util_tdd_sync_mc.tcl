###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the util_tdd_sync HDL sources for later HDL+ core packaging.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir util_tdd_sync.v]

import_files \
  -library work \
  -hdl_source $src_file \
  -hdl_source [file join $ad_hdl_dir library common util_pulse_gen.v]
build_design_hierarchy
