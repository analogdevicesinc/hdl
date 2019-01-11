
proc init {cellpath otherInfo} {
  set ip [get_bd_cells $cellpath]

  bd::mark_propagate_only $ip " \
    FPGA_TECHNOLOGY \
    FPGA_FAMILY \
    SPEED_GRADE \
    DEV_PACKAGE"

  set ip_path [bd::get_vlnv_dir [get_property VLNV $ip]]
  source ${ip_path}../scripts/common_bd.tcl

  adi_auto_assign_device_spec $cellpath
}

