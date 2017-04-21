
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/cn0363_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 35

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]
