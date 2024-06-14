###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description

# ALERT_SPI_N - SDOB-SDOD/ALERT pin can operate as a serial data output pin or alert indication output
#  - Options : SDOB-SDOD(0)/ALERT(1)
# NUM_OF_SDI - Number of SDI lines used
#  - Options : 1,2,4

adi_project ad738x_fmc_zed 0 [list \
  ALERT_SPI_N [get_env_param ALERT_SPI_N  0]\
  NUM_OF_SDI [get_env_param NUM_OF_SDI    1] ]

adi_project_files ad738x_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
    "system_constr.xdc" \
    "system_top.v" ]

switch [get_env_param NUM_OF_SDI 1] {
  1 {
    adi_project_files ad738x_fmc_zed [list \
      "system_constr_1sdi.xdc" ]
  }
  2 {
    adi_project_files ad738x_fmc_zed [list \
     "system_constr_2sdi.xdc" ]
 }
  4 {
   adi_project_files ad738x_fmc_zed [list \
     "system_constr_4sdi.xdc" ]
  }
  default {
    adi_project_files ad738x_fmc_zed [list \
      "system_constr_1sdi.xdc" ]
  }
}

adi_project_run ad738x_fmc_zed
