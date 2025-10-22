###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description
# DEV_CONFIG - The device which will be used
#  - Options : AD7606B(0)/C-16(1)/C-18(2)
# SIMPLE_STATUS_CRC - ADC read mode Options
# - Options : SIMPLE(0), STATUS(1), CRC(2), CRC_STATUS(3)
# EXT_CLK - Use external clock as ADC clock
#  - Options : No(0), Yes(1)

set DEV_CONFIG [get_env_param DEV_CONFIG 0]
set SIMPLE_STATUS_CRC [get_env_param SIMPLE_STATUS_CRC 0]
set EXT_CLK [get_env_param EXT_CLK 0]

adi_project ad7606x_fmc_zcu102 0 [list \
  DEV_CONFIG $DEV_CONFIG \
  SIMPLE_STATUS_CRC $SIMPLE_STATUS_CRC \
  EXT_CLK $EXT_CLK \
]

adi_project_files ad7606x_fmc_zcu102 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
  "system_top.v" \
  "system_constr.xdc"]

adi_project_run ad7606x_fmc_zcu102
