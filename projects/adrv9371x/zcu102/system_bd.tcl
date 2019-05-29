
## FIFO depth is 16Mb - 1M samples
set dac_fifo_address_width 17

## NOTE: With this configuration the #36Kb BRAM utilization is at ~51%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

source ../common/adrv9371x_bd.tcl

ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.TX_DIFFCTRL 6

ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1

