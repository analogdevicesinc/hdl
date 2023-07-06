###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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
#      make RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1
#      make RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1

#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C, uses Xilinx IP as Physical layer
#      8B10B  - 8b10b link layer defined in JESD 204B, uses ADI IP as Physical layer
#
#   RX_LANE_RATE :  Line rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Line rate of the Tx link ( FPGA to MxFE )
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample, only 16 is supported
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#

adi_project ad9081_fmca_ebz_zcu102 0 [list \
  JESD_MODE        [get_env_param JESD_MODE      8B10B ] \
  RX_LANE_RATE     [get_env_param RX_LANE_RATE      10 ] \
  TX_LANE_RATE     [get_env_param TX_LANE_RATE      10 ] \
  RX_JESD_M        [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L        [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S        [get_env_param RX_JESD_S          1 ] \
  RX_JESD_NP       [get_env_param RX_JESD_NP        16 ] \
  RX_NUM_LINKS     [get_env_param RX_NUM_LINKS       1 ] \
  RX_TPL_WIDTH     [get_env_param RX_TPL_WIDTH      {} ] \
  TX_JESD_M        [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L        [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S        [get_env_param TX_JESD_S          1 ] \
  TX_JESD_NP       [get_env_param TX_JESD_NP        16 ] \
  TX_NUM_LINKS     [get_env_param TX_NUM_LINKS       1 ] \
  TX_TPL_WIDTH     [get_env_param TX_TPL_WIDTH      {} ] \
  TDD_SUPPORT      [get_env_param TDD_SUPPORT        0 ] \
  SHARED_DEVCLK    [get_env_param SHARED_DEVCLK      0 ] \
  TDD_CHANNEL_CNT  [get_env_param TDD_CHANNEL_CNT    2 ] \
  TDD_SYNC_WIDTH   [get_env_param TDD_SYNC_WIDTH    32 ] \
  TDD_SYNC_INT     [get_env_param TDD_SYNC_INT       1 ] \
  TDD_SYNC_EXT     [get_env_param TDD_SYNC_EXT       0 ] \
  TDD_SYNC_EXT_CDC [get_env_param TDD_SYNC_EXT_CDC   0 ] \
]

adi_project_files ad9081_fmca_ebz_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]


adi_project_run ad9081_fmca_ebz_zcu102

