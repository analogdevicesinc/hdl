

package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME axi_hdmi_tx
set_module_property DESCRIPTION "AXI HDMI Transmit Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_hdmi_tx

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_hdmi_tx_alt
add_fileset_file MULT_MACRO.v         VERILOG PATH $ad_hdl_dir/library/common/altera/MULT_MACRO.v
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_mem.v             VERILOG PATH $ad_hdl_dir/library/common/ad_mem.v
add_fileset_file ad_csc_1_mul.v       VERILOG PATH $ad_hdl_dir/library/common/ad_csc_1_mul.v
add_fileset_file ad_csc_1_add.v       VERILOG PATH $ad_hdl_dir/library/common/ad_csc_1_add.v
add_fileset_file ad_csc_1.v           VERILOG PATH $ad_hdl_dir/library/common/ad_csc_1.v
add_fileset_file ad_csc_RGB2CrYCb.v   VERILOG PATH $ad_hdl_dir/library/common/ad_csc_RGB2CrYCb.v
add_fileset_file ad_ss_444to422.v     VERILOG PATH $ad_hdl_dir/library/common/ad_ss_444to422.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_hdmi_tx.v         VERILOG PATH $ad_hdl_dir/library/common/up_hdmi_tx.v
add_fileset_file axi_hdmi_tx_vdma.v   VERILOG PATH axi_hdmi_tx_vdma.v
add_fileset_file axi_hdmi_tx_core.v   VERILOG PATH axi_hdmi_tx_core.v
add_fileset_file axi_hdmi_tx.v        VERILOG PATH axi_hdmi_tx.v
add_fileset_file axi_hdmi_tx_alt.v    VERILOG PATH axi_hdmi_tx_alt.v TOP_LEVEL_FILE

# parameters

add_parameter PCORE_ID INTEGER 0
set_parameter_property PCORE_ID DEFAULT_VALUE 0
set_parameter_property PCORE_ID DISPLAY_NAME PCORE_ID
set_parameter_property PCORE_ID TYPE INTEGER
set_parameter_property PCORE_ID UNITS None
set_parameter_property PCORE_ID HDL_PARAMETER true

add_parameter PCORE_DEVICE_TYPE INTEGER 0
set_parameter_property PCORE_DEVICE_TYPE DEFAULT_VALUE 16
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

add_parameter PCORE_Cr_Cb_N INTEGER 0
set_parameter_property PCORE_Cr_Cb_N DEFAULT_VALUE 0
set_parameter_property PCORE_Cr_Cb_N DISPLAY_NAME PCORE_Cr_Cb_N
set_parameter_property PCORE_Cr_Cb_N TYPE INTEGER
set_parameter_property PCORE_Cr_Cb_N UNITS None
set_parameter_property PCORE_Cr_Cb_N HDL_PARAMETER true

add_parameter PCORE_EMBEDDED_SYNC INTEGER 0
set_parameter_property PCORE_EMBEDDED_SYNC DEFAULT_VALUE 0
set_parameter_property PCORE_EMBEDDED_SYNC DISPLAY_NAME PCORE_EMBEDDED_SYNC
set_parameter_property PCORE_EMBEDDED_SYNC TYPE INTEGER
set_parameter_property PCORE_EMBEDDED_SYNC UNITS None
set_parameter_property PCORE_EMBEDDED_SYNC HDL_PARAMETER true

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

# hdmi interface

add_interface hdmi_clock clock end
add_interface_port hdmi_clock hdmi_clk clk Input 1

add_interface hdmi_if conduit end
set_interface_property hdmi_if associatedClock hdmi_clock
set_interface_property hdmi_if associatedReset s_axi_reset
add_interface_port hdmi_if hdmi_out_clk h_clk Output 1
add_interface_port hdmi_if hdmi_16_hsync h16_hsync Output 1
add_interface_port hdmi_if hdmi_16_vsync h16_vsync Output 1
add_interface_port hdmi_if hdmi_16_data_e h16_data_e Output 1
add_interface_port hdmi_if hdmi_16_data h16_data Output 16
add_interface_port hdmi_if hdmi_16_es_data h16_es_data Output 16
add_interface_port hdmi_if hdmi_24_hsync h24_hsync Output 1
add_interface_port hdmi_if hdmi_24_vsync h24_vsync Output 1
add_interface_port hdmi_if hdmi_24_data_e h24_data_e Output 1
add_interface_port hdmi_if hdmi_24_data h24_data Output 24
add_interface_port hdmi_if hdmi_36_hsync h36_hsync Output 1
add_interface_port hdmi_if hdmi_36_vsync h36_vsync Output 1
add_interface_port hdmi_if hdmi_36_data_e h36_data_e Output 1
add_interface_port hdmi_if hdmi_36_data h36_data Output 36

# avalon streaming dma

add_interface vdma_clock  clock end
add_interface_port vdma_clock vdma_clk clk Input 1

add_interface vdma_if avalon_streaming end
set_interface_property vdma_if associatedClock vdma_clock
set_interface_property vdma_if associatedReset s_axi_reset
add_interface_port vdma_if vdma_valid valid Input 1
add_interface_port vdma_if vdma_data data Input 64
add_interface_port vdma_if vdma_ready ready Output 1
add_interface_port vdma_if vdma_sop startofpacket Input 1
add_interface_port vdma_if vdma_eop endofpacket Input 1
add_interface_port vdma_if vdma_empty empty Input 3


