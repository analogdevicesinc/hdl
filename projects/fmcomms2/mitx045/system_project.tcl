
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcomms2_mitx045
adi_project_files fmcomms2_mitx045 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/mitx045/mitx045_system_constr.xdc" ]

adi_project_run fmcomms2_mitx045


