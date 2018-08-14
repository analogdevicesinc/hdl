# load script
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9467_fmc_kc705
adi_project_files ad9467_fmc_kc705 [list \
  "../common/ad9467_spi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/kc705/kc705_system_constr.xdc"]

adi_project_run ad9467_fmc_kc705

