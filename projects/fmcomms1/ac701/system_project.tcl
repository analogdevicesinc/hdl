


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create fmcomms1_ac701
adi_project_files fmcomms1_ac701 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/projects/common/ac701/ac701_system_constr.xdc" ]

adi_project_run fmcomms1_ac701


