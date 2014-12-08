


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create fmcadc2_zc706
adi_project_files fmcadc2_zc706 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "../common/fmcadc2_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_mig_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

set_property PROCESSING_ORDER EARLY [get_files $ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc]
set_property PROCESSING_ORDER EARLY [get_files system_constr.xdc]

adi_project_run fmcadc2_zc706


