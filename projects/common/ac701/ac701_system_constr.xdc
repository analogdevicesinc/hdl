
# constraints

set_property -dict  {PACKAGE_PIN  U4    IOSTANDARD  LVCMOS15} [get_ports sys_rst]

# clocks

set_property -dict  {PACKAGE_PIN  R3    IOSTANDARD  DIFF_SSTL15 DIFF_TERM TRUE} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  P3    IOSTANDARD  DIFF_SSTL15 DIFF_TERM TRUE} [get_ports sys_clk_n]

# ethernet

set_property -dict  {PACKAGE_PIN V18    IOSTANDARD  LVCMOS18} [get_ports phy_reset_n]

set_property -dict  {PACKAGE_PIN W18    IOSTANDARD  LVCMOS18} [get_ports phy_mdc]
set_property -dict  {PACKAGE_PIN T14    IOSTANDARD  LVCMOS18} [get_ports phy_mdio]

set_property -dict  {PACKAGE_PIN U22    IOSTANDARD  LVCMOS18} [get_ports phy_tx_clk]
set_property -dict  {PACKAGE_PIN T15    IOSTANDARD  LVCMOS18} [get_ports phy_tx_ctrl]
set_property -dict  {PACKAGE_PIN T17    IOSTANDARD  LVCMOS18} [get_ports phy_tx_data[3]]
set_property -dict  {PACKAGE_PIN T18    IOSTANDARD  LVCMOS18} [get_ports phy_tx_data[2]]
set_property -dict  {PACKAGE_PIN U15    IOSTANDARD  LVCMOS18} [get_ports phy_tx_data[1]]
set_property -dict  {PACKAGE_PIN U16    IOSTANDARD  LVCMOS18} [get_ports phy_tx_data[0]]

set_property -dict  {PACKAGE_PIN U21    IOSTANDARD  LVCMOS18} [get_ports phy_rx_clk]
set_property -dict  {PACKAGE_PIN U14    IOSTANDARD  LVCMOS18} [get_ports phy_rx_ctrl]
set_property -dict  {PACKAGE_PIN V14    IOSTANDARD  LVCMOS18} [get_ports phy_rx_data[3]]
set_property -dict  {PACKAGE_PIN V16    IOSTANDARD  LVCMOS18} [get_ports phy_rx_data[2]]
set_property -dict  {PACKAGE_PIN V17    IOSTANDARD  LVCMOS18} [get_ports phy_rx_data[1]]
set_property -dict  {PACKAGE_PIN U17    IOSTANDARD  LVCMOS18} [get_ports phy_rx_data[0]]

# uart

set_property -dict  {PACKAGE_PIN  T19   IOSTANDARD  LVCMOS18} [get_ports uart_sin]
set_property -dict  {PACKAGE_PIN  U19   IOSTANDARD  LVCMOS18} [get_ports uart_sout]

# fan

set_property -dict  {PACKAGE_PIN  J26   IOSTANDARD  LVCMOS25} [get_ports fan_pwm]

# lcd

set_property -dict  {PACKAGE_PIN  L20   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[6]]   ; ## lcd_e
set_property -dict  {PACKAGE_PIN  L23   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[5]]   ; ## lcd_rs
set_property -dict  {PACKAGE_PIN  L24   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[4]]   ; ## lcd_rw
set_property -dict  {PACKAGE_PIN  L22   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[3]]   ; ## lcd_db[7]
set_property -dict  {PACKAGE_PIN  M25   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[2]]   ; ## lcd_db[6]
set_property -dict  {PACKAGE_PIN  M24   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[1]]   ; ## lcd_db[5]
set_property -dict  {PACKAGE_PIN  L25   IOSTANDARD  LVCMOS33} [get_ports gpio_lcd[0]]   ; ## lcd_db[4]
set_property -dict  {PACKAGE_PIN  R8    IOSTANDARD  SSTL15}   [get_ports gpio_bd[0]]    ; ## GPIO_DIP_SW0
set_property -dict  {PACKAGE_PIN  P8    IOSTANDARD  SSTL15}   [get_ports gpio_bd[1]]    ; ## GPIO_DIP_SW1
set_property -dict  {PACKAGE_PIN  R7    IOSTANDARD  SSTL15}   [get_ports gpio_bd[2]]    ; ## GPIO_DIP_SW2
set_property -dict  {PACKAGE_PIN  R6    IOSTANDARD  SSTL15}   [get_ports gpio_bd[3]]    ; ## GPIO_DIP_SW3
set_property -dict  {PACKAGE_PIN  P6    IOSTANDARD  LVCMOS15} [get_ports gpio_bd[4]]    ; ## GPIO_SW_N
set_property -dict  {PACKAGE_PIN  U5    IOSTANDARD  SSTL15}   [get_ports gpio_bd[5]]    ; ## GPIO_SW_E
set_property -dict  {PACKAGE_PIN  T5    IOSTANDARD  SSTL15}   [get_ports gpio_bd[6]]    ; ## GPIO_SW_S
set_property -dict  {PACKAGE_PIN  R5    IOSTANDARD  SSTL15}   [get_ports gpio_bd[7]]    ; ## GPIO_SW_W
set_property -dict  {PACKAGE_PIN  U6    IOSTANDARD  SSTL15}   [get_ports gpio_bd[8]]    ; ## GPIO_SW_C
set_property -dict  {PACKAGE_PIN  M26   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[9]]    ; ## GPIO_LED_0_LS
set_property -dict  {PACKAGE_PIN  T24   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[10]]   ; ## GPIO_LED_1_LS
set_property -dict  {PACKAGE_PIN  T25   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[11]]   ; ## GPIO_LED_2_LS
set_property -dict  {PACKAGE_PIN  R26   IOSTANDARD  LVCMOS33} [get_ports gpio_bd[12]]   ; ## GPIO_LED_3_LS

# iic

set_property -dict  {PACKAGE_PIN  R17   IOSTANDARD  LVCMOS33} [get_ports iic_rstn]
set_property -dict  {PACKAGE_PIN  N18   IOSTANDARD  LVCMOS33  DRIVE 8 SLEW SLOW} [get_ports iic_scl]
set_property -dict  {PACKAGE_PIN  K25   IOSTANDARD  LVCMOS33  DRIVE 8 SLEW SLOW} [get_ports iic_sda]

# setting the vonfiguration bank voltage select

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Create SPI clock
create_generated_clock -name spi_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi/sck_o]
