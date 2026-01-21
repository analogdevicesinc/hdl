###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project adsy2301_2_zcu102 0 [list \
  MULTI_SPI        [get_env_param MULTI_SPI         0 ] \
  TDD_SUPPORT      [get_env_param TDD_SUPPORT       1 ] \
  TDD_CHANNEL_CNT  [get_env_param TDD_CHANNEL_CNT  17 ] \
  TDD_DEFAULT_POL  [get_env_param TDD_DEFAULT_POL   0 ] \
  TDD_REG_WIDTH    [get_env_param TDD_REG_WIDTH    32 ] \
  TDD_BURST_WIDTH  [get_env_param TDD_BURST_WIDTH  32 ] \
  TDD_SYNC_WIDTH   [get_env_param TDD_SYNC_WIDTH   32 ] \
  TDD_SYNC_INT     [get_env_param TDD_SYNC_INT      1 ] \
  TDD_SYNC_EXT     [get_env_param TDD_SYNC_EXT      0 ] \
  TDD_SYNC_EXT_CDC [get_env_param TDD_SYNC_EXT_CDC  0 ] \
]

adi_project_files adsy2301_2_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/adsy2301_2/zcu102/system_constr.xdc"]

adi_project_run adsy2301_2_zcu102
