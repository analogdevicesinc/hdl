source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project __i3c_ardz_coraz7s

adi_project_files __i3c_ardz_coraz7s [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc"]

adi_project_run __i3c_ardz_coraz7s
