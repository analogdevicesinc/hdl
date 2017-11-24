


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_xilinx fmcadc5_vc707
adi_project_files fmcadc5_vc707 [list \
  "$ad_hdl_dir/projects/common/vc707/vc707_system_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "../common/fmcadc5_spi.v" \
  "system_constr.xdc"\
  "system_top.v"]

set_property is_enabled false [get_files  *system_rx_0/jesd204_rx_constr.xdc]
set_property is_enabled false [get_files  *system_rx_1/jesd204_rx_constr.xdc]

adi_project_run fmcadc5_vc707


