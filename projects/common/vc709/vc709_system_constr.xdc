###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints

set_property -dict  {PACKAGE_PIN  AV40  IOSTANDARD  LVCMOS18} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  H19   IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  G18   IOSTANDARD  DIFF_SSTL15} [get_ports sys_clk_n]

# uart

set_property -dict  {PACKAGE_PIN  AU33  IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  AU36  IOSTANDARD  LVCMOS18} [get_ports uart_sout]

# fan

set_property -dict  {PACKAGE_PIN  BA37  IOSTANDARD  LVCMOS18} [get_ports fan_pwm]

set_property -dict  {PACKAGE_PIN  AV30  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[0]]    ; ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  AY33  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[1]]    ; ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  BA31  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[2]]    ; ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  BA32  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[3]]    ; ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  AW30  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[4]]    ; ## GPIO_DIP_SW4
set_property -dict  {PACKAGE_PIN  AY30  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[5]]    ; ## GPIO_DIP_SW5
set_property -dict  {PACKAGE_PIN  BA30  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[6]]    ; ## GPIO_DIP_SW6
set_property -dict  {PACKAGE_PIN  BB31  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[7]]    ; ## GPIO_DIP_SW7
set_property -dict  {PACKAGE_PIN  AR40  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[8]]    ; ## GPIO_SW_N
set_property -dict  {PACKAGE_PIN  AU38  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[9]]    ; ## GPIO_SW_E
set_property -dict  {PACKAGE_PIN  AP40  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[10]]   ; ## GPIO_SW_S
set_property -dict  {PACKAGE_PIN  AW40  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[11]]   ; ## GPIO_SW_W
set_property -dict  {PACKAGE_PIN  AV39  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_i[12]]   ; ## GPIO_SW_C
set_property -dict  {PACKAGE_PIN  AM39  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[0]]   ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  AN39  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[1]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  AR37  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[2]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  AT37  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[3]]   ; ## GPIO_LED_3_LS
set_property -dict  {PACKAGE_PIN  AR35  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[4]]   ; ## GPIO_LED_4_LS
set_property -dict  {PACKAGE_PIN  AP41  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[5]]   ; ## GPIO_LED_5_LS
set_property -dict  {PACKAGE_PIN  AP42  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[6]]   ; ## GPIO_LED_6_LS
set_property -dict  {PACKAGE_PIN  AU39  IOSTANDARD  LVCMOS18} [get_ports gpio_bd_o[7]]   ; ## GPIO_LED_7_LS

# iic

set_property -dict  {PACKAGE_PIN  AY42  IOSTANDARD  LVCMOS18} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  AT35  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  AU32  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

#Setting the Configuration Bank Voltage Select
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

# Create SPI clock
create_generated_clock -name spi_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi/sck_o]
