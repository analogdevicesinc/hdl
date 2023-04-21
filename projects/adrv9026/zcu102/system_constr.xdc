###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#adrv9026

set_property -dict {PACKAGE_PIN G27}  [get_ports ref_clk_p]                                  ; ## D4   FMC1_GBTCLK0_M2C_C_P  MGTREFCLK0P_130
set_property -dict {PACKAGE_PIN G28}  [get_ports ref_clk_n]                                  ; ## D5   FMC1_GBTCLK0_M2C_C_N  MGTREFCLK0N_130
set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVDS} [get_ports core_clk_p]                 ; ## H4   FMC1_CLK0_M2C_P       IO_L12P_T1U_N10_GC_65
set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVDS} [get_ports core_clk_n]                 ; ## H5   FMC1_CLK0_M2C_N       IO_L12N_T1U_N11_GC_65

set_property -dict {PACKAGE_PIN D33}  [get_ports rx_data_p[0]]                               ; ## A2   FMC1_DP1_M2C_P        MGTHRXP1_130
set_property -dict {PACKAGE_PIN D34}  [get_ports rx_data_n[0]]                               ; ## A3   FMC1_DP1_M2C_N        MGTHRXN1_130
set_property -dict {PACKAGE_PIN E31}  [get_ports rx_data_p[1]]                               ; ## C6   FMC1_DP0_M2C_P        MGTHRXP0_130
set_property -dict {PACKAGE_PIN E32}  [get_ports rx_data_n[1]]                               ; ## C7   FMC1_DP0_M2C_N        MGTHRXN0_130
set_property -dict {PACKAGE_PIN C31}  [get_ports rx_data_p[2]]                               ; ## A6   FMC1_DP2_M2C_P        MGTHRXP2_130
set_property -dict {PACKAGE_PIN C32}  [get_ports rx_data_n[2]]                               ; ## A7   FMC1_DP2_M2C_N        MGTHRXN2_130
set_property -dict {PACKAGE_PIN B33}  [get_ports rx_data_p[3]]                               ; ## A10  FMC1_DP3_M2C_P        MGTHRXP3_130
set_property -dict {PACKAGE_PIN B34}  [get_ports rx_data_n[3]]                               ; ## A11  FMC1_DP3_M2C_N        MGTHRXN3_130

set_property -dict {PACKAGE_PIN D29}  [get_ports tx_data_p[0]]                               ; ## A22  FMC1_DP1_C2M_P        MGTHTXP1_130  (tx_data_p[2])
set_property -dict {PACKAGE_PIN D30}  [get_ports tx_data_n[0]]                               ; ## A23  FMC1_DP1_C2M_N        MGTHTXN1_130  (tx_data_n[2])
set_property -dict {PACKAGE_PIN F29}  [get_ports tx_data_p[1]]                               ; ## C2   FMC1_DP0_C2M_P        MGTHTXP0_130  (tx_data_p[3])
set_property -dict {PACKAGE_PIN F30}  [get_ports tx_data_n[1]]                               ; ## C3   FMC1_DP0_C2M_N        MGTHTXN0_130  (tx_data_n[3])
set_property -dict {PACKAGE_PIN B29}  [get_ports tx_data_p[2]]                               ; ## A26  FMC1_DP2_C2M_P        MGTHTXP2_130  (tx_data_p[1])
set_property -dict {PACKAGE_PIN B30}  [get_ports tx_data_n[2]]                               ; ## A27  FMC1_DP2_C2M_N        MGTHTXN2_130  (tx_data_n[1])
set_property -dict {PACKAGE_PIN A31}  [get_ports tx_data_p[3]]                               ; ## A30  FMC1_DP3_C2M_P        MGTHTXP3_130  (tx_data_p[0])
set_property -dict {PACKAGE_PIN A32}  [get_ports tx_data_n[3]]                               ; ## A31  FMC1_DP3_C2M_N        MGTHTXN3_130  (tx_data_n[0])

set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVDS} [get_ports rx_sync_p]                  ; ## G9   FMC1_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_65
set_property -dict {PACKAGE_PIN AJ1  IOSTANDARD LVDS} [get_ports rx_sync_n]                  ; ## G10  FMC1_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_65
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVDS} [get_ports rx_os_sync_p]               ; ## G27  FMC1_LA25_P           IO_L1P_T0L_N0_DBC_65
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVDS} [get_ports rx_os_sync_n]               ; ## G28  FMC1_LA25_N           IO_L1N_T0L_N1_DBC_65

set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_p]    ; ## G6   FMC1_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_65
set_property -dict {PACKAGE_PIN AF5  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_n]    ; ## G7   FMC1_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_65

set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]   ; ## H7   FMC1_LA02_P           IO_L23P_T3U_N8_I2C_SCLK_65
set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]   ; ## H8   FMC1_LA02_N           IO_L23N_T3U_N9_65
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_p] ; ## H28  FMC1_LA24_P           IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_n] ; ## H29  FMC1_LA24_N           IO_L2N_T0L_N3_65

set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]         ; ## C26  FMC1_LA27_P           IO_L3P_T0L_N4_AD15P_67
set_property -dict {PACKAGE_PIN T10  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]      ; ## C27  FMC1_LA27_N           IO_L3N_T0L_N5_AD15N_67
set_property -dict {PACKAGE_PIN AG3  IOSTANDARD LVCMOS18} [get_ports adrv9026_test]          ; ## D11  FMC1_LA05_P           IO_L20P_T3L_N2_AD1P_65

set_property -dict {PACKAGE_PIN AH2  IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_a]    ; ## C10  FMC1_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_65
set_property -dict {PACKAGE_PIN AJ2  IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_b]    ; ## C11  FMC1_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_65
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_c]    ; ## D26  FMC1_LA26_P           IO_L4P_T0U_N6_DBC_AD7P_67
set_property -dict {PACKAGE_PIN AJ4  IOSTANDARD LVCMOS18} [get_ports adrv9026_orx_ctrl_d]    ; ## C15  FMC1_LA10_N           IO_L15N_T2L_N5_AD11N_65

set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVCMOS18} [get_ports adrv9026_rx1_enable]    ; ## D18  FMC1_LA13_N           IO_L8N_T1L_N3_AD5N_65
set_property -dict {PACKAGE_PIN AH6  IOSTANDARD LVCMOS18} [get_ports adrv9026_rx2_enable]    ; ## C19  FMC1_LA14_N           IO_L7N_T1L_N1_QBC_AD13N_65
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS18} [get_ports adrv9026_rx3_enable]    ; ## D24  FMC1_LA23_N           IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS18} [get_ports adrv9026_rx4_enable]    ; ## D23  FMC1_LA23_P           IO_L3P_T0L_N4_AD15P_65

set_property -dict {PACKAGE_PIN AG8  IOSTANDARD LVCMOS18} [get_ports adrv9026_tx1_enable]    ; ## D17  FMC1_LA13_P           IO_L8P_T1L_N2_AD5P_65
set_property -dict {PACKAGE_PIN AH7  IOSTANDARD LVCMOS18} [get_ports adrv9026_tx2_enable]    ; ## C18  FMC1_LA14_P           IO_L7P_T1L_N0_QBC_AD13P_65
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18} [get_ports adrv9026_tx3_enable]    ; ## D27  FMC1_LA26_N           IO_L4N_T0U_N7_DBC_AD7N_67
set_property -dict {PACKAGE_PIN AH4  IOSTANDARD LVCMOS18} [get_ports adrv9026_tx4_enable]    ; ## C14  FMC1_LA10_P           IO_L15P_T2L_N4_AD11P_65

set_property -dict {PACKAGE_PIN AF1  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpint1]        ; ## H11  FMC1_LA04_N           IO_L21N_T3L_N5_AD8N_65
set_property -dict {PACKAGE_PIN T13  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpint2]        ; ## H31  FMC1_LA28_P           IO_L2P_T0L_N2_67
set_property -dict {PACKAGE_PIN AF2  IOSTANDARD LVCMOS18} [get_ports adrv9026_reset_b]       ; ## H10  FMC1_LA04_P           IO_L21P_T3L_N4_AD8P_65

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_00]       ; ## H19  FMC1_LA15_P           IO_L6P_T0U_N10_AD6P_65
set_property -dict {PACKAGE_PIN AE9  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_01]       ; ## H20  FMC1_LA15_N           IO_L6N_T0U_N11_AD6N_65
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_02]       ; ## G18  FMC1_LA16_P           IO_L5P_T0U_N8_AD14P_65
set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_03]       ; ## G19  FMC1_LA16_N           IO_L5N_T0U_N9_AD14N_65
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_04]       ; ## H25  FMC1_LA21_P           IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_05]       ; ## H26  FMC1_LA21_N           IO_L1N_T0L_N1_DBC_66
set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_06]       ; ## C22  FMC1_LA18_CC_P        IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN Y7   IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_07]       ; ## C23  FMC1_LA18_CC_N        IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_08]       ; ## G25  FMC1_LA22_N           IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_09]       ; ## H22  FMC1_LA19_P           IO_L3P_T0L_N4_AD15P_66
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_10]       ; ## H23  FMC1_LA19_N           IO_L3N_T0L_N5_AD15N_66
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_11]       ; ## G21  FMC1_LA20_P           IO_L2P_T0L_N2_66
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_12]       ; ## G22  FMC1_LA20_N           IO_L2N_T0L_N3_66
set_property -dict {PACKAGE_PIN W11  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_13]       ; ## G31  FMC1_LA29_N           IO_L1N_T0L_N1_DBC_67
set_property -dict {PACKAGE_PIN W12  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_14]       ; ## G30  FMC1_LA29_P           IO_L1P_T0L_N0_DBC_67
set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_15]       ; ## G24  FMC1_LA22_P           IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
set_property -dict {PACKAGE_PIN AD6  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_16]       ; ## G16  FMC1_LA12_N           IO_L9N_T1L_N5_AD12N_65
set_property -dict {PACKAGE_PIN AD7  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_17]       ; ## G15  FMC1_LA12_P           IO_L9P_T1L_N4_AD12P_65
set_property -dict {PACKAGE_PIN AH3  IOSTANDARD LVCMOS18} [get_ports adrv9026_gpio_18]       ; ## D12  FMC1_LA05_N           IO_L20N_T3L_N3_AD1N_65

set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9026]       ; ## D14  FMC1_LA09_P           IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]         ; ## D15  FMC1_LA09_N           IO_L24N_T3U_N11_PERSTN0_65
set_property -dict {PACKAGE_PIN AD4  IOSTANDARD LVCMOS18} [get_ports spi_clk]                ; ## H13  FMC1_LA07_P           IO_L18P_T2U_N10_AD2P_65
set_property -dict {PACKAGE_PIN AE3  IOSTANDARD LVCMOS18} [get_ports spi_miso]               ; ## G12  FMC1_LA08_P           IO_L17P_T2U_N8_AD10P_65
set_property -dict {PACKAGE_PIN AE4  IOSTANDARD LVCMOS18} [get_ports spi_mosi]               ; ## H14  FMC1_LA07_N           IO_L18N_T2U_N11_AD2N_65

# clocks

create_clock -name ref_clk   -period  4.00 [get_ports ref_clk_p]
create_clock -name core_clk  -period  4.00 [get_ports core_clk_p]
