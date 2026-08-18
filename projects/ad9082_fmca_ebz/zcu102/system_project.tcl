###############################################################################
## Copyright (C) 2019-2023, 2026 Analog Devices, Inc. All rights reserved.
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
#    e.g. XCVR only
#      make PLL_TYPE=QPLL0 REF_CLK=750 LANE_RATE=15
#
#    e.g. JESD only
#      make RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1
#      make RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1
#
#    e.g. JESD and XCVR
#      make RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1 PLL_TYPE=QPLL0 REF_CLK=750 LANE_RATE=15
#      make RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 PLL_TYPE=QPLL0 REF_CLK=750 LANE_RATE=15

global xcvr_config_paths

# Parameter description:
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL1/QPLL0]
#   XCVR_RX_LANE_RATE: Value of lane rate for the RX link [gbps] (Optional)
#   XCVR_RX_REF_CLK: Value of the reference clock for the RX link [MHz] (usually XCVR_RX_LANE_RATE/20 or XCVR_RX_LANE_RATE/40) (Optional)
#   XCVR_RX_PLL_TYPE: The PLL used for driving the RX link [CPLL/QPLL1/QPLL0] (Optional)
#   JESD_MODE: Used link layer encoder mode [64B66B - JESD 204C, 8B10B - JESD 204B] (Optional)

set xcvr_config_paths [adi_xcvr_project [list \
  LANE_RATE [get_env_param LANE_RATE    15] \
  REF_CLK   [get_env_param REF_CLK     750] \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL0] \
]]

# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   RX_LANE_RATE :  Line rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Line rate of the Tx link ( FPGA to MxFE )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample, only 16 is supported
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#
#  !!! For this carrier only 8B10B mode is supported !!!

adi_project ad9082_fmca_ebz_zcu102 0 [list \
  JESD_MODE    [get_env_param JESD_MODE      8B10B ] \
  RX_LANE_RATE [get_env_param RX_LANE_RATE      15 ] \
  TX_LANE_RATE [get_env_param TX_LANE_RATE      15 ] \
  RX_JESD_M    [get_env_param RX_JESD_M          4 ] \
  RX_JESD_L    [get_env_param RX_JESD_L          8 ] \
  RX_JESD_S    [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP         16] \
  RX_NUM_LINKS [get_env_param RX_NUM_LINKS       1 ] \
  RX_TPL_WIDTH [get_env_param RX_TPL_WIDTH       {}] \
  TX_JESD_M    [get_env_param TX_JESD_M          4 ] \
  TX_JESD_L    [get_env_param TX_JESD_L          8 ] \
  TX_JESD_S    [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP   [get_env_param TX_JESD_NP         16] \
  TX_NUM_LINKS [get_env_param TX_NUM_LINKS       1 ] \
  TX_TPL_WIDTH [get_env_param TX_TPL_WIDTH       {}] \
]

adi_project_files ad9082_fmca_ebz_zcu102 [list \
  "../../ad9081_fmca_ebz/zcu102/system_top.v" \
  "../../ad9081_fmca_ebz/zcu102/system_constr.xdc" \
  "../../ad9081_fmca_ebz/zcu102/timing_constr.xdc" \
  "../../../library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run ad9082_fmca_ebz_zcu102
