
set dac_fifo_address_width 10

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_dacfifo_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 200

source ../common/adrv9371x_bd.tcl

ad_connect  sys_dma_clk sys_ps7/FCLK_CLK2
ad_connect  sys_ps7/FCLK_RESET2_N sys_dma_rstgen/ext_reset_in
