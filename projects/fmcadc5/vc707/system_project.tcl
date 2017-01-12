


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create fmcadc5_vc707
adi_project_files fmcadc5_vc707 [list \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_lvds_out.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "../common/fmcadc5_spi.v" \
  "../common/fmcadc5_psync.v" \
  "system_constr.xdc"\
  "system_top.v"]

adi_project_run fmcadc5_vc707


