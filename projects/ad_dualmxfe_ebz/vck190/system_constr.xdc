###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# dual mxfe/vck190 fmcp1

# adf4377

set_property -dict {PACKAGE_PIN BA16 IOSTANDARD LVCMOS15} [get_ports adf4377_ce]            ; ## H23  FMC1_LA19_N           IO_L7N_N2P3_M2P69_707
set_property -dict {PACKAGE_PIN BA17 IOSTANDARD LVCMOS15} [get_ports adf4377_csb]           ; ## H22  FMC1_LA19_P           IO_L7P_N2P2_M2P68_707
set_property -dict {PACKAGE_PIN BE16 IOSTANDARD LVCMOS15} [get_ports adf4377_enclk1]        ; ## G21  FMC1_LA20_P           IO_L8P_N2P4_M2P70_707
set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS15} [get_ports adf4377_enclk2]        ; ## H19  FMC1_LA15_P           IO_L15P_XCC_N5P0_M2P30_706
set_property -dict {PACKAGE_PIN BE22 IOSTANDARD LVCMOS15} [get_ports adf4377_sclk]          ; ## H17  FMC1_LA11_N           IO_L0N_XCC_N0P1_M2P1_706
set_property -dict {PACKAGE_PIN BF23 IOSTANDARD LVCMOS15} [get_ports adf4377_sdio]          ; ## H16  FMC1_LA11_P           IO_L0P_XCC_N0P0_M2P0_706
set_property -dict {PACKAGE_PIN AW24 IOSTANDARD LVCMOS15} [get_ports adf4377_sdo]           ; ## H7   FMC1_LA02_P           IO_L17P_N5P4_M2P34_706

set_property -dict {PACKAGE_PIN AU21 IOSTANDARD LVCMOS15} [get_ports fan_pwm]               ; ## H10  FMC1_LA04_P           IO_L16P_N5P2_M2P32_706
set_property -dict {PACKAGE_PIN AV21 IOSTANDARD LVCMOS15} [get_ports fmc_fan_tach]          ; ## H11  FMC1_LA04_N           IO_L16N_N5P3_M2P33_706

# fpga clocks

set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVDS15} [get_ports fpga_clk0_p]             ; ## D4   FMC1_GBTCLK0_M2C_C_P  GTY_REFCLKP1_201
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVDS15} [get_ports fpga_clk0_n]             ; ## D5   FMC1_GBTCLK0_M2C_C_N  GTY_REFCLKN1_201

set_property -dict {PACKAGE_PIN K14  IOSTANDARD LVDS15} [get_ports fpga_clk1_n]             ; ## B21  FMC1_GBTCLK1_M2C_C_N  GTY_REFCLKN1_202
set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVDS15} [get_ports fpga_clk1_p]             ; ## B20  FMC1_GBTCLK1_M2C_C_P  GTY_REFCLKP1_202

set_property -dict {PACKAGE_PIN AW23 IOSTANDARD LVDS15} [get_ports fpga_clk2_n]             ; ## H5   FMC1_CLK0_M2C_N       IO_L12N_GC_XCC_N4P1_M2P25_706
set_property -dict {PACKAGE_PIN AV23 IOSTANDARD LVDS15} [get_ports fpga_clk2_p]             ; ## H4   FMC1_CLK0_M2C_P       IO_L12P_GC_XCC_N4P0_M2P24_706

set_property -dict {PACKAGE_PIN AP18 IOSTANDARD LVDS15} [get_ports fpga_clk3_n]             ; ## G3   FMC1_CLK1_M2C_N       IO_L12N_GC_XCC_N4P1_M2P79_707
set_property -dict {PACKAGE_PIN AP19 IOSTANDARD LVDS15} [get_ports fpga_clk3_p]             ; ## G2   FMC1_CLK1_M2C_P       IO_L12P_GC_XCC_N4P0_M2P78_707

set_property -dict {PACKAGE_PIN H14  IOSTANDARD LVDS15} [get_ports fpga_clk4_n]             ; ## L13  FMC1_GBTCLK2_M2C_C_N  GTY_REFCLKN1_203
set_property -dict {PACKAGE_PIN H15  IOSTANDARD LVDS15} [get_ports fpga_clk4_p]             ; ## L12  FMC1_GBTCLK2_M2C_C_P  GTY_REFCLKP1_203

# sysrefs

set_property -dict {PACKAGE_PIN BC23 IOSTANDARD LVDS15} [get_ports fpga_sysref0_p]          ; ## D8   FMC1_LA01_CC_P        IO_L9P_GC_XCC_N3P0_M2P18_706
set_property -dict {PACKAGE_PIN BD22 IOSTANDARD LVDS15} [get_ports fpga_sysref0_n]          ; ## D9   FMC1_LA01_CC_N        IO_L9N_GC_XCC_N3P1_M2P19_706
set_property -dict {PACKAGE_PIN BE17 IOSTANDARD LVDS15} [get_ports fpga_sysref1_p]          ; ## C22  FMC1_LA18_CC_P        IO_L9P_GC_XCC_N3P0_M2P72_707
set_property -dict {PACKAGE_PIN BD17 IOSTANDARD LVDS15} [get_ports fpga_sysref1_n]          ; ## C23  FMC1_LA18_CC_N        IO_L9N_GC_XCC_N3P1_M2P73_707

# hmc7044

set_property -dict {PACKAGE_PIN BG18 IOSTANDARD LVCMOS15} [get_ports hmc7044_miso]          ; ## G25  FMC1_LA22_N           IO_L4N_N1P3_M2P63_707
set_property -dict {PACKAGE_PIN AY25 IOSTANDARD LVCMOS15} [get_ports hmc7044_mosi]          ; ## H8   FMC1_LA02_N           IO_L17N_N5P5_M2P35_706
set_property -dict {PACKAGE_PIN BF17 IOSTANDARD LVCMOS15} [get_ports hmc7044_reset]         ; ## G22  FMC1_LA20_N           IO_L8N_N2P5_M2P71_707
set_property -dict {PACKAGE_PIN BF18 IOSTANDARD LVCMOS15} [get_ports hmc7044_sclk]          ; ## G24  FMC1_LA22_P           IO_L4P_N1P2_M2P62_707
set_property -dict {PACKAGE_PIN BF16 IOSTANDARD LVCMOS15} [get_ports hmc7044_slen]          ; ## G27  FMC1_LA25_P           IO_L10P_N3P2_M2P74_707

# interrupts

set_property -dict {PACKAGE_PIN BC25 IOSTANDARD LVCMOS15} [get_ports m0_irq]                ; ## H13  FMC1_LA07_P           IO_L11P_N3P4_M2P22_706
set_property -dict {PACKAGE_PIN BD25 IOSTANDARD LVCMOS15} [get_ports m1_irq]                ; ## H14  FMC1_LA07_N           IO_L11N_N3P5_M2P23_706

# mxfe0 signals

set_property -dict {PACKAGE_PIN BF19 IOSTANDARD LVCMOS15} [get_ports mxfe_reset[0]]         ; ## C26  FMC1_LA27_P           IO_L2P_N0P4_M2P58_707
set_property -dict {PACKAGE_PIN AV22 IOSTANDARD LVCMOS15} [get_ports mxfe_cs[0]]            ; ## G9   FMC1_LA03_P           IO_L14P_N4P4_M2P28_706
set_property -dict {PACKAGE_PIN AW21 IOSTANDARD LVCMOS15} [get_ports mxfe_miso[0]]          ; ## G10  FMC1_LA03_N           IO_L14N_N4P5_M2P29_706
set_property -dict {PACKAGE_PIN BC22 IOSTANDARD LVCMOS15} [get_ports mxfe_mosi[0]]          ; ## G12  FMC1_LA08_P           IO_L8P_N2P4_M2P16_706
set_property -dict {PACKAGE_PIN BB16 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen0[0]]         ; ## D20  FMC1_LA17_CC_P        IO_L6P_GC_XCC_N2P0_M2P66_707
set_property -dict {PACKAGE_PIN BC16 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen1[0]]         ; ## D21  FMC1_LA17_CC_N        IO_L6N_GC_XCC_N2P1_M2P67_707
set_property -dict {PACKAGE_PIN BC21 IOSTANDARD LVCMOS15} [get_ports mxfe_sclk[0]]          ; ## G13  FMC1_LA08_N           IO_L8N_N2P5_M2P17_706
set_property -dict {PACKAGE_PIN BC18 IOSTANDARD LVCMOS15} [get_ports mxfe_txen0[0]]         ; ## D26  FMC1_LA26_P           IO_L3P_XCC_N1P0_M2P60_707
set_property -dict {PACKAGE_PIN BD18 IOSTANDARD LVCMOS15} [get_ports mxfe_txen1[0]]         ; ## D27  FMC1_LA26_N           IO_L3N_XCC_N1P1_M2P61_707

# mxfe0 gpios

set_property -dict {PACKAGE_PIN AY23 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[0]]         ; ## H20  FMC1_LA15_N           IO_L15N_XCC_N5P1_M2P31_706
set_property -dict {PACKAGE_PIN BA20 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[1]]         ; ## H28  FMC1_LA24_P           IO_L5P_N1P4_M2P64_707
set_property -dict {PACKAGE_PIN BA19 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[2]]         ; ## H29  FMC1_LA24_N           IO_L5N_N1P5_M2P65_707
set_property -dict {PACKAGE_PIN BB18 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[3]]         ; ## H31  FMC1_LA28_P           IO_L11P_N3P4_M2P76_707
set_property -dict {PACKAGE_PIN BC17 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[4]]         ; ## H32  FMC1_LA28_N           IO_L11N_N3P5_M2P77_707
set_property -dict {PACKAGE_PIN AT20 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[5]]         ; ## H34  FMC1_LA30_P           IO_L15P_XCC_N5P0_M2P84_707
set_property -dict {PACKAGE_PIN AR20 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[6]]         ; ## H35  FMC1_LA30_N           IO_L15N_XCC_N5P1_M2P85_707
set_property -dict {PACKAGE_PIN AN20 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[7]]         ; ## H37  FMC1_LA32_P           IO_L17P_N5P4_M2P88_707
set_property -dict {PACKAGE_PIN AN19 IOSTANDARD LVCMOS15} [get_ports mxfe0_gpio[8]]         ; ## H38  FMC1_LA32_N           IO_L17N_N5P5_M2P89_707

# mxfe1 signals

set_property -dict {PACKAGE_PIN BG19 IOSTANDARD LVCMOS15} [get_ports mxfe_reset[1]]         ; ## C27  FMC1_LA27_N           IO_L2N_N0P5_M2P59_707
set_property -dict {PACKAGE_PIN BG21 IOSTANDARD LVCMOS15} [get_ports mxfe_cs[1]]            ; ## G15  FMC1_LA12_P           IO_L3P_XCC_N1P0_M2P6_706
set_property -dict {PACKAGE_PIN BF22 IOSTANDARD LVCMOS15} [get_ports mxfe_miso[1]]          ; ## G16  FMC1_LA12_N           IO_L3N_XCC_N1P1_M2P7_706
set_property -dict {PACKAGE_PIN BF21 IOSTANDARD LVCMOS15} [get_ports mxfe_mosi[1]]          ; ## G18  FMC1_LA16_P           IO_L2P_N0P4_M2P4_706
set_property -dict {PACKAGE_PIN BB20 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen0[1]]         ; ## D23  FMC1_LA23_P           IO_L1P_N0P2_M2P56_707
set_property -dict {PACKAGE_PIN BB19 IOSTANDARD LVCMOS15} [get_ports mxfe_rxen1[1]]         ; ## D24  FMC1_LA23_N           IO_L1N_N0P3_M2P57_707
set_property -dict {PACKAGE_PIN BG20 IOSTANDARD LVCMOS15} [get_ports mxfe_sclk[1]]          ; ## G19  FMC1_LA16_N           IO_L2N_N0P5_M2P5_706
set_property -dict {PACKAGE_PIN BD23 IOSTANDARD LVCMOS15} [get_ports mxfe_txen0[1]]         ; ## G6   FMC1_LA00_CC_P        IO_L6P_GC_XCC_N2P0_M2P12_706
set_property -dict {PACKAGE_PIN BD24 IOSTANDARD LVCMOS15} [get_ports mxfe_txen1[1]]         ; ## G7   FMC1_LA00_CC_N        IO_L6N_GC_XCC_N2P1_M2P13_706

# mxfe1 gpios

set_property -dict {PACKAGE_PIN BG16 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[0]]         ; ## G28  FMC1_LA25_N           IO_L10N_N3P3_M2P75_707
set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[1]]         ; ## G30  FMC1_LA29_P           IO_L13P_N4P2_M2P80_707
set_property -dict {PACKAGE_PIN AM20 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[2]]         ; ## G31  FMC1_LA29_N           IO_L13N_N4P3_M2P81_707
set_property -dict {PACKAGE_PIN AR18 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[3]]         ; ## G33  FMC1_LA31_P           IO_L14P_N4P4_M2P82_707
set_property -dict {PACKAGE_PIN AT19 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[4]]         ; ## G34  FMC1_LA31_N           IO_L14N_N4P5_M2P83_707
set_property -dict {PACKAGE_PIN AU20 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[5]]         ; ## G36  FMC1_LA33_P           IO_L16P_N5P2_M2P86_707
set_property -dict {PACKAGE_PIN AU19 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[6]]         ; ## G37  FMC1_LA33_N           IO_L16N_N5P3_M2P87_707
set_property -dict {PACKAGE_PIN BE19 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[7]]         ; ## H25  FMC1_LA21_P           IO_L0P_XCC_N0P0_M2P54_707
set_property -dict {PACKAGE_PIN BD19 IOSTANDARD LVCMOS15} [get_ports mxfe1_gpio[8]]         ; ## H26  FMC1_LA21_N           IO_L0N_XCC_N0P1_M2P55_707

# mxfe0_sync signals

set_property -dict {PACKAGE_PIN BC20 IOSTANDARD LVDS15} [get_ports mxfe0_syncin_p_0]        ; ## C10  FMC1_LA06_P           IO_L10P_N3P2_M2P20_706
set_property -dict {PACKAGE_PIN BD20 IOSTANDARD LVDS15} [get_ports mxfe0_syncin_n_0]        ; ## C11  FMC1_LA06_N           IO_L10N_N3P3_M2P21_706
set_property -dict {PACKAGE_PIN AU24 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe0_syncin_p_1]  ; ## C18  FMC1_LA14_P           IO_L13P_N4P2_M2P26_706

set_property -dict {PACKAGE_PIN BF24 IOSTANDARD LVDS15} [get_ports mxfe0_syncout_p_0]       ; ## D11  FMC1_LA05_P           IO_L5P_N1P4_M2P10_706
set_property -dict {PACKAGE_PIN BG23 IOSTANDARD LVDS15} [get_ports mxfe0_syncout_n_0]       ; ## D12  FMC1_LA05_N           IO_L5N_N1P5_M2P11_706
set_property -dict {PACKAGE_PIN BE21 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe0_syncout_p_1] ; ## D17  FMC1_LA13_P           IO_L4P_N1P2_M2P8_706

# mxfe1_sync signals

set_property -dict {PACKAGE_PIN BG25 IOSTANDARD LVDS15} [get_ports mxfe1_syncin_p_0]        ; ## C14  FMC1_LA10_P           IO_L1P_N0P2_M2P2_706
set_property -dict {PACKAGE_PIN BG24 IOSTANDARD LVDS15} [get_ports mxfe1_syncin_n_1]        ; ## C15  FMC1_LA10_N           IO_L1N_N0P3_M2P3_706
set_property -dict {PACKAGE_PIN AU23 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe1_syncin_p_1]  ; ## C19  FMC1_LA14_N           IO_L13N_N4P3_M2P27_706

set_property -dict {PACKAGE_PIN BE25 IOSTANDARD LVDS15} [get_ports mxfe1_syncout_p_0]       ; ## D14  FMC1_LA09_P           IO_L7P_N2P2_M2P14_706
set_property -dict {PACKAGE_PIN BE24 IOSTANDARD LVDS15} [get_ports mxfe1_syncout_n_1]       ; ## D15  FMC1_LA09_N           IO_L7N_N2P3_M2P15_706
set_property -dict {PACKAGE_PIN BE20 IOSTANDARD LVCMOS15} [get_ports fmc_mxfe1_syncout_p_1] ; ## D18  FMC1_LA13_N           IO_L4N_N1P3_M2P9_706

# serdes0

set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[0]]        ; ## A22  FMC1_DP1_C2M_P        GTY_TXP1_201
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[1]]        ; ## B24  FMC1_DP9_C2M_P        GTY_TXP1_203
set_property -dict {PACKAGE_PIN Y7   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[2]]        ; ## A26  FMC1_DP2_C2M_P        GTY_TXP2_201
set_property -dict {PACKAGE_PIN W9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[3]]        ; ## A30  FMC1_DP3_C2M_P        GTY_TXP3_201
set_property -dict {PACKAGE_PIN AB7  IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[4]]        ; ## C2   FMC1_DP0_C2M_P        GTY_TXP0_201
set_property -dict {PACKAGE_PIN P7   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[5]]        ; ## B28  FMC1_DP8_C2M_P        GTY_TXP0_203
set_property -dict {PACKAGE_PIN L9   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[6]]        ; ## Y26  FMC1_DP11_C2M_P       GTY_TXP3_203
set_property -dict {PACKAGE_PIN M7   IOSTANDARD LVDS15} [get_ports serdes0_c2m_p[7]]        ; ## Z24  FMC1_DP10_C2M_P       GTY_TXP2_203

set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[0]]        ; ## A23  FMC1_DP1_C2M_N        GTY_TXN1_201
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[1]]        ; ## B25  FMC1_DP9_C2M_N        GTY_TXN1_203
set_property -dict {PACKAGE_PIN Y6   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[2]]        ; ## A27  FMC1_DP2_C2M_N        GTY_TXN2_201
set_property -dict {PACKAGE_PIN W8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[3]]        ; ## A31  FMC1_DP3_C2M_N        GTY_TXN3_201
set_property -dict {PACKAGE_PIN AB6  IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[4]]        ; ## C3   FMC1_DP0_C2M_N        GTY_TXN0_201
set_property -dict {PACKAGE_PIN P6   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[5]]        ; ## B29  FMC1_DP8_C2M_N        GTY_TXN0_203
set_property -dict {PACKAGE_PIN L8   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[6]]        ; ## Y27  FMC1_DP11_C2M_N       GTY_TXN3_203
set_property -dict {PACKAGE_PIN M6   IOSTANDARD LVDS15} [get_ports serdes0_c2m_n[7]]        ; ## Z25  FMC1_DP10_C2M_N       GTY_TXN2_203

set_property -dict {PACKAGE_PIN AA4  IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[0]]        ; ## A2   FMC1_DP1_M2C_P        GTY_RXP1_201
set_property -dict {PACKAGE_PIN AB2  IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[1]]        ; ## C6   FMC1_DP0_M2C_P        GTY_RXP0_201
set_property -dict {PACKAGE_PIN P2   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[2]]        ; ## B8   FMC1_DP8_M2C_P        GTY_RXP0_203
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[3]]        ; ## A10  FMC1_DP3_M2C_P        GTY_RXP3_201
set_property -dict {PACKAGE_PIN L4   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[4]]        ; ## Z12  FMC1_DP11_M2C_P       GTY_RXP3_203
set_property -dict {PACKAGE_PIN M2   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[5]]        ; ## Y10  FMC1_DP10_M2C_P       GTY_RXP2_203
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[6]]        ; ## A6   FMC1_DP2_M2C_P        GTY_RXP2_201
set_property -dict {PACKAGE_PIN N4   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_p[7]]        ; ## B4   FMC1_DP9_M2C_P        GTY_RXP1_203

set_property -dict {PACKAGE_PIN AA3  IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[0]]        ; ## A3   FMC1_DP1_M2C_N        GTY_RXN1_201
set_property -dict {PACKAGE_PIN AB1  IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[1]]        ; ## C7   FMC1_DP0_M2C_N        GTY_RXN0_201
set_property -dict {PACKAGE_PIN P1   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[2]]        ; ## B9   FMC1_DP8_M2C_N        GTY_RXN0_203
set_property -dict {PACKAGE_PIN W3   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[3]]        ; ## A11  FMC1_DP3_M2C_N        GTY_RXN3_201
set_property -dict {PACKAGE_PIN L3   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[4]]        ; ## Z13  FMC1_DP11_M2C_N       GTY_RXN3_203
set_property -dict {PACKAGE_PIN M1   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[5]]        ; ## Y11  FMC1_DP10_M2C_N       GTY_RXN2_203
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[6]]        ; ## A7   FMC1_DP2_M2C_N        GTY_RXN2_201
set_property -dict {PACKAGE_PIN N3   IOSTANDARD LVDS15 DIFF_TERM TRUE} [get_ports serdes0_m2c_n[7]]        ; ## B5   FMC1_DP9_M2C_N        GTY_RXN1_203

# serdes1

set_property -dict {PACKAGE_PIN V7   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[2]]        ; ## A34  FMC1_DP4_C2M_P        GTY_TXP0_202
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[3]]        ; ## A38  FMC1_DP5_C2M_P        GTY_TXP1_202
set_property -dict {PACKAGE_PIN T7   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[5]]        ; ## B36  FMC1_DP6_C2M_P        GTY_TXP2_202
set_property -dict {PACKAGE_PIN R9   IOSTANDARD LVDS15} [get_ports serdes1_c2m_p[6]]        ; ## B32  FMC1_DP7_C2M_P        GTY_TXP3_202

set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[2]]        ; ## A35  FMC1_DP4_C2M_N        GTY_TXN0_202
set_property -dict {PACKAGE_PIN U8   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[3]]        ; ## A39  FMC1_DP5_C2M_N        GTY_TXN1_202
set_property -dict {PACKAGE_PIN T6   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[5]]        ; ## B37  FMC1_DP6_C2M_N        GTY_TXN2_202
set_property -dict {PACKAGE_PIN R8   IOSTANDARD LVDS15} [get_ports serdes1_c2m_n[6]]        ; ## B33  FMC1_DP7_C2M_N        GTY_TXN3_202

set_property -dict {PACKAGE_PIN R4   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[0]]        ; ## B12  FMC1_DP7_M2C_P        GTY_RXP3_202
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[1]]        ; ## A14  FMC1_DP4_M2C_P        GTY_RXP0_202
set_property -dict {PACKAGE_PIN T2   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[2]]        ; ## B16  FMC1_DP6_M2C_P        GTY_RXP2_202
set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVDS15} [get_ports serdes1_m2c_p[3]]        ; ## A18  FMC1_DP5_M2C_P        GTY_RXP1_202

set_property -dict {PACKAGE_PIN R3   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[0]]        ; ## B13  FMC1_DP7_M2C_N        GTY_RXN3_202
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[1]]        ; ## A15  FMC1_DP4_M2C_N        GTY_RXN0_202
set_property -dict {PACKAGE_PIN T1   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[2]]        ; ## B17  FMC1_DP6_M2C_N        GTY_RXN2_202
set_property -dict {PACKAGE_PIN U3   IOSTANDARD LVDS15} [get_ports serdes1_m2c_n[3]]        ; ## A19  FMC1_DP5_M2C_N        GTY_RXN1_202
