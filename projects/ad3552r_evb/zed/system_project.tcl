###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad3552r_evb_zed
adi_project_files ad3552r_evb_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run ad3552r_evb_zed
