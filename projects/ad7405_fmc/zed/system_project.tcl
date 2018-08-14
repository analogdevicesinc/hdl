
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7405/ADuM7701 operation and interface mode
#
#    adc_port_type - Defines the type of the data line: single
#    ended (ADuM7701) or differential (AD7405)
#
# LEGEND: single ended - 0
#         differential - 1
#
# NOTE : This switch is a 'hardware' switch. Please reimplement the
# design if the variable has been changed.
#
##--------------------------------------------------------------

set adc_port_type   0

adi_project ad7405_fmc_zed

if { $adc_port_type == 0 } {

  adi_project_files ad7405_fmc_zed [list \
      "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
      "system_top_singlended.v" \
      "system_constr_singlended.xdc" \
      "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

} elseif { $adc_port_type == 1 } {

  adi_project_files ad7405_fmc_zed [list \
      "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
      "system_top_differential.v" \
      "system_constr_differential.xdc" \
      "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

} else {
  return -code error [format "ERROR: Invalid data line type! Define as \'0\' (single ended) or \'1\' (differential) ..."]
}
adi_project_run ad7405_fmc_zed

