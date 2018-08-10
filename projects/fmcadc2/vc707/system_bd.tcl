
## FIFO depth is 16Mb - 1M samples
set adc_fifo_name axi_ad9625_fifo
set adc_fifo_address_width 18
set adc_data_width 256
set adc_dma_data_width 64

## NOTE: With this configuration the #36Kb BRAM utilization is at ~68%

source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/fmcadc2_bd.tcl

