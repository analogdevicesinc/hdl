
# DAC SPI interface

set_property -dict {PACKAGE_PIN E15  IOSTANDARD LVCMOS33} [get_ports spi_sclk]           ; ## FMC-LA23_P 
set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS33} [get_ports spi_sdi]            ; ## FMC-LA18_CC_P 
set_property -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS33} [get_ports spi_sdo]            ; ## FMC-LA17_CC_N
set_property -dict {PACKAGE_PIN B19  IOSTANDARD LVCMOS33} [get_ports spi_sync_n]         ; ## FMC-LA17_CC_P

# DAC GPIO interface
set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS33} [get_ports dac_fault_n]        ; ## FMC-LA22_N 
set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS33} [get_ports dac_reset_n]        ; ## FMC-LA21_P
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS33} [get_ports dac_ldac_n]         ; ## FMC-LA26_P 

# Reconfigure the pins from Bank 34 and Bank 35 to use LVCMOS33 since VADJ must be set to 3.3V

# otg
set_property IOSTANDARD LVCMOS33 [get_ports otg_vbusoc]

# gpio (switches, leds and such)
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[0]]       ; ## BTNC
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[1]]       ; ## BTND
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[2]]       ; ## BTNL
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[3]]       ; ## BTNR
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[4]]       ; ## BTNU

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[11]]      ; ## SW0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[12]]      ; ## SW1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[13]]      ; ## SW2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[14]]      ; ## SW3
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[15]]      ; ## SW4
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[16]]      ; ## SW5
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[17]]      ; ## SW6
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[18]]      ; ## SW7

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[31]]      ; ## OTG-RESETN

