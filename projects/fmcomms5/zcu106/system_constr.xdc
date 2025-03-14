###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints

# ad9361 master

set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports ref_clk_p]               ; ## D20  FMC_HPC0_LA17_CC_P  IO_L14P_T2L_N2_GC_68
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports ref_clk_n]               ; ## D21  FMC_HPC0_LA17_CC_N  IO_L14N_T2L_N3_GC_68
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_0_p]           ; ## G6   FMC_HPC0_LA00_CC_P  IO_L13P_T2L_N0_GC_QBC_67
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_0_n]           ; ## G7   FMC_HPC0_LA00_CC_N  IO_L13N_T2L_N1_GC_QBC_67
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_0_p]         ; ## D8   FMC_HPC0_LA01_CC_P  IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_0_n]         ; ## D9   FMC_HPC0_LA01_CC_N  IO_L16N_T2U_N7_QBC_AD3N_67
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVDS} [get_ports tx_clk_out_0_p]                         ; ## G12  FMC_HPC0_LA08_P     IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS} [get_ports tx_clk_out_0_n]                         ; ## G13  FMC_HPC0_LA08_N     IO_L9N_T1L_N5_AD12N_67
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVDS} [get_ports tx_frame_out_0_p]                       ; ## D14  FMC_HPC0_LA09_P     IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS} [get_ports tx_frame_out_0_n]                       ; ## D15  FMC_HPC0_LA09_N     IO_L18N_T2U_N11_AD2N_67

set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[0]]       ; ## H7   FMC_HPC0_LA02_P     IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[0]]       ; ## H8   FMC_HPC0_LA02_N     IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[1]]       ; ## G9   FMC_HPC0_LA03_P     IO_L23P_T3U_N8_67
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[1]]       ; ## G10  FMC_HPC0_LA03_N     IO_L23N_T3U_N9_67
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[2]]       ; ## H10  FMC_HPC0_LA04_P     IO_L24P_T3U_N10_67
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[2]]       ; ## H11  FMC_HPC0_LA04_N     IO_L24N_T3U_N11_67
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[3]]       ; ## D11  FMC_HPC0_LA05_P     IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[3]]       ; ## D12  FMC_HPC0_LA05_N     IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[4]]       ; ## C10  FMC_HPC0_LA06_P     IO_L15P_T2L_N4_AD11P_67
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[4]]       ; ## C11  FMC_HPC0_LA06_N     IO_L15N_T2L_N5_AD11N_67
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_p[5]]       ; ## H13  FMC_HPC0_LA07_P     IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_0_n[5]]       ; ## H14  FMC_HPC0_LA07_N     IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[0]]                     ; ## C14  FMC_HPC0_LA10_P     IO_L22P_T3U_N6_DBC_AD0P_67
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[0]]                     ; ## C15  FMC_HPC0_LA10_N     IO_L22N_T3U_N7_DBC_AD0N_67
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[1]]                     ; ## H16  FMC_HPC0_LA11_P     IO_L5P_T0U_N8_AD14P_67
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[1]]                     ; ## H17  FMC_HPC0_LA11_N     IO_L5N_T0U_N9_AD14N_67
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[2]]                     ; ## G15  FMC_HPC0_LA12_P     IO_L17P_T2U_N8_AD10P_67
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[2]]                     ; ## G16  FMC_HPC0_LA12_N     IO_L17N_T2U_N9_AD10N_67
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[3]]                     ; ## D17  FMC_HPC0_LA13_P     IO_L14P_T2L_N2_GC_67
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[3]]                     ; ## D18  FMC_HPC0_LA13_N     IO_L14N_T2L_N3_GC_67
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[4]]                     ; ## C18  FMC_HPC0_LA14_P     IO_L6P_T0U_N10_AD6P_67
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[4]]                     ; ## C19  FMC_HPC0_LA14_N     IO_L6N_T0U_N11_AD6N_67
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVDS} [get_ports tx_data_out_0_p[5]]                     ; ## H19  FMC_HPC0_LA15_P     IO_L7P_T1L_N0_QBC_AD13P_67
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS} [get_ports tx_data_out_0_n[5]]                     ; ## H20  FMC_HPC0_LA15_N     IO_L7N_T1L_N1_QBC_AD13N_67

set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS18} [get_ports mcs_sync]                           ; ## C22  FMC_HPC0_LA18_CC_P  IO_L16P_T2U_N6_QBC_AD3P_68
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS18} [get_ports enable_0]                           ; ## G18  FMC_HPC0_LA16_P     IO_L8P_T1L_N2_AD5P_67
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS18} [get_ports txnrx_0]                            ; ## G19  FMC_HPC0_LA16_N     IO_L8N_T1L_N3_AD5N_67

set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[0]]                   ; ## H22  FMC_HPC0_LA19_P     IO_L18P_T2U_N10_AD2P_68
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[1]]                   ; ## H23  FMC_HPC0_LA19_N     IO_L18N_T2U_N11_AD2N_68
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[2]]                   ; ## G21  FMC_HPC0_LA20_P     IO_L17P_T2U_N8_AD10P_68
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[3]]                   ; ## G22  FMC_HPC0_LA20_N     IO_L17N_T2U_N9_AD10N_68
set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[4]]                   ; ## H25  FMC_HPC0_LA21_P     IO_L22P_T3U_N6_DBC_AD0P_68
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[5]]                   ; ## H26  FMC_HPC0_LA21_N     IO_L22N_T3U_N7_DBC_AD0N_68
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[6]]                   ; ## G24  FMC_HPC0_LA22_P     IO_L15P_T2L_N4_AD11P_68
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS18} [get_ports gpio_status_0[7]]                   ; ## G25  FMC_HPC0_LA22_N     IO_L15N_T2L_N5_AD11N_68
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS18} [get_ports gpio_ctl_0[0]]                      ; ## D23  FMC_HPC0_LA23_P     IO_L24P_T3U_N10_68
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS18} [get_ports gpio_ctl_0[1]]                      ; ## D24  FMC_HPC0_LA23_N     IO_L24N_T3U_N11_68
set_property -dict {PACKAGE_PIN B6  IOSTANDARD LVCMOS18} [get_ports gpio_ctl_0[2]]                      ; ## H28  FMC_HPC0_LA24_P     IO_L21P_T3L_N4_AD8P_68
set_property -dict {PACKAGE_PIN A6  IOSTANDARD LVCMOS18} [get_ports gpio_ctl_0[3]]                      ; ## H29  FMC_HPC0_LA24_N     IO_L21N_T3L_N5_AD8N_68
set_property -dict {PACKAGE_PIN C7  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc_0]                      ; ## G27  FMC_HPC0_LA25_P     IO_L19P_T3L_N0_DBC_AD9P_68
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS18} [get_ports gpio_resetb_0]                      ; ## C23  FMC_HPC0_LA18_CC_N  IO_L16N_T2U_N7_QBC_AD3N_68
set_property -dict {PACKAGE_PIN A8  IOSTANDARD LVCMOS18} [get_ports gpio_debug_1_0]                     ; ## C26  FMC_HPC0_LA27_P     IO_L23P_T3U_N8_68
set_property -dict {PACKAGE_PIN A7  IOSTANDARD LVCMOS18} [get_ports gpio_debug_2_0]                     ; ## C27  FMC_HPC0_LA27_N     IO_L23N_T3U_N9_68
set_property -dict {PACKAGE_PIN B9  IOSTANDARD LVCMOS18} [get_ports gpio_calsw_1_0]                     ; ## D26  FMC_HPC0_LA26_P     IO_L20P_T3L_N2_AD1P_68
set_property -dict {PACKAGE_PIN B8  IOSTANDARD LVCMOS18} [get_ports gpio_calsw_2_0]                     ; ## D27  FMC_HPC0_LA26_N     IO_L20N_T3L_N3_AD1N_68
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS18} [get_ports gpio_ad5355_rfen]                   ; ## H31  FMC_HPC0_LA28_P     IO_L1P_T0L_N0_DBC_68
set_property -dict {PACKAGE_PIN F8  IOSTANDARD LVCMOS18} [get_ports gpio_ad5355_lock]                   ; ## H37  FMC_HPC0_LA32_P     IO_L9P_T1L_N4_AD12P_68

# spi

set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports spi_ad9361_0]       ; ## G30  FMC_HPC0_LA29_P     IO_L2P_T0L_N2_68
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports spi_ad9361_1]       ; ## G31  FMC_HPC0_LA29_N     IO_L2N_T0L_N3_68
set_property -dict {PACKAGE_PIN E9  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports spi_ad5355]         ; ## H34  FMC_HPC0_LA30_P     IO_L10P_T1U_N6_QBC_AD4P_68
set_property -dict {PACKAGE_PIN D9  IOSTANDARD LVCMOS18} [get_ports spi_clk]                            ; ## H35  FMC_HPC0_LA30_N     IO_L10N_T1U_N7_QBC_AD4N_68
set_property -dict {PACKAGE_PIN F7  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                           ; ## G33  FMC_HPC0_LA31_P     IO_L7P_T1L_N0_QBC_AD13P_68
set_property -dict {PACKAGE_PIN E7  IOSTANDARD LVCMOS18} [get_ports spi_miso]                           ; ## G34  FMC_HPC0_LA31_N     IO_L7N_T1L_N1_QBC_AD13N_68

# ad9361 slave

set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_1_p]           ; ## G6   FMC_HPC1_LA00_CC_P  IO_L22P_T3U_N6_DBC_AD0P_28
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_1_n]           ; ## G7   FMC_HPC1_LA00_CC_N  IO_L22N_T3U_N7_DBC_AD0N_28
set_property -dict {PACKAGE_PIN E24 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_1_p]         ; ## D8   FMC_HPC1_LA01_CC_P  IO_L16P_T2U_N6_QBC_AD3P_28
set_property -dict {PACKAGE_PIN D24 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_1_n]         ; ## D9   FMC_HPC1_LA01_CC_N  IO_L16N_T2U_N7_QBC_AD3N_28
set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVDS} [get_ports tx_clk_out_1_p]                         ; ## G12  FMC_HPC1_LA08_P     IO_L5P_T0U_N8_AD14P_28
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVDS} [get_ports tx_clk_out_1_n]                         ; ## G13  FMC_HPC1_LA08_N     IO_L5N_T0U_N9_AD14N_28
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS} [get_ports tx_frame_out_1_p]                       ; ## D14  FMC_HPC1_LA09_P     IO_L10P_T1U_N6_QBC_AD4P_28
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVDS} [get_ports tx_frame_out_1_n]                       ; ## D15  FMC_HPC1_LA09_N     IO_L10N_T1U_N7_QBC_AD4N_28

set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[0]]       ; ## H7   FMC_HPC1_LA02_P     IO_L4P_T0U_N6_DBC_AD7P_28
set_property -dict {PACKAGE_PIN K23 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[0]]       ; ## H8   FMC_HPC1_LA02_N     IO_L4N_T0U_N7_DBC_AD7N_28
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[1]]       ; ## G9   FMC_HPC1_LA03_P     IO_L3P_T0L_N4_AD15P_28
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[1]]       ; ## G10  FMC_HPC1_LA03_N     IO_L3N_T0L_N5_AD15N_28
set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[2]]       ; ## H10  FMC_HPC1_LA04_P     IO_L6P_T0U_N10_AD6P_28
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[2]]       ; ## H11  FMC_HPC1_LA04_N     IO_L6N_T0U_N11_AD6N_28
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[3]]       ; ## D11  FMC_HPC1_LA05_P     IO_L18P_T2U_N10_AD2P_28
set_property -dict {PACKAGE_PIN G26 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[3]]       ; ## D12  FMC_HPC1_LA05_N     IO_L18N_T2U_N11_AD2N_28
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[4]]       ; ## C10  FMC_HPC1_LA06_P     IO_L8P_T1L_N2_AD5P_28
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[4]]       ; ## C11  FMC_HPC1_LA06_N     IO_L8N_T1L_N3_AD5N_28
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_p[5]]       ; ## H13  FMC_HPC1_LA07_P     IO_L17P_T2U_N8_AD10P_28
set_property -dict {PACKAGE_PIN C23 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_1_n[5]]       ; ## H14  FMC_HPC1_LA07_N     IO_L17N_T2U_N9_AD10N_28
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[0]]                     ; ## C14  FMC_HPC1_LA10_P     IO_L11P_T1U_N8_GC_28
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[0]]                     ; ## C15  FMC_HPC1_LA10_N     IO_L11N_T1U_N9_GC_28
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[1]]                     ; ## H16  FMC_HPC1_LA11_P     IO_L21P_T3L_N4_AD8P_28
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[1]]                     ; ## H17  FMC_HPC1_LA11_N     IO_L21N_T3L_N5_AD8N_28
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[2]]                     ; ## G15  FMC_HPC1_LA12_P     IO_L7P_T1L_N0_QBC_AD13P_28
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[2]]                     ; ## G16  FMC_HPC1_LA12_N     IO_L7N_T1L_N1_QBC_AD13N_28
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[3]]                     ; ## D17  FMC_HPC1_LA13_P     IO_L15P_T2L_N4_AD11P_28
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[3]]                     ; ## D18  FMC_HPC1_LA13_N     IO_L15N_T2L_N5_AD11N_28
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[4]]                     ; ## C18  FMC_HPC1_LA14_P     IO_L9P_T1L_N4_AD12P_28
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[4]]                     ; ## C19  FMC_HPC1_LA14_N     IO_L9N_T1L_N5_AD12N_28
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS} [get_ports tx_data_out_1_p[5]]                     ; ## H19  FMC_HPC1_LA15_P     IO_L19P_T3L_N0_DBC_AD9P_28
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVDS} [get_ports tx_data_out_1_n[5]]                     ; ## H20  FMC_HPC1_LA15_N     IO_L19N_T3L_N1_DBC_AD9N_28

set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS18} [get_ports enable_1]                           ; ## G18  FMC_HPC1_LA16_P     IO_L20P_T3L_N2_AD1P_28
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS18} [get_ports txnrx_1]                            ; ## G19  FMC_HPC1_LA16_N     IO_L20N_T3L_N3_AD1N_28


