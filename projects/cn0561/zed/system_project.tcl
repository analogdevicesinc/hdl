###############################################################################
## Copyright (C) 2022-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project cn0561_zed

adi_project_files cn0561_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc" ]

adi_project_run cn0561_zed
