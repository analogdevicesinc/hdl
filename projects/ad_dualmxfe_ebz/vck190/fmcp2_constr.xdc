# dual mxfe/vck190 fmcp2

# adf4377

set_property -dict {PACKAGE_PIN AT13 IOSTANDARD LVCMOS15} [get_ports adf4377_ce]            ; ## H23  FMC2_LA19_N           IO_L18N_XCC_N6P1_M2P145_708
set_property -dict {PACKAGE_PIN AR14 IOSTANDARD LVCMOS15} [get_ports adf4377_csb]           ; ## H22  FMC2_LA19_P           IO_L18P_XCC_N6P0_M2P144_708
set_property -dict {PACKAGE_PIN AP15 IOSTANDARD LVCMOS15} [get_ports adf4377_enclk1]        ; ## G21  FMC2_LA20_P           IO_L19P_N6P2_M2P146_708
set_property -dict {PACKAGE_PIN AP11 IOSTANDARD LVCMOS15} [get_ports adf4377_enclk1]        ; ## G21  FMC2_LA22_P           IO_L20P_N6P4_M2P148_708
set_property -dict {PACKAGE_PIN BE12 IOSTANDARD LVCMOS15} [get_ports adf4377_enclk2]        ; ## H19  FMC2_LA15_P           IO_L3P_XCC_N1P0_M2P114_708
set_property -dict {PACKAGE_PIN BD12 IOSTANDARD LVCMOS15} [get_ports adf4377_sclk]          ; ## H17  FMC2_LA11_N           IO_L8N_N2P5_M2P125_708
set_property -dict {PACKAGE_PIN BC12 IOSTANDARD LVCMOS15} [get_ports adf4377_sdio]          ; ## H16  FMC2_LA11_P           IO_L8P_N2P4_M2P124_708
set_property -dict {PACKAGE_PIN BF14 IOSTANDARD LVDS15} [get_ports adf4377_sdo]             ; ## H7   FMC2_LA02_P           IO_L0P_XCC_N0P0_M2P108_708

set_property -dict {PACKAGE_PIN BF11 IOSTANDARD LVCMOS15} [get_ports fan_pwm]               ; ## H10  FMC2_LA04_P           IO_L4P_N1P2_M2P116_708
set_property -dict {PACKAGE_PIN BG11 IOSTANDARD LVCMOS15} [get_ports fmc_fan_tach]          ; ## H11  FMC2_LA04_N           IO_L4N_N1P3_M2P117_708

# fpga clocks

set_property -dict {PACKAGE_PIN F14  IOSTANDARD LVDS15} [get_ports fpga_clk0_n]             ; ## D5   FMC2_GBTCLK0_M2C_C_N  GTY_REFCLKN1_204
set_property -dict {PACKAGE_PIN F15  IOSTANDARD LVDS15} [get_ports fpga_clk0_p]             ; ## D4   FMC2_GBTCLK0_M2C_C_P  GTY_REFCLKP1_204
set_property -dict {PACKAGE_PIN D14  IOSTANDARD LVDS15} [get_ports fpga_clk1_n]             ; ## B21  FMC2_GBTCLK1_M2C_C_N  GTY_REFCLKN1_205
set_property -dict {PACKAGE_PIN D15  IOSTANDARD LVDS15} [get_ports fpga_clk1_p]             ; ## B20  FMC2_GBTCLK1_M2C_C_P  GTY_REFCLKP1_205
set_property -dict {PACKAGE_PIN BB13 IOSTANDARD LVDS15} [get_ports fpga_clk2_n]             ; ## H5   FMC2_CLK0_M2C_N       IO_L6N_GC_XCC_N2P1_M2P121_708
set_property -dict {PACKAGE_PIN BB14 IOSTANDARD LVDS15} [get_ports fpga_clk2_p]             ; ## H4   FMC2_CLK0_M2C_P       IO_L6P_GC_XCC_N2P0_M2P120_708
set_property -dict {PACKAGE_PIN AY18 IOSTANDARD LVDS15} [get_ports fpga_clk3_n]             ; ## G3   FMC2_CLK1_M2C_N       IO_L24N_GC_XCC_N8P1_M2P103_707
set_property -dict {PACKAGE_PIN AW19 IOSTANDARD LVDS15} [get_ports fpga_clk3_p]             ; ## G2   FMC2_CLK1_M2C_P       IO_L24P_GC_XCC_N8P0_M2P102_707
set_property -dict {PACKAGE_PIN B14  IOSTANDARD LVDS15} [get_ports fpga_clk4_n]             ; ## L13  FMC2_GBTCLK2_M2C_C_N  GTY_REFCLKN1_206
set_property -dict {PACKAGE_PIN B15  IOSTANDARD LVDS15} [get_ports fpga_clk4_p]             ; ## L12  FMC2_GBTCLK2_M2C_C_P  GTY_REFCLKP1_206

# sysrefs

set_property -dict {PACKAGE_PIN AW13 IOSTANDARD LVDS15} [get_ports fpga_sysref0_n]          ; ## D9   FMC2_LA01_CC_N        IO_L15N_XCC_N5P1_M2P139_708
set_property -dict {PACKAGE_PIN AW12 IOSTANDARD LVDS15} [get_ports fpga_sysref0_p]          ; ## D8   FMC2_LA01_CC_P        IO_L15P_XCC_N5P0_M2P138_708
set_property -dict {PACKAGE_PIN AV13 IOSTANDARD LVDS15} [get_ports fpga_sysref1_n]          ; ## C23  FMC2_LA18_CC_N        IO_L12N_GC_XCC_N4P1_M2P133_708
set_property -dict {PACKAGE_PIN AU13 IOSTANDARD LVDS15} [get_ports fpga_sysref1_p]          ; ## C22  FMC2_LA18_CC_P        IO_L12P_GC_XCC_N4P0_M2P132_708

# gpios



# hmc7044

set_property -dict {PACKAGE_PIN BG13 IOSTANDARD LVCMOS15} [get_ports hmc7044_mosi]          ; ## H8   FMC2_LA02_N           IO_L0N_XCC_N0P1_M2P109_708
set_property -dict {PACKAGE_PIN AR15 IOSTANDARD LVCMOS15} [get_ports hmc7044_reset]         ; ## G22  FMC2_LA20_N           IO_L19N_N6P3_M2P147_708
set_property -dict {PACKAGE_PIN AR12 IOSTANDARD LVCMOS15} [get_ports hmc7044_reset]         ; ## G22  FMC2_LA22_N           IO_L20N_N6P5_M2P149_708
set_property -dict {PACKAGE_PIN AY11 IOSTANDARD LVCMOS15} [get_ports hmc7044_slen]          ; ## G27  FMC2_LA25_P           IO_L26P_N8P4_M2P160_708

# interrupts

set_property -dict {PACKAGE_PIN BG15 IOSTANDARD LVCMOS15} [get_ports m0_irq]                ; ## H13  FMC2_LA07_P           IO_L5P_N1P4_M2P118_708
set_property -dict {PACKAGE_PIN BG14 IOSTANDARD LVCMOS15} [get_ports m1_irq]                ; ## H14  FMC2_LA07_N           IO_L5N_N1P5_M2P119_708


# mxfe0 signals

set_property -dict {PACKAGE_PIN AW20 IOSTANDARD LVCMOS15} [get_ports mxfe_reset[0]]         ; ## C26  FMC2_LA27_P           IO_L25P_N8P2_M2P104_707
set_property -dict {PACKAGE_PIN BE11 IOSTANDARD LVCMOS15} [get_ports mxfe_cs[0]]            ; ## G9   FMC2_LA03_P           IO_L2P_N0P4_M2P112_708
set_property -dict {PACKAGE_PIN BF12 IOSTANDARD LVCMOS15} [get_ports mxfe_miso[0]]          ; ## G10  FMC2_LA03_N           IO_L2N_N0P5_M2P113_708
set_property -dict {PACKAGE_PIN AV15 IOSTANDARD LVCMOS15} [get_ports mxfe_mosi[0]]          ; ## G12  FMC2_LA08_P           IO_L17P_N5P4_M2P142_708
set_property -dict {PACKAGE_PIN AY13 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen0[0]]         ; ## D20  FMC2_LA17_CC_P        IO_L24P_GC_XCC_N8P0_M2P156_708
set_property -dict {PACKAGE_PIN BA12 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen1[0]]         ; ## D21  FMC2_LA17_CC_N        IO_L24N_GC_XCC_N8P1_M2P157_708
set_property -dict {PACKAGE_PIN AV14 IOSTANDARD LVCMOS15} [get_ports mxfe_sclk[0]]          ; ## G13  FMC2_LA08_N           IO_L17N_N5P5_M2P143_708
set_property -dict {PACKAGE_PIN AV19 IOSTANDARD LVCMOS15} [get_ports mxfe_txen0[0]]         ; ## D26  FMC2_LA26_P           IO_L26P_N8P4_M2P106_707
set_property -dict {PACKAGE_PIN AV18 IOSTANDARD LVCMOS15} [get_ports mxfe_txen1[0]]         ; ## D27  FMC2_LA26_N           IO_L26N_N8P5_M2P107_707

# mxfe0 gpios

set_property -dict {PACKAGE_PIN BF13 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[0]]         ; ## H20  FMC2_LA15_N           IO_L3N_XCC_N1P1_M2P115_708
set_property -dict {PACKAGE_PIN AR11 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[1]]         ; ## H28  FMC2_LA24_P           IO_L22P_N7P2_M2P152_708
set_property -dict {PACKAGE_PIN AT11 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[2]]         ; ## H29  FMC2_LA24_N           IO_L22N_N7P3_M2P153_708
set_property -dict {PACKAGE_PIN AU17 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[3]]         ; ## H31  FMC2_LA28_P           IO_L20P_N6P4_M2P94_707
set_property -dict {PACKAGE_PIN AV17 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[4]]         ; ## H32  FMC2_LA28_N           IO_L20N_N6P5_M2P95_707
set_property -dict {PACKAGE_PIN AN16 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[5]]         ; ## H34  FMC2_LA30_P           IO_L21P_XCC_N7P0_M2P96_707
set_property -dict {PACKAGE_PIN AP16 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[6]]         ; ## H35  FMC2_LA30_N           IO_L21N_XCC_N7P1_M2P97_707
set_property -dict {PACKAGE_PIN AL16 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[7]]         ; ## H37  FMC2_LA32_P           IO_L23P_N7P4_M2P100_707
set_property -dict {PACKAGE_PIN AM17 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[8]]         ; ## H38  FMC2_LA32_N           IO_L23N_N7P5_M2P101_707

# mxfe1 signals

set_property -dict {PACKAGE_PIN AY19 IOSTANDARD LVCMOS15} [get_ports mxfe_reset[1]]         ; ## C27  FMC2_LA27_N           IO_L25N_N8P3_M2P105_707
set_property -dict {PACKAGE_PIN BB11 IOSTANDARD LVCMOS15} [get_ports mxfe_cs[1]]            ; ## G15  FMC2_LA12_P           IO_L10P_N3P2_M2P128_708
set_property -dict {PACKAGE_PIN BC11 IOSTANDARD LVCMOS15} [get_ports mxfe_miso[1]]          ; ## G16  FMC2_LA12_N           IO_L10N_N3P3_M2P129_708
set_property -dict {PACKAGE_PIN AV11 IOSTANDARD LVCMOS15} [get_ports mxfe_mosi[1]]          ; ## G18  FMC2_LA16_P           IO_L16P_N5P2_M2P140_708
set_property -dict {PACKAGE_PIN AP12 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen0[1]]         ; ## D23  FMC2_LA23_P           IO_L21P_XCC_N7P0_M2P150_708
set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen1[1]]         ; ## D24  FMC2_LA23_N           IO_L21N_XCC_N7P1_M2P151_708
set_property -dict {PACKAGE_PIN AW11 IOSTANDARD LVCMOS15} [get_ports mxfe_sclk[1]]          ; ## G19  FMC2_LA16_N           IO_L16N_N5P3_M2P141_708
set_property -dict {PACKAGE_PIN BC13 IOSTANDARD LVCMOS15} [get_ports mxfe_txen0[1]]         ; ## G6   FMC2_LA00_CC_P        IO_L9P_GC_XCC_N3P0_M2P126_708
set_property -dict {PACKAGE_PIN BD13 IOSTANDARD LVCMOS15} [get_ports mxfe_txen1[1]]         ; ## G7   FMC2_LA00_CC_N        IO_L9N_GC_XCC_N3P1_M2P127_708

# mxfe1 gpios

set_property -dict {PACKAGE_PIN BA11 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[0]]         ; ## G28  FMC2_LA25_N           IO_L26N_N8P5_M2P161_708
set_property -dict {PACKAGE_PIN AM18 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[1]]         ; ## G30  FMC2_LA29_P           IO_L19P_N6P2_M2P92_707
set_property -dict {PACKAGE_PIN AN17 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[2]]         ; ## G31  FMC2_LA29_N           IO_L19N_N6P3_M2P93_707
set_property -dict {PACKAGE_PIN AT16 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[3]]         ; ## G33  FMC2_LA31_P           IO_L18P_XCC_N6P0_M2P90_707
set_property -dict {PACKAGE_PIN AR17 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[4]]         ; ## G34  FMC2_LA31_N           IO_L18N_XCC_N6P1_M2P91_707
set_property -dict {PACKAGE_PIN AT17 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[5]]         ; ## G36  FMC2_LA33_P           IO_L22P_N7P2_M2P98_707
set_property -dict {PACKAGE_PIN AU16 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[6]]         ; ## G37  FMC2_LA33_N           IO_L22N_N7P3_M2P99_707
set_property -dict {PACKAGE_PIN AN14 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[7]]         ; ## H25  FMC2_LA21_P           IO_L23P_N7P4_M2P154_708
set_property -dict {PACKAGE_PIN AP13 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[8]]         ; ## H26  FMC2_LA21_N           IO_L23N_N7P5_M2P155_708

# mxfe0_sync signals

set_property -dict {PACKAGE_PIN AU12 IOSTANDARD LVDS15} [get_ports mxfe0_syncin_p_0]        ; ## C10  FMC2_LA06_P           IO_L14P_N4P4_M2P136_708
set_property -dict {PACKAGE_PIN AU11 IOSTANDARD LVDS15} [get_ports mxfe0_syncin_n_0]        ; ## C11  FMC2_LA06_N           IO_L14N_N4P5_M2P137_708
set_property -dict {PACKAGE_PIN BE15 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe0_syncin_p_1]  ; ## C18  FMC2_LA14_P           IO_L1P_N0P2_M2P110_708

set_property -dict {PACKAGE_PIN AY14 IOSTANDARD LVDS15} [get_ports mxfe0_syncout_p_0]       ; ## D11  FMC2_LA05_P           IO_L25P_N8P2_M2P158_708
set_property -dict {PACKAGE_PIN BA13 IOSTANDARD LVDS15} [get_ports mxfe0_syncout_n_0]       ; ## D12  FMC2_LA05_N           IO_L25N_N8P3_M2P159_708
set_property -dict {PACKAGE_PIN BB15 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe0_syncout_p_1] ; ## D17  FMC2_LA13_P           IO_L7P_N2P2_M2P122_708

# mxfe1_sync signals

set_property -dict {PACKAGE_PIN AT14 IOSTANDARD LVDS15} [get_ports mxfe1_syncin_p_0]        ; ## C14  FMC2_LA10_P           IO_L13P_N4P2_M2P134_708
set_property -dict {PACKAGE_PIN AU15 IOSTANDARD LVDS15} [get_ports mxfe1_syncin_n_1]        ; ## C15  FMC2_LA10_N           IO_L13N_N4P3_M2P135_708
set_property -dict {PACKAGE_PIN BE14 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe1_syncin_p_1]  ; ## C19  FMC2_LA14_N           IO_L1N_N0P3_M2P111_708

set_property -dict {PACKAGE_PIN BD15 IOSTANDARD LVDS15} [get_ports mxfe1_syncout_p_0]       ; ## D14  FMC2_LA09_P           IO_L11P_N3P4_M2P130_708
set_property -dict {PACKAGE_PIN BD14 IOSTANDARD LVDS15} [get_ports mxfe1_syncout_n_1]       ; ## D15  FMC2_LA09_N           IO_L11N_N3P5_M2P131_708
set_property -dict {PACKAGE_PIN BC15 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe1_syncout_p_1] ; ## D18  FMC2_LA13_N           IO_L7N_N2P3_M2P123_708

# serdes0

set_property -dict {PACKAGE_PIN K11  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[0]]        ; ## A22  FMC2_DP1_C2M_P        GTY_TXP1_204
set_property -dict {PACKAGE_PIN B11  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[1]]        ; ## B24  FMC2_DP9_C2M_P        GTY_TXP1_206
set_property -dict {PACKAGE_PIN J9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[2]]        ; ## A26  FMC2_DP2_C2M_P        GTY_TXP2_204
set_property -dict {PACKAGE_PIN H11  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[3]]        ; ## A30  FMC2_DP3_C2M_P        GTY_TXP3_204
set_property -dict {PACKAGE_PIN K7   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[4]]        ; ## C2   FMC2_DP0_C2M_P        GTY_TXP0_204
set_property -dict {PACKAGE_PIN C9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[5]]        ; ## B28  FMC2_DP8_C2M_P        GTY_TXP0_206
set_property -dict {PACKAGE_PIN A13  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[6]]        ; ## Y26  FMC2_DP11_C2M_P       GTY_TXP3_206
set_property -dict {PACKAGE_PIN A9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[7]]        ; ## Z24  FMC2_DP10_C2M_P       GTY_TXP2_206

set_property -dict {PACKAGE_PIN K10  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[0]]        ; ## A23  FMC2_DP1_C2M_N        GTY_TXN1_204
set_property -dict {PACKAGE_PIN B10  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[1]]        ; ## B25  FMC2_DP9_C2M_N        GTY_TXN1_206
set_property -dict {PACKAGE_PIN J8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[2]]        ; ## A27  FMC2_DP2_C2M_N        GTY_TXN2_204
set_property -dict {PACKAGE_PIN H10  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[3]]        ; ## A31  FMC2_DP3_C2M_N        GTY_TXN3_204
set_property -dict {PACKAGE_PIN K6   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[4]]        ; ## C3   FMC2_DP0_C2M_N        GTY_TXN0_204
set_property -dict {PACKAGE_PIN C8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[5]]        ; ## B29  FMC2_DP8_C2M_N        GTY_TXN0_206
set_property -dict {PACKAGE_PIN A12  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[6]]        ; ## Y27  FMC2_DP11_C2M_N       GTY_TXN3_206
set_property -dict {PACKAGE_PIN A8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[7]]        ; ## Z25  FMC2_DP10_C2M_N       GTY_TXN2_206

set_property -dict {PACKAGE_PIN J4   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[0]]        ; ## A2   FMC2_DP1_M2C_P        GTY_RXP1_204
set_property -dict {PACKAGE_PIN K2   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[1]]        ; ## C6   FMC2_DP0_M2C_P        GTY_RXP0_204
set_property -dict {PACKAGE_PIN D2   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[2]]        ; ## B8   FMC2_DP8_M2C_P        GTY_RXP0_206
set_property -dict {PACKAGE_PIN H6   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[3]]        ; ## A10  FMC2_DP3_M2C_P        GTY_RXP3_204
set_property -dict {PACKAGE_PIN B6   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[4]]        ; ## Z12  FMC2_DP11_M2C_P       GTY_RXP3_206
set_property -dict {PACKAGE_PIN C4   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[5]]        ; ## Y10  FMC2_DP10_M2C_P       GTY_RXP2_206
set_property -dict {PACKAGE_PIN H2   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[6]]        ; ## A6   FMC2_DP2_M2C_P        GTY_RXP2_204
set_property -dict {PACKAGE_PIN D6   IOSTANDARD LVDS15} [get_ports serdes0_m2c_p[7]]        ; ## B4   FMC2_DP9_M2C_P        GTY_RXP1_206

set_property -dict {PACKAGE_PIN J3   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[0]]        ; ## A3   FMC2_DP1_M2C_N        GTY_RXN1_204
set_property -dict {PACKAGE_PIN K1   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[1]]        ; ## C7   FMC2_DP0_M2C_N        GTY_RXN0_204
set_property -dict {PACKAGE_PIN D1   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[2]]        ; ## B9   FMC2_DP8_M2C_N        GTY_RXN0_206
set_property -dict {PACKAGE_PIN H5   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[3]]        ; ## A11  FMC2_DP3_M2C_N        GTY_RXN3_204
set_property -dict {PACKAGE_PIN B5   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[4]]        ; ## Z13  FMC2_DP11_M2C_N       GTY_RXN3_206
set_property -dict {PACKAGE_PIN C3   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[5]]        ; ## Y11  FMC2_DP10_M2C_N       GTY_RXN2_206
set_property -dict {PACKAGE_PIN H1   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[6]]        ; ## A7   FMC2_DP2_M2C_N        GTY_RXN2_204
set_property -dict {PACKAGE_PIN D5   IOSTANDARD LVDS15} [get_ports serdes0_m2c_n[7]]        ; ## B5   FMC2_DP9_M2C_N        GTY_RXN1_206

# serdes1

set_property -dict {PACKAGE_PIN G9   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[2]]        ; ## A34  FMC2_DP4_C2M_P        GTY_TXP0_205
set_property -dict {PACKAGE_PIN F11  IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[3]]        ; ## A38  FMC2_DP5_C2M_P        GTY_TXP1_205
set_property -dict {PACKAGE_PIN E9   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[5]]        ; ## B36  FMC2_DP6_C2M_P        GTY_TXP2_205
set_property -dict {PACKAGE_PIN D11  IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[6]]        ; ## B32  FMC2_DP7_C2M_P        GTY_TXP3_205

set_property -dict {PACKAGE_PIN G8   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[2]]        ; ## A35  FMC2_DP4_C2M_N        GTY_TXN0_205
set_property -dict {PACKAGE_PIN F10  IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[3]]        ; ## A39  FMC2_DP5_C2M_N        GTY_TXN1_205
set_property -dict {PACKAGE_PIN E8   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[5]]        ; ## B37  FMC2_DP6_C2M_N        GTY_TXN2_205
set_property -dict {PACKAGE_PIN D10  IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[6]]        ; ## B33  FMC2_DP7_C2M_N        GTY_TXN3_205

set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[0]]        ; ## B12  FMC2_DP7_M2C_P        GTY_RXP3_205
set_property -dict {PACKAGE_PIN G4   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[1]]        ; ## A14  FMC2_DP4_M2C_P        GTY_RXP0_205
set_property -dict {PACKAGE_PIN F6   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[2]]        ; ## B16  FMC2_DP6_M2C_P        GTY_RXP2_205
set_property -dict {PACKAGE_PIN F2   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[3]]        ; ## A18  FMC2_DP5_M2C_P        GTY_RXP1_205

set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[0]]        ; ## B13  FMC2_DP7_M2C_N        GTY_RXN3_205
set_property -dict {PACKAGE_PIN G3   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[1]]        ; ## A15  FMC2_DP4_M2C_N        GTY_RXN0_205
set_property -dict {PACKAGE_PIN F5   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[2]]        ; ## B17  FMC2_DP6_M2C_N        GTY_RXN2_205
set_property -dict {PACKAGE_PIN F1   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[3]]        ; ## A19  FMC2_DP5_M2C_N        GTY_RXN1_205

