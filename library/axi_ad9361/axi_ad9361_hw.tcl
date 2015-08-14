

package require -exact qsys 13.0
source ../scripts/adi_env.tcl

set_module_property NAME axi_ad9361
set_module_property DESCRIPTION "AXI AD9361 Interface"
set_module_property VERSION 1.0
set_module_property DISPLAY_NAME axi_ad9361

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9361
add_fileset_file ad_rst.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_lvds_clk.v            VERILOG PATH $ad_hdl_dir/library/common/altera/ad_lvds_clk.v
add_fileset_file ad_lvds_in.v             VERILOG PATH $ad_hdl_dir/library/common/altera/ad_lvds_in.v
add_fileset_file ad_lvds_out.v            VERILOG PATH $ad_hdl_dir/library/common/altera/ad_lvds_out.v
add_fileset_file MULT_MACRO.v             VERILOG PATH $ad_hdl_dir/library/common/altera/MULT_MACRO.v
add_fileset_file DSP48E1.v                VERILOG PATH $ad_hdl_dir/library/common/altera/DSP48E1.v
add_fileset_file ad_mul.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_mul.v
add_fileset_file ad_pnmon.v               VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file ad_dds_sine.v            VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_1.v               VERILOG PATH $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_datafmt.v             VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file ad_dcfilter.v            VERILOG PATH $ad_hdl_dir/library/common/ad_dcfilter.v
add_fileset_file ad_iqcor.v               VERILOG PATH $ad_hdl_dir/library/common/ad_iqcor.v
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v          VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v         VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v           VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_delay_cntrl.v         VERILOG PATH $ad_hdl_dir/library/common/up_delay_cntrl.v
add_fileset_file up_adc_common.v          VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v         VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file up_dac_common.v          VERILOG PATH $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v         VERILOG PATH $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file up_tdd_cntrl.v           VERILOG PATH $ad_hdl_dir/library/common/up_tdd_cntrl.v
add_fileset_file ad_tdd_control.v         VERILOG PATH $ad_hdl_dir/library/common/ad_tdd_control.v
add_fileset_file ad_addsub.v              VERILOG PATH $ad_hdl_dir/library/common/ad_addsub.v
add_fileset_file axi_ad9361_alt_lvds_tx.v VERILOG PATH axi_ad9361_alt_lvds_tx.v
add_fileset_file axi_ad9361_alt_lvds_rx.v VERILOG PATH axi_ad9361_alt_lvds_rx.v
add_fileset_file axi_ad9361_dev_if_alt.v  VERILOG PATH axi_ad9361_dev_if_alt.v
add_fileset_file axi_ad9361_rx_pnmon.v    VERILOG PATH axi_ad9361_rx_pnmon.v
add_fileset_file axi_ad9361_rx_channel.v  VERILOG PATH axi_ad9361_rx_channel.v
add_fileset_file axi_ad9361_rx.v          VERILOG PATH axi_ad9361_rx.v
add_fileset_file axi_ad9361_tx_channel.v  VERILOG PATH axi_ad9361_tx_channel.v
add_fileset_file axi_ad9361_tx.v          VERILOG PATH axi_ad9361_tx.v
add_fileset_file axi_ad9361_tdd.v         VERILOG PATH axi_ad9361_tdd.v
add_fileset_file axi_ad9361_tdd_if.v      VERILOG PATH axi_ad9361_tdd_if.v
add_fileset_file axi_ad9361.v             VERILOG PATH axi_ad9361.v TOP_LEVEL_FILE

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

# device interface

add_interface device_clock clock end
add_interface_port device_clock clk clk Input 1

add_interface device_if conduit end
set_interface_property device_if associatedClock device_clock
add_interface_port device_if rx_clk_in_p rx_clk_in_p Input 1
add_interface_port device_if rx_clk_in_n rx_clk_in_n Input 1
add_interface_port device_if rx_frame_in_p rx_frame_in_p Input 1
add_interface_port device_if rx_frame_in_n rx_frame_in_n Input 1
add_interface_port device_if rx_data_in_p rx_data_in_p Input 6
add_interface_port device_if rx_data_in_n rx_data_in_n Input 6
add_interface_port device_if tx_clk_out_p tx_clk_out_p Output 1
add_interface_port device_if tx_clk_out_n tx_clk_out_n Output 1
add_interface_port device_if tx_frame_out_p tx_frame_out_p Output 1
add_interface_port device_if tx_frame_out_n tx_frame_out_n Output 1
add_interface_port device_if tx_data_out_p tx_data_out_p Output 6
add_interface_port device_if tx_data_out_n tx_data_out_n Output 6

add_interface master_if conduit end
set_interface_property master_if associatedClock device_clock
add_interface_port master_if l_clk l_clk Output 1
add_interface_port master_if dac_sync_in dac_sync_in Input 1
add_interface_port master_if dac_sync_out dac_sync_out Output 1

add_interface dma_if conduit start
set_interface_property dma_if associatedClock device_clock
add_interface_port dma_if adc_enable_i0 adc_enable_i0 Output  1
add_interface_port dma_if adc_valid_i0 adc_valid_i0 Output  1
add_interface_port dma_if adc_data_i0 adc_data_i0 Output  16
add_interface_port dma_if adc_enable_q0 adc_enable_q0 Output  1
add_interface_port dma_if adc_valid_q0 adc_valid_q0 Output  1
add_interface_port dma_if adc_data_q0 adc_data_q0 Output  16
add_interface_port dma_if adc_enable_i1 adc_enable_i1 Output  1
add_interface_port dma_if adc_valid_i1 adc_valid_i1 Output  1
add_interface_port dma_if adc_data_i1 adc_data_i1 Output  16
add_interface_port dma_if adc_enable_q1 adc_enable_q1 Output  1
add_interface_port dma_if adc_valid_q1 adc_valid_q1 Output  1
add_interface_port dma_if adc_data_q1 adc_data_q1 Output  16
add_interface_port dma_if adc_dovf adc_dovf Input   1
add_interface_port dma_if adc_dunf adc_dunf Input   1
add_interface_port dma_if dac_enable_i0 dac_enable_i0 Output  1
add_interface_port dma_if dac_valid_i0 dac_valid_i0 Output  1
add_interface_port dma_if dac_data_i0 dac_data_i0 Input   16
add_interface_port dma_if dac_enable_q0 dac_enable_q0 Output  1
add_interface_port dma_if dac_valid_q0 dac_valid_q0 Output  1
add_interface_port dma_if dac_data_q0 dac_data_q0 Input   16
add_interface_port dma_if dac_enable_i1 dac_enable_i1 Output  1
add_interface_port dma_if dac_valid_i1 dac_valid_i1 Output  1
add_interface_port dma_if dac_data_i1 dac_data_i1 Input   16
add_interface_port dma_if dac_enable_q1 dac_enable_q1 Output  1
add_interface_port dma_if dac_valid_q1 dac_valid_q1 Output  1
add_interface_port dma_if dac_data_q1 dac_data_q1 Input   16
add_interface_port dma_if dac_dovf dac_dovf Input   1
add_interface_port dma_if dac_dunf dac_dunf Input   1


add_interface delay_clock clock end
add_interface_port delay_clock delay_clk clk Input 1

