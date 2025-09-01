###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#adrv904x

set_property -dict {PACKAGE_PIN G8} [get_ports ref_clk0_p]                                             ; ## D4   FMC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7} [get_ports ref_clk0_n]                                             ; ## D5   FMC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229
set_property -dict {PACKAGE_PIN L8} [get_ports ref_clk1_p]                                             ; ## B20  FMC0_GBTCLK1_M2C_C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN L7} [get_ports ref_clk1_n]                                             ; ## B21  FMC0_GBTCLK1_M2C_C_N  MGTREFCLK0N_228

set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_p]     ; ## H4   FMC0_CLK0_M2C_P       IO_L12P_T1U_N10_GC_66
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_n]     ; ## H5   FMC0_CLK0_M2C_N       IO_L12N_T1U_N11_GC_66

set_property -dict {PACKAGE_PIN P2}   [get_ports rx_data_p[0]]                                         ; ## A18  FMC0_DP5_M2C_P        MGTHRXP1_228  (rx_data_n[0])
set_property -dict {PACKAGE_PIN P1}   [get_ports rx_data_n[0]]                                         ; ## A19  FMC0_DP5_M2C_N        MGTHRXN1_228  (rx_data_p[0])
set_property -dict {PACKAGE_PIN T2}   [get_ports rx_data_p[1]]                                         ; ## B16  FMC0_DP6_M2C_P        MGTHRXP0_228  (rx_data_n[1])
set_property -dict {PACKAGE_PIN T1}   [get_ports rx_data_n[1]]                                         ; ## B17  FMC0_DP6_M2C_N        MGTHRXN0_228  (rx_data_p[1])
set_property -dict {PACKAGE_PIN L4}   [get_ports rx_data_p[2]]                                         ; ## A14  FMC0_DP4_M2C_P        MGTHRXP3_228  (rx_data_n[2])
set_property -dict {PACKAGE_PIN L3}   [get_ports rx_data_n[2]]                                         ; ## A15  FMC0_DP4_M2C_N        MGTHRXN3_228  (rx_data_p[2])
set_property -dict {PACKAGE_PIN M2}   [get_ports rx_data_p[3]]                                         ; ## B12  FMC0_DP7_M2C_P        MGTHRXP2_228  (rx_data_n[3])
set_property -dict {PACKAGE_PIN M1}   [get_ports rx_data_n[3]]                                         ; ## B13  FMC0_DP7_M2C_N        MGTHRXN2_228  (rx_data_p[3])
set_property -dict {PACKAGE_PIN F2}   [get_ports rx_data_p[4]]                                         ; ## A6   FMC0_DP2_M2C_P        MGTHRXP3_229  (rx_data_n[4])
set_property -dict {PACKAGE_PIN F1}   [get_ports rx_data_n[4]]                                         ; ## A7   FMC0_DP2_M2C_N        MGTHRXN3_229  (rx_data_p[4])
set_property -dict {PACKAGE_PIN K2}   [get_ports rx_data_p[5]]                                         ; ## A10  FMC0_DP3_M2C_P        MGTHRXP0_229  (rx_data_n[5])
set_property -dict {PACKAGE_PIN K1}   [get_ports rx_data_n[5]]                                         ; ## A11  FMC0_DP3_M2C_N        MGTHRXN0_229  (rx_data_p[5])
set_property -dict {PACKAGE_PIN J4}   [get_ports rx_data_p[6]]                                         ; ## A2   FMC0_DP1_M2C_P        MGTHRXP1_229  (rx_data_n[6])
set_property -dict {PACKAGE_PIN J3}   [get_ports rx_data_n[6]]                                         ; ## A3   FMC0_DP1_M2C_N        MGTHRXN1_229  (rx_data_p[6])
set_property -dict {PACKAGE_PIN H2}   [get_ports rx_data_p[7]]                                         ; ## C6   FMC0_DP0_M2C_P        MGTHRXP2_229  (rx_data_n[7])
set_property -dict {PACKAGE_PIN H1}   [get_ports rx_data_n[7]]                                         ; ## C7   FMC0_DP0_M2C_N        MGTHRXN2_229  (rx_data_p[7])

set_property -dict {PACKAGE_PIN P6}   [get_ports tx_data_p[0]]                                         ; ## A38  FMC0_DP5_C2M_P        MGTHTXP1_228  (tx_data_n[6])
set_property -dict {PACKAGE_PIN P5}   [get_ports tx_data_n[0]]                                         ; ## A39  FMC0_DP5_C2M_N        MGTHTXN1_228  (tx_data_p[6])
set_property -dict {PACKAGE_PIN R4}   [get_ports tx_data_p[1]]                                         ; ## B36  FMC0_DP6_C2M_P        MGTHTXP0_228  (tx_data_n[5])
set_property -dict {PACKAGE_PIN R3}   [get_ports tx_data_n[1]]                                         ; ## B37  FMC0_DP6_C2M_N        MGTHTXN0_228  (tx_data_p[5])
set_property -dict {PACKAGE_PIN M6}   [get_ports tx_data_p[2]]                                         ; ## A34  FMC0_DP4_C2M_P        MGTHTXP3_228  (tx_data_n[7])
set_property -dict {PACKAGE_PIN M5}   [get_ports tx_data_n[2]]                                         ; ## A35  FMC0_DP4_C2M_N        MGTHTXN3_228  (tx_data_p[7])
set_property -dict {PACKAGE_PIN N4}   [get_ports tx_data_p[3]]                                         ; ## B32  FMC0_DP7_C2M_P        MGTHTXP2_228  (tx_data_n[4])
set_property -dict {PACKAGE_PIN N3}   [get_ports tx_data_n[3]]                                         ; ## B33  FMC0_DP7_C2M_N        MGTHTXN2_228  (tx_data_p[4])
set_property -dict {PACKAGE_PIN F6}   [get_ports tx_data_p[4]]                                         ; ## A26  FMC0_DP2_C2M_P        MGTHTXP3_229  (tx_data_n[2])
set_property -dict {PACKAGE_PIN F5}   [get_ports tx_data_n[4]]                                         ; ## A27  FMC0_DP2_C2M_N        MGTHTXN3_229  (tx_data_p[2])
set_property -dict {PACKAGE_PIN K6}   [get_ports tx_data_p[5]]                                         ; ## A30  FMC0_DP3_C2M_P        MGTHTXP0_229  (tx_data_n[3])
set_property -dict {PACKAGE_PIN K5}   [get_ports tx_data_n[5]]                                         ; ## A31  FMC0_DP3_C2M_N        MGTHTXN0_229  (tx_data_p[3])
set_property -dict {PACKAGE_PIN H6}   [get_ports tx_data_p[6]]                                         ; ## A22  FMC0_DP1_C2M_P        MGTHTXP1_229  (tx_data_n[1])
set_property -dict {PACKAGE_PIN H5}   [get_ports tx_data_n[6]]                                         ; ## A23  FMC0_DP1_C2M_N        MGTHTXN1_229  (tx_data_p[1])
set_property -dict {PACKAGE_PIN G4}   [get_ports tx_data_p[7]]                                         ; ## C2   FMC0_DP0_C2M_P        MGTHTXP2_229  (tx_data_n[0])
set_property -dict {PACKAGE_PIN G3}   [get_ports tx_data_n[7]]                                         ; ## C3   FMC0_DP0_C2M_N        MGTHTXN2_229  (tx_data_p[0])

set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVDS} [get_ports rx_sync_p]                            ; ## H7   FMC0_LA02_P           IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVDS} [get_ports rx_sync_n]                            ; ## H8   FMC0_LA02_N           IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVDS} [get_ports rx_os_sync_p]                         ; ## H37  FMC0_LA32_P           IO_L6P_T0U_N11_AD6N_67
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVDS} [get_ports rx_os_sync_n]                         ; ## H38  FMC0_LA32_N           IO_L6N_T0U_N10_AD6P_67
set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]     ; ## G33  FMC0_LA31_P           IO_L7P_T1L_N0_QBC_AD13P_67
set_property -dict {PACKAGE_PIN V7   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]     ; ## G34  FMC0_LA31_N           IO_L7N_T1L_N1_QBC_AD13N_67
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_p]   ; ## G27  FMC0_LA25_P           IO_L17P_T2U_N8_AD10P_67
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_n]   ; ## G28  FMC0_LA25_N           IO_L17N_T2U_N9_AD10N_67
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_2_p]   ; ## G36  FMC0_LA33_P           IO_L5P_T0U_N8_AD14P_67
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_2_n]   ; ## G37  FMC0_LA33_N           IO_L5N_T0U_N9_AD14N_67

set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_in_p]   ; ## D8   FMC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_in_n]   ; ## D9   FMC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVDS} [get_ports sysref_out_p]                         ; ## G9   FMC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVDS} [get_ports sysref_out_n]                         ; ## G10  FMC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66

set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]                ; ## C27  FMC0_LA27_N           IO_L15N_T2L_N5_AD11N_67
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18} [get_ports adrv904x_test]                    ; ## D11  FMC0_LA05_P           IO_L20P_T3L_N2_AD1P_66

set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports adrv904x_orx0_enable]             ; ## C10  FMC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports adrv904x_orx1_enable]             ; ## C11  FMC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx0_enable]             ; ## D17  FMC0_LA13_P           IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx1_enable]             ; ## D18  FMC0_LA13_N           IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN W5   IOSTANDARD LVCMOS18} [get_ports adrv904x_trx2_enable]             ; ## C14  FMC0_LA10_P           IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVCMOS18} [get_ports adrv904x_trx3_enable]             ; ## C15  FMC0_LA10_N           IO_L15N_T2L_N5_AD11N_66
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx4_enable]             ; ## D23  FMC0_LA23_P           IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx5_enable]             ; ## D24  FMC0_LA23_N           IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx6_enable]             ; ## C18  FMC0_LA14_P           IO_L7P_T1L_N0_QBC_AD13P_66
set_property -dict {PACKAGE_PIN AC6  IOSTANDARD LVCMOS18} [get_ports adrv904x_trx7_enable]             ; ## C19  FMC0_LA14_N           IO_L7N_T1L_N1_QBC_AD13N_66

set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[0]]                 ; ## H19  FMC0_LA15_P           IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[1]]                 ; ## H20  FMC0_LA15_N           IO_L6N_T0U_N11_AD6N_66
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[2]]                 ; ## G18  FMC0_LA16_P           IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[3]]                 ; ## G19  FMC0_LA16_N           IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[4]]                 ; ## H25  FMC0_LA21_P           IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[5]]                 ; ## H26  FMC0_LA21_N           IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[6]]                 ; ## C22  FMC0_LA18_CC_P        IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[7]]                 ; ## C23  FMC0_LA18_CC_N        IO_L16N_T2U_N7_QBC_AD3N_67
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[8]]                 ; ## H22  FMC0_LA19_P           IO_L23P_T3U_N8_67
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[9]]                 ; ## H23  FMC0_LA19_N           IO_L23N_T3U_N9_67
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[10]]                ; ## G24  FMC0_LA22_P           IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[11]]                ; ## G25  FMC0_LA22_N           IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[12]]                ; ## H10  FMC0_LA04_P           IO_L21P_T3L_N4_AD8P_66
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[13]]                ; ## H11  FMC0_LA04_N           IO_L21N_T3L_N5_AD8N_66
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[14]]                ; ## G30  FMC0_LA29_P           IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN U8   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[15]]                ; ## G31  FMC0_LA29_N           IO_L9N_T1L_N5_AD12N_67
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[16]]                ; ## G15  FMC0_LA12_P           IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[17]]                ; ## G16  FMC0_LA12_N           IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[18]]                ; ## D12  FMC0_LA05_N           IO_L20N_T3L_N3_AD1N_66
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[19]]                ; ## G21  FMC0_LA20_P           IO_L22P_T3U_N6_DBC_AD0P_67
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[20]]                ; ## H34  FMC0_LA30_P           IO_L8P_T1L_N2_AD5P_67
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[21]]                ; ## H35  FMC0_LA30_N           IO_L8N_T1L_N3_AD5N_67
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[22]]                ; ## H28  FMC0_LA24_P           IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18} [get_ports adrv904x_gpio[23]]                ; ## H29  FMC0_LA24_N           IO_L18N_T2U_N11_AD2N_67

set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]                   ; ## C26  FMC0_LA27_P           IO_L15P_T2L_N4_AD11P_67
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18} [get_ports adrv904x_reset_b]                 ; ## G22  FMC0_LA20_N           IO_L22N_T3U_N7_DBC_AD0N_67

set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv904x]                 ; ## D14  FMC0_LA09_P           IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]                   ; ## D15  FMC0_LA09_N           IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## H13  FMC0_LA07_P           IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN V4   IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## G12  FMC0_LA08_P           IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## H14  FMC0_LA07_N           IO_L18N_T2U_N11_AD2N_66

# clocks

create_clock -period 4.069 -name device_clk [get_ports core_clk_p]
create_clock -period 2.035 -name tx_ref_clk [get_ports ref_clk0_p]
create_clock -period 2.035 -name rx_ref_clk [get_ports ref_clk1_p]
