# load script

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create imageon_zc706
adi_project_files imageon_zc706 [list \
  "system_top.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

set_property PROCESSING_ORDER EARLY [get_files $ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc]
set_property PROCESSING_ORDER EARLY [get_files system_constr.xdc]

adi_project_run imageon_zc706

