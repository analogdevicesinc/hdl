###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# BUFMRCE_EN - Enable BUFMRCE buffer (ADA4355 variant)
# TDD_EN     - Enable TDD controller for LiDAR timing

set BUFMRCE_EN [get_env_param BUFMRCE_EN 0]
set TDD_EN [get_env_param TDD_EN 0]

if {$BUFMRCE_EN == 1 && $TDD_EN == 1} {
  error "ERROR: TDD_EN=1 is not supported with BUFMRCE_EN=1 (ADA4355 variant)"
}

adi_project ada4355_fmc_zed 0 [list \
  BUFMRCE_EN $BUFMRCE_EN \
  TDD_EN $TDD_EN ]

adi_project_files ada4355_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" ]

if {$BUFMRCE_EN == 1} {
  adi_project_files ada4355_fmc_zed [list \
    "system_constr_bufmrce_en.xdc" \
    "system_top_bufmrce_en.v" ]
} elseif {$TDD_EN == 1} {
  adi_project_files ada4355_fmc_zed [list \
    "system_constr.xdc" \
    "system_top_tdd.v" ]
} else {
  adi_project_files ada4355_fmc_zed [list \
    "system_constr.xdc" \
    "system_top.v" ]
}

adi_project_run ada4355_fmc_zed
