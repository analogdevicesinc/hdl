
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_adcfifo.tcl
source ../common/fmcadc5_bd.tcl

# ila 

set mfifo_adc [create_bd_cell -type ip -vlnv analog.com:user:util_mfifo:1.0 mfifo_adc]
set_property -dict [list CONFIG.NUM_OF_CHANNELS {1}] $mfifo_adc
set_property -dict [list CONFIG.DIN_DATA_WIDTH {512}] $mfifo_adc
set_property -dict [list CONFIG.ADDRESS_WIDTH {6}] $mfifo_adc

set ila_adc [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_adc]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] $ila_adc
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_adc

ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 mfifo_adc/din_clk
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset mfifo_adc/din_rst
ad_connect  util_ad9625_cpack/adc_valid mfifo_adc/din_valid
ad_connect  util_ad9625_cpack/adc_data mfifo_adc/din_data_0
ad_connect  axi_ad9625_0_jesd_rstgen/peripheral_reset mfifo_adc/dout_rst
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 mfifo_adc/dout_clk
ad_connect  util_fmcadc5_0_xcvr/rx_out_clk_0 ila_adc/clk
ad_connect  mfifo_adc/dout_valid ila_adc/probe0
ad_connect  mfifo_adc/dout_data_0 ila_adc/probe1

