
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad9208_vcu118
adi_project_files ad9208_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/daq3/common/daq3_spi.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

## To improve timing in DDR4 MIG
#set_property strategy Performance_Retiming [get_runs impl_1]
set_property strategy Performance_SpreadSLLs [get_runs impl_1]

adi_project_run ad9208_vcu118

