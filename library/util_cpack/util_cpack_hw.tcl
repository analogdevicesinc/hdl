

package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_cpack
set_module_property DESCRIPTION "Channel Pack Utility"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_cpack
set_module_property ELABORATION_CALLBACK p_util_cpack

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_cpack
add_fileset_file util_cpack_mux.v   VERILOG PATH util_cpack_mux.v
add_fileset_file util_cpack_dsf.v   VERILOG PATH util_cpack_dsf.v
add_fileset_file util_cpack.v       VERILOG PATH util_cpack.v TOP_LEVEL_FILE

# parameters

add_parameter CHANNEL_DATA_WIDTH INTEGER 0
set_parameter_property CHANNEL_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property CHANNEL_DATA_WIDTH DISPLAY_NAME CHANNEL_DATA_WIDTH
set_parameter_property CHANNEL_DATA_WIDTH TYPE INTEGER
set_parameter_property CHANNEL_DATA_WIDTH UNITS None
set_parameter_property CHANNEL_DATA_WIDTH HDL_PARAMETER true

add_parameter NUM_OF_CHANNELS INTEGER 0
set_parameter_property NUM_OF_CHANNELS DEFAULT_VALUE 8
set_parameter_property NUM_OF_CHANNELS DISPLAY_NAME NUM_OF_CHANNELS
set_parameter_property NUM_OF_CHANNELS TYPE INTEGER
set_parameter_property NUM_OF_CHANNELS UNITS None
set_parameter_property NUM_OF_CHANNELS HDL_PARAMETER true

# defaults

ad_alt_intf clock   adc_clk         input   1
ad_alt_intf reset   adc_rst         input   1  if_adc_clk

ad_alt_intf signal  adc_valid       output  1  valid
ad_alt_intf signal  adc_sync        output  1  sync
ad_alt_intf signal  adc_data        output  NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH  data

for {set n 0} {$n < 8} {incr n} {
  add_interface adc_ch_${n} conduit end
  add_interface_port adc_ch_${n}  adc_enable_${n}  enable   Input  1
  add_interface_port adc_ch_${n}  adc_valid_${n}   valid    Input  1
  add_interface_port adc_ch_${n}  adc_data_${n}    data     Input  CHANNEL_DATA_WIDTH

  set_interface_property adc_ch_${n}  associatedClock if_adc_clk
  set_interface_property adc_ch_${n}  associatedReset none
}

proc p_util_cpack {} {
  set num_channels [get_parameter_value NUM_OF_CHANNELS]

  for {set n 1} {$n < 8} {incr n} {
    if {$n >= $num_channels} {
      set_interface_property adc_ch_${n} ENABLED false
    }
  }

}

