
## FIFO depth is 8Mb - 500k samples
set adc_fifo_name axi_ad9680_fifo
set adc_fifo_address_width 17
set adc_data_width 128
set adc_dma_data_width 64

## FIFO depth is 8Mb - 500k samples
set dac_fifo_name axi_ad9144_fifo
set dac_fifo_address_width 16
set dac_data_width 128
set dac_dma_data_width 128

## NOTE: With this configuration the #36Kb BRAM utilization is at ~57%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq2_bd.tcl

ad_ip_parameter axi_ad9144_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_ad9680_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_daq2_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter util_daq2_xcvr CONFIG.CH_HSPMUX  0x2424        ;#16'b0010010000100100
ad_ip_parameter util_daq2_xcvr CONFIG.CPLL_CFG0 0x03fe         ;#16'b0000001111111110
ad_ip_parameter util_daq2_xcvr CONFIG.CPLL_CFG1 0x0021         ;#16'b0000000000100001
ad_ip_parameter util_daq2_xcvr CONFIG.CPLL_CFG2 0x0203         ;#16'b0000001000000011
ad_ip_parameter util_daq2_xcvr CONFIG.PREIQ_FREQ_BST 0
ad_ip_parameter util_daq2_xcvr CONFIG.PCIE_BUFG_DIV_CTRL 0x3500;#16'b0011010100000000
ad_ip_parameter util_daq2_xcvr CONFIG.PCIE_PLL_SEL_MODE_GEN12 2
ad_ip_parameter util_daq2_xcvr CONFIG.RXCDR_CFG3 0x0012        ;#16'b0000000000010010
ad_ip_parameter util_daq2_xcvr CONFIG.RXCDR_CFG3_GEN2 0x12     ;#6'b010010
ad_ip_parameter util_daq2_xcvr CONFIG.RXCDR_CFG3_GEN3 0x0012   ;#16'b0000000000010010
ad_ip_parameter util_daq2_xcvr CONFIG.RXPI_CFG0 0x0102         ;#16'b0000000100000010
ad_ip_parameter util_daq2_xcvr CONFIG.RXPI_CFG1 0x0015         ;#16'b0000000000010101
ad_ip_parameter util_daq2_xcvr CONFIG.RX_WIDEMODE_CDR 0
ad_ip_parameter util_daq2_xcvr CONFIG.TXPH_CFG 0x0323          ;#16'b0000001100100011
ad_ip_parameter util_daq2_xcvr CONFIG.TXPI_CFG 0x0054          ;#16'b0000000001010100
ad_ip_parameter util_daq2_xcvr CONFIG.TXPI_CFG3 0
ad_ip_parameter util_daq2_xcvr CONFIG.TXPI_CFG4 1
ad_ip_parameter util_daq2_xcvr CONFIG.TX_PI_BIASSET 1

ad_ip_parameter util_daq2_xcvr CONFIG.PPF0_CFG 0x0600      ;#16'b0000011000000000
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL0_CFG2 0x0fc1    ;#16'b0000111111000001
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL0_CFG2_G3 0x0fc1 ;#16'b0000111111000001
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL0_CFG4 0x0003    ;#16'b0000000000000011
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL0_LPF 0x27f      ;#10'b1001111111
