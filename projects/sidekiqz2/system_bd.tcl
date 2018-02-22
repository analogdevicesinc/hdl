# create board design

source ../pluto/system_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 19

set_property LEFT 18 [get_bd_ports /gpio_i]
set_property LEFT 18 [get_bd_ports /gpio_o]
set_property LEFT 18 [get_bd_ports /gpio_t]

