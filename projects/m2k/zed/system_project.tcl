
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project m2k_fmc_zed
adi_project_files m2k_fmc_zed [list \
  "../common/m2k_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v"]
set_property is_enabled false [get_files  *system_sys_ps7_0.xdc]
adi_project_run m2k_fmc_zed
