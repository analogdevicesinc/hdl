


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcadc2_vc707
adi_project_files fmcadc2_vc707 [list \
  "../common/fmcadc2_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" ]

set_property PROCESSING_ORDER EARLY [get_files $ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc]
set_property PROCESSING_ORDER EARLY [get_files system_constr.xdc]

adi_project_run fmcadc2_vc707


