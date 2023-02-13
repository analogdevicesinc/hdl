###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# if the interface is not build defined, set CMOS as default inferface
# make LVDS_CMOS_N=1 for LVDS interface
set LVDS_CMOS_N  0
if [info exists ::env(LVDS_CMOS_N)] {
  set LVDS_CMOS_N $::env(LVDS_CMOS_N)
} else {
  set env(LVDS_CMOS_N) $LVDS_CMOS_N
}

adi_project ad4858_fmcz_zed 0 [list \
  LVDS_CMOS_N     $LVDS_CMOS_N \
]

if {$LVDS_CMOS_N == "0"} {
  adi_project_files {} [list \
    "system_top_cmos.v" \
  ]
} else {
  adi_project_files {} [list \
    "system_top_lvds.v" \
  ]
}

adi_project_files {} [list \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_constr.tcl"]

adi_project_run ad4858_fmcz_zed
