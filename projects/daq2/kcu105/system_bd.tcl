
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_sys_dmafifo [current_bd_instance .] axi_ad9680_fifo 128 16
p_sys_dacfifo [current_bd_instance .] axi_ad9144_fifo 128 10

source ../common/daq2_bd.tcl

set_property -dict [list CONFIG.GTH_OR_GTX_N {1}] $axi_daq2_gt
set_property -dict [list CONFIG.QPLL0_FBDIV {20}] $axi_daq2_gt
set_property -dict [list CONFIG.QPLL0_REFCLK_DIV {1}] $axi_daq2_gt


