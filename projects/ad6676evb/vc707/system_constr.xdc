
# ad6676

set_property  -dict {PACKAGE_PIN  A10}  [get_ports rx_ref_clk_p]                                   ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9 }  [get_ports rx_ref_clk_n]                                   ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  D8 }  [get_ports rx_data_p[0]]                                   ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  D7 }  [get_ports rx_data_n[0]]                                   ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  C6 }  [get_ports rx_data_p[1]]                                   ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  C5 }  [get_ports rx_data_n[1]]                                   ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  J40   IOSTANDARD LVDS} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41   IOSTANDARD LVDS} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  K39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  K40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G07  FMC_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  L41  IOSTANDARD LVCMOS18} [get_ports spi_csn]                    ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  H41  IOSTANDARD LVCMOS18} [get_ports spi_clk]                    ; ## H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  H40  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                   ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  M41  IOSTANDARD LVCMOS18} [get_ports spi_miso]                   ; ## D11  FMC_HPC_LA05_P

set_property  -dict {PACKAGE_PIN  J42  IOSTANDARD LVCMOS18} [get_ports adc_oen]                    ; ## C11  FMC_HPC_LA06_N             
set_property  -dict {PACKAGE_PIN  M37  IOSTANDARD LVCMOS18} [get_ports adc_sela]                   ; ## G12  FMC_HPC_LA08_P             
set_property  -dict {PACKAGE_PIN  M38  IOSTANDARD LVCMOS18} [get_ports adc_selb]                   ; ## G13  FMC_HPC_LA08_N             
set_property  -dict {PACKAGE_PIN  G41  IOSTANDARD LVCMOS18} [get_ports adc_s0]                     ; ## H13  FMC_HPC_LA07_P             
set_property  -dict {PACKAGE_PIN  G42  IOSTANDARD LVCMOS18} [get_ports adc_s1]                     ; ## H14  FMC_HPC_LA07_N             
set_property  -dict {PACKAGE_PIN  K42  IOSTANDARD LVCMOS18} [get_ports adc_resetb]                 ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  P41  IOSTANDARD LVCMOS18} [get_ports adc_agc1]                   ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  N41  IOSTANDARD LVCMOS18} [get_ports adc_agc2]                   ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  M42  IOSTANDARD LVCMOS18} [get_ports adc_agc3]                   ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42  IOSTANDARD LVCMOS18} [get_ports adc_agc4]                   ; ## G10  FMC_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period  3.30 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.60 [get_pins i_system_wrapper/system_i/axi_ad6676_gt/inst/g_lane_1[0].i_gt_channel_1/i_gtxe2_channel/RXOUTCLK]

