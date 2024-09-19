###############################################################################
## Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_vhk158
adi_project_files template_vhk158 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vhk158/vhk158_system_constr.xdc" \
  "system_top.v" ]

adi_project_run template_vhk158
