## ad9694
set_property  -dict {PACKAGE_PIN  G27}                        [get_ports ref_clk0_p]      ; ## FMC_HPC1_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G28}                        [get_ports ref_clk0_n]      ; ## FMC_HPC1_GBTCLK0_M2C_P

set_property  -dict {PACKAGE_PIN  D33}                        [get_ports rx_data_p[3]]    ; ## FMC_HPC1_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D34}                        [get_ports rx_data_n[3]]    ; ## FMC_HPC1_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  H33}                        [get_ports rx_data_p[1]]    ; ## FMC_HPC1_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  H34}                        [get_ports rx_data_n[1]]    ; ## FMC_HPC1_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  E31}                        [get_ports rx_data_p[2]]    ; ## FMC_HPC1_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E32}                        [get_ports rx_data_n[2]]    ; ## FMC_HPC1_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  K33}                        [get_ports rx_data_p[0]]    ; ## FMC_HPC1_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  K34}                        [get_ports rx_data_n[0]]    ; ## FMC_HPC1_DP5_M2C_N

# not used
set_property  -dict {PACKAGE_PIN  L31}                        [get_ports rx_dummy_p[0]]    ; ## FMC_HPC1_DP4_M2C_P
set_property  -dict {PACKAGE_PIN  L32}                        [get_ports rx_dummy_n[0]]    ; ## FMC_HPC1_DP4_M2C_N
set_property  -dict {PACKAGE_PIN  F33}                        [get_ports rx_dummy_p[1]]    ; ## FMC_HPC1_DP7_M2C_P
set_property  -dict {PACKAGE_PIN  F34}                        [get_ports rx_dummy_n[1]]    ; ## FMC_HPC1_DP7_M2C_N

set_property  -dict {PACKAGE_PIN  AH2 IOSTANDARD LVCMOS18}    [get_ports spi_csn]         ; ## FMC_HPC1_LA06_P
set_property  -dict {PACKAGE_PIN  AD2 IOSTANDARD LVCMOS18}    [get_ports spi_miso]        ; ## FMC_HPC1_LA02_P
set_property  -dict {PACKAGE_PIN  AJ6 IOSTANDARD LVCMOS18}    [get_ports spi_clk]         ; ## FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AJ5 IOSTANDARD LVCMOS18}    [get_ports spi_mosi]        ; ## FMC_HPC1_LA01_CC_N

set_property  -dict {PACKAGE_PIN  A20 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_csn]    ; ## PMOD0_0
set_property  -dict {PACKAGE_PIN  B20 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_mosi]   ; ## PMOD0_1
set_property  -dict {PACKAGE_PIN  A22 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_miso]   ; ## PMOD0_2
set_property  -dict {PACKAGE_PIN  A21 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_clk]    ; ## PMOD0_3

set_property  -dict {PACKAGE_PIN  AD1  IOSTANDARD LVCMOS18}   [get_ports pwdn]            ; ## FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN  AH1  IOSTANDARD LVCMOS18}   [get_ports fda]             ; ## FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1  IOSTANDARD LVCMOS18}   [get_ports fdb]             ; ## FMC_HPC1_LA03_N

set_property  -dict {PACKAGE_PIN  AF2  IOSTANDARD LVDS}       [get_ports rx_sync1_p]       ; ## FMC_HPC1_LA04_P DSYNC_TO_DUT_CD+
set_property  -dict {PACKAGE_PIN  AF1  IOSTANDARD LVDS}       [get_ports rx_sync1_n]       ; ## FMC_HPC1_LA04_N DSYNC_TO_DUT_CD-

set_property  -dict {PACKAGE_PIN  AD4  IOSTANDARD LVDS}       [get_ports rx_sync0_p]       ; ## FMC_HPC1_LA07_P DSYNC_TO_DUT_AB+
set_property  -dict {PACKAGE_PIN  AE4  IOSTANDARD LVDS}       [get_ports rx_sync0_n]       ; ## FMC_HPC1_LA07_N DSYNC_TO_DUT_AB-

set_property  -dict {PACKAGE_PIN  J27}                        [get_ports sysref_p]        ; ## USER_SMA_MGT_CLOCK_P
set_property  -dict {PACKAGE_PIN  J28}                        [get_ports sysref_n]        ; ## USER_SMA_MGT_CLOCK_N

## clocks
create_clock -period 4 -name rx_ref_clk [get_ports ref_clk0_p]
