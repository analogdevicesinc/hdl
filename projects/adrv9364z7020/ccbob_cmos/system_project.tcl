###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create adrv9364z7020_ccbob_cmos 0 {} "xc7z020clg400-1"
adi_project_files adrv9364z7020_ccbob_cmos [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "../common/adrv9364z7020_constr.xdc" \
  "../common/adrv9364z7020_constr_cmos.xdc" \
  "../common/ccbob_constr.xdc" \
  "system_top.v" ]

adi_project_run adrv9364z7020_ccbob_cmos
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

