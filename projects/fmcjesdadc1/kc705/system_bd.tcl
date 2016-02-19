
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl

set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {512}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.FIFO_SIZE {32}] $axi_ad9250_0_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {512}] $axi_ad9250_1_dma
set_property -dict [list CONFIG.FIFO_SIZE {32}] $axi_ad9250_1_dma

