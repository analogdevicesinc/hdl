
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create ad7768evb_zed
adi_project_files ad7768evb_zed [list \
  "../common/ad7768_if.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" ]

adi_project_run ad7768evb_zed

