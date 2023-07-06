###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN AE8  IOSTANDARD LVCMOS18 PULLUP true} [get_ports mdio_fmc_a]      ; ## H16 FMC_HPC1_LA11_P
set_property -dict {PACKAGE_PIN AF8  IOSTANDARD LVCMOS18} [get_ports mdc_fmc_a]                   ; ## H17 FMC_HPC1_LA11_N
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports reset_a]                     ; ## H19 FMC_HPC1_LA15_P
set_property -dict {PACKAGE_PIN AF2  IOSTANDARD LVCMOS18} [get_ports link_st_a]                   ; ## H10 FMC_HPC1_LA04_P

set_property -dict {PACKAGE_PIN AE3  IOSTANDARD LVCMOS18} [get_ports led_0_a]                     ; ## G12 FMC_HPC1_LA08_P
set_property -dict {PACKAGE_PIN AD7  IOSTANDARD LVCMOS18} [get_ports led_ar_c_c2m]                ; ## G15 FMC_HPC1_LA12_P
set_property -dict {PACKAGE_PIN AD6  IOSTANDARD LVCMOS18} [get_ports led_ar_a_c2m]                ; ## G16 FMC_HPC1_LA12_N
set_property -dict {PACKAGE_PIN AG8  IOSTANDARD LVCMOS18} [get_ports led_al_c_c2m]                ; ## D17 FMC_HPC1_LA13_P
set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVCMOS18} [get_ports led_al_a_c2m]                ; ## D18 FMC_HPC1_LA13_N

set_property -dict {PACKAGE_PIN T13  IOSTANDARD LVCMOS18 PULLUP true} [get_ports mdio_fmc_b]      ; ## H31 FMC_HPC1_LA28_P
set_property -dict {PACKAGE_PIN R13  IOSTANDARD LVCMOS18} [get_ports mdc_fmc_b]                   ; ## H32 FMC_HPC1_LA28_N

set_property -dict {PACKAGE_PIN AE9  IOSTANDARD LVCMOS18} [get_ports reset_b]                     ; ## H20 FMC_HPC1_LA15_N
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports link_st_b]                   ; ## G27 FMC_HPC1_LA25_P

set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS18} [get_ports led_0_b]                     ; ## D23 FMC_HPC1_LA23_P
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCMOS18} [get_ports led_bl_c_c2m]                ; ## D26 FMC_HPC1_LA26_P
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18} [get_ports led_bl_a_c2m]                ; ## D27 FMC_HPC1_LA26_N
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18} [get_ports led_br_c_c2m]                ; ## G18 FMC_HPC1_LA16_P
set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVCMOS18} [get_ports led_br_a_c2m]                ; ## G19 FMC_HPC1_LA16_N

if {![info exists INTF_CFG]} {
  set INTF_CFG $::env(INTF_CFG)
}

switch $INTF_CFG {
  "MII" {

    set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCMOS18} [get_ports mii_rx_clk_a]                 ; ## G06 FMC_HPC1_LA00_CC_P
    set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVCMOS18} [get_ports mii_rx_er_a]                  ; ## D09 FMC_HPC1_LA01_CC_N
    set_property -dict {PACKAGE_PIN AE4  IOSTANDARD LVCMOS18} [get_ports mii_rx_dv_a]                  ; ## H14 FMC_HPC1_LA07_N
    set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVCMOS18} [get_ports {mii_rxd_a[0]}]               ; ## H07 FMC_HPC1_LA02_P
    set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCMOS18} [get_ports {mii_rxd_a[1]}]               ; ## H08 FMC_HPC1_LA02_N
    set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVCMOS18} [get_ports {mii_rxd_a[2]}]               ; ## G09 FMC_HPC1_LA03_P
    set_property -dict {PACKAGE_PIN AJ1  IOSTANDARD LVCMOS18} [get_ports {mii_rxd_a[3]}]               ; ## G10 FMC_HPC1_LA03_N
    set_property -dict {PACKAGE_PIN AF1  IOSTANDARD LVCMOS18} [get_ports mii_tx_clk_a]                 ; ## H11 FMC_HPC1_LA04_N
    set_property -dict {PACKAGE_PIN AD4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports mii_tx_en_a]        ; ## H13 FMC_HPC1_LA07_P
    set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_a[0]}]     ; ## D14 FMC_HPC1_LA09_P
    set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_a[1]}]     ; ## D15 FMC_HPC1_LA09_N
    set_property -dict {PACKAGE_PIN AH2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_a[2]}]     ; ## C10 FMC_HPC1_LA06_P
    set_property -dict {PACKAGE_PIN AJ2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_a[3]}]     ; ## C11 FMC_HPC1_LA06_N

    set_property -dict {PACKAGE_PIN AF3  IOSTANDARD LVCMOS18} [get_ports mii_crs_a]                    ; ## G13 FMC_HPC1_LA08_N

    set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS18} [get_ports mii_rx_clk_b]                 ; ## C22 FMC_HPC1_LA18_CC_P
    set_property -dict {PACKAGE_PIN AA5  IOSTANDARD LVCMOS18} [get_ports mii_rx_er_b]                  ; ## D21 FMC_HPC1_LA17_CC_N
    set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS18} [get_ports mii_rx_dv_b]                  ; ## H29 FMC_HPC1_LA24_N
    set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports {mii_rxd_b[0]}]               ; ## H22 FMC_HPC1_LA19_P
    set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports {mii_rxd_b[1]}]               ; ## H23 FMC_HPC1_LA19_N
    set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports {mii_rxd_b[2]}]               ; ## G21 FMC_HPC1_LA20_P
    set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports {mii_rxd_b[3]}]               ; ## G22 FMC_HPC1_LA20_N
    set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS18} [get_ports mii_tx_clk_b]                 ; ## G28 FMC_HPC1_LA25_N
    set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports mii_tx_en_b]        ; ## H28 FMC_HPC1_LA24_P
    set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_b[0]}]     ; ## H25 FMC_HPC1_LA21_P
    set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_b[1]}]     ; ## H26 FMC_HPC1_LA21_N
    set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_b[2]}]     ; ## G24 FMC_HPC1_LA22_P
    set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd_b[3]}]     ; ## G25 FMC_HPC1_LA22_N

    set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS18} [get_ports mii_crs_b]                    ; ## D24 FMC_HPC1_LA23_N

    create_clock -name rx_clk_1   -period  40.0 [get_ports mii_rx_clk_a]
    create_clock -name rx_clk_2   -period  40.0 [get_ports mii_rx_clk_b]
    create_clock -name tx_clk_1   -period  40.0 [get_ports mii_tx_clk_a]
    create_clock -name tx_clk_2   -period  40.0 [get_ports mii_tx_clk_b]

    create_clock -name mdio_clk_a -period 400.0 [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet0_mdio_mdc]
    create_clock -name mdio_clk_b -period 400.0 [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet1_mdio_mdc]

    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports mii_rx_clk_b]
    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports mii_txd_b]

    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports link_st_b]

    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mii_tx_clk_a*]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mii_tx_clk_b*]

  }
  "RGMII" {

    set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVDS} [get_ports ref_clk_125_p]                   ; ## H04  FMC_HPC1_CLK0_M2C_P
    set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVDS} [get_ports ref_clk_125_n]                   ; ## H05  FMC_HPC1_CLK0_M2C_N

    set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCMOS18} [get_ports rgmii_rxc_a]                 ; ## G06 FMC_HPC1_LA00_CC_P
    set_property -dict {PACKAGE_PIN AE4  IOSTANDARD LVCMOS18} [get_ports rgmii_rx_ctl_a]              ; ## H14 FMC_HPC1_LA07_N
    set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_a[0]}]            ; ## H07 FMC_HPC1_LA02_P
    set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_a[1]}]            ; ## H08 FMC_HPC1_LA02_N
    set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_a[2]}]            ; ## G09 FMC_HPC1_LA03_P
    set_property -dict {PACKAGE_PIN AJ1  IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_a[3]}]            ; ## G10 FMC_HPC1_LA03_N
    set_property -dict {PACKAGE_PIN AF1  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_txc_a]       ; ## H11 FMC_HPC1_LA04_N
    set_property -dict {PACKAGE_PIN AD4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_tx_ctl_a]    ; ## H13 FMC_HPC1_LA07_P
    set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_a[0]}]  ; ## D14 FMC_HPC1_LA09_P
    set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_a[1]}]  ; ## D15 FMC_HPC1_LA09_N
    set_property -dict {PACKAGE_PIN AH2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_a[2]}]  ; ## C10 FMC_HPC1_LA06_P
    set_property -dict {PACKAGE_PIN AJ2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_a[3]}]  ; ## C11 FMC_HPC1_LA06_N

    set_property -dict {PACKAGE_PIN AF3  IOSTANDARD LVCMOS18} [get_ports int_n_a]                     ; ## G13 FMC_HPC1_LA08_N

    set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS18} [get_ports rgmii_rxc_b]                 ; ## C22 FMC_HPC1_LA18_CC_P
    set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS18} [get_ports rgmii_rx_ctl_b]              ; ## H29 FMC_HPC1_LA24_N
    set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_b[0]}]            ; ## H22 FMC_HPC1_LA19_P
    set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_b[1]}]            ; ## H23 FMC_HPC1_LA19_N
    set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_b[2]}]            ; ## G21 FMC_HPC1_LA20_P
    set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd_b[3]}]            ; ## G22 FMC_HPC1_LA20_N
    set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_txc_b]       ; ## G28 FMC_HPC1_LA25_N
    set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_tx_ctl_b]    ; ## H28 FMC_HPC1_LA24_P
    set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_b[0]}]  ; ## H25 FMC_HPC1_LA21_P
    set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_b[1]}]  ; ## H26 FMC_HPC1_LA21_N
    set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_b[2]}]  ; ## G24 FMC_HPC1_LA22_P
    set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd_b[3]}]  ; ## G25 FMC_HPC1_LA22_N 

    set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS18} [get_ports int_n_b]                     ; ## D24 FMC_HPC1_LA23_N

    create_clock -name rx_clk_1       -period    8.0 [get_ports rgmii_rxc_a]
    create_clock -name rx_clk_2       -period    8.0 [get_ports rgmii_rxc_b]
    create_clock -name ref_clk_125    -period    8.0 [get_ports ref_clk_125_p]

    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports rgmii_rxc_b]
    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports rgmii_txd_b]

    set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports link_st_b]

    create_clock -period 400.000 -name mdio_clk_a [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet0_mdio_mdc]
    create_clock -period 400.000 -name mdio_clk_b [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet1_mdio_mdc]

    set_false_path -setup -to [get_pins i_system_wrapper/system_i/sys_ps8/inst/PS8_i/EMIOENET0MDIOI]
    set_false_path -setup -to [get_pins i_system_wrapper/system_i/sys_ps8/inst/PS8_i/EMIOENET1MDIOI]

  }
  "RMII" {

    set_property -dict {PACKAGE_PIN AJ6  IOSTANDARD LVCMOS18} [get_ports rmii_rx_ref_clk_a]            ; ## D08 FMC_HPC1_LA01_CC_P
    set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVCMOS18} [get_ports rmii_rx_er_a]                 ; ## D09 FMC_HPC1_LA01_CC_N
    set_property -dict {PACKAGE_PIN AE4  IOSTANDARD LVCMOS18 PULLUP true} [get_ports rmii_rx_dv_a]     ; ## H14 FMC_HPC1_LA07_N
    set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCMOS18 PULLUP true} [get_ports mac_if_sel_0_a]   ; ## G06 FMC_HPC1_LA00_CC_P
    set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVCMOS18} [get_ports {rmii_rxd_a[0]}]              ; ## H07 FMC_HPC1_LA02_P
    set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCMOS18} [get_ports {rmii_rxd_a[1]}]              ; ## H08 FMC_HPC1_LA02_N
    set_property -dict {PACKAGE_PIN AD4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rmii_tx_en_a]       ; ## H13 FMC_HPC1_LA07_P
    set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rmii_txd_a[0]}]    ; ## D14 FMC_HPC1_LA09_P
    set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rmii_txd_a[1]}]    ; ## D15 FMC_HPC1_LA09_N

    set_property -dict {PACKAGE_PIN Y5   IOSTANDARD LVCMOS18} [get_ports rmii_rx_ref_clk_b]            ; ## D20 FMC_HPC1_LA17_CC_P
    set_property -dict {PACKAGE_PIN AA5  IOSTANDARD LVCMOS18} [get_ports rmii_rx_er_b]                 ; ## D21 FMC_HPC1_LA17_CC_N
    set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS18 PULLUP true} [get_ports rmii_rx_dv_b]     ; ## H29 FMC_HPC1_LA24_N
    set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS18 PULLUP true} [get_ports mac_if_sel_0_b]   ; ## C22 FMC_HPC1_LA18_CC_P
    set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports {rmii_rxd_b[0]}]              ; ## H22 FMC_HPC1_LA19_P
    set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports {rmii_rxd_b[1]}]              ; ## H23 FMC_HPC1_LA19_N
    set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rmii_tx_en_b]       ; ## H28 FMC_HPC1_LA24_P
    set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rmii_txd_b[0]}]    ; ## H25 FMC_HPC1_LA21_P
    set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rmii_txd_b[1]}]    ; ## H26 FMC_HPC1_LA21_N

    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rmii_rx_ref_clk_a]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rmii_rx_ref_clk_b]

    create_clock -name rx_clk_a -period 20.0 [get_ports rmii_rx_ref_clk_a]
    create_clock -name rx_clk_b -period 20.0 [get_ports rmii_rx_ref_clk_b]

    create_clock -name mdio_clk_a -period 400.0 [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet0_mdio_mdc]
    create_clock -name mdio_clk_b -period 400.0 [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet1_mdio_mdc]

    create_clock -name mdio_0_rx_clk_a -period 40.0 [get_pins i_system_wrapper/system_i/sys_ps8/emio_enet0_gmii_rx_clk]
    create_clock -name mdio_0_tx_clk_a -period 40.0 [get_pins i_system_wrapper/system_i/sys_ps8/emio_enet0_gmii_tx_clk]
    create_clock -name mdio_0_rx_clk_b -period 40.0 [get_pins i_system_wrapper/system_i/sys_ps8/emio_enet1_gmii_rx_clk]
    create_clock -name mdio_0_tx_clk_b -period 40.0 [get_pins i_system_wrapper/system_i/sys_ps8/emio_enet1_gmii_tx_clk]

  }
}
