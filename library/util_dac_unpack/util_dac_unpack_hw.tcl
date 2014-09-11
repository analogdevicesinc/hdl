
package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME util_dac_unpack
set_module_property DESCRIPTION "Util DAC data unpacker"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_dac_unpack

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_dac_unpack
add_fileset_file util_dac_unpack.v   VERILOG PATH util_dac_unpack.v

add_interface data_clock clock end
add_interface_port data_clock clk clk Input 1

add_interface channels_data conduit end
set_interface_property channels_data associatedClock data_clock
add_interface_port channels_data dac_enable_00 dac_enable_00 Input 1
add_interface_port channels_data dac_valid_00 dac_valid_00 Input 1
add_interface_port channels_data dac_data_00 dac_data_00 Output 16

add_interface_port channels_data dac_enable_01 dac_enable_01 Input 1
add_interface_port channels_data dac_valid_01  dac_valid_01 Input 1
add_interface_port channels_data dac_data_01   dac_data_01 Output 16

add_interface_port channels_data dac_enable_02 dac_enable_02 Input 1
add_interface_port channels_data dac_valid_02 dac_valid_02 Input 1
add_interface_port channels_data dac_data_02 dac_data_02 Input 16

add_interface_port channels_data dac_enable_03 dac_enable_03 Input 1
add_interface_port channels_data dac_valid_03 dac_valid_03 Input 1
add_interface_port channels_data dac_data_03 dac_data_03 Input 16

add_interface_port channels_data dac_enable_04 dac_enable_04 Input 1
add_interface_port channels_data dac_valid_04 dac_valid_04 Input 1
add_interface_port channels_data dac_data_04 dac_data_04 Input 16

add_interface_port channels_data dac_enable_05 dac_enable_05 Input 1
add_interface_port channels_data dac_valid_05 dac_valid_05 Input 1
add_interface_port channels_data dac_data_05 dac_data_05 Input 16

add_interface_port channels_data dac_enable_06 dac_enable_06 Input 1
add_interface_port channels_data dac_valid_06 dac_valid_06 Input 1
add_interface_port channels_data dac_data_06 dac_data_06 Input 16

add_interface_port channels_data dac_enable_07 dac_enable_07 Input 1
add_interface_port channels_data dac_valid_07 dac_valid_07 Input 1
add_interface_port channels_data dac_data_07 dac_data_07 Input 16

add_interface_port channels_data fifo_valid fifo_valid Input 1
add_interface_port channels_data dma_rd dma_rd Output 1
add_interface_port channels_data dma_data dma_data Input 128

