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
# ADC_RES: parameter describing the ADC input resolution, thus selecting
#          between ADAQ23878 (18-bit, default) and ADAQ23875/ADAQ23876 (16-bit)
# - 18: 18 bits, ADAQ23878 (default)
# - 16: 16 bits, ADAQ23875 & ADAQ23876
#
# The valid configurations for each supported evaluation board, depending on
# the above parameters, are:
#
# Eval board | ADC_RES | TWOLANES |
# =================================
# ADAQ23875  | 16      | 0 or 1   |
# ADAQ23876  | 16      | 0 or 1   |
# ADAQ23878  | 18      | 0 or 1   |

adi_project adaq2387x_zed 0 [list \
  TWOLANES  [get_env_param TWOLANES  1 ] \
  ADC_RES   [get_env_param ADC_RES  18 ] \
]

adi_project_files adaq2387x_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run adaq2387x_zed
