
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad77681evb_zed

adi_project_files ad77681evb_zed [list \
    "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "system_top.v" \
    "system_constr.xdc" \
    "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run ad77681evb_zed

