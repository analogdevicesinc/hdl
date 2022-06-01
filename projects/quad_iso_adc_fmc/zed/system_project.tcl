
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project quad_iso_adc_fmc_zed

adi_project_files quad_iso_adc_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_top_ad40xx.v" \
  "system_constr_ad40xx.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

adi_project_run quad_iso_adc_fmc_zed

