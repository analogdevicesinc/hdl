
set dac_fifo_name axi_ad9371_dacfifo
set dac_fifo_address_width 10
set dac_data_width 128
set dac_dma_data_width 128

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ 200

source ../common/adrv9371x_bd.tcl

ad_connect sys_dma_clk axi_ddr_cntrl/addn_ui_clkout3
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset

ad_ip_parameter axi_ad9371_tx_xcvr CONFIG.XCVR_TYPE 1
ad_ip_parameter axi_ad9371_rx_xcvr CONFIG.XCVR_TYPE 1
ad_ip_parameter axi_ad9371_rx_os_xcvr CONFIG.XCVR_TYPE 1

ad_ip_parameter util_ad9371_xcvr CONFIG.XCVR_TYPE 1
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_ad9371_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_ad9371_rx_clkgen CONFIG.DEVICE_TYPE 2
ad_ip_parameter axi_ad9371_tx_clkgen CONFIG.DEVICE_TYPE 2
