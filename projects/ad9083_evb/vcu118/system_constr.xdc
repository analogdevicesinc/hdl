###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9083

#input
set_property  -dict {PACKAGE_PIN  AL35 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE}       [get_ports glblclk_p]       ; ## FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AL36 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE}       [get_ports glblclk_n]       ; ## FMC_HPC0_LA00_CC_N

set_property  -dict {PACKAGE_PIN  AK38}                      [get_ports ref_clk0_p]      ; ## FMC_HPC0_GBTCLK0_M2C_C_P
set_property  -dict {PACKAGE_PIN  AK39}                      [get_ports ref_clk0_n]      ; ## FMC_HPC0_GBTCLK0_M2C_C_N

set_property  -dict {PACKAGE_PIN  AR45}                      [get_ports rx_data_p[0]]    ; ## FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AR46}                      [get_ports rx_data_n[0]]    ; ## FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AN45}                      [get_ports rx_data_p[1]]    ; ## FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AN46}                      [get_ports rx_data_n[1]]    ; ## FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AL45}                      [get_ports rx_data_p[2]]    ; ## FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AL46}                      [get_ports rx_data_n[2]]    ; ## FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AJ45}                      [get_ports rx_data_p[3]]    ; ## FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AJ46}                      [get_ports rx_data_n[3]]    ; ## FMC_HPC0_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  AP37 IOSTANDARD LVCMOS18}  [get_ports spi_csn_clk]     ; ## FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  AJ32 IOSTANDARD LVCMOS18}  [get_ports spi_csn_adc]     ; ## FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  AL30 IOSTANDARD LVCMOS18}  [get_ports spi_clk]         ; ## FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AL31 IOSTANDARD LVCMOS18}  [get_ports spi_sdio]        ; ## FMC_HPC0_LA01_CC_N

set_property  -dict {PACKAGE_PIN  AK32 IOSTANDARD LVCMOS18}  [get_ports pwdn]            ; ## FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  AP36 IOSTANDARD LVCMOS18}  [get_ports rstb]            ; ## FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  AT39 IOSTANDARD LVCMOS18}  [get_ports refsel]          ; ## FMC_HPC0_LA03_P

set_property  -dict {PACKAGE_PIN  AR37 IOSTANDARD LVDS}      [get_ports rx_sync_p]       ; ## FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AT37 IOSTANDARD LVDS}      [get_ports rx_sync_n]       ; ## FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  AK29 IOSTANDARD LVDS}      [get_ports sysref_p]        ; ## FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  AK30 IOSTANDARD LVDS}      [get_ports sysref_n]        ; ## FMC_HPC0_LA08_N

# clocks
create_clock -period 2.66666 -name rx_ref_clk  [get_ports ref_clk0_p]
create_clock -period 4       -name rx_ref_clk2 [get_ports glblclk_p]
# create_generated_clock       -name rx_link_clk [get_pins i_system_wrapper/system_i/util_ad9083_xcvr/inst/i_xch_0/i_gtye4_channel/RXOUTCLK]

set_input_delay -clock [get_clocks rx_ref_clk2] [get_property PERIOD [get_clocks rx_ref_clk2]] \
               [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]

# set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
# set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
# set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
# set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
# set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_core_clk_ibufds_1/O]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets core_clk]
