###############################################################################
## Copyright (C) 2022-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
    create_bd_port -dir O -from 2 -to 0 emio_enet0_speed_mode
    create_bd_port -dir O -from 2 -to 0 emio_enet1_speed_mode

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

    ad_connect sys_ps8/emio_enet0_speed_mode emio_enet0_speed_mode
    ad_connect sys_ps8/emio_enet1_speed_mode emio_enet1_speed_mode
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

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "$INTF_CFG"

sysid_gen_sys_init_file $sys_cstring
