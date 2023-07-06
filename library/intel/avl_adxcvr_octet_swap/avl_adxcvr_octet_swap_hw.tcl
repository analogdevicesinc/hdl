###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create avl_adxcvr_octet_swap "avl_adxcvvr_octet_swap helper" avl_adxcvr_octet_swap_elaboration
set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS true
set_module_property HIDE_FROM_QUARTUS true

# files

ad_ip_files avl_adxcvr_octet_swap { \
  avl_adxcvr_octet_swap.v
}

# parameters

ad_ip_parameter NUM_OF_LANES INTEGER 4 true
ad_ip_parameter TX_OR_RX_N INTEGER 0 false

# interfaces

add_interface clock clock end
add_interface_port clock clk clk Input 1

add_interface reset reset end
add_interface_port reset reset reset Input 1
set_interface_property reset associatedClock clock

add_interface in_sof conduit end
add_interface_port in_sof in_sof export Input 4

add_interface out_sof conduit end
add_interface_port out_sof out_sof export Output 4

proc avl_adxcvr_octet_swap_elaboration {} {
  set num_lanes [get_parameter_value NUM_OF_LANES]
  set tx [get_parameter_value TX_OR_RX_N]

  add_interface in avalon_streaming sink
  set_interface_property in associatedClock clock
  set_interface_property in associatedReset reset
  add_interface_port in in_data data input [expr 32*$num_lanes]
  add_interface_port in in_valid valid input 1
  add_interface_port in in_ready ready output 1
  set_interface_property in dataBitsPerSymbol [expr 32*$num_lanes]

  add_interface out avalon_streaming source
  set_interface_property out associatedClock clock
  set_interface_property out associatedReset reset
  add_interface_port out out_data data output [expr 32*$num_lanes]
  add_interface_port out out_valid valid output 1
  add_interface_port out out_ready ready input 1
  set_interface_property out dataBitsPerSymbol [expr 32*$num_lanes]

  if {$tx} {
    set_port_property in_sof TERMINATION true
    set_port_property in_sof TERMINATION_VALUE 0
    set_port_property out_sof TERMINATION true
  }
}
