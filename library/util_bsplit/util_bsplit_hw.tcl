

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_bsplit
set_module_property DESCRIPTION "Channel Split Utility"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_bsplit
set_module_property ELABORATION_CALLBACK p_util_bsplit

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_bsplit
add_fileset_file util_bsplit.v VERILOG PATH util_bsplit.v TOP_LEVEL_FILE

# parameters

add_parameter CH_DW INTEGER 0
set_parameter_property CH_DW DEFAULT_VALUE 32
set_parameter_property CH_DW DISPLAY_NAME CH_DW
set_parameter_property CH_DW TYPE INTEGER
set_parameter_property CH_DW UNITS None
set_parameter_property CH_DW HDL_PARAMETER true

add_parameter CH_CNT INTEGER 0
set_parameter_property CH_CNT DEFAULT_VALUE 8
set_parameter_property CH_CNT DISPLAY_NAME CH_CNT
set_parameter_property CH_CNT TYPE INTEGER
set_parameter_property CH_CNT UNITS None
set_parameter_property CH_CNT HDL_PARAMETER true

# avalon streaming

add_interface if_clk clock end
add_interface_port if_clk clk clk Input 1

add_interface if_data avalon_streaming end
set_interface_property if_data associatedClock if_clk
add_interface_port if_data data data Input CH_CNT*CH_DW

add_interface if_split_data_0 avalon_streaming start
set_interface_property if_split_data_0 associatedClock if_clk
add_interface_port if_split_data_0 split_data_0 data Output CH_DW

proc p_util_bsplit {} {

  set p_ch_cnt [get_parameter_value "CH_CNT"]
  set p_ch_dw [get_parameter_value "CH_DW"]

  set_interface_property if_data dataBitsPerSymbol [expr $p_ch_cnt*$p_ch_dw]
  set_interface_property if_split_data_0 dataBitsPerSymbol $p_ch_dw

  if {[get_parameter_value CH_CNT] > 1} {
    add_interface if_split_data_1 avalon_streaming start
    set_interface_property if_split_data_1 associatedClock if_clk
    set_interface_property if_split_data_1 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_1 split_data_1 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 2} {
    add_interface if_split_data_2 avalon_streaming start
    set_interface_property if_split_data_2 associatedClock if_clk
    set_interface_property if_split_data_2 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_2 split_data_2 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 3} {
    add_interface if_split_data_3 avalon_streaming start
    set_interface_property if_split_data_3 associatedClock if_clk
    set_interface_property if_split_data_3 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_3 split_data_3 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 4} {
    add_interface if_split_data_4 avalon_streaming start
    set_interface_property if_split_data_4 associatedClock if_clk
    set_interface_property if_split_data_4 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_4 split_data_4 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 5} {
    add_interface if_split_data_5 avalon_streaming start
    set_interface_property if_split_data_5 associatedClock if_clk
    set_interface_property if_split_data_5 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_5 split_data_5 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 6} {
    add_interface if_split_data_6 avalon_streaming start
    set_interface_property if_split_data_6 associatedClock if_clk
    set_interface_property if_split_data_6 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_6 split_data_6 data Output CH_DW
  }
  if {[get_parameter_value CH_CNT] > 7} {
    add_interface if_split_data_7 avalon_streaming start
    set_interface_property if_split_data_7 associatedClock if_clk
    set_interface_property if_split_data_7 dataBitsPerSymbol $p_ch_dw
    add_interface_port if_split_data_7 split_data_7 data Output CH_DW
  }
}

