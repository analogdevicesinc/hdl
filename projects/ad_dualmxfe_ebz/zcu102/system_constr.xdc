# dual_mxfe/zcu102

set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS_18} [get_ports adf4377_ce]        ; ## H23  FMC0_LA19_N           IO_L23N_T3U_N9_67
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS_18} [get_ports adf4377_csb]       ; ## H22  FMC0_LA19_P           IO_L23P_T3U_N8_67
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS_18} [get_ports adf4377_enclk1]    ; ## G21  FMC0_LA20_P           IO_L22P_T3U_N6_DBC_AD0P_67
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS_18} [get_ports adf4377_enclk2]    ; ## H19  FMC0_LA15_P           IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS_18} [get_ports adf4377_sclk]      ; ## H17  FMC0_LA11_N           IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN AB6  IOSTANDARD LVCMOS_18} [get_ports adf4377_sdio]      ; ## H16  FMC0_LA11_P           IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVCMOS_18} [get_ports adf4377_sdo]       ; ## H7   FMC0_LA02_P           IO_L23P_T3U_N8_66

set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS_18} [get_ports fan_pwm]           ; ## H10  FMC0_LA04_P           IO_L21P_T3L_N4_AD8P_66
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS_18} [get_ports fan_tach]          ; ## H11  FMC0_LA04_N           IO_L21N_T3L_N5_AD8N_66

set_property -dict {PACKAGE_PIN G8   IOSTANDARD LVDS} [get_ports fpga_clk0_p]            ; ## D4   FMC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7   IOSTANDARD LVDS} [get_ports fpga_clk0_n]            ; ## D5   FMC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229

set_property -dict {PACKAGE_PIN L8   IOSTANDARD LVDS} [get_ports fpga_clk1_p]            ; ## B20  FMC0_GBTCLK1_M2C_C_P  MGTREFCLK0P_228
set_property -dict {PACKAGE_PIN L7   IOSTANDARD LVDS} [get_ports fpga_clk1_n]            ; ## B21  FMC0_GBTCLK1_M2C_C_N  MGTREFCLK0N_228

set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVDS} [get_ports fpga_clk2_p]            ; ## H4   FMC0_CLK0_M2C_P       IO_L12P_T1U_N10_GC_66
set_property -dict {PACKAGE_PIN AA6  IOSTANDARD LVDS} [get_ports fpga_clk2_n]            ; ## H5   FMC0_CLK0_M2C_N       IO_L12N_T1U_N11_GC_66

set_property -dict {PACKAGE_PIN T8   IOSTANDARD LVDS} [get_ports fpga_clk3_p]            ; ## G2   FMC0_CLK1_M2C_P       IO_L12P_T1U_N10_GC_67
set_property -dict {PACKAGE_PIN R8   IOSTANDARD LVDS} [get_ports fpga_clk3_n]            ; ## G3   FMC0_CLK1_M2C_N       IO_L12N_T1U_N11_GC_67

set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVDS} [get_ports fpga_sysref0_p]         ; ## D8   FMC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVDS} [get_ports fpga_sysref0_n]         ; ## D9   FMC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVDS} [get_ports fpga_sysref1_p]         ; ## C22  FMC0_LA18_CC_P        IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVDS} [get_ports fpga_sysref1_n]         ; ## C23  FMC0_LA18_CC_N        IO_L16N_T2U_N7_QBC_AD3N_67

set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS_18} [get_ports hmc7044_miso]      ; ## G25  FMC0_LA22_N           IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS_18} [get_ports hmc7044_mosi]      ; ## H8   FMC0_LA02_N           IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS_18} [get_ports hmc7044_reset]     ; ## G22  FMC0_LA20_N           IO_L22N_T3U_N7_DBC_AD0N_67
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS_18} [get_ports hmc7044_sclk]      ; ## G24  FMC0_LA22_P           IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS_18} [get_ports hmc7044_slen]      ; ## G27  FMC0_LA25_P           IO_L17P_T2U_N8_AD10P_67

set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS_18} [get_ports m0_irq]            ; ## H13  FMC0_LA07_P           IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVCMOS_18} [get_ports m1_irq]            ; ## H14  FMC0_LA07_N           IO_L18N_T2U_N11_AD2N_66

set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS_18} [get_ports mxfe_reset[0]]     ; ## C26  FMC0_LA27_P           IO_L15P_T2L_N4_AD11P_67
set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS_18} [get_ports mxfe_reset[1]]     ; ## C27  FMC0_LA27_N           IO_L15N_T2L_N5_AD11N_67

set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[0]]     ; ## H20  FMC0_LA15_N           IO_L6N_T0U_N11_AD6N_66
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[1]]     ; ## H28  FMC0_LA24_P           IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[2]]     ; ## H29  FMC0_LA24_N           IO_L18N_T2U_N11_AD2N_67
set_property -dict {PACKAGE_PIN T7   IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[3]]     ; ## H31  FMC0_LA28_P           IO_L10P_T1U_N6_QBC_AD4P_67
set_property -dict {PACKAGE_PIN T6   IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[4]]     ; ## H32  FMC0_LA28_N           IO_L10N_T1U_N7_QBC_AD4N_67
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[5]]     ; ## H34  FMC0_LA30_P           IO_L8P_T1L_N2_AD5P_67
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[6]]     ; ## H35  FMC0_LA30_N           IO_L8N_T1L_N3_AD5N_67
set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[7]]     ; ## H37  FMC0_LA32_P           IO_L6P_T0U_N10_AD6P_67
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS_18} [get_ports mxfe0_gpio[8]]     ; ## H38  FMC0_LA32_N           IO_L6N_T0U_N11_AD6N_67
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[0]]     ; ## G28  FMC0_LA25_N           IO_L17N_T2U_N9_AD10N_67
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[1]]     ; ## G30  FMC0_LA29_P           IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN U8   IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[2]]     ; ## G31  FMC0_LA29_N           IO_L9N_T1L_N5_AD12N_67
set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[3]]     ; ## G33  FMC0_LA31_P           IO_L7P_T1L_N0_QBC_AD13P_67
set_property -dict {PACKAGE_PIN V7   IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[4]]     ; ## G34  FMC0_LA31_N           IO_L7N_T1L_N1_QBC_AD13N_67
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[5]]     ; ## G36  FMC0_LA33_P           IO_L5P_T0U_N8_AD14P_67
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[6]]     ; ## G37  FMC0_LA33_N           IO_L5N_T0U_N9_AD14N_67
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[7]]     ; ## H25  FMC0_LA21_P           IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVCMOS_18} [get_ports mxfe1_gpio[8]]     ; ## H26  FMC0_LA21_N           IO_L21N_T3L_N5_AD8N_67

set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS_18} [get_ports mxfe_cs[0]]        ; ## G9   FMC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS_18} [get_ports mxfe_cs[1]]        ; ## G15  FMC0_LA12_P           IO_L9P_T1L_N4_AD12P_66

set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVCMOS_18} [get_ports mxfe_sclk[0]]      ; ## G13  FMC0_LA08_N           IO_L17N_T2U_N9_AD10N_66
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS_18} [get_ports mxfe_sclk[1]]      ; ## G19  FMC0_LA16_N           IO_L5N_T0U_N9_AD14N_66

set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVCMOS_18} [get_ports mxfe_miso[0]]      ; ## G10  FMC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS_18} [get_ports mxfe_miso[1]]      ; ## G16  FMC0_LA12_N           IO_L9N_T1L_N5_AD12N_66

set_property -dict {PACKAGE_PIN V4   IOSTANDARD LVCMOS_18} [get_ports mxfe_mosi[0]]      ; ## G12  FMC0_LA08_P           IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS_18} [get_ports mxfe_mosi[1]]      ; ## G18  FMC0_LA16_P           IO_L5P_T0U_N8_AD14P_66

set_property -dict {PACKAGE_PIN P11  IOSTANDARD LVCMOS_18} [get_ports mxfe_rx_en0[0]]    ; ## D20  FMC0_LA17_CC_P        IO_L13P_T2L_N0_GC_QBC_67
set_property -dict {PACKAGE_PIN N11  IOSTANDARD LVCMOS_18} [get_ports mxfe_rx_en1[0]]    ; ## D21  FMC0_LA17_CC_N        IO_L13N_T2L_N1_GC_QBC_67
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS_18} [get_ports mxfe_rx_en0[1]]    ; ## D23  FMC0_LA23_P           IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS_18} [get_ports mxfe_rx_en1[1]]    ; ## D24  FMC0_LA23_N           IO_L19N_T3L_N1_DBC_AD9N_67

set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS_18} [get_ports mxfe_tx_en0[0]]    ; ## D26  FMC0_LA26_P           IO_L24P_T3U_N10_67
set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS_18} [get_ports mxfe_tx_en1[0]]    ; ## D27  FMC0_LA26_N           IO_L24N_T3U_N11_67
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVCMOS_18} [get_ports mxfe_tx_en0[1]]    ; ## G6   FMC0_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_66
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVCMOS_18} [get_ports mxfe_tx_en1[1]]    ; ## G7   FMC0_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_66

set_property -dict {PACKAGE_PIN H6} [get_ports serdes0_c2m_p[0]]                         ; ## A22  FMC0_DP1_C2M_P        MGTHTXP1_229
set_property -dict {PACKAGE_PIN F6} [get_ports serdes0_c2m_p[2]]                         ; ## A26  FMC0_DP2_C2M_P        MGTHTXP3_229
set_property -dict {PACKAGE_PIN K6} [get_ports serdes0_c2m_p[3]]                         ; ## A30  FMC0_DP3_C2M_P        MGTHTXP0_229
set_property -dict {PACKAGE_PIN G4} [get_ports serdes0_c2m_p[4]]                         ; ## C2   FMC0_DP0_C2M_P        MGTHTXP2_229

set_property -dict {PACKAGE_PIN H5} [get_ports serdes0_c2m_n[0]]                         ; ## A23  FMC0_DP1_C2M_N        MGTHTXN1_229
set_property -dict {PACKAGE_PIN F5} [get_ports serdes0_c2m_n[2]]                         ; ## A27  FMC0_DP2_C2M_N        MGTHTXN3_229
set_property -dict {PACKAGE_PIN K5} [get_ports serdes0_c2m_n[3]]                         ; ## A31  FMC0_DP3_C2M_N        MGTHTXN0_229
set_property -dict {PACKAGE_PIN G3} [get_ports serdes0_c2m_n[4]]                         ; ## C3   FMC0_DP0_C2M_N        MGTHTXN2_229

set_property -dict {PACKAGE_PIN J4} [get_ports serdes0_m2c_p[0]]                         ; ## A2   FMC0_DP1_M2C_P        MGTHRXP1_229
set_property -dict {PACKAGE_PIN H2} [get_ports serdes0_m2c_p[1]]                         ; ## C6   FMC0_DP0_M2C_P        MGTHRXP2_229
set_property -dict {PACKAGE_PIN K2} [get_ports serdes0_m2c_p[3]]                         ; ## A10  FMC0_DP3_M2C_P        MGTHRXP0_229
set_property -dict {PACKAGE_PIN F2} [get_ports serdes0_m2c_p[6]]                         ; ## A6   FMC0_DP2_M2C_P        MGTHRXP3_229

set_property -dict {PACKAGE_PIN J3} [get_ports serdes0_m2c_n[0]]                         ; ## A3   FMC0_DP1_M2C_N        MGTHRXN1_229
set_property -dict {PACKAGE_PIN H1} [get_ports serdes0_m2c_n[1]]                         ; ## C7   FMC0_DP0_M2C_N        MGTHRXN2_229
set_property -dict {PACKAGE_PIN K1} [get_ports serdes0_m2c_n[3]]                         ; ## A11  FMC0_DP3_M2C_N        MGTHRXN0_229
set_property -dict {PACKAGE_PIN F1} [get_ports serdes0_m2c_n[6]]                         ; ## A7   FMC0_DP2_M2C_N        MGTHRXN3_229

set_property -dict {PACKAGE_PIN M6} [get_ports serdes1_c2m_p[2]]                         ; ## A34  FMC0_DP4_C2M_P        MGTHTXP3_228
set_property -dict {PACKAGE_PIN P6} [get_ports serdes1_c2m_p[3]]                         ; ## A38  FMC0_DP5_C2M_P        MGTHTXP1_228
set_property -dict {PACKAGE_PIN R4} [get_ports serdes1_c2m_p[5]]                         ; ## B36  FMC0_DP6_C2M_P        MGTHTXP0_228
set_property -dict {PACKAGE_PIN N4} [get_ports serdes1_c2m_p[6]]                         ; ## B32  FMC0_DP7_C2M_P        MGTHTXP2_228

set_property -dict {PACKAGE_PIN M5} [get_ports serdes1_c2m_n[2]]                         ; ## A35  FMC0_DP4_C2M_N        MGTHTXN3_228
set_property -dict {PACKAGE_PIN P5} [get_ports serdes1_c2m_n[3]]                         ; ## A39  FMC0_DP5_C2M_N        MGTHTXN1_228
set_property -dict {PACKAGE_PIN R3} [get_ports serdes1_c2m_n[5]]                         ; ## B37  FMC0_DP6_C2M_N        MGTHTXN0_228
set_property -dict {PACKAGE_PIN N3} [get_ports serdes1_c2m_n[6]]                         ; ## B33  FMC0_DP7_C2M_N        MGTHTXN2_228

set_property -dict {PACKAGE_PIN M2} [get_ports serdes1_m2c_p[0]]                         ; ## B12  FMC0_DP7_M2C_P        MGTHRXP2_228
set_property -dict {PACKAGE_PIN L4} [get_ports serdes1_m2c_p[1]]                         ; ## A14  FMC0_DP4_M2C_P        MGTHRXP3_228
set_property -dict {PACKAGE_PIN T2} [get_ports serdes1_m2c_p[2]]                         ; ## B16  FMC0_DP6_M2C_P        MGTHRXP0_228
set_property -dict {PACKAGE_PIN P2} [get_ports serdes1_m2c_p[3]]                         ; ## A18  FMC0_DP5_M2C_P        MGTHRXP1_228

set_property -dict {PACKAGE_PIN M1} [get_ports serdes1_m2c_n[0]]                         ; ## B13  FMC0_DP7_M2C_N        MGTHRXN2_228
set_property -dict {PACKAGE_PIN L3} [get_ports serdes1_m2c_n[1]]                         ; ## A15  FMC0_DP4_M2C_N        MGTHRXN3_228
set_property -dict {PACKAGE_PIN T1} [get_ports serdes1_m2c_n[2]]                         ; ## B17  FMC0_DP6_M2C_N        MGTHRXN0_228
set_property -dict {PACKAGE_PIN P1} [get_ports serdes1_m2c_n[3]]                         ; ## A19  FMC0_DP5_M2C_N        MGTHRXN1_228

set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVDS} [get_ports mxfe0_syncin_p_0]       ; ## C10  FMC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN W5   IOSTANDARD LVDS} [get_ports mxfe0_syncin_p_1]       ; ## C14  FMC0_LA10_P           IO_L15P_T2L_N4_AD11P_66
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVDS} [get_ports mxfe1_syncin_p_2]       ; ## C18  FMC0_LA14_P           IO_L7P_T1L_N0_QBC_AD13P_66
set_property -dict {PACKAGE_PIN AC6  IOSTANDARD LVDS} [get_ports mxfe1_syncin_p_3]       ; ## C19  FMC0_LA14_N           IO_L7N_T1L_N1_QBC_AD13N_66

set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVDS} [get_ports mxfe0_syncin_n_0]       ; ## C11  FMC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVDS} [get_ports mxfe1_syncin_n_1]       ; ## C15  FMC0_LA10_N           IO_L15N_T2L_N5_AD11N_66

set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVDS} [get_ports mxfe0_syncout_p_0]      ; ## D11  FMC0_LA05_P           IO_L20P_T3L_N2_AD1P_66
set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVDS} [get_ports mxfe0_syncout_p_1]      ; ## D14  FMC0_LA09_P           IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVDS} [get_ports mxfe1_syncout_p_2]      ; ## D17  FMC0_LA13_P           IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVDS} [get_ports mxfe1_syncout_p_3]      ; ## D18  FMC0_LA13_N           IO_L8N_T1L_N3_AD5N_66

set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVDS} [get_ports mxfe0_syncout_n_0]      ; ## D12  FMC0_LA05_N           IO_L20N_T3L_N3_AD1N_66
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVDS} [get_ports mxfe1_syncout_n_1]      ; ## D15  FMC0_LA09_N           IO_L24N_T3U_N11_66
