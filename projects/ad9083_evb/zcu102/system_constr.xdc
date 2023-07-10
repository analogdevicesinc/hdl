###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9083

#input
set_property  -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE}       [get_ports glblclk_p]       ; ## FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE}       [get_ports glblclk_n]       ; ## FMC_HPC0_LA00_CC_N

set_property  -dict {PACKAGE_PIN  G8}                        [get_ports ref_clk0_p]      ; ## FMC_HPC0_GBTCLK0_M2C_C_P
set_property  -dict {PACKAGE_PIN  G7}                        [get_ports ref_clk0_n]      ; ## FMC_HPC0_GBTCLK0_M2C_C_N

set_property  -dict {PACKAGE_PIN  H2}                        [get_ports rx_data_p[0]]    ; ## FMC_HPC0_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  H1}                        [get_ports rx_data_n[0]]    ; ## FMC_HPC0_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  J4}                        [get_ports rx_data_p[1]]    ; ## FMC_HPC0_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  J3}                        [get_ports rx_data_n[1]]    ; ## FMC_HPC0_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  F2}                        [get_ports rx_data_p[2]]    ; ## FMC_HPC0_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  F1}                        [get_ports rx_data_n[2]]    ; ## FMC_HPC0_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  K2}                        [get_ports rx_data_p[3]]    ; ## FMC_HPC0_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  K1}                        [get_ports rx_data_n[3]]    ; ## FMC_HPC0_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  U4  IOSTANDARD LVCMOS18}   [get_ports spi_csn_clk]     ; ## FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  V2  IOSTANDARD LVCMOS18}   [get_ports spi_csn_adc]     ; ## FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD LVCMOS18}   [get_ports spi_clk]         ; ## FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD LVCMOS18}   [get_ports spi_sdio]        ; ## FMC_HPC0_LA01_CC_N

set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVCMOS18}   [get_ports pwdn]            ; ## FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  U5  IOSTANDARD LVCMOS18}   [get_ports rstb]            ; ## FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18}   [get_ports refsel]          ; ## FMC_HPC0_LA03_P

set_property  -dict {PACKAGE_PIN  AA2 IOSTANDARD LVDS}       [get_ports rx_sync_p]       ; ## FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1 IOSTANDARD LVDS}       [get_ports rx_sync_n]       ; ## FMC_HPC0_LA04_N

set_property  -dict {PACKAGE_PIN  V4  IOSTANDARD LVDS}       [get_ports sysref_p]        ; ## FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  V3  IOSTANDARD LVDS}       [get_ports sysref_n]        ; ## FMC_HPC0_LA08_N

# clocks
create_clock -period 2 -name rx_ref_clk [get_ports ref_clk0_p]
create_clock -period 8 -name rx_ref_clk2 [get_ports glblclk_p]

set_input_delay -clock [get_clocks rx_ref_clk2] [get_property PERIOD [get_clocks rx_ref_clk2]] \
                [get_ports -regexp -filter { NAME =~  ".*sysref.*" && DIRECTION == "IN" }]

