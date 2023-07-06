###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project cn0579_coraz7s 0 

adi_project_files cn0579_coraz7s [list \
  "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_top.v" \
  "system_constr.xdc" ]

adi_project_run cn0579_coraz7s
