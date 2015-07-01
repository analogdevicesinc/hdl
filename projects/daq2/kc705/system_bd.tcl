
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_sys_dmafifo [current_bd_instance .] axi_ad9680_fifo 128 16
p_sys_dacfifo [current_bd_instance .] axi_ad9144_fifo 128 10

source ../common/daq2_bd.tcl


