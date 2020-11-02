
# ad4696_fmc SPI interface

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sdi]       ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sdo]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sclk]      ; ## D09  FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_cs]        ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_cnv]       ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad469x_resetn]        ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad469x_busy_alt_gp0]  ; ## H08  FMC_LPC_LA02_N
