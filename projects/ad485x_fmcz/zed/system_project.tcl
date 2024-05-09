##############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# if the interface is not build defined, set CMOS as default inferface
# make LVDS_CMOS_N=1 for LVDS interface
set LVDS_CMOS_N 0
if [info exists ::env(LVDS_CMOS_N)] {
  set LVDS_CMOS_N $::env(LVDS_CMOS_N)
} else {
  set env(LVDS_CMOS_N) $LVDS_CMOS_N
}

set DEVICE "AD4858"
if [info exists ::env(DEVICE)] {
  set DEVICE $::env(DEVICE)
} else {
  set env(DEVICE) $DEVICE
}

adi_project ad485x_fmcz_zed 0 [list \
  LVDS_CMOS_N     $LVDS_CMOS_N \
  DEVICE          $DEVICE \
]

if {$LVDS_CMOS_N == "0"} {
  source ../common/config.tcl
  if {$numb_of_lanes == "4"} {
    adi_project_files {} [list \
      "system_top_cmos_quad.v" \
      "system_constr_cmos_quad.xdc" \
    ]
  } else {
    adi_project_files {} [list \
      "system_top_cmos_octa.v" \
      "system_constr_cmos_octa.xdc" \
    ]
  }
} else {
  adi_project_files {} [list \
    "system_top_lvds.v" \
    "system_constr_lvds.xdc" \
  ]
}

adi_project_files {} [list \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
]

adi_project_run ad485x_fmcz_zed
