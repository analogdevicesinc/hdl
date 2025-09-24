###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#adrv9026

set_property -dict {PACKAGE_PIN AK38} [get_ports ref_clk_p]                                          ; ## D4   FMC_GBT0_0_P    MGTREFCLK0P_121
set_property -dict {PACKAGE_PIN AK39} [get_ports ref_clk_n]                                          ; ## D5   FMC_GBT0_0_N    MGTREFCLK0N_121
set_property -dict {PACKAGE_PIN AL32 IOSTANDARD LVDS} [get_ports core_clk_p]                         ; ## H4   FMC_CLK0_M2C_P  IO_L13P_T2L_N0_GC_QBC_43
set_property -dict {PACKAGE_PIN AM32 IOSTANDARD LVDS} [get_ports core_clk_n]                         ; ## H5   FMC_CLK0_M2C_N  IO_L13N_T2L_N1_GC_QBC_43

set_property -dict {PACKAGE_PIN AN45} [get_ports rx_data_p[0]]                                       ; ## A2   FMC_DP1_M2C_P   MGTYRXP1_121
set_property -dict {PACKAGE_PIN AN46} [get_ports rx_data_n[0]]                                       ; ## A3   FMC_DP1_M2C_N   MGTYRXN1_121
set_property -dict {PACKAGE_PIN AR45} [get_ports rx_data_p[1]]                                       ; ## C6   FMC_DP0_M2C_P   MGTYRXP0_121
set_property -dict {PACKAGE_PIN AR46} [get_ports rx_data_n[1]]                                       ; ## C7   FMC_DP0_M2C_N   MGTYRXN0_121
set_property -dict {PACKAGE_PIN AL45} [get_ports rx_data_p[2]]                                       ; ## A6   FMC_DP2_M2C_P   MGTYRXP2_121
set_property -dict {PACKAGE_PIN AL46} [get_ports rx_data_n[2]]                                       ; ## A7   FMC_DP2_M2C_N   MGTYRXN2_121
set_property -dict {PACKAGE_PIN AJ45} [get_ports rx_data_p[3]]                                       ; ## A10  FMC_DP3_M2C_P   MGTYRXP3_121
set_property -dict {PACKAGE_PIN AJ46} [get_ports rx_data_n[3]]                                       ; ## A11  FMC_DP3_M2C_N   MGTYRXN3_121

set_property -dict {PACKAGE_PIN AP42} [get_ports tx_data_p[0]]                                       ; ## A22  FMC_DP1_C2M_P   MGTYTXP1_121
set_property -dict {PACKAGE_PIN AP43} [get_ports tx_data_n[0]]                                       ; ## A23  FMC_DP1_C2M_N   MGTYTXN1_121
set_property -dict {PACKAGE_PIN AT42} [get_ports tx_data_p[1]]                                       ; ## C2   FMC_DP0_C2M_P   MGTYTXP0_121
set_property -dict {PACKAGE_PIN AT43} [get_ports tx_data_n[1]]                                       ; ## C3   FMC_DP0_C2M_N   MGTYTXN0_121
set_property -dict {PACKAGE_PIN AM42} [get_ports tx_data_p[2]]                                       ; ## A26  FMC_DP2_C2M_P   MGTYTXP2_121
set_property -dict {PACKAGE_PIN AM43} [get_ports tx_data_n[2]]                                       ; ## A27  FMC_DP2_C2M_N   MGTYTXN2_121
set_property -dict {PACKAGE_PIN AL40} [get_ports tx_data_p[3]]                                       ; ## A30  FMC_DP3_C2M_P   MGTYTXP3_121
set_property -dict {PACKAGE_PIN AL41} [get_ports tx_data_n[3]]                                       ; ## A31  FMC_DP3_C2M_N   MGTYTXN3_121

set_property -dict {PACKAGE_PIN AT39 IOSTANDARD LVDS} [get_ports rx_sync_p]                          ; ## G9   FMC_LA03_P      IO_L4P_T0U_N6_DBC_AD7P_43
set_property -dict {PACKAGE_PIN AT40 IOSTANDARD LVDS} [get_ports rx_sync_n]                          ; ## G10  FMC_LA03_N      IO_L4N_T0U_N7_DBC_AD7N_43
set_property -dict {PACKAGE_PIN Y34  IOSTANDARD LVDS} [get_ports rx_os_sync_p]                       ; ## G27  FMC_LA25_P      IO_L3P_T0L_N4_AD15P_45
set_property -dict {PACKAGE_PIN W34  IOSTANDARD LVDS} [get_ports rx_os_sync_n]                       ; ## G28  FMC_LA25_N      IO_L3N_T0L_N5_AD15N_45

set_property -dict {PACKAGE_PIN AL35 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_p]            ; ## G6   FMC_LA00_CC_P   IO_L7P_T1L_N0_QBC_AD13P_43
set_property -dict {PACKAGE_PIN AL36 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_n]            ; ## G7   FMC_LA00_CC_N   IO_L7N_T1L_N1_QBC_AD13N_43

set_property -dict {PACKAGE_PIN AJ32 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]           ; ## H7   FMC_LA02_P      IO_L14P_T2L_N2_GC_43
set_property -dict {PACKAGE_PIN AK32 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]           ; ## H8   FMC_LA02_N      IO_L14N_T2L_N3_GC_43
set_property -dict {PACKAGE_PIN T34  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_p]         ; ## H28  FMC_LA24_P      IO_L6P_T0U_N10_AD6P_45
set_property -dict {PACKAGE_PIN T35  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_n]         ; ## H29  FMC_LA24_N      IO_L6N_T0U_N11_AD6N_45

set_property -dict {PACKAGE_PIN V33  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]                 ; ## C26  FMC_LA27_P      IO_L5P_T0U_N8_AD14P_45
set_property -dict {PACKAGE_PIN V34  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]              ; ## C27  FMC_LA27_N      IO_L5N_T0U_N9_AD14N_45
set_property -dict {PACKAGE_PIN AP38 IOSTANDARD LVCMOS18} [get_ports adrv9026_test]                  ; ## D11  FMC_LA05_P      IO_L1P_T0L_N0_DBC_43

set_property -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_a]            ; ## C10  FMC_LA06_P      IO_L2P_T0L_N2_43
set_property -dict {PACKAGE_PIN AT36 IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_b]            ; ## C11  FMC_LA06_N      IO_L2N_T0L_N3_43
set_property -dict {PACKAGE_PIN V32  IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_c]            ; ## D26  FMC_LA26_P      IO_L2P_T0L_N2_45
set_property -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_d]            ; ## C15  FMC_LA10_N      IO_L3N_T0L_N5_AD15N_43

set_property -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18} [get_ports adrv9026_rx1_enable]            ; ## D18  FMC_LA13_N      IO_L20N_T3L_N3_AD1N_43
set_property -dict {PACKAGE_PIN AH31 IOSTANDARD LVCMOS18} [get_ports adrv9026_rx2_enable]            ; ## C19  FMC_LA14_N      IO_L23N_T3U_N9_43
set_property -dict {PACKAGE_PIN W32  IOSTANDARD LVCMOS18} [get_ports adrv9026_rx3_enable]            ; ## D24  FMC_LA23_N      IO_L1N_T0L_N1_DBC_45
set_property -dict {PACKAGE_PIN Y32  IOSTANDARD LVCMOS18} [get_ports adrv9026_rx4_enable]            ; ## D23  FMC_LA23_P      IO_L1P_T0L_N0_DBC_45

set_property -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18} [get_ports adrv9026_tx1_enable]            ; ## D17  FMC_LA13_P      IO_L20P_T3L_N2_AD1P_43
set_property -dict {PACKAGE_PIN AG31 IOSTANDARD LVCMOS18} [get_ports adrv9026_tx2_enable]            ; ## C18  FMC_LA14_P      IO_L23P_T3U_N8_43
set_property -dict {PACKAGE_PIN U33  IOSTANDARD LVCMOS18} [get_ports adrv9026_tx3_enable]            ; ## D27  FMC_LA26_N      IO_L2N_T0L_N3_45
set_property -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18} [get_ports adrv9026_tx4_enable]            ; ## C14  FMC_LA10_P      IO_L3P_T0L_N4_AD15P_43

set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpint1]                ; ## H11  FMC_LA04_N      IO_L6N_T0U_N11_AD6N_43
set_property -dict {PACKAGE_PIN M36  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpint2]                ; ## H31  FMC_LA28_P      IO_L17P_T2U_N8_AD10P_45
set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS18} [get_ports adrv9026_reset_b]               ; ## H10  FMC_LA04_P      IO_L6P_T0U_N10_AD6P_43

set_property -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_00]               ; ## H19  FMC_LA15_P      IO_L24P_T3U_N10_43
set_property -dict {PACKAGE_PIN AG33 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_01]               ; ## H20  FMC_LA15_N      IO_L24N_T3U_N11_43
set_property -dict {PACKAGE_PIN AG34 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_02]               ; ## G18  FMC_LA16_P      IO_L22P_T3U_N6_DBC_AD0P_43
set_property -dict {PACKAGE_PIN AH35 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_03]               ; ## G19  FMC_LA16_N      IO_L22N_T3U_N7_DBC_AD0N_43
set_property -dict {PACKAGE_PIN M35  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_04]               ; ## H25  FMC_LA21_P      IO_L24P_T3U_N10_45
set_property -dict {PACKAGE_PIN L35  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_05]               ; ## H26  FMC_LA21_N      IO_L24N_T3U_N11_45
set_property -dict {PACKAGE_PIN R31  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_06]               ; ## C22  FMC_LA18_CC_P   IO_L10P_T1U_N6_QBC_AD4P_45
set_property -dict {PACKAGE_PIN P31  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_07]               ; ## C23  FMC_LA18_CC_N   IO_L10N_T1U_N7_QBC_AD4N_45
set_property -dict {PACKAGE_PIN N35  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_08]               ; ## G25  FMC_LA22_N      IO_L20N_T3L_N3_AD1N_45
set_property -dict {PACKAGE_PIN N33  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_09]               ; ## H22  FMC_LA19_P      IO_L22P_T3U_N6_DBC_AD0P_45
set_property -dict {PACKAGE_PIN M33  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_10]               ; ## H23  FMC_LA19_N      IO_L22N_T3U_N7_DBC_AD0N_45
set_property -dict {PACKAGE_PIN N32  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_11]               ; ## G21  FMC_LA20_P      IO_L23P_T3U_N8_45
set_property -dict {PACKAGE_PIN M32  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_12]               ; ## G22  FMC_LA20_N      IO_L23N_T3U_N9_45
set_property -dict {PACKAGE_PIN T36  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_13]               ; ## G31  FMC_LA29_N      IO_L4N_T0U_N7_DBC_AD7N_45
set_property -dict {PACKAGE_PIN U35  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_14]               ; ## G30  FMC_LA29_P      IO_L4P_T0U_N6_DBC_AD7P_45
set_property -dict {PACKAGE_PIN N34  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_15]               ; ## G24  FMC_LA22_P      IO_L20P_T3L_N2_AD1P_45
set_property -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_16]               ; ## G16  FMC_LA12_N      IO_L21N_T3L_N5_AD8N_43
set_property -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_17]               ; ## G15  FMC_LA12_P      IO_L21P_T3L_N4_AD8P_43
set_property -dict {PACKAGE_PIN AR38 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_18]               ; ## D12  FMC_LA05_N      IO_L1N_T0L_N1_DBC_43

set_property -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9026]               ; ## D14  FMC_LA09_P      IO_L19P_T3L_N0_DBC_AD9P_43
set_property -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]                 ; ## D15  FMC_LA09_N      IO_L19N_T3L_N1_DBC_AD9N_43
set_property -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18} [get_ports spi_clk]                        ; ## H13  FMC_LA07_P      IO_L5P_T0U_N8_AD14P_43
set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18} [get_ports spi_miso]                       ; ## G12  FMC_LA08_P      IO_L18P_T2U_N10_AD2P_43
set_property -dict {PACKAGE_PIN AP37 IOSTANDARD LVCMOS18} [get_ports spi_mosi]                       ; ## H14  FMC_LA07_N      IO_L5N_T0U_N9_AD14N_43

# clocks

create_clock -name ref_clk   -period  4.00 [get_ports ref_clk_p]
create_clock -name core_clk  -period  4.00 [get_ports core_clk_p]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_core_clk_ibufds_1/O]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets core_clk]
