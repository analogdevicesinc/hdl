
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {32}] $sys_ps7
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.NUM_PORTS {5}] $sys_concat_intc

set_property LEFT 31 [get_bd_ports GPIO_I]
set_property LEFT 31 [get_bd_ports GPIO_O]
set_property LEFT 31 [get_bd_ports GPIO_T]

