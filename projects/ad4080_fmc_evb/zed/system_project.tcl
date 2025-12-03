###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set ADC_N_BITS [get_env_param ADC_N_BITS 20]

adi_project ad4080_fmc_evb_zed 0 [list \
  ADC_N_BITS $ADC_N_BITS \
]
adi_project_files ad4080_fmc_evb_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

adi_project_run ad4080_fmc_evb_zed
