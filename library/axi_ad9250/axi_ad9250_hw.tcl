

package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME axi_ad9250
set_module_property DESCRIPTION "AXI AD9250 Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_ad9250

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9250_alt
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/altera/ad_rst.v
add_fileset_file ad_pnmon.v           VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file ad_datafmt.v         VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_drp_cntrl.v       VERILOG PATH $ad_hdl_dir/library/common/up_drp_cntrl.v
add_fileset_file up_delay_cntrl.v     VERILOG PATH $ad_hdl_dir/library/common/up_delay_cntrl.v
add_fileset_file up_adc_common.v      VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v     VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file axi_ad9250_pnmon.v   VERILOG PATH axi_ad9250_pnmon.v
add_fileset_file axi_ad9250_if.v      VERILOG PATH axi_ad9250_if.v
add_fileset_file axi_ad9250_channel.v VERILOG PATH axi_ad9250_channel.v
add_fileset_file axi_ad9250.v         VERILOG PATH axi_ad9250.v
add_fileset_file axi_ad9250_alt.v     VERILOG PATH axi_ad9250_alt.v TOP_LEVEL_FILE

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

add_parameter PCORE_AXI_ID_WIDTH INTEGER 0
set_parameter_property PCORE_AXI_ID_WIDTH DEFAULT_VALUE 3
set_parameter_property PCORE_AXI_ID_WIDTH DISPLAY_NAME PCORE_AXI_ID_WIDTH
set_parameter_property PCORE_AXI_ID_WIDTH TYPE INTEGER
set_parameter_property PCORE_AXI_ID_WIDTH UNITS None
set_parameter_property PCORE_AXI_ID_WIDTH HDL_PARAMETER true

# axi4 slave

add_interface s_axi_clock clock end
add_interface_port s_axi_clock s_axi_aclk clk Input 1

add_interface s_axi_reset reset end
set_interface_property s_axi_reset associatedClock s_axi_clock
add_interface_port s_axi_reset s_axi_aresetn reset_n Input 1

add_interface s_axi axi4 end
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
add_interface_port s_axi s_axi_awid awid Input PCORE_AXI_ID_WIDTH
add_interface_port s_axi s_axi_awlen awlen Input 8
add_interface_port s_axi s_axi_awsize awsize Input 3
add_interface_port s_axi s_axi_awburst awburst Input 2
add_interface_port s_axi s_axi_awlock awlock Input 1
add_interface_port s_axi s_axi_awcache awcache Input 4
add_interface_port s_axi s_axi_awprot awprot Input 3
add_interface_port s_axi s_axi_wlast wlast Input 1
add_interface_port s_axi s_axi_bid bid Output PCORE_AXI_ID_WIDTH
add_interface_port s_axi s_axi_arid arid Input PCORE_AXI_ID_WIDTH
add_interface_port s_axi s_axi_arlen arlen Input 8
add_interface_port s_axi s_axi_arsize arsize Input 3
add_interface_port s_axi s_axi_arburst arburst Input 2
add_interface_port s_axi s_axi_arlock arlock Input 1
add_interface_port s_axi s_axi_arcache arcache Input 4
add_interface_port s_axi s_axi_arprot arprot Input 3
add_interface_port s_axi s_axi_rid rid Output PCORE_AXI_ID_WIDTH
add_interface_port s_axi s_axi_rlast rlast Output 1


# transceiver interface

add_interface xcvr_clk clock end
add_interface_port xcvr_clk rx_clk clk Input 1

add_interface xcvr_data conduit end
set_interface_property xcvr_data associatedClock xcvr_clk
add_interface_port xcvr_data rx_data data Input 64

# dma interface

add_interface adc_clock clock start
add_interface_port adc_clock adc_clk clk Output 1

add_interface adc_dma_if conduit end
set_interface_property adc_dma_if associatedClock adc_clock
add_interface_port adc_dma_if adc_valid_a adc_valid_a Output 1
add_interface_port adc_dma_if adc_enable_a adc_enable_a Output 1
add_interface_port adc_dma_if adc_data_a adc_data_a Output 32
add_interface_port adc_dma_if adc_valid_b adc_valid_b Output 1
add_interface_port adc_dma_if adc_enable_b adc_enable_b Output 1
add_interface_port adc_dma_if adc_data_b adc_data_b Output 32
add_interface_port adc_dma_if adc_dovf adc_dovf Input 1
add_interface_port adc_dma_if adc_dunf adc_dunf Input 1

