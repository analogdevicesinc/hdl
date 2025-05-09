###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
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
# Parameter description:
#   JESD_MODE: link layer encoder mode used;
#      64B66B - 64b66b link layer defined in JESD 204C, uses Xilinx IP as Physical layer
#      8B10B - 8b10b link layer defined in JESD 204B, uses ADI IP as Physical layer
#   [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
#   [RX/TX]_JESD_M - [RX/TX] number of converters per link
#   [RX/TX]_JESD_L - [RX/TX] number of lanes per link
#   [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
#   [RX/TX]_JESD_NP - [RX/TX] number of bits per sample
#   [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices

adi_project adrv904x_zcu102 0 [list \
  JESD_MODE       [get_env_param JESD_MODE     64B66B] \
  TX_LANE_RATE    [get_env_param TX_LANE_RATE   16.22] \
  RX_LANE_RATE    [get_env_param RX_LANE_RATE   16.22] \
  TX_NUM_LINKS    [get_env_param RX_NUM_LINKS       1] \
  RX_NUM_LINKS    [get_env_param RX_NUM_LINKS       1] \
  TX_JESD_M       [get_env_param TX_JESD_M         16] \
  TX_JESD_L       [get_env_param TX_JESD_L          8] \
  TX_JESD_S       [get_env_param TX_JESD_S          1] \
  TX_JESD_NP      [get_env_param TX_JESD_NP        16] \
  RX_JESD_M       [get_env_param RX_JESD_M         16] \
  RX_JESD_L       [get_env_param RX_JESD_L          8] \
  RX_JESD_S       [get_env_param RX_JESD_S          1] \
  RX_JESD_NP      [get_env_param RX_JESD_NP        16] \
]

adi_project_files adrv904x_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run adrv904x_zcu102

