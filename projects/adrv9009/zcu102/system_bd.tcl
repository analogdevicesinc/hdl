
set dac_fifo_name axi_adrv9009_dacfifo
set dac_fifo_address_width 14
set dac_data_width 128
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_mem_hp0_interconnect sys_cpu_clk sys_ps8/S_AXI_HP0

source ../common/adrv9009_bd.tcl

ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.FIFO_SIZE 32

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_connect sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect sys_cpu_resetn dma_clk_wiz/resetn

ad_connect sys_dma_clk dma_clk_wiz/clk_out1
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset

ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_adrv9009_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.DEVICE_TYPE 2
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.DEVICE_TYPE 2

ad_ip_parameter util_adrv9009_xcvr CONFIG.CH_HSPMUX  0x2424        ;#16'b0010010000100100
ad_ip_parameter util_adrv9009_xcvr CONFIG.CPLL_CFG0 0x03fe         ;#16'b0000001111111110
ad_ip_parameter util_adrv9009_xcvr CONFIG.CPLL_CFG1 0x021          ;#16'b0000000000100001
ad_ip_parameter util_adrv9009_xcvr CONFIG.CPLL_CFG2 0x0203         ;#16'b0000001000000011
ad_ip_parameter util_adrv9009_xcvr CONFIG.PREIQ_FREQ_BST 0
ad_ip_parameter util_adrv9009_xcvr CONFIG.PCIE_BUFG_DIV_CTRL 0x3500;#16'b0011010100000000
ad_ip_parameter util_adrv9009_xcvr CONFIG.PCIE_PLL_SEL_MODE_GEN12 2
ad_ip_parameter util_adrv9009_xcvr CONFIG.RXCDR_CFG3 0x0012        ;#16'b0000000000010010
ad_ip_parameter util_adrv9009_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12     ;#6'b010010
ad_ip_parameter util_adrv9009_xcvr CONFIG.RXCDR_CFG3_GEN3 0x0012   ;#16'b0000000000010010
ad_ip_parameter util_adrv9009_xcvr CONFIG.RXPI_CFG0 0x0102         ;#16'b0000000100000010
ad_ip_parameter util_adrv9009_xcvr CONFIG.RXPI_CFG1 0x0015         ;#16'b0000000000010101
ad_ip_parameter util_adrv9009_xcvr CONFIG.RX_WIDEMODE_CDR 0
ad_ip_parameter util_adrv9009_xcvr CONFIG.TXPH_CFG 0x0323          ;#16'b0000001100100011
ad_ip_parameter util_adrv9009_xcvr CONFIG.TXPI_CFG 0x0054          ;#16'b0000000001010100
ad_ip_parameter util_adrv9009_xcvr CONFIG.TXPI_CFG3 0
ad_ip_parameter util_adrv9009_xcvr CONFIG.TXPI_CFG4 1
ad_ip_parameter util_adrv9009_xcvr CONFIG.TX_PI_BIASSET 1

ad_ip_parameter util_adrv9009_xcvr CONFIG.PPF0_CFG 0x0600      ;#16'b0000011000000000
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL0_CFG2 0x0fc1    ;#16'b0000111111000001
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL0_CFG2_G3 0x0fc1 ;#16'b0000111111000001
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL0_CFG4 0x0003    ;#16'b0000000000000011
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL0_LPF 0x37f      ;#10'b1101111111
