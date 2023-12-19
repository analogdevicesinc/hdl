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

adi_ip_instance -vlnv {latticesemi.com:ip:dma_fifo:2.0.0} \
  -ip_path "$preinst_ip_mod_dir/ip/Automation/latticesemi.com_ip_fifo_dma_2.0.0" \
  -ip_params {
    "TX_FIFO_EN": 1
  } \
  -ip_iname "dma_fifo_inst"

adi_ip_update -vlnv {latticesemi.com:ip:cpu0:2.4.0} \
  -ip_path "$ip_download_path/latticesemi.com_ip_riscv_mc_2.4.0" \
  -ip_params {
    "SIMULATION": false,
    "DEBUG_ENABLE": true,
    "M_STANDALONE": true,
    "IRQ_NUM": 6
  } \
  -ip_iname "cpu0_inst"

adi_ip_update -vlnv {latticesemi.com:module:ahbl0:1.3.0} \
  -ip_path "$preinst_ip_mod_dir/ip/common/ahb_lite_interconnect" \
  -ip_params {
    "TOTAL_MASTER_CNT": 3,
    "TOTAL_SLAVE_CNT": 7
  } \
  -ip_iname "ahbl0_inst"

sbp_design save

sbp_add_port -direction in ref_clk_125_p

sbp_add_port -direction in rgmii_rxc_a
sbp_add_port -direction in rgmii_rx_ctl_a
sbp_add_port -from 3 -to 0 -direction in rgmii_rxd_a

sbp_add_port -direction out rgmii_txc_a
sbp_add_port -direction out rgmii_tx_ctl_a
sbp_add_port -from 3 -to 0 -direction out rgmii_txd_a
sbp_add_port -direction out rgmii_rstn_a

sbp_add_port -direction in rgmii_rxc_b
sbp_add_port -direction in rgmii_rx_ctl_b
sbp_add_port -from 3 -to 0 -direction in rgmii_rxd_b

sbp_add_port -direction out rgmii_txc_b
sbp_add_port -direction out rgmii_tx_ctl_b
sbp_add_port -from 3 -to 0 -direction out rgmii_txd_b
sbp_add_port -direction out rgmii_rstn_b

sbp_add_port -direction inout mdio_fmc_a
sbp_add_port -direction out   mdc_fmc_a

sbp_add_port -direction inout mdio_fmc_b
sbp_add_port -direction out   mdc_fmc_b

sbp_connect_net "$project_name/ether_control_inst/RGMII_RST_N_P1" \
  "$project_name/rgmii_rstn_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RST_N_P2" \
  "$project_name/rgmii_rstn_b"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RD_P1" \
  "$project_name/rgmii_rxd_a"

sbp_connect_net "$project_name/ether_control_inst/RGMII_RD_P2" \
  "$project_name/rgmii_rxd_b"

sbp_connect_net -name [sbp_get_nets -from $project_name/pll0_inst *clkop*] \
  "$project_name/ether_control_inst/CLK_AHBL0" \
  "$project_name/dma_fifo_inst/clk_i"

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

sbp_connect_net -name [sbp_get_nets -from $project_name/cpu0_inst *resetn*] \
  "$project_name/ether_control_inst/rst_n" \
  "$project_name/dma_fifo_inst/rst_n_i"

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

sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M05" \
  "$project_name/ether_control_inst/AHBL_S0_Ethercon_IP"

sbp_connect_interface_net "$project_name/dma_fifo_inst/AHBL_M0_INSTR" \
  "$project_name/ahbl0_inst/AHBL_S02"

sbp_connect_interface_net "$project_name/ahbl0_inst/AHBL_M06" \
  "$project_name/dma_fifo_inst/AHBL_FIFO_DMA"

sbp_connect_net "$project_name/dma_fifo_inst/tx_fifo_we_o" \
  "$project_name/ether_control_inst/tx_fifo_we_i"

sbp_connect_net "$project_name/dma_fifo_inst/tx_fifo_wr_clk_o" \
  "$project_name/ether_control_inst/tx_fifo_wr_clk_i"

sbp_connect_net "$project_name/ether_control_inst/tx_fifo_full_o" \
  "$project_name/dma_fifo_inst/tx_fifo_full_i"

sbp_connect_net "$project_name/dma_fifo_inst/tx_fifo_data_o" \
  "$project_name/ether_control_inst/tx_fifo_data_i"

sbp_assign_addr_seg -offset 'h00108000 "$project_name/ahbl0_inst/AHBL_M05" \
  "$project_name/ether_control_inst/AHBL_S0_Ethercon_IP"

sbp_assign_addr_seg -offset 'h00100000 "$project_name/ahbl0_inst/AHBL_M06" \
  "$project_name/dma_fifo_inst/AHBL_FIFO_DMA"
