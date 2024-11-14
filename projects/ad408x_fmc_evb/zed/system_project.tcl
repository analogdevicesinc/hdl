###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set ADC_N_BITS [get_env_param ADC_N_BITS 20]
set DDR_OR_SDR_N [get_env_param DDR_OR_SDR_N 1]

adi_project ad408x_fmc_evb_zed 0 [list \
  ADC_N_BITS $ADC_N_BITS \
  DDR_OR_SDR_N $DDR_OR_SDR_N \
]
adi_project_files ad408x_fmc_evb_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

adi_project_run ad408x_fmc_evb_zed
