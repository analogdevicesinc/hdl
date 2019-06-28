
## FIFO depth is 16Mb - 1M samples
set dac_fifo_address_width 17

## NOTE: With this configuration the #36Kb BRAM utilization is at ~51%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 200

source ../common/adrv9371x_bd.tcl

ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.TX_DIFFCTRL 6

ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1
