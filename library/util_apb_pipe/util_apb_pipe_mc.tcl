###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the util_apb_pipe HDL sources for later HDL+ core packaging.
# Sourced within an open Libero project before the helper creates the wrapper.

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir util_apb_pipe.v]

import_files \
	-library work \
	-hdl_source $src_file \
	-hdl_source [file join $script_dir util_apb_pipe_stage.v]
build_design_hierarchy
