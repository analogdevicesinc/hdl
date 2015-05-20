

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_jesd_align
set_module_property DESCRIPTION "JESD Align Utility"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_jesd_align
set_module_property ELABORATION_CALLBACK p_util_jesd_align

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_jesd_align
add_fileset_file ad_jesd_align.v         VERILOG PATH $ad_hdl_dir/library/common/altera/ad_jesd_align.v
add_fileset_file util_jesd_align.v       VERILOG PATH util_jesd_align.v TOP_LEVEL_FILE

# parameters

add_parameter NUM_OF_LANES INTEGER 0
set_parameter_property NUM_OF_LANES DEFAULT_VALUE 2
set_parameter_property NUM_OF_LANES DISPLAY_NAME NUM_OF_LANES
set_parameter_property NUM_OF_LANES TYPE INTEGER
set_parameter_property NUM_OF_LANES UNITS None
set_parameter_property NUM_OF_LANES HDL_PARAMETER true

# transceiver interface

add_interface if_rx_clk clock end
add_interface_port if_rx_clk rx_clk clk Input 1

add_interface if_rx_ip_data avalon_streaming end
add_interface_port if_rx_ip_data rx_ip_data data Input 32*NUM_OF_LANES

add_interface if_rx_data avalon_streaming start
add_interface_port if_rx_data rx_data data Output 32*NUM_OF_LANES

ad_alt_intf signal rx_ip_sof input 4 export
ad_alt_intf signal rx_sof output NUM_OF_LANES export

proc p_util_jesd_align {} {

  set p_num_of_lanes [get_parameter_value "NUM_OF_LANES"]
  set_interface_property if_rx_ip_data associatedClock if_rx_clk
  set_interface_property if_rx_ip_data dataBitsPerSymbol [expr (32*$p_num_of_lanes)]
  set_interface_property if_rx_data associatedClock if_rx_clk
  set_interface_property if_rx_data dataBitsPerSymbol [expr (32*$p_num_of_lanes)]
}
