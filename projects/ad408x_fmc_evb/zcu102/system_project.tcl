###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad408x_fmc_evb_zcu102
adi_project_files ad408x_fmc_evb_zcu102 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]
# added "system_constr.xdc" \ & changed template_zcu102 to "ad408x_fmc_evb_zcu102" \# 
adi_project_run ad408x_fmc_evb_zcu102
