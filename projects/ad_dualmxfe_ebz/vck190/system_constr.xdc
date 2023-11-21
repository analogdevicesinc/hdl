###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# dual_mxfe/vck190

set_property -dict {PACKAGE_PIN M33  IOSTANDARD LVCMOS18} [get_ports adf4377_ce]        ; ## H23  FMC_LA19_N           IO_L22N_T3U_N7_DBC_AD0N_45
set_property -dict {PACKAGE_PIN N33  IOSTANDARD LVCMOS18} [get_ports adf4377_csb]       ; ## H22  FMC_LA19_P           IO_L22P_T3U_N6_DBC_AD0P_45
set_property -dict {PACKAGE_PIN N32  IOSTANDARD LVCMOS18} [get_ports adf4377_enclk1]    ; ## G21  FMC_LA20_P           IO_L23P_T3U_N8_45
set_property -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18} [get_ports adf4377_enclk2]    ; ## H19  FMC_LA15_P           IO_L24P_T3U_N10_43
set_property -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18} [get_ports adf4377_sclk]      ; ## H17  FMC_LA11_N           IO_L17N_T2U_N9_AD10N_43
set_property -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18} [get_ports adf4377_sdio]      ; ## H16  FMC_LA11_P           IO_L17P_T2U_N8_AD10P_43
set_property -dict {PACKAGE_PIN AJ32 IOSTANDARD LVCMOS18} [get_ports adf4377_sdo]       ; ## H7   FMC_LA02_P           IO_L14P_T2L_N2_GC_43

set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS18} [get_ports fan_pwm]           ; ## H10  FMC_LA04_P           IO_L6P_T0U_N10_AD6P_43
set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18} [get_ports fan_tach]          ; ## H11  FMC_LA04_N           IO_L6N_T0U_N11_AD6N_43

set_property -dict {PACKAGE_PIN AK38} [get_ports fpga_clk0_p]                           ; ## D4   FMC_GBT0_0_P         MGTREFCLK0P_121
set_property -dict {PACKAGE_PIN V38}  [get_ports fpga_clk0_p_replica]                   ; ## --   --                   MGTREFCLK0P_126
set_property -dict {PACKAGE_PIN AK39} [get_ports fpga_clk0_n]                           ; ## D5   FMC_GBT0_0_N         MGTREFCLK0N_121
set_property -dict {PACKAGE_PIN V39}  [get_ports fpga_clk0_n_replica]                   ; ## --   --                   MGTREFCLK0N_126

#set_property -dict {PACKAGE_PIN AH38 IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_0_P         MGTREFCLK1P_121
#set_property -dict {PACKAGE_PIN T38  IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_1_P         MGTREFCLK1P_126
#set_property -dict {PACKAGE_PIN AD38 IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_2_P         MGTREFCLK1P_122
#set_property -dict {PACKAGE_PIN Y38  IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_3_P         MGTREFCLK1P_125
#set_property -dict {PACKAGE_PIN N40  IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_4_P         MGTREFCLK1P_127
#set_property -dict {PACKAGE_PIN AM38 IOSTANDARD LVDS} [get_ports fpga_clk1_p]           ; ## B20  FMC_GBT1_5_P         MGTREFCLK1P_120
#set_property -dict {PACKAGE_PIN AH39 IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_0_N         MGTREFCLK1N_121
#set_property -dict {PACKAGE_PIN T39  IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_1_N         MGTREFCLK1N_126
#set_property -dict {PACKAGE_PIN AD39 IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_2_N         MGTREFCLK1N_122
#set_property -dict {PACKAGE_PIN Y39  IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_3_N         MGTREFCLK1N_125
#set_property -dict {PACKAGE_PIN N41  IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_4_N         MGTREFCLK1N_127
#set_property -dict {PACKAGE_PIN AM39 IOSTANDARD LVDS} [get_ports fpga_clk1_n]           ; ## B21  FMC_GBT1_5_N         MGTREFCLK1N_120

set_property -dict {PACKAGE_PIN AL32 IOSTANDARD LVDS} [get_ports fpga_clk2_p]           ; ## H4   FMC_CLK0_M2C_P       IO_L13P_T2L_N0_GC_QBC_43
set_property -dict {PACKAGE_PIN AM32 IOSTANDARD LVDS} [get_ports fpga_clk2_n]           ; ## H5   FMC_CLK0_M2C_N       IO_L13N_T2L_N1_GC_QBC_43

set_property -dict {PACKAGE_PIN P35  IOSTANDARD LVDS} [get_ports fpga_clk3_p]           ; ## G2   FMC_CLK1_M2C_P       IO_L14P_T2L_N2_GC_45
set_property -dict {PACKAGE_PIN P36  IOSTANDARD LVDS} [get_ports fpga_clk3_n]           ; ## G3   FMC_CLK1_M2C_N       IO_L14N_T2L_N3_GC_45

set_property -dict {PACKAGE_PIN AF38} [get_ports fpga_clk4_p]                           ; ## L12  FMC_GBTCLK2_M2C_C_P  MGTREFCLK0P_122
set_property -dict {PACKAGE_PIN AF39} [get_ports fpga_clk4_n]                           ; ## L13  FMC_GBTCLK2_M2C_C_N  MGTREFCLK0N_122

set_property -dict {PACKAGE_PIN AL30 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports fpga_sysref0_p]        ; ## D8   FMC_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_43
set_property -dict {PACKAGE_PIN AL31 IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports fpga_sysref0_n]        ; ## D9   FMC_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_43
set_property -dict {PACKAGE_PIN R31  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports fpga_sysref1_p]        ; ## C22  FMC_LA18_CC_P        IO_L10P_T1U_N6_QBC_AD4P_45
set_property -dict {PACKAGE_PIN P31  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports fpga_sysref1_n]        ; ## C23  FMC_LA18_CC_N        IO_L10N_T1U_N7_QBC_AD4N_45

set_property -dict {PACKAGE_PIN R14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[0]]    ; ## E6   FMC_HA05_P           IO_L14P_T2L_N2_GC_70
set_property -dict {PACKAGE_PIN W14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[1]]    ; ## E9   FMC_HA09_P           IO_L6P_T0U_N10_AD6P_70
set_property -dict {PACKAGE_PIN V13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[2]]    ; ## E12  FMC_HA13_P           IO_L4P_T0U_N6_DBC_AD7P_7
set_property -dict {PACKAGE_PIN T14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[3]]    ; ## E15  FMC_HA16_P           IO_L11P_T1U_N8_GC_70
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[4]]    ; ## E18  FMC_HA20_P           IO_L17P_T2U_N8_AD10P_70
set_property -dict {PACKAGE_PIN N14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[5]]    ; ## F4   FMC_HA00_CC_P        IO_L13P_T2L_N0_GC_QBC_70
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[6]]    ; ## F7   FMC_HA04_P           IO_L1P_T0L_N0_DBC_70
set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[7]]    ; ## F10  FMC_HA08_P           IO_L10P_T1U_N6_QBC_AD4P_70
set_property -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[8]]    ; ## F13  FMC_HA12_P           IO_L9P_T1L_N4_AD12P_70
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[9]]    ; ## F16  FMC_HA15_P           IO_L19P_T3L_N0_DBC_AD9P_70
set_property -dict {PACKAGE_PIN L14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[10]]   ; ## F19  FMC_HA19_P           IO_L20P_T3L_N2_AD1P_70
set_property -dict {PACKAGE_PIN W12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[11]]   ; ## J6   FMC_HA03_P           IO_L3P_T0L_N4_AD15P_70
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[12]]   ; ## J9   FMC_HA07_P           IO_L2P_T0L_N2_70
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[13]]   ; ## J12  FMC_HA11_P           IO_L18P_T2U_N10_AD2P_70
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[14]]   ; ## J15  FMC_HA14_P           IO_L22P_T3U_N6_DBC_AD0P_700
set_property -dict {PACKAGE_PIN P15  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[15]]   ; ## J18  FMC_HA18_P           IO_L15P_T2L_N4_AD11P_70
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[16]]   ; ## J21  FMC_HA22_P           IO_L24P_T3U_N10_70
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[17]]   ; ## K7   FMC_HA02_P           IO_L5P_T0U_N8_AD14P_70
set_property -dict {PACKAGE_PIN U13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[18]]   ; ## K10  FMC_HA06_P           IO_L12P_T1U_N10_GC_70
set_property -dict {PACKAGE_PIN V16  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[19]]   ; ## K13  FMC_HA10_P           IO_L8P_T1L_N2_AD5P_70
set_property -dict {PACKAGE_PIN R11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[20]]   ; ## K16  FMC_HA17_CC_P        IO_L16P_T2U_N6_QBC_AD3P_70
set_property -dict {PACKAGE_PIN K14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[21]]   ; ## K19  FMC_HA21_P           IO_L23P_T3U_N8_70
set_property -dict {PACKAGE_PIN K11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_p[22]]   ; ## K22  FMC_HA23_P           IO_L21P_T3L_N4_AD8P_70

set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[0]]    ; ## E7   FMC_HA05_N           IO_L14N_T2L_N3_GC_70
set_property -dict {PACKAGE_PIN V14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[1]]    ; ## E10  FMC_HA09_N           IO_L6N_T0U_N11_AD6N_70
set_property -dict {PACKAGE_PIN U12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[2]]    ; ## E13  FMC_HA13_N           IO_L4N_T0U_N7_DBC_AD7N_70
set_property -dict {PACKAGE_PIN R13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[3]]    ; ## E16  FMC_HA16_N           IO_L11N_T1U_N9_GC_70
set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[4]]    ; ## E19  FMC_HA20_N           IO_L17N_T2U_N9_AD10N_70
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[5]]    ; ## F5   FMC_HA00_CC_N        IO_L13N_T2L_N1_GC_QBC_70
set_property -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[6]]    ; ## F8   FMC_HA04_N           IO_L1N_T0L_N1_DBC_70
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[7]]    ; ## F11  FMC_HA08_N           IO_L10N_T1U_N7_QBC_AD4N_70
set_property -dict {PACKAGE_PIN T15  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[8]]    ; ## F14  FMC_HA12_N           IO_L9N_T1L_N5_AD12N_70
set_property -dict {PACKAGE_PIN M12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[9]]    ; ## F17  FMC_HA15_N           IO_L19N_T3L_N1_DBC_AD9N_70
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[10]]   ; ## F20  FMC_HA19_N           IO_L20N_T3L_N3_AD1N_70
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[11]]   ; ## J7   FMC_HA03_N           IO_L3N_T0L_N5_AD15N_70
set_property -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[12]]   ; ## J10  FMC_HA07_N           IO_L2N_T0L_N3_70
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[13]]   ; ## J13  FMC_HA11_N           IO_L18N_T2U_N11_AD2N_70
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[14]]   ; ## J16  FMC_HA14_N           IO_L22N_T3U_N7_DBC_AD0N_70
set_property -dict {PACKAGE_PIN N15  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[15]]   ; ## J19  FMC_HA18_N           IO_L15N_T2L_N5_AD11N_70
set_property -dict {PACKAGE_PIN J12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[16]]   ; ## J22  FMC_HA22_N           IO_L24N_T3U_N11_70
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[17]]   ; ## K8   FMC_HA02_N           IO_L5N_T0U_N9_AD14N_70
set_property -dict {PACKAGE_PIN T13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[18]]   ; ## K11  FMC_HA06_N           IO_L12N_T1U_N11_GC_70
set_property -dict {PACKAGE_PIN U16  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[19]]   ; ## K14  FMC_HA10_N           IO_L8N_T1L_N3_AD5N_70
set_property -dict {PACKAGE_PIN P11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[20]]   ; ## K17  FMC_HA17_CC_N        IO_L16N_T2U_N7_QBC_AD3N_70
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[21]]   ; ## K20  FMC_HA21_N           IO_L23N_T3U_N9_70
set_property -dict {PACKAGE_PIN J11  IOSTANDARD LVCMOS18} [get_ports gpio_fmcp_n[22]]   ; ## K23  FMC_HA23_N           IO_L21N_T3L_N5_AD8N_70

set_property -dict {PACKAGE_PIN N35  IOSTANDARD LVCMOS18} [get_ports hmc7044_miso]      ; ## G25  FMC_LA22_N           IO_L20N_T3L_N3_AD1N_45
set_property -dict {PACKAGE_PIN AK32 IOSTANDARD LVCMOS18} [get_ports hmc7044_mosi]      ; ## H8   FMC_LA02_N           IO_L14N_T2L_N3_GC_43
set_property -dict {PACKAGE_PIN M32  IOSTANDARD LVCMOS18} [get_ports hmc7044_reset]     ; ## G22  FMC_LA20_N           IO_L23N_T3U_N9_45
set_property -dict {PACKAGE_PIN N34  IOSTANDARD LVCMOS18} [get_ports hmc7044_sclk]      ; ## G24  FMC_LA22_P           IO_L20P_T3L_N2_AD1P_45
set_property -dict {PACKAGE_PIN Y34  IOSTANDARD LVCMOS18} [get_ports hmc7044_slen]      ; ## G27  FMC_LA25_P           IO_L3P_T0L_N4_AD15P_45

set_property -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18} [get_ports m0_irq]            ; ## H13  FMC_LA07_P           IO_L5P_T0U_N8_AD14P_43
set_property -dict {PACKAGE_PIN AP37 IOSTANDARD LVCMOS18} [get_ports m1_irq]            ; ## H14  FMC_LA07_N           IO_L5N_T0U_N9_AD14N_43

set_property -dict {PACKAGE_PIN V33  IOSTANDARD LVCMOS18} [get_ports mxfe_reset[0]]     ; ## C26  FMC_LA27_P           IO_L5P_T0U_N8_AD14P_45
set_property -dict {PACKAGE_PIN V34  IOSTANDARD LVCMOS18} [get_ports mxfe_reset[1]]     ; ## C27  FMC_LA27_N           IO_L5N_T0U_N9_AD14N_45

set_property -dict {PACKAGE_PIN AG33 IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[0]]     ; ## H20  FMC_LA15_N           IO_L24N_T3U_N11_43
set_property -dict {PACKAGE_PIN T34  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[1]]     ; ## H28  FMC_LA24_P           IO_L6P_T0U_N10_AD6P_45
set_property -dict {PACKAGE_PIN T35  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[2]]     ; ## H29  FMC_LA24_N           IO_L6N_T0U_N11_AD6N_45
set_property -dict {PACKAGE_PIN M36  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[3]]     ; ## H31  FMC_LA28_P           IO_L17P_T2U_N8_AD10P_45
set_property -dict {PACKAGE_PIN L36  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[4]]     ; ## H32  FMC_LA28_N           IO_L17N_T2U_N9_AD10N_45
set_property -dict {PACKAGE_PIN N38  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[5]]     ; ## H34  FMC_LA30_P           IO_L18P_T2U_N10_AD2P_45
set_property -dict {PACKAGE_PIN M38  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[6]]     ; ## H35  FMC_LA30_N           IO_L18N_T2U_N11_AD2N_45
set_property -dict {PACKAGE_PIN L33  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[7]]     ; ## H37  FMC_LA32_P           IO_L21P_T3L_N4_AD8P_45
set_property -dict {PACKAGE_PIN K33  IOSTANDARD LVCMOS18} [get_ports mxfe0_gpio[8]]     ; ## H38  FMC_LA32_N           IO_L21N_T3L_N5_AD8N_45

set_property -dict {PACKAGE_PIN W34  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[0]]     ; ## G28  FMC_LA25_N           IO_L3N_T0L_N5_AD15N_45
set_property -dict {PACKAGE_PIN U35  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[1]]     ; ## G30  FMC_LA29_P           IO_L4P_T0U_N6_DBC_AD7P_45
set_property -dict {PACKAGE_PIN T36  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[2]]     ; ## G31  FMC_LA29_N           IO_L4N_T0U_N7_DBC_AD7N_45
set_property -dict {PACKAGE_PIN P37  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[3]]     ; ## G33  FMC_LA31_P           IO_L16P_T2U_N6_QBC_AD3P_45
set_property -dict {PACKAGE_PIN N37  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[4]]     ; ## G34  FMC_LA31_N           IO_L16N_T2U_N7_QBC_AD3N_45
set_property -dict {PACKAGE_PIN L34  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[5]]     ; ## G36  FMC_LA33_P           IO_L19P_T3L_N0_DBC_AD9P_45
set_property -dict {PACKAGE_PIN K34  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[6]]     ; ## G37  FMC_LA33_N           IO_L19N_T3L_N1_DBC_AD9N_45
set_property -dict {PACKAGE_PIN M35  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[7]]     ; ## H25  FMC_LA21_P           IO_L24P_T3U_N10_45
set_property -dict {PACKAGE_PIN L35  IOSTANDARD LVCMOS18} [get_ports mxfe1_gpio[8]]     ; ## H26  FMC_LA21_N           IO_L24N_T3U_N11_45

set_property -dict {PACKAGE_PIN AT39 IOSTANDARD LVCMOS18} [get_ports mxfe_cs[0]]        ; ## G9   FMC_LA03_P           IO_L4P_T0U_N6_DBC_AD7P_43
set_property -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18} [get_ports mxfe_cs[1]]        ; ## G15  FMC_LA12_P           IO_L21P_T3L_N4_AD8P_43

set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18} [get_ports mxfe_sclk[0]]      ; ## G13  FMC_LA08_N           IO_L18N_T2U_N11_AD2N_43
set_property -dict {PACKAGE_PIN AH35 IOSTANDARD LVCMOS18} [get_ports mxfe_sclk[1]]      ; ## G19  FMC_LA16_N           IO_L22N_T3U_N7_DBC_AD0N_43

set_property -dict {PACKAGE_PIN AT40 IOSTANDARD LVCMOS18} [get_ports mxfe_miso[0]]      ; ## G10  FMC_LA03_N           IO_L4N_T0U_N7_DBC_AD7N_43
set_property -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18} [get_ports mxfe_miso[1]]      ; ## G16  FMC_LA12_N           IO_L21N_T3L_N5_AD8N_43

set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18} [get_ports mxfe_mosi[0]]      ; ## G12  FMC_LA08_P           IO_L18P_T2U_N10_AD2P_43
set_property -dict {PACKAGE_PIN AG34 IOSTANDARD LVCMOS18} [get_ports mxfe_mosi[1]]      ; ## G18  FMC_LA16_P           IO_L22P_T3U_N6_DBC_AD0P_43

set_property -dict {PACKAGE_PIN R34  IOSTANDARD LVCMOS18} [get_ports mxfe_rx_en0[0]]     ; ## D20  FMC_LA17_CC_P        IO_L13P_T2L_N0_GC_QBC_45
set_property -dict {PACKAGE_PIN Y32  IOSTANDARD LVCMOS18} [get_ports mxfe_rx_en0[1]]     ; ## D23  FMC_LA23_P           IO_L1P_T0L_N0_DBC_45
set_property -dict {PACKAGE_PIN P34  IOSTANDARD LVCMOS18} [get_ports mxfe_rx_en1[0]]     ; ## D21  FMC_LA17_CC_N        IO_L13N_T2L_N1_GC_QBC_45
set_property -dict {PACKAGE_PIN W32  IOSTANDARD LVCMOS18} [get_ports mxfe_rx_en1[1]]     ; ## D24  FMC_LA23_N           IO_L1N_T0L_N1_DBC_45

set_property -dict {PACKAGE_PIN V32  IOSTANDARD LVCMOS18} [get_ports mxfe_tx_en0[0]]     ; ## D26  FMC_LA26_P           IO_L2P_T0L_N2_45
set_property -dict {PACKAGE_PIN AL35 IOSTANDARD LVCMOS18} [get_ports mxfe_tx_en0[1]]     ; ## G6   FMC_LA00_CC_P        IO_L7P_T1L_N0_QBC_AD13P_43
set_property -dict {PACKAGE_PIN U33  IOSTANDARD LVCMOS18} [get_ports mxfe_tx_en1[0]]     ; ## D27  FMC_LA26_N           IO_L2N_T0L_N3_45
set_property -dict {PACKAGE_PIN AL36 IOSTANDARD LVCMOS18} [get_ports mxfe_tx_en1[1]]     ; ## G7   FMC_LA00_CC_N        IO_L7N_T1L_N1_QBC_AD13N_43

set_property -dict {PACKAGE_PIN AP42} [get_ports serdes0_c2m_p[0]]                      ; ## A22  FMC_DP1_C2M_P        MGTYTXP1_121
set_property -dict {PACKAGE_PIN AJ40} [get_ports serdes0_c2m_p[1]]                      ; ## B24  FMC_DP9_C2M_P        MGTYTXP1_122
set_property -dict {PACKAGE_PIN AM42} [get_ports serdes0_c2m_p[2]]                      ; ## A26  FMC_DP2_C2M_P        MGTYTXP2_121
set_property -dict {PACKAGE_PIN AL40} [get_ports serdes0_c2m_p[3]]                      ; ## A30  FMC_DP3_C2M_P        MGTYTXP3_121
set_property -dict {PACKAGE_PIN AT42} [get_ports serdes0_c2m_p[4]]                      ; ## C2   FMC_DP0_C2M_P        MGTYTXP0_121
set_property -dict {PACKAGE_PIN AK42} [get_ports serdes0_c2m_p[5]]                      ; ## B28  FMC_DP8_C2M_P        MGTYTXP0_122
set_property -dict {PACKAGE_PIN AE40} [get_ports serdes0_c2m_p[6]]                      ; ## Y26  FMC_DP11_C2M_P       MGTYTXP3_122
set_property -dict {PACKAGE_PIN AG40} [get_ports serdes0_c2m_p[7]]                      ; ## Z24  FMC_DP10_C2M_P       MGTYTXP2_122

set_property -dict {PACKAGE_PIN AP43} [get_ports serdes0_c2m_n[0]]                      ; ## A23  FMC_DP1_C2M_N        MGTYTXN1_121
set_property -dict {PACKAGE_PIN AJ41} [get_ports serdes0_c2m_n[1]]                      ; ## B25  FMC_DP9_C2M_N        MGTYTXN1_122
set_property -dict {PACKAGE_PIN AM43} [get_ports serdes0_c2m_n[2]]                      ; ## A27  FMC_DP2_C2M_N        MGTYTXN2_121
set_property -dict {PACKAGE_PIN AL41} [get_ports serdes0_c2m_n[3]]                      ; ## A31  FMC_DP3_C2M_N        MGTYTXN3_121
set_property -dict {PACKAGE_PIN AT43} [get_ports serdes0_c2m_n[4]]                      ; ## C3   FMC_DP0_C2M_N        MGTYTXN0_121
set_property -dict {PACKAGE_PIN AK43} [get_ports serdes0_c2m_n[5]]                      ; ## B29  FMC_DP8_C2M_N        MGTYTXN0_122
set_property -dict {PACKAGE_PIN AE41} [get_ports serdes0_c2m_n[6]]                      ; ## Y27  FMC_DP11_C2M_N       MGTYTXN3_122
set_property -dict {PACKAGE_PIN AG41} [get_ports serdes0_c2m_n[7]]                      ; ## Z25  FMC_DP10_C2M_N       MGTYTXN2_122

set_property -dict {PACKAGE_PIN AN45} [get_ports serdes0_m2c_p[0]]                      ; ## A2   FMC_DP1_M2C_P        MGTYRXP1_121
set_property -dict {PACKAGE_PIN AR45} [get_ports serdes0_m2c_p[1]]                      ; ## C6   FMC_DP0_M2C_P        MGTYRXP0_121
set_property -dict {PACKAGE_PIN AG45} [get_ports serdes0_m2c_p[2]]                      ; ## B8   FMC_DP8_M2C_P        MGTYRXP0_122
set_property -dict {PACKAGE_PIN AJ45} [get_ports serdes0_m2c_p[3]]                      ; ## A10  FMC_DP3_M2C_P        MGTYRXP3_121
set_property -dict {PACKAGE_PIN AD43} [get_ports serdes0_m2c_p[4]]                      ; ## Z12  FMC_DP11_M2C_P       MGTYRXP3_122
set_property -dict {PACKAGE_PIN AE45} [get_ports serdes0_m2c_p[5]]                      ; ## Y10  FMC_DP10_M2C_P       MGTYRXP2_122
set_property -dict {PACKAGE_PIN AL45} [get_ports serdes0_m2c_p[6]]                      ; ## A6   FMC_DP2_M2C_P        MGTYRXP2_121
set_property -dict {PACKAGE_PIN AF43} [get_ports serdes0_m2c_p[7]]                      ; ## B4   FMC_DP9_M2C_P        MGTYRXP1_122

set_property -dict {PACKAGE_PIN AN46} [get_ports serdes0_m2c_n[0]]                      ; ## A3   FMC_DP1_M2C_N        MGTYRXN1_121
set_property -dict {PACKAGE_PIN AR46} [get_ports serdes0_m2c_n[1]]                      ; ## C7   FMC_DP0_M2C_N        MGTYRXN0_121
set_property -dict {PACKAGE_PIN AG46} [get_ports serdes0_m2c_n[2]]                      ; ## B9   FMC_DP8_M2C_N        MGTYRXN0_122
set_property -dict {PACKAGE_PIN AJ46} [get_ports serdes0_m2c_n[3]]                      ; ## A11  FMC_DP3_M2C_N        MGTYRXN3_121
set_property -dict {PACKAGE_PIN AD44} [get_ports serdes0_m2c_n[4]]                      ; ## Z13  FMC_DP11_M2C_N       MGTYRXN3_122
set_property -dict {PACKAGE_PIN AE46} [get_ports serdes0_m2c_n[5]]                      ; ## Y11  FMC_DP10_M2C_N       MGTYRXN2_122
set_property -dict {PACKAGE_PIN AL46} [get_ports serdes0_m2c_n[6]]                      ; ## A7   FMC_DP2_M2C_N        MGTYRXN2_121
set_property -dict {PACKAGE_PIN AF44} [get_ports serdes0_m2c_n[7]]                      ; ## B5   FMC_DP9_M2C_N        MGTYRXN1_122

set_property -dict {PACKAGE_PIN U40 } [get_ports serdes1_c2m_p[0]]                      ; ## M22  FMC_DP15_C2M_P       MGTYTXP3_125
set_property -dict {PACKAGE_PIN AA40} [get_ports serdes1_c2m_p[1]]                      ; ## Y30  FMC_DP13_C2M_P       MGTYTXP1_125
set_property -dict {PACKAGE_PIN T42 } [get_ports serdes1_c2m_p[2]]                      ; ## A34  FMC_DP4_C2M_P        MGTYTXP0_126
set_property -dict {PACKAGE_PIN P42 } [get_ports serdes1_c2m_p[3]]                      ; ## A38  FMC_DP5_C2M_P        MGTYTXP1_126
set_property -dict {PACKAGE_PIN W40 } [get_ports serdes1_c2m_p[4]]                      ; ## M18  FMC_DP14_C2M_P       MGTYTXP2_125
set_property -dict {PACKAGE_PIN M42 } [get_ports serdes1_c2m_p[5]]                      ; ## B36  FMC_DP6_C2M_P        MGTYTXP2_126
set_property -dict {PACKAGE_PIN K42 } [get_ports serdes1_c2m_p[6]]                      ; ## B32  FMC_DP7_C2M_P        MGTYTXP3_126
set_property -dict {PACKAGE_PIN AC40} [get_ports serdes1_c2m_p[7]]                      ; ## Z28  FMC_DP12_C2M_P       MGTYTXP0_125

set_property -dict {PACKAGE_PIN U41 } [get_ports serdes1_c2m_n[0]]                      ; ## M23  FMC_DP15_C2M_N       MGTYTXN3_125
set_property -dict {PACKAGE_PIN AA41} [get_ports serdes1_c2m_n[1]]                      ; ## Y31  FMC_DP13_C2M_N       MGTYTXN1_125
set_property -dict {PACKAGE_PIN T43 } [get_ports serdes1_c2m_n[2]]                      ; ## A35  FMC_DP4_C2M_N        MGTYTXN0_126
set_property -dict {PACKAGE_PIN P43 } [get_ports serdes1_c2m_n[3]]                      ; ## A39  FMC_DP5_C2M_N        MGTYTXN1_126
set_property -dict {PACKAGE_PIN W41 } [get_ports serdes1_c2m_n[4]]                      ; ## M19  FMC_DP14_C2M_N       MGTYTXN2_125
set_property -dict {PACKAGE_PIN M43 } [get_ports serdes1_c2m_n[5]]                      ; ## B37  FMC_DP6_C2M_N        MGTYTXN2_126
set_property -dict {PACKAGE_PIN K43 } [get_ports serdes1_c2m_n[6]]                      ; ## B33  FMC_DP7_C2M_N        MGTYTXN3_126
set_property -dict {PACKAGE_PIN AC41} [get_ports serdes1_c2m_n[7]]                      ; ## Z29  FMC_DP12_C2M_N       MGTYTXN0_125

set_property -dict {PACKAGE_PIN N45 } [get_ports serdes1_m2c_p[0]]                      ; ## B12  FMC_DP7_M2C_P        MGTYRXP3_126
set_property -dict {PACKAGE_PIN W45 } [get_ports serdes1_m2c_p[1]]                      ; ## A14  FMC_DP4_M2C_P        MGTYRXP0_126
set_property -dict {PACKAGE_PIN R45 } [get_ports serdes1_m2c_p[2]]                      ; ## B16  FMC_DP6_M2C_P        MGTYRXP2_126
set_property -dict {PACKAGE_PIN U45 } [get_ports serdes1_m2c_p[3]]                      ; ## A18  FMC_DP5_M2C_P        MGTYRXP1_126
set_property -dict {PACKAGE_PIN Y43 } [get_ports serdes1_m2c_p[4]]                      ; ## Y22  FMC_DP15_M2C_P       MGTYRXP3_125
set_property -dict {PACKAGE_PIN AA45} [get_ports serdes1_m2c_p[5]]                      ; ## Y18  FMC_DP14_M2C_P       MGTYRXP2_125
set_property -dict {PACKAGE_PIN AB43} [get_ports serdes1_m2c_p[6]]                      ; ## Z16  FMC_DP13_M2C_P       MGTYRXP1_125
set_property -dict {PACKAGE_PIN AC45} [get_ports serdes1_m2c_p[7]]                      ; ## Y14  FMC_DP12_M2C_P       MGTYRXP0_125

set_property -dict {PACKAGE_PIN N46 } [get_ports serdes1_m2c_n[0]]                      ; ## B13  FMC_DP7_M2C_N        MGTYRXN3_126
set_property -dict {PACKAGE_PIN W46 } [get_ports serdes1_m2c_n[1]]                      ; ## A15  FMC_DP4_M2C_N        MGTYRXN0_126
set_property -dict {PACKAGE_PIN R46 } [get_ports serdes1_m2c_n[2]]                      ; ## B17  FMC_DP6_M2C_N        MGTYRXN2_126
set_property -dict {PACKAGE_PIN U46 } [get_ports serdes1_m2c_n[3]]                      ; ## A19  FMC_DP5_M2C_N        MGTYRXN1_126
set_property -dict {PACKAGE_PIN Y44 } [get_ports serdes1_m2c_n[4]]                      ; ## Y23  FMC_DP15_M2C_N       MGTYRXN3_125
set_property -dict {PACKAGE_PIN AA46} [get_ports serdes1_m2c_n[5]]                      ; ## Y19  FMC_DP14_M2C_N       MGTYRXN2_125
set_property -dict {PACKAGE_PIN AB44} [get_ports serdes1_m2c_n[6]]                      ; ## Z17  FMC_DP13_M2C_N       MGTYRXN1_125
set_property -dict {PACKAGE_PIN AC46} [get_ports serdes1_m2c_n[7]]                      ; ## Y15  FMC_DP12_M2C_N       MGTYRXN0_125

set_property -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS18} [get_ports syncin_p_0]        ; ## C10  FMC_LA06_P           IO_L2P_T0L_N2_43
set_property -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18} [get_ports syncin_p_1]        ; ## C14  FMC_LA10_P           IO_L3P_T0L_N4_AD15P_43
set_property -dict {PACKAGE_PIN AG31 IOSTANDARD LVCMOS18} [get_ports syncin_p_2]        ; ## C18  FMC_LA14_P           IO_L23P_T3U_N8_43
set_property -dict {PACKAGE_PIN AH31 IOSTANDARD LVCMOS18} [get_ports syncin_p_3]        ; ## C19  FMC_LA14_N           IO_L23N_T3U_N9_43

set_property -dict {PACKAGE_PIN AT36 IOSTANDARD LVCMOS18} [get_ports syncin_n_0]        ; ## C11  FMC_LA06_N           IO_L2N_T0L_N3_43
set_property -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18} [get_ports syncin_n_1]        ; ## C15  FMC_LA10_N           IO_L3N_T0L_N5_AD15N_43

set_property -dict {PACKAGE_PIN AP38 IOSTANDARD LVCMOS18} [get_ports syncout_p_0]       ; ## D11  FMC_LA05_P           IO_L1P_T0L_N0_DBC_43
set_property -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18} [get_ports syncout_p_1]       ; ## D14  FMC_LA09_P           IO_L19P_T3L_N0_DBC_AD9P_43
set_property -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18} [get_ports syncout_p_2]       ; ## D17  FMC_LA13_P           IO_L20P_T3L_N2_AD1P_43
set_property -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18} [get_ports syncout_p_3]       ; ## D18  FMC_LA13_N           IO_L20N_T3L_N3_AD1N_43

set_property -dict {PACKAGE_PIN AR38 IOSTANDARD LVCMOS18} [get_ports syncout_n_0]       ; ## D12  FMC_LA05_N           IO_L1N_T0L_N1_DBC_43
set_property -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18} [get_ports syncout_n_1]       ; ## D15  FMC_LA09_N           IO_L19N_T3L_N1_DBC_AD9N_43

# i'm not sure if it's needed, but it appears in the schematic and also for quad mxfe
# !!! the pin might not be ok
set_property  -dict {PACKAGE_PIN AK35  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports vadj_1v8_pgood];   ## IO_T1U_N12_43_AK35
