

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_jesd_xcvr
set_module_property DESCRIPTION "AXI JESD XCVR Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_jesd_xcvr

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_jesd_xcvr
add_fileset_file ad_rst.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_jesd_align.v          VERILOG PATH $ad_hdl_dir/library/common/altera/ad_jesd_align.v
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xcvr.v                VERILOG PATH $ad_hdl_dir/library/common/up_xcvr.v
add_fileset_file axi_jesd_xcvr.v          VERILOG PATH axi_jesd_xcvr.v TOP_LEVEL_FILE
add_fileset_file axi_jesd_xcvr_constr.sdc SDC     PATH axi_jesd_xcvr_constr.sdc

# parameters

add_parameter PCORE_ID INTEGER 0
set_parameter_property PCORE_ID DEFAULT_VALUE 0
set_parameter_property PCORE_ID DISPLAY_NAME PCORE_ID
set_parameter_property PCORE_ID TYPE INTEGER
set_parameter_property PCORE_ID UNITS None
set_parameter_property PCORE_ID HDL_PARAMETER true

add_parameter PCORE_DEVICE_TYPE INTEGER 0
set_parameter_property PCORE_DEVICE_TYPE DEFAULT_VALUE 0
set_parameter_property PCORE_DEVICE_TYPE DISPLAY_NAME PCORE_DEVICE_TYPE
set_parameter_property PCORE_DEVICE_TYPE TYPE INTEGER
set_parameter_property PCORE_DEVICE_TYPE UNITS None
set_parameter_property PCORE_DEVICE_TYPE HDL_PARAMETER true

add_parameter PCORE_NUM_OF_TX_LANES INTEGER 0
set_parameter_property PCORE_NUM_OF_TX_LANES DEFAULT_VALUE 4
set_parameter_property PCORE_NUM_OF_TX_LANES DISPLAY_NAME PCORE_NUM_OF_TX_LANES
set_parameter_property PCORE_NUM_OF_TX_LANES TYPE INTEGER
set_parameter_property PCORE_NUM_OF_TX_LANES UNITS None
set_parameter_property PCORE_NUM_OF_TX_LANES HDL_PARAMETER true

add_parameter PCORE_NUM_OF_RX_LANES INTEGER 0
set_parameter_property PCORE_NUM_OF_RX_LANES DEFAULT_VALUE 4
set_parameter_property PCORE_NUM_OF_RX_LANES DISPLAY_NAME PCORE_NUM_OF_RX_LANES
set_parameter_property PCORE_NUM_OF_RX_LANES TYPE INTEGER
set_parameter_property PCORE_NUM_OF_RX_LANES UNITS None
set_parameter_property PCORE_NUM_OF_RX_LANES HDL_PARAMETER true

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

ad_alt_intf clock   rx_ref_clk          input   1
ad_alt_intf signal  rx_d                input   4
ad_alt_intf clock   rx_clk              output  1
ad_alt_intf signal  rx_ext_sysref_in    input   1
ad_alt_intf signal  rx_ext_sysref_out   output  1
ad_alt_intf signal  rx_sync             output  1
ad_alt_intf signal  rx_sof              output  PCORE_NUM_OF_RX_LANES
ad_alt_intf signal  rx_data             output  PCORE_NUM_OF_RX_LANES*32  data

ad_alt_intf clock   tx_ref_clk          input   1
ad_alt_intf signal  tx_d                output  4
ad_alt_intf clock   tx_clk              output  1
ad_alt_intf signal  tx_ext_sysref_in    input   1
ad_alt_intf signal  tx_ext_sysref_out   output  1
ad_alt_intf signal  tx_sync             input   1
ad_alt_intf signal  tx_data             input   PCORE_NUM_OF_TX_LANES*32  data

