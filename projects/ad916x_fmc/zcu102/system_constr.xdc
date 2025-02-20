###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# zcu102
# ad916x device

set_property -dict {PACKAGE_PIN  AB4 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p[0]]      ; ## D8   FMC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN  AC4 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n[0]]      ; ## D9   FMC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN  V2  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p[1]]      ; ## H7   FMC0_LA02_P           IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN  V1  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n[1]]      ; ## H8   FMC0_LA02_N           IO_L23N_T3U_N9_66

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

set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS18} [get_ports spi_clk]       ; ## G9   FMC0_LA03_P IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]   ; ## H11  FMC0_LA04_N IO_L21N_T3L_N5_AD8N_66
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]   ; ## D11  FMC0_LA05_P IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports spi_csn_clk2]  ; ## D14  FMC0_LA09_P IO_L20P_T3L_N2_AD1P_66
set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS18} [get_ports spi_miso]      ; ## H10  FMC0_LA04_P IO_L21P_T3L_N4_AD8P_66
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVCMOS18} [get_ports spi_mosi]      ; ## G10  FMC0_LA03_N IO_L22N_T3U_N7_DBC_AD0N_66
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18} [get_ports spi_en]        ; ## D12  FMC0_LA05_N IO_L20N_T3L_N3_AD1N_66

# For AD916(1,2,3,4)-FMC-EBZ
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports dac_ctrl[0]]   ; ## H13  FMC0_LA07_P      IO_L18P_T2U_N10_AD2P_66_U5
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports dac_ctrl[1]]   ; ## D15  FMC0_LA09_N      IO_L24N_T3U_N11_66

# Max lane rate of 15.4 Gbps
# ref clock lane_rate/40 or lane_rate/20

create_clock -name tx_ref_clk   -period 2.597 [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK

set_input_delay -clock [get_clocks tx_ref_clk] \
  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] \
  [get_ports {tx_sysref_*}]
