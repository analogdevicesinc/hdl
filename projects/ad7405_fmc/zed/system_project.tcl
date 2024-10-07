###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7405/ADuM7701 operation and interface mode
#
#    LVDS_CMOS_N - Defines the type of the data line:
#    single ended (ADuM7701, AD7403) or differential (AD7405)
#
# LEGEND: single ended - 0
#         differential - 1
##--------------------------------------------------------------
set LVDS_CMOS_N 0
if [info exists ::env(LVDS_CMOS_N)] {
  set LVDS_CMOS_N $::env(LVDS_CMOS_N)
} else {
  set env(LVDS_CMOS_N) $LVDS_CMOS_N
}

adi_project ad7405_fmc_zed 0 [list \
  LVDS_CMOS_N $LVDS_CMOS_N \
]

adi_project_files ad7405_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $LVDS_CMOS_N {
  0 {
    adi_project_files ad7405_fmc_zed [list \
      "system_top_lvds.v" \
      "system_constr_lvds.xdc"]
  }

  1 {
    adi_project_files ad7405_fmc_zed [list \
      "system_top_cmos.v" \
      "system_constr_cmos.xdc"]
  }
  default {
    return -code error [format "ERROR: Invalid data line type! Define as \'1\' (single ended) or \'0\' (differential) ..."]
  }
}
adi_project_run ad7405_fmc_zed
