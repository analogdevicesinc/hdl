###############################################################################
## Copyright (C) 2022-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# adaq23875/adaq23876/adaq23878
# clocks

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_p]      ; ## G2   FMC_CLK1_M2C_P  IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_n]      ; ## G3   FMC_CLK1_M2C_N  IO_L12N_T1_MRCC_35
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25} [get_ports clk_p]                         ; ## G6   FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25} [get_ports clk_n]                         ; ## G7   FMC_LA00_CC_N   IO_L13N_T2_MRCC_34

# fpga_cnv

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25} [get_ports cnv_p]                         ; ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25} [get_ports cnv_n]                         ; ## D9   FMC_LA01_CC_N   IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports cnv_en]                       ; ## G10  FMC_LA03_N      IO_L16N_T2_34

# dco, da, db

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_p]          ; ## H4   FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_n]          ; ## H5   FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports da_p]           ; ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports da_n]           ; ## H8   FMC_LA02_N      IO_L20N_T3_34
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db_p]           ; ## H10  FMC_LA04_P      IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db_n]           ; ## H11  FMC_LA04_N      IO_L15N_T2_DQS_34

# 100MHz clock
set clk_period  10
# differential propagation delay for ref_clk
set tref_early  0.3
set tref_late   1.5

# clocks

create_clock -period $clk_period -name ref_clk  [get_ports ref_clk_p]

# clock latencies

# minimum source latency values
set_clock_latency -source -early $tref_early  [get_clocks ref_clk]
# maximum source latency values
set_clock_latency -source -late  $tref_late   [get_clocks ref_clk]
