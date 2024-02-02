###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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
#   REF_CLK_RATE : Frequency of reference clock in MHz used in 64B66B mode
#   GENERATE_LINK_CLK : If 1 use the generated link clocks from the physical layer, else use the reference clock as the link clock.
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#   [RX/TX]_JESD_NP : Number of bits per sample, only 16 is supported
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#   [RX/TX]_KS_PER_CHANNEL : Number of samples stored in internal buffers in kilosamples per converter (M)

#      make JESD_MODE=64B66B RX_LANE_RATE=24.75 TX_LANE_RATE=24.75 RX_JESD_M=8 RX_JESD_L=8 RX_JESD_S=2 RX_JESD_NP=12 TX_JESD_M=8 TX_JESD_L=8 TX_JESD_S=2 TX_JESD_NP=12

adi_project ad_dualmxfe_ebz_vck190 0 [list \
  JESD_MODE         [get_env_param JESD_MODE              64B66B ]\
  RX_LANE_RATE      [get_env_param RX_LANE_RATE            24.75 ] \
  TX_LANE_RATE      [get_env_param TX_LANE_RATE            24.75 ] \
  REF_CLK_RATE      [get_env_param REF_CLK_RATE              375 ] \
  GENERATE_LINK_CLK [get_env_param GENERATE_LINK_CLK           0 ] \
  RX_JESD_M         [get_env_param RX_JESD_M                   8 ] \
  RX_JESD_L         [get_env_param RX_JESD_L                   8 ] \
  RX_JESD_S         [get_env_param RX_JESD_S                   2 ] \
  RX_JESD_NP        [get_env_param RX_JESD_NP                 12 ] \
  RX_NUM_LINKS      [get_env_param RX_NUM_LINKS                1 ] \
  TX_JESD_M         [get_env_param TX_JESD_M                   8 ] \
  TX_JESD_L         [get_env_param TX_JESD_L                   8 ] \
  TX_JESD_S         [get_env_param TX_JESD_S                   2 ] \
  TX_JESD_NP        [get_env_param TX_JESD_NP                 12 ] \
  TX_NUM_LINKS      [get_env_param TX_NUM_LINKS                1 ] \
  RX_KS_PER_CHANNEL [get_env_param RX_KS_PER_CHANNEL          64 ] \
  TX_KS_PER_CHANNEL [get_env_param TX_KS_PER_CHANNEL          64 ] \
]

adi_project_files ad_dualmxfe_ebz_vck190 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vck190/vck190_system_constr.xdc" ]

set_property strategy Performance_Explore [get_runs impl_1]

adi_project_run ad_dualmxfe_ebz_vck190

