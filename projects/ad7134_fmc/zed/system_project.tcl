###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad7134_fmc_zed

adi_project_files ad7134_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad7134_fmc_zed
