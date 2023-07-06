###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create axi_clock_monitor {axi_clock_monitor} p_axi_clock_monitor

# files
set_module_property NAME axi_clock_monitor

ad_ip_files axi_clock_monitor [list \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  axi_clock_monitor.v \
]

# parameters

add_parameter NUM_OF_CLOCKS INTEGER 0
set_parameter_property NUM_OF_CLOCKS DEFAULT_VALUE 8
set_parameter_property NUM_OF_CLOCKS DISPLAY_NAME NUM_OF_CLOCKS
set_parameter_property NUM_OF_CLOCKS UNITS None
set_parameter_property NUM_OF_CLOCKS HDL_PARAMETER true

# interfaces

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

ad_interface reset   output   1  if_reset

proc p_axi_clock_monitor {} {
  set num_of_clock [get_parameter_value NUM_OF_CLOCKS]

   for {set n 0} {$n < $num_of_clock} {incr n} {
    ad_interface clock  clock_${n}  input   1
  }
}

