###############################################################################
## Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# data interface

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports spi_sclk]; ## G6   FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports sdi];      ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports sdo];      ## C11  FMC_LA06_N      IO_L10N_T1_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports cnv];      ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports spi_clk];  ## H4   FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports chain];    ## G7   FMC_LA00_CC_N   IO_L13N_T2_MRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports dcg];      ## D9   FMC_LA01_CC_N   IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports busy];     ## C11  FMC_LA18_CC_P   IO_L14P_T2_AD4P_SRCC_35
# set_property -dict {PACKAGE_PIN #N/A IOSTANDARD LVCMOS25} [get_ports enable]    ; ## D1  FMC_PG_C2M      #N/A
