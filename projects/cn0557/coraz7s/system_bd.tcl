
source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 200

ad_ip_instance gmii_to_rgmii gmii_to_rgmii_0
ad_ip_parameter gmii_to_rgmii_0 CONFIG.SupportLevel Include_Shared_Logic_in_Core

make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/RGMII]

ad_connect sys_ps7/GMII_ETHERNET_0 gmii_to_rgmii_0/GMII
ad_connect sys_ps7/MDIO_ETHERNET_0 gmii_to_rgmii_0/MDIO_GEM

ad_connect gmii_to_rgmii_0/clkin sys_ps7/FCLK_CLK1

ad_connect gmii_to_rgmii_0/tx_reset sys_cpu_reset
ad_connect gmii_to_rgmii_0/rx_reset sys_cpu_reset

make_bd_pins_external  [get_bd_pins gmii_to_rgmii_0/clock_speed]

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
