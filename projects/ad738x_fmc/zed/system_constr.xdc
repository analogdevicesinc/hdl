###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports spi_sclk]            ; ## G6 FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports spi_sdia]            ; ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports spi_sdib]            ; ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports spi_sdo]             ; ## H7  FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports spi_cs]              ; ## G7  FMC_LA00_CC_N  IO_L13N_T2_MRCC_34
