

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_jesd_xcvr
set_module_property DESCRIPTION "AXI JESD XCVR Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_jesd_xcvr
set_module_property ELABORATION_CALLBACK p_axi_jesd_xcvr

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_jesd_xcvr
add_fileset_file ad_rst.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_jesd_align.v          VERILOG PATH $ad_hdl_dir/library/common/ad_jesd_align.v
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xcvr.v                VERILOG PATH $ad_hdl_dir/library/common/up_xcvr.v
add_fileset_file axi_jesd_xcvr.v          VERILOG PATH axi_jesd_xcvr.v TOP_LEVEL_FILE
add_fileset_file axi_jesd_xcvr_constr.sdc SDC     PATH axi_jesd_xcvr_constr.sdc

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE INTEGER
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter DEVICE_TYPE INTEGER 0
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 0
set_parameter_property DEVICE_TYPE DISPLAY_NAME DEVICE_TYPE
set_parameter_property DEVICE_TYPE TYPE INTEGER
set_parameter_property DEVICE_TYPE UNITS None
set_parameter_property DEVICE_TYPE HDL_PARAMETER true

add_parameter TX_NUM_OF_LANES INTEGER 0
set_parameter_property TX_NUM_OF_LANES DEFAULT_VALUE 4
set_parameter_property TX_NUM_OF_LANES DISPLAY_NAME TX_NUM_OF_LANES
set_parameter_property TX_NUM_OF_LANES TYPE INTEGER
set_parameter_property TX_NUM_OF_LANES UNITS None
set_parameter_property TX_NUM_OF_LANES HDL_PARAMETER true

add_parameter RX_NUM_OF_LANES INTEGER 0
set_parameter_property RX_NUM_OF_LANES DEFAULT_VALUE 4
set_parameter_property RX_NUM_OF_LANES DISPLAY_NAME RX_NUM_OF_LANES
set_parameter_property RX_NUM_OF_LANES TYPE INTEGER
set_parameter_property RX_NUM_OF_LANES UNITS None
set_parameter_property RX_NUM_OF_LANES HDL_PARAMETER true

# axi4 slave

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

# transceiver interface

ad_alt_intf reset   rst                 output  1 s_axi_clock s_axi_reset

ad_alt_intf clock   rx_clk              input   1
ad_alt_intf reset-n rx_rstn             output  1 if_rx_clk s_axi_reset
ad_alt_intf signal  rx_ext_sysref_in    input   1
ad_alt_intf signal  rx_ext_sysref_out   output  1
ad_alt_intf signal  rx_sync             output  1
ad_alt_intf signal  rx_sof              output  RX_NUM_OF_LANES
ad_alt_intf signal  rx_data             output  RX_NUM_OF_LANES*32  data
ad_alt_intf signal  rx_ready            input   RX_NUM_OF_LANES rx_ready
ad_alt_intf signal  rx_ip_sysref        output  1 export
ad_alt_intf signal  rx_ip_sync          input   1 export
ad_alt_intf signal  rx_ip_sof           input   4 export

add_interface if_rx_ip_avl avalon_streaming sink
add_interface_port if_rx_ip_avl rx_ip_data  data  input RX_NUM_OF_LANES*32
add_interface_port if_rx_ip_avl rx_ip_valid valid input 1
add_interface_port if_rx_ip_avl rx_ip_ready ready output 1

ad_alt_intf clock   tx_clk              input   1
ad_alt_intf reset-n tx_rstn             output  1 if_tx_clk s_axi_reset
ad_alt_intf signal  tx_ext_sysref_in    input   1
ad_alt_intf signal  tx_ext_sysref_out   output  1
ad_alt_intf signal  tx_sync             input   1
ad_alt_intf signal  tx_data             input   TX_NUM_OF_LANES*32  data
ad_alt_intf signal  tx_ready            input   TX_NUM_OF_LANES tx_ready
ad_alt_intf signal  tx_ip_sysref        output  1 export
ad_alt_intf signal  tx_ip_sync          output  1 export

add_interface if_tx_ip_avl avalon_streaming source
add_interface_port if_tx_ip_avl tx_ip_data  data  output TX_NUM_OF_LANES*32
add_interface_port if_tx_ip_avl tx_ip_valid valid output 1
add_interface_port if_tx_ip_avl tx_ip_ready ready input 1

proc p_axi_jesd_xcvr {} {

  set p_num_of_rx_lanes [get_parameter_value "RX_NUM_OF_LANES"]
  set p_num_of_tx_lanes [get_parameter_value "TX_NUM_OF_LANES"]

  set_interface_property if_rx_ip_avl associatedClock if_rx_clk
  set_interface_property if_rx_ip_avl associatedReset if_rx_rstn
  set_interface_property if_rx_ip_avl dataBitsPerSymbol [expr ($p_num_of_rx_lanes*32)]
  
  set_interface_property if_tx_ip_avl associatedClock if_tx_clk
  set_interface_property if_tx_ip_avl associatedReset if_tx_rstn
  set_interface_property if_tx_ip_avl dataBitsPerSymbol [expr ($p_num_of_tx_lanes*32)]
}

