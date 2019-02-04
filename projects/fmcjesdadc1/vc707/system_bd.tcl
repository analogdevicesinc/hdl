
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl

ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_ad9250_0_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_DATA_WIDTH_DEST 256
ad_ip_parameter axi_ad9250_1_dma CONFIG.FIFO_SIZE 32

## Board specific GT configuration
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.GTX_QPLL_FBDIV 0x80

