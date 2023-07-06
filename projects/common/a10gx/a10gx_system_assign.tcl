###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# a10gx carrier defaults
# clocks and resets

set_location_assignment PIN_AR36  -to sys_clk
set_location_assignment PIN_AR37  -to "sys_clk(n)"
set_location_assignment PIN_BD27  -to sys_resetn
set_instance_assignment -name IO_STANDARD LVDS -to sys_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to sys_resetn
set_global_assignment -name PROGRAMMABLE_POWER_TECHNOLOGY_SETTING "FORCE ALL USED TILES TO HIGH SPEED"

# ddr3

set_location_assignment PIN_F34   -to ddr3_ref_clk
set_location_assignment PIN_F35   -to "ddr3_ref_clk(n)"

set_instance_assignment -name IO_STANDARD LVDS -to ddr3_ref_clk
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to ddr3_ref_clk -disable

set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_a[14]
set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_a[13]
set_instance_assignment -name IO_STANDARD "1.5 V" -to ddr3_a[12]

set_location_assignment PIN_R30   -to ddr3_clk_p      ; ## 1.5 V   V1  MEM_CLK_P
set_location_assignment PIN_R31   -to ddr3_clk_n      ; ## 1.5 V   V2  MEM_CLK_N
set_location_assignment PIN_M32   -to ddr3_a[0]       ; ## 1.5 V   F1  MEM_ADDR_CMD0
set_location_assignment PIN_L32   -to ddr3_a[1]       ; ## 1.5 V   H1  MEM_ADDR_CMD1
set_location_assignment PIN_N34   -to ddr3_a[2]       ; ## 1.5 V   F2  MEM_ADDR_CMD2
set_location_assignment PIN_M35   -to ddr3_a[3]       ; ## 1.5 V   G2  MEM_ADDR_CMD3
set_location_assignment PIN_L34   -to ddr3_a[4]       ; ## 1.5 V   H2  MEM_ADDR_CMD4
set_location_assignment PIN_K34   -to ddr3_a[5]       ; ## 1.5 V   J2  MEM_ADDR_CMD5
set_location_assignment PIN_M33   -to ddr3_a[6]       ; ## 1.5 V   K2  MEM_ADDR_CMD6
set_location_assignment PIN_L33   -to ddr3_a[7]       ; ## 1.5 V   G3  MEM_ADDR_CMD7
set_location_assignment PIN_J33   -to ddr3_a[8]       ; ## 1.5 V   J3  MEM_ADDR_CMD8
set_location_assignment PIN_J32   -to ddr3_a[9]       ; ## 1.5 V   L3  MEM_ADDR_CMD9
set_location_assignment PIN_H31   -to ddr3_a[10]      ; ## 1.5 V   E4  MEM_ADDR_CMD10
set_location_assignment PIN_J31   -to ddr3_a[11]      ; ## 1.5 V   F4  MEM_ADDR_CMD11
set_location_assignment PIN_H34   -to ddr3_a[12]      ; ## 1.5 V   G4  MEM_ADDR_CMD12
set_location_assignment PIN_H33   -to ddr3_a[13]      ; ## 1.5 V   H4  MEM_ADDR_CMD13
set_location_assignment PIN_G32   -to ddr3_a[14]      ; ## 1.5 V   J4  MEM_ADDR_CMD14
set_location_assignment PIN_F33   -to ddr3_ba[0]      ; ## 1.5 V   M1  MEM_ADDR_CMD16
set_location_assignment PIN_G35   -to ddr3_ba[1]      ; ## 1.5 V   M2  MEM_ADDR_CMD17
set_location_assignment PIN_H35   -to ddr3_ba[2]      ; ## 1.5 V   N2  MEM_ADDR_CMD18
set_location_assignment PIN_U33   -to ddr3_cke        ; ## 1.5 V   P5  MEM_ADDR_CMD20
set_location_assignment PIN_R34   -to ddr3_cs_n       ; ## 1.5 V   P1  MEM_ADDR_CMD22
set_location_assignment PIN_N33   -to ddr3_odt        ; ## 1.5 V   M4  MEM_ADDR_CMD24
set_location_assignment PIN_T35   -to ddr3_reset_n    ; ## 1.5 V   K1  MEM_ADDR_CMD27
set_location_assignment PIN_T34   -to ddr3_we_n       ; ## 1.5 V   P2  MEM_ADDR_CMD28
set_location_assignment PIN_F32   -to ddr3_ras_n      ; ## 1.5 V   L2  MEM_ADDR_CMD26
set_location_assignment PIN_G33   -to ddr3_cas_n      ; ## 1.5 V   L4  MEM_ADDR_CMD19
set_location_assignment PIN_B26   -to ddr3_dqs_p[0]   ; ## 1.5 V   A6  MEM_DQSA_P0
set_location_assignment PIN_C26   -to ddr3_dqs_n[0]   ; ## 1.5 V   A7  MEM_DQSA_N0
set_location_assignment PIN_H28   -to ddr3_dqs_p[1]   ; ## 1.5 V   A2  MEM_DQSA_P1
set_location_assignment PIN_J27   -to ddr3_dqs_n[1]   ; ## 1.5 V   A3  MEM_DQSA_N1
set_location_assignment PIN_C30   -to ddr3_dqs_p[2]   ; ## 1.5 V   A14 MEM_DQSA_P2
set_location_assignment PIN_C29   -to ddr3_dqs_n[2]   ; ## 1.5 V   A15 MEM_DQSA_N2
set_location_assignment PIN_L30   -to ddr3_dqs_p[3]   ; ## 1.5 V   F18 MEM_DQSA_P3
set_location_assignment PIN_L29   -to ddr3_dqs_n[3]   ; ## 1.5 V   G18 MEM_DQSA_N3
set_location_assignment PIN_Y32   -to ddr3_dqs_p[4]   ; ## 1.5 V   H18 MEM_DQSB_P0
set_location_assignment PIN_AA32  -to ddr3_dqs_n[4]   ; ## 1.5 V   J18 MEM_DQSB_N0
set_location_assignment PIN_AJ32  -to ddr3_dqs_p[5]   ; ## 1.5 V   U18 MEM_DQSB_P1
set_location_assignment PIN_AJ31  -to ddr3_dqs_n[5]   ; ## 1.5 V   V18 MEM_DQSB_N1
set_location_assignment PIN_AA34  -to ddr3_dqs_p[6]   ; ## 1.5 V   V16 MEM_DQSB_P2
set_location_assignment PIN_AA33  -to ddr3_dqs_n[6]   ; ## 1.5 V   V17 MEM_DQSB_N2
set_location_assignment PIN_AF33  -to ddr3_dqs_p[7]   ; ## 1.5 V   V8  MEM_DQSB_P3
set_location_assignment PIN_AF34  -to ddr3_dqs_n[7]   ; ## 1.5 V   V9  MEM_DQSB_N3
set_location_assignment PIN_B28   -to ddr3_dq[0]      ; ## 1.5 V   A4  MEM_DQA0
set_location_assignment PIN_A28   -to ddr3_dq[1]      ; ## 1.5 V   B4  MEM_DQA1
set_location_assignment PIN_A27   -to ddr3_dq[2]      ; ## 1.5 V   B5  MEM_DQA2
set_location_assignment PIN_B27   -to ddr3_dq[3]      ; ## 1.5 V   B6  MEM_DQA3
set_location_assignment PIN_D27   -to ddr3_dq[4]      ; ## 1.5 V   A8  MEM_DQA4
set_location_assignment PIN_E27   -to ddr3_dq[5]      ; ## 1.5 V   B8  MEM_DQA5
set_location_assignment PIN_D26   -to ddr3_dq[6]      ; ## 1.5 V   B9  MEM_DQA6
set_location_assignment PIN_D28   -to ddr3_dq[7]      ; ## 1.5 V   A10 MEM_DQA7
set_location_assignment PIN_G25   -to ddr3_dq[8]      ; ## 1.5 V   B1  MEM_DQA8
set_location_assignment PIN_H25   -to ddr3_dq[9]      ; ## 1.5 V   B2  MEM_DQA9
set_location_assignment PIN_G26   -to ddr3_dq[10]     ; ## 1.5 V   C2  MEM_DQA10
set_location_assignment PIN_H26   -to ddr3_dq[11]     ; ## 1.5 V   C3  MEM_DQA11
set_location_assignment PIN_G28   -to ddr3_dq[12]     ; ## 1.5 V   E3  MEM_DQA12
set_location_assignment PIN_F27   -to ddr3_dq[13]     ; ## 1.5 V   D4  MEM_DQA13
set_location_assignment PIN_K27   -to ddr3_dq[14]     ; ## 1.5 V   D1  MEM_DQA14
set_location_assignment PIN_F28   -to ddr3_dq[15]     ; ## 1.5 V   D2  MEM_DQA15
set_location_assignment PIN_D31   -to ddr3_dq[16]     ; ## 1.5 V   A12 MEM_DQA16
set_location_assignment PIN_E31   -to ddr3_dq[17]     ; ## 1.5 V   B12 MEM_DQA17
set_location_assignment PIN_B31   -to ddr3_dq[18]     ; ## 1.5 V   B13 MEM_DQA18
set_location_assignment PIN_C31   -to ddr3_dq[19]     ; ## 1.5 V   B14 MEM_DQA19
set_location_assignment PIN_A30   -to ddr3_dq[20]     ; ## 1.5 V   C15 MEM_DQA20
set_location_assignment PIN_E30   -to ddr3_dq[21]     ; ## 1.5 V   A16 MEM_DQA21
set_location_assignment PIN_B30   -to ddr3_dq[22]     ; ## 1.5 V   B16 MEM_DQA22
set_location_assignment PIN_D29   -to ddr3_dq[23]     ; ## 1.5 V   A18 MEM_DQA23
set_location_assignment PIN_K30   -to ddr3_dq[24]     ; ## 1.5 V   C16 MEM_DQA24
set_location_assignment PIN_H30   -to ddr3_dq[25]     ; ## 1.5 V   D16 MEM_DQA25
set_location_assignment PIN_G30   -to ddr3_dq[26]     ; ## 1.5 V   E16 MEM_DQA26
set_location_assignment PIN_K31   -to ddr3_dq[27]     ; ## 1.5 V   F16 MEM_DQA27
set_location_assignment PIN_H29   -to ddr3_dq[28]     ; ## 1.5 V   D17 MEM_DQA28
set_location_assignment PIN_K29   -to ddr3_dq[29]     ; ## 1.5 V   C18 MEM_DQA29
set_location_assignment PIN_J29   -to ddr3_dq[30]     ; ## 1.5 V   D18 MEM_DQA30
set_location_assignment PIN_F29   -to ddr3_dq[31]     ; ## 1.5 V   E18 MEM_DQA31
set_location_assignment PIN_AC31  -to ddr3_dq[32]     ; ## 1.5 V   H16 MEM_DQB0
set_location_assignment PIN_AB31  -to ddr3_dq[33]     ; ## 1.5 V   J16 MEM_DQB1
set_location_assignment PIN_W31   -to ddr3_dq[34]     ; ## 1.5 V   K16 MEM_DQB2
set_location_assignment PIN_Y31   -to ddr3_dq[35]     ; ## 1.5 V   L16 MEM_DQB3
set_location_assignment PIN_AD31  -to ddr3_dq[36]     ; ## 1.5 V   H17 MEM_DQB4
set_location_assignment PIN_AD32  -to ddr3_dq[37]     ; ## 1.5 V   K17 MEM_DQB5
set_location_assignment PIN_AD33  -to ddr3_dq[38]     ; ## 1.5 V   K18 MEM_DQB6
set_location_assignment PIN_AA30  -to ddr3_dq[39]     ; ## 1.5 V   L18 MEM_DQB7
set_location_assignment PIN_AE31  -to ddr3_dq[40]     ; ## 1.5 V   M17 MEM_DQB8
set_location_assignment PIN_AE32  -to ddr3_dq[41]     ; ## 1.5 V   N18 MEM_DQB9
set_location_assignment PIN_AE30  -to ddr3_dq[42]     ; ## 1.5 V   P17 MEM_DQB10
set_location_assignment PIN_AF30  -to ddr3_dq[43]     ; ## 1.5 V   P18 MEM_DQB11
set_location_assignment PIN_AG33  -to ddr3_dq[44]     ; ## 1.5 V   R18 MEM_DQB12
set_location_assignment PIN_AG32  -to ddr3_dq[45]     ; ## 1.5 V   T16 MEM_DQB13
set_location_assignment PIN_AH33  -to ddr3_dq[46]     ; ## 1.5 V   T17 MEM_DQB14
set_location_assignment PIN_AH31  -to ddr3_dq[47]     ; ## 1.5 V   T18 MEM_DQB15
set_location_assignment PIN_U31   -to ddr3_dq[48]     ; ## 1.5 V   U15 MEM_DQB16
set_location_assignment PIN_W33   -to ddr3_dq[49]     ; ## 1.5 V   T14 MEM_DQB17
set_location_assignment PIN_W32   -to ddr3_dq[50]     ; ## 1.5 V   U14 MEM_DQB18
set_location_assignment PIN_V31   -to ddr3_dq[51]     ; ## 1.5 V   V14 MEM_DQB19
set_location_assignment PIN_Y34   -to ddr3_dq[52]     ; ## 1.5 V   T13 MEM_DQB20
set_location_assignment PIN_W35   -to ddr3_dq[53]     ; ## 1.5 V   T12 MEM_DQB21
set_location_assignment PIN_W34   -to ddr3_dq[54]     ; ## 1.5 V   U12 MEM_DQB22
set_location_assignment PIN_V34   -to ddr3_dq[55]     ; ## 1.5 V   V12 MEM_DQB23
set_location_assignment PIN_AH35  -to ddr3_dq[56]     ; ## 1.5 V   T10 MEM_DQB24
set_location_assignment PIN_AJ34  -to ddr3_dq[57]     ; ## 1.5 V   U10 MEM_DQB25
set_location_assignment PIN_AJ33  -to ddr3_dq[58]     ; ## 1.5 V   V10 MEM_DQB26
set_location_assignment PIN_AH34  -to ddr3_dq[59]     ; ## 1.5 V   T9  MEM_DQB27
set_location_assignment PIN_AD35  -to ddr3_dq[60]     ; ## 1.5 V   T8  MEM_DQB28
set_location_assignment PIN_AE34  -to ddr3_dq[61]     ; ## 1.5 V   U8  MEM_DQB29
set_location_assignment PIN_AC33  -to ddr3_dq[62]     ; ## 1.5 V   U7  MEM_DQB30
set_location_assignment PIN_AD34  -to ddr3_dq[63]     ; ## 1.5 V   V6  MEM_DQB31
set_location_assignment PIN_E26   -to ddr3_dm[0]      ; ## 1.5 V   B10 MEM_DMA0
set_location_assignment PIN_G27   -to ddr3_dm[1]      ; ## 1.5 V   C4  MEM_DMA1
set_location_assignment PIN_A29   -to ddr3_dm[2]      ; ## 1.5 V   B17 MEM_DMA2
set_location_assignment PIN_F30   -to ddr3_dm[3]      ; ## 1.5 V   F17 MEM_DMA3
set_location_assignment PIN_AB32  -to ddr3_dm[4]      ; ## 1.5 V   M16 MEM_DMB0
set_location_assignment PIN_AG31  -to ddr3_dm[5]      ; ## 1.5 V   U16 MEM_DMB1
set_location_assignment PIN_Y35   -to ddr3_dm[6]      ; ## 1.5 V   U11 MEM_DMB2
set_location_assignment PIN_AC34  -to ddr3_dm[7]      ; ## 1.5 V   U6  MEM_DMB3
set_location_assignment PIN_J34   -to ddr3_rzq        ; ## RZQ

# ethernet interface

set_location_assignment PIN_BD24 -to eth_ref_clk
set_location_assignment PIN_BC24 -to "eth_ref_clk(n)"
set_location_assignment PIN_AV24 -to eth_rxd
set_location_assignment PIN_AW24 -to "eth_rxd(n)"
set_location_assignment PIN_BC23 -to eth_txd
set_location_assignment PIN_BD23 -to "eth_txd(n)"

set_instance_assignment -name IO_STANDARD LVDS -to eth_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to eth_rxd
set_instance_assignment -name IO_STANDARD LVDS -to eth_txd

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_ref_clk -disable
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to eth_rxd -disable

set_location_assignment PIN_AW23 -to eth_resetn
set_location_assignment PIN_AF13 -to eth_mdc
set_location_assignment PIN_AL18 -to eth_mdio
set_location_assignment PIN_AG13 -to eth_intn

set_instance_assignment -name IO_STANDARD "1.8 V" -to eth_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to eth_mdc
set_instance_assignment -name IO_STANDARD "1.8 V" -to eth_mdio
set_instance_assignment -name IO_STANDARD "1.8 V" -to eth_intn

# flash

set_location_assignment PIN_BB12 -to flash_addr[0]
set_location_assignment PIN_BB11 -to flash_addr[1]
set_instance_assignment -name VIRTUAL_PIN ON -to flash_addr[0]
set_instance_assignment -name VIRTUAL_PIN ON -to flash_addr[1]
set_location_assignment PIN_AM11 -to flash_addr[2]
set_location_assignment PIN_AM12 -to flash_addr[3]
set_location_assignment PIN_AL12 -to flash_addr[4]
set_location_assignment PIN_AN13 -to flash_addr[5]
set_location_assignment PIN_AM13 -to flash_addr[6]
set_location_assignment PIN_AE12 -to flash_addr[7]
set_location_assignment PIN_AN15 -to flash_addr[8]
set_location_assignment PIN_AL10 -to flash_addr[9]
set_location_assignment PIN_AR10 -to flash_addr[10]
set_location_assignment PIN_AP11 -to flash_addr[11]
set_location_assignment PIN_AL13 -to flash_addr[12]
set_location_assignment PIN_AH11 -to flash_addr[13]
set_location_assignment PIN_AN14 -to flash_addr[14]
set_location_assignment PIN_AG11 -to flash_addr[15]
set_location_assignment PIN_AH10 -to flash_addr[16]
set_location_assignment PIN_AF14 -to flash_addr[17]
set_location_assignment PIN_AF15 -to flash_addr[18]
set_location_assignment PIN_AH14 -to flash_addr[19]
set_location_assignment PIN_AJ12 -to flash_addr[20]
set_location_assignment PIN_AJ14 -to flash_addr[21]
set_location_assignment PIN_AH13 -to flash_addr[22]
set_location_assignment PIN_AG12 -to flash_addr[23]
set_location_assignment PIN_AJ13 -to flash_addr[24]
set_location_assignment PIN_AF12 -to flash_addr[25]
set_location_assignment PIN_AK14 -to flash_addr[26]
set_location_assignment PIN_AK11 -to flash_addr[27]
set_location_assignment PIN_BB20 -to flash_data[0]
set_location_assignment PIN_BA22 -to flash_data[1]
set_location_assignment PIN_AU25 -to flash_data[2]
set_location_assignment PIN_BD21 -to flash_data[3]
set_location_assignment PIN_AY25 -to flash_data[4]
set_location_assignment PIN_BD22 -to flash_data[5]
set_location_assignment PIN_AY24 -to flash_data[6]
set_location_assignment PIN_AV25 -to flash_data[7]
set_location_assignment PIN_BC21 -to flash_data[8]
set_location_assignment PIN_BB21 -to flash_data[9]
set_location_assignment PIN_BC20 -to flash_data[10]
set_location_assignment PIN_AW22 -to flash_data[11]
set_location_assignment PIN_AP26 -to flash_data[12]
set_location_assignment PIN_BA24 -to flash_data[13]
set_location_assignment PIN_BA25 -to flash_data[14]
set_location_assignment PIN_AR26 -to flash_data[15]
set_location_assignment PIN_AT25 -to flash_data[16]
set_location_assignment PIN_BA19 -to flash_data[17]
set_location_assignment PIN_BA20 -to flash_data[18]
set_location_assignment PIN_AP24 -to flash_data[19]
set_location_assignment PIN_AP23 -to flash_data[20]
set_location_assignment PIN_BA18 -to flash_data[21]
set_location_assignment PIN_AT24 -to flash_data[22]
set_location_assignment PIN_BD19 -to flash_data[23]
set_location_assignment PIN_AU23 -to flash_data[24]
set_location_assignment PIN_AR24 -to flash_data[25]
set_location_assignment PIN_AT23 -to flash_data[26]
set_location_assignment PIN_AR25 -to flash_data[27]
set_location_assignment PIN_AP22 -to flash_data[28]
set_location_assignment PIN_BC19 -to flash_data[29]
set_location_assignment PIN_AU22 -to flash_data[30]
set_location_assignment PIN_BA17 -to flash_data[31]
set_location_assignment PIN_BC25 -to flash_advn
set_location_assignment PIN_BB22 -to flash_cen[0]
set_location_assignment PIN_BB23 -to flash_cen[1]
set_location_assignment PIN_BB25 -to flash_clk
set_location_assignment PIN_BC26 -to flash_oen
set_location_assignment PIN_BA23 -to flash_resetn
set_location_assignment PIN_BD26 -to flash_wen

set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_oen
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_wen
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_advn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_cen
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[27]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[26]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_addr[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[31]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[30]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[29]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[28]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[27]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[26]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_data[0]

# leds

set_location_assignment PIN_L28   -to gpio_bd_o[0]  ; ## led-g0-d10
set_location_assignment PIN_K26   -to gpio_bd_o[1]  ; ## led-g1-d9
set_location_assignment PIN_K25   -to gpio_bd_o[2]  ; ## led-g2-d8
set_location_assignment PIN_L25   -to gpio_bd_o[3]  ; ## led-g3-d7
set_location_assignment PIN_J24   -to gpio_bd_o[4]  ; ## led-g4-d6
set_location_assignment PIN_A19   -to gpio_bd_o[5]  ; ## led-g5-d5
set_location_assignment PIN_C18   -to gpio_bd_o[6]  ; ## led-g6-d4
set_location_assignment PIN_D18   -to gpio_bd_o[7]  ; ## led-g7-d3
set_location_assignment PIN_L27   -to gpio_bd_o[8]  ; ## led-r0-d10
set_location_assignment PIN_J26   -to gpio_bd_o[9]  ; ## led-r1-d9
set_location_assignment PIN_K24   -to gpio_bd_o[10] ; ## led-r2-d8
set_location_assignment PIN_L23   -to gpio_bd_o[11] ; ## led-r3-d7
set_location_assignment PIN_B20   -to gpio_bd_o[12] ; ## led-r4-d6
set_location_assignment PIN_C19   -to gpio_bd_o[13] ; ## led-r5-d5
set_location_assignment PIN_D19   -to gpio_bd_o[14] ; ## led-r6-d4
set_location_assignment PIN_M23   -to gpio_bd_o[15] ; ## led-r7-d3
set_location_assignment PIN_A24   -to gpio_bd_i[0]  ; ## dipsw0
set_location_assignment PIN_B23   -to gpio_bd_i[1]  ; ## dipsw1
set_location_assignment PIN_A23   -to gpio_bd_i[2]  ; ## dipsw2
set_location_assignment PIN_B22   -to gpio_bd_i[3]  ; ## dipsw3
set_location_assignment PIN_A22   -to gpio_bd_i[4]  ; ## dipsw4
set_location_assignment PIN_B21   -to gpio_bd_i[5]  ; ## dipsw5
set_location_assignment PIN_C21   -to gpio_bd_i[6]  ; ## dipsw6
set_location_assignment PIN_A20   -to gpio_bd_i[7]  ; ## dipsw7
set_location_assignment PIN_T12   -to gpio_bd_i[8]  ; ## pb0-s3
set_location_assignment PIN_U12   -to gpio_bd_i[9]  ; ## pb1-s2
set_location_assignment PIN_U11   -to gpio_bd_i[10] ; ## pb2-s1

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_o[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_bd_i[10]

