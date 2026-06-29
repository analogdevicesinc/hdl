###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_microzed
adi_project_files template_microzed [list \
  "$ad_hdl_dir/projects/common/microzed/microzed_system_constr.xdc" \
  "system_top.v" ]

adi_project_run template_microzed
