
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create imageon_loopback_zed
adi_project_files imageon_loopback_zed [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

adi_project_run imageon_loopback_zed
