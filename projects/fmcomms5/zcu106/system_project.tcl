###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcomms5_zcu106
adi_project_files fmcomms5_zcu106 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu106/zcu106_system_constr.xdc" ]

adi_project_run fmcomms5_zcu106
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

