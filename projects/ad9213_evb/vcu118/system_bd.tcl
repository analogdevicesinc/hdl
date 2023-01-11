
## FIFO depth is 4Mb - 250k samples (65k samples per converter)
set adc_fifo_address_width 13

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/ad9213_evb_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# Set SPI clock to 100/16 =  6.25 MHz
ad_ip_parameter axi_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter hmc7044_spi CONFIG.C_SCK_RATIO 16

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter util_adc_xcvr CONFIG.RX_CLK25_DIV 30
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG0 0x1fa
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG1 0x2b
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_CFG2 0x2
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_adc_xcvr CONFIG.CH_HSPMUX 0x4040
ad_ip_parameter util_adc_xcvr CONFIG.PREIQ_FREQ_BST 1
ad_ip_parameter util_adc_xcvr CONFIG.RTX_BUF_CML_CTRL 0x5
ad_ip_parameter util_adc_xcvr CONFIG.RXPI_CFG0 0x3002
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_CFG0 0x333c
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_adc_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_adc_xcvr CONFIG.PPF0_CFG 0xB00
