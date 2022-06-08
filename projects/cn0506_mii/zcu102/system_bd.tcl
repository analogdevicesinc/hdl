
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl

# configuring one parameter at a time will end in a validation proces halt
set_property -dict [list \
  CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
  CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO}] [get_bd_cells sys_ps8]

source ../common/cn0506_bd.tcl

make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/GMII_ENET0]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET0]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/GMII_ENET1]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET1]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
