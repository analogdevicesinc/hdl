
# daq1

set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports tx_ref_clk_p]       ; ##  G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports tx_ref_clk_n]       ; ##  G07  FMC_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  V23   IOSTANDARD LVDS_25} [get_ports tx_clk_p]                           ; ##  D20  FMC_HPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  W24   IOSTANDARD LVDS_25} [get_ports tx_clk_n]                           ; ##  D21  FMC_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVDS_25} [get_ports tx_frame_p]                         ; ##  C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVDS_25} [get_ports tx_frame_n]                         ; ##  C23  FMC_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports tx_data_p[0]]                       ; ##  H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports tx_data_n[0]]                       ; ##  H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25} [get_ports tx_data_p[1]]                       ; ##  D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25} [get_ports tx_data_n[1]]                       ; ##  D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVDS_25} [get_ports tx_data_p[2]]                       ; ##  C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVDS_25} [get_ports tx_data_n[2]]                       ; ##  C11  FMC_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25} [get_ports tx_data_p[3]]                       ; ##  H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25} [get_ports tx_data_n[3]]                       ; ##  H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVDS_25} [get_ports tx_data_p[4]]                       ; ##  G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVDS_25} [get_ports tx_data_n[4]]                       ; ##  G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVDS_25} [get_ports tx_data_p[5]]                       ; ##  D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVDS_25} [get_ports tx_data_n[5]]                       ; ##  D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVDS_25} [get_ports tx_data_p[6]]                       ; ##  C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVDS_25} [get_ports tx_data_n[6]]                       ; ##  C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVDS_25} [get_ports tx_data_p[7]]                       ; ##  H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVDS_25} [get_ports tx_data_n[7]]                       ; ##  H17  FMC_HPC_LA11_N
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVDS_25} [get_ports tx_data_p[8]]                       ; ##  G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVDS_25} [get_ports tx_data_n[8]]                       ; ##  G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVDS_25} [get_ports tx_data_p[9]]                       ; ##  D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVDS_25} [get_ports tx_data_n[9]]                       ; ##  D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVDS_25} [get_ports tx_data_p[10]]                      ; ##  C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVDS_25} [get_ports tx_data_n[10]]                      ; ##  C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVDS_25} [get_ports tx_data_p[11]]                      ; ##  H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVDS_25} [get_ports tx_data_n[11]]                      ; ##  H20  FMC_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVDS_25} [get_ports tx_data_p[12]]                      ; ##  G18  FMC_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVDS_25} [get_ports tx_data_n[12]]                      ; ##  G19  FMC_HPC_LA16_N
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25} [get_ports tx_data_p[13]]                      ; ##  H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25} [get_ports tx_data_n[13]]                      ; ##  H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25} [get_ports tx_data_p[14]]                      ; ##  D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25} [get_ports tx_data_n[14]]                      ; ##  D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25} [get_ports tx_data_p[15]]                      ; ##  G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25} [get_ports tx_data_n[15]]                      ; ##  G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  AD10  } [get_ports rx_ref_clk_p]                                         ; ##  D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD9   } [get_ports rx_ref_clk_n]                                         ; ##  D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AH10  } [get_ports rx_data_p[0]]                                         ; ##  C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9   } [get_ports rx_data_n[0]]                                         ; ##  C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8   } [get_ports rx_data_p[1]]                                         ; ##  A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7   } [get_ports rx_data_n[1]]                                         ; ##  A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVDS_25} [get_ports rx_sync_p]                          ; ##  H22  FMC_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVDS_25} [get_ports rx_sync_n]                          ; ##  H23  FMC_HPC_LA19_N
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]         ; ##  H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]         ; ##  H26  FMC_HPC_LA21_N

set_property  -dict {PACKAGE_PIN  U29   IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                       ; ##  G28  FMC_HPC_LA25_N
set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                       ; ##  G27  FMC_HPC_LA25_P
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                       ; ##  H29  FMC_HPC_LA24_N
set_property  -dict {PACKAGE_PIN  P26   IOSTANDARD LVCMOS25} [get_ports spi_clk]                           ; ##  D24  FMC_HPC_LA23_N
set_property  -dict {PACKAGE_PIN  P25   IOSTANDARD LVCMOS25} [get_ports spi_sdio]                          ; ##  D23  FMC_HPC_LA23_P

set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25} [get_ports gpio_resetn]                       ; ##  G25  FMC_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  R30   IOSTANDARD LVCMOS25} [get_ports gpio_clkd_syncn]                   ; ##  H32  FMC_HPC_LA28_N
set_property  -dict {PACKAGE_PIN  P30   IOSTANDARD LVCMOS25} [get_ports gpio_clkd_pdn]                     ; ##  H31  FMC_HPC_LA28_P

set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVCMOS25} [get_ports gpio_clkd_status[1]]               ; ##  D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVCMOS25} [get_ports gpio_clkd_status[0]]               ; ##  D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25} [get_ports gpio_dac_irqn]                     ; ##  G24  FMC_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  V28   IOSTANDARD LVCMOS25} [get_ports gpio_adc_fda]                      ; ##  C26  FMC_HPC_LA27_P
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS25} [get_ports gpio_adc_fdb]                      ; ##  C27  FMC_HPC_LA27_N

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  8.00 [get_nets i_system_wrapper/system_i/axi_ad9122_dac_div_clk]
create_clock -name rx_div_clk   -period  8.00 [get_nets i_system_wrapper/system_i/axi_daq1_gt_rx_clk]

