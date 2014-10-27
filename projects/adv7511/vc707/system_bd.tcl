
source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_SI {8}] $axi_mem_interconnect
set_property -dict [list CONFIG.NUM_MI {1}] $axi_mem_interconnect


