
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/fmcomms5_bd.tcl

set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7

# ila (adc) master

set ila_adc_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc_0]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc_0
set_property -dict [list CONFIG.C_NUM_OF_PROBES {5}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE0_WIDTH {62}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE1_WIDTH {112}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE2_WIDTH {112}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] $ila_adc_0
set_property -dict [list CONFIG.C_PROBE4_WIDTH {128}] $ila_adc_0
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc_0

ad_connect axi_ad9361_0_clk ila_adc_0/clk
ad_connect axi_ad9361_0/dev_l_dbg_data ila_adc_0/probe0
ad_connect axi_ad9361_0/dev_dbg_data ila_adc_0/probe1
ad_connect axi_ad9361_1/dev_dbg_data ila_adc_0/probe2
ad_connect util_adc_pack_0/dvalid ila_adc_0/probe3
ad_connect util_adc_pack_0/ddata ila_adc_0/probe4

# ila (adc) slave

set ila_adc_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc_1]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc_1
set_property -dict [list CONFIG.C_NUM_OF_PROBES {1}] $ila_adc_1
set_property -dict [list CONFIG.C_PROBE0_WIDTH {62}] $ila_adc_1
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc_1

ad_connect axi_ad9361_1_clk ila_adc_1/clk
ad_connect axi_ad9361_1/dev_l_dbg_data ila_adc_1/probe0

