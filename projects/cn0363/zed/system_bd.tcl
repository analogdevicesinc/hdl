
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/cn0363_bd.tcl

set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {35}] $sys_ps7

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]
