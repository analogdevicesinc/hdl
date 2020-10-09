
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET1_GRP_MDIO_ENABLE 1

source ../common/cn0506_bd.tcl

ad_ip_parameter clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 200
ad_ip_parameter clk_wiz CONFIG.MMCM_CLKIN2_PERIOD 10.0

ad_connect sys_ps7/GMII_ETHERNET_0 gmii_to_rgmii_0/GMII
ad_connect sys_ps7/MDIO_ETHERNET_0 gmii_to_rgmii_0/MDIO_GEM
ad_connect sys_ps7/GMII_ETHERNET_1 gmii_to_rgmii_1/GMII
ad_connect sys_ps7/MDIO_ETHERNET_1 gmii_to_rgmii_1/MDIO_GEM

# Remove the unused 200MHz reset generator added in the base design.

delete_bd_objs [get_bd_nets sys_ps7_FCLK_RESET1_N] \
               [get_bd_nets sys_200m_reset] \
               [get_bd_nets sys_200m_resetn] \
               [get_bd_cells sys_200m_rstgen]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file
