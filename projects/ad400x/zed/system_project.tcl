
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_xilinx ad400x_zed

adi_project_files ad400x_zed [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run ad400x_zed

