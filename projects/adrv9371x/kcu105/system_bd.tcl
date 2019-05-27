
## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

## NOTE: With this configuration the #36Kb BRAM utilization is at ~68%

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

source ../common/adrv9371x_bd.tcl

ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1

