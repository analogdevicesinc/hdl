###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25 IOB TRUE} [get_ports spi_sdia]; ## D8  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports spi_sdib];  ## D9  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS25} [get_ports spi_sdid];  ## G9  FMC_LA03_P     IO_L16P_T2_34
