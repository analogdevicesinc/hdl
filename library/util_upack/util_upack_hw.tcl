
package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

ad_ip_create util_upack {Channel Unpack Utility} util_upack_elab
ad_ip_files util_upack [list\
  util_upack_dmx.v \
  util_upack_dsf.v \
  util_upack.v]

# parameters

ad_ip_parameter CHANNEL_DATA_WIDTH INTEGER 32
ad_ip_parameter NUM_OF_CHANNELS INTEGER 8

# defaults

ad_alt_intf clock dac_clk input 1
ad_alt_intf signal dac_valid output 1 valid
ad_alt_intf signal dac_sync output 1 sync
ad_alt_intf signal dac_data input NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH data

for {set n 0} {$n < 8} {incr n} {
  add_interface dac_ch_${n} conduit end
  add_interface_port dac_ch_${n} dac_enable_${n} enable Input 1
  add_interface_port dac_ch_${n} dac_valid_${n} valid Input 1
  add_interface_port dac_ch_${n} dac_valid_out_${n} data_valid Output 1
  add_interface_port dac_ch_${n} dac_data_${n} data Output CHANNEL_DATA_WIDTH
  set_interface_property dac_ch_${n} associatedClock if_dac_clk
  set_interface_property dac_ch_${n} associatedReset none
}

proc util_upack_elab {} {
  set num_channels [get_parameter_value NUM_OF_CHANNELS]

  for {set n 1} {$n < 8} {incr n} {
    if {$n >= $num_channels} {
      set_interface_property dac_ch_${n} ENABLED false
    }
  }
}

