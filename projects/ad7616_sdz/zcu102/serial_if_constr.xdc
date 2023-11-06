###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad7616 - Serial mode
# Note: The design uses an SDP to FMC interposer.

set_property -dict {PACKAGE_PIN AJ1  IOSTANDARD LVCOMOS18} [get_ports spi_sclk]         ; ## G10  FMC1_LA03_N      IO_L22N_T3U_N7_DBC_AD0N_65
set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVCOMOS18} [get_ports spi_sdo]          ; ## G9   FMC1_LA03_P      IO_L22P_T3U_N6_DBC_AD0P_65
set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCOMOS18} [get_ports spi_sdi[0]]       ; ## G6   FMC1_LA00_CC_P   IO_L13P_T2L_N0_GC_QBC_65
set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVCOMOS18} [get_ports spi_sdi[1]]       ; ## D9   FMC1_LA01_CC_N   IO_L16N_T2U_N7_QBC_AD3N_65
set_property -dict {PACKAGE_PIN AF1  IOSTANDARD LVCOMOS18} [get_ports spi_cs]           ; ## H11  FMC1_LA04_N      IO_L21N_T3L_N5_AD8N_65

set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCOMOS18} [get_ports adc_cnvst]        ; ## H28  FMC1_LA24_P      IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCOMOS18} [get_ports adc_chsel[0]]     ; ## H26  FMC1_LA21_N      IO_L1N_T0L_N1_DBC_66
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCOMOS18} [get_ports adc_chsel[1]]     ; ## D27  FMC1_LA26_N      IO_L4N_T0U_N7_DBC_AD7N_67
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCOMOS18} [get_ports adc_chsel[2]]     ; ## G27  FMC1_LA25_P      IO_L1P_T0L_N0_DBC_65
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCOMOS18} [get_ports adc_hw_rngsel[0]] ; ## H25  FMC1_LA21_P      IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCOMOS18} [get_ports adc_hw_rngsel[1]] ; ## D26  FMC1_LA26_P      IO_L4P_T0U_N6_DBC_AD7P_67
set_property -dict {PACKAGE_PIN AJ4  IOSTANDARD LVCOMOS18} [get_ports adc_busy]         ; ## C15  FMC1_LA10_N      IO_L15N_T2L_N5_AD11N_65
set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCOMOS18} [get_ports adc_seq_en]       ; ## C26  FMC1_LA27_P      IO_L3P_T0L_N4_AD15P_67
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCOMOS18} [get_ports adc_reset_n]      ; ## G25  FMC1_LA22_N      IO_L4N_T0U_N7_DBC_AD7N_65

set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVCOMOS18} [get_ports adc_os[0]]        ; ## H5   FMC1_CLK0_M2C_N  IO_L12N_T1U_N11_GC_65
set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVCOMOS18} [get_ports adc_os[1]]        ; ## H4   FMC1_CLK0_M2C_P  IO_L12P_T1U_N10_GC_65
set_property -dict {PACKAGE_PIN AJ6  IOSTANDARD LVCOMOS18} [get_ports adc_os[2]]        ; ## D8   FMC1_LA01_CC_P   IO_L16P_T2U_N6_QBC_AD3P_65
set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCOMOS18} [get_ports adc_burst]        ; ## D15  FMC1_LA09_N      IO_L24N_T3U_N11_PERSTN0_65
set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCOMOS18} [get_ports adc_crcen]        ; ## H8   FMC1_LA02_N      IO_L23N_T3U_N9_65

