
# adrv9009

set_property  -dict {PACKAGE_PIN  G27} [get_ports ref_clk0_p]                                          ; ## D04  FMC_HPC1_GBTCLK0_M2C_C_P (NC)
set_property  -dict {PACKAGE_PIN  G28} [get_ports ref_clk0_n]                                          ; ## D05  FMC_HPC1_GBTCLK0_M2C_C_N (NC)
set_property  -dict {PACKAGE_PIN  E27} [get_ports ref_clk1_p]                                          ; ## B20  FMC_HPC1_GBTCLK1_M2C_C_P
set_property  -dict {PACKAGE_PIN  E28} [get_ports ref_clk1_n]                                          ; ## B21  FMC_HPC1_GBTCLK1_M2C_C_N
set_property  -dict {PACKAGE_PIN  D33} [get_ports rx_data_p[0]]                                        ; ## A02  FMC_HPC1_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D34} [get_ports rx_data_n[0]]                                        ; ## A03  FMC_HPC1_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  C31} [get_ports rx_data_p[1]]                                        ; ## A06  FMC_HPC1_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  C32} [get_ports rx_data_n[1]]                                        ; ## A07  FMC_HPC1_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  E31} [get_ports rx_data_p[2]]                                        ; ## C06  FMC_HPC1_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E32} [get_ports rx_data_n[2]]                                        ; ## C07  FMC_HPC1_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  B33} [get_ports rx_data_p[3]]                                        ; ## A10  FMC_HPC1_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  B34} [get_ports rx_data_n[3]]                                        ; ## A11  FMC_HPC1_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  D29} [get_ports tx_data_p[0]]                                        ; ## A22  FMC_HPC1_DP1_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  D30} [get_ports tx_data_n[0]]                                        ; ## A23  FMC_HPC1_DP1_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  B29} [get_ports tx_data_p[1]]                                        ; ## A26  FMC_HPC1_DP2_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  B30} [get_ports tx_data_n[1]]                                        ; ## A27  FMC_HPC1_DP2_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  F29} [get_ports tx_data_p[2]]                                        ; ## C02  FMC_HPC1_DP0_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  F30} [get_ports tx_data_n[2]]                                        ; ## C03  FMC_HPC1_DP0_C2M_N (tx_data_n[2])
set_property  -dict {PACKAGE_PIN  A31} [get_ports tx_data_p[3]]                                        ; ## A30  FMC_HPC1_DP3_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  A32} [get_ports tx_data_n[3]]                                        ; ## A31  FMC_HPC1_DP3_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  AH1  IOSTANDARD LVDS} [get_ports rx_sync_p]                          ; ## G09  FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1  IOSTANDARD LVDS} [get_ports rx_sync_n]                          ; ## G10  FMC_HPC1_LA03_N
set_property  -dict {PACKAGE_PIN  AE10 IOSTANDARD LVDS} [get_ports rx_os_sync_p]                       ; ## G27  FMC_HPC1_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  AF10 IOSTANDARD LVDS} [get_ports rx_os_sync_n]                       ; ## G28  FMC_HPC1_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  AD2  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]   ; ## H07  FMC_HPC1_LA02_P
set_property  -dict {PACKAGE_PIN  AD1  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]   ; ## H08  FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN  AE5  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_p]    ; ## G06  FMC_HPC1_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AF5  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_n]    ; ## G07  FMC_HPC1_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AH12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_p] ; ## H28  FMC_HPC1_LA24_P
set_property  -dict {PACKAGE_PIN  AH11 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_n] ; ## H29  FMC_HPC1_LA24_N
set_property  -dict {PACKAGE_PIN  AJ6  IOSTANDARD LVDS } [get_ports sysref_out_p]                      ; ## D08  FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AJ5  IOSTANDARD LVDS } [get_ports sysref_out_n]                      ; ## D09  FMC_HPC1_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AE1  IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]                 ; ## D15  FMC_HPC1_LA09_N
set_property  -dict {PACKAGE_PIN  AE2  IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009]               ; ## D14  FMC_HPC1_LA09_P
set_property  -dict {PACKAGE_PIN  AD4  IOSTANDARD LVCMOS18} [get_ports spi_clk]                        ; ## H13  FMC_HPC1_LA07_P
set_property  -dict {PACKAGE_PIN  AE4  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                       ; ## H14  FMC_HPC1_LA07_N
set_property  -dict {PACKAGE_PIN  AE3  IOSTANDARD LVCMOS18} [get_ports spi_miso]                       ; ## G12  FMC_HPC1_LA08_P

set_property  -dict {PACKAGE_PIN  T12  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]                 ; ## D26  FMC_HPC1_LA26_P
set_property  -dict {PACKAGE_PIN  R12  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]              ; ## D27  FMC_HPC1_LA26_N
set_property  -dict {PACKAGE_PIN  AG8  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable]            ; ## D17  FMC_HPC1_LA13_P
set_property  -dict {PACKAGE_PIN  AH7  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable]            ; ## C18  FMC_HPC1_LA14_P
set_property  -dict {PACKAGE_PIN  AH8  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable]            ; ## D18  FMC_HPC1_LA13_N
set_property  -dict {PACKAGE_PIN  AH6  IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable]            ; ## C19  FMC_HPC1_LA14_N
set_property  -dict {PACKAGE_PIN  AE8  IOSTANDARD LVCMOS18} [get_ports adrv9009_test]                  ; ## H16  FMC_HPC1_LA11_P
#set_property  -dict {PACKAGE_PIN  AG3  IOSTANDARD LVCMOS18} [get_ports adrv9009_test]                  ; ## D11  FMC_HPC1_LA05_P
set_property  -dict {PACKAGE_PIN  AF2  IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b]               ; ## H10  FMC_HPC1_LA04_P
set_property  -dict {PACKAGE_PIN  AF1  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint]                 ; ## H11  FMC_HPC1_LA04_N

set_property  -dict {PACKAGE_PIN  AD10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00]               ; ## H19  FMC_HPC1_LA15_P
set_property  -dict {PACKAGE_PIN  AE9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01]               ; ## H20  FMC_HPC1_LA15_N
set_property  -dict {PACKAGE_PIN  AG10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02]               ; ## G18  FMC_HPC1_LA16_P
set_property  -dict {PACKAGE_PIN  AG9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03]               ; ## G19  FMC_HPC1_LA16_N
set_property  -dict {PACKAGE_PIN  AC12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04]               ; ## H25  FMC_HPC1_LA21_P
set_property  -dict {PACKAGE_PIN  AC11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05]               ; ## H26  FMC_HPC1_LA21_N
set_property  -dict {PACKAGE_PIN  Y8   IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06]               ; ## C22  FMC_HPC1_LA18_CC_P
set_property  -dict {PACKAGE_PIN  Y7   IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07]               ; ## C23  FMC_HPC1_LA18_CC_N
set_property  -dict {PACKAGE_PIN  AG11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08]               ; ## G25  FMC_HPC1_LA22_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AA11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_09]               ; ## H22  FMC_HPC1_LA19_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AA10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_10]               ; ## H23  FMC_HPC1_LA19_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AB11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_11]               ; ## G21  FMC_HPC1_LA20_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AB10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_12]               ; ## G22  FMC_HPC1_LA20_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AD6  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]               ; ## G16  FMC_HPC1_LA12_N (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AD7  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]               ; ## G15  FMC_HPC1_LA12_P (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  W11  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]               ; ## G31  FMC_HPC1_LA29_N     (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  W12  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]               ; ## G30  FMC_HPC1_LA29_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AF11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_15]               ; ## G24  FMC_HPC1_LA22_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AJ2  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]               ; ## C11  FMC_HPC1_LA06_N (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AH2  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]               ; ## C10  FMC_HPC1_LA06_P (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AF8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]               ; ## H17  FMC_HPC1_LA11_N
#set_property  -dict {PACKAGE_PIN  P9   IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]               ; ## G03  FMC_HPC1_CLK1_M2C_N (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  P10  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]               ; ## G02  FMC_HPC1_CLK1_M2C_P (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  AH3  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]               ; ## D12  FMC_HPC1_LA05_N

# clocks

create_clock -name tx_ref_clk     -period  4.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  4.00 [get_ports ref_clk1_p]
create_clock -name tx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/TXOUTCLK]
create_clock -name rx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]
create_clock -name rx_os_div_clk  -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_2/i_gthe4_channel/RXOUTCLK]
