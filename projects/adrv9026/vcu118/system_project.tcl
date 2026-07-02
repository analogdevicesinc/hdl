###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#    Use over-writable parameters from the environment.
#
#    e.g. JESD only
#      RX-OS disabled: make
#      RX-OS Non-LinkSharing:
#       - JESD204B: make ORX_ENABLE=1 RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 RX_OS_JESD_NP=16 RX_JESD_L=2 RX_TPL_WIDTH=8
#       - JESD204C: make JESD_MODE=64B66B ORX_ENABLE=1 TX_LANE_RATE=16.22 RX_LANE_RATE=16.22 \
#                        RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 RX_OS_JESD_NP=16 RX_JESD_L=2
#
#    e.g. XCVR only
#      make PLL_TYPE=QPLL0 REF_CLK=245.75 LANE_RATE=9.83
#
#    e.g. JESD and XCVR
#      make JESD_MODE=8B10B ORX_ENABLE=1 RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 RX_OS_JESD_NP=16 RX_JESD_L=2 RX_TPL_WIDTH=8 \
#           PLL_TYPE=QPLL0 REF_CLK=245.75 LANE_RATE=9.83
#      make JESD_MODE=64B66B ORX_ENABLE=1 TX_LANE_RATE=16.22 RX_LANE_RATE=16.22 RX_OS_JESD_M=4 RX_OS_JESD_L=2 RX_OS_JESD_S=1 \
#           RX_OS_JESD_NP=16 RX_JESD_L=2 PLL_TYPE=QPLL0 REF_CLK=245.76 LANE_RATE=16.22016

global xcvr_config_paths

# Parameter description:
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL1/QPLL0]
#   XCVR_RX_LANE_RATE: Value of lane rate for the RX link [gbps] (Optional)
#   XCVR_RX_REF_CLK: Value of the reference clock for the RX link [MHz] (usually XCVR_RX_LANE_RATE/20 or XCVR_RX_LANE_RATE/40) (Optional)
#   XCVR_RX_PLL_TYPE: The PLL used for driving the RX link [CPLL/QPLL1/QPLL0] (Optional)

set xcvr_config_paths [adi_xcvr_project [list \
  LANE_RATE [get_env_param LANE_RATE 16.22016] \
  REF_CLK   [get_env_param REF_CLK     245.76] \
  PLL_TYPE  [get_env_param PLL_TYPE     QPLL1] \
]]

# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#   ORX_ENABLE : Additional data path for RX-OS
#      0 - Disabled (used for profiles with RX-OS disabled)
#      1 - Enabled (used for profiles with RX-OS enabled)
#   TX_LANE_RATE : Transceiver line rate of the TX link
#   RX_LANE_RATE : Transceiver line rate of the RX link
#   [TX/RX/RX_OS]_NUM_LINKS : Number of links
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#   [TX/RX/RX_OS]_TPL_WIDTH : TPL data path width in bits

adi_project adrv9026_vcu118 0 [list \
  JESD_MODE           [get_env_param JESD_MODE      8B10B ] \
  ORX_ENABLE          [get_env_param ORX_ENABLE         0 ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE    9.83 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE    9.83 ] \
  TX_NUM_LINKS        [get_env_param TX_NUM_LINKS       1 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS       1 ] \
  RX_OS_NUM_LINKS     [get_env_param RX_OS_NUM_LINKS    1 ] \
  TX_JESD_M           [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L           [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S           [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP          [get_env_param TX_JESD_NP        16 ] \
  TX_TPL_WIDTH        [get_env_param TX_TPL_WIDTH      {} ] \
  RX_JESD_M           [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L           [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S           [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP          [get_env_param RX_JESD_NP        16 ] \
  RX_TPL_WIDTH        [get_env_param RX_TPL_WIDTH      {} ] \
  RX_OS_JESD_M        [get_env_param RX_OS_JESD_M       0 ] \
  RX_OS_JESD_L        [get_env_param RX_OS_JESD_L       0 ] \
  RX_OS_JESD_S        [get_env_param RX_OS_JESD_S       0 ] \
  RX_OS_JESD_NP       [get_env_param RX_OS_JESD_NP      0 ] \
  RX_OS_TPL_WIDTH     [get_env_param RX_OS_TPL_WIDTH   {} ] \
]

adi_project_files adrv9026_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

## To improve timing in DDR4 MIG
set_property strategy Performance_RefinePlacement [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE ExploreWithAggressiveHoldFix [get_runs impl_1]

adi_project_run adrv9026_vcu118
