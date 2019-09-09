#
## dual_ad9208
#

#
##                                                                                                                   FMCp_PORT      FPGA_IO
#
set_property  -dict {PACKAGE_PIN AK38} [get_ports  rx_ref_clk_0_p]                                            ; ##   GBTCLK0_M2C_P  MGTREFCLK0P_121
set_property  -dict {PACKAGE_PIN AK39} [get_ports  rx_ref_clk_0_n]                                            ; ##   GBTCLK0_M2C_N  MGTREFCLK0N_121
set_property  -dict {PACKAGE_PIN AR45} [get_ports  rx_data_p[0]]                                              ; ##   DP0_M2C_P      MGTYRXP0_121
set_property  -dict {PACKAGE_PIN AR46} [get_ports  rx_data_n[0]]                                              ; ##   DP0_M2C_N      MGTYRXN0_121
set_property  -dict {PACKAGE_PIN AN45} [get_ports  rx_data_p[1]]                                              ; ##   DP1_M2C_P      MGTYRXP1_121
set_property  -dict {PACKAGE_PIN AN46} [get_ports  rx_data_n[1]]                                              ; ##   DP1_M2C_N      MGTYRXN1_121
set_property  -dict {PACKAGE_PIN AL45} [get_ports  rx_data_p[2]]                                              ; ##   DP2_M2C_P      MGTYRXP2_121
set_property  -dict {PACKAGE_PIN AL46} [get_ports  rx_data_n[2]]                                              ; ##   DP2_M2C_N      MGTYRXN2_121
set_property  -dict {PACKAGE_PIN AJ45} [get_ports  rx_data_p[3]]                                              ; ##   DP3_M2C_P      MGTYRXP3_121
set_property  -dict {PACKAGE_PIN AJ46} [get_ports  rx_data_n[3]]                                              ; ##   DP3_M2C_N      MGTYRXN3_121
set_property  -dict {PACKAGE_PIN AG45} [get_ports  rx_data_p[8]]                                              ; ##   DP8_M2C_P      MGTYRXP0_122
set_property  -dict {PACKAGE_PIN AG46} [get_ports  rx_data_n[8]]                                              ; ##   DP8_M2C_N      MGTYRXN0_122
set_property  -dict {PACKAGE_PIN AF43} [get_ports  rx_data_p[9]]                                              ; ##   DP9_M2C_P      MGTYRXP1_122
set_property  -dict {PACKAGE_PIN AF44} [get_ports  rx_data_n[9]]                                              ; ##   DP9_M2C_N      MGTYRXN1_122
set_property  -dict {PACKAGE_PIN AE45} [get_ports  rx_data_p[10]]                                             ; ##   DP10_M2C_P     MGTYRXP2_122
set_property  -dict {PACKAGE_PIN AE46} [get_ports  rx_data_n[10]]                                             ; ##   DP10_M2C_N     MGTYRXN2_122
set_property  -dict {PACKAGE_PIN AD43} [get_ports  rx_data_p[11]]                                             ; ##   DP11_M2C_P     MGTYRXP3_122
set_property  -dict {PACKAGE_PIN AD44} [get_ports  rx_data_n[11]]                                             ; ##   DP11_M2C_N     MGTYRXN3_122
set_property  -dict {PACKAGE_PIN V38}  [get_ports  rx_ref_clk_1_p]                                            ; ##   GBTCLK0_M2C_P  MGTREFCLK0P_126
set_property  -dict {PACKAGE_PIN V39}  [get_ports  rx_ref_clk_1_n]                                            ; ##   GBTCLK0_M2C_N  MGTREFCLK0N_126
set_property  -dict {PACKAGE_PIN W45}  [get_ports  rx_data_p[4]]                                              ; ##   DP4_M2C_P      MGTYRXP0_126
set_property  -dict {PACKAGE_PIN W46}  [get_ports  rx_data_n[4]]                                              ; ##   DP4_M2C_N      MGTYRXN0_126
set_property  -dict {PACKAGE_PIN U45}  [get_ports  rx_data_p[5]]                                              ; ##   DP5_M2C_P      MGTYRXP1_126
set_property  -dict {PACKAGE_PIN U46}  [get_ports  rx_data_n[5]]                                              ; ##   DP5_M2C_N      MGTYRXN1_126
set_property  -dict {PACKAGE_PIN R45}  [get_ports  rx_data_p[6]]                                              ; ##   DP6_M2C_P      MGTYRXP2_126
set_property  -dict {PACKAGE_PIN R46}  [get_ports  rx_data_n[6]]                                              ; ##   DP6_M2C_N      MGTYRXN2_126
set_property  -dict {PACKAGE_PIN N45}  [get_ports  rx_data_p[7]]                                              ; ##   DP7_M2C_P      MGTYRXP3_126
set_property  -dict {PACKAGE_PIN N46}  [get_ports  rx_data_n[7]]                                              ; ##   DP7_M2C_N      MGTYRXN3_126
set_property  -dict {PACKAGE_PIN AC45} [get_ports  rx_data_p[12]]                                             ; ##   DP12_M2C_P     MGTYRXP0_125
set_property  -dict {PACKAGE_PIN AC46} [get_ports  rx_data_n[12]]                                             ; ##   DP12_M2C_N     MGTYRXN0_125
set_property  -dict {PACKAGE_PIN AB43} [get_ports  rx_data_p[13]]                                             ; ##   DP13_M2C_P     MGTYRXP1_125
set_property  -dict {PACKAGE_PIN AB44} [get_ports  rx_data_n[13]]                                             ; ##   DP13_M2C_N     MGTYRXN1_125
set_property  -dict {PACKAGE_PIN AA45} [get_ports  rx_data_p[14]]                                             ; ##   DP14_M2C_P     MGTYRXP2_125
set_property  -dict {PACKAGE_PIN AA46} [get_ports  rx_data_n[14]]                                             ; ##   DP14_M2C_N     MGTYRXN2_125
set_property  -dict {PACKAGE_PIN Y43}  [get_ports  rx_data_p[15]]                                             ; ##   DP15_M2C_P     MGTYRXP3_125
set_property  -dict {PACKAGE_PIN Y44}  [get_ports  rx_data_n[15]]                                             ; ##   DP15_M2C_N     MGTYRXN3_125
set_property  -dict {PACKAGE_PIN AF38} [get_ports  glbl_clk_0_p]                                              ; ##   GBTCLK2_M2C_P  MGTREFCLK0P_122
set_property  -dict {PACKAGE_PIN AF39} [get_ports  glbl_clk_0_n]                                              ; ##   GBTCLK2_M2C_N  MGTREFCLK0N_122
set_property  -dict {PACKAGE_PIN AJ32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports  rx_sysref_0_p]      ; ##   LA02_P         IO_L14P_T2L_N2_GC_43
set_property  -dict {PACKAGE_PIN AK32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports  rx_sysref_0_n]      ; ##   LA02_N         IO_L14N_T2L_N3_GC_43
set_property  -dict {PACKAGE_PIN AR37 IOSTANDARD LVDS} [get_ports  rx_sync_0_p]                               ; ##   LA04_P         IO_L6P_T0U_N10_AD6P_43
set_property  -dict {PACKAGE_PIN AT37 IOSTANDARD LVDS} [get_ports  rx_sync_0_n]                               ; ##   LA04_N         IO_L6N_T0U_N11_AD6N_43
set_property  -dict {PACKAGE_PIN AL30 IOSTANDARD LVDS} [get_ports  glbl_clk_1_p]                              ; ##   LA01_P_CC      IO_L16P_T2U_N6_QBC_AD3P_43
set_property  -dict {PACKAGE_PIN AL31 IOSTANDARD LVDS} [get_ports  glbl_clk_1_n]                              ; ##   LA01_N_CC      IO_L16N_T2U_N7_QBC_AD3N_43
set_property  -dict {PACKAGE_PIN AT39 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports  rx_sysref_1_p]      ; ##   LA03_P         IO_L4P_T0U_N6_DBC_AD7P_43
set_property  -dict {PACKAGE_PIN AT40 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports  rx_sysref_1_n]      ; ##   LA03_N         IO_L4N_T0U_N7_DBC_AD7N_43
set_property  -dict {PACKAGE_PIN AP38 IOSTANDARD LVDS} [get_ports  rx_sync_1_p]                               ; ##   LA05_P         IO_L1P_T0L_N0_DBC_43
set_property  -dict {PACKAGE_PIN AR38 IOSTANDARD LVDS} [get_ports  rx_sync_1_n]                               ; ##   LA05_N         IO_L1N_T0L_N1_DBC_43
set_property  -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS18} [get_ports  spi_clk]                               ; ##   LA06_P         IO_L2P_T0L_N2_43
set_property  -dict {PACKAGE_PIN AT36 IOSTANDARD LVCMOS18} [get_ports  spi_sdio]                              ; ##   LA06_N         IO_L2N_T0L_N3_43
set_property  -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18} [get_ports  spi_csn_clk]                           ; ##   LA07_P         IO_L5P_T0U_N8_AD14P_43
set_property  -dict {PACKAGE_PIN AP37 IOSTANDARD LVCMOS18} [get_ports  spi_csn_adc0]                          ; ##   LA07_N         IO_L5N_T0U_N9_AD14N_43
set_property  -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18} [get_ports  spi_csn_adc1]                          ; ##   LA08_P         IO_L18P_T2U_N10_AD2P_43
set_property  -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18} [get_ports  adc0_fda]                              ; ##   LA09_N         IO_L19N_T3L_N1_DBC_AD9N_43
set_property  -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18} [get_ports  adc0_fdb]                              ; ##   LA10_N         IO_L3N_T0L_N5_AD15N_43
set_property  -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18} [get_ports  adc0_gpio_a1]                          ; ##   LA11_N         IO_L17N_T2U_N9_AD10N_43
set_property  -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18} [get_ports  adc0_gpio_b1]                          ; ##   LA12_N         IO_L21N_T3L_N5_AD8N_43
set_property  -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18} [get_ports  adc0_pdwn]                             ; ##   LA08_N         IO_L18N_T2U_N11_AD2N_43
set_property  -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18} [get_ports  adc1_fda]                              ; ##   LA10_P         IO_L3P_T0L_N4_AD15P_43
set_property  -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18} [get_ports  adc1_fdb]                              ; ##   LA11_P         IO_L17P_T2U_N8_AD10P_43
set_property  -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18} [get_ports  adc1_gpio_a1]                          ; ##   LA12_P         IO_L21P_T3L_N4_AD8P_43
set_property  -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18} [get_ports  adc1_gpio_b1]                          ; ##   LA13_P         IO_L20P_T3L_N2_AD1P_43
set_property  -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18} [get_ports  adc1_pdwn]                             ; ##   LA09_P         IO_L19P_T3L_N0_DBC_AD9P_43
set_property  -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18} [get_ports  hmc_sync_req]                          ; ##   LA13_N         IO_L20N_T3L_N3_AD1N_43


# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB
create_clock -name rx_ref_clk_0   -period  1.33 [get_ports rx_ref_clk_0_p]
create_clock -name rx_ref_clk_1   -period  1.33 [get_ports rx_ref_clk_1_p]

# The Global clock is routed from the REFCLK1 of the dual_ad9208 board
# since GLBLCLK0 and GLBLCLK1 are not connected to global clock capable pins.
create_clock -name global_clk_0   -period  2.66 [get_ports glbl_clk_0_p]


# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
set_input_delay -clock [get_clocks global_clk_0] \
  [expr [get_property PERIOD [get_clocks global_clk_0]] / 2] \
  [get_ports {rx_sysref_*}]

