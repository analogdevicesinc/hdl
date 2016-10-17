
source ../../scripts/adi_env.tcl 
source $ad_hdl_dir/projects/scripts/adi_project.tcl 
source $ad_hdl_dir/projects/scripts/adi_board.tcl 

adi_project_create ccbox_lvds_pzsdr1
adi_project_files ccbox_lvds_pzsdr1 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/pzsdr1/pzsdr1_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/pzsdr1/pzsdr1_lvds_system_constr.xdc" ]

adi_project_run ccbox_lvds_pzsdr1


