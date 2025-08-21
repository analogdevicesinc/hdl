###############################################################################
## Copyright (C) 2022-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# load scripts
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# TWOLANES: parameter describing the number of lanes
# - 1: in two-lane mode (default)
# - 0: in one-lane mode
#
# ADC_RES: parameter describing the ADC input resolution
# - 18: 18 bits (default)
# - 16: 16 bits
#
# in one-lane mode (TWOLANES=0), only the 18-bit resolution is supported! (ADC_RES=16)

adi_project cn0577_zed 0 [list \
  TWOLANES  [get_env_param TWOLANES  1 ] \
  ADC_RES   [get_env_param ADC_RES  18 ] \
]

adi_project_files cn0577_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run cn0577_zed
