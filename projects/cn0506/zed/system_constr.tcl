###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mdio_fmc_a]      ; ## H16 FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS25} [get_ports mdc_fmc_a]                   ; ## H17 FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports reset_a]                     ; ## H19 FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS25} [get_ports link_st_a]                   ; ## H10 FMC_LPC_LA04_P

set_property -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS25} [get_ports led_0_a]                     ; ## G12 FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN P20  IOSTANDARD LVCMOS25} [get_ports led_ar_c_c2m]                ; ## G15 FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS25} [get_ports led_ar_a_c2m]                ; ## G16 FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17  IOSTANDARD LVCMOS25} [get_ports led_al_c_c2m]                ; ## D17 FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17  IOSTANDARD LVCMOS25} [get_ports led_al_a_c2m]                ; ## D18 FMC_LPC_LA13_N

set_property -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mdio_fmc_b]      ; ## H31 FMC_LPC_LA28_P
set_property -dict {PACKAGE_PIN A17  IOSTANDARD LVCMOS25} [get_ports mdc_fmc_b]                   ; ## H32 FMC_LPC_LA28_N
set_property -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS25} [get_ports reset_b]                     ; ## H20 FMC_LPC_LA15_N
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS25} [get_ports link_st_b]                   ; ## G27 FMC_LPC_LA25_P

set_property -dict {PACKAGE_PIN E15  IOSTANDARD LVCMOS25} [get_ports led_0_b]                     ; ## D23 FMC_LPC_LA23_P
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS25} [get_ports led_bl_c_c2m]                ; ## D26 FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS25} [get_ports led_bl_a_c2m]                ; ## D27 FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN J20  IOSTANDARD LVCMOS25} [get_ports led_br_c_c2m]                ; ## G18 FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21  IOSTANDARD LVCMOS25} [get_ports led_br_a_c2m]                ; ## G19 FMC_LPC_LA16_N

if {![info exists INTF_CFG]} {
  set INTF_CFG $::env(INTF_CFG)
}

switch $INTF_CFG {
  "MII" {

    set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports mii_rx_clk_a]                ; ## G06 FMC_LPC_LA00_CC_P
    set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports mii_rx_er_a]                 ; ## D09 FMC_LPC_LA01_CC_N
    set_property -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS25} [get_ports mii_rx_dv_a]                 ; ## H14 FMC_LPC_LA07_N
    set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_a[0]}]              ; ## H07 FMC_LPC_LA02_P
    set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_a[1]}]              ; ## H08 FMC_LPC_LA02_N
    set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_a[2]}]              ; ## G09 FMC_LPC_LA03_P
    set_property -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_a[3]}]              ; ## G10 FMC_LPC_LA03_N
    set_property -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_clk_a]      ; ## H11 FMC_LPC_LA04_N
    set_property -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_en_a]       ; ## H13 FMC_LPC_LA07_P
    set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_a[0]}]    ; ## D14 FMC_LPC_LA09_P
    set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_a[1]}]    ; ## D15 FMC_LPC_LA09_N
    set_property -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_a[2]}]    ; ## C10 FMC_LPC_LA06_P
    set_property -dict {PACKAGE_PIN L22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_a[3]}]    ; ## C11 FMC_LPC_LA06_N 

    set_property -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS25} [get_ports mii_crs_a]                   ; ## G13 FMC_LPC_LA08_N

    set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS25} [get_ports mii_rx_clk_b]                ; ## C22 FMC_LPC_LA18_CC_P
    set_property -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS25} [get_ports mii_rx_er_b]                 ; ## D21 FMC_LPC_LA17_CC_N
    set_property -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS25} [get_ports mii_rx_dv_b]                 ; ## H29 FMC_LPC_LA24_N
    set_property -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_b[0]}]              ; ## H22 FMC_LPC_LA19_P
    set_property -dict {PACKAGE_PIN G16  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_b[1]}]              ; ## H23 FMC_LPC_LA19_N
    set_property -dict {PACKAGE_PIN G20  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_b[2]}]              ; ## G21 FMC_LPC_LA20_P
    set_property -dict {PACKAGE_PIN G21  IOSTANDARD LVCMOS25} [get_ports {mii_rxd_b[3]}]              ; ## G22 FMC_LPC_LA20_N
    set_property -dict {PACKAGE_PIN C22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_clk_b]      ; ## G28 FMC_LPC_LA25_N
    set_property -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_en_b]       ; ## H28 FMC_LPC_LA24_P
    set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_b[0]}]    ; ## H25 FMC_LPC_LA21_P
    set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_b[1]}]    ; ## H26 FMC_LPC_LA21_N
    set_property -dict {PACKAGE_PIN G19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_b[2]}]    ; ## G24 FMC_LPC_LA22_P
    set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd_b[3]}]    ; ## G25 FMC_LPC_LA22_N

    set_property -dict {PACKAGE_PIN D15  IOSTANDARD LVCMOS25} [get_ports mii_crs_b]                   ; ## D24 FMC_LPC_LA23_N

    create_clock -name rx_clk_1       -period 40.0 [get_ports mii_rx_clk_a]
    create_clock -name rx_clk_2       -period 40.0 [get_ports mii_rx_clk_b]
    create_clock -name tx_clk_1       -period 40.0 [get_ports mii_tx_clk_a]
    create_clock -name tx_clk_2       -period 40.0 [get_ports mii_tx_clk_b]

    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mii_tx_clk_a*]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mii_tx_clk_b*]

  }
  "RGMII" {

    set_property -dict {PACKAGE_PIN L18  IOSTANDARD LVDS_25} [get_ports ref_clk_125_p]                ; ## H04  FMC_LPC_CLK0_M2C_P
    set_property -dict {PACKAGE_PIN L19  IOSTANDARD LVDS_25} [get_ports ref_clk_125_n]                ; ## H05  FMC_LPC_CLK0_M2C_N

    set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports rgmii_rxc_a]                 ; ## G06 FMC_LPC_LA00_CC_P
    set_property -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS25} [get_ports rgmii_rx_ctl_a]              ; ## H14 FMC_LPC_LA07_N
    set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_a[0]}]            ; ## H07 FMC_LPC_LA02_P
    set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_a[1]}]            ; ## H08 FMC_LPC_LA02_N
    set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_a[2]}]            ; ## G09 FMC_LPC_LA03_P
    set_property -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_a[3]}]            ; ## G10 FMC_LPC_LA03_N
    set_property -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rgmii_txc_a]       ; ## H11 FMC_LPC_LA04_N
    set_property -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rgmii_tx_ctl_a]    ; ## H13 FMC_LPC_LA07_P
    set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_a[0]}]  ; ## D14 FMC_LPC_LA09_P
    set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_a[1]}]  ; ## D15 FMC_LPC_LA09_N
    set_property -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_a[2]}]  ; ## C10 FMC_LPC_LA06_P
    set_property -dict {PACKAGE_PIN L22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_a[3]}]  ; ## C11 FMC_LPC_LA06_N

    set_property -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS25} [get_ports int_n_a]                     ; ## G13 FMC_LPC_LA08_N

    set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS25} [get_ports rgmii_rxc_b]                 ; ## C22 FMC_LPC_LA18_CC_P
    set_property -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS25} [get_ports rgmii_rx_ctl_b]              ; ## H29 FMC_LPC_LA24_N
    set_property -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_b[0]}]            ; ## H22 FMC_LPC_LA19_P
    set_property -dict {PACKAGE_PIN G16  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_b[1]}]            ; ## H23 FMC_LPC_LA19_N
    set_property -dict {PACKAGE_PIN G20  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_b[2]}]            ; ## G21 FMC_LPC_LA20_P
    set_property -dict {PACKAGE_PIN G21  IOSTANDARD LVCMOS25} [get_ports {rgmii_rxd_b[3]}]            ; ## G22 FMC_LPC_LA20_N
    set_property -dict {PACKAGE_PIN C22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rgmii_txc_b]       ; ## G28 FMC_LPC_LA25_N
    set_property -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rgmii_tx_ctl_b]    ; ## H28 FMC_LPC_LA24_P
    set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_b[0]}]  ; ## H25 FMC_LPC_LA21_P
    set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_b[1]}]  ; ## H26 FMC_LPC_LA21_N
    set_property -dict {PACKAGE_PIN G19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_b[2]}]  ; ## G24 FMC_LPC_LA22_P
    set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rgmii_txd_b[3]}]  ; ## G25 FMC_LPC_LA22_N

    set_property -dict {PACKAGE_PIN D15  IOSTANDARD LVCMOS25} [get_ports int_n_b]                     ; ## D24 FMC_LPC_LA23_N

    create_clock -name rx_clk_1       -period  8.0 [get_ports rgmii_rxc_a]
    create_clock -name rx_clk_2       -period  8.0 [get_ports rgmii_rxc_b]
    create_clock -name ref_clk_125    -period  8.0 [get_ports ref_clk_125_p]

  }
  "RMII" {

    set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports rmii_rx_ref_clk_a]            ; ## D08 FMC_LPC_LA01_CC_P
    set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports rmii_rx_er_a]                 ; ## D09 FMC_LPC_LA01_CC_N
    set_property -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS25 PULLUP true} [get_ports rmii_rx_dv_a]     ; ## H14 FMC_LPC_LA07_N
    set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mac_if_sel_0_a]   ; ## G06 FMC_HPC1_LA00_CC_P
    set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_a[0]}]              ; ## H07 FMC_LPC_LA02_P
    set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_a[1]}]              ; ## H08 FMC_LPC_LA02_N
    set_property -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rmii_tx_en_a]       ; ## H13 FMC_LPC_LA07_P
    set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_a[0]}]    ; ## D14 FMC_LPC_LA09_P
    set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_a[1]}]    ; ## D15 FMC_LPC_LA09_N 

    set_property -dict {PACKAGE_PIN B19  IOSTANDARD LVCMOS25} [get_ports rmii_rx_ref_clk_b]            ; ## D20 FMC_LPC_LA17_CC_P
    set_property -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS25} [get_ports rmii_rx_er_b]                 ; ## D21 FMC_LPC_LA17_CC_N
    set_property -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS25 PULLUP true} [get_ports rmii_rx_dv_b]     ; ## H29 FMC_HPC1_LA24_N
    set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mac_if_sel_0_b]   ; ## C22 FMC_HPC1_LA18_CC_P
    set_property -dict {PACKAGE_PIN G15  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_b[0]}]              ; ## H22 FMC_LPC_LA19_P
    set_property -dict {PACKAGE_PIN G16  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_b[1]}]              ; ## H23 FMC_LPC_LA19_N
    set_property -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rmii_tx_en_b]       ; ## H28 FMC_LPC_LA24_P
    set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_b[0]}]    ; ## H25 FMC_LPC_LA21_P
    set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_b[1]}]    ; ## H26 FMC_LPC_LA21_N

    create_clock -name rmii_ref_clk_a  -period 20.0 [get_ports rmii_rx_ref_clk_a]
    create_clock -name rmii_ref_clk_b  -period 20.0 [get_ports rmii_rx_ref_clk_b]

    create_clock -name rmii_rx_clk_0   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/inst/mii_rx_clk_r1_reg/Q]
    create_clock -name rmii_rx_clk_1   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_1/inst/mii_rx_clk_r1_reg/Q]
    create_clock -name rmii_tx_clk_0   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/inst/mii_tx_clk_r1_reg/Q]
    create_clock -name rmii_tx_clk_1   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_1/inst/mii_tx_clk_r1_reg/Q]

  }
}
