###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_sclk]; ## D17   FMC_LA13_P
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_miso]; ## C19   FMC_LA14_N
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_mosi]; ## H19   FMC_LA15_P
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_cs_0]; ## G17   FMC_LA16_P  CS_FPGA
set_property -dict {PACKAGE_PIN G27 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_cs_1]; ## G27   FMC_LA25_P  CS_DAC


# reset and GPIO signal

set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25}                          [get_ports ad77681_reset];    ## G15  FMC_LA12_P      IO_L18P_T2_34
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[0]];  ## G12  FMC_LA08_P      IO_L8P_T1_34
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[1]];  ## D14  FMC_LA09_P      IO_L17P_T2_34
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[2]];  ## C14  FMC_LA10_P      IO_L22P_T3_34
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25}                          [get_ports ad77681_gpio[3]];  ## H16  FMC_LA11_P      IO_L5P_T0_34

# syncronization and timing

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25}                          [get_ports ad77681_drdy];     ## D11  FMC_LA05_P      IO_L7P_T1_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS25}                          [get_ports ad77681_sync_out]; ## H5   FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25}                          [get_ports ad77681_sync_in];  ## C10  FMC_LA06_P      IO_L10P_T1_34
