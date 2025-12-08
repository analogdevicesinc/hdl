###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make DEVICE="AD9740"
#
#
# Parameter description:
#
# DEVICE : DAC Part for which the project is compiled
#
#   AD9740 (Default)
#   AD9742
#   AD9744
#   AD9748
#
# Example:
#
#   make DEVICE="AD9740"
#   make DEVICE="AD9742"
#   make DEVICE="AD9744"
#   make DEVICE="AD9748"
#

adi_project ad9740_fmc_zed 0 [list \
  DEVICE [get_env_param DEVICE "AD9740"] \
  ]

adi_project_files ad9740_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad9740_fmc_zed

