
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project daq3_vcu118
adi_project_files daq3_vcu118 [list \
  "../common/daq3_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

## To improve timing in DDR4 MIG
set_property strategy Performance_Retiming [get_runs impl_1]

adi_project_run daq3_vcu118

