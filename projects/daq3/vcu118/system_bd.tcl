
## FIFO depth is 4Mb - 250k samples
set adc_fifo_address_width 16

## FIFO depth is 4Mb - 250k samples
set dac_fifo_address_width 15


source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq3_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG0 0x331C
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG1 0xD038
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG2 0xFC1
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG3 0x120
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG4 0x2
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG1_G3 0xD038
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_CFG2_G3 0xFC1

ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG0 0x3fe
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG1 0x29
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG2 0x203
ad_ip_parameter util_daq3_xcvr CONFIG.RX_CLK25_DIV 25
ad_ip_parameter util_daq3_xcvr CONFIG.TX_CLK25_DIV 25

ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC true
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_ad9152_dma CONFIG.AXI_SLICE_SRC true
