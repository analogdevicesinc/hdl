
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/cn0363_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 35

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]
