###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the sysid_rom HDL sources for later HDL+ core packaging.
# No standard bus interfaces — just a simple ROM read port.

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir sysid_rom.v]

import_files -library work -hdl_source $src_file
build_design_hierarchy
