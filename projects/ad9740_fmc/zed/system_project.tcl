###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9740_fmc_zed

adi_project_files ad9740_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad9740_fmc_zed
