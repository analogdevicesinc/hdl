###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
source $ad_hdl_dir/library/axi_tdd/scripts/axi_tdd.tcl

adi_project_create sharkbyte 0 {} "xc7z010clg225-2"

adi_project_files sharkbyte [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

set_property is_enabled false [get_files  *system_sys_ps7_0.xdc]
adi_project_run sharkbyte
