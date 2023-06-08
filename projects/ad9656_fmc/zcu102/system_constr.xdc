###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9656

set_property  -dict {PACKAGE_PIN  G8}                        [get_ports ref_clk0_p]      ; ## D04  FMC_HPC0_GBTCLK0_M2C_C_P
set_property  -dict {PACKAGE_PIN  G7}                        [get_ports ref_clk0_n]      ; ## D05  FMC_HPC0_GBTCLK0_M2C_C_N
set_property  -dict {PACKAGE_PIN  L8}                        [get_ports ref_clk1_p]      ; ## B20  FMC_HPC0_GBTCLK1_M2C_C_P
set_property  -dict {PACKAGE_PIN  L7}                        [get_ports ref_clk1_n]      ; ## B21  FMC_HPC0_GBTCLK1_M2C_C_N
set_property  -dict {PACKAGE_PIN  J4}                        [get_ports rx_data_p[0]]    ; ## A02  FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3}                        [get_ports rx_data_n[0]]    ; ## A03  FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2}                        [get_ports rx_data_p[1]]    ; ## A06  FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1}                        [get_ports rx_data_n[1]]    ; ## A07  FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  H2}                        [get_ports rx_data_p[2]]    ; ## C06  FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1}                        [get_ports rx_data_n[2]]    ; ## C07  FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  K2}                        [get_ports rx_data_p[3]]    ; ## A10  FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1}                        [get_ports rx_data_n[3]]    ; ## A11  FMC_HPC0_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  Y2   IOSTANDARD LVCMOS18}  [get_ports spi_csn_ad9508]  ; ## G09  FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN  Y1   IOSTANDARD LVCMOS18}  [get_ports spi_csn_ad9553]  ; ## G10  FMC_HPC0_LA03_N
set_property  -dict {PACKAGE_PIN  AB4  IOSTANDARD LVCMOS18}  [get_ports spi_clk]         ; ## D08  FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4  IOSTANDARD LVCMOS18}  [get_ports spi_mosi]        ; ## D09  FMC_HPC0_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AB3  IOSTANDARD LVDS}      [get_ports sysref_out_p]    ; ## D11  FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AC3  IOSTANDARD LVDS}      [get_ports sysref_out_n]    ; ## D12  FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN  AA2  IOSTANDARD LVDS}      [get_ports rx_sync_p]       ; ## H10  FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1  IOSTANDARD LVDS}      [get_ports rx_sync_n]       ; ## H11  FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  AA7  IOSTANDARD LVDS}      [get_ports sysref_p]        ; ## H4   FMC_HPC0_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AA6  IOSTANDARD LVDS}      [get_ports sysref_n]        ; ## H5   FMC_HPC0_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN  V2   IOSTANDARD LVCMOS18}  [get_ports spi_miso]        ; ## H7   FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  V1   IOSTANDARD LVCMOS18}  [get_ports spi_csn_ad9656]  ; ## H8   FMC_HPC0_LA02_N

# clocks

create_clock  -name rx_ref_clk  -period 8.00  [get_ports ref_clk0_p]

# For transceiver output clocks use reference clock divided by two
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

create_generated_clock  -name rx_div_clk  [get_pins  i_system_wrapper/system_i/util_ad9656_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]

# SYSREF input

set_input_delay -clock [get_clocks rx_div_clk] [get_property PERIOD [get_clocks rx_div_clk]] [get_ports {sysref_n sysref_p}]
