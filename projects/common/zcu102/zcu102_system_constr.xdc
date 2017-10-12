
# constraints
# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  AN14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]           ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  AP14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]           ; ## GPIO_DIP_SW1
set_property  -dict {PACKAGE_PIN  AM14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]           ; ## GPIO_DIP_SW2
set_property  -dict {PACKAGE_PIN  AN13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]           ; ## GPIO_DIP_SW3
set_property  -dict {PACKAGE_PIN  AN12  IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]           ; ## GPIO_DIP_SW4
set_property  -dict {PACKAGE_PIN  AP12  IOSTANDARD LVCMOS25} [get_ports gpio_bd[5]]           ; ## GPIO_DIP_SW5
set_property  -dict {PACKAGE_PIN  AL13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]           ; ## GPIO_DIP_SW6
set_property  -dict {PACKAGE_PIN  AK13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]           ; ## GPIO_DIP_SW7
set_property  -dict {PACKAGE_PIN  AE14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]           ; ## GPIO_SW_E
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]           ; ## GPIO_SW_S
set_property  -dict {PACKAGE_PIN  AG15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]          ; ## GPIO_SW_N
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]          ; ## GPIO_SW_W
set_property  -dict {PACKAGE_PIN  AG13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]          ; ## GPIO_SW_C

set_property  -dict {PACKAGE_PIN  AG14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]          ; ## GPIO_LED_0
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]          ; ## GPIO_LED_1
set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]          ; ## GPIO_LED_2
set_property  -dict {PACKAGE_PIN  AJ14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[16]]          ; ## GPIO_LED_3
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[17]]          ; ## GPIO_LED_4
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[18]]          ; ## GPIO_LED_5
set_property  -dict {PACKAGE_PIN  AH14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[19]]          ; ## GPIO_LED_6
set_property  -dict {PACKAGE_PIN  AL12  IOSTANDARD LVCMOS25} [get_ports gpio_bd[20]]          ; ## GPIO_LED_7

