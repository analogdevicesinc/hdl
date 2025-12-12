###############################################################################
## Copyright (C) 2014-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
set ADI_POST_ROUTE_SCRIPT [file normalize $ad_hdl_dir/projects/scripts/auto_timing_fix_xilinx.tcl]

adi_project fmcomms2_zcu102
adi_project_files fmcomms2_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

## fmcomms2 design is presenting hold time violations on some paths
## set the strategy to spread logic and help with hold time fixes
set_property strategy Congestion_SpreadLogic_high [get_runs impl_1]

adi_project_run fmcomms2_zcu102
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

