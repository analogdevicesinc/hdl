


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcomms2_zc706
adi_project_files fmcomms2_zc706 [list \
  "../common/prcfg.v" \
  "$ad_hdl_dir/library/prcfg/common/prcfg_top.v" \
  "$ad_hdl_dir/library/prcfg/default/prcfg_dac.v" \
  "$ad_hdl_dir/library/prcfg/default/prcfg_adc.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

adi_project_run fmcomms2_zc706


