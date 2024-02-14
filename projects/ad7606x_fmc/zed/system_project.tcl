###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# DEV_CONFIG - The device which will be used
#  - Options : AD7606B(0)/C-16(1)/C-18(2)
# INTF - Operation interface
#  - Options : Parallel(0)/Serial(1)
# NUM_OF_SDI - Number of SDI lines used
#  - Options: 1, 2, 4, 8
# EXT_CLK - Use external clock as ADC clock
#  - Options : No(0), Yes(1)

set DEV_CONFIG [get_env_param DEV_CONFIG 0]

# This type of check is useful when build without the INTF or NUM_OF_SDI parameters, that affect the constraints file
set INTF 1
if {[info exists ::env(INTF)]} {
  set INTF $::env(INTF)
} else {
  set env(INTF) $INTF
}

set NUM_OF_SDI 4
if {[info exists ::env(NUM_OF_SDI)]} {
  set NUM_OF_SDI $::env(NUM_OF_SDI)
} else {
  set env(NUM_OF_SDI) $NUM_OF_SDI
}

set EXT_CLK [get_env_param EXT_CLK 0]

adi_project ad7606x_fmc_zed 0 [list \
  DEV_CONFIG $DEV_CONFIG \
  INTF $INTF \
  NUM_OF_SDI $NUM_OF_SDI \
  EXT_CLK $EXT_CLK \
]

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.tcl"]

switch $INTF {
  0 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_pi.v" ]
  }
  1 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_si.v" ]
  }
}

adi_project_run ad7606x_fmc_zed
