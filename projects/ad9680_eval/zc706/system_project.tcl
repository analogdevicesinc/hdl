


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create ad9680_eval_zc706
adi_project_files ad9680_eval_zc706 [list \
  "system_top.v" \
  "../common/ad9680_eval_spi.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run ad9680_eval_zc706


