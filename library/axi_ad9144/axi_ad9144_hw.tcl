

package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME axi_ad9144
set_module_property DESCRIPTION "AXI AD9144 Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_ad9144

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9144
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/altera/ad_rst.v
add_fileset_file MULT_MACRO.v         VERILOG PATH $ad_hdl_dir/library/common/altera/MULT_MACRO.v
add_fileset_file ad_mul.v             VERILOG PATH $ad_hdl_dir/library/common/ad_mul.v
add_fileset_file ad_dds_sine.v        VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_1.v           VERILOG PATH $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v             VERILOG PATH $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_drp_cntrl.v       VERILOG PATH $ad_hdl_dir/library/common/up_drp_cntrl.v
add_fileset_file up_dac_common.v      VERILOG PATH $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v     VERILOG PATH $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file axi_ad9144_channel.v VERILOG PATH axi_ad9144_channel.v
add_fileset_file axi_ad9144_core.v    VERILOG PATH axi_ad9144_core.v
add_fileset_file axi_ad9144_if.v      VERILOG PATH axi_ad9144_if.v
add_fileset_file axi_ad9144.v         VERILOG PATH axi_ad9144.v TOP_LEVEL_FILE

# parameters

add_parameter PCORE_ID INTEGER 0
set_parameter_property PCORE_ID DEFAULT_VALUE 0
set_parameter_property PCORE_ID DISPLAY_NAME PCORE_ID
set_parameter_property PCORE_ID TYPE INTEGER
set_parameter_property PCORE_ID UNITS None
set_parameter_property PCORE_ID HDL_PARAMETER true

add_parameter PCORE_QUAD_DUAL_N INTEGER 0
set_parameter_property PCORE_QUAD_DUAL_N DEFAULT_VALUE 0
set_parameter_property PCORE_QUAD_DUAL_N DISPLAY_NAME PCORE_QUAD_DUAL_N
set_parameter_property PCORE_QUAD_DUAL_N TYPE INTEGER
set_parameter_property PCORE_QUAD_DUAL_N UNITS None
set_parameter_property PCORE_QUAD_DUAL_N HDL_PARAMETER true

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

add_interface xcvr_clk clock end
add_interface_port xcvr_clk tx_clk clk Input 1

add_interface xcvr_data conduit end
set_interface_property xcvr_data associatedClock xcvr_clk
add_interface_port xcvr_data tx_data data Output 128*(PCORE_QUAD_DUAL_N+1)

# dma interface

add_interface dac_clock clock start
add_interface_port dac_clock dac_clk clk Output 1

add_interface dac_dma_if conduit start
set_interface_property dac_dma_if associatedClock dac_clock
add_interface_port dac_dma_if dac_valid_0 dac_valid_0 Output 1
add_interface_port dac_dma_if dac_enable_0 dac_enable_0 Output 1
add_interface_port dac_dma_if dac_data_0 dac_data_0 Input 64
add_interface_port dac_dma_if dac_valid_1 dac_valid_1 Output 1
add_interface_port dac_dma_if dac_enable_1 dac_enable_1 Output 1
add_interface_port dac_dma_if dac_data_1 dac_data_1 Input 64
add_interface_port dac_dma_if dac_valid_2 dac_valid_2 Output 1
add_interface_port dac_dma_if dac_enable_2 dac_enable_2 Output 1
add_interface_port dac_dma_if dac_data_2 dac_data_2 Input 64
add_interface_port dac_dma_if dac_valid_3 dac_valid_3 Output 1
add_interface_port dac_dma_if dac_enable_3 dac_enable_3 Output 1
add_interface_port dac_dma_if dac_data_3 dac_data_3 Input 64
add_interface_port dac_dma_if dac_dovf dac_dovf Input 1
add_interface_port dac_dma_if dac_dunf dac_dunf Input 1

