###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# zcu102
# ad9166 device

set_property -dict {PACKAGE_PIN  AB4 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## D8   FMC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN  AC4 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## D9   FMC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66

# tx_sysref = LA00_CC_P/N = SYSREF_FMC_P/N
set_property -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p] ; ## G6  FMC_HPC0_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_66_Y4
set_property -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n] ; ## G7  FMC_HPC0_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_66_Y3

# GBTCLK0_M2C_P/N = BR40_P/N
set_property -dict {PACKAGE_PIN G8} [get_ports tx_ref_clk_p] ; ## D4   FMC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7} [get_ports tx_ref_clk_n] ; ## D5   FMC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229

set_property -dict {PACKAGE_PIN G4} [get_ports tx_data_p[0]] ; ## C2      FMC0_DP0_C2M_P     MGTHTXP2_229
set_property -dict {PACKAGE_PIN G3} [get_ports tx_data_n[0]] ; ## C3      FMC0_DP0_C2M_N     MGTHTXN2_229
set_property -dict {PACKAGE_PIN H6} [get_ports tx_data_p[1]] ; ## A22     FMC0_DP1_C2M_P     MGTHTXP1_229
set_property -dict {PACKAGE_PIN H5} [get_ports tx_data_n[1]] ; ## A23     FMC0_DP1_C2M_N     MGTHTXN1_229
set_property -dict {PACKAGE_PIN F6} [get_ports tx_data_p[2]] ; ## A26     FMC0_DP2_C2M_P     MGTHTXP3_229
set_property -dict {PACKAGE_PIN F5} [get_ports tx_data_n[2]] ; ## A27     FMC0_DP2_C2M_N     MGTHTXN3_229
set_property -dict {PACKAGE_PIN K6} [get_ports tx_data_p[3]] ; ## A30     FMC0_DP3_C2M_P     MGTHTXP0_229
set_property -dict {PACKAGE_PIN K5} [get_ports tx_data_n[3]] ; ## A31     FMC0_DP3_C2M_N     MGTHTXN0_229
set_property -dict {PACKAGE_PIN N4} [get_ports tx_data_p[4]] ; ## B32     FMC0_DP7_C2M_P     MGTHTXP2_228
set_property -dict {PACKAGE_PIN N3} [get_ports tx_data_n[4]] ; ## B33     FMC0_DP7_C2M_N     MGTHTXN2_228
set_property -dict {PACKAGE_PIN M6} [get_ports tx_data_p[5]] ; ## A34     FMC0_DP4_C2M_P     MGTHTXP3_228
set_property -dict {PACKAGE_PIN M5} [get_ports tx_data_n[5]] ; ## A35     FMC0_DP4_C2M_N     MGTHTXN3_228
set_property -dict {PACKAGE_PIN R4} [get_ports tx_data_p[6]] ; ## B36     FMC0_DP6_C2M_P     MGTHTXP0_228
set_property -dict {PACKAGE_PIN R3} [get_ports tx_data_n[6]] ; ## B37     FMC0_DP6_C2M_N     MGTHTXN0_228
set_property -dict {PACKAGE_PIN P6} [get_ports tx_data_p[7]] ; ## A38     FMC0_DP5_C2M_P     MGTHTXP1_228
set_property -dict {PACKAGE_PIN P5} [get_ports tx_data_n[7]] ; ## A39     FMC0_DP5_C2M_N     MGTHTXN1_228

set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS18} [get_ports spi_clk]           ; ## G9   FMC0_LA03_P IO_L22P_T3U_N6_DBC_AD0P_66
# FMC_CS1 (AD9166)
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]       ; ## H11  FMC0_LA04_N IO_L21N_T3L_N5_AD8N_66
# FMC_CS2 (HMC7044)
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18} [get_ports spi_csn_hmc7044]   ; ## D11  FMC0_LA05_P IO_L24P_T3U_N10_66
# FMC_CS3 (ADF4372)
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports spi_cs_adf4372]    ; ## C10  FMC_HPC0_LA06_P  IO_L19P_T3L_N0_DBC_AD9P_66_AC2
# FMC_CS4 (Amplifier)
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports spi_cs_amp]    ; ## C11  FMC_HPC0_LA06_N  IO_L19N_T3L_N1_DBC_AD9N_66_AC1
set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS18} [get_ports spi_miso]      ; ## H10  FMC0_LA04_P IO_L21P_T3L_N4_AD8P_66
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVCMOS18} [get_ports spi_mosi]      ; ## G10  FMC0_LA03_N IO_L22N_T3U_N7_DBC_AD0N_66
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18} [get_ports spi_en]        ; ## D12  FMC0_LA05_N IO_L20N_T3L_N3_AD1N_66

set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports fmc_txen]      ; ## H13  FMC0_HPC_LA07_P  IO_L18P_T2U_N10_AD2P_66

# PL PMOD 1 header
set_property  -dict {PACKAGE_PIN  D20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]  ; ## PMOD1_0   IO_L8N_HDGC_AD4N_47_D20
set_property  -dict {PACKAGE_PIN  E20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]  ; ## PMOD1_1   IO_L8P_HDGC_AD4P_47_E20
set_property  -dict {PACKAGE_PIN  D22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi] ; ## PMOD1_2   IO_L7N_HDGC_AD5N_47_D22
set_property  -dict {PACKAGE_PIN  E22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso] ; ## PMOD1_3   IO_L7P_HDGC_AD5P_47_E22
set_property  -dict {PACKAGE_PIN  F20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[0]]  ; ## PMOD1_4   IO_L6N_HDGC_AD6N_47_F20
set_property  -dict {PACKAGE_PIN  G20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[1]]  ; ## PMOD1_5   IO_L6P_HDGC_AD6P_47_G20
set_property  -dict {PACKAGE_PIN  J20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[2]]  ; ## PMOD1_6   IO_L4N_AD8N_47_J20
set_property  -dict {PACKAGE_PIN  J19 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[3]]  ; ## PMOD1_7   IO_L4P_AD8P_47_J19

# Max lane rate of 12.5 Gbps
# ref clock lane_rate/40

create_clock -name tx_ref_clk   -period  3.2 [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK

set_input_delay -clock [get_clocks tx_ref_clk] \
  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] \
  [get_ports {tx_sysref_*}]
