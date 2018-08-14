
package require qsys
package require quartus::device

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

set_module_property NAME axi_adxcvr
set_module_property DESCRIPTION "AXI ADXCVR Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_adxcvr
set_module_property ELABORATION_CALLBACK p_axi_adxcvr
set_module_property VALIDATION_CALLBACK info_param_validate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL axi_adxcvr
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file axi_adxcvr_up.v          VERILOG PATH axi_adxcvr_up.v
add_fileset_file axi_adxcvr.v             VERILOG PATH axi_adxcvr.v TOP_LEVEL_FILE

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE INTEGER
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter TX_OR_RX_N INTEGER 0
set_parameter_property TX_OR_RX_N DISPLAY_NAME TX_OR_RX_N
set_parameter_property TX_OR_RX_N TYPE INTEGER
set_parameter_property TX_OR_RX_N UNITS None
set_parameter_property TX_OR_RX_N HDL_PARAMETER true

add_parameter NUM_OF_LANES INTEGER 4
set_parameter_property NUM_OF_LANES DISPLAY_NAME NUM_OF_LANES
set_parameter_property NUM_OF_LANES TYPE INTEGER
set_parameter_property NUM_OF_LANES UNITS None
set_parameter_property NUM_OF_LANES HDL_PARAMETER true

adi_add_auto_fpga_spec_params

adi_add_device_spec_param XCVR_TYPE
adi_add_device_spec_param FPGA_VOLTAGE
set_parameter_property FPGA_VOLTAGE DISPLAY_UNITS mV
set_parameter_property FPGA_VOLTAGE_MANUAL DISPLAY_UNITS mV
adi_add_indep_spec_params_overwrite XCVR_TYPE
adi_add_indep_spec_params_overwrite FPGA_VOLTAGE

# axi4 slave interface

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 12

# xcvr interface

ad_interface reset up_rst output 1 s_axi_clock
set_interface_property if_up_rst associatedResetSinks s_axi_reset

add_interface core_pll_locked conduit end
add_interface_port core_pll_locked up_pll_locked pll_locked Input 1

# name changes

proc p_axi_adxcvr {} {

  set m_tx_or_rx_n [get_parameter_value TX_OR_RX_N]
  set m_num_of_lanes [get_parameter_value NUM_OF_LANES]

  if {$m_tx_or_rx_n == 1} {
    add_interface ready conduit end
    add_interface_port ready up_ready tx_ready input $m_num_of_lanes
  }

  if {$m_tx_or_rx_n == 0} {
    add_interface ready conduit end
    add_interface_port ready up_ready rx_ready input $m_num_of_lanes
  }
}

