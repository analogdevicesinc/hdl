
## FIFO depth is 8Mb - 500k samples
set dac_fifo_name axi_ad9152_fifo
set dac_fifo_address_width 16
set dac_data_width 128
set dac_dma_data_width 128

## NOTE: With this configuration the #36Kb BRAM utilization is at ~28%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq3_bd.tcl

create_bd_port -dir I dac_fifo_bypass

ad_ip_parameter axi_ad9152_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_ad9680_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_daq3_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter util_daq3_xcvr CONFIG.CH_HSPMUX  0x4444        ;#16'b0100010001000100
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG0  0x03fe        ;#16'b0000001111111110
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG1  0x0021        ;#16'b0000000000100001
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG2  0x0203        ;#16'b0000001000000011
ad_ip_parameter util_daq3_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_daq3_xcvr CONFIG.PCIE_BUFG_DIV_CTRL 0x3500;#16'b0011010100000000
ad_ip_parameter util_daq3_xcvr CONFIG.PCIE_PLL_SEL_MODE_GEN12 2
ad_ip_parameter util_daq3_xcvr CONFIG.RXCDR_CFG3 0x001a        ;#16'b0000000000011010
ad_ip_parameter util_daq3_xcvr CONFIG.RXCDR_CFG3_GEN2 0x1a     ;#6'b011010
ad_ip_parameter util_daq3_xcvr CONFIG.RXCDR_CFG3_GEN3 0x001a   ;#16'b0000000000011010
ad_ip_parameter util_daq3_xcvr CONFIG.RXPI_CFG0 0x2004         ;#16'b0010000000000100
ad_ip_parameter util_daq3_xcvr CONFIG.RXPI_CFG1 0x0000         ;#16'b0000000000000000
ad_ip_parameter util_daq3_xcvr CONFIG.RX_WIDEMODE_CDR 1
ad_ip_parameter util_daq3_xcvr CONFIG.TXPH_CFG 0x0323          ;#16'b0000001100100011
ad_ip_parameter util_daq3_xcvr CONFIG.TXPI_CFG 0x0000          ;#16'b0000000000000000
ad_ip_parameter util_daq3_xcvr CONFIG.TXPI_CFG3 1
ad_ip_parameter util_daq3_xcvr CONFIG.TXPI_CFG4 0
ad_ip_parameter util_daq3_xcvr CONFIG.TX_PI_BIASSET 2

ad_ip_parameter util_daq3_xcvr CONFIG.PPF0_CFG 0x0800      ;#16'b0000100000000000
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL0_CFG2 0x0fc1    ;#16'b0000111111000001
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL0_CFG2_G3 0x0fc1 ;#16'b0000111111000001
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL0_CFG4 0x0004    ;#16'b0000000000000100
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL0_LPF 0x37f      ;#10'b1101111111

ad_ip_parameter axi_ad9152_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9152_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_ad9152_dma CONFIG.MAX_BYTES_PER_BURST 256

ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9680_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9680_dma CONFIG.MAX_BYTES_PER_BURST 256

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance proc_sys_reset sys_dma_rstgen

ad_connect sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect sys_cpu_resetn dma_clk_wiz/resetn

ad_connect sys_dma_clk dma_clk_wiz/clk_out1

ad_connect sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect sys_cpu_resetn sys_dma_rstgen/ext_reset_in

ad_connect sys_dma_reset sys_dma_rstgen/peripheral_reset
ad_connect sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

ad_connect sys_dma_clk axi_ad9152_fifo/dma_clk
ad_connect sys_dma_reset axi_ad9152_fifo/dma_rst
ad_connect sys_dma_clk axi_ad9152_dma/m_axis_aclk
ad_connect sys_dma_resetn axi_ad9152_dma/m_src_axi_aresetn
ad_connect axi_ad9152_fifo/bypass dac_fifo_bypass

ad_connect sys_dma_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect axi_ad9680_dma/fifo_wr_clk util_daq3_xcvr/rx_out_clk_0
ad_connect axi_ad9680_cpack/adc_data axi_ad9680_dma/fifo_wr_din
ad_connect axi_ad9680_cpack/adc_valid axi_ad9680_dma/fifo_wr_en
ad_connect axi_ad9680_cpack/adc_valid axi_ad9680_dma/fifo_wr_sync

ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_ad9680_xcvr/m_axi
ad_mem_hp1_interconnect sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_dma_clk axi_ad9680_dma/m_dest_axi
ad_mem_hp3_interconnect sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_dma_clk axi_ad9152_dma/m_src_axi
