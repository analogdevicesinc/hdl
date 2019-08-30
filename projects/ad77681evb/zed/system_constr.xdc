
# SPI interface

set_property -dict {PACKAGE_PIN  N19 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_spi_sclk]    ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN  P17 IOSTANDARD LVCMOS25 IOB TRUE PULLTYPE PULLUP}  [get_ports ad7768_spi_miso]    ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN  N22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_spi_mosi]    ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN  M21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_spi_cs]      ; ## FMC_LPC_LA04_P

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  P20 IOSTANDARD LVCMOS25}                           [get_ports ad7768_reset]       ; ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN  J21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_gpio[0]]     ; ## FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN  R20 IOSTANDARD LVCMOS25}                           [get_ports ad7768_gpio[1]]     ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN  R19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_gpio[2]]     ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN  N17 IOSTANDARD LVCMOS25}                           [get_ports ad7768_gpio[3]]     ; ## FMC_LPC_LA11_P

# syncronization and timing

set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_drdy]        ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN  L19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_sync_out]    ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN  L21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_sync_in]     ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN  M19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_mclk]        ; ## FMC_LPC_LA00_CC_P

set_property -dict {PACKAGE_PIN  L18 IOSTANDARD LVCMOS25}                           [get_ports ad7768_mclk_return]   ; ## FMC_LPC_CLK0_M2C_P

