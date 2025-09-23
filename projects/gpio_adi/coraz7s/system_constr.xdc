###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# User GPIO mapping for Coraz7s


# # Button [0]
# set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {btn[0]}] ; ## User Button BTN0

# # LED [0]
# set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[0]}] ; ## User LED LED0

## Buttons
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {btn[0]}] ; ## BTN0
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {btn[1]}] ; ## BTN1

## LEDs
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[0]}] ; ## LED0
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[1]}] ; ## LED1
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[2]}] ; ## LED2
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[3]}] ; ## LED3
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[4]}] ; ## LED4
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {led[5]}] ; ## LED5

## I2C (Arduino header)
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {iic_ard_scl}] ; ## I2C SCL
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {iic_ard_sda}] ; ## I2C SDA

# ## SPI ADC
# set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {adc_spi_sclk}] ; ## SPI SCLK
# set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {adc_spi_mosi}] ; ## SPI MOSI
# set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {adc_spi_csn}] ; ## SPI CSN
# set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {adc_spi_miso_rdyn}] ; ## SPI MISO_RDYN

