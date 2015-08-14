
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcjesdadc1_vc707
adi_project_files fmcjesdadc1_vc707 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "../common/fmcjesdadc1_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" ]

adi_project_run fmcjesdadc1_vc707
