

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

ad_alt_intf signal  adc_valid       output  1  valid
ad_alt_intf signal  adc_sync        output  1  sync
ad_alt_intf signal  adc_data        output  NUM_OF_CHANNELS*CHANNEL_DATA_WIDTH  data

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0  adc_enable_0  enable   Input  1
add_interface_port adc_ch_0  adc_valid_0   valid    Input  1
add_interface_port adc_ch_0  adc_data_0    data     Input  CHANNEL_DATA_WIDTH

set_interface_property adc_ch_0  associatedClock if_adc_clk
set_interface_property adc_ch_0  associatedReset none

proc p_util_cpack {} {

  if {[get_parameter_value NUM_OF_CHANNELS] > 1} {

    add_interface adc_ch_1 conduit end
    add_interface_port adc_ch_1  adc_enable_1 enable   Input  1
    add_interface_port adc_ch_1  adc_valid_1  valid    Input  1
    add_interface_port adc_ch_1  adc_data_1   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_1  associatedClock if_adc_clk
    set_interface_property adc_ch_1  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 2} {

    add_interface adc_ch_2 conduit end
    add_interface_port adc_ch_2  adc_enable_2 enable   Input  1
    add_interface_port adc_ch_2  adc_valid_2  valid    Input  1
    add_interface_port adc_ch_2  adc_data_2   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_2  associatedClock if_adc_clk
    set_interface_property adc_ch_2  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 3} {

    add_interface adc_ch_3 conduit end
    add_interface_port adc_ch_3  adc_enable_3 enable   Input  1
    add_interface_port adc_ch_3  adc_valid_3  valid    Input  1
    add_interface_port adc_ch_3  adc_data_3   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_3  associatedClock if_adc_clk
    set_interface_property adc_ch_3  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 4} {

    add_interface adc_ch_4 conduit end
    add_interface_port adc_ch_4  adc_enable_4 enable   Input  1
    add_interface_port adc_ch_4  adc_valid_4  valid    Input  1
    add_interface_port adc_ch_4  adc_data_4   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_4  associatedClock if_adc_clk
    set_interface_property adc_ch_4  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 5} {

    add_interface adc_ch_5 conduit end
    add_interface_port adc_ch_5  adc_enable_5 enable   Input  1
    add_interface_port adc_ch_5  adc_valid_5  valid    Input  1
    add_interface_port adc_ch_5  adc_data_5   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_5  associatedClock if_adc_clk
    set_interface_property adc_ch_5  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 6} {

    add_interface adc_ch_6 conduit end
    add_interface_port adc_ch_6  adc_enable_6 enable   Input  1
    add_interface_port adc_ch_6  adc_valid_6  valid    Input  1
    add_interface_port adc_ch_6  adc_data_6   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_6  associatedClock if_adc_clk
    set_interface_property adc_ch_6  associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 7} {

    add_interface adc_ch_7 conduit end
    add_interface_port adc_ch_7  adc_enable_7 enable   Input  1
    add_interface_port adc_ch_7  adc_valid_7  valid    Input  1
    add_interface_port adc_ch_7  adc_data_7   data     Input  CHANNEL_DATA_WIDTH

    set_interface_property adc_ch_7  associatedClock if_adc_clk
    set_interface_property adc_ch_7  associatedReset none
  }
}

