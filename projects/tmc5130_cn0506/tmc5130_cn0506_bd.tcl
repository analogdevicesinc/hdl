###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

########### This file contains only the tcl commands for importing lib ########
########### components and the assemly of the design. #########################

set preinst_ip_mod_dir ${env(TOOLRTF)}
set ip_download_path ${env(USERPROFILE)}/PropelIPLocal
set conf_dir $ad_hdl_dir/projects/tmc5130_cn0506/ipcfg

## configure ip components and add to design. #################################
adi_ip_instance -vlnv {latticesemi.com:ip:ether_control:2.3.0} \
  -ip_path "$preinst_ip_mod_dir/ip/Automation/latticesemi.com_ip_Etherconnect_2.3.0" \
  -ip_params {
    "SYSTEM_TYPE": 1,
    "PORT_1_MII_INTRF": 0,
    "PORT_2_MII_INTRF": 0,
    "SIM": 0
  } \
  -ip_iname "ether_control_inst"

sbp_add_port -direction in ref_clk_125_p

sbp_add_port -direction in rgmii_rxc_a
sbp_add_port -direction in rgmii_rx_ctl_a
sbp_add_port -from 3 -to 0 -direction in rgmii_rxd_a

sbp_add_port -direction out rgmii_txc_a
sbp_add_port -direction out rgmii_tx_ctl_a
sbp_add_port -from 3 -to 0 -direction out rgmii_txd_a

sbp_add_port -direction in rgmii_rxc_b
sbp_add_port -direction in rgmii_rx_ctl_b
sbp_add_port -from 3 -to 0 -direction in rgmii_rxd_b

sbp_add_port -direction out rgmii_txc_b
sbp_add_port -direction out rgmii_tx_ctl_b
sbp_add_port -from 3 -to 0 -direction out rgmii_txd_b

sbp_add_port -direction inout mdio_fmc_a
sbp_add_port -direction out   mdc_fmc_a

sbp_add_port -direction inout mdio_fmc_b
sbp_add_port -direction out   mdc_fmc_b

sbp_connect_net "$project_name/ether_control_inst/RGMII_RD_P1" \
  "$project_name/rgmii_rxd_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RD_P2" \
  "$project_name/rgmii_rxd_b"

sbp_connect_net "$project_name/pll0_inst/clkop_o" \
  "$project_name/ahbl2apb0_inst/clk_i" \
  "$project_name/ahbl0_inst/ahbl_hclk_i" \
  "$project_name/cpu0_inst/clk_i" \
  "$project_name/sysmem0_inst/ahbl_hclk_i"  \
  "$project_name/spi0_inst/clk_i"  \
  "$project_name/ether_control_inst/CLK_AHBL0"

sbp_connect_net "$project_name/ether_control_inst/CLK_IN_125" \
  "$project_name/ref_clk_125_p"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RX_CLK_IN_P1" \
  "$project_name/rgmii_rxc_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RX_CLK_IN_P2" \
  "$project_name/rgmii_rxc_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RX_CTL_P1" \
  "$project_name/rgmii_rx_ctl_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RX_CTL_P2" \
  "$project_name/rgmii_rx_ctl_b"

sbp_connect_net "$project_name/cpu0_inst/system_resetn_o" \
  "$project_name/ahbl2apb0_inst/presetn_i" \
  "$project_name/ahbl2apb0_inst/rst_n_i" \
  "$project_name/apb0_inst/apb_presetn_i" \
  "$project_name/uart0_inst/rst_n_i" \
  "$project_name/ahbl0_inst/ahbl_hresetn_i" \
  "$project_name/gpio0_inst/resetn_i" \
  "$project_name/gpio1_inst/resetn_i" \
  "$project_name/sysmem0_inst/ahbl_hresetn_i" \
  "$project_name/spi0_inst/rst_n_i" \
  "$project_name/i2c0_inst/rst_n_i" \
  "$project_name/ether_control_inst/rst_n"

sbp_connect_net "$project_name/ether_control_inst/RGMII_TD_P1" \
  "$project_name/rgmii_txd_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_TD_P2" \
  "$project_name/rgmii_txd_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_CLK_OUT_P1" \
  "$project_name/rgmii_txc_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_CLK_OUT_P2" \
  "$project_name/rgmii_txc_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_PHY_MDC_P1" \
  "$project_name/mdc_fmc_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_PHY_MDC_P2" \
  "$project_name/mdc_fmc_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_PHY_MDIO_P1" \
  "$project_name/mdio_fmc_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_PHY_MDIO_P2" \
  "$project_name/mdio_fmc_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_TX_CTL_P1" \
  "$project_name/rgmii_tx_ctl_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_TX_CTL_P2" \
  "$project_name/rgmii_tx_ctl_b"

sbp_connect_interface_net "$project_name/ether_control_inst/ethercon_INTR" \
  "$project_name/cpu0_inst/IRQ_S5"

sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M03" \
  "$project_name/ether_control_inst/AHBL_S0_Ethercon_IP"

sbp_assign_addr_seg -offset 'h00010000 "$project_name/ahbl0_inst/AHBL_M03" \
  "$project_name/ether_control_inst/AHBL_S0_Ethercon_IP"
  