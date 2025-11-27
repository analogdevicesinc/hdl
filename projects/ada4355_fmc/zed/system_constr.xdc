###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]; ## H4 FMC_CLK0_M2C_P IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]; ## H5 FMC_CLK0_M2C_N IO_L12N_T1_MRCC_34

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_p];  ## G9 FMC_LA03_P IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_n];  ## G10 FMC_LA03_N IO_L16N_T2_34

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_p];  ## H10 FMC_LA04_P IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_n];  ## H11 FMC_LA04_N IO_L15N_T2_DQS_34

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_p]; ## G6 FMC_LA00_CC_P IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_n]; ## G7 FMC_LA00_CC_N IO_L13N_T2_MRCC_34

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports freq_sel0];     ## H25 FMC_LA21_P IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports freq_sel1];     ## H26 FMC_LA21_N IO_L21N_T3_DQS_AD14N_35
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports gain_sel0];     ## G21 FMC_LA20_P IO_L22P_T3_AD7P_35
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports gain_sel1];     ## G22 FMC_LA20_N IO_L22N_T3_AD7N_35
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports gain_sel2];     ## G24 FMC_LA22_P IO_L20P_T3_AD6P_35
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports gain_sel3];     ## G25 FMC_LA22_N IO_L20N_T3_AD6N_35
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports gpio_vld_en];   ## G16 FMC_LA12_N IO_L18N_T2_34
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports gpio_test];     ## D23 FMC_LA23_P IO_L3P_T0_DQS_AD1P_35
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports trig_fmc_in];   ## C14 FMC_LA10_P IO_L22P_T3_34
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports trig_fmc_out];  ## C15 FMC_LA10_N IO_L22N_T3_34
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports apd_supp_en];   ## C18 FMC_LA14_P IO_L11P_T1_SRCC_34

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports csb_apd_pot];   ## G12 FMC_LA08_P IO_L8P_T1_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports sclk_pot];      ## D9 FMC_LA01_CC_N IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports mosi_pot];      ## H14 FMC_LA07_N IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports miso_pot];      ## H13 FMC_LA07_P IO_L21P_T3_DQS_34

set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports ada4355_csn];   ## G13 FMC_LA08_N IO_L8N_T1_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ada4355_sclk];  ## D8 FMC_LA01_CC_P IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ada4355_mosi];  ## H7 FMC_LA02_P IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ada4355_miso];  ## H8 FMC_LA02_N IO_L20N_T3_34

# TDD control signals for LiDAR - Using PMOD JA connector
# PMOD JA pins on ZedBoard (3.3V logic level)
set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports tdd_ext_sync];   ## PMOD JA1
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports laser_trigger];  ## PMOD JA2

# clocks

create_clock -period 2.000 -name dco_clk [get_ports dco_p]

# Clock groups to define asynchronous clock domains
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks dco_clk]
