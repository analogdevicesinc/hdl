
set adc_fifo_name axi_ad9680_fifo
set adc_fifo_address_width 18
set adc_data_width 256
set adc_dma_data_width 64

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source ../common/fmcadc4_bd.tcl

