###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# DAC SPI interface
set_property -dict {PACKAGE_PIN H15  IOSTANDARD LVCMOS33} [get_ports spi_sck]           ; ## ck_sck H15
set_property -dict {PACKAGE_PIN T12  IOSTANDARD LVCMOS33} [get_ports spi_sdo]           ; ## ck_mosi T12
set_property -dict {PACKAGE_PIN W15  IOSTANDARD LVCMOS33} [get_ports spi_sdi]           ; ## ck_miso W15
set_property -dict {PACKAGE_PIN F16  IOSTANDARD LVCMOS33} [get_ports spi_csb]           ; ## ck_ss F16

# DAC GPIO interface
set_property -dict {PACKAGE_PIN V13  IOSTANDARD LVCMOS33} [get_ports dac_resetb]        ; ## ck_io[1] V13
set_property -dict {PACKAGE_PIN T14  IOSTANDARD LVCMOS33} [get_ports dac_ldacb]         ; ## ck_io[2] T14
