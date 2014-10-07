
package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME util_adc_pack
set_module_property DESCRIPTION "Util ADC data packager"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_adc_pack
set_module_property ELABORATION_CALLBACK util_adc_pack_elaborate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_adc_pack
add_fileset_file util_adc_pack.v   VERILOG PATH util_adc_pack.v

# parameters

add_parameter CHANNELS INTEGER 0
set_parameter_property CHANNELS DEFAULT_VALUE 8
set_parameter_property CHANNELS ALLOWED_RANGES {4 8}
set_parameter_property CHANNELS DESCRIPTION "Valid values are 4 and 8"
set_parameter_property CHANNELS DISPLAY_NAME CHANNELS
set_parameter_property CHANNELS TYPE INTEGER
set_parameter_property CHANNELS UNITS None
set_parameter_property CHANNELS HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 0
set_parameter_property DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property DATA_WIDTH ALLOWED_RANGES {16 32}
set_parameter_property DATA_WIDTH DESCRIPTION "Valid values are 16 and 32"
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_interface data_clock clock end
add_interface_port data_clock clk clk Input 1

add_interface channels_data conduit end
set_interface_property channels_data associatedClock data_clock
add_interface_port channels_data chan_enable_0 chan_enable_0 Input 1
add_interface_port channels_data chan_valid_0 chan_valid_0 Input 1
add_interface_port channels_data chan_data_0 chan_data_0 Input DATA_WIDTH

add_interface_port channels_data chan_enable_1 chan_enable_1 Input 1
add_interface_port channels_data chan_valid_1 chan_valid_1 Input 1
add_interface_port channels_data chan_data_1 chan_data_1 Input DATA_WIDTH

add_interface_port channels_data chan_enable_2 chan_enable_2 Input 1
add_interface_port channels_data chan_valid_2 chan_valid_2 Input 1
add_interface_port channels_data chan_data_2 chan_data_2 Input DATA_WIDTH

add_interface_port channels_data chan_enable_3 chan_enable_3 Input 1
add_interface_port channels_data chan_valid_3 chan_valid_3 Input 1
add_interface_port channels_data chan_data_3 chan_data_3 Input DATA_WIDTH

proc util_adc_pack_elaborate {} {

  set DW [ get_parameter_value DATA_WIDTH ]
  set CHAN [ get_parameter_value CHANNELS ]
  add_interface_port channels_data dvalid dvalid Output 1
  add_interface_port channels_data dsync dsync Output 1
  add_interface_port channels_data ddata ddata Output [expr {$DW * $CHAN}]

  if {[get_parameter_value CHANNELS] == 8} {

    add_interface_port channels_data chan_enable_4 chan_enable_4 Input 1
    add_interface_port channels_data chan_valid_4 chan_valid_4 Input 1
    add_interface_port channels_data chan_data_4 chan_data_4 Input DATA_WIDTH

    add_interface_port channels_data chan_enable_5 chan_enable_5 Input 1
    add_interface_port channels_data chan_valid_5 chan_valid_5 Input 1
    add_interface_port channels_data chan_data_5 chan_data_5 Input DATA_WIDTH

    add_interface_port channels_data chan_enable_6 chan_enable_6 Input 1
    add_interface_port channels_data chan_valid_6 chan_valid_6 Input 1
    add_interface_port channels_data chan_data_6 chan_data_6 Input DATA_WIDTH

    add_interface_port channels_data chan_enable_7 chan_enable_7 Input 1
    add_interface_port channels_data chan_valid_7 chan_valid_7 Input 1
    add_interface_port channels_data chan_data_7 chan_data_7 Input DATA_WIDTH
}

}

