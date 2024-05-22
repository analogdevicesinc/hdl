###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project missouri_zed

adi_project_files missouri_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_top.v" \
  "system_constr.xdc" \
]

adi_project_run missouri_zed
