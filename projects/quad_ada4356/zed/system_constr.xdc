###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface (shared bus, active-low chip selects via GPIO)

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports sclk];         ## H4  FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34         SCLK_FMC
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports mosi];         ## H7  FMC_LA02_P      IO_L20P_T3_34              SDI_FMC
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports miso];         ## H8  FMC_LA02_N      IO_L20N_T3_34              SDO_FMC

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports csb_dutd];     ## H19 FMC_LA15_P      IO_L2P_T0_34               CSB_DUTD_FMC
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports csb_duta];     ## H20 FMC_LA15_N      IO_L2N_T0_34               CSB_DUTA_FMC
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports csb_dutc];     ## G18 FMC_LA16_P      IO_L9P_T1_DQS_34           CSB_DUTC_FMC
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports csb_dutb];     ## G19 FMC_LA16_N      IO_L9N_T1_DQS_34           CSB_DUTB_FMC

# Other control signals

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports trig_fmc_in];  ## H10 FMC_LA04_P      IO_L15P_T2_DQS_34          TRIG_FMC_IN
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports trig_fmc_out]; ## H11 FMC_LA04_N      IO_L15N_T2_DQS_34          TRIG_FMC_OUT

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports csb_ad9510];   ## C10 FMC_LA06_P      IO_L10P_T1_34              CSB_AD9510_FMC
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS25} [get_ports int_max7329];  ## H34 FMC_LA30_P      IO_L7P_T1_AD2P_35          INT_MAX7329

# ADA4356 Instance 0 (DUT A) - LVDS Data Interface (bank 34)

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_0_p];   ## D8  FMC_LA01_CC_P   IO_L14P_T2_SRCC_34        DCOP_A
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_0_n];   ## D9  FMC_LA01_CC_N   IO_L14N_T2_SRCC_34        DCON_A
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_0_p];   ## D14 FMC_LA09_P      IO_L17P_T2_34             D0AP
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_0_n];   ## D15 FMC_LA09_N      IO_L17N_T2_34             D0AN
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_0_p];   ## C14 FMC_LA10_P      IO_L22P_T3_34             D1AP
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_0_n];   ## C15 FMC_LA10_N      IO_L22N_T3_34             D1AN
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_0_p]; ## D11 FMC_LA05_P      IO_L7P_T1_34              FCOP_A
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_0_n]; ## D12 FMC_LA05_N      IO_L7N_T1_34              FCON_A

# ADA4356 Instance 1 (DUT B) - LVDS Data Interface (bank 34)

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_1_p];   ## G6  FMC_LA00_CC_P   IO_L13P_T2_MRCC_34        DCOP_B
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_1_n];   ## G7  FMC_LA00_CC_N   IO_L13N_T2_MRCC_34        DCON_B
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_1_p];   ## G12 FMC_LA08_P      IO_L8P_T1_34              D0BP
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_1_n];   ## G13 FMC_LA08_N      IO_L8N_T1_34              D0BN
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_1_p];   ## H13 FMC_LA07_P      IO_L21P_T3_DQS_34         D1BP
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_1_n];   ## H14 FMC_LA07_N      IO_L21N_T3_DQS_34         D1BN
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_1_p]; ## G9  FMC_LA03_P      IO_L16P_T2_34             FCOP_B
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_1_n]; ## G10 FMC_LA03_N      IO_L16N_T2_34             FCON_B

# ADA4356 Instance 2 (DUT C) - LVDS Data Interface (bank 35)

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_2_p];   ## D20 FMC_LA17_CC_P   IO_L13P_T2_MRCC_35        DCOP_C
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_2_n];   ## D21 FMC_LA17_CC_N   IO_L13N_T2_MRCC_35        DCON_C
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_2_p];   ## G21 FMC_LA20_P      IO_L22P_T3_AD7P_35        D0CP
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_2_n];   ## G22 FMC_LA20_N      IO_L22N_T3_AD7N_35        D0CN
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_2_p];   ## H22 FMC_LA19_P      IO_L4P_T0_35              D1CP
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_2_n];   ## H23 FMC_LA19_N      IO_L4N_T0_35              D1CN
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_2_p]; ## D23 FMC_LA23_P      IO_L3P_T0_DQS_AD1P_35     FCOP_C
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_2_n]; ## D24 FMC_LA23_N      IO_L3N_T0_DQS_AD1N_35     FCON_C

# ADA4356 Instance 3 (DUT D) - LVDS Data Interface (bank 35)

set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_3_p];   ## C22 FMC_LA18_CC_P   IO_L14P_T2_AD4P_SRCC_35   DCOP_D
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_3_n];   ## C23 FMC_LA18_CC_N   IO_L14N_T2_AD4N_SRCC_35   DCON_D
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_3_p];   ## G24 FMC_LA22_P      IO_L20P_T3_AD6P_35        D0DP
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_3_n];   ## G25 FMC_LA22_N      IO_L20N_T3_AD6N_35        D0DN
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_3_p];   ## H25 FMC_LA21_P      IO_L21P_T3_DQS_AD14P_35   D1DP
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_3_n];   ## H26 FMC_LA21_N      IO_L21N_T3_DQS_AD14N_35   D1DN
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_3_p]; ## C26 FMC_LA27_P      IO_L17P_T2_AD5P_35        FCOP_D
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_3_n]; ## C27 FMC_LA27_N      IO_L17N_T2_AD5N_35        FCON_D

# Clock constraints for all ADA4356 DCO clocks
create_clock -period 2.000 -name dco_0_clk [get_ports dco_0_p]
create_clock -period 2.000 -name dco_1_clk [get_ports dco_1_p]
create_clock -period 2.000 -name dco_2_clk [get_ports dco_2_p]
create_clock -period 2.000 -name dco_3_clk [get_ports dco_3_p]
