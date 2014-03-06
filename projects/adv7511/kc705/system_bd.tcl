
source $ad_hdl_dir/projects/common/kc705/kc705_system_bd.tcl
set_property -dict [list CONFIG.NUM_MI {14}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_SI {8}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_PORTS {8}] $sys_concat_intc


