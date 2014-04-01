


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create fmcomms2_vc707
adi_project_files fmcomms2_vc707 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" ]

adi_project_run fmcomms2_vc707


