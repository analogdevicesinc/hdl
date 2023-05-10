package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create i3c_controller_core {I3C Controller Core}
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files i3c_controller_core [list \
  i3c_controller_core.v \
  i3c_controller_framing.v \
  i3c_controller_daa.v \
  i3c_controller_phy_sda.v \
  i3c_controller_word.v \
  i3c_controller_word_cmd.v \
  i3c_controller_bit_mod.v \
  i3c_controller_bit_mod_cmd.v \
  i3c_controller_quarter_clk.v \
]

# parameters

proc p_elaboration {} {

  # clock and reset interface
  ad_interface clock   clk     input 1
  ad_interface reset   resetn  input 1 if_clk

  ad_interface signal active output 1

  set_interface_property sync associatedClock if_clk
  set_interface_property sync associatedReset if_resetn

  # physical I3C interface
  ad_interface clock scl output 1
  ad_interface signal sda   inout 1
}

