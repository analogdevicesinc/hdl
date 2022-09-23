source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/cn0363_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 35

set_property LEFT 34 [get_bd_ports GPIO_I]
set_property LEFT 34 [get_bd_ports GPIO_O]
set_property LEFT 34 [get_bd_ports GPIO_T]
