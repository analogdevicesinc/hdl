
# constraints
# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  AN14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[0]]           ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  AP14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[1]]           ; ## GPIO_DIP_SW1
set_property  -dict {PACKAGE_PIN  AM14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[2]]           ; ## GPIO_DIP_SW2
set_property  -dict {PACKAGE_PIN  AN13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[3]]           ; ## GPIO_DIP_SW3
set_property  -dict {PACKAGE_PIN  AN12  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[4]]           ; ## GPIO_DIP_SW4
set_property  -dict {PACKAGE_PIN  AP12  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[5]]           ; ## GPIO_DIP_SW5
set_property  -dict {PACKAGE_PIN  AL13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[6]]           ; ## GPIO_DIP_SW6
set_property  -dict {PACKAGE_PIN  AK13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[7]]           ; ## GPIO_DIP_SW7
set_property  -dict {PACKAGE_PIN  AE14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[8]]           ; ## GPIO_SW_E
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[9]]           ; ## GPIO_SW_S
set_property  -dict {PACKAGE_PIN  AG15  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[10]]          ; ## GPIO_SW_N
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[11]]          ; ## GPIO_SW_W
set_property  -dict {PACKAGE_PIN  AG13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[12]]          ; ## GPIO_SW_C

set_property  -dict {PACKAGE_PIN  AG14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[0]]           ; ## GPIO_LED_0
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[1]]           ; ## GPIO_LED_1
set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[2]]           ; ## GPIO_LED_2
set_property  -dict {PACKAGE_PIN  AJ14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[3]]           ; ## GPIO_LED_3
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[4]]           ; ## GPIO_LED_4
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[5]]           ; ## GPIO_LED_5
set_property  -dict {PACKAGE_PIN  AH14  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[6]]           ; ## GPIO_LED_6
set_property  -dict {PACKAGE_PIN  AL12  IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[7]]           ; ## GPIO_LED_7

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]
