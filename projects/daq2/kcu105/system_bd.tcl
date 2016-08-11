
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_sys_dmafifo [current_bd_instance .] axi_ad9680_fifo 128 16
p_sys_dacfifo [current_bd_instance .] axi_ad9144_fifo 128 10

source ../common/daq2_bd.tcl

set_property -dict [list CONFIG.GTH_OR_GTX_N {1}] $util_daq2_xcvr
set_property -dict [list CONFIG.QPLL_FBDIV {20}] $util_daq2_xcvr
set_property -dict [list CONFIG.QPLL_REFCLK_DIV {1}] $util_daq2_xcvr


