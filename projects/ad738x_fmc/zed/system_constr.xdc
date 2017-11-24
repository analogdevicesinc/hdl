
# SPI interface

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports spi_sclk]            ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports spi_sdia]            ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25} [get_ports spi_sdib]            ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25} [get_ports spi_sdo]             ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports spi_cs]              ; ## FMC_LPC_LA00_CC_N

