
set adc_fifo_name axi_ad9684_fifo
set adc_fifo_address_width 10
set adc_data_width 64
set adc_dma_data_width 64

source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/daq1_bd.tcl
