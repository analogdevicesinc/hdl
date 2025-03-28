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
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample

adi_project adrv9026_vcu118 0 [list \
  JESD_MODE           [get_env_param JESD_MODE      8B10B ] \
  LINK_SHARING        [get_env_param LINK_SHARING       1 ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE    9.83 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE    9.83 ] \
  TX_NUM_LINKS        [get_env_param TX_NUM_LINKS       1 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS       1 ] \
  RX_OS_NUM_LINKS     [get_env_param RX_OS_NUM_LINKS    1 ] \
  TX_JESD_M           [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L           [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S           [get_env_param TX_JESD_S          1 ] \
  RX_JESD_M           [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L           [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S           [get_env_param RX_JESD_S          1 ] \
  RX_OS_JESD_M        [get_env_param RX_OS_JESD_M       0 ] \
  RX_OS_JESD_L        [get_env_param RX_OS_JESD_L       0 ] \
  RX_OS_JESD_S        [get_env_param RX_OS_JESD_S       0 ] \
]

adi_project_files adrv9026_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

set_property strategy Performance_RefinePlacement [get_runs impl_1]

adi_project_run adrv9026_vcu118
