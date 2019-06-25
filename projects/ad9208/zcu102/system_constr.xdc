
set_property  -dict {PACKAGE_PIN  AF5 IOSTANDARD LVDS} [get_ports rx_core_clk_p]                            ; ## G07 FMC_HPC1_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AE5 IOSTANDARD LVDS} [get_ports rx_core_clk_n]                            ; ## G06 FMC_HPC1_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AF2 IOSTANDARD LVDS} [get_ports rx_sync_p]                                ; ## H10 FMC_HPC1_LA04_P
set_property  -dict {PACKAGE_PIN  AF1 IOSTANDARD LVDS} [get_ports rx_sync_n]                                ; ## H11 FMC_HPC1_LA04_N
set_property  -dict {PACKAGE_PIN  AE7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]       ; ## H04 FMC_HPC1_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AF7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]       ; ## H05 FMC_HPC1_CLK0_M2C_N

set_property  -dict {PACKAGE_PIN  AJ2 IOSTANDARD LVCMOS18} [get_ports spi_csn_vref]                         ; ## C11 FMC_HPC1_LA06_N
set_property  -dict {PACKAGE_PIN  AH2 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                          ; ## C10 FMC_HPC1_LA06_P
set_property  -dict {PACKAGE_PIN  AJ6 IOSTANDARD LVCMOS18} [get_ports spi_clk_adc]                          ; ## D08 FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AD2 IOSTANDARD LVCMOS18} [get_ports spi_miso_adc]                         ; ## H07 FMC_HPC1_LA02_P
set_property  -dict {PACKAGE_PIN  AJ5 IOSTANDARD LVCMOS18} [get_ports spi_mosi_adc]                         ; ## D09 FMC_HPC1_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AD4 IOSTANDARD LVCMOS18} [get_ports spi_csb_adt7320]                      ; ## H13 FMC_HPC1_LA07_P
set_property  -dict {PACKAGE_PIN  AE4 IOSTANDARD LVCMOS18} [get_ports spi_sdi_adt7320]                      ; ## H14 FMC_HPC1_LA07_N
set_property  -dict {PACKAGE_PIN  AE3 IOSTANDARD LVCMOS18} [get_ports spi_sdo_adt7320]                      ; ## G12 FMC_HPC1_LA08_P
set_property  -dict {PACKAGE_PIN  AF3 IOSTANDARD LVCMOS18} [get_ports spi_clk_adt7320]                      ; ## G13 FMC_HPC1_LA08_N

set_property  -dict {PACKAGE_PIN  AH1 IOSTANDARD LVCMOS18} [get_ports fda]                                  ; ## G09 FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1 IOSTANDARD LVCMOS18} [get_ports fdb]                                  ; ## G10 FMC_HPC1_LA03_N
set_property  -dict {PACKAGE_PIN  AD1 IOSTANDARD LVCMOS18} [get_ports pwdn]                                 ; ## H08 FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN  AG3 IOSTANDARD LVCMOS18} [get_ports gpio_a1]                              ; ## D11 FMC_HPC1_LA05_P
set_property  -dict {PACKAGE_PIN  AH3 IOSTANDARD LVCMOS18} [get_ports gpio_b1]                              ; ## D12 FMC_HPC1_LA05_N

set_property  -dict {PACKAGE_PIN  J27} [get_ports rx_ref_clk_p]                                             ; ## USER_SMA_MGT_CLOCK_C_P
set_property  -dict {PACKAGE_PIN  J28} [get_ports rx_ref_clk_n]                                             ; ## USER_SMA_MGT_CLOCK_C_N

set_property  -dict {PACKAGE_PIN  D33} [get_ports rx_data_p[0]] ; ## A02 FMC_HPC1_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D34} [get_ports rx_data_n[0]] ; ## A03 FMC_HPC1_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  E31} [get_ports rx_data_p[1]] ; ## C06 FMC_HPC1_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E32} [get_ports rx_data_n[1]] ; ## C07 FMC_HPC1_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  C31} [get_ports rx_data_p[2]] ; ## A06 FMC_HPC1_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  C32} [get_ports rx_data_n[2]] ; ## A07 FMC_HPC1_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  B33} [get_ports rx_data_p[3]] ; ## A10 FMC_HPC1_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  B34} [get_ports rx_data_n[3]] ; ## A11 FMC_HPC1_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  F33} [get_ports rx_data_p[4]] ; ## B12 FMC_HPC1_DP7_M2C_P
set_property  -dict {PACKAGE_PIN  F34} [get_ports rx_data_n[4]] ; ## B13 FMC_HPC1_DP7_M2C_N
set_property  -dict {PACKAGE_PIN  L31} [get_ports rx_data_p[5]] ; ## A14 FMC_HPC1_DP4_M2C_P
set_property  -dict {PACKAGE_PIN  L32} [get_ports rx_data_n[5]] ; ## A15 FMC_HPC1_DP4_M2C_N
set_property  -dict {PACKAGE_PIN  H33} [get_ports rx_data_p[6]] ; ## B16 FMC_HPC1_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  H34} [get_ports rx_data_n[6]] ; ## B17 FMC_HPC1_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  K33} [get_ports rx_data_p[7]] ; ## A18 FMC_HPC1_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  K34} [get_ports rx_data_n[7]] ; ## A19 FMC_HPC1_DP5_M2C_N


set_property  -dict {PACKAGE_PIN  A20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]   ; ## PMOD0_0
set_property  -dict {PACKAGE_PIN  B20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi]  ; ## PMOD0_1
set_property  -dict {PACKAGE_PIN  A22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso]  ; ## PMOD0_2
set_property  -dict {PACKAGE_PIN  A21 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]   ; ## PMOD0_3

# clocks

create_clock -name rx_ref_clk   -period  2.666 [get_ports rx_ref_clk_p]
create_clock -name rx_core_clk  -period  2.666 [get_ports rx_core_clk_p]

set_false_path -from [get_pins i_system_wrapper/system_i/sys_ps8/inst/PS8_i/EMIOSPI0SCLKO] -to [get_pins i_system_wrapper/system_i/sys_ps8/inst/PS8_i/EMIOSPI0MI]
