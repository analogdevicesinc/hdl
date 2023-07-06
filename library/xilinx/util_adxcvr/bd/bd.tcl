###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc init {cellpath otherInfo} {
  set ip [get_bd_cells $cellpath]

  bd::mark_propagate_override $ip " \
    XCVR_TYPE CH_HSPMUX PPF0_CFG RXPI_CFG0 RXPI_CFG1 RTX_BUF_CML_CTRL \
    QPLL_LPF RXCDR_CFG3_GEN2 RXCDR_CFG3_GEN3 RXCDR_CFG3_GEN4 TX_PI_BIASSET"

  adi_auto_assign_device_spec $cellpath
}

# auto set parameters defined in auto_set_param_list (adi_xilinx_device_info_enc.tcl)
proc adi_auto_assign_device_spec {cellpath} {

  set ip [get_bd_cells $cellpath]
  set ip_param_list [list_property $ip]
  set ip_path [bd::get_vlnv_dir [get_property VLNV $ip]]

  set parent_dir "../"
  for {set x 1} {$x<=4} {incr x} {
    set linkname ${ip_path}${parent_dir}scripts/adi_xilinx_device_info_enc.tcl
    if { [file exists $linkname] } {
      source ${ip_path}${parent_dir}/scripts/adi_xilinx_device_info_enc.tcl
      break
    }
    append parent_dir "../"
  }

  # Find predefindes auto assignable parameters
  foreach i $auto_set_param_list {
    if { [lsearch $ip_param_list "CONFIG.$i"] > 0 } {
      set val [adi_device_spec $cellpath $i]
      set_property CONFIG.$i $val $ip
    }
  }

  # Find predefindes auto assignable/overwritable parameters
  foreach i $auto_set_param_list_overwritable {
    if { [lsearch $ip_param_list "CONFIG.$i"] > 0 } {
      set val [adi_device_spec $cellpath $i]
      set_property CONFIG.$i $val $ip
    }
  }
}

