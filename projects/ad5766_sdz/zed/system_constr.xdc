
# SPI interface

set_property -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS25} [get_ports spi_sclk]   ; ## FMC_LPC_LA15_N
set_property -dict {PACKAGE_PIN K21  IOSTANDARD LVCMOS25} [get_ports spi_sdo]    ; ## FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS25} [get_ports spi_sdi]    ; ## FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports spi_cs]     ; ## FMC_LPC_LA15_P

# reset signal

set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS25} [get_ports reset]      ; ## FMC_LPC_LA21_P

