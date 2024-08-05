###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25}          [get_ports pulsar_spi_cs];  ## G7   FMC_LA00_CC_N  IO_L13N_T2_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports pulsar_spi_sdo]; ## H7   FMC_LA02_P     IO_L20P_T3_34
