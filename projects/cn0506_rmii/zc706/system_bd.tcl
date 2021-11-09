
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {100 Mbps}

create_bd_port -dir O reset_a
create_bd_port -dir O reset_b
create_bd_port -dir I ref_clk_50_a
create_bd_port -dir I ref_clk_50_b

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M_0
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M_1
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_0]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]

ad_ip_instance util_mii_to_rmii mii_to_rmii_0
ad_ip_parameter mii_to_rmii_0 CONFIG.INTF_CFG 1
ad_ip_parameter mii_to_rmii_0 CONFIG.RATE_10_100 0

ad_connect mii_to_rmii_0/GMII    sys_ps7/GMII_ETHERNET_0
ad_connect mii_to_rmii_0/ref_clk ref_clk_50_a

ad_connect mii_to_rmii_0/RMII RMII_PHY_M_0

ad_ip_instance util_mii_to_rmii mii_to_rmii_1
ad_ip_parameter mii_to_rmii_1 CONFIG.INTF_CFG 1
ad_ip_parameter mii_to_rmii_1 CONFIG.RATE_10_100 0

ad_connect mii_to_rmii_1/GMII    sys_ps7/GMII_ETHERNET_1
ad_connect mii_to_rmii_1/ref_clk ref_clk_50_b

ad_connect mii_to_rmii_1/RMII RMII_PHY_M_1

ad_ip_instance proc_sys_reset proc_sys_reset_eth0
ad_connect proc_sys_reset_eth0/slowest_sync_clk  ref_clk_50_a
ad_connect proc_sys_reset_eth0/ext_reset_in  sys_rstgen/peripheral_aresetn
ad_connect proc_sys_reset_eth0/peripheral_reset  reset_a
ad_connect proc_sys_reset_eth0/peripheral_aresetn  mii_to_rmii_0/reset_n

ad_ip_instance proc_sys_reset proc_sys_reset_eth1
ad_connect proc_sys_reset_eth1/slowest_sync_clk  ref_clk_50_b
ad_connect proc_sys_reset_eth1/ext_reset_in  sys_rstgen/peripheral_aresetn
ad_connect proc_sys_reset_eth1/peripheral_reset  reset_b
ad_connect proc_sys_reset_eth1/peripheral_aresetn  mii_to_rmii_1/reset_n

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
