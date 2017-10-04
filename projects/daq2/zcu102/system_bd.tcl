
set adc_fifo_name axi_ad9680_fifo
set adc_fifo_address_width 16
set adc_data_width 128
set adc_dma_data_width 64

set dac_fifo_name axi_ad9144_fifo
set dac_fifo_address_width 10
set dac_data_width 128
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/daq2_bd.tcl

ad_ip_parameter axi_daq2_xcvr CONFIG.GT_Location {X1Y8}

ad_connect axi_daq2_xcvr/gt0_rx axi_ad9680_jesd/rx_phy0
ad_connect axi_daq2_xcvr/gt1_rx axi_ad9680_jesd/rx_phy3
ad_connect axi_daq2_xcvr/gt2_rx axi_ad9680_jesd/rx_phy1
ad_connect axi_daq2_xcvr/gt3_rx axi_ad9680_jesd/rx_phy2

ad_connect axi_ad9144_jesd/tx_phy0 axi_daq2_xcvr/gt0_tx
ad_connect axi_ad9144_jesd/tx_phy2 axi_daq2_xcvr/gt1_tx
ad_connect axi_ad9144_jesd/tx_phy3 axi_daq2_xcvr/gt2_tx
ad_connect axi_ad9144_jesd/tx_phy1 axi_daq2_xcvr/gt3_tx

