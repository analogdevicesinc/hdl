source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create ac701
adi_project_files ac701 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/projects/common/ac701//ac701_system_constr.xdc" ]

adi_project_run ac701
