
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create adv7511_zc706
adi_project_files adv7511_zc706 [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

adi_project_run adv7511_zc706

