###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set device AD9173
set mode   04

set env(ADI_DAC_DEVICE) $device
set env(ADI_DAC_MODE) $mode

source $ad_hdl_dir/projects/dac_fmc_ebz/common/config.tcl

adi_project adi_vna_8ch_zcu102 0 [list \
  RX_JESD_L    [get_env_param RX_JESD_L    1 ] \
  RX_JESD_M    [get_env_param RX_JESD_M   32 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  TX_JESD_M    [get_config_param M] \
  TX_JESD_L    [get_config_param L] \
  TX_JESD_S    [get_config_param S] \
  TX_JESD_NP   [get_config_param NP] \
  TX_NUM_LINKS $num_links \
  TX_DEVICE_CODE $device_code \
]

adi_project_files adi_vna_8ch_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "timing_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run adi_vna_8ch_zcu102
