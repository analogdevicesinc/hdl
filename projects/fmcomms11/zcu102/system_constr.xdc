###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# fmcomms11

set_property -dict {PACKAGE_PIN L8  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports usr_clk_p]       ; ## B20  FMC0_GBTCLK1_M2C_C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN L7  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports usr_clk_n]       ; ## B21  FMC0_GBTCLK1_M2C_C_N  MGTREFCLK0N_228
set_property -dict {PACKAGE_PIN G8}  [get_ports trx_ref_clk_p]                                  ; ## D4   FMC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7}  [get_ports trx_ref_clk_n]                                  ; ## D5   FMC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229

set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVDS} [get_ports rx_sync_p]                      ; ## H7   FMC0_LA02_P           IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVDS} [get_ports rx_sync_n]                      ; ## H8   FMC0_LA02_N           IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN Y2  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_p]       ; ## G9   FMC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN Y1  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports tx_sync_n]       ; ## G10  FMC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66

set_property -dict {PACKAGE_PIN H2}  [get_ports rx_data_p[0]]                                   ; ## C6   FMC0_DP0_M2C_P        MGTHRXP2_229
set_property -dict {PACKAGE_PIN H1}  [get_ports rx_data_n[0]]                                   ; ## C7   FMC0_DP0_M2C_N        MGTHRXN2_229
set_property -dict {PACKAGE_PIN J4}  [get_ports rx_data_p[1]]                                   ; ## A2   FMC0_DP1_M2C_P        MGTHRXP1_229
set_property -dict {PACKAGE_PIN J3}  [get_ports rx_data_n[1]]                                   ; ## A3   FMC0_DP1_M2C_N        MGTHRXN1_229
set_property -dict {PACKAGE_PIN F2}  [get_ports rx_data_p[2]]                                   ; ## A6   FMC0_DP2_M2C_P        MGTHRXP3_229
set_property -dict {PACKAGE_PIN F1}  [get_ports rx_data_n[2]]                                   ; ## A7   FMC0_DP2_M2C_N        MGTHRXN3_229
set_property -dict {PACKAGE_PIN K2}  [get_ports rx_data_p[3]]                                   ; ## A10  FMC0_DP3_M2C_P        MGTHRXP0_229
set_property -dict {PACKAGE_PIN K1}  [get_ports rx_data_n[3]]                                   ; ## A11  FMC0_DP3_M2C_N        MGTHRXN0_229
set_property -dict {PACKAGE_PIN L4}  [get_ports rx_data_p[4]]                                   ; ## A14  FMC0_DP4_M2C_P        MGTHRXP3_228
set_property -dict {PACKAGE_PIN L3}  [get_ports rx_data_n[4]]                                   ; ## A15  FMC0_DP4_M2C_N        MGTHRXN3_228
set_property -dict {PACKAGE_PIN P2}  [get_ports rx_data_p[5]]                                   ; ## A18  FMC0_DP5_M2C_P        MGTHRXP1_228
set_property -dict {PACKAGE_PIN P1}  [get_ports rx_data_n[5]]                                   ; ## A19  FMC0_DP5_M2C_N        MGTHRXN1_228
set_property -dict {PACKAGE_PIN T2}  [get_ports rx_data_p[6]]                                   ; ## B16  FMC0_DP6_M2C_P        MGTHRXP0_228
set_property -dict {PACKAGE_PIN T1}  [get_ports rx_data_n[6]]                                   ; ## B17  FMC0_DP6_M2C_N        MGTHRXN0_228
set_property -dict {PACKAGE_PIN M2}  [get_ports rx_data_p[7]]                                   ; ## B12  FMC0_DP7_M2C_P        MGTHRXP2_228
set_property -dict {PACKAGE_PIN M1}  [get_ports rx_data_n[7]]                                   ; ## B13  FMC0_DP7_M2C_N        MGTHRXN2_228
set_property -dict {PACKAGE_PIN G4}  [get_ports tx_data_p[0]]                                   ; ## C2   FMC0_DP0_C2M_P        MGTHTXP2_229
set_property -dict {PACKAGE_PIN G3}  [get_ports tx_data_n[0]]                                   ; ## C3   FMC0_DP0_C2M_N        MGTHTXN2_229
set_property -dict {PACKAGE_PIN H6}  [get_ports tx_data_p[1]]                                   ; ## A22  FMC0_DP1_C2M_P        MGTHTXP1_229
set_property -dict {PACKAGE_PIN H5}  [get_ports tx_data_n[1]]                                   ; ## A23  FMC0_DP1_C2M_N        MGTHTXN1_229
set_property -dict {PACKAGE_PIN F6}  [get_ports tx_data_p[2]]                                   ; ## A26  FMC0_DP2_C2M_P        MGTHTXP3_229
set_property -dict {PACKAGE_PIN F5}  [get_ports tx_data_n[2]]                                   ; ## A27  FMC0_DP2_C2M_N        MGTHTXN3_229
set_property -dict {PACKAGE_PIN K6}  [get_ports tx_data_p[3]]                                   ; ## A30  FMC0_DP3_C2M_P        MGTHTXP0_229
set_property -dict {PACKAGE_PIN K5}  [get_ports tx_data_n[3]]                                   ; ## A31  FMC0_DP3_C2M_N        MGTHTXN0_229
set_property -dict {PACKAGE_PIN M6}  [get_ports tx_data_p[4]]                                   ; ## A34  FMC0_DP4_C2M_P        MGTHTXP3_228
set_property -dict {PACKAGE_PIN M5}  [get_ports tx_data_n[4]]                                   ; ## A35  FMC0_DP4_C2M_N        MGTHTXN3_228
set_property -dict {PACKAGE_PIN P6}  [get_ports tx_data_p[5]]                                   ; ## A38  FMC0_DP5_C2M_P        MGTHTXP1_228
set_property -dict {PACKAGE_PIN P5}  [get_ports tx_data_n[5]]                                   ; ## A39  FMC0_DP5_C2M_N        MGTHTXN1_228
set_property -dict {PACKAGE_PIN R4}  [get_ports tx_data_p[6]]                                   ; ## B36  FMC0_DP6_C2M_P        MGTHTXP0_228
set_property -dict {PACKAGE_PIN R3}  [get_ports tx_data_n[6]]                                   ; ## B37  FMC0_DP6_C2M_N        MGTHTXN0_228
set_property -dict {PACKAGE_PIN N4}  [get_ports tx_data_p[7]]                                   ; ## B32  FMC0_DP7_C2M_P        MGTHTXP2_228
set_property -dict {PACKAGE_PIN N3}  [get_ports tx_data_n[7]]                                   ; ## B33  FMC0_DP7_C2M_N        MGTHTXN2_228

set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS18} [get_ports adf4355_muxout]             ; ## D14  FMC0_LA09_P           IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN W1  IOSTANDARD LVCMOS18} [get_ports ad9625_irq]                 ; ## D15  FMC0_LA09_N           IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS18} [get_ports ad9162_txen]                ; ## G13  FMC0_LA08_N           IO_L17N_T2U_N9_AD10N_66
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports ad9162_irq]                 ; ## H16  FMC0_LA11_P           IO_L10P_T1U_N6_QBC_AD4P_66

set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9162]             ; ## G12  FMC0_LA08_P           IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVCMOS18} [get_ports spi_csn_hmc1119]            ; ## G15  FMC0_LA12_P           IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS18} [get_ports spi_csn_adf4355]            ; ## G16  FMC0_LA12_N           IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports spi_csn_adl5240]            ; ## C10  FMC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9625]             ; ## C11  FMC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9508]             ; ## H14  FMC0_LA07_N           IO_L18N_T2U_N11_AD2N_66
set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS18} [get_ports spi_dir]                    ; ## H13  FMC0_LA07_P           IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS18} [get_ports spi_clk]                    ; ## C14  FMC0_LA10_P           IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVCMOS18} [get_ports spi_sdio]                   ; ## C15  FMC0_LA10_N           IO_L15N_T2L_N5_AD11N_66


# clocks

create_clock -name rx_ref_clk   -period  8 [get_ports trx_ref_clk_p]
create_clock -name tx_div_clk   -period  4 [get_pins i_system_wrapper/system_i/util_fmcomms11_xcvr/inst/i_xch_0/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  8 [get_pins i_system_wrapper/system_i/util_fmcomms11_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]
