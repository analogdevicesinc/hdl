###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value.
#
#   Use over-writable parameters from the environment.
#
#    e.g. JESD only
#      make RX_JESD_L=4 RX_JESD_M=16 RX_JESD_S=1 RX_JESD_NP=12
#
#    e.g. XCVR only
#      make PLL_TYPE=QPLL0 REF_CLK=750 LANE_RATE=15
#
#    e.g. JESD and XCVR
#      make RX_JESD_L=4 \
#      RX_JESD_M=16 \
#      RX_JESD_S=1 \
#      RX_JESD_NP=12 \
#      PLL_TYPE=QPLL0 \
#      REF_CLK=750 \
#      LANE_RATE=15

# adi_xcvr_project runs the xcvr_wizard project sub-build and returns a
# dictionary with the paths to the `cfng` file containing the modified
# parameters and to the `_common.v` file for GTXE2.
#
#   e.g. call for make with parameters
#   set xcvr_config_paths [adi_xcvr_project [list \
#     LANE_RATE 15\
#     REF_CLK 750\
#     PLL_TYPE QPLL0\
#   ]]

global xcvr_config_paths

# Parameter description:
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL0/QPLL1]

set xcvr_config_paths [adi_xcvr_project [list \
  LANE_RATE [get_env_param LANE_RATE    15] \
  REF_CLK   [get_env_param REF_CLK     750] \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL0] \
]]

# Parameter description:
#   [RX]_JESD_M : Number of converters per link
#   [RX]_JESD_L : Number of lanes per link
#   [RX]_JESD_S : Number of samples per frame
#   [RX]_JESD_NP: Number of bits per sample

adi_project ad9083_evb_vcu118 0 [list \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_M    [get_env_param RX_JESD_M   16 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP  12 ] \
]

adi_project_files ad9083_evb_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

set_property strategy Congestion_SpreadLogic_high [get_runs impl_1]

adi_project_run ad9083_evb_vcu118
