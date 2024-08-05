###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## The following HDL projects supports all the devices of EVAL-AD40XX-FMCZ:
##
##  AD4000/AD4001/AD4002/AD4003/AD4004/AD4005/AD4006/AD4007/AD4008/AD4010/AD4011/AD4020
##
## and also the EVAL-ADAQ400x eval board (with PMOD):
##
##  ADAQ4003
##
## NOTE: Make sure that you set up your required ADC resolution in pulsar_adc_bd.tcl
##

## Please select which eval board do you want to use
##
##    1 - EVAL-AD40XX-FMCZ
##    0 - EVAL-ADAQ400x
##
set FMC_N_PMOD [get_env_param FMC_N_PMOD 1]
set SPI_OP_MODE [get_env_param SPI_OP_MODE 0]

adi_project pulsar_adc_pmdz_zed 0 [list \
  FMC_N_PMOD    [get_env_param FMC_N_PMOD  1] \
  SPI_OP_MODE   [get_env_param SPI_OP_MODE 0] ]

adi_project_files pulsar_adc_pmdz_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" ]

if {$FMC_N_PMOD == 0} {
  adi_project_files pulsar_adc_pmdz_zed [list \
    "system_top_pmod.v" \
    "system_constr_pmod.xdc" ]
} elseif {$FMC_N_PMOD == 1} {
    adi_project_files pulsar_adc_pmdz_zed [list \
      "system_top_fmc.v" \
      "system_constr_fmc.xdc" ]
    if {$SPI_OP_MODE == 0} {
    adi_project_files pulsar_adc_pmdz_zed [list \
      "system_constr_fmc_sm0.xdc" ]
    } elseif {$SPI_OP_MODE == 1} {
    adi_project_files pulsar_adc_pmdz_zed [list \
      "system_constr_fmc_sm1.xdc" ]
    } elseif {$SPI_OP_MODE == 2} {
    adi_project_files pulsar_adc_pmdz_zed [list \
      "system_constr_fmc_sm2.xdc" ]
    }
} else {
  return -code error [format "ERROR: Invalid eval board type! ..."]
}

adi_project_run pulsar_adc_pmdz_zed

