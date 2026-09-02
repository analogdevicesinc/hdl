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
