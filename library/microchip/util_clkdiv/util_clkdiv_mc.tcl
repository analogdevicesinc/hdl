###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the Microchip util_clkdiv HDL source for later HDL+ core packaging.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir util_clkdiv.v]

import_files \
  -library work \
  -hdl_source $src_file
build_design_hierarchy
