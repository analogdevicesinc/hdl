###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# load script
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad777x_ardz_zed 0 

adi_project_files ad777x_ardz_zed [list \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_top.v" \
  "system_constr.xdc" ]


adi_project_run ad777x_ardz_zed
