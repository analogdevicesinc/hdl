###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9265

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]     ; ## H4   FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]     ; ## H5   FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34

set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]] ; ## D14  FMC_LA09_P      IO_L17P_T2_34
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]] ; ## D15  FMC_LA09_N      IO_L17N_T2_34
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]] ; ## C10  FMC_LA06_P      IO_L10P_T1_34
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]] ; ## C11  FMC_LA06_N      IO_L10N_T1_34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]] ; ## H13  FMC_LA07_P      IO_L21P_T3_DQS_34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]] ; ## H14  FMC_LA07_N      IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]] ; ## G12  FMC_LA08_P      IO_L8P_T1_34
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]] ; ## G13  FMC_LA08_N      IO_L8N_T1_34
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]] ; ## H10  FMC_LA04_P      IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]] ; ## H11  FMC_LA04_N      IO_L15N_T2_DQS_34
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]] ; ## D11  FMC_LA05_P      IO_L7P_T1_34
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]] ; ## D12  FMC_LA05_N      IO_L7N_T1_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]] ; ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]] ; ## H8   FMC_LA02_N      IO_L20N_T3_34
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]] ; ## G9   FMC_LA03_P      IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]] ; ## G10  FMC_LA03_N      IO_L16N_T2_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]    ; ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]    ; ## D9   FMC_LA01_CC_N   IO_L14N_T2_SRCC_34

# spi

set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                    ; ## G36  FMC_LA33_P      IO_L18P_T2_AD13P_35
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                    ; ## G37  FMC_LA33_N      IO_L18N_T2_AD13N_35
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports spi_sdio]                       ; ## H37  FMC_LA32_P      IO_L15P_T2_DQS_AD12P_35
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports spi_clk]                        ; ## H38  FMC_LA32_N      IO_L15N_T2_DQS_AD12N_35

# clocks

create_clock -name adc_clk      -period 3.33             [get_ports adc_clk_in_p]                   ;
