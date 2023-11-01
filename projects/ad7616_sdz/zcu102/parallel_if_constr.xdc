
# ad7616 - Parallel mode
# Note: The design uses an SDP to FMC interposer.

set_property -dict {PACKAGE_PIN AH4  IOSTANDARD LVCOMOS18} [get_ports adc_db[0]]        ; ## C14  FMC1_LA10_P      IO_L15P_T2L_N4_AD11P_65
set_property -dict {PACKAGE_PIN AF2  IOSTANDARD LVCOMOS18} [get_ports adc_db[1]]        ; ## H10  FMC1_LA04_P      IO_L21P_T3L_N4_AD8P_65
set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCOMOS18} [get_ports adc_db[2]]        ; ## D14  FMC1_LA09_P      IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property -dict {PACKAGE_PIN AH1  IOSTANDARD LVCOMOS18} [get_ports adc_db[3]]        ; ## G9   FMC1_LA03_P      IO_L22P_T3U_N6_DBC_AD0P_65
set_property -dict {PACKAGE_PIN AH3  IOSTANDARD LVCOMOS18} [get_ports adc_db[4]]        ; ## D12  FMC1_LA05_N      IO_L20N_T3L_N3_AD1N_65
set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCOMOS18} [get_ports adc_db[5]]        ; ## H8   FMC1_LA02_N      IO_L23N_T3U_N9_65
set_property -dict {PACKAGE_PIN AJ2  IOSTANDARD LVCOMOS18} [get_ports adc_db[6]]        ; ## C11  FMC1_LA06_N      IO_L19N_T3L_N1_DBC_AD9N_65
set_property -dict {PACKAGE_PIN AF5  IOSTANDARD LVCOMOS18} [get_ports adc_db[7]]        ; ## G7   FMC1_LA00_CC_N   IO_L13N_T2L_N1_GC_QBC_65
set_property -dict {PACKAGE_PIN AG3  IOSTANDARD LVCOMOS18} [get_ports adc_db[8]]        ; ## D11  FMC1_LA05_P      IO_L20P_T3L_N2_AD1P_65
set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVCOMOS18} [get_ports adc_db[9]]        ; ## H7   FMC1_LA02_P      IO_L23P_T3U_N8_I2C_SCLK_65
set_property -dict {PACKAGE_PIN AH2  IOSTANDARD LVCOMOS18} [get_ports adc_db[10]]       ; ## C10  FMC1_LA06_P      IO_L19P_T3L_N0_DBC_AD9P_65
set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCOMOS18} [get_ports adc_db[11]]       ; ## G6   FMC1_LA00_CC_P   IO_L13P_T2L_N0_GC_QBC_65
set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVCOMOS18} [get_ports adc_db[12]]       ; ## D9   FMC1_LA01_CC_N   IO_L16N_T2U_N7_QBC_AD3N_65
set_property -dict {PACKAGE_PIN AF7  IOSTANDARD LVCOMOS18} [get_ports adc_db[13]]       ; ## H5   FMC1_CLK0_M2C_N  IO_L12N_T1U_N11_GC_65
set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVCOMOS18} [get_ports adc_db[14]]       ; ## H4   FMC1_CLK0_M2C_P  IO_L12P_T1U_N10_GC_65
set_property -dict {PACKAGE_PIN AJ6  IOSTANDARD LVCOMOS18} [get_ports adc_db[15]]       ; ## D8   FMC1_LA01_CC_P   IO_L16P_T2U_N6_QBC_AD3P_65

set_property -dict {PACKAGE_PIN AJ1  IOSTANDARD LVCOMOS18} [get_ports adc_rd_n]         ; ## G10  FMC1_LA03_N      IO_L22N_T3U_N7_DBC_AD0N_65
set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCOMOS18} [get_ports adc_wr_n]         ; ## D15  FMC1_LA09_N      IO_L24N_T3U_N11_PERSTN0_65

set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCOMOS18} [get_ports adc_cnvst]        ; ## H28  FMC1_LA24_P      IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCOMOS18} [get_ports adc_chsel[0]]     ; ## H26  FMC1_LA21_N      IO_L1N_T0L_N1_DBC_66
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCOMOS18} [get_ports adc_chsel[1]]     ; ## D27  FMC1_LA26_N      IO_L4N_T0U_N7_DBC_AD7N_67
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCOMOS18} [get_ports adc_chsel[2]]     ; ## G27  FMC1_LA25_P      IO_L1P_T0L_N0_DBC_65
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCOMOS18} [get_ports adc_hw_rngsel[0]] ; ## H25  FMC1_LA21_P      IO_L1P_T0L_N0_DBC_66
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCOMOS18} [get_ports adc_hw_rngsel[1]] ; ## D26  FMC1_LA26_P      IO_L4P_T0U_N6_DBC_AD7P_67
set_property -dict {PACKAGE_PIN AJ4  IOSTANDARD LVCOMOS18} [get_ports adc_busy]         ; ## C15  FMC1_LA10_N      IO_L15N_T2L_N5_AD11N_65
set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCOMOS18} [get_ports adc_seq_en]       ; ## C26  FMC1_LA27_P      IO_L3P_T0L_N4_AD15P_67
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCOMOS18} [get_ports adc_reset_n]      ; ## G25  FMC1_LA22_N      IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN AF1  IOSTANDARD LVCOMOS18} [get_ports adc_cs_n]         ; ## H11  FMC1_LA04_N      IO_L21N_T3L_N5_AD8N_65

