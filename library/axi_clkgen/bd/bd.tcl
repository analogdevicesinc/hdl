## ***************************************************************************
## ***************************************************************************
## Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
##
## In this HDL repository, there are many different and unique modules, consisting
## of various HDL (Verilog or VHDL) components. The individual modules are
## developed independently, and may be accompanied by separate and unique license
## terms.
##
## The user should read each of these license terms, and understand the
## freedoms and responsibilities that he or she has by using this source/core.
##
## This core is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
## A PARTICULAR PURPOSE.
##
## Redistribution and use of source or resulting binaries, with or without modification
## of this file, are permitted under one of the following two license terms:
##
##   1. The GNU General Public License version 2 as published by the
##      Free Software Foundation, which can be found in the top level directory
##      of this repository (LICENSE_GPL2), and also online at:
##      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
##
## OR
##
##   2. An ADI specific BSD license, which can be found in the top level directory
##      of this repository (LICENSE_ADIBSD), and also on-line at:
##      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
##      This will allow to generate bit files and not release the source code,
##      as long as it attaches to an ADI device.
##
## ***************************************************************************
## ***************************************************************************

proc init {cellpath otherInfo} {
  set ip [get_bd_cells $cellpath]

  bd::mark_propagate_override $ip \
    "CLKIN_PERIOD \
     CLKIN2_PERIOD \
     FPGA_VOLTAGE"

  bd::mark_propagate_only $ip \
    "FPGA_TECHNOLOGY \
     FPGA_FAMILY \
     SPEED_GRADE \
     DEV_PACKAGE \
     FPGA_VOLTAGE"

  adi_auto_assign_device_spec $cellpath
}

proc axi_clkgen_get_infer_period {ip param clk_name} {
  set param_src [get_property "CONFIG.$param.VALUE_SRC" $ip]
  if {[string equal $param_src "USER"]} {
    return;
  }

  set clk [get_bd_pins "$ip/$clk_name"]
  set clk_freq [get_property CONFIG.FREQ_HZ $clk]

  if {$clk_freq != {}} {
    set clk_period [expr 1000000000.0 / $clk_freq]
    set_property "CONFIG.$param" [format "%.6f" $clk_period] $ip
  }
}

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

proc propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  set vco_mul [get_property CONFIG.VCO_MUL $ip]
  set vco_div [get_property CONFIG.VCO_DIV $ip]
  set clk0_div [get_property CONFIG.CLK0_DIV $ip]
  set clk1_div [get_property CONFIG.CLK1_DIV $ip]

  if {$vco_mul == {} || $vco_mul < 1} {
    set vco_mul 1
  }
  if {$vco_div == {} || $vco_div < 1} {
    set vco_div 1
  }
  if {$clk0_div == {} || $clk0_div < 1} {
    set clk0_div 1
  }
  if {$clk1_div == {} || $clk0_div < 1} {
    set clk1_div 1
  }

  set clk [get_bd_pins "$ip/clk"]
  set clk_freq [get_property CONFIG.FREQ_HZ $clk]
  if {[get_property "CONFIG.ENABLE_CLKIN2" $ip] == "true"} {
    set clk2 [get_bd_pins "$ip/clk"]
    set clk2_freq [get_property CONFIG.FREQ_HZ $clk2]
    # Use the larger of the two
    if {$clk_freq == {} || $clk2_freq > $clk_freq} {
      set clk_freq $clk2_freq
    }
  }

  if {$clk_freq != {}} {
    set clk0_out [get_bd_pins "$ip/clk_0"]
    set clk0_out_freq [expr ($clk_freq + 0.0) * $vco_mul / ($vco_div * $clk0_div)]
    set_property CONFIG.FREQ_HZ $clk0_out_freq $clk0_out

    if {[get_property "CONFIG.ENABLE_CLKOUT1" $ip] == "true"} {
      set clk0_out [get_bd_pins "$ip/clk_1"]
      set clk1_out_freq [expr ($clk_freq + 0.0) * $vco_mul / ($vco_div * $clk1_div)]
      set_property CONFIG.FREQ_HZ $clk1_out_freq $clk1_out
    }
  }
}

proc post_propagate {cellpath otherinfo} {
  set ip [get_bd_cells $cellpath]

  axi_clkgen_get_infer_period $ip CLKIN_PERIOD clk
  if {[get_property "CONFIG.ENABLE_CLKIN2" $ip] == "true"} {
    axi_clkgen_get_infer_period $ip CLKIN2_PERIOD clk2
  }
}
