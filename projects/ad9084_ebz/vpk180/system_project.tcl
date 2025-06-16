###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../../projects/scripts/adi_project_xilinx.tcl
source ../../../projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make JESD_MODE=64B66B RX_LANE_RATE=10.3125 TX_LANE_RATE=10.3125 RX_JESD_M=4 TX_JESD_M=4 RX_JESD_L=8 TX_JESD_L=8 RX_JESD_S=1 TX_JESD_S=1 RX_JESD_NP=16 TX_JESD_NP=16
#

#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
#   ENABLE_HSCI : If set, adds and enables the HSCI core in the design
#   RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links - only when ASYMMETRIC_A_B_MODE = 0
#   [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
#   ASYMMETRIC_A_B_MODE : When set, each Apollo side has its own JESD link
#   RX_B_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA ) for B side
#   TX_B_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo ) for B side
#   [RX/TX]_B_JESD_M : Number of converters per link for B side
#   [RX/TX]_B_JESD_L : Number of lanes per link for B side
#   [RX/TX]_B_JESD_NP : Number of bits per sample for B side
#   [RX/TX]_B_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M) for B side
#

adi_project ad9084_ebz_vpk180 0 [list \
  JESD_MODE           [get_env_param JESD_MODE       64B66B ] \
  REF_CLK_RATE        [get_env_param REF_CLK_RATE     312.5 ] \
  ENABLE_HSCI         [get_env_param ENABLE_HSCI          1 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE    20.625 ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE    20.625 ] \
  RX_JESD_M           [get_env_param RX_JESD_M            4 ] \
  RX_JESD_L           [get_env_param RX_JESD_L            4 ] \
  RX_JESD_S           [get_env_param RX_JESD_S            1 ] \
  RX_JESD_NP          [get_env_param RX_JESD_NP          16 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS         2 ] \
  TX_JESD_M           [get_env_param TX_JESD_M            4 ] \
  TX_JESD_L           [get_env_param TX_JESD_L            4 ] \
  TX_JESD_S           [get_env_param TX_JESD_S            1 ] \
  TX_JESD_NP          [get_env_param TX_JESD_NP          16 ] \
  TX_NUM_LINKS        [get_env_param TX_NUM_LINKS         2 ] \
  RX_KS_PER_CHANNEL   [get_env_param RX_KS_PER_CHANNEL   64 ] \
  TX_KS_PER_CHANNEL   [get_env_param TX_KS_PER_CHANNEL   64 ] \
  ASYMMETRIC_A_B_MODE [get_env_param ASYMMETRIC_A_B_MODE  0 ] \
  RX_B_LANE_RATE      [get_env_param RX_B_LANE_RATE  20.625 ] \
  TX_B_LANE_RATE      [get_env_param TX_B_LANE_RATE  20.625 ] \
  RX_B_JESD_M         [get_env_param RX_B_JESD_M          4 ] \
  RX_B_JESD_L         [get_env_param RX_B_JESD_L          4 ] \
  RX_B_JESD_S         [get_env_param RX_B_JESD_S          1 ] \
  RX_B_JESD_NP        [get_env_param RX_B_JESD_NP        16 ] \
  TX_B_JESD_M         [get_env_param TX_B_JESD_M          4 ] \
  TX_B_JESD_L         [get_env_param TX_B_JESD_L          4 ] \
  TX_B_JESD_S         [get_env_param TX_B_JESD_S          1 ] \
  TX_B_JESD_NP        [get_env_param TX_B_JESD_NP        16 ] \
  RX_B_KS_PER_CHANNEL [get_env_param RX_B_KS_PER_CHANNEL 64 ] \
  TX_B_KS_PER_CHANNEL [get_env_param TX_B_KS_PER_CHANNEL 64 ] \
]

adi_project_files ad9084_ebz_vpk180 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "timing_constr.tcl" \
  "../common/ad9084_ebz_spi.v" \
  "../common/versal_transceiver.tcl" \
  "../common/versal_hsci_phy.tcl" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vpk180/vpk180_system_constr.xdc" ]

# Avoid critical warning in OOC mode from the clock definitions
# since at that stage the submodules are not stiched together yet
if {$ADI_USE_OOC_SYNTHESIS == 1} {
  set_property used_in_synthesis false [get_files timing_constr.tcl]
}

set_property strategy Performance_RefinePlacement [get_runs impl_1]

adi_project_run ad9084_ebz_vpk180
