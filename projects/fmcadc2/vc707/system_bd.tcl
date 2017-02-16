
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_adcfifo.tcl

p_sys_adcfifo [current_bd_instance .] axi_ad9625_fifo 256 18

source ../common/fmcadc2_bd.tcl

set_property -dict [list CONFIG.LPM_OR_DFE_N {1}] [get_bd_cells axi_ad9625_xcvr]
set_property -dict [list CONFIG.SYS_CLK_SEL {0}] [get_bd_cells axi_ad9625_xcvr]
set_property -dict [list CONFIG.OUT_CLK_SEL {2}] [get_bd_cells axi_ad9625_xcvr]

