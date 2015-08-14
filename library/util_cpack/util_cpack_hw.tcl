

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME util_cpack
set_module_property DESCRIPTION "Channel Pack Utility"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME util_cpack
set_module_property ELABORATION_CALLBACK p_util_cpack

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL util_cpack
add_fileset_file util_cpack_mux.v   VERILOG PATH util_cpack_mux.v
add_fileset_file util_cpack_dsf.v   VERILOG PATH util_cpack_dsf.v
add_fileset_file util_cpack.v       VERILOG PATH util_cpack.v TOP_LEVEL_FILE

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

# defaults

ad_alt_intf clock   adc_clk         input   1
ad_alt_intf signal  adc_valid       output  1
ad_alt_intf signal  adc_sync        output  1
ad_alt_intf signal  adc_data        output  CH_CNT*CH_DW
ad_alt_intf signal  adc_valid_0     input   1
ad_alt_intf signal  adc_enable_0    input   1
ad_alt_intf signal  adc_data_0      input   CH_DW

add_interface adc_reset reset end
set_interface_property adc_reset associatedClock if_adc_clk
add_interface_port adc_reset adc_rst reset  Input 1

proc p_util_cpack {} {

  if {[get_parameter_value CH_CNT] > 1} {
    ad_alt_intf signal  adc_valid_1     input   1
    ad_alt_intf signal  adc_enable_1    input   1
    ad_alt_intf signal  adc_data_1      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 2} {
    ad_alt_intf signal  adc_valid_2     input   1
    ad_alt_intf signal  adc_enable_2    input   1
    ad_alt_intf signal  adc_data_2      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 3} {
    ad_alt_intf signal  adc_valid_3     input   1
    ad_alt_intf signal  adc_enable_3    input   1
    ad_alt_intf signal  adc_data_3      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 4} {
    ad_alt_intf signal  adc_valid_4     input   1
    ad_alt_intf signal  adc_enable_4    input   1
    ad_alt_intf signal  adc_data_4      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 5} {
    ad_alt_intf signal  adc_valid_5     input   1
    ad_alt_intf signal  adc_enable_5    input   1
    ad_alt_intf signal  adc_data_5      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 6} {
    ad_alt_intf signal  adc_valid_6     input   1
    ad_alt_intf signal  adc_enable_6    input   1
    ad_alt_intf signal  adc_data_6      input   CH_DW
  }
  if {[get_parameter_value CH_CNT] > 7} {
    ad_alt_intf signal  adc_valid_7     input   1
    ad_alt_intf signal  adc_enable_7    input   1
    ad_alt_intf signal  adc_data_7      input   CH_DW
  }
}

