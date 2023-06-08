###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints

set_property -dict  {PACKAGE_PIN  BM29  IOSTANDARD  LVCMOS12} [get_ports sys_rst]

# clocks
# DDR4 Component Memory I/F clock, fixed 100 MHz LVDS [U76]

set_property -dict  {PACKAGE_PIN  BH51   IOSTANDARD  LVDS} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  BJ51   IOSTANDARD  LVDS} [get_ports sys_clk_n]

# ethernet

set_property PACKAGE_PIN BG22 [get_ports phy_tx_p]
set_property PACKAGE_PIN BH22 [get_ports phy_tx_n]
set_property PACKAGE_PIN BJ22 [get_ports phy_rx_p]
set_property PACKAGE_PIN BK21 [get_ports phy_rx_n]

set_property -dict  {PACKAGE_PIN  BH27  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100} [get_ports phy_clk_p]
set_property -dict  {PACKAGE_PIN  BJ27  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100} [get_ports phy_clk_n]

set_property -dict  {PACKAGE_PIN  BN27  IOSTANDARD  LVCMOS18} [get_ports mdio_mdc]
set_property -dict  {PACKAGE_PIN  BG23  IOSTANDARD  LVCMOS18} [get_ports mdio_mdio]

# uart

set_property -dict  {PACKAGE_PIN  BP26  IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  BN26  IOSTANDARD  LVCMOS18} [get_ports uart_sout]

set_property -dict  {PACKAGE_PIN  BH24  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[0]]   ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  BG24  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[1]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  BG25  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[2]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  BF25  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[3]]   ; ## GPIO_LED_3_LS
set_property -dict  {PACKAGE_PIN  BF26  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[4]]   ; ## GPIO_LED_4_LS
set_property -dict  {PACKAGE_PIN  BF27  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[5]]   ; ## GPIO_LED_5_LS
set_property -dict  {PACKAGE_PIN  BG27  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[6]]   ; ## GPIO_LED_6_LS
set_property -dict  {PACKAGE_PIN  BG28  IOSTANDARD  LVCMOS18} [get_ports gpio_bd[7]]   ; ## GPIO_LED_7_LS

# iic

set_property -dict  {PACKAGE_PIN  BM27  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  BL28  IOSTANDARD  LVCMOS18  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

# Create SPI clock
create_generated_clock -name spi_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi/sck_o]

# Balance clocks
#
# Minimize skew on synchronous CDC timing paths between clocks originating
# from the same MMCM source. (sys_mem_clk and sys_cpu_clk)
# This is required mostly by the smart interconnect.
# Property must be applied directly to the output net of BUFGs.
set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS \
  [list [get_nets [get_property PARENT [get_nets {i_system_wrapper/system_i/sys_cpu_clk}]]] \
        [get_nets [get_property PARENT [get_nets {i_system_wrapper/system_i/sys_mem_clk}]]] \
  ]

