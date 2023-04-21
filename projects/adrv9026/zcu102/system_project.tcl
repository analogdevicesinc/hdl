###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project adrv9026_zcu102 0 [list \
  TX_JESD_M       [get_env_param TX_JESD_M       8 ] \
  TX_JESD_L       [get_env_param TX_JESD_L       4 ] \
  TX_JESD_S       [get_env_param TX_JESD_S       1 ] \
  RX_JESD_M       [get_env_param RX_JESD_M       8 ] \
  RX_JESD_L       [get_env_param RX_JESD_L       4 ] \
  RX_JESD_S       [get_env_param RX_JESD_S       1 ] \
]
adi_project_files adrv9026_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run adrv9026_zcu102