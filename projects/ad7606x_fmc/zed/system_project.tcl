###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# INTF - Operation interface
#  - Options : Parallel(0)/Serial(1)
# NUM_OF_SDI - Number of SDI lines used
#  - Options: 1, 2, 4, 8
# ADC_N_BITS - ADC resolution
#  - Options: 16, 18

set NUM_OF_SDI [get_env_param NUM_OF_SDI 2]
set ADC_N_BITS [get_env_param ADC_N_BITS 16]
set INTF [get_env_param INTF 0]

adi_project ad7606x_fmc_zed 0 [list \
  INTF $INTF \
  NUM_OF_SDI $NUM_OF_SDI \
  ADC_N_BITS $ADC_N_BITS \
]

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $INTF {
  0 {
    adi_project_files ad7606x_fmc_zed [list \
      "system_top_pi.v" \
      "system_constr_pif.xdc"]
  }
  1 {
    switch $NUM_OF_SDI {
      1 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_1.xdc"]
      }

      2 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_2.xdc"]
      }

      4 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_4.xdc"]
      }

      8 {
        adi_project_files ad7606x_fmc_zed [list \
          "system_top_si.v" \
          "system_constr_spi_8.xdc"]
      }
    }
  }
}

adi_project_run ad7606x_fmc_zed
