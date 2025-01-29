###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN  N19  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports clk_in_p]    ; ##D8    FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property  -dict {PACKAGE_PIN  N20  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports clk_in_n]    ; ##D9    FMC_LA01_CC_N   IO_L14N_T2_SRCC_34

set_property  -dict {PACKAGE_PIN M19  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports fclk_p]       ; ##G6    FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property  -dict {PACKAGE_PIN M20  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports fclk_n]       ; ##G7    FMC_LA00_CC_N   IO_L13N_T2_MRCC_34

set_property  -dict {PACKAGE_PIN L17  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports trig_p]       ; ##D17   FMC_LA13_P    IO_L4P_T0_34
set_property  -dict {PACKAGE_PIN M17  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports trig_n]       ; ##D18   FMC_LA13_N    IO_L4N_T0_34

set_property  -dict {PACKAGE_PIN R19  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[0]] ; ##C14   FMC_LA10_P    IO_L22P_T3_34
set_property  -dict {PACKAGE_PIN R20  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[1]] ; ##D14   FMC_LA09_P    IO_L17P_T2_34
set_property  -dict {PACKAGE_PIN J21  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[2]] ; ##G12   FMC_LA08_P    IO_L8P_T1_34
set_property  -dict {PACKAGE_PIN M21  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[3]] ; ##H10   FMC_LA04_P    IO_L15P_T2_DQS_34
set_property  -dict {PACKAGE_PIN N17  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[4]] ; ##H16   FMC_LA11_P    IO_L5P_T0_34
set_property  -dict {PACKAGE_PIN T16  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[5]] ; ##H13   FMC_LA07_P    IO_L21P_T3_DQS_34
set_property  -dict {PACKAGE_PIN J18  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[6]] ; ##D11   FMC_LA05_P    IO_L7P_T1_34
set_property  -dict {PACKAGE_PIN L21  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_p[7]] ; ##C10   FMC_LA06_P    IO_L10P_T1_34

set_property  -dict {PACKAGE_PIN T19  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[0]] ; ##C15   FMC_LA10_N    IO_L22N_T3_34
set_property  -dict {PACKAGE_PIN R21  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[1]] ; ##D15   FMC_LA09_N    IO_L17N_T2_34
set_property  -dict {PACKAGE_PIN J22  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[2]] ; ##G13   FMC_LA08_N    IO_L8N_T1_34
set_property  -dict {PACKAGE_PIN M22  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[3]] ; ##H11   FMC_LA04_N    IO_L15N_T2_DQS_34
set_property  -dict {PACKAGE_PIN N18  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[4]] ; ##H17   FMC_LA11_N    IO_L5N_T0_34
set_property  -dict {PACKAGE_PIN T17  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[5]] ; ##H14   FMC_LA07_N    IO_L21N_T3_DQS_34
set_property  -dict {PACKAGE_PIN J18  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[6]] ; ##D11   FMC_LA05_P    IO_L7P_T1_34
set_property  -dict {PACKAGE_PIN L21  IOSTANDARD LVDS_25 DIFF_TERM 1}  [get_ports data_in_n[7]] ; ##C10   FMC_LA06_P    IO_L10P_T1_34

set_property  -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS25}  [get_ports spi_csn]      ; ## G10  FMC_LA03_N       IO_L16N_T2_34
set_property  -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25}  [get_ports spi_clk]      ; ## H7   FMC_LA02_P       IO_L20P_T3_34
set_property  -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25}  [get_ports spi_sdio]     ; ## H8   FMC_LA02_N       IO_L20N_T3_34

set_property  -dict {PACKAGE_PIN P20  IOSTANDARD LVCMOS25}  [get_ports fmc_pd]       ; ##G15   FMC_LA12_P       IO_L18P_T2_34
set_property  -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS25}  [get_ports fmc_rstn]     ; ##G16   FMC_LA12_N       IO_L18N_T2_34


create_clock -name adc_clk   -period 2 [get_ports clk_in_p]
create_clock -name frame_clk -period 8 [get_ports fclk_p]