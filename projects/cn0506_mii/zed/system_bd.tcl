
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1

source ../common/cn0506_bd.tcl

make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/GMII_ETHERNET_1]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_0]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/GMII_ETHERNET_0]

