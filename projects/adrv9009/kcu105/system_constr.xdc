###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#adrv9009

set_property -dict {PACKAGE_PIN K6}  [get_ports ref_clk0_p]                                  ; ## D4   FMC_GBTCLK0_M2C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN K5}  [get_ports ref_clk0_n]                                  ; ## D5   FMC_GBTCLK0_M2C_N  MGTREFCLK0N_228
set_property -dict {PACKAGE_PIN H6}  [get_ports ref_clk1_p]                                  ; ## B20  FMC_GBTCLK1_M2C_P  MGTREFCLK1P_228
set_property -dict {PACKAGE_PIN H5}  [get_ports ref_clk1_n]                                  ; ## B21  FMC_GBTCLK1_M2C_N  MGTREFCLK1N_228

set_property -dict {PACKAGE_PIN D2}  [get_ports rx_data_p[0]]                                ; ## A2   FMC_DP1_M2C_P      MGTHRXP1_228
set_property -dict {PACKAGE_PIN D1}  [get_ports rx_data_n[0]]                                ; ## A3   FMC_DP1_M2C_N      MGTHRXN1_228
set_property -dict {PACKAGE_PIN B2}  [get_ports rx_data_p[1]]                                ; ## A6   FMC_DP2_M2C_P      MGTHRXP2_228
set_property -dict {PACKAGE_PIN B1}  [get_ports rx_data_n[1]]                                ; ## A7   FMC_DP2_M2C_N      MGTHRXN2_228
set_property -dict {PACKAGE_PIN E4}  [get_ports rx_data_p[2]]                                ; ## C6   FMC_DP0_M2C_P      MGTHRXP0_228
set_property -dict {PACKAGE_PIN E3}  [get_ports rx_data_n[2]]                                ; ## C7   FMC_DP0_M2C_N      MGTHRXN0_228
set_property -dict {PACKAGE_PIN A4}  [get_ports rx_data_p[3]]                                ; ## A10  FMC_DP3_M2C_P      MGTHRXP3_228
set_property -dict {PACKAGE_PIN A3}  [get_ports rx_data_n[3]]                                ; ## A11  FMC_DP3_M2C_N      MGTHRXN3_228
set_property -dict {PACKAGE_PIN D6}  [get_ports tx_data_p[0]]                                ; ## A22  FMC_DP1_C2M_P      MGTHTXP1_228
set_property -dict {PACKAGE_PIN D5}  [get_ports tx_data_n[0]]                                ; ## A23  FMC_DP1_C2M_N      MGTHTXN1_228
set_property -dict {PACKAGE_PIN C4}  [get_ports tx_data_p[1]]                                ; ## A26  FMC_DP2_C2M_P      MGTHTXP2_228
set_property -dict {PACKAGE_PIN C3}  [get_ports tx_data_n[1]]                                ; ## A27  FMC_DP2_C2M_N      MGTHTXN2_228
set_property -dict {PACKAGE_PIN F6}  [get_ports tx_data_p[2]]                                ; ## C2   FMC_DP0_C2M_P      MGTHTXP0_228
set_property -dict {PACKAGE_PIN F5}  [get_ports tx_data_n[2]]                                ; ## C3   FMC_DP0_C2M_N      MGTHTXN0_228
set_property -dict {PACKAGE_PIN B6}  [get_ports tx_data_p[3]]                                ; ## A30  FMC_DP3_C2M_P      MGTHTXP3_228
set_property -dict {PACKAGE_PIN B5}  [get_ports tx_data_n[3]]                                ; ## A31  FMC_DP3_C2M_N      MGTHTXN3_228

set_property -dict {PACKAGE_PIN G9  IOSTANDARD LVDS} [get_ports sysref_out_p]                ; ## D8   FMC_LA01_CC_P      IO_L11P_T1U_N8_GC_66
set_property -dict {PACKAGE_PIN F9  IOSTANDARD LVDS} [get_ports sysref_out_n]                ; ## D9   FMC_LA01_CC_N      IO_L11N_T1U_N9_GC_66
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_p]     ; ## G6   FMC_LA00_CC_P      IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports sysref_n]     ; ## G7   FMC_LA00_CC_N      IO_L13N_T2L_N1_GC_QBC_66

set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS} [get_ports rx_sync_p]                   ; ## G9   FPC_LA03_P         IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVDS} [get_ports rx_sync_n]                   ; ## G10  FPC_LA03_N         IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS} [get_ports rx_os_sync_p]                ; ## G27  FMC_LA25_P         IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS} [get_ports rx_os_sync_n]                ; ## G28  FMC_LA25_N         IO_L18N_T2U_N11_AD2N_67
set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]    ; ## H7   FMC_LA02_P         IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]    ; ## H8   FMC_LA02_N         IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_p]  ; ## H28  FMC_LA24_P         IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_1_n]  ; ## H29  FMC_LA24_N         IO_L20N_T3L_N3_AD1N_67

set_property -dict {PACKAGE_PIN J9  IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009]        ; ## D14  FMC_LA09_P         IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN H9  IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]          ; ## D15  FMC_LA09_N         IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN F8  IOSTANDARD LVCMOS18} [get_ports spi_clk]                 ; ## H13  FMC_LA07_P         IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN E8  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                ; ## H14  FMC_LA07_N         IO_L1N_T0L_N1_DBC_66
set_property -dict {PACKAGE_PIN J8  IOSTANDARD LVCMOS18} [get_ports spi_miso]                ; ## G12  FMC_LA08_P         IO_L9P_T1L_N4_AD12P_66

set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]          ; ## D26  FMC_LA26_P         IO_L22P_T3U_N6_DBC_AD0P_67
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]       ; ## D27  FMC_LA26_N         IO_L22N_T3U_N7_DBC_AD0N_67

set_property -dict {PACKAGE_PIN D9  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable]     ; ## D17  FMC_LA13_P         IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN C9  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable]     ; ## D18  FMC_LA13_N         IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable]     ; ## C18  FMC_LA14_P         IO_L4P_T0U_N6_DBC_AD7P_66
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable]     ; ## C19  FMC_LA14_N         IO_L4N_T0U_N7_DBC_AD7N_66

set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS18} [get_ports adrv9009_test]           ; ## H16  FMC_LA11_P         IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b]        ; ## H10  FMC_LA04_P         IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint]          ; ## H11  FMC_LA04_N         IO_L17N_T2U_N9_AD10N_66

set_property -dict {PACKAGE_PIN D8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00]        ; ## H19  FMC_LA15_P         IO_L3P_T0L_N4_AD15P_66
set_property -dict {PACKAGE_PIN C8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01]        ; ## H20  FMC_LA15_N         IO_L3N_T0L_N5_AD15N_66
set_property -dict {PACKAGE_PIN B9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02]        ; ## G18  FMC_LA16_P         IO_L2P_T0L_N2_66
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03]        ; ## G19  FMC_LA16_N         IO_L2N_T0L_N3_66
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04]        ; ## H25  FMC_LA21_P         IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN F24 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05]        ; ## H26  FMC_LA21_N         IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06]        ; ## C22  FMC_LA18_CC_P      IO_L14P_T2L_N2_GC_67
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07]        ; ## C23  FMC_LA18_CC_N      IO_L14N_T2L_N3_GC_67
set_property -dict {PACKAGE_PIN F25 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08]        ; ## G25  FMC_LA22_N         IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_09]        ; ## H22  FMC_LA19_P         IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_10]        ; ## H23  FMC_LA19_N         IO_L16N_T2U_N7_QBC_AD3N_67
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_11]        ; ## G21  FMC_LA20_P         IO_L10P_T1U_N6_QBC_AD4P_67
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_12]        ; ## G22  FMC_LA20_N         IO_L10N_T1U_N7_QBC_AD4N_67
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]        ; ## G16  FMC_LA12_N         IO_L6N_T0U_N11_AD6N_666
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]        ; ## G15  FMC_LA12_P         IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_15]        ; ## G24  FMC_LA22_P         IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]        ; ## C11  FMC_LA06_N         IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]        ; ## C10  FMC_LA06_P         IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]        ; ## H17  FMC_LA11_N         IO_L15N_T2L_N5_AD11N_6

# clocks

create_clock -name tx_ref_clk     -period  4.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  4.00 [get_ports ref_clk1_p]

# For transceiver output clocks use reference clock
# This will help autoderive the clocks correcly
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

# Hold time constraints for critical paths
set_max_delay -datapath_only -from [get_clocks mmcm_clkout1] -to [get_clocks mmcm_clkout0] 5.0
set_min_delay -from [get_clocks mmcm_clkout1] -to [get_clocks mmcm_clkout0] 1.0
