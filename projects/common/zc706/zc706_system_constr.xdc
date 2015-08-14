
# constraints

# hdmi

set_property  -dict {PACKAGE_PIN  P28   IOSTANDARD LVCMOS25}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  R22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  V24   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  U24   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  R23   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  AA25  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AE28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  T23   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AB25  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  T27   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AD26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  AB26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  AA28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  AC26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  AE30  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  Y25   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  AA29  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  AD30  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[15]]
set_property  -dict {PACKAGE_PIN  Y28   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[16]]
set_property  -dict {PACKAGE_PIN  AF28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[17]]
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[18]]
set_property  -dict {PACKAGE_PIN  AA27  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[19]]
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[20]]
set_property  -dict {PACKAGE_PIN  N28   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[21]]
set_property  -dict {PACKAGE_PIN  V21   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[22]]
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[23]]

# spdif

set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS25} [get_ports spdif]

# iic

set_property  -dict {PACKAGE_PIN  AJ14  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  AJ18  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]           ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]           ; ## GPIO_DIP_SW1
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]           ; ## GPIO_DIP_SW2
set_property  -dict {PACKAGE_PIN  AJ13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]           ; ## GPIO_DIP_SW3
set_property  -dict {PACKAGE_PIN  AK25  IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]           ; ## GPIO_SW_LEFT
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS15} [get_ports gpio_bd[5]]           ; ## GPIO_SW_CENTER
set_property  -dict {PACKAGE_PIN  R27   IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]           ; ## GPIO_SW_RIGHT

set_property  -dict {PACKAGE_PIN  Y21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]           ; ## GPIO_LED_LEFT
set_property  -dict {PACKAGE_PIN  G2    IOSTANDARD LVCMOS15} [get_ports gpio_bd[8]]           ; ## GPIO_LED_CENTER
set_property  -dict {PACKAGE_PIN  W21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]           ; ## GPIO_LED_RIGHT
set_property  -dict {PACKAGE_PIN  A17   IOSTANDARD LVCMOS15} [get_ports gpio_bd[10]]          ; ## GPIO_LED_0

set_property  -dict {PACKAGE_PIN  H14   IOSTANDARD LVCMOS15} [get_ports gpio_bd[11]]          ; ## XADC_GPIO_0
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS15} [get_ports gpio_bd[12]]          ; ## XADC_GPIO_1
set_property  -dict {PACKAGE_PIN  J16   IOSTANDARD LVCMOS15} [get_ports gpio_bd[13]]          ; ## XADC_GPIO_2
set_property  -dict {PACKAGE_PIN  J14   IOSTANDARD LVCMOS15} [get_ports gpio_bd[14]]          ; ## XADC_GPIO_3

