
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project daq2_kcu105
adi_project_files daq2_kcu105 [list \
  "../common/daq2_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" ]

## To improve timing in DDR4 MIG
set_property strategy Performance_Retiming [get_runs impl_1]

adi_project_run daq2_kcu105


