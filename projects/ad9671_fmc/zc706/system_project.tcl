


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create ad9671_fmc_zc706
adi_project_files ad9671_fmc_zc706 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "../common/ad9671_fmc_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run ad9671_fmc_zc706


