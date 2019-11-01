
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcjesdadc1_zcu102
adi_project_files fmcjesdadc1_zcu102 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  "../common/fmcjesdadc1_spi.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run fmcjesdadc1_zcu102
