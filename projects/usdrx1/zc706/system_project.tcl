


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create usdrx1_zc706
adi_project_files usdrx1_zc706 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "../common/usdrx1_spi.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_mig_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run usdrx1_zc706


