###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints

set_property -dict  {PACKAGE_PIN  AN8   IOSTANDARD  LVCMOS18} [get_ports sys_rst]

# uart

set_property -dict  {PACKAGE_PIN  K26   IOSTANDARD  LVCMOS18} [get_ports uart_sout]
set_property -dict  {PACKAGE_PIN  G25   IOSTANDARD  LVCMOS18} [get_ports uart_sin]

# ethernet  (phy_rst_n automation cannot be used with axi_ethernet 7.0)

set_property -dict  {PACKAGE_PIN  J23   IOSTANDARD  LVCMOS18}  [get_ports phy_rst_n]

# fan

set_property -dict  {PACKAGE_PIN  AJ9   IOSTANDARD  LVCMOS18} [get_ports fan_pwm]

# sw/led

set_property -dict  {PACKAGE_PIN  AP8   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[0]]
set_property -dict  {PACKAGE_PIN  H23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[1]]
set_property -dict  {PACKAGE_PIN  P20   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[2]]
set_property -dict  {PACKAGE_PIN  P21   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[3]]
set_property -dict  {PACKAGE_PIN  N22   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[4]]
set_property -dict  {PACKAGE_PIN  M22   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[5]]
set_property -dict  {PACKAGE_PIN  R23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[6]]
set_property -dict  {PACKAGE_PIN  P23   IOSTANDARD  LVCMOS18} [get_ports gpio_bd[7]]
set_property -dict  {PACKAGE_PIN  AN16  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[8]];   ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  AN19  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[9]];   ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  AP18  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[10]];  ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  AN14  IOSTANDARD  LVCMOS12  DRIVE 8} [get_ports gpio_bd[11]];  ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  AD10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[12]];  ## GPIO_SW_N
set_property -dict  {PACKAGE_PIN  AE8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[13]];  ## GPIO_SW_E
set_property -dict  {PACKAGE_PIN  AF8   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[14]];  ## GPIO_SW_S
set_property -dict  {PACKAGE_PIN  AF9   IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[15]];  ## GPIO_SW_W
set_property -dict  {PACKAGE_PIN  AE10  IOSTANDARD  LVCMOS18  DRIVE 8} [get_ports gpio_bd[16]];  ## GPIO_SW_C

# iic

set_property -dict  {PACKAGE_PIN  J24   IOSTANDARD  LVCMOS18} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  J25   IOSTANDARD  LVCMOS18} [get_ports iic_sda]

# ddr

set_property -dict  {PACKAGE_PIN  AK17} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  AK16} [get_ports sys_clk_n]

set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 44]
set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 45]
set_property -dict  {INTERNAL_VREF {0.84}}  [get_iobanks 46]

#Setting the Configuration Bank Voltage Select
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

# Create SPI clock
create_generated_clock -name spi_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi/sck_o]
