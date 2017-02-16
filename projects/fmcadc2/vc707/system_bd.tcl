
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_adcfifo.tcl

p_sys_adcfifo [current_bd_instance .] axi_ad9625_fifo 256 18

source ../common/fmcadc2_bd.tcl

