###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

############################################################################
# AD9173
############################################################################
set_property -dict {PACKAGE_PIN P6}   [get_ports dac_data_p[0]]                                                  ; ## A38  FMC0_DP5_C2M_P        MGTHTXP1_228
set_property -dict {PACKAGE_PIN P5}   [get_ports dac_data_n[0]]                                                  ; ## A39  FMC0_DP5_C2M_N        MGTHTXN1_228
set_property -dict {PACKAGE_PIN R4}   [get_ports dac_data_p[1]]                                                  ; ## B36  FMC0_DP6_C2M_P        MGTHTXP0_228
set_property -dict {PACKAGE_PIN R3}   [get_ports dac_data_n[1]]                                                  ; ## B37  FMC0_DP6_C2M_N        MGTHTXN0_228
set_property -dict {PACKAGE_PIN M6}   [get_ports dac_data_p[2]]                                                  ; ## A34  FMC0_DP4_C2M_P        MGTHTXP3_228
set_property -dict {PACKAGE_PIN M5}   [get_ports dac_data_n[2]]                                                  ; ## A35  FMC0_DP4_C2M_N        MGTHTXN3_228
set_property -dict {PACKAGE_PIN N4}   [get_ports dac_data_p[3]]                                                  ; ## B32  FMC0_DP7_C2M_P        MGTHTXP2_228
set_property -dict {PACKAGE_PIN N3}   [get_ports dac_data_n[3]]                                                  ; ## B33  FMC0_DP7_C2M_N        MGTHTXN2_228

# Ref clock
set_property -dict {PACKAGE_PIN L8}   [get_ports br40_ext_p]                                                     ; ## B20  FMC0_GBTCLK1_M2C_C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN L7}   [get_ports br40_ext_n]                                                     ; ## B21  FMC0_GBTCLK1_M2C_C_N  MGTREFCLK0N_228

set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVDS} [get_ports sync0_n]                                        ; ## G33  FMC0_LA31_P           IO_L7P_T1L_N0_QBC_AD13P_67
set_property -dict {PACKAGE_PIN V7   IOSTANDARD LVDS} [get_ports sync0_p]                                        ; ## G34  FMC0_LA31_N           IO_L7N_T1L_N1_QBC_AD13N_67
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVDS} [get_ports sync1_n]                                        ; ## G36  FMC0_LA33_P           IO_L5P_T0U_N8_AD14P_67
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVDS} [get_ports sync1_p]                                        ; ## G37  FMC0_LA33_N           IO_L5N_T0U_N9_AD14N_67

set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVDS} [get_ports sysrefdac_p]                                    ; ## H4   FMC0_CLK0_M2C_P       IO_L12P_T1U_N10_GC_66
set_property -dict {PACKAGE_PIN AA6  IOSTANDARD LVDS} [get_ports sysrefdac_n]                                    ; ## H5   FMC0_CLK0_M2C_N       IO_L12N_T1U_N11_GC_66

############################################################################
# AD9083
############################################################################
set_property -dict {PACKAGE_PIN H2}   [get_ports rx_data_p[0]]                                                   ; ## C6   FMC0_DP0_M2C_P        MGTHRXP2_229
set_property -dict {PACKAGE_PIN H1}   [get_ports rx_data_n[0]]                                                   ; ## C7   FMC0_DP0_M2C_N        MGTHRXN2_229
set_property -dict {PACKAGE_PIN J4}   [get_ports rx_data_p[1]]                                                   ; ## A2   FMC0_DP1_M2C_P        MGTHRXP1_229
set_property -dict {PACKAGE_PIN J3}   [get_ports rx_data_n[1]]                                                   ; ## A3   FMC0_DP1_M2C_N        MGTHRXN1_229
set_property -dict {PACKAGE_PIN F2}   [get_ports rx_data_p[2]]                                                   ; ## A6   FMC0_DP2_M2C_P        MGTHRXP3_229
set_property -dict {PACKAGE_PIN F1}   [get_ports rx_data_n[2]]                                                   ; ## A7   FMC0_DP2_M2C_N        MGTHRXN3_229
set_property -dict {PACKAGE_PIN K2}   [get_ports rx_data_p[3]]                                                   ; ## A10  FMC0_DP3_M2C_P        MGTHRXP0_229
set_property -dict {PACKAGE_PIN K1}   [get_ports rx_data_n[3]]                                                   ; ## A11  FMC0_DP3_M2C_N        MGTHRXN0_229

set_property -dict {PACKAGE_PIN V4   IOSTANDARD LVDS} [get_ports sysrefadc_p]                                    ; ## G12  FMC0_LA08_P           IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVDS} [get_ports sysrefadc_n]                                    ; ## G13  FMC0_LA08_N           IO_L17N_T2U_N9_AD10N_66

set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVDS} [get_ports rx_sync_p]                                      ; ## H10  FMC0_LA04_P           IO_L21P_T3L_N4_AD8P_66
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVDS} [get_ports rx_sync_n]                                      ; ## H11  FMC0_LA04_N           IO_L21N_T3L_N5_AD8N_66

# Ref clock
set_property -dict {PACKAGE_PIN G8}   [get_ports ref_clk0_p]                                                     ; ## D4   FMC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7}   [get_ports ref_clk0_n]                                                     ; ## D5   FMC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229

# Device clock
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVDS} [get_ports glblclk_p]                                      ; ## G6   FMC0_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVDS} [get_ports glblclk_n]                                      ; ## G7   FMC0_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_66

############################################################################
# SPIs
############################################################################
set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn1]                           ; ## D26  FMC0_LA26_P           IO_L24P_T3U_N10_67
set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn2]                           ; ## D27  FMC0_LA26_N           IO_L24N_T3U_N11_67
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn3]                           ; ## C10  FMC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn4]                           ; ## C11  FMC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN W5   IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn5]                           ; ## C14  FMC0_LA10_P           IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn6]                           ; ## C15  FMC0_LA10_N           IO_L15N_T2L_N5_AD11N_66
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn7]                           ; ## C18  FMC0_LA14_P           IO_L7P_T1L_N0_QBC_AD13P_66
set_property -dict {PACKAGE_PIN AC6  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_csn8]                           ; ## C19  FMC0_LA14_N           IO_L7N_T1L_N1_QBC_AD13N_66
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_sck]                            ; ## D23  FMC0_LA23_P           IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS18} [get_ports spi_adl5960_sdio]                           ; ## D24  FMC0_LA23_N           IO_L19N_T3L_N1_DBC_AD9N_67

set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS18} [get_ports fpga_sdo]                                   ; ## C26  FMC0_LA27_P           IO_L15P_T2L_N4_AD11P_67
set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS18} [get_ports fpga_sck]                                   ; ## D8   FMC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVCMOS18} [get_ports fpga_sdio]                                  ; ## D9   FMC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVCMOS18} [get_ports fpga_csb]                                   ; ## H7   FMC0_LA02_P           IO_L23P_T3U_N8_66

set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS18} [get_ports ndac_sck]                                   ; ## C27  FMC0_LA27_N           IO_L15N_T2L_N5_AD11N_67
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports ndac_sdi]                                   ; ## G19  FMC0_LA16_N           IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN T7   IOSTANDARD LVCMOS18} [get_ports ndac_csb]                                   ; ## H31  FMC0_LA28_P           IO_L10P_T1U_N6_QBC_AD4P_67

set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18} [get_ports spim_csb_sig]                               ; ## D12  FMC0_LA05_N           IO_L20N_T3L_N3_AD1N_66
set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports spim_mosi]                                  ; ## D14  FMC0_LA09_P           IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports spim_sck]                                   ; ## D15  FMC0_LA09_N           IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports spim_miso]                                  ; ## D17  FMC0_LA13_P           IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN P11  IOSTANDARD LVCMOS18} [get_ports spim_csb_lo]                                ; ## D20  FMC0_LA17_CC_P        IO_L13P_T2L_N0_GC_QBC_67

set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18} [get_ports fpga_bus0_sdi]                              ; ## G15  FMC0_LA12_P           IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS18} [get_ports fpga_bus0_sdo]                              ; ## G16  FMC0_LA12_N           IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports fpga_bus0_sck]                              ; ## G18  FMC0_LA16_P           IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVCMOS18} [get_ports fpga_bus0_cs_9528]                          ; ## H14  FMC0_LA07_N           IO_L18N_T2U_N11_AD2N_66
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18} [get_ports fpga_bus0_cs_4372]                          ; ## G21  FMC0_LA20_P           IO_L22P_T3U_N6_DBC_AD0P_67

set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18} [get_ports fpga_bus1_sdi]                              ; ## G24  FMC0_LA22_P           IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS18} [get_ports fpga_bus1_sdo]                              ; ## G25  FMC0_LA22_N           IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18} [get_ports fpga_bus1_sck]                              ; ## G27  FMC0_LA25_P           IO_L17P_T2U_N8_AD10P_67
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18} [get_ports fpga_bus1_cs1]                              ; ## G28  FMC0_LA25_N           IO_L17N_T2U_N9_AD10N_67
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS18} [get_ports fpga_bus1_cs2]                              ; ## G30  FMC0_LA29_P           IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVCMOS18} [get_ports fpga_gpio_csb]                              ; ## G10  FMC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66

set_property -dict {PACKAGE_PIN AB6  IOSTANDARD LVCMOS18} [get_ports fmcdac_cs1]                                 ; ## H16  FMC0_LA11_P           IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS18} [get_ports fmcdac_mosi]                                ; ## H17  FMC0_LA11_N           IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports fmcdac_sck]                                 ; ## H19  FMC0_LA15_P           IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports fmcdac_miso]                                ; ## H20  FMC0_LA15_N           IO_L6N_T0U_N11_AD6N_66
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports adcmon_csb]                                 ; ## H22  FMC0_LA19_P           IO_L23P_T3U_N8_67

set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sfl]                              ; ## H23  FMC0_LA19_N           IO_L23N_T3U_N9_67
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_csb]                              ; ## H25  FMC0_LA21_P           IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sdo]                              ; ## H26  FMC0_LA21_N           IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sdi]                              ; ## H28  FMC0_LA24_P           IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18} [get_ports fpga_busf_sck]                              ; ## H29  FMC0_LA24_N           IO_L18N_T2U_N11_AD2N_67

set_property -dict {PACKAGE_PIN T6   IOSTANDARD LVCMOS18} [get_ports spiad_sdi]                                  ; ## H32  FMC0_LA28_N           IO_L10N_T1U_N7_QBC_AD4N_67
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS18} [get_ports spiad_sck]                                  ; ## H35  FMC0_LA30_N           IO_L8N_T1L_N3_AD5N_67
set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18} [get_ports spiad_sdo]                                  ; ## H37  FMC0_LA32_P           IO_L6P_T0U_N10_AD6P_67
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS18} [get_ports adccnv]                                     ; ## H34  FMC0_LA30_P           IO_L8P_T1L_N2_AD5P_67

############################################################################
# GPIOs
############################################################################
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18} [get_ports lmix_rstn]                                  ; ## D11  FMC0_LA05_P           IO_L20P_T3L_N2_AD1P_66
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports smix_rstn]                                  ; ## D18  FMC0_LA13_N           IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN N11  IOSTANDARD LVCMOS18} [get_ports adl5960x_sync1]                             ; ## D21  FMC0_LA17_CC_N        IO_L13N_T2L_N1_GC_QBC_67
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS18} [get_ports adcmon_rstn]                                ; ## G9   FMC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18 PULLUP TRUE} [get_ports seq_shdnn]                      ; ## G22  FMC0_LA20_N           IO_L22N_T3U_N7_DBC_AD0N_67
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS18} [get_ports pd]                                         ; ## H8   FMC0_LA02_N           IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports rstb]                                       ; ## H13  FMC0_LA07_P           IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18} [get_ports spare_gpiox]                                ; ## H38  FMC0_LA32_N           IO_L6N_T0U_N11_AD6N_67

# Fix xcvr location assignment
set_property LOC GTHE4_CHANNEL_X1Y10  [get_cells -hierarchical -filter {NAME =~ *util_ad9083_xcvr/inst/i_xch_0/i_gthe4_channel}]
