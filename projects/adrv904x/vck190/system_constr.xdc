###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#adrv904x

set_property -dict {PACKAGE_PIN M15}  [get_ports ref_clk0_p]                                                    ; ## D4   FMC1_GBTCLK0_M2C_C_P  GTY_REFCLKP1_201
set_property -dict {PACKAGE_PIN M14}  [get_ports ref_clk0_n]                                                    ; ## D5   FMC1_GBTCLK0_M2C_C_N  GTY_REFCLKN1_201
set_property -dict {PACKAGE_PIN K15}  [get_ports ref_clk1_p]                                                    ; ## B20  FMC1_GBTCLK1_M2C_C_P  GTY_REFCLKP1_202
set_property -dict {PACKAGE_PIN K14}  [get_ports ref_clk1_n]                                                    ; ## B21  FMC1_GBTCLK1_M2C_C_N  GTY_REFCLKN1_202

set_property -dict {PACKAGE_PIN AV23 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports core_clk_p]           ; ## H4   FMC1_CLK0_M2C_P       IO_L12P_GC_XCC_N4P0_M2P24_706
set_property -dict {PACKAGE_PIN AW23 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports core_clk_n]           ; ## H5   FMC1_CLK0_M2C_N       IO_L12N_GC_XCC_N4P1_M2P25_706

set_property -dict {PACKAGE_PIN AB2}  [get_ports rx_data_p[0]]                                                  ; ## C6   FMC1_DP0_M2C_P        GTY_RXP0_201
set_property -dict {PACKAGE_PIN AB1}  [get_ports rx_data_n[0]]                                                  ; ## C7   FMC1_DP0_M2C_N        GTY_RXN0_201
set_property -dict {PACKAGE_PIN AA4}  [get_ports rx_data_p[1]]                                                  ; ## A2   FMC1_DP1_M2C_P        GTY_RXP1_201
set_property -dict {PACKAGE_PIN AA3}  [get_ports rx_data_n[1]]                                                  ; ## A3   FMC1_DP1_M2C_N        GTY_RXN1_201
set_property -dict {PACKAGE_PIN Y2}   [get_ports rx_data_p[2]]                                                  ; ## A6   FMC1_DP2_M2C_P        GTY_RXP2_201
set_property -dict {PACKAGE_PIN Y1}   [get_ports rx_data_n[2]]                                                  ; ## A7   FMC1_DP2_M2C_N        GTY_RXN2_201
set_property -dict {PACKAGE_PIN W4}   [get_ports rx_data_p[3]]                                                  ; ## A10  FMC1_DP3_M2C_P        GTY_RXP3_201
set_property -dict {PACKAGE_PIN W3}   [get_ports rx_data_n[3]]                                                  ; ## A11  FMC1_DP3_M2C_N        GTY_RXN3_201
set_property -dict {PACKAGE_PIN V2}   [get_ports rx_data_p[4]]                                                  ; ## A14  FMC1_DP4_M2C_P        GTY_RXP0_202
set_property -dict {PACKAGE_PIN V1}   [get_ports rx_data_n[4]]                                                  ; ## A15  FMC1_DP4_M2C_N        GTY_RXN0_202
set_property -dict {PACKAGE_PIN U4}   [get_ports rx_data_p[5]]                                                  ; ## A18  FMC1_DP5_M2C_P        GTY_RXP1_202
set_property -dict {PACKAGE_PIN U3}   [get_ports rx_data_n[5]]                                                  ; ## A19  FMC1_DP5_M2C_N        GTY_RXN1_202
set_property -dict {PACKAGE_PIN T2}   [get_ports rx_data_p[6]]                                                  ; ## B16  FMC1_DP6_M2C_P        GTY_RXP2_202
set_property -dict {PACKAGE_PIN T1}   [get_ports rx_data_n[6]]                                                  ; ## B17  FMC1_DP6_M2C_N        GTY_RXN2_202
set_property -dict {PACKAGE_PIN R4}   [get_ports rx_data_p[7]]                                                  ; ## B12  FMC1_DP7_M2C_P        GTY_RXP3_202
set_property -dict {PACKAGE_PIN R3}   [get_ports rx_data_n[7]]                                                  ; ## B13  FMC1_DP7_M2C_N        GTY_RXN3_202

set_property -dict {PACKAGE_PIN AB7}  [get_ports tx_data_p[0]]                                                  ; ## C2   FMC1_DP0_C2M_P        GTY_TXP0_201
set_property -dict {PACKAGE_PIN AB6}  [get_ports tx_data_n[0]]                                                  ; ## C3   FMC1_DP0_C2M_N        GTY_TXN0_201
set_property -dict {PACKAGE_PIN AA9}  [get_ports tx_data_p[1]]                                                  ; ## A22  FMC1_DP1_C2M_P        GTY_TXP1_201
set_property -dict {PACKAGE_PIN AA8}  [get_ports tx_data_n[1]]                                                  ; ## A23  FMC1_DP1_C2M_N        GTY_TXN1_201
set_property -dict {PACKAGE_PIN Y7}   [get_ports tx_data_p[2]]                                                  ; ## A26  FMC1_DP2_C2M_P        GTY_TXP2_201
set_property -dict {PACKAGE_PIN Y6}   [get_ports tx_data_n[2]]                                                  ; ## A27  FMC1_DP2_C2M_N        GTY_TXN2_201
set_property -dict {PACKAGE_PIN W9}   [get_ports tx_data_p[3]]                                                  ; ## A30  FMC1_DP3_C2M_P        GTY_TXP3_201
set_property -dict {PACKAGE_PIN W8}   [get_ports tx_data_n[3]]                                                  ; ## A31  FMC1_DP3_C2M_N        GTY_TXN3_201
set_property -dict {PACKAGE_PIN V7}   [get_ports tx_data_p[4]]                                                  ; ## A34  FMC1_DP4_C2M_P        GTY_TXP0_202
set_property -dict {PACKAGE_PIN V6}   [get_ports tx_data_n[4]]                                                  ; ## A35  FMC1_DP4_C2M_N        GTY_TXN0_202
set_property -dict {PACKAGE_PIN U9}   [get_ports tx_data_p[5]]                                                  ; ## A38  FMC1_DP5_C2M_P        GTY_TXP1_202
set_property -dict {PACKAGE_PIN U8}   [get_ports tx_data_n[5]]                                                  ; ## A39  FMC1_DP5_C2M_N        GTY_TXN1_202
set_property -dict {PACKAGE_PIN T7}   [get_ports tx_data_p[6]]                                                  ; ## B36  FMC1_DP6_C2M_P        GTY_TXP2_202
set_property -dict {PACKAGE_PIN T6}   [get_ports tx_data_n[6]]                                                  ; ## B37  FMC1_DP6_C2M_N        GTY_TXN2_202
set_property -dict {PACKAGE_PIN R9}   [get_ports tx_data_p[7]]                                                  ; ## B32  FMC1_DP7_C2M_P        GTY_TXP3_202
set_property -dict {PACKAGE_PIN R8}   [get_ports tx_data_n[7]]                                                  ; ## B33  FMC1_DP7_C2M_N        GTY_TXN3_202

set_property -dict {PACKAGE_PIN AW24 IOSTANDARD LVDS15} [get_ports rx_sync_p]                                   ; ## H7   FMC1_LA02_P           IO_L17P_N5P4_M2P34_706
set_property -dict {PACKAGE_PIN AY25 IOSTANDARD LVDS15} [get_ports rx_sync_n]                                   ; ## H8   FMC1_LA02_N           IO_L17N_N5P5_M2P35_706
set_property -dict {PACKAGE_PIN AN20 IOSTANDARD LVDS15} [get_ports rx_sync_1_p]                                 ; ## H37  FMC1_LA32_P           IO_L17P_N5P4_M2P88_707
set_property -dict {PACKAGE_PIN AN19 IOSTANDARD LVDS15} [get_ports rx_sync_1_n]                                 ; ## H38  FMC1_LA32_N           IO_L17N_N5P5_M2P89_707
set_property -dict {PACKAGE_PIN AR18 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]            ; ## G33  FMC1_LA31_P           IO_L14P_N4P4_M2P82_707
set_property -dict {PACKAGE_PIN AT19 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]            ; ## G34  FMC1_LA31_N           IO_L14N_N4P5_M2P83_707
set_property -dict {PACKAGE_PIN BF16 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_p]          ; ## G27  FMC1_LA25_P           IO_L10P_N3P2_M2P74_707
set_property -dict {PACKAGE_PIN BG16 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_n]          ; ## G28  FMC1_LA25_N           IO_L10N_N3P3_M2P75_707
set_property -dict {PACKAGE_PIN AU20 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_2_p]          ; ## G36  FMC1_LA33_P           IO_L16P_N5P2_M2P86_707
set_property -dict {PACKAGE_PIN AU19 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports tx_sync_2_n]          ; ## G37  FMC1_LA33_N           IO_L16N_N5P3_M2P87_707

set_property -dict {PACKAGE_PIN BC23 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports sysref_p]             ; ## D8   FMC1_LA01_CC_P        IO_L9P_GC_XCC_N3P0_M2P18_706
set_property -dict {PACKAGE_PIN BD22 IOSTANDARD LVDS15 DIFF_TERM_ADV TERM_100} [get_ports sysref_n]             ; ## D9   FMC1_LA01_CC_N        IO_L9N_GC_XCC_N3P1_M2P19_706
set_property -dict {PACKAGE_PIN AV22 IOSTANDARD LVDS15} [get_ports sysref_out_p]                                ; ## G9   FMC1_LA03_P           IO_L14P_N4P4_M2P28_706
set_property -dict {PACKAGE_PIN AW21 IOSTANDARD LVDS15} [get_ports sysref_out_n]                                ; ## G10  FMC1_LA03_N           IO_L14N_N4P5_M2P29_706

set_property -dict {PACKAGE_PIN BG19 IOSTANDARD LVCMOS15} [get_ports ad9528_sysref_req]                         ; ## C27  FMC1_LA27_N           IO_L2N_N0P5_M2P59_707
set_property -dict {PACKAGE_PIN BF24 IOSTANDARD LVCMOS15} [get_ports adrv904x_test]                             ; ## D11  FMC1_LA05_P           IO_L5P_N1P4_M2P10_706

set_property -dict {PACKAGE_PIN BC20 IOSTANDARD LVCMOS15} [get_ports adrv904x_orx0_enable]                      ; ## C10  FMC1_LA06_P           IO_L10P_N3P2_M2P20_706
set_property -dict {PACKAGE_PIN BD20 IOSTANDARD LVCMOS15} [get_ports adrv904x_orx1_enable]                      ; ## C11  FMC1_LA06_N           IO_L10N_N3P3_M2P21_706
set_property -dict {PACKAGE_PIN BE21 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx0_enable]                      ; ## D17  FMC1_LA13_P           IO_L4P_N1P2_M2P8_706
set_property -dict {PACKAGE_PIN BE20 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx1_enable]                      ; ## D18  FMC1_LA13_N           IO_L4N_N1P3_M2P9_706
set_property -dict {PACKAGE_PIN BG25 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx2_enable]                      ; ## C14  FMC1_LA10_P           IO_L1P_N0P2_M2P2_706
set_property -dict {PACKAGE_PIN BG24 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx3_enable]                      ; ## C15  FMC1_LA10_N           IO_L1N_N0P3_M2P3_706
set_property -dict {PACKAGE_PIN BB20 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx4_enable]                      ; ## D23  FMC1_LA23_P           IO_L1P_N0P2_M2P56_707
set_property -dict {PACKAGE_PIN BB19 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx5_enable]                      ; ## D24  FMC1_LA23_N           IO_L1N_N0P3_M2P57_707
set_property -dict {PACKAGE_PIN AU24 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx6_enable]                      ; ## C18  FMC1_LA14_P           IO_L13P_N4P2_M2P26_706
set_property -dict {PACKAGE_PIN AU23 IOSTANDARD LVCMOS15} [get_ports adrv904x_trx7_enable]                      ; ## C19  FMC1_LA14_N           IO_L13N_N4P3_M2P27_706

set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[0]]                          ; ## H19  FMC1_LA15_P           IO_L15P_XCC_N5P0_M2P30_706
set_property -dict {PACKAGE_PIN AY23 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[1]]                          ; ## H20  FMC1_LA15_N           IO_L15N_XCC_N5P1_M2P31_706
set_property -dict {PACKAGE_PIN BF21 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[2]]                          ; ## G18  FMC1_LA16_P           IO_L2P_N0P4_M2P4_706
set_property -dict {PACKAGE_PIN BG20 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[3]]                          ; ## G19  FMC1_LA16_N           IO_L2N_N0P5_M2P5_706
set_property -dict {PACKAGE_PIN BE19 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[4]]                          ; ## H25  FMC1_LA21_P           IO_L0P_XCC_N0P0_M2P54_707
set_property -dict {PACKAGE_PIN BD19 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[5]]                          ; ## H26  FMC1_LA21_N           IO_L0N_XCC_N0P1_M2P55_707
set_property -dict {PACKAGE_PIN BE17 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[6]]                          ; ## C22  FMC1_LA18_CC_P        IO_L9P_GC_XCC_N3P0_M2P72_707
set_property -dict {PACKAGE_PIN BD17 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[7]]                          ; ## C23  FMC1_LA18_CC_N        IO_L9N_GC_XCC_N3P1_M2P73_707
set_property -dict {PACKAGE_PIN BA17 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[8]]                          ; ## H22  FMC1_LA19_P           IO_L7P_N2P2_M2P68_707
set_property -dict {PACKAGE_PIN BA16 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[9]]                          ; ## H23  FMC1_LA19_N           IO_L7N_N2P3_M2P69_707
set_property -dict {PACKAGE_PIN BF18 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[10]]                         ; ## G24  FMC1_LA22_P           IO_L4P_N1P2_M2P62_707
set_property -dict {PACKAGE_PIN BG18 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[11]]                         ; ## G25  FMC1_LA22_N           IO_L4N_N1P3_M2P63_707
set_property -dict {PACKAGE_PIN AU21 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[12]]                         ; ## H10  FMC1_LA04_P           IO_L16P_N5P2_M2P32_706
set_property -dict {PACKAGE_PIN AV21 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[13]]                         ; ## H11  FMC1_LA04_N           IO_L16N_N5P3_M2P33_706
set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[14]]                         ; ## G30  FMC1_LA29_P           IO_L13P_N4P2_M2P80_707
set_property -dict {PACKAGE_PIN AM20 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[15]]                         ; ## G31  FMC1_LA29_N           IO_L13N_N4P3_M2P81_707
set_property -dict {PACKAGE_PIN BG21 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[16]]                         ; ## G15  FMC1_LA12_P           IO_L3P_XCC_N1P0_M2P6_706
set_property -dict {PACKAGE_PIN BF22 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[17]]                         ; ## G16  FMC1_LA12_N           IO_L3N_XCC_N1P1_M2P7_706
set_property -dict {PACKAGE_PIN BG23 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[18]]                         ; ## D12  FMC1_LA05_N           IO_L5N_N1P5_M2P11_706
set_property -dict {PACKAGE_PIN BE16 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[19]]                         ; ## G21  FMC1_LA20_P           IO_L8P_N2P4_M2P70_707
set_property -dict {PACKAGE_PIN AT20 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[20]]                         ; ## H34  FMC1_LA30_P           IO_L15P_XCC_N5P0_M2P84_707
set_property -dict {PACKAGE_PIN AR20 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[21]]                         ; ## H35  FMC1_LA30_N           IO_L15N_XCC_N5P1_M2P85_707
set_property -dict {PACKAGE_PIN BA20 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[22]]                         ; ## H28  FMC1_LA24_P           IO_L5P_N1P4_M2P64_707
set_property -dict {PACKAGE_PIN BA19 IOSTANDARD LVCMOS15} [get_ports adrv904x_gpio[23]]                         ; ## H29  FMC1_LA24_N           IO_L5N_N1P5_M2P65_707

set_property -dict {PACKAGE_PIN BF19 IOSTANDARD LVCMOS15} [get_ports ad9528_reset_b]                            ; ## C26  FMC1_LA27_P           IO_L2P_N0P4_M2P58_707
set_property -dict {PACKAGE_PIN BF17 IOSTANDARD LVCMOS15} [get_ports adrv904x_reset_b]                          ; ## G22  FMC1_LA20_N           IO_L8N_N2P5_M2P71_707

set_property -dict {PACKAGE_PIN BE25 IOSTANDARD LVCMOS15} [get_ports spi_csn_adrv904x]                          ; ## D14  FMC1_LA09_P           IO_L7P_N2P2_M2P14_706
set_property -dict {PACKAGE_PIN BE24 IOSTANDARD LVCMOS15} [get_ports spi_csn_ad9528]                            ; ## D15  FMC1_LA09_N           IO_L7N_N2P3_M2P15_706
set_property -dict {PACKAGE_PIN BC25 IOSTANDARD LVCMOS15} [get_ports spi_clk]                                   ; ## H13  FMC1_LA07_P           IO_L11P_N3P4_M2P22_706
set_property -dict {PACKAGE_PIN BC22 IOSTANDARD LVCMOS15} [get_ports spi_miso]                                  ; ## G12  FMC1_LA08_P           IO_L8P_N2P4_M2P16_706
set_property -dict {PACKAGE_PIN BD25 IOSTANDARD LVCMOS15} [get_ports spi_mosi]                                  ; ## H14  FMC1_LA07_N           IO_L11N_N3P5_M2P23_706

# clocks

create_clock -period 4.069  -name device_clk [get_ports core_clk_p]
create_clock -period 4.069  -name ref_clk [get_ports ref_clk0_p]
