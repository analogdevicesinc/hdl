
## FIFO depth is 8Mb - 500k samples
set adc_fifo_address_width 17

## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

source $ad_hdl_dir/projects/common/vc709/vc709_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq2_bd.tcl

#shared transciever core parameters
ad_ip_parameter util_daq2_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_daq2_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_daq2_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_daq2_xcvr CONFIG.RX_DFE_LPM_CFG 0x80
ad_ip_parameter util_daq2_xcvr CONFIG.RX_PMA_CFG 0x80
ad_ip_parameter util_daq2_xcvr CONFIG.RX_CDR_CFG 0x2007FE2000C208001A
ad_ip_parameter util_daq2_xcvr CONFIG.RXPI_CFG0 0x0
ad_ip_parameter util_daq2_xcvr CONFIG.RXPI_CFG1 0x3
ad_ip_parameter util_daq2_xcvr CONFIG.TXPI_CFG0 0x0
ad_ip_parameter util_daq2_xcvr CONFIG.TXPI_CFG1 0x0

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
sysid_gen_sys_init_file 
