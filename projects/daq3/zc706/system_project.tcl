


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project daq3_zc706
adi_project_files daq3_zc706 [list \
  "../common/daq3_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_plddr3_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]


set_property part "xc7z045ffg900-3" [get_runs synth_1]
set_property part "xc7z045ffg900-3" [get_runs impl_1]
adi_project_run daq3_zc706

