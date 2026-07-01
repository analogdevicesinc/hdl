###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description:
# LANE_RATE: Value of lane rate [gbps]
# REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
# PLL_TYPE: The PLL used for driving the link [CPLL/QPLL0/QPLL1]
# JESD_MODE: Used link layer encoder mode [64B66B - JESD 204C, 8B10B - JESD 204B]

adi_project xcvr_wizard_zcu102 0 [list \
  LANE_RATE      [get_env_param LANE_RATE        10 ] \
  REF_CLK        [get_env_param REF_CLK         500 ] \
  PLL_TYPE       [get_env_param PLL_TYPE      QPLL0 ] \
  JESD_MODE      [get_env_param JESD_MODE      8B10B] \
  XCVR_RX_PLL_TYPE    [get_env_param XCVR_RX_PLL_TYPE      {} ] \
  XCVR_RX_LANE_RATE [get_env_param XCVR_RX_LANE_RATE {} ] \
  XCVR_RX_REF_CLK     [get_env_param XCVR_RX_REF_CLK       {} ] \
]
