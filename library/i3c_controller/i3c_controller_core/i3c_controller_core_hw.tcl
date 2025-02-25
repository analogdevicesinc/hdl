###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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
