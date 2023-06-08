###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9083

set_property  -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports glblclk_p] ; ## G6 FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports glblclk_n] ; ## G7 FMC_HPC0_LA00_CC_N

set_property  -dict {PACKAGE_PIN  G8}                                                       [get_ports ref_clk0_p]        ; ## D4  FMC_HPC0 GBTCLK0 M2C_C_P
set_property  -dict {PACKAGE_PIN  G7}                                                       [get_ports ref_clk0_n]        ; ## D5  FMC_HPC0_GBTCLK0_M2C_C_N

set_property  -dict {PACKAGE_PIN  H2}                                                       [get_ports rx_data_p[0]]      ; ## C6  FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1}                                                       [get_ports rx_data_n[0]]      ; ## C7  FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  J4}                                                       [get_ports rx_data_p[1]]      ; ## A2  FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3}                                                       [get_ports rx_data_n[1]]      ; ## A3  FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2}                                                       [get_ports rx_data_p[2]]      ; ## A6  FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1}                                                       [get_ports rx_data_n[2]]      ; ## A7  FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  K2}                                                       [get_ports rx_data_p[3]]      ; ## A10 FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1}                                                       [get_ports rx_data_n[3]]      ; ## A11 FMC_HPC0_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  U4  IOSTANDARD  LVCMOS18}                                 [get_ports spi_csn_clk]       ; ## H14 FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  V2  IOSTANDARD  LVCMOS18}                                 [get_ports spi_csn_adc]       ; ## H7  FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD  LVCMOS18}                                 [get_ports spi_clk]           ; ## D8  FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD  LVCMOS18}                                 [get_ports spi_sdio]          ; ## D9  FMC_HPC0_LA01_CC_N
set_property  -dict {PACKAGE_PIN  M10 IOSTANDARD  LVCMOS18}                                 [get_ports spi_sdo]           ; ## C26 FMC_HPC0_LA27_P


set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD  LVCMOS18}                                 [get_ports pwdn]              ; ## H8  FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  U5  IOSTANDARD  LVCMOS18}                                 [get_ports rstb]              ; ## H13 FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD  LVCMOS18 PULLTYPE PULLUP}                 [get_ports adc_lvsft_en]      ; ## G9  FMC_HPC0_LA03_P

set_property  -dict {PACKAGE_PIN  AA2 IOSTANDARD  LVDS}                                     [get_ports rx_sync_p]         ; ## H10 FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1 IOSTANDARD  LVDS}                                     [get_ports rx_sync_n]         ; ## H11 FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  V4  IOSTANDARD  LVDS}                                     [get_ports sysref_p]          ; ## G12 FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  V3  IOSTANDARD  LVDS}                                     [get_ports sysref_n]          ; ## G13 FMC_HPC0_LA08_N

set_property  -dict {PACKAGE_PIN  AB6  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_1]     ; ## H16 FMC_HPC0_LA11_P
set_property  -dict {PACKAGE_PIN  AB5  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_2]     ; ## H17 FMC_HPC0_LA11_N
set_property  -dict {PACKAGE_PIN  Y10  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_3]     ; ## H19 FMC_HPC0_LA15_P
set_property  -dict {PACKAGE_PIN  Y9   IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_4]     ; ## H20 FMC_HPC0_LA15_N
set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_5]     ; ## H22 FMC_HPC0_LA19_P
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_6]     ; ## H23 FMC_HPC0_LA19_N
set_property  -dict {PACKAGE_PIN  P12  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_7]     ; ## H25 FMC_HPC0_LA21_P
set_property  -dict {PACKAGE_PIN  N12  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports adl5960_temp_8]     ; ## H26 FMC_HPC0_LA21_N

set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw0 ]          ; ## D11 FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw1 ]          ; ## D12 FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN  W2   IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw2 ]          ; ## D14 FMC_HPC0_LA09_P
set_property  -dict {PACKAGE_PIN  W1   IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw3_v1]        ; ## D15 FMC_HPC0_LA09_N
set_property  -dict {PACKAGE_PIN  AB8  IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw3_v2]        ; ## D17 FMC_HPC0_LA13_P
set_property  -dict {PACKAGE_PIN  AC8  IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw4_v1]        ; ## D18 FMC_HPC0_LA13_N
set_property  -dict {PACKAGE_PIN  P11  IOSTANDARD LVCMOS18}                                 [get_ports gpio_sw4_v2]        ; ## D20 FMC_HPC0_LA17_P_CC

set_property  -dict {PACKAGE_PIN  N11  IOSTANDARD LVCMOS18}                                 [get_ports adl5960x_sync1]     ; ## D21 FMC_HPC0_LA17_N_CC

set_property  -dict {PACKAGE_PIN  Y12  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus0_sck]       ; ## G18 FMC_HPC0_LA16_P
set_property  -dict {PACKAGE_PIN  W7   IOSTANDARD LVCMOS18}                                 [get_ports spi_bus0_sdi]       ; ## G15 FMC_HPC0_LA12_P
set_property  -dict {PACKAGE_PIN  W6   IOSTANDARD LVCMOS18}                                 [get_ports spi_bus0_sdo]       ; ## G16 FMC_HPC0_LA12_N
set_property  -dict {PACKAGE_PIN  AA12 IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports clkd_lvsft_en]      ; ## G19 FMC_HPC0_LA16_N

set_property  -dict {PACKAGE_PIN  N13  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus0_csn_f2]    ; ## G21 FMC_HPC0_LA20_P
set_property  -dict {PACKAGE_PIN  M13  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus0_csn_sen]   ; ## G22 FMC_HPC0_LA20_N

set_property  -dict {PACKAGE_PIN  M11  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus1_sck]       ; ## G27 FMC_HPC0_LA25_P
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus1_sdi]       ; ## G24 FMC_HPC0_LA22_P
set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus1_sdo]       ; ## G25 FMC_HPC0_LA22_N
set_property  -dict {PACKAGE_PIN  L11  IOSTANDARD LVCMOS18}                                 [get_ports spi_bus1_csn_dat1]  ; ## G28 FMC_HPC0_LA25_N
set_property  -dict {PACKAGE_PIN  U9   IOSTANDARD LVCMOS18}                                 [get_ports spi_bus1_csn_dat2]  ; ## G30 FMC_HPC0_LA29_P

set_property  -dict {PACKAGE_PIN  L16  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_sck]  ; ## D23 FMC_HPC0_LA23_P
set_property  -dict {PACKAGE_PIN  K16  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_sdio] ; ## D24 FMC_HPC0_LA23_N
set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_csn1] ; ## D26 FMC_HPC0_LA26_P
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_csn2] ; ## D27 FMC_HPC0_LA26_N
set_property  -dict {PACKAGE_PIN  AC2  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_csn3] ; ## C10 FMC_HPC0_LA06_P
set_property  -dict {PACKAGE_PIN  AC1  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_1_csn4] ; ## C11 FMC_HPC0_LA06_N

set_property  -dict {PACKAGE_PIN  W5   IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_sck]  ; ## C14 FMC_HPC0_LA10_P
set_property  -dict {PACKAGE_PIN  W4   IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_sdio] ; ## C15 FMC_HPC0_LA10_N
set_property  -dict {PACKAGE_PIN  AC7  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_csn5] ; ## C18 FMC_HPC0_LA14_P
set_property  -dict {PACKAGE_PIN  AC6  IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_csn6] ; ## C19 FMC_HPC0_LA14_N
set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_csn7] ; ## C22 FMC_HPC0_LA18_P_CC
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVCMOS18}                                 [get_ports spi_adl5960_2_csn8] ; ## C23 FMC_HPC0_LA18_N_CC

set_property  -dict {PACKAGE_PIN  L12  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[0]]           ; ## H28 FMC_HPC0_LA24_P
set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[1]]           ; ## H29 FMC_HPC0_LA24_N
set_property  -dict {PACKAGE_PIN  T7   IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[2]]           ; ## H31 FMC_HPC0_LA28_P
set_property  -dict {PACKAGE_PIN  T6   IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[3]]           ; ## H32 FMC_HPC0_LA28_N
set_property  -dict {PACKAGE_PIN  V6   IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[4]]           ; ## H34 FMC_HPC0_LA30_P
set_property  -dict {PACKAGE_PIN  U6   IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[5]]           ; ## H35 FMC_HPC0_LA30_N
set_property  -dict {PACKAGE_PIN  U11  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[6]]           ; ## H37 FMC_HPC0_LA32_P
set_property  -dict {PACKAGE_PIN  T11  IOSTANDARD LVCMOS18 PULLTYPE PULLUP}                 [get_ports prten[7]]           ; ## H38 FMC_HPC0_LA32_N

# clocks
create_clock -period 2 -name rx_ref_clk [get_ports ref_clk0_p]
create_clock -period 8 -name rx_ref_clk2 [get_ports glblclk_p]

set_input_delay -clock [get_clocks rx_ref_clk2] [get_property PERIOD [get_clocks rx_ref_clk2]] \
                [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]

create_generated_clock -name clk_sck0  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_bus1/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_bus1/sck_o]

create_generated_clock -name clk_sck1  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_adl5960_1/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_adl5960_1/sck_o]

create_generated_clock -name clk_sck2  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_adl5960_2/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_adl5960_2/sck_o]
