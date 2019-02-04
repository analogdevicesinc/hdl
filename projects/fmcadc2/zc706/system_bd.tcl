
set adc_fifo_address_width 18

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source ../common/fmcadc2_bd.tcl

## Board specific GT configuration
ad_ip_parameter util_fmcadc2_xcvr CONFIG.GTX_QPLL_FBDIV 0x80

