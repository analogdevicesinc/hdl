###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9213_evb_vcu118 0 [list \
  CLK_MODE     [get_env_param CLK_MODE      0] \
  NUM_OF_SDI   [get_env_param NUM_OF_SDI    4] \
  CAPTURE_ZONE [get_env_param CAPTURE_ZONE  2] \
  DDR_EN       [get_env_param DDR_EN        0] ]

adi_project_files ad9213_evb_vcu118 [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

switch [get_env_param NUM_OF_SDI 4] {
  1 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_1sdi.xdc" ]
  }
  2 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_2sdi.xdc" ]
  }
  4 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_4sdi.xdc" ]
  }
  8 {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_8sdi.xdc" ]
  }
  default {
    adi_project_files ad4630_fmc_zed [list \
      "system_constr_2sdi.xdc" ]
  }
}

## To improve timing in DDR4 MIG
set_property strategy Performance_SpreadSLLs [get_runs impl_1]

adi_project_run ad9213_evb_vcu118
