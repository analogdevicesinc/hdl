

package require -exact qsys 14.0
source ../scripts/adi_env.tcl

set_module_property NAME axi_ad9671
set_module_property DESCRIPTION "AXI AD9671 Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_ad9671

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9671
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
add_fileset_file ad_mem.v             VERILOG PATH $ad_hdl_dir/library/common/ad_mem.v
add_fileset_file axi_ad9671_pnmon.v   VERILOG PATH axi_ad9671_pnmon.v
add_fileset_file axi_ad9671_if.v      VERILOG PATH axi_ad9671_if.v
add_fileset_file axi_ad9671_channel.v VERILOG PATH axi_ad9671_channel.v
add_fileset_file axi_ad9671.v         VERILOG PATH axi_ad9671.v TOP_LEVEL_FILE

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

add_parameter PCORE_4L_2L_N INTEGER 0
set_parameter_property PCORE_4L_2L_N DEFAULT_VALUE 1
set_parameter_property PCORE_4L_2L_N DISPLAY_NAME PCORE_4L_2L_N
set_parameter_property PCORE_4L_2L_N TYPE INTEGER
set_parameter_property PCORE_4L_2L_N UNITS None
set_parameter_property PCORE_4L_2L_N HDL_PARAMETER true

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
add_interface_port s_axi s_axi_araddr araddr Input 14
add_interface_port s_axi s_axi_arprot arprot Input 3
add_interface_port s_axi s_axi_arready arready Output 1
add_interface_port s_axi s_axi_rvalid rvalid Output 1
add_interface_port s_axi s_axi_rresp rresp Output 2
add_interface_port s_axi s_axi_rdata rdata Output 32
add_interface_port s_axi s_axi_rready rready Input 1

# transceiver interface

add_interface xcvr_clk clock end
add_interface_port xcvr_clk rx_clk clk Input 1

add_interface xcvr_data conduit end
set_interface_property xcvr_data associatedClock xcvr_clk
add_interface_port xcvr_data rx_data data Input 64*PCORE_4L_2L_N+64
add_interface_port xcvr_data rx_sof data_sof Input 1

add_interface xcvr_sync conduit end
set_interface_property xcvr_sync associatedClock xcvr_clk
add_interface_port xcvr_sync adc_sync_in sync_in Input 1
add_interface_port xcvr_sync adc_sync_out sync_out Output 1
add_interface_port xcvr_sync adc_raddr_in raddr_in Input 4
add_interface_port xcvr_sync adc_raddr_out raddr_out Output 4

# dma interface

add_interface adc_clock clock start
add_interface_port adc_clock adc_clk clk Output 1

add_interface adc_dma_if conduit end
set_interface_property adc_dma_if associatedClock adc_clock
add_interface_port adc_dma_if adc_valid valid Output 8
add_interface_port adc_dma_if adc_enable enable Output 8
add_interface_port adc_dma_if adc_data data Output 128
add_interface_port adc_dma_if adc_dovf dovf Input 1
add_interface_port adc_dma_if adc_dunf dunf Input 1

