###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN  Y11    IOSTANDARD LVCMOS33} [get_ports spi_csn];       # "JA1"
set_property  -dict {PACKAGE_PIN  AA8    IOSTANDARD LVCMOS33} [get_ports spi_clk];       # "JA10"
set_property  -dict {PACKAGE_PIN  AA11   IOSTANDARD LVCMOS33} [get_ports spi_mosi];      # "JA2"
set_property  -dict {PACKAGE_PIN  Y10    IOSTANDARD LVCMOS33} [get_ports spi_miso];      # "JA3"

set_property  -dict {PACKAGE_PIN  W12    IOSTANDARD LVCMOS33} [get_ports pmod_gpio[0]];  # "JB1"
set_property  -dict {PACKAGE_PIN  W11    IOSTANDARD LVCMOS33} [get_ports pmod_gpio[1]];  # "JB2"
set_property  -dict {PACKAGE_PIN  V10    IOSTANDARD LVCMOS33} [get_ports pmod_gpio[2]];  # "JB3"
set_property  -dict {PACKAGE_PIN  W8     IOSTANDARD LVCMOS33} [get_ports pmod_gpio[3]];  # "JB4"
