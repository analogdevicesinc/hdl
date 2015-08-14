
# ad9625

set_property  -dict {PACKAGE_PIN  A10 } [get_ports rx_ref_clk_p]                                 ; ## D04  FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9  } [get_ports rx_ref_clk_n]                                 ; ## D05  FMC1_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  D8  } [get_ports rx_data_p[0]]                                 ; ## C06  FMC1_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  D7  } [get_ports rx_data_n[0]]                                 ; ## C07  FMC1_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  C6  } [get_ports rx_data_p[1]]                                 ; ## A02  FMC1_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  C5  } [get_ports rx_data_n[1]]                                 ; ## A03  FMC1_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  B8  } [get_ports rx_data_p[2]]                                 ; ## A06  FMC1_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  B7  } [get_ports rx_data_n[2]]                                 ; ## A07  FMC1_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  A6  } [get_ports rx_data_p[3]]                                 ; ## A10  FMC1_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  A5  } [get_ports rx_data_n[3]]                                 ; ## A11  FMC1_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  E6  } [get_ports rx_data_p[4]]                                 ; ## B12  FMC1_HPC_DP7_M2C_P
set_property  -dict {PACKAGE_PIN  E5  } [get_ports rx_data_n[4]]                                 ; ## B13  FMC1_HPC_DP7_M2C_N
set_property  -dict {PACKAGE_PIN  H8  } [get_ports rx_data_p[5]]                                 ; ## A14  FMC1_HPC_DP4_M2C_P
set_property  -dict {PACKAGE_PIN  H7  } [get_ports rx_data_n[5]]                                 ; ## A15  FMC1_HPC_DP4_M2C_N
set_property  -dict {PACKAGE_PIN  F8  } [get_ports rx_data_p[6]]                                 ; ## B16  FMC1_HPC_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  F7  } [get_ports rx_data_n[6]]                                 ; ## B17  FMC1_HPC_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  G6  } [get_ports rx_data_p[7]]                                 ; ## A18  FMC1_HPC_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  G5  } [get_ports rx_data_n[7]]                                 ; ## A19  FMC1_HPC_DP5_M2C_N
set_property  -dict {PACKAGE_PIN  H40   IOSTANDARD LVDS} [get_ports rx_sync_p]                   ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  H41   IOSTANDARD LVDS} [get_ports rx_sync_n]                   ; ## H11  FMC1_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  M41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_p]  ; ## D11  FMC1_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_n]  ; ## D12  FMC1_HPC_LA05_N

set_property  -dict {PACKAGE_PIN  N41  IOSTANDARD LVCMOS18} [get_ports spi_adc_csn]              ; ## H08  FMC1_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  J40  IOSTANDARD LVCMOS18} [get_ports spi_adc_clk]              ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41  IOSTANDARD LVCMOS18} [get_ports spi_adc_sdio]             ; ## D09  FMC1_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  P41  IOSTANDARD LVCMOS18} [get_ports spi_ext_csn_0]            ; ## H07  FMC1_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  K42  IOSTANDARD LVCMOS18} [get_ports spi_ext_csn_1]            ; ## C10  FMC1_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  K39  IOSTANDARD LVCMOS18} [get_ports spi_ext_clk]              ; ## G06  FMC1_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  K40  IOSTANDARD LVCMOS18} [get_ports spi_ext_sdio]             ; ## G07  FMC1_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  M42  IOSTANDARD LVCMOS18} [get_ports adc_irq]                  ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42  IOSTANDARD LVCMOS18} [get_ports adc_fd]                   ; ## G10  FMC1_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/axi_ad9625_gt/inst/g_lane_1[0].i_gt_channel_1/i_gtxe2_channel/RXOUTCLK]

