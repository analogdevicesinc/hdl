
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl

create_bd_port -dir O reset_n

ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1

ad_connect sys_rstgen/peripheral_aresetn reset_n

make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/GMII_ETHERNET_1]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
sysid_gen_sys_init_file

