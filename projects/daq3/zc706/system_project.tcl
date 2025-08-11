###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make PLL_TYPE=QPLL REF_CLK=500 LANE_RATE=10

# Parameter description:
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL]
#
#   e.g. call for make with parameters
#   set xcvr_config_paths [adi_xcvr_project [list \
#     LANE_RATE 10\
#     REF_CLK 500\
#     PLL_TYPE QPLL\
#   ]]
# The function returns a dictionary with the paths to the `cfng` file
# containing the modified parameters and to the `_common.v` file for extracting the value of the `QPLL_FBDIV_TOP` parameter for GTXE2.

global xcvr_config_paths

set xcvr_config_paths [adi_xcvr_projec [list \
  LANE_RATE [get_env_param LANE_RATE   10] \
  REF_CLK   [get_env_param REF_CLK    500] \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL] \
]]

# Parameter description:
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame

adi_project daq3_zc706 0 [list \
  RX_JESD_M    [get_env_param RX_JESD_M    2 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  TX_JESD_M    [get_env_param TX_JESD_M    2 ] \
  TX_JESD_L    [get_env_param TX_JESD_L    4 ] \
  TX_JESD_S    [get_env_param TX_JESD_S    1 ] \
]

adi_project_files daq3_zc706 [list \
  "../common/daq3_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_plddr3_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]


set_property part "xc7z045ffg900-3" [get_runs synth_1]
set_property part "xc7z045ffg900-3" [get_runs impl_1]
adi_project_run daq3_zc706

