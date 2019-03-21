
# SPI interface

set_property -dict {PACKAGE_PIN  N19 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_0_spi_sclk]    ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN  P17 IOSTANDARD LVCMOS25 IOB TRUE PULLTYPE PULLUP}  [get_ports ad7768_0_spi_miso]    ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN  N22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_spi_mosi]    ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN  M21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_spi_cs]      ; ## FMC_LPC_LA04_P

set_property -dict {PACKAGE_PIN  N20 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_1_spi_sclk]    ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN  P18 IOSTANDARD LVCMOS25 IOB TRUE PULLTYPE PULLUP}  [get_ports ad7768_1_spi_miso]    ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN  P22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_spi_mosi]    ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN  M22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_spi_cs]      ; ## FMC_LPC_LA04_N

# reset and GPIO signals

set_property -dict {PACKAGE_PIN  P20 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_reset]       ; ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN  J21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_gpio[0]]     ; ## FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN  R20 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_gpio[1]]     ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN  R19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_gpio[2]]     ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN  N17 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_gpio[3]]     ; ## FMC_LPC_LA11_P

set_property -dict {PACKAGE_PIN  P21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_reset]       ; ## FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN  J22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_gpio[0]]     ; ## FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN  R21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_gpio[1]]     ; ## FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN  T19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_gpio[2]]     ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN  N18 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_gpio[3]]     ; ## FMC_LPC_LA11_N

# syncronization and timing

set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_0_drdy]        ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN  L19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_sync_out]    ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN  L21 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_sync_in]     ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN  M19 IOSTANDARD LVCMOS25}                           [get_ports ad7768_0_mclk]        ; ## FMC_LPC_LA00_CC_P

set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS25 IOB TRUE}                  [get_ports ad7768_1_drdy]        ; ## FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN  T16 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_sync_out]    ; ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN  L22 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_sync_in]     ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN  M20 IOSTANDARD LVCMOS25}                           [get_ports ad7768_1_mclk]        ; ## FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN  L18 IOSTANDARD LVCMOS25}                           [get_ports ad7768_mclk_return]   ; ## FMC_LPC_LA00_CC_P

