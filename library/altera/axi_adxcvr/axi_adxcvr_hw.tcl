
package require -exact qsys 14.0

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_alt.tcl

set_module_property NAME axi_adxcvr
set_module_property DESCRIPTION "AXI ADXCVR Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_adxcvr
set_module_property ELABORATION_CALLBACK p_axi_adxcvr

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

# axi4 slave interface

add_interface s_axi_clock clock end
add_interface_port s_axi_clock s_axi_aclk clk Input 1

add_interface s_axi_reset reset end
set_interface_property s_axi_reset associatedClock s_axi_clock
add_interface_port s_axi_reset s_axi_aresetn reset_n Input 1

add_interface s_axi axi4lite end
set_interface_property s_axi associatedClock s_axi_clock
set_interface_property s_axi associatedReset s_axi_reset
add_interface_port s_axi s_axi_awvalid awvalid Input 1
add_interface_port s_axi s_axi_awaddr awaddr Input 16
add_interface_port s_axi s_axi_awprot awprot Input 3
add_interface_port s_axi s_axi_awready awready Output 1
add_interface_port s_axi s_axi_wvalid wvalid Input 1
add_interface_port s_axi s_axi_wdata wdata Input 32
add_interface_port s_axi s_axi_wstrb wstrb Input 4
add_interface_port s_axi s_axi_wready wready Output 1
add_interface_port s_axi s_axi_bvalid bvalid Output 1
add_interface_port s_axi s_axi_bresp bresp Output 2
add_interface_port s_axi s_axi_bready bready Input 1
add_interface_port s_axi s_axi_arvalid arvalid Input 1
add_interface_port s_axi s_axi_araddr araddr Input 16
add_interface_port s_axi s_axi_arprot arprot Input 3
add_interface_port s_axi s_axi_arready arready Output 1
add_interface_port s_axi s_axi_rvalid rvalid Output 1
add_interface_port s_axi s_axi_rresp rresp Output 2
add_interface_port s_axi s_axi_rdata rdata Output 32
add_interface_port s_axi s_axi_rready rready Input 1

# xcvr interface

ad_alt_intf reset up_rst output 1 s_axi_clock
set_interface_property if_up_rst associatedResetSinks s_axi_reset

add_interface core_pll_locked conduit end
add_interface_port core_pll_locked up_pll_locked export Input 1

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

