
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
