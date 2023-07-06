###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
##--------------------------------------------------------------
# IMPORTANT: Set CN0506 interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make INTF_CFG=MII
#
#    INTF_CFG  - Defines the interface type (MII, RGMII or RMII)
#
# LEGEND: MII
#         RGMII
#         RMII
#
##--------------------------------------------------------------

set INTF_CFG [get_env_param INTF_CFG RGMII]

switch $INTF_CFG {
  MII {
    source ../common/mii_bd.tcl

    set_property -dict [list \
      CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
      CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO}] [get_bd_cells sys_ps8]

    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/GMII_ENET0]
    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET0]
    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/GMII_ENET1]
    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET1]
  }
  RGMII {
    source ../common/rgmii_bd.tcl

    set_property -dict [list \
      CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
      CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO}] [get_bd_cells sys_ps8]

    ad_connect gmii_to_rgmii_0/GMII sys_ps8/GMII_ENET0
    ad_connect gmii_to_rgmii_1/GMII sys_ps8/GMII_ENET1
    ad_connect gmii_to_rgmii_0/MDIO_GEM sys_ps8/MDIO_ENET0
    ad_connect gmii_to_rgmii_1/MDIO_GEM sys_ps8/MDIO_ENET1

    # Remove the unused 250MHz and 500MHz reset generators added in the base design.

    delete_bd_objs [get_bd_nets sys_500m_clk] \
                   [get_bd_nets sys_500m_reset] \
                   [get_bd_nets sys_500m_resetn] \
                   [get_bd_cells sys_500m_rstgen] \
                   [get_bd_nets sys_250m_resetn] \
                   [get_bd_nets sys_250m_reset] \
                   [get_bd_nets sys_250m_clk] \
                   [get_bd_cells sys_250m_rstgen]
  }
  RMII {
    set_property -dict [list \
      CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
      CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
      CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO} \
      CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0} \
      CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0}] [get_bd_cells sys_ps8]

    create_bd_port -dir O reset_a
    create_bd_port -dir O reset_b
    create_bd_port -dir I ref_clk_50_a
    create_bd_port -dir I ref_clk_50_b

    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M_0
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M_1
    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET0]
    make_bd_intf_pins_external  [get_bd_intf_pins sys_ps8/MDIO_ENET1]

    ad_ip_instance util_mii_to_rmii mii_to_rmii_0
    ad_ip_parameter mii_to_rmii_0 CONFIG.INTF_CFG 1
    ad_ip_parameter mii_to_rmii_0 CONFIG.RATE_10_100 0

    ad_connect mii_to_rmii_0/GMII    sys_ps8/GMII_ENET0
    ad_connect mii_to_rmii_0/ref_clk ref_clk_50_a

    ad_connect mii_to_rmii_0/RMII RMII_PHY_M_0

    ad_ip_instance util_mii_to_rmii mii_to_rmii_1
    ad_ip_parameter mii_to_rmii_1 CONFIG.INTF_CFG 1
    ad_ip_parameter mii_to_rmii_1 CONFIG.RATE_10_100 0

    ad_connect mii_to_rmii_1/GMII    sys_ps8/GMII_ENET1
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
  }
}

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set INTF_CFG $::env(INTF_CFG)
set sys_cstring "$INTF_CFG"
sysid_gen_sys_init_file $sys_cstring
