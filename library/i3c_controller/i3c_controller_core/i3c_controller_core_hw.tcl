package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create i3c_controller_core {I3C Controller Core} p_elaboration
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files i3c_controller_core [list \
  i3c_controller_core.v \
  i3c_controller_framing.v \
  i3c_controller_word.v \
  i3c_controller_word_cmd.v \
  i3c_controller_bit_mod.v \
  i3c_controller_bit_mod_cmd.v \
]

# parameters

ad_ip_parameter SIM_DEVICE STRING "7SERIES"

proc p_elaboration {} {

  # read parameters

  set sim_device [get_parameter_value "SIM_DEVICE"]

  # clock and reset interface

  ad_interface clock   clk     input 1
  ad_interface reset   resetn  input 1 if_clk

  ad_interface signal active output 1

  set_interface_property sync associatedClock if_clk
  set_interface_property sync associatedReset if_resetn

  # physical I3C interface

  ad_interface clock  scl output 1
  ad_interface signal sda inout  1

  # I3C Controller interfaces

  ad_interface clock clk     input 1
  ad_interface reset reset_n output 1 if_clk

  add_interface sdo axi4stream end
  add_interface_port sdo sdo_ready tready input  1
  add_interface_port sdo sdo_valid tvalid output 1
  add_interface_port sdo sdo_data  tdata  output 8

  set_interface_property sdo associatedClock if_clk
  set_interface_property sdo associatedReset if_reset_n

  add_interface sdi axi4stream start
  add_interface_port sdi sdi_ready tready output 1
  add_interface_port sdi sdi_valid tvalid input  1
  add_interface_port sdi sdi_data  tdata  input  8

  set_interface_property sdi associatedClock if_clk
  set_interface_property sdi associatedReset if_reset_n

  add_interface ibi axi4stream start
  add_interface_port ibi ibi_ready tready output 1
  add_interface_port ibi ibi_valid tvalid input  1
  add_interface_port ibi ibi_data  tdata  input  16

  set_interface_property ibi associatedClock if_clk
  set_interface_property ibi associatedReset if_reset_n
}

