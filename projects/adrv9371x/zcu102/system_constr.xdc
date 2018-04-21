# FMC_HPC 0

# ad9371

set_property  -dict {PACKAGE_PIN  Y2   IOSTANDARD LVDS} [get_ports rx_sync_p]                         ; ## G09  FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN  Y1   IOSTANDARD LVDS} [get_ports rx_sync_n]                         ; ## G10  FMC_HPC0_LA03_N
set_property  -dict {PACKAGE_PIN  M11  IOSTANDARD LVDS} [get_ports rx_os_sync_p]                      ; ## G27  FMC_HPC0_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  L11  IOSTANDARD LVDS} [get_ports rx_os_sync_n]                      ; ## G28  FMC_HPC0_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  V2   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]  ; ## H07  FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  V1   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]  ; ## H08  FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  V12  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_p]   ; ## G36  FMC_HPC0_LA33_P
set_property  -dict {PACKAGE_PIN  V11  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_n]   ; ## G37  FMC_HPC0_LA33_N

set_property  -dict {PACKAGE_PIN  W2   IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9371]                ; ## D14  FMC_HPC0_LA09_P
set_property  -dict {PACKAGE_PIN  W1   IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]                ; ## D15  FMC_HPC0_LA09_N
set_property  -dict {PACKAGE_PIN  U5   IOSTANDARD LVCMOS18} [get_ports spi_clk]                       ; ## H13  FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  U4   IOSTANDARD LVCMOS18} [get_ports spi_mosi]                      ; ## H14  FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  V4   IOSTANDARD LVCMOS18} [get_ports spi_miso]                      ; ## G12  FMC_HPC0_LA08_P

set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]                ; ## D26  FMC_HPC0_LA26_P
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]             ; ## D27  FMC_HPC0_LA26_N
set_property  -dict {PACKAGE_PIN  AB8  IOSTANDARD LVCMOS18} [get_ports ad9371_tx1_enable]             ; ## D17  FMC_HPC0_LA13_P
set_property  -dict {PACKAGE_PIN  AC7  IOSTANDARD LVCMOS18} [get_ports ad9371_tx2_enable]             ; ## C18  FMC_HPC0_LA14_P
set_property  -dict {PACKAGE_PIN  AC8  IOSTANDARD LVCMOS18} [get_ports ad9371_rx1_enable]             ; ## D18  FMC_HPC0_LA13_N
set_property  -dict {PACKAGE_PIN  AC6  IOSTANDARD LVCMOS18} [get_ports ad9371_rx2_enable]             ; ## C19  FMC_HPC0_LA14_N
set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVCMOS18} [get_ports ad9371_test]                   ; ## D11  FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVCMOS18} [get_ports ad9371_reset_b]                ; ## H10  FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVCMOS18} [get_ports ad9371_gpint]                  ; ## H11  FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  Y10  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_00]                ; ## H19  FMC_HPC0_LA15_P
set_property  -dict {PACKAGE_PIN  Y9   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_01]                ; ## H20  FMC_HPC0_LA15_N
set_property  -dict {PACKAGE_PIN  Y12  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_02]                ; ## G18  FMC_HPC0_LA16_P
set_property  -dict {PACKAGE_PIN  AA12 IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_03]                ; ## G19  FMC_HPC0_LA16_N
set_property  -dict {PACKAGE_PIN  P12  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_04]                ; ## H25  FMC_HPC0_LA21_P
set_property  -dict {PACKAGE_PIN  N12  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_05]                ; ## H26  FMC_HPC0_LA21_N
set_property  -dict {PACKAGE_PIN  N9   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_06]                ; ## C22  FMC_HPC0_LA18_CC_P
set_property  -dict {PACKAGE_PIN  N8   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_07]                ; ## C23  FMC_HPC0_LA18_CC_N
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_15]                ; ## G24  FMC_HPC0_LA22_P
set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_08]                ; ## G25  FMC_HPC0_LA22_N
set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_09]                ; ## H22  FMC_HPC0_LA19_P
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_10]                ; ## H23  FMC_HPC0_LA19_N
set_property  -dict {PACKAGE_PIN  N13  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_11]                ; ## G21  FMC_HPC0_LA20_P
set_property  -dict {PACKAGE_PIN  M13  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_12]                ; ## G22  FMC_HPC0_LA20_N
set_property  -dict {PACKAGE_PIN  U9   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_14]                ; ## G30  FMC_HPC0_LA29_P
set_property  -dict {PACKAGE_PIN  U8   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_13]                ; ## G31  FMC_HPC0_LA29_N
set_property  -dict {PACKAGE_PIN  W7   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_17]                ; ## G15  FMC_HPC0_LA12_P
set_property  -dict {PACKAGE_PIN  W6   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_16]                ; ## G16  FMC_HPC0_LA12_N
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_18]                ; ## D12  FMC_HPC0_LA05_N

# clocks

create_clock -name tx_ref_clk     -period  8.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  8.00 [get_ports ref_clk1_p]

create_clock -name tx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_0/i_gthe4_channel/TXOUTCLK]
create_clock -name rx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]
create_clock -name rx_os_div_clk  -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_2/i_gthe4_channel/RXOUTCLK]

# pin assignments for JESD204 lanes and reference clocks

set_property  -dict {PACKAGE_PIN  G8   } [get_ports ref_clk0_p]                                       ; ## D04  FMC_HPC0_GBTCLK0_M2C_C_P
set_property  -dict {PACKAGE_PIN  G7   } [get_ports ref_clk0_n]                                       ; ## D05  FMC_HPC0_GBTCLK0_M2C_C_N
set_property  -dict {PACKAGE_PIN  L8   } [get_ports ref_clk1_p]                                       ; ## B20  FMC_HPC0_GBTCLK1_M2C_C_P
set_property  -dict {PACKAGE_PIN  L7   } [get_ports ref_clk1_n]                                       ; ## B21  FMC_HPC0_GBTCLK1_M2C_C_N

set_property  -dict {PACKAGE_PIN  J4   } [get_ports rx_data_p[0]]                                      ; ## A02  FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3   } [get_ports rx_data_n[0]]                                      ; ## A03  FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2   } [get_ports rx_data_p[1]]                                      ; ## A06  FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1   } [get_ports rx_data_n[1]]                                      ; ## A07  FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  H2   } [get_ports rx_data_p[2]]                                      ; ## C06  FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1   } [get_ports rx_data_n[2]]                                      ; ## C07  FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  K2   } [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1   } [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC0_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  H6   } [get_ports tx_data_p[0]]                                      ; ## A22  FMC_HPC0_DP1_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  H5   } [get_ports tx_data_n[0]]                                      ; ## A23  FMC_HPC0_DP1_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  F6   } [get_ports tx_data_p[1]]                                      ; ## A26  FMC_HPC0_DP2_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  F5   } [get_ports tx_data_n[1]]                                      ; ## A27  FMC_HPC0_DP2_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  G4   } [get_ports tx_data_p[2]]                                      ; ## C02  FMC_HPC0_DP0_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  G3   } [get_ports tx_data_n[2]]                                      ; ## C03  FMC_HPC0_DP0_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  K6   } [get_ports tx_data_p[3]]                                      ; ## A30  FMC_HPC0_DP3_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  K5   } [get_ports tx_data_n[3]]                                      ; ## A31  FMC_HPC0_DP3_C2M_N (tx_data_n[2])

