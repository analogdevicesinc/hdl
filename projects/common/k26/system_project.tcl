###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_k26
adi_project_files template_k26 [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/k26/k26_system_constr.xdc" \
]

adi_project_run template_k26
