###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25 IOB TRUE}                 [get_ports ad77681_spi_sclk]; ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE PULLTYPE PULLUP} [get_ports ad77681_spi_miso]; ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25}                          [get_ports ad77681_spi_mosi]; ## G9   FMC_LA03_P      IO_L16P_T2_34
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25}                          [get_ports ad77681_spi_cs];   ## H10  FMC_LA04_P      IO_L15P_T2_DQS_34

# reset and GPIO signal

set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25}                          [get_ports ad77681_reset];    ## G15  FMC_LA12_P      IO_L18P_T2_34
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[0]];  ## G12  FMC_LA08_P      IO_L8P_T1_34
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[1]];  ## D14  FMC_LA09_P      IO_L17P_T2_34
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[2]];  ## C14  FMC_LA10_P      IO_L22P_T3_34
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[3]];  ## H16  FMC_LA11_P      IO_L5P_T0_34

# syncronization and timin

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25}                          [get_ports ad77681_drdy];     ## D11  FMC_LA05_P      IO_L7P_T1_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS25}                          [get_ports ad77681_sync_out]; ## H5   FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25}                          [get_ports ad77681_sync_in];  ## C10  FMC_LA06_P      IO_L10P_T1_34
