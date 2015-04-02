
source $ad_hdl_dir/projects/common/zc702/zc702_system_bd.tcl

set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {150.0}] $sys_ps7
ad_connect  sys_dma_clk sys_ps7/FCLK_CLK2
source ../common/fmcomms5_bd.tcl

# ila (adc) master

set ila_adc_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc_0]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc_0
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE1_WIDTH {128}] $ila_adc_0
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc_0

ad_connect axi_ad9361_0_clk ila_adc_0/clk
ad_connect util_adc_pack_0/dvalid ila_adc_0/probe0
ad_connect util_adc_pack_0/ddata ila_adc_0/probe1
