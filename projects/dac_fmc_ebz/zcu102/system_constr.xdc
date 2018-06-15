
# DAC FMC signals

set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p[0]]  ; ## D08  FMC_HPC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66_AB4
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n[0]]  ; ## D09  FMC_HPC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66_AC4
set_property  -dict {PACKAGE_PIN  V2  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p[1]]  ; ## H08  FMC_HPC0_LA02_P           IO_L23P_T3U_N8_66_V2
set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n[1]]  ; ## H09  FMC_HPC0_LA02_N           IO_L23N_T3U_N9_66_V1
set_property  -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]   ; ## G06  FMC_HPC0_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_66_Y4
set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]   ; ## G07  FMC_HPC0_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_66_Y3

set_property  -dict {PACKAGE_PIN  AA1 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                      ; ## H11  FMC_HPC0_LA04_N           IO_L21N_T3L_N5_AD8N_66_AA1
set_property  -dict {PACKAGE_PIN  AB3 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                      ; ## D11  FMC_HPC0_LA05_P           IO_L20P_T3L_N2_AD1P_66_AB3
set_property  -dict {PACKAGE_PIN  AA2 IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## H10  FMC_HPC0_LA04_P           IO_L21P_T3L_N4_AD8P_66_AA2
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## G10  FMC_HPC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66_Y1
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## G09  FMC_HPC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66_Y2
set_property  -dict {PACKAGE_PIN  AC3 IOSTANDARD LVCMOS18} [get_ports spi_en]                           ; ## D12  FMC_HPC0_LA05_N           IO_L20N_T3L_N3_AD1N_66_AC3
# For AD916(1,2,3,4)-FMC-EBZ
set_property  -dict {PACKAGE_PIN  W2  IOSTANDARD LVCMOS18} [get_ports spi_csn_clk2]                     ; ## D14  FMC_HPC_LA09_P            IO_L10P_T1_11

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_property  -dict {PACKAGE_PIN  U5  IOSTANDARD LVCMOS18} [get_ports dac_ctrl[0]]                      ; ## H13  FMC_HPC0_LA07_P           IO_L18P_T2U_N10_AD2P_66_U5
set_property  -dict {PACKAGE_PIN  U4  IOSTANDARD LVCMOS18} [get_ports dac_ctrl[3]]                      ; ## H14  FMC_HPC0_LA07_N           IO_L18N_T2U_N11_AD2N_66_U4

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_property  -dict {PACKAGE_PIN  AC2 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[1]]                      ; ## C10  FMC_HPC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66_AC2
set_property  -dict {PACKAGE_PIN  AC1 IOSTANDARD LVCMOS18} [get_ports dac_ctrl[2]]                      ; ## C11  FMC_HPC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66_AC1
# For AD916(1,2,3,4)-FMC-EBZ
set_property  -dict {PACKAGE_PIN  W1  IOSTANDARD LVCMOS18} [get_ports dac_ctrl[4]]                      ; ## D15  FMC_HPC_LA09_P            IO_L10N_T1_11

set_property  -dict {PACKAGE_PIN  G8} [get_ports tx_ref_clk_p]                                          ; ## D04  FMC_HPC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229_G8
set_property  -dict {PACKAGE_PIN  G7} [get_ports tx_ref_clk_n]                                          ; ## D05  FMC_HPC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229_G7

set_property  -quiet -dict {PACKAGE_PIN  G3} [get_ports tx_data_n[7]]                                   ; ## C03  FMC_HPC0_DP0_C2M_N        MGTHTXN2_229_G3
set_property  -quiet -dict {PACKAGE_PIN  G4} [get_ports tx_data_p[7]]                                   ; ## C02  FMC_HPC0_DP0_C2M_P        MGTHTXP2_229_G4
set_property  -quiet -dict {PACKAGE_PIN  H5} [get_ports tx_data_n[6]]                                   ; ## A23  FMC_HPC0_DP1_C2M_N        MGTHTXN1_229_H5
set_property  -quiet -dict {PACKAGE_PIN  H6} [get_ports tx_data_p[6]]                                   ; ## A22  FMC_HPC0_DP1_C2M_P        MGTHTXP1_229_H6
set_property  -quiet -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[5]]                                   ; ## A27  FMC_HPC0_DP2_C2M_N        MGTHTXN3_229_F5
set_property  -quiet -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[5]]                                   ; ## A26  FMC_HPC0_DP2_C2M_P        MGTHTXP3_229_F6
set_property  -quiet -dict {PACKAGE_PIN  K5} [get_ports tx_data_n[4]]                                   ; ## A31  FMC_HPC0_DP3_C2M_N        MGTHTXN0_229_K5
set_property  -quiet -dict {PACKAGE_PIN  K6} [get_ports tx_data_p[4]]                                   ; ## A30  FMC_HPC0_DP3_C2M_P        MGTHTXP0_229_K6
set_property  -quiet -dict {PACKAGE_PIN  M6} [get_ports tx_data_p[2]]                                   ; ## A34  FMC_HPC0_DP4_C2M_P        MGTHTXP3_228_M6
set_property  -quiet -dict {PACKAGE_PIN  M5} [get_ports tx_data_n[2]]                                   ; ## A35  FMC_HPC0_DP4_C2M_N        MGTHTXN3_228_M5
set_property  -quiet -dict {PACKAGE_PIN  P6} [get_ports tx_data_p[0]]                                   ; ## A38  FMC_HPC0_DP5_C2M_P        MGTHTXP1_228_P6
set_property  -quiet -dict {PACKAGE_PIN  P5} [get_ports tx_data_n[0]]                                   ; ## A39  FMC_HPC0_DP5_C2M_N        MGTHTXN1_228_P5
set_property  -quiet -dict {PACKAGE_PIN  R4} [get_ports tx_data_p[1]]                                   ; ## B36  FMC_HPC0_DP6_C2M_P        MGTHTXP0_228_R4
set_property  -quiet -dict {PACKAGE_PIN  R3} [get_ports tx_data_n[1]]                                   ; ## B37  FMC_HPC0_DP6_C2M_N        MGTHTXN0_228_R3
set_property  -quiet -dict {PACKAGE_PIN  N4} [get_ports tx_data_p[3]]                                   ; ## B32  FMC_HPC0_DP7_C2M_P        MGTHTXP2_228_N4
set_property  -quiet -dict {PACKAGE_PIN  N3} [get_ports tx_data_n[3]]                                   ; ## B33  FMC_HPC0_DP7_C2M_N        MGTHTXN2_228_N3

# PL PMOD 1 header
set_property  -dict {PACKAGE_PIN  D20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]                     ; ## PMOD1_0                        IO_L8N_HDGC_AD4N_47_D20
set_property  -dict {PACKAGE_PIN  E20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]                     ; ## PMOD1_1                        IO_L8P_HDGC_AD4P_47_E20
set_property  -dict {PACKAGE_PIN  D22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi]                    ; ## PMOD1_2                        IO_L7N_HDGC_AD5N_47_D22
set_property  -dict {PACKAGE_PIN  E22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso]                    ; ## PMOD1_3                        IO_L7P_HDGC_AD5P_47_E22
set_property  -dict {PACKAGE_PIN  F20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[0]]                     ; ## PMOD1_4                        IO_L6N_HDGC_AD6N_47_F20
set_property  -dict {PACKAGE_PIN  G20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[1]]                     ; ## PMOD1_5                        IO_L6P_HDGC_AD6P_47_G20
set_property  -dict {PACKAGE_PIN  J20 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[2]]                     ; ## PMOD1_6                        IO_L4N_AD8N_47_J20
set_property  -dict {PACKAGE_PIN  J19 IOSTANDARD LVCMOS33} [get_ports pmod_gpio[3]]                     ; ## PMOD1_7                        IO_L4P_AD8P_47_J19

# clocks

# Max lane rate of 15.4 Gbps
create_clock -name tx_ref_clk   -period  2.597 [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay, 
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
set_input_delay -clock [get_clocks tx_ref_clk] \
  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] \
  [get_ports {tx_sysref_*}]
