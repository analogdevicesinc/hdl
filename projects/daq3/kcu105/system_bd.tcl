
set adc_fifo_name axi_ad9680_fifo
set adc_fifo_address_width 16
set adc_data_width 128
set adc_dma_data_width 64

set dac_fifo_name axi_ad9152_fifo
set dac_fifo_address_width 10
set dac_data_width 128
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq3_bd.tcl

set_property -dict [list CONFIG.XCVR_TYPE {1}] $util_daq3_xcvr
set_property -dict [list CONFIG.QPLL_FBDIV {20}] $util_daq3_xcvr
set_property -dict [list CONFIG.QPLL_REFCLK_DIV {1}] $util_daq3_xcvr

