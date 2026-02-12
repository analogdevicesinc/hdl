###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl



adi_project pynq_subsystem_zed

# adi_project_files pynq_subsystem_zed [list \
#     "$ad_hdl_dir/library/common/ad_iobuf.v" \
#     "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
#     "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
#     "system_constr.xdc" \
#     "system_top.v" \ 
#     "$ad_hdl_dir/projects/pynq_subsystem/common/universal_register.v"]

adi_project_files pynq_subsystem_zed [list \
    $ad_hdl_dir/library/common/ad_iobuf.v \
    $ad_hdl_dir/library/xilinx/common/ad_data_clk.v \
    $ad_hdl_dir/projects/common/zed/zed_system_constr.xdc \
    system_constr.xdc \
    system_top.v \
]

set_property used_in_synthesis false [get_files $ad_hdl_dir/projects/common/zed/zed_system_constr.xdc]
set_property used_in_synthesis false [get_files $ad_hdl_dir/projects/pynq_subsystem/zed/system_constr.xdc]


adi_project_run pynq_subsystem_zed
