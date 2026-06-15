###############################################################################
## Copyright (C) 2019-2023, 2026 Analog Devices, Inc. All rights reserved.
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

