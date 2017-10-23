
set adc_fifo_name axi_usdrx1_fifo
set adc_fifo_address_width 18
set adc_data_width 512
set adc_dma_data_width 64

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
source ../common/usdrx1_bd.tcl

ad_connect axi_usdrx1_xcvr/gt0_rx axi_usdrx1_jesd/rx_phy0
ad_connect axi_usdrx1_xcvr/gt1_rx axi_usdrx1_jesd/rx_phy1
ad_connect axi_usdrx1_xcvr/gt2_rx axi_usdrx1_jesd/rx_phy2
ad_connect axi_usdrx1_xcvr/gt3_rx axi_usdrx1_jesd/rx_phy3
ad_connect axi_usdrx1_xcvr/gt4_rx axi_usdrx1_jesd/rx_phy4
ad_connect axi_usdrx1_xcvr/gt5_rx axi_usdrx1_jesd/rx_phy5
ad_connect axi_usdrx1_xcvr/gt6_rx axi_usdrx1_jesd/rx_phy6
ad_connect axi_usdrx1_xcvr/gt7_rx axi_usdrx1_jesd/rx_phy7
