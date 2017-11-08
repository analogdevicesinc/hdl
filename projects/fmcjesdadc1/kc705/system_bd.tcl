
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
source ../common/fmcjesdadc1_bd.tcl

ad_ip_parameter axi_ad9250_0_dma CONFIG.DMA_DATA_WIDTH_DEST 512
ad_ip_parameter axi_ad9250_0_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9250_1_dma CONFIG.DMA_DATA_WIDTH_DEST 512
ad_ip_parameter axi_ad9250_1_dma CONFIG.FIFO_SIZE 32

ad_connect axi_fmcadc1_xcvr/gt0_rx axi_fmcadc1_jesd/rx_phy0
ad_connect axi_fmcadc1_xcvr/gt1_rx axi_fmcadc1_jesd/rx_phy1
ad_connect axi_fmcadc1_xcvr/gt2_rx axi_fmcadc1_jesd/rx_phy2
ad_connect axi_fmcadc1_xcvr/gt3_rx axi_fmcadc1_jesd/rx_phy3

