# ad713x SPI configuration interface

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sdi]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sdo]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sclk]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports {ad713x_spi_cs[0]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports {ad713x_spi_cs[1]}]

# ad713x data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ad713x_dclk]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[0]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[1]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[2]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[3]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[4]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[5]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[6]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports {ad713x_din[7]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad713x_odr]

# ad713x GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports {ad713x_resetn[0]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports {ad713x_resetn[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports {ad713x_pdn[0]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports {ad713x_pdn[1]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports {ad713x_mode[0]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {ad713x_mode[1]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[0]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[1]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[2]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[3]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[4]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[5]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports {ad713x_gpio[7]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports {ad713x_dclkio[0]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports {ad713x_dclkio[1]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad713x_pinbspi]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports ad713x_dclkmode]

# ad713x reference clock (not used by default)

set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad713x_sdpclk]

set_false_path -to [get_pins -hierarchical * -filter {NAME=~*busy_sync/inst/cdc_sync_stage1_reg[0]/D}]





