
source ../../scripts/adi_env.tcl 
source $ad_hdl_dir/projects/scripts/adi_project.tcl 
source $ad_hdl_dir/projects/scripts/adi_board.tcl 

set p_device "xc7z020clg400-1"
adi_project_create pzsdr1_ccbox_lvds
adi_project_files pzsdr1_ccbox_lvds [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "../common/pzsdr1_constr.xdc" \
  "../common/pzsdr1_constr_lvds.xdc" \
  "../common/ccbox_constr.xdc" \
  "system_top.v" ]

adi_project_run pzsdr1_ccbox_lvds


