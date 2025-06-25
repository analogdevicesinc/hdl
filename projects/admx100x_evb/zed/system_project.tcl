###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project admx100x_evb_zed

adi_project_files admx100x_evb_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
    "system_constr.xdc" \
    "system_top.v"]

adi_project_run admx100x_evb_zed

