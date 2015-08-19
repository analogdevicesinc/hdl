

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_upack
set_module_property DESCRIPTION "Channel Pack Utility"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_upack
set_module_property ELABORATION_CALLBACK p_util_upack

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_upack
add_fileset_file util_upack_dmx.v   VERILOG PATH util_upack_dmx.v
add_fileset_file util_upack_dsf.v   VERILOG PATH util_upack_dsf.v
add_fileset_file util_upack.v       VERILOG PATH util_upack.v TOP_LEVEL_FILE

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

ad_alt_intf clock   dac_clk         input   1
ad_alt_intf signal  dma_xfer_in     input   1
ad_alt_intf signal  dac_xfer_out    output  1
ad_alt_intf signal  dac_valid       output  1
ad_alt_intf signal  dac_sync        output  1
ad_alt_intf signal  dac_data        input   NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH
ad_alt_intf signal  dac_enable_0    input   1
ad_alt_intf signal  dac_valid_0     input   1
ad_alt_intf signal  dac_data_0      output  CHANNEL_DATA_WIDTH
ad_alt_intf signal  upack_valid_0   output  1

proc p_util_upack {} {

  if {[get_parameter_value NUM_OF_CHANNELS] > 1} {
    ad_alt_intf signal  dac_enable_1    input   1
    ad_alt_intf signal  dac_valid_1     input   1
    ad_alt_intf signal  dac_data_1      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_1   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 2} {
    ad_alt_intf signal  dac_enable_2    input   1
    ad_alt_intf signal  dac_valid_2     input   1
    ad_alt_intf signal  dac_data_2      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_2   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 3} {
    ad_alt_intf signal  dac_enable_3    input   1
    ad_alt_intf signal  dac_valid_3     input   1
    ad_alt_intf signal  dac_data_3      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_3   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 4} {
    ad_alt_intf signal  dac_enable_4    input   1
    ad_alt_intf signal  dac_valid_4     input   1
    ad_alt_intf signal  dac_data_4      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_4   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 5} {
    ad_alt_intf signal  dac_enable_5    input   1
    ad_alt_intf signal  dac_valid_5     input   1
    ad_alt_intf signal  dac_data_5      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_5   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 6} {
    ad_alt_intf signal  dac_enable_6    input   1
    ad_alt_intf signal  dac_valid_6     input   1
    ad_alt_intf signal  dac_data_6      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_6   output  1
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 7} {
    ad_alt_intf signal  dac_enable_7    input   1
    ad_alt_intf signal  dac_valid_7     input   1
    ad_alt_intf signal  dac_data_7      output  CHANNEL_DATA_WIDTH
    ad_alt_intf signal  upack_valid_7   output  1
  }
}

