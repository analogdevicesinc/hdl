
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create fmcjesdadc1_kc705
adi_project_files fmcjesdadc1_kc705 [list \
  "../common/fmcjesdadc1_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/kc705/kc705_system_constr.xdc" ]

adi_project_run fmcjesdadc1_kc705
