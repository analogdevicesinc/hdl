###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9747

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[0]]  ; ## H19  FMC_LA15_P      IO_L2P_T0_34
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[0]]  ; ## C26  FMC_LA27_P      IO_L17P_T2_AD5P_35
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[1]]  ; ## C18  FMC_LA14_P      IO_L11P_T1_SRCC_34
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[1]]  ; ## C22  FMC_LA18_CC_P   IO_L14P_T2_AD4P_SRCC_35
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[2]]  ; ## G18  FMC_LA16_P      IO_L9P_T1_DQS_34
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[2]]  ; ## H37  FMC_LA32_P      IO_L15P_T2_DQS_AD12P_35
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[3]]  ; ## D14  FMC_LA09_P      IO_L17P_T2_34
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[3]]  ; ## G36  FMC_LA33_P      IO_L18P_T2_AD13P_35
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[4]]  ; ## D17  FMC_LA13_P      IO_L4P_T0_34
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[4]]  ; ## H34  FMC_LA30_P      IO_L7P_T1_AD2P_35
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[5]]  ; ## H16  FMC_LA11_P      IO_L5P_T0_34
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[5]]  ; ## G33  FMC_LA31_P      IO_L8P_T1_AD10P_35
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[6]]  ; ## G15  FMC_LA12_P      IO_L18P_T2_34
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[6]]  ; ## H31  FMC_LA28_P      IO_L9P_T1_DQS_AD3P_35
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[7]]  ; ## D11  FMC_LA05_P      IO_L7P_T1_34
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[7]]  ; ## G30  FMC_LA29_P      IO_L11P_T1_SRCC_35
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[8]]  ; ## C14  FMC_LA10_P      IO_L22P_T3_34
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[8]]  ; ## H28  FMC_LA24_P      IO_L10P_T1_AD11P_35
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[9]]  ; ## H13  FMC_LA07_P      IO_L21P_T3_DQS_34
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[9]]  ; ## G27  FMC_LA25_P      IO_L16P_T2_35
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[10]] ; ## G12  FMC_LA08_P      IO_L8P_T1_34
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[10]] ; ## D26  FMC_LA26_P      IO_L5P_T0_AD9P_35
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[11]] ; ## C10  FMC_LA06_P      IO_L10P_T1_34
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[11]] ; ## H25  FMC_LA21_P      IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[12]] ; ## G9   FMC_LA03_P      IO_L16P_T2_34
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[12]] ; ## G24  FMC_LA22_P      IO_L20P_T3_AD6P_35
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[13]] ; ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[13]] ; ## D23  FMC_LA23_P      IO_L3P_T0_DQS_AD1P_35
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[14]] ; ## H10  FMC_LA04_P      IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[14]] ; ## H22  FMC_LA19_P      IO_L4P_T0_35
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p1[15]] ; ## G2   FMC_CLK1_M2C_P  IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports data_p2[15]] ; ## G21  FMC_LA20_P      IO_L22P_T3_AD7P_35

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco]         ; ## G6   FMC_LA00_CC_P   IO_L13P_T2_MRCC_34

# spi ports
# can't be configured :(
# t.b.c. in the future