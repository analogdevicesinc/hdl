


source ../../scripts/adi_env.tcl 
source $ad_hdl_dir/projects/scripts/adi_project.tcl 
source $ad_hdl_dir/projects/scripts/adi_board.tcl 

adi_project_create ccbrk_cmos_pzsdr
adi_project_files ccbrk_cmos_pzsdr [list \
  "system_top.v" \
  "../ccbrk/system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/pzsdr/pzsdr_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/pzsdr/pzsdr_bd_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/pzsdr/pzsdr_cmos_system_constr.xdc" ]

adi_project_run ccbrk_cmos_pzsdr


