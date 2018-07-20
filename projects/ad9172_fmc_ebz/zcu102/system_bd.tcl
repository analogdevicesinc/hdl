
set dac_fifo_name axi_ad9172_fifo
set dac_fifo_address_width 13
set dac_data_width 256
set dac_dma_data_width 256

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source ../common/ad9172_fmc_ebz_bd.tcl

ad_ip_parameter axi_ad9172_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_ad9172_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_ad9172_xcvr CONFIG.QPLL_FBDIV 40
ad_ip_parameter util_ad9172_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_ad9172_jesd/tx CONFIG.SYSREF_IOB false

