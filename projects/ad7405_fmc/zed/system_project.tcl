###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
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

adi_project ad7405_fmc_zed 0 [list \
  LVDS_CMOS_N [get_env_param LVDS_CMOS_N  0]
]

adi_project_files ad7405_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch [get_env_param LVDS_CMOS_N 0] {
  0 {
    adi_project_files ad7405_fmc_zed [list \
      "system_top_cmos.v" \
      "system_constr_cmos.xdc"]
  }

  1 {
    adi_project_files ad7405_fmc_zed [list \
      "system_top_lvds.v" \
      "system_constr_lvds.xdc"]
  }
  default {
    return -code error [format "ERROR: Invalid data line type! Define as \'1\' (single ended) or \'0\' (differential) ..."]
  }
}
adi_project_run ad7405_fmc_zed
