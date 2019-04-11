
# ad40xx_fmc SPI interface

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sdo]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sdi]       ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_sclk]      ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 IOB TRUE} [get_ports ad40xx_spi_cs]        ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports ad40xx_amp_pd]        ; ## G10  FMC_LPC_LA03_N

