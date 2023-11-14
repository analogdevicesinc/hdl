###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9434

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_p]      ; ## G6   FMC_LA00_CC_P  IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_n]      ; ## G7   FMC_LA00_CC_N  IO_L13N_T2_MRCC_34

set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[0]]  ; ## D17  FMC_LA13_P     IO_L4P_T0_34
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[0]]  ; ## D18  FMC_LA13_N     IO_L4N_T0_34
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[1]]  ; ## H16  FMC_LA11_P     IO_L5P_T0_34
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[2]]  ; ## G15  FMC_LA12_P     IO_L18P_T2_34
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[2]]  ; ## G16  FMC_LA12_N     IO_L18N_T2_34
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[3]]  ; ## D14  FMC_LA09_P     IO_L17P_T2_34
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[3]]  ; ## D15  FMC_LA09_N     IO_L17N_T2_34
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[4]]  ; ## C14  FMC_LA10_P     IO_L22P_T3_34
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[4]]  ; ## C15  FMC_LA10_N     IO_L22N_T3_34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[5]]  ; ## H13  FMC_LA07_P     IO_L21P_T3_DQS_34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[5]]  ; ## H14  FMC_LA07_N     IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[6]]  ; ## G12  FMC_LA08_P     IO_L8P_T1_34
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[6]]  ; ## G13  FMC_LA08_N     IO_L8N_T1_34
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[7]]  ; ## D11  FMC_LA05_P     IO_L7P_T1_34
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[7]]  ; ## D12  FMC_LA05_N     IO_L7N_T1_34
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[8]]  ; ## C10  FMC_LA06_P     IO_L10P_T1_34
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[8]]  ; ## C11  FMC_LA06_N     IO_L10N_T1_34
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[9]]  ; ## H10  FMC_LA04_P     IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[9]]  ; ## H11  FMC_LA04_N     IO_L15N_T2_DQS_34
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[10]] ; ## G9   FMC_LA03_P     IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[10]] ; ## G10  FMC_LA03_N     IO_L16N_T2_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[11]] ; ## D8   FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[11]] ; ## D9   FMC_LA01_CC_N  IO_L14N_T2_SRCC_34

#adc

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_p]       ; ## H7   FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_n]       ; ## H8   FMC_LA02_N     IO_L20N_T3_34

#spi

set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## G36  FMC_LA33_P     IO_L18P_T2_AD13P_35
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                  ; ## G37  FMC_LA33_N     IO_L18N_T2_AD13N_35
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports spi_dio]                      ; ## H37  FMC_LA32_P     IO_L15P_T2_DQS_AD12P_35
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports spi_sclk]                     ; ## H38  FMC_LA32_N     IO_L15N_T2_DQS_AD12N_35
