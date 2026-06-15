###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

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
      set clk1_out [get_bd_pins "$ip/clk_1"]
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
