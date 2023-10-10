###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS25} [get_ports spi_sclk]            ; ## H20  FMC_LA15_N  IO_L2N_T0_34
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS25} [get_ports spi_sdi]             ; ## H17  FMC_LA11_N  IO_L5N_T0_34
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports spi_cs]              ; ## H19  FMC_LA15_P  IO_L2P_T0_34

# GPIO signals

set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[0]]    ; ## H25  FMC_LA21_P  IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[1]]    ; ## D26  FMC_LA26_P  IO_L5P_T0_AD9P_35
set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[2]]    ; ## G25  FMC_LA22_N  IO_L20N_T3_AD6N_35
set_property -dict {PACKAGE_PIN E21  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[3]]    ; ## C26  FMC_LA27_P  IO_L17P_T2_AD5P_35
set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[4]]    ; ## H26  FMC_LA21_N  IO_L21N_T3_DQS_AD14N_35
set_property -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[5]]    ; ## D27  FMC_LA26_N  IO_L5N_T0_AD9N_35
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[6]]    ; ## G27  FMC_LA25_P  IO_L16P_T2_35
set_property -dict {PACKAGE_PIN D21  IOSTANDARD LVCMOS25} [get_ports adaq7980_gpio[7]]    ; ## C27  FMC_LA27_N  IO_L17N_T2_AD5N_35

# REF_PD and RBUF_PD

set_property -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS25} [get_ports adaq7980_ref_pd]     ; ## H31  FMC_LA28_P  IO_L9P_T1_DQS_AD3P_35
set_property -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS25} [get_ports adaq7980_rbuf_pd]    ; ## G30  FMC_LA29_P  IO_L11P_T1_SRCC_35
