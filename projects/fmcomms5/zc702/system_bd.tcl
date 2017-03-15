
source $ad_hdl_dir/projects/common/zc702/zc702_system_bd.tcl

set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {150.0}] $sys_ps7
ad_connect  sys_dma_clk sys_ps7/FCLK_CLK2
source ../common/fmcomms5_bd.tcl

set_property CONFIG.ADC_INIT_DELAY 24 [get_bd_cells axi_ad9361_0]
set_property CONFIG.ADC_INIT_DELAY 24 [get_bd_cells axi_ad9361_1]

