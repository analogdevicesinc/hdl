
# adrv9009

set_property  -dict {PACKAGE_PIN  AD10} [get_ports ref_clk0_p]                                        ; ## D04  FMC_HPC_GBTCLK0_M2C_P (NC)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports ref_clk0_n]                                        ; ## D05  FMC_HPC_GBTCLK0_M2C_N (NC)
set_property  -dict {PACKAGE_PIN  AA8 } [get_ports ref_clk1_p]                                        ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports ref_clk1_n]                                        ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[0]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[0]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[1]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[1]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[2]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[2]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AK6 } [get_ports tx_data_p[0]]                                      ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  AK5 } [get_ports tx_data_n[0]]                                      ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  AJ4 } [get_ports tx_data_p[1]]                                      ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  AJ3 } [get_ports tx_data_n[1]]                                      ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  AK10} [get_ports tx_data_p[2]]                                      ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  AK9 } [get_ports tx_data_n[2]]                                      ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[2])
set_property  -dict {PACKAGE_PIN  AK2 } [get_ports tx_data_p[3]]                                      ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  AK1 } [get_ports tx_data_n[3]]                                      ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVDS_25} [get_ports rx_os_sync_p]                  ; ## G27  FMC_HPC_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  U29   IOSTANDARD LVDS_25} [get_ports rx_os_sync_n]                  ; ## G28  FMC_HPC_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_p]       ; ## G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_n]       ; ## G07  FMC_HPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  T30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_1_p]    ; ## H28  FMC_HPC_LA24_P
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_1_n]    ; ## H29  FMC_HPC_LA24_N
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_out_p]   ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_out_n]   ; ## D09  FMC_HPC_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9528]               ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_csn_adrv9009]             ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                     ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_miso]                     ; ## G12  FMC_HPC_LA08_P

set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVCMOS25} [get_ports ad9528_reset_b]               ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVCMOS25} [get_ports ad9528_sysref_req]            ; ## D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports adrv9009_tx1_enable]          ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports adrv9009_tx2_enable]          ; ## C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports adrv9009_rx1_enable]          ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports adrv9009_rx2_enable]          ; ## C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports adrv9009_test]                ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVCMOS25} [get_ports adrv9009_reset_b]             ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpint]               ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_00]             ; ## H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_01]             ; ## H20  FMC_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_02]             ; ## G18  FMC_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_03]             ; ## G19  FMC_HPC_LA16_N
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_04]             ; ## H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_05]             ; ## H26  FMC_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_06]             ; ## C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_07]             ; ## C23  FMC_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_08]             ; ## G25  FMC_HPC_LA22_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_09]             ; ## H22  FMC_HPC_LA19_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_10]             ; ## H23  FMC_HPC_LA19_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  U25   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_11]             ; ## G21  FMC_HPC_LA20_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  V26   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_12]             ; ## G22  FMC_HPC_LA20_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_13]             ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_14]             ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_15]             ; ## G24  FMC_HPC_LA22_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_16]             ; ## C11  FMC_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_17]             ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports adrv9009_gpio_18]             ; ## H17  FMC_HPC_LA11_N

# clocks

create_clock -name tx_ref_clk     -period  4.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  4.00 [get_ports ref_clk1_p]
create_clock -name tx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]
create_clock -name rx_os_div_clk  -period  4.00 [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_2/i_gtxe2_channel/RXOUTCLK]
