###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

source ../common/config.tcl

adi_project dac_fmc_ebz_zc706 0 [list \
  JESD_M    [get_config_param M] \
  JESD_L    [get_config_param L] \
  JESD_S    [get_config_param S] \
  JESD_NP   [get_config_param NP] \
  NUM_LINKS $num_links \
  DEVICE_CODE $device_code \
]

adi_project_files dac_fmc_ebz_zc706 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run dac_fmc_ebz_zc706
