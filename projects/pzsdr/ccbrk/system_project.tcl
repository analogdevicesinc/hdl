


source ../../scripts/adi_env.tcl -notrace
source $ad_hdl_dir/projects/scripts/adi_project.tcl -notrace
source $ad_hdl_dir/projects/scripts/adi_board.tcl -notrace

adi_project_create ccbrk_pzsdr
adi_project_files ccbrk_pzsdr [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/pzsdr/pzsdr_system_constr.xdc" ]

set_property PROCESSING_ORDER EARLY [get_files $ad_hdl_dir/projects/common/pzsdr/pzsdr_system_constr.xdc]
set_property PROCESSING_ORDER EARLY [get_files system_constr.xdc]

adi_project_run ccbrk_pzsdr


