
package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME util_dac_unpack
set_module_property DESCRIPTION "Util DAC data unpacker"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_dac_unpack
set_module_property ELABORATION_CALLBACK util_dac_unpack_elaborate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_dac_unpack
add_fileset_file util_dac_unpack.v   VERILOG PATH util_dac_unpack.v

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
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_interface data_clock clock end
add_interface_port data_clock clk clk Input 1

proc util_dac_unpack_elaborate {} {
  set DW [ get_parameter_value DATA_WIDTH ]
  set CHAN [ get_parameter_value CHANNELS ]

  add_interface channels_data conduit end
  set_interface_property channels_data associatedClock data_clock
  add_interface_port channels_data dac_enable_00 dac_enable_00 Input 1
  add_interface_port channels_data dac_valid_00 dac_valid_00 Input 1
  add_interface_port channels_data dac_data_00 dac_data_00 Output DATA_WIDTH

  add_interface_port channels_data dac_enable_01 dac_enable_01 Input 1
  add_interface_port channels_data dac_valid_01  dac_valid_01 Input 1
  add_interface_port channels_data dac_data_01   dac_data_01 Output DATA_WIDTH

  add_interface_port channels_data dac_enable_02 dac_enable_02 Input 1
  add_interface_port channels_data dac_valid_02 dac_valid_02 Input 1
  add_interface_port channels_data dac_data_02 dac_data_02 Output DATA_WIDTH

  add_interface_port channels_data dac_enable_03 dac_enable_03 Input 1
  add_interface_port channels_data dac_valid_03 dac_valid_03 Input 1
  add_interface_port channels_data dac_data_03 dac_data_03 Output DATA_WIDTH

  if {$CHAN == 8} {
    add_interface_port channels_data dac_enable_04 dac_enable_04 Input 1
    add_interface_port channels_data dac_valid_04 dac_valid_04 Input 1
    add_interface_port channels_data dac_data_04 dac_data_04 Output DATA_WIDTH

    add_interface_port channels_data dac_enable_05 dac_enable_05 Input 1
    add_interface_port channels_data dac_valid_05 dac_valid_05 Input 1
    add_interface_port channels_data dac_data_05 dac_data_05 Output DATA_WIDTH

    add_interface_port channels_data dac_enable_06 dac_enable_06 Input 1
    add_interface_port channels_data dac_valid_06 dac_valid_06 Input 1
    add_interface_port channels_data dac_data_06 dac_data_06 Output DATA_WIDTH

    add_interface_port channels_data dac_enable_07 dac_enable_07 Input 1
    add_interface_port channels_data dac_valid_07 dac_valid_07 Input 1
    add_interface_port channels_data dac_data_07 dac_data_07 Output DATA_WIDTH
  }

  add_interface_port channels_data fifo_valid fifo_valid Input 1
  add_interface_port channels_data dma_rd dma_rd Output 1
  add_interface_port channels_data dma_data dma_data Input [expr {$DW * $CHAN}]
}

