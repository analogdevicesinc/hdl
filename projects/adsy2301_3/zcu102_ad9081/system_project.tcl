###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project adsy2301_3_zcu102_ad9081 0 [list \
  JESD_MODE        [get_env_param JESD_MODE     8B10B ] \
  RX_LANE_RATE     [get_env_param RX_LANE_RATE     10 ] \
  TX_LANE_RATE     [get_env_param TX_LANE_RATE     10 ] \
  RX_JESD_M        [get_env_param RX_JESD_M         8 ] \
  RX_JESD_L        [get_env_param RX_JESD_L         4 ] \
  RX_JESD_S        [get_env_param RX_JESD_S         1 ] \
  RX_JESD_NP       [get_env_param RX_JESD_NP       16 ] \
  RX_NUM_LINKS     [get_env_param RX_NUM_LINKS      1 ] \
  RX_TPL_WIDTH     [get_env_param RX_TPL_WIDTH     {} ] \
  TX_JESD_M        [get_env_param TX_JESD_M         8 ] \
  TX_JESD_L        [get_env_param TX_JESD_L         4 ] \
  TX_JESD_S        [get_env_param TX_JESD_S         1 ] \
  TX_JESD_NP       [get_env_param TX_JESD_NP       16 ] \
  TX_NUM_LINKS     [get_env_param TX_NUM_LINKS      1 ] \
  TX_TPL_WIDTH     [get_env_param TX_TPL_WIDTH     {} ] \
  SHARED_DEVCLK    [get_env_param SHARED_DEVCLK     1 ] \
  TDD_SUPPORT      [get_env_param TDD_SUPPORT       1 ] \
  TDD_CHANNEL_CNT  [get_env_param TDD_CHANNEL_CNT   4 ] \
  TDD_DEFAULT_POL  [get_env_param TDD_DEFAULT_POL   0 ] \
  TDD_REG_WIDTH    [get_env_param TDD_REG_WIDTH    32 ] \
  TDD_BURST_WIDTH  [get_env_param TDD_BURST_WIDTH  32 ] \
  TDD_SYNC_WIDTH   [get_env_param TDD_SYNC_WIDTH   32 ] \
  TDD_SYNC_INT     [get_env_param TDD_SYNC_INT      1 ] \
  TDD_SYNC_EXT     [get_env_param TDD_SYNC_EXT      0 ] \
  TDD_SYNC_EXT_CDC [get_env_param TDD_SYNC_EXT_CDC  0 ] \
]

adi_project_files adsy2301_3_zcu102_ad9081 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/ad9081_fmca_ebz/zcu102/system_constr.xdc" \
  "$ad_hdl_dir/projects/ad9081_fmca_ebz/zcu102/timing_constr.xdc" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/adsy2301_3/zcu102_ad9081/system_constr.xdc"]

adi_project_run adsy2301_3_zcu102_ad9081
