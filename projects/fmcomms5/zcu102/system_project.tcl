###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
set ADI_POST_ROUTE_SCRIPT [file normalize $ad_hdl_dir/scripts/auto_timing_fix.tcl]
set BOARD_NAME zcu102

adi_project fmcomms5_${BOARD_NAME}
adi_project_files fmcomms5_${BOARD_NAME} [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/${BOARD_NAME}/${BOARD_NAME}_system_constr.xdc" ]

adi_project_run fmcomms5_${BOARD_NAME}
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

