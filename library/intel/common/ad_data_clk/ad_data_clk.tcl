
package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create ad_data_clk {ad_data_clk} p_ad_data_clk
set_module_property VALIDATION_CALLBACK info_param_validate

# parameters

ad_ip_files ad_data_clk [list\
  ad_data_clk.v]

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter SINGLE_ENDED INTEGER 0 false

set_parameter_property SINGLE_ENDED ALLOWED_RANGES {0 1}

adi_add_auto_fpga_spec_params

ad_interface signal rst input 1
ad_interface signal locked output 1

ad_interface clock delay_clk input 1
ad_interface clock l_clk output 1
ad_interface clock clk input 1

proc p_ad_data_clk {} {

  set m_device_family [get_parameter_value "DEVICE_FAMILY"]
  set m_single_ended [get_parameter_value "SINGLE_ENDED"]

  add_hdl_instance clk_buffer altclkctrl 19.1
  set_instance_parameter_value clk_buffer {DEVICE_FAMILY} $m_device_family
}

