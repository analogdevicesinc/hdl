

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

ad_alt_intf signal  data          input   CH_CNT*CH_DW
ad_alt_intf signal  split_data_0  output  CH_DW   data

proc p_util_bsplit {} {

  set p_ch_cnt [get_parameter_value "CH_CNT"]
  set p_ch_dw [get_parameter_value "CH_DW"]

  if {[get_parameter_value CH_CNT] > 1} {
    ad_alt_intf signal  split_data_1  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 2} {
    ad_alt_intf signal  split_data_2  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 3} {
    ad_alt_intf signal  split_data_3  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 4} {
    ad_alt_intf signal  split_data_4  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 5} {
    ad_alt_intf signal  split_data_5  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 6} {
    ad_alt_intf signal  split_data_6  output  CH_DW data
  }
  if {[get_parameter_value CH_CNT] > 7} {
    ad_alt_intf signal  split_data_7  output  CH_DW data
  }
}

