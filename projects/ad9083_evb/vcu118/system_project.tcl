###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9083_evb_vcu118 0 [list \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_M    [get_env_param RX_JESD_M   16 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP  12 ] \
]
adi_project_files ad9083_fmc_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

adi_project_run ad9083_evb_vcu118
