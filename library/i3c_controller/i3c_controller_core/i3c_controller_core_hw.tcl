###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
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
source ../../scripts/adi_ip_intel.tcl

ad_ip_create i3c_controller_core {I3C Controller Core} p_elaboration
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files i3c_controller_core [list \
  i3c_controller_core.v \
  i3c_controller_framing.v \
  i3c_controller_word.v \
  i3c_controller_word.vh \
  i3c_controller_bit_mod.v \
  i3c_controller_bit_mod.vh \
]

# parameters

ad_ip_parameter MAX_DEVS STRING "MAX_DEVS"
ad_ip_parameter I2C_MOD INTEGER 0

proc p_elaboration {} {

  # read parameters

  set max_devs [get_parameter_value "MAX_DEVS"]
  set i2c_mod [get_parameter_value "I2C_MOD"]

  # clock and reset interface

  ad_interface clock    clk      input 1
  ad_interface reset-n  reset_n  input 1 if_clk

  add_interface sdo axi4stream end
  add_interface_port sdo sdo_ready tready output 1
  add_interface_port sdo sdo_valid tvalid input  1
  add_interface_port sdo sdo       tdata  input  8

  set_interface_property sdo associatedClock if_clk
  set_interface_property sdo associatedReset if_reset_n

  add_interface sdi axi4stream start
  add_interface_port sdi sdi_ready tready input  1
  add_interface_port sdi sdi_valid tvalid output 1
  add_interface_port sdi sdi_last  tlast  output 1
  add_interface_port sdi sdi       tdata  output 8

  set_interface_property sdi associatedClock if_clk
  set_interface_property sdi associatedReset if_reset_n

  add_interface ibi axi4stream start
  add_interface_port ibi ibi_ready tready input  1
  add_interface_port ibi ibi_valid tvalid output 1
  add_interface_port ibi ibi       tdata  output 15

  set_interface_property ibi associatedClock if_clk
  set_interface_property ibi associatedReset if_reset_n

  add_interface cmdp conduit end
  add_interface_port cmdp cmdp_ready       cready      output  1
  add_interface_port cmdp cmdp_valid       cvalid      input   1
  add_interface_port cmdp cmdp             cdata       input  31
  add_interface_port cmdp cmdp_error       error       output  3
  add_interface_port cmdp cmdp_nop         nop         output  1
  add_interface_port cmdp cmdp_daa_trigger daa_trigger output  1

  set_interface_property cmdp associatedClock if_clk
  set_interface_property cmdp associatedReset if_reset_n

  add_interface rmap conduit end
  add_interface_port rmap rmap_ibi_config    ibi_config    input  2
  add_interface_port rmap rmap_pp_sg         pp_sg         input  2
  add_interface_port rmap rmap_dev_char_addr dev_char_addr output 7
  add_interface_port rmap rmap_dev_char_data dev_char_data input  4

  set_interface_property rmap associatedClock if_clk
  set_interface_property rmap associatedReset if_reset_n

  # physical I3C interface

  add_interface i3c conduit end
  add_interface_port i3c i3c_scl scl output 1
  add_interface_port i3c i3c_sdo sdo output 1
  add_interface_port i3c i3c_sdi sdi input  1
  add_interface_port i3c i3c_t   t   output 1

  set_interface_property i3c associatedClock if_clk
  set_interface_property i3c associatedReset if_reset_n
}
