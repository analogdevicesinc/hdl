
## FIFO depth is 16Mb - 1M Samples
set adc_fifo_address_width 18

## NOTE: With this configuration the #36Kb BRAM utilization is at ~70%

source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/fmcadc5_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

# ila

ad_ip_instance util_mfifo mfifo_adc
ad_ip_parameter mfifo_adc CONFIG.NUM_OF_CHANNELS 1
ad_ip_parameter mfifo_adc CONFIG.DIN_DATA_WIDTH 512
ad_ip_parameter mfifo_adc CONFIG.ADDRESS_WIDTH 6

ad_ip_instance ila ila_adc
ad_ip_parameter ila_adc CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_adc CONFIG.C_TRIGIN_EN false
ad_ip_parameter ila_adc CONFIG.C_EN_STRG_QUAL 1
ad_ip_parameter ila_adc CONFIG.C_NUM_OF_PROBES 2
ad_ip_parameter ila_adc CONFIG.C_PROBE0_WIDTH 1
ad_ip_parameter ila_adc CONFIG.C_PROBE1_WIDTH 16

ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 mfifo_adc/din_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset mfifo_adc/din_rst
ad_connect  axi_fmcadc5_sync/rx_enable mfifo_adc/din_valid
ad_connect  axi_fmcadc5_sync/rx_data mfifo_adc/din_data_0
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset mfifo_adc/dout_rst
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 mfifo_adc/dout_clk
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 ila_adc/clk
ad_connect  mfifo_adc/dout_valid ila_adc/probe0
ad_connect  mfifo_adc/dout_data_0 ila_adc/probe1

