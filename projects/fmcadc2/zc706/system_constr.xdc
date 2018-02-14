
# ad9625

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[0]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[0]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[1]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[1]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AD6 } [get_ports rx_data_p[4]]                                      ; ## B12  FMC_HPC_DP7_M2C_P
set_property  -dict {PACKAGE_PIN  AD5 } [get_ports rx_data_n[4]]                                      ; ## B13  FMC_HPC_DP7_M2C_N
set_property  -dict {PACKAGE_PIN  AH6 } [get_ports rx_data_p[5]]                                      ; ## A14  FMC_HPC_DP4_M2C_P
set_property  -dict {PACKAGE_PIN  AH5 } [get_ports rx_data_n[5]]                                      ; ## A15  FMC_HPC_DP4_M2C_N
set_property  -dict {PACKAGE_PIN  AF6 } [get_ports rx_data_p[6]]                                      ; ## B16  FMC_HPC_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  AF5 } [get_ports rx_data_n[6]]                                      ; ## B17  FMC_HPC_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  AG4 } [get_ports rx_data_p[7]]                                      ; ## A18  FMC_HPC_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  AG3 } [get_ports rx_data_n[7]]                                      ; ## A19  FMC_HPC_DP5_M2C_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## D12  FMC_HPC_LA05_N

set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVCMOS25} [get_ports spi_adc_csn]                  ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVCMOS25} [get_ports spi_adc_clk]                  ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVCMOS25} [get_ports spi_adc_sdio]                 ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_data_or_csn_0]    ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_clk_or_csn_1]     ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_le_or_clk]        ; ## G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_ce_or_sdio]       ; ## G07  FMC_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports adc_irq]                      ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports adc_fd]                       ; ## G10  FMC_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/util_fmcadc2_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]

