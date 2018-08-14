
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project fmcomms2_kcu105
adi_project_files fmcomms2_kcu105 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_lutram_constr.xdc" ]

## To improve timing in DDR4 MIG
set_property strategy Performance_Retiming [get_runs impl_1]

adi_project_run fmcomms2_kcu105
source $ad_hdl_dir/library/axi_ad9361/axi_ad9361_delay.tcl

