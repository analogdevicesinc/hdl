###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

global ad_hdl_dir

set src_file [file join $ad_hdl_dir library common ad_rst.v]

import_files \
  -library work \
  -hdl_source $src_file
build_design_hierarchy
