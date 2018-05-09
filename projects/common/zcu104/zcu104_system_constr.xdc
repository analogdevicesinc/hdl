
# constraints
# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  E4    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[0]]           ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  D4    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[1]]           ; ## GPIO_DIP_SW1
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[2]]           ; ## GPIO_DIP_SW2
set_property  -dict {PACKAGE_PIN  F4    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[3]]           ; ## GPIO_DIP_SW3
set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[4]]           ; ## GPIO_SW0
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[5]]           ; ## GPIO_SW1
set_property  -dict {PACKAGE_PIN  B3    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[6]]           ; ## GPIO_SW2
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS33} [get_ports gpio_bd_i[7]]           ; ## GPIO_SW3

set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[0]]           ; ## GPIO_LED_0
set_property  -dict {PACKAGE_PIN  D6    IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[1]]           ; ## GPIO_LED_1
set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[2]]           ; ## GPIO_LED_2
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS33} [get_ports gpio_bd_o[3]]           ; ## GPIO_LED_3
