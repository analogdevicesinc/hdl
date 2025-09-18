###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project admx6001_ebz_vcu118

adi_project_files admx6001_ebz_vcu118 [list \
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

set_property PROCESSING_ORDER LATE [get_files system_constr.xdc]

## To improve timing in DDR4 MIG
set_property strategy Performance_SpreadSLLs [get_runs impl_1]

adi_project_run admx6001_ebz_vcu118
