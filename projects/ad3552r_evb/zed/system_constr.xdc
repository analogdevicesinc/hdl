
# ad40xx_fmc SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[0]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[1]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[2]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {ad3552r_spi_sdio[3]}]

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_sclk]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad3552r_spi_cs]

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad3552r_ldacn]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports ad3552r_resetn]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad3552r_alertn]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad3552r_qspi_sel]

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_6]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_7]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_8]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports ad3552r_gpio_9]

