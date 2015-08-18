

package require -exact qsys 13.0
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
ad_alt_intf signal  adc_valid       output  1
ad_alt_intf signal  adc_sync        output  1
ad_alt_intf signal  adc_data        output  NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH
ad_alt_intf signal  adc_valid_0     input   1
ad_alt_intf signal  adc_enable_0    input   1
ad_alt_intf signal  adc_data_0      input   CHANNEL_DATA_WIDTH

proc p_util_cpack {} {

  if {[get_parameter_value NUM_OF_CHANNELS] > 1} {
    ad_alt_intf signal  adc_valid_1     input   1
    ad_alt_intf signal  adc_enable_1    input   1
    ad_alt_intf signal  adc_data_1      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 2} {
    ad_alt_intf signal  adc_valid_2     input   1
    ad_alt_intf signal  adc_enable_2    input   1
    ad_alt_intf signal  adc_data_2      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 3} {
    ad_alt_intf signal  adc_valid_3     input   1
    ad_alt_intf signal  adc_enable_3    input   1
    ad_alt_intf signal  adc_data_3      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 4} {
    ad_alt_intf signal  adc_valid_4     input   1
    ad_alt_intf signal  adc_enable_4    input   1
    ad_alt_intf signal  adc_data_4      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 5} {
    ad_alt_intf signal  adc_valid_5     input   1
    ad_alt_intf signal  adc_enable_5    input   1
    ad_alt_intf signal  adc_data_5      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 6} {
    ad_alt_intf signal  adc_valid_6     input   1
    ad_alt_intf signal  adc_enable_6    input   1
    ad_alt_intf signal  adc_data_6      input   CHANNEL_DATA_WIDTH
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 7} {
    ad_alt_intf signal  adc_valid_7     input   1
    ad_alt_intf signal  adc_enable_7    input   1
    ad_alt_intf signal  adc_data_7      input   CHANNEL_DATA_WIDTH
  }
}

