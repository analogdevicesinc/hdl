
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_sys_dmafifo [current_bd_instance .] axi_ad9680_fifo 128 16

source ../common/daq2_bd.tcl


