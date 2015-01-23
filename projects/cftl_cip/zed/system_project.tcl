
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create cftl_custom_zed
adi_project_files cftl_custom_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

adi_project_run cftl_custom_zed

