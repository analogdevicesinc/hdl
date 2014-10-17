
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create adv7511_kcu105
adi_project_files adv7511_kcu105 [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" ]

adi_project_run adv7511_kcu105


