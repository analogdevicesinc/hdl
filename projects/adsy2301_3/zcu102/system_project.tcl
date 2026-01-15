###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project adsy2301_3_zcu102

adi_project_files adsy2301_3_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/adsy2301_3/zcu102/system_constr.xdc"]

adi_project_run adsy2301_3_zcu102
