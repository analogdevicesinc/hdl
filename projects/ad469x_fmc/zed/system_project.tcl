###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl

adi_project ad469x_fmc_zed

adi_project_files ad469x_fmc_zed [list \
    "../../../library/common/ad_iobuf.v" \
    "../../common/zed/zed_system_constr.xdc" \
    "system_top.v" \
    "system_constr.xdc"]

adi_project_run ad469x_fmc_zed
