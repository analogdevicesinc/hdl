###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_vpk180
adi_project_files template_vpk180 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "vpk180_system_constr.xdc" \
  "system_top.v" ]

adi_project_run template_vpk180
