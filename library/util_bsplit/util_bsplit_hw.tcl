###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl


set_module_property NAME util_bsplit
set_module_property DESCRIPTION "Channel Split Utility"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_bsplit
set_module_property ELABORATION_CALLBACK p_util_bsplit

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_bsplit
add_fileset_file util_bsplit.v VERILOG PATH util_bsplit.v TOP_LEVEL_FILE

# parameters

add_parameter CHANNEL_DATA_WIDTH INTEGER 0
set_parameter_property CHANNEL_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property CHANNEL_DATA_WIDTH DISPLAY_NAME CHANNEL_DATA_WIDTH
set_parameter_property CHANNEL_DATA_WIDTH UNITS None
set_parameter_property CHANNEL_DATA_WIDTH HDL_PARAMETER true

add_parameter NUM_OF_CHANNELS INTEGER 0
set_parameter_property NUM_OF_CHANNELS DEFAULT_VALUE 8
set_parameter_property NUM_OF_CHANNELS DISPLAY_NAME NUM_OF_CHANNELS
set_parameter_property NUM_OF_CHANNELS UNITS None
set_parameter_property NUM_OF_CHANNELS HDL_PARAMETER true

# avalon streaming

ad_interface signal  data          input   NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH
ad_interface signal  split_data_0  output  CHANNEL_DATA_WIDTH   data

proc p_util_bsplit {} {

  set p_ch_cnt [get_parameter_value "NUM_OF_CHANNELS"]
  set p_ch_dw [get_parameter_value "CHANNEL_DATA_WIDTH"]

  if {[get_parameter_value NUM_OF_CHANNELS] > 1} {
    ad_interface signal  split_data_1  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 2} {
    ad_interface signal  split_data_2  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 3} {
    ad_interface signal  split_data_3  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 4} {
    ad_interface signal  split_data_4  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 5} {
    ad_interface signal  split_data_5  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 6} {
    ad_interface signal  split_data_6  output  CHANNEL_DATA_WIDTH data
  }
  if {[get_parameter_value NUM_OF_CHANNELS] > 7} {
    ad_interface signal  split_data_7  output  CHANNEL_DATA_WIDTH data
  }
}

