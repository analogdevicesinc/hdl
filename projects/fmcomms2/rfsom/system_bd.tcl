
source $ad_hdl_dir/projects/common/rfsom/rfsom_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_wfifo.tcl
source ../common/fmcomms2_bd.tcl

set_property -dict [list CONFIG.PCORE_DAC_IODELAY_ENABLE {1}] $axi_ad9361

