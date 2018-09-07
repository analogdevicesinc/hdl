
## FIFO depth is 16Mb - 1M samples
set dac_fifo_name axi_ad9371_dacfifo
set dac_fifo_address_width 17
set dac_data_width 128
set dac_dma_data_width 128

## NOTE: With this configuration the #36Kb BRAM utilization is at ~51%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 200

source ../common/adrv9371x_bd.tcl

ad_connect sys_dma_clk sys_ps8/pl_clk2
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset

ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_ad9371_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.DEVICE_TYPE 2
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.DEVICE_TYPE 2

ad_ip_parameter util_ad9371_xcvr CONFIG.CH_HSPMUX  0x243c        ;#16'b0010010000111100
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG0  0x01fa        ;#16'b0000000111111010
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG1  0x0023        ;#16'b0000000000100011
ad_ip_parameter util_ad9371_xcvr CONFIG.CPLL_CFG2  0x0002        ;#16'b0000000000000010
ad_ip_parameter util_ad9371_xcvr CONFIG.PREIQ_FREQ_BST 0
ad_ip_parameter util_ad9371_xcvr CONFIG.PCIE_BUFG_DIV_CTRL 0x1000;#16'b0001000000000000
ad_ip_parameter util_ad9371_xcvr CONFIG.PCIE_PLL_SEL_MODE_GEN12 0
ad_ip_parameter util_ad9371_xcvr CONFIG.RXCDR_CFG3 0x0012        ;#16'b0000000000010010
ad_ip_parameter util_ad9371_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12     ;#6'b010010
ad_ip_parameter util_ad9371_xcvr CONFIG.RXCDR_CFG3_GEN3 0x0012   ;#16'b0000000000010010
ad_ip_parameter util_ad9371_xcvr CONFIG.RXPI_CFG0 0x3300         ;#16'b0011001100000000
ad_ip_parameter util_ad9371_xcvr CONFIG.RXPI_CFG1 0x00fd         ;#16'b0000000011111101
ad_ip_parameter util_ad9371_xcvr CONFIG.RX_WIDEMODE_CDR 0
ad_ip_parameter util_ad9371_xcvr CONFIG.TXPH_CFG 0x0723          ;#16'b0000011100100011
ad_ip_parameter util_ad9371_xcvr CONFIG.TXPI_CFG 0x0054          ;#16'b0000000001010100
ad_ip_parameter util_ad9371_xcvr CONFIG.TXPI_CFG3 0
ad_ip_parameter util_ad9371_xcvr CONFIG.TXPI_CFG4 1
ad_ip_parameter util_ad9371_xcvr CONFIG.TX_PI_BIASSET 1

ad_ip_parameter util_ad9371_xcvr CONFIG.PPF0_CFG 0x0600      ;#16'b0000011000000000
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL0_CFG2 0x0fc3    ;#16'b0000111111000011
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL0_CFG2_G3 0x0fc3 ;#16'b0000111111000011
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL0_CFG4 0x0003    ;#16'b0000000000000011
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL0_LPF 0x21f      ;#10'b1000011111
