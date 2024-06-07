###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description

# ALERT_SPI_N - SDOB/ALERT pin can operate as a serial data output pin or alert indication output
#  - Options : SDOB(0)/ALERT(1)
# NUM_OF_SDI - Number of SDI lines used
#  - Options : 1, 2, 4
# CHIP_SELECT - The device which will be used
#  - Options : AD7380-4(0)/AD7380/1(1)

set ALERT_SPI_N 0
if {[info exists ::env(ALERT_SPI_N)]} {
  set ALERT_SPI_N $::env(ALERT_SPI_N)
} else {
  set env(ALERT_SPI_N) $ALERT_SPI_N
}

set NUM_OF_SDI 4
if {[info exists ::env(NUM_OF_SDI)]} {
  set NUM_OF_SDI $::env(NUM_OF_SDI)
} else {
  set env(NUM_OF_SDI) $NUM_OF_SDI
}

set CHIP_SELECT [get_env_param CHIP_SELECT 0]

adi_project ad738x_fmc_zed 0 [list \
  ALERT_SPI_N $ALERT_SPI_N \
  NUM_OF_SDI $NUM_OF_SDI \
  CHIP_SELECT $CHIP_SELECT \
]

adi_project_files ad738x_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.tcl" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run ad738x_fmc_zed
