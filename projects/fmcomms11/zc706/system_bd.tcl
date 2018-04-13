
set adc_fifo_name axi_ad9625_fifo
set adc_fifo_address_width 18
set adc_data_width 256
set adc_dma_data_width 64

set dac_fifo_name axi_ad9162_fifo
set dac_fifo_address_width 10
set dac_data_width 256
set dac_dma_data_width 256

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/fmcomms11_bd.tcl

