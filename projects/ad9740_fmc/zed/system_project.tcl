###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl


puts "system_project.tcl: param: [get_env_param DEVICE "AD9744"]"

adi_project ad9740_fmc_zed 0 [list \
  DEVICE [get_env_param DEVICE "AD9744"]  \
  ]

adi_project_files ad9740_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "system_top.v" \
    "system_constr.xdc" \
    ]

adi_project_run ad9740_fmc_zed
