

package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl


set_module_property NAME axi_ad9250
set_module_property DESCRIPTION "AXI AD9250 Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_ad9250

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9250
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_pnmon.v           VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file ad_datafmt.v         VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_delay_cntrl.v     VERILOG PATH $ad_hdl_dir/library/common/up_delay_cntrl.v
add_fileset_file up_adc_common.v      VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v     VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file axi_ad9250_pnmon.v   VERILOG PATH axi_ad9250_pnmon.v
add_fileset_file axi_ad9250_if.v      VERILOG PATH axi_ad9250_if.v
add_fileset_file axi_ad9250_channel.v VERILOG PATH axi_ad9250_channel.v
add_fileset_file axi_ad9250.v         VERILOG PATH axi_ad9250.v TOP_LEVEL_FILE

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
add_interface_port s_axi s_axi_awaddr awaddr Input 14
add_interface_port s_axi s_axi_awready awready Output 1
add_interface_port s_axi s_axi_wvalid wvalid Input 1
add_interface_port s_axi s_axi_wdata wdata Input 32
add_interface_port s_axi s_axi_wstrb wstrb Input 4
add_interface_port s_axi s_axi_wready wready Output 1
add_interface_port s_axi s_axi_bvalid bvalid Output 1
add_interface_port s_axi s_axi_bresp bresp Output 2
add_interface_port s_axi s_axi_bready bready Input 1
add_interface_port s_axi s_axi_arvalid arvalid Input 1
add_interface_port s_axi s_axi_araddr araddr Input 14
add_interface_port s_axi s_axi_arready arready Output 1
add_interface_port s_axi s_axi_rvalid rvalid Output 1
add_interface_port s_axi s_axi_rresp rresp Output 2
add_interface_port s_axi s_axi_rdata rdata Output 32
add_interface_port s_axi s_axi_rready rready Input 1
add_interface_port s_axi s_axi_awprot awprot Input 3
add_interface_port s_axi s_axi_arprot arprot Input 3


# transceiver interface

add_interface xcvr_clk clock end
add_interface_port xcvr_clk rx_clk clk Input 1

add_interface xcvr_data conduit end
set_interface_property xcvr_data associatedClock xcvr_clk
add_interface_port xcvr_data rx_data data Input 64

# dma interface

ad_alt_intf clock   adc_clk       output  1
ad_alt_intf signal  adc_valid_a   output  1   adc_valid_0
ad_alt_intf signal  adc_enable_a  output  1   adc_enable_0
ad_alt_intf signal  adc_data_a    output  32  adc_data_0
ad_alt_intf signal  adc_valid_b   output  1   adc_valid_1
ad_alt_intf signal  adc_enable_b  output  1   adc_enable_1
ad_alt_intf signal  adc_data_b    output  32  adc_data_1
ad_alt_intf signal  adc_dovf      input   1
ad_alt_intf signal  adc_dunf      input   1

