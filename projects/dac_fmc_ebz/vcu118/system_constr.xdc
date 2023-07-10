###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# DAC FMC signals

set_property  -dict {PACKAGE_PIN  AL30 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p[0]]  ; ## D08  FMCP_HSPC_LA01_CC_P       IO_L16P_T2U_N6_QBC_AD3P_43
set_property  -dict {PACKAGE_PIN  AL31 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n[0]]  ; ## D09  FMCP_HSPC_LA01_CC_N       IO_L16N_T2U_N7_QBC_AD3N_43
set_property  -dict {PACKAGE_PIN  AJ32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p[1]]  ; ## H07  FMCP_HSPC_LA02_P          IO_L14P_T2L_N2_GC_43
set_property  -dict {PACKAGE_PIN  AK32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n[1]]  ; ## H08  FMCP_HSPC_LA02_N          IO_L14N_T2L_N3_GC_43
set_property  -dict {PACKAGE_PIN  AL35 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]   ; ## G06  FMCP_HSPC_LA00_CC_P       IO_L7P_T1L_N0_QBC_AD13P_43
set_property  -dict {PACKAGE_PIN  AL36 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]   ; ## G07  FMCP_HSPC_LA00_CC_N       IO_L7N_T1L_N1_QBC_AD13N_43

set_property  -dict {PACKAGE_PIN  AT37 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                      ; ## H11  FMCP_HSPC_LA04_N          IO_L6N_T0U_N11_AD6N_43
set_property  -dict {PACKAGE_PIN  AP38 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                      ; ## D11  FMCP_HSPC_LA05_P          IO_L1P_T0L_N0_DBC_43 
set_property  -dict {PACKAGE_PIN  AR37 IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## H10  FMCP_HSPC_LA04_P          IO_L6P_T0U_N10_AD6P_43 
set_property  -dict {PACKAGE_PIN  AT40 IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## G10  FMCP_HSPC_LA03_N          IO_L4N_T0U_N7_DBC_AD7N_43
set_property  -dict {PACKAGE_PIN  AT39 IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## G09  FMCP_HSPC_LA03_P          IO_L4P_T0U_N6_DBC_AD7P_43
set_property  -dict {PACKAGE_PIN  AR38 IOSTANDARD LVCMOS18} [get_ports spi_en]                           ; ## D12  FMCP_HSPC_LA05_N          IO_L1N_T0L_N1_DBC_43
# For AD916(1,2,3,4)-FMC-EBZ
set_property  -dict {PACKAGE_PIN  AJ33 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk2]                     ; ## D14  FMCP_HSPC_LA09_P          IO_L19P_T3L_N0_DBC_AD9P_43 

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_property  -dict {PACKAGE_PIN  AP36 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[0]]                      ; ## H13  FMCP_HSPC_LA07_P          IO_L5P_T0U_N8_AD14P_43
set_property  -dict {PACKAGE_PIN  AP37 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[3]]                      ; ## H14  FMCP_HSPC_LA07_N          IO_L5N_T0U_N9_AD14N_43

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_property  -dict {PACKAGE_PIN  AT35 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[1]]                      ; ## C10  FMCP_HSPC_LA06_P          IO_L2P_T0L_N2_43
set_property  -dict {PACKAGE_PIN  AT36 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[2]]                      ; ## C11  FMCP_HSPC_LA06_N          IO_L2N_T0L_N3_43
# For AD916(1,2,3,4)-FMC-EBZ
set_property  -dict {PACKAGE_PIN  AK33 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[4]]                      ; ## D15  FMCP_HSPC_LA09_N          IO_L19N_T3L_N1_DBC_AD9N_43

set_property  -dict {PACKAGE_PIN  AK38} [get_ports tx_ref_clk_121_p]                                     ; ## D04  FMCP_HSPC_GBT0_0_P        MGTREFCLK0P_121
set_property  -dict {PACKAGE_PIN  AK39} [get_ports tx_ref_clk_121_n]                                     ; ## D05  FMCP_HSPC_GBT0_0_N        MGTREFCLK0N_121
set_property  -dict {PACKAGE_PIN  V38 } [get_ports tx_ref_clk_126_p]                                     ; ## D04  FMCP_HSPC_GBT0_1_P        MGTREFCLK0P_126
set_property  -dict {PACKAGE_PIN  V39 } [get_ports tx_ref_clk_126_n]                                     ; ## D05  FMCP_HSPC_GBT0_1_N        MGTREFCLK0N_126

set_property  -dict {PACKAGE_PIN  AT43} [get_ports tx_data_n[7]]                                         ; ## C03  FMCP_HSPC_DP0_C2M_N       MGTYTXN0_121
set_property  -dict {PACKAGE_PIN  AT42} [get_ports tx_data_p[7]]                                         ; ## C02  FMCP_HSPC_DP0_C2M_P       MGTYTXP0_121
set_property  -dict {PACKAGE_PIN  AP43} [get_ports tx_data_n[6]]                                         ; ## A23  FMCP_HSPC_DP1_C2M_N       MGTYTXN1_121
set_property  -dict {PACKAGE_PIN  AP42} [get_ports tx_data_p[6]]                                         ; ## A22  FMCP_HSPC_DP1_C2M_P       MGTYTXP1_121
set_property  -dict {PACKAGE_PIN  AM43} [get_ports tx_data_n[5]]                                         ; ## A27  FMCP_HSPC_DP2_C2M_N       MGTYTXN2_121
set_property  -dict {PACKAGE_PIN  AM42} [get_ports tx_data_p[5]]                                         ; ## A26  FMCP_HSPC_DP2_C2M_P       MGTYTXP2_121
set_property  -dict {PACKAGE_PIN  AL41} [get_ports tx_data_n[4]]                                         ; ## A31  FMCP_HSPC_DP3_C2M_N       MGTYTXN3_121
set_property  -dict {PACKAGE_PIN  AL40} [get_ports tx_data_p[4]]                                         ; ## A30  FMCP_HSPC_DP3_C2M_P       MGTYTXP3_121
set_property  -dict {PACKAGE_PIN  T42}  [get_ports tx_data_p[2]]                                         ; ## A34  FMCP_HSPC_DP4_C2M_P       MGTYTXP0_126
set_property  -dict {PACKAGE_PIN  T43}  [get_ports tx_data_n[2]]                                         ; ## A35  FMCP_HSPC_DP4_C2M_N       MGTYTXN0_126
set_property  -dict {PACKAGE_PIN  P42}  [get_ports tx_data_p[0]]                                         ; ## A38  FMCP_HSPC_DP5_C2M_P       MGTYTXP1_126
set_property  -dict {PACKAGE_PIN  P43}  [get_ports tx_data_n[0]]                                         ; ## A39  FMCP_HSPC_DP5_C2M_N       MGTYTXN1_126
set_property  -dict {PACKAGE_PIN  M42}  [get_ports tx_data_p[1]]                                         ; ## B36  FMCP_HSPC_DP6_C2M_P       MGTYTXP2_126
set_property  -dict {PACKAGE_PIN  M43}  [get_ports tx_data_n[1]]                                         ; ## B37  FMCP_HSPC_DP6_C2M_N       MGTYTXN2_126
set_property  -dict {PACKAGE_PIN  K42}  [get_ports tx_data_p[3]]                                         ; ## B32  FMCP_HSPC_DP7_C2M_P       MGTYTXP3_126
set_property  -dict {PACKAGE_PIN  K43}  [get_ports tx_data_n[3]]                                         ; ## B33  FMCP_HSPC_DP7_C2M_N       MGTYTXN3_126

# PL PMOD 1 header
# set_property  -dict {PACKAGE_PIN  AY14 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]                     ; ## PMOD0_0_LS                     IO_L10N_T1U_N7_QBC_AD4N_67
# set_property  -dict {PACKAGE_PIN  AY15 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]                     ; ## PMOD0_1_LS                     IO_L10P_T1U_N6_QBC_AD4P_67
# set_property  -dict {PACKAGE_PIN  AW15 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi]                    ; ## PMOD0_2_LS                     IO_L9N_T1L_N5_AD12N_67
# set_property  -dict {PACKAGE_PIN  AV15 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso]                    ; ## PMOD0_3_LS                     IO_L9P_T1L_N4_AD12P_67
# set_property  -dict {PACKAGE_PIN  AV16 IOSTANDARD LVCMOS18} [get_ports pmod_gpio[0]]                     ; ## PMOD0_4_LS                     IO_L8N_T1L_N3_AD5N_67
# set_property  -dict {PACKAGE_PIN  AU16 IOSTANDARD LVCMOS18} [get_ports pmod_gpio[1]]                     ; ## PMOD0_5_LS                     IO_L8P_T1L_N2_AD5P_67
# set_property  -dict {PACKAGE_PIN  AT15 IOSTANDARD LVCMOS18} [get_ports pmod_gpio[2]]                     ; ## PMOD0_6_LS                     IO_L7N_T1L_N1_QBC_AD13N_67
# set_property  -dict {PACKAGE_PIN  AT16 IOSTANDARD LVCMOS18} [get_ports pmod_gpio[3]]                     ; ## PMOD0_7_LS                     IO_L7P_T1L_N0_QBC_AD13P_67

# clocks

# Max lane rate of 15.4 Gbps
create_clock -name tx_ref_clk_121   -period  2.597 [get_ports tx_ref_clk_121_p]
create_clock -name tx_ref_clk_126   -period  2.597 [get_ports tx_ref_clk_126_p]

# For transceiver output clocks use reference clock
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]
