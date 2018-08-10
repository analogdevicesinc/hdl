
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

