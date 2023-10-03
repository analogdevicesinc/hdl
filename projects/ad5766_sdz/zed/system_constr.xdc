###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS25} [get_ports spi_sclk]   ; ## FMC_LA15_N IO_L2N_T0_34
set_property -dict {PACKAGE_PIN K21  IOSTANDARD LVCMOS25} [get_ports spi_sdo]    ; ## FMC_LA16_N IO_L9N_T1_DQS_34
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS25} [get_ports spi_sdi]    ; ## FMC_LA11_N IO_L5N_T0_34
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports spi_cs]     ; ## FMC_LA15_P IO_L2P_T0_34

# reset signal

set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25} [get_ports reset]      ; ## FMC_LA21_P IO_L21P_T3_DQS_AD14P_35
