###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## mxfe
#

set_property -dict {PACKAGE_PIN B2}  [get_ports rx_data_p[2]]                                            ; ## A6   FMC_DP2_M2C_P      MGTHRXP2_228
set_property -dict {PACKAGE_PIN B1}  [get_ports rx_data_n[2]]                                            ; ## A7   FMC_DP2_M2C_N      MGTHRXN2_228
set_property -dict {PACKAGE_PIN E4}  [get_ports rx_data_p[0]]                                            ; ## C6   FMC_DP0_M2C_P      MGTHRXP0_228
set_property -dict {PACKAGE_PIN E3}  [get_ports rx_data_n[0]]                                            ; ## C7   FMC_DP0_M2C_N      MGTHRXN0_228
set_property -dict {PACKAGE_PIN F2}  [get_ports rx_data_p[7]]                                            ; ## B12  FMC_DP7_M2C_P      MGTHRXP3_227
set_property -dict {PACKAGE_PIN F1}  [get_ports rx_data_n[7]]                                            ; ## B13  FMC_DP7_M2C_N      MGTHRXN3_227
set_property -dict {PACKAGE_PIN K2}  [get_ports rx_data_p[6]]                                            ; ## B16  FMC_DP6_M2C_P      MGTHRXP1_227
set_property -dict {PACKAGE_PIN K1}  [get_ports rx_data_n[6]]                                            ; ## B17  FMC_DP6_M2C_N      MGTHRXN1_227
set_property -dict {PACKAGE_PIN H2}  [get_ports rx_data_p[5]]                                            ; ## A18  FMC_DP5_M2C_P      MGTHRXP2_227
set_property -dict {PACKAGE_PIN H1}  [get_ports rx_data_n[5]]                                            ; ## A19  FMC_DP5_M2C_N      MGTHRXN2_227
set_property -dict {PACKAGE_PIN M2}  [get_ports rx_data_p[4]]                                            ; ## A14  FMC_DP4_M2C_P      MGTHRXP0_227
set_property -dict {PACKAGE_PIN M1}  [get_ports rx_data_n[4]]                                            ; ## A15  FMC_DP4_M2C_N      MGTHRXN0_227
set_property -dict {PACKAGE_PIN A4}  [get_ports rx_data_p[3]]                                            ; ## A10  FMC_DP3_M2C_P      MGTHRXP3_228
set_property -dict {PACKAGE_PIN A3}  [get_ports rx_data_n[3]]                                            ; ## A11  FMC_DP3_M2C_N      MGTHRXN3_228
set_property -dict {PACKAGE_PIN D2}  [get_ports rx_data_p[1]]                                            ; ## A2   FMC_DP1_M2C_P      MGTHRXP1_228
set_property -dict {PACKAGE_PIN D1}  [get_ports rx_data_n[1]]                                            ; ## A3   FMC_DP1_M2C_N      MGTHRXN1_228

set_property -dict {PACKAGE_PIN F6}  [get_ports tx_data_p[0]]                                            ; ## C2   FMC_DP0_C2M_P      MGTHTXP0_228
set_property -dict {PACKAGE_PIN F5}  [get_ports tx_data_n[0]]                                            ; ## C3   FMC_DP0_C2M_N      MGTHTXN0_228
set_property -dict {PACKAGE_PIN C4}  [get_ports tx_data_p[2]]                                            ; ## A26  FMC_DP2_C2M_P      MGTHTXP2_228
set_property -dict {PACKAGE_PIN C3}  [get_ports tx_data_n[2]]                                            ; ## A27  FMC_DP2_C2M_N      MGTHTXN2_228
set_property -dict {PACKAGE_PIN G4}  [get_ports tx_data_p[7]]                                            ; ## B32  FMC_DP7_C2M_P      MGTHTXP3_227
set_property -dict {PACKAGE_PIN G3}  [get_ports tx_data_n[7]]                                            ; ## B33  FMC_DP7_C2M_N      MGTHTXN3_227
set_property -dict {PACKAGE_PIN L4}  [get_ports tx_data_p[6]]                                            ; ## B36  FMC_DP6_C2M_P      MGTHTXP1_227
set_property -dict {PACKAGE_PIN L3}  [get_ports tx_data_n[6]]                                            ; ## B37  FMC_DP6_C2M_N      MGTHTXN1_227
set_property -dict {PACKAGE_PIN D6}  [get_ports tx_data_p[1]]                                            ; ## A22  FMC_DP1_C2M_P      MGTHTXP1_228
set_property -dict {PACKAGE_PIN D5}  [get_ports tx_data_n[1]]                                            ; ## A23  FMC_DP1_C2M_N      MGTHTXN1_228
set_property -dict {PACKAGE_PIN J4}  [get_ports tx_data_p[5]]                                            ; ## A38  FMC_DP5_C2M_P      MGTHTXP2_227
set_property -dict {PACKAGE_PIN J3}  [get_ports tx_data_n[5]]                                            ; ## A39  FMC_DP5_C2M_N      MGTHTXN2_227
set_property -dict {PACKAGE_PIN N4}  [get_ports tx_data_p[4]]                                            ; ## A34  FMC_DP4_C2M_P      MGTHTXP0_227
set_property -dict {PACKAGE_PIN N3}  [get_ports tx_data_n[4]]                                            ; ## A35  FMC_DP4_C2M_N      MGTHTXN0_227
set_property -dict {PACKAGE_PIN B6}  [get_ports tx_data_p[3]]                                            ; ## A30  FMC_DP3_C2M_P      MGTHTXP3_228
set_property -dict {PACKAGE_PIN B5}  [get_ports tx_data_n[3]]                                            ; ## A31  FMC_DP3_C2M_N      MGTHTXN3_228

set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_syncin_p[0]] ; ## H7   FMC_LA02_P         IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports fpga_syncin_n[0]] ; ## H8   FMC_LA02_N         IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS18} [get_ports fpga_syncin_p[1]]                    ; ## G9   FPC_LA03_P         IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS18} [get_ports fpga_syncin_n[1]]                    ; ## G10  FPC_LA03_N         IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN G9  IOSTANDARD LVDS} [get_ports fpga_syncout_p[0]]                       ; ## D8   FMC_LA01_CC_P      IO_L11P_T1U_N8_GC_66
set_property -dict {PACKAGE_PIN F9  IOSTANDARD LVDS} [get_ports fpga_syncout_n[0]]                       ; ## D9   FMC_LA01_CC_N      IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS18} [get_ports fpga_syncout_p[1]]                   ; ## C10  FMC_LA06_P         IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS18} [get_ports fpga_syncout_n[1]]                   ; ## C11  FMC_LA06_N         IO_L24N_T3U_N11_66

set_property -dict {PACKAGE_PIN K6}  [get_ports fpga_refclk_in_p]                                        ; ## D4   FMC_GBTCLK0_M2C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN K5}  [get_ports fpga_refclk_in_n]                                        ; ## D5   FMC_GBTCLK0_M2C_N  MGTREFCLK0N_228
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref2_p]        ; ## H4   FMC_CLK0_M2C_P     IO_L14P_T2L_N2_GC_66
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref2_n]        ; ## H5   FMC_CLK0_M2C_N     IO_L14N_T2L_N3_GC_66
set_property -dict {PACKAGE_PIN E25 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports clkin6_p]         ; ## G2   FMC_CLK1_M2C_P     IO_L11P_T1U_N8_GC_67
set_property -dict {PACKAGE_PIN D25 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports clkin6_n]         ; ## G3   FMC_CLK1_M2C_N     IO_L11N_T1U_N9_GC_67
set_property -dict {PACKAGE_PIN H6} [get_ports clkin8_p]                                                 ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property -dict {PACKAGE_PIN H5} [get_ports clkin8_n]                                                 ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports clkin10_p]        ; ## G6   FMC_LA00_CC_P      IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports clkin10_n]        ; ## G7   FMC_LA00_CC_N      IO_L13N_T2L_N1_GC_QBC_66
set_property -dict {PACKAGE_PIN E8  IOSTANDARD LVCMOS18} [get_ports hmc_sync]                            ; ## H14  FMC_LA07_N         IO_L1N_T0L_N1_DBC_66

set_property -dict {PACKAGE_PIN F8  IOSTANDARD LVCMOS18} [get_ports rstb]                                ; ## H13  FMC_LA07_P         IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN J9  IOSTANDARD LVCMOS18} [get_ports txen[0]]                             ; ## D14  FMC_LA09_P         IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN H9  IOSTANDARD LVCMOS18} [get_ports txen[1]]                             ; ## D15  FMC_LA09_N         IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN L8  IOSTANDARD LVCMOS18} [get_ports rxen[0]]                             ; ## C14  FMC_LA10_P         IO_L7P_T1L_N0_QBC_AD13P_66
set_property -dict {PACKAGE_PIN K8  IOSTANDARD LVCMOS18} [get_ports rxen[1]]                             ; ## C15  FMC_LA10_N         IO_L7N_T1L_N1_QBC_AD13N_66
set_property -dict {PACKAGE_PIN D8  IOSTANDARD LVCMOS18} [get_ports gpio[0]]                             ; ## H19  FMC_LA15_P         IO_L3P_T0L_N4_AD15P_66
set_property -dict {PACKAGE_PIN C8  IOSTANDARD LVCMOS18} [get_ports gpio[1]]                             ; ## H20  FMC_LA15_N         IO_L3N_T0L_N5_AD15N_66
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS18} [get_ports gpio[2]]                             ; ## H22  FMC_LA19_P         IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS18} [get_ports gpio[3]]                             ; ## H23  FMC_LA19_N         IO_L16N_T2U_N7_QBC_AD3N_67
set_property -dict {PACKAGE_PIN D9  IOSTANDARD LVCMOS18} [get_ports gpio[4]]                             ; ## D17  FMC_LA13_P         IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN C9  IOSTANDARD LVCMOS18} [get_ports gpio[5]]                             ; ## D18  FMC_LA13_N         IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS18} [get_ports gpio[6]]                             ; ## C18  FMC_LA14_P         IO_L4P_T0U_N6_DBC_AD7P_66
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS18} [get_ports gpio[7]]                             ; ## C19  FMC_LA14_N         IO_L4N_T0U_N7_DBC_AD7N_66
set_property -dict {PACKAGE_PIN B9  IOSTANDARD LVCMOS18} [get_ports gpio[8]]                             ; ## G18  FMC_LA16_P         IO_L2P_T0L_N2_66
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS18} [get_ports gpio[9]]                             ; ## G19  FMC_LA16_N         IO_L2N_T0L_N3_66
set_property -dict {PACKAGE_PIN F25 IOSTANDARD LVCMOS18} [get_ports gpio[10]]                            ; ## G25  FMC_LA22_N         IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN J8  IOSTANDARD LVCMOS18} [get_ports irqb[0]]                             ; ## G12  FMC_LA08_P         IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN H8  IOSTANDARD LVCMOS18} [get_ports irqb[1]]                             ; ## G13  FMC_LA08_N         IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS18} [get_ports hmc_gpio1]                           ; ## H17  FMC_LA11_N         IO_L15N_T2L_N5_AD11N_6

set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS18} [get_ports spi0_csb]                            ; ## D11  FMC_LA05_P         IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18} [get_ports spi0_mosi]                           ; ## H10  FMC_LA04_P         IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS18} [get_ports spi0_sclk]                           ; ## H11  FMC_LA04_N         IO_L17N_T2U_N9_AD10N_66
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS18} [get_ports spi0_miso]                           ; ## D12  FMC_LA05_N         IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS18} [get_ports spi1_csb]                            ; ## G15  FMC_LA12_P         IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS18} [get_ports spi1_sclk]                           ; ## H16  FMC_LA11_P         IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS18} [get_ports spi1_sdio]                           ; ## G16  FMC_LA12_N         IO_L6N_T0U_N11_AD6N_666

set_property -dict {PACKAGE_PIN D24 IOSTANDARD LVCMOS18} [get_ports agc0[0]]                             ; ## D20  FMC_LA17_P         IO_L12P_T1U_N10_GC_67
set_property -dict {PACKAGE_PIN C24 IOSTANDARD LVCMOS18} [get_ports agc0[1]]                             ; ## D21  FMC_LA17_N         IO_L12N_T1U_N11_GC_67
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS18} [get_ports agc1[0]]                             ; ## C22  FMC_LA18_CC_P      IO_L14P_T2L_N2_GC_67
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS18} [get_ports agc1[1]]                             ; ## C23  FMC_LA18_CC_N      IO_L14N_T2L_N3_GC_67
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS18} [get_ports agc2[0]]                             ; ## G21  FMC_LA20_P         IO_L10P_T1U_N6_QBC_AD4P_67
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS18} [get_ports agc2[1]]                             ; ## G22  FMC_LA20_N         IO_L10N_T1U_N7_QBC_AD4N_67
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS18} [get_ports agc3[0]]                             ; ## H25  FMC_LA21_P         IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN F24 IOSTANDARD LVCMOS18} [get_ports agc3[1]]                             ; ## H26  FMC_LA21_N         IO_L21N_T3L_N5_AD8N_67

set_property -dict {PACKAGE_PIN M27 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports vadj_1v8_pgood]      ; ## IO_T1U_N12_43_AK35 
