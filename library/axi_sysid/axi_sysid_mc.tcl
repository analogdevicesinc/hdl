###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the axi_sysid HDL sources for later HDL+ core packaging.
# Sourced within an open Libero project before the helper creates the wrapper.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir axi_sysid.v]

import_files \
	-library work \
	-hdl_source $src_file \
	-hdl_source [file join $ad_hdl_dir library common up_apb.v] \
	-hdl_source [file join $ad_hdl_dir library common up_axi.v]
build_design_hierarchy
