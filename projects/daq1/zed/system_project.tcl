
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_xilinx daq1_zed
adi_project_files daq1_zed [list \
  "../common/daq1_spi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_top.v" ]

adi_project_run daq1_zed

