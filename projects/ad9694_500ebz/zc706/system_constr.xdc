
set_property  -dict {PACKAGE_PIN  AD10 } [get_ports rx_ref_clk_p]                                     ; ## SMA_MGT_REFCLK_P
set_property  -dict {PACKAGE_PIN   AD9 } [get_ports rx_ref_clk_n]                                     ; ## SMA_MGT_REFCLK_N

set_property  -dict {PACKAGE_PIN  AG4  } [get_ports rx_data_p[0]]                                     ; ## A18  FMC_HPC_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  AG3  } [get_ports rx_data_n[0]]                                     ; ## A19  FMC_HPC_DP5_M2C_N
set_property  -dict {PACKAGE_PIN  AF6  } [get_ports rx_data_p[1]]                                     ; ## B16  FMC_HPC_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  AF5  } [get_ports rx_data_n[1]]                                     ; ## B17  FMC_HPC_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8  } [get_ports rx_data_p[2]]                                     ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7  } [get_ports rx_data_n[2]]                                     ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AH10 } [get_ports rx_data_p[3]]                                     ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9  } [get_ports rx_data_n[3]]                                     ; ## C07  FMC_HPC_DP0_M2C_N

set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25} [get_ports rx_sync0_p]                    ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25} [get_ports rx_sync0_n]                    ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync1_p]                    ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync1_n]                    ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVDS_25} [get_ports rx_device_clk_p]               ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD LVDS_25} [get_ports rx_device_clk_n]               ; ## H14  FMC_HPC_LA07_N


set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_adc_csn]                  ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVCMOS25} [get_ports spi_adc_clk]                  ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports spi_adc_miso]                 ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVCMOS25} [get_ports spi_adc_mosi]                 ; ## D09  FMC_HPC_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  AJ21  IOSTANDARD LVCMOS25} [get_ports spi_clk0_clk]                 ; ## PMOD1_0
set_property  -dict {PACKAGE_PIN  AK21  IOSTANDARD LVCMOS25} [get_ports spi_clk0_mosi]                ; ## PMOD1_1
set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS25} [get_ports spi_clk0_csn]                 ; ## PMOD1_2
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS25} [get_ports spi_clk0_miso]                ; ## PMOD1_3
set_property  -dict {PACKAGE_PIN   Y20  IOSTANDARD LVCMOS25} [get_ports spi_clk1_clk]                 ; ## PMOD1_4
set_property  -dict {PACKAGE_PIN  AA20  IOSTANDARD LVCMOS25} [get_ports spi_clk1_mosi]                ; ## PMOD1_5
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS25} [get_ports spi_clk1_csn]                 ; ## PMOD1_6
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS25} [get_ports adc_capture_start]            ; ## PMOD1_7

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/util_ad9694_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]
