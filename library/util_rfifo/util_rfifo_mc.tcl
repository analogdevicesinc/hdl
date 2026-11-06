###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the util_rfifo HDL sources for later HDL+ core packaging.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir util_rfifo.v]

import_files \
  -library work \
  -hdl_source $src_file \
  -hdl_source [file join $ad_hdl_dir library common ad_mem.v]
build_design_hierarchy
