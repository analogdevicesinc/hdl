
# constraints
# hdmi

set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVCMOS18}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  D14  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  E16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  G17  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  F15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  F13  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  G12  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  E13  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  D13  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  F12  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  E12  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property  -dict {PACKAGE_PIN  F17  IOSTANDARD LVCMOS18} [get_ports spdif]

# i2s

set_property  -dict {PACKAGE_PIN  C14   IOSTANDARD LVCMOS18} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  B17   IOSTANDARD LVCMOS18} [get_ports i2s_bclk]
set_property  -dict {PACKAGE_PIN  A17   IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]
set_property  -dict {PACKAGE_PIN  C17   IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]
set_property  -dict {PACKAGE_PIN  B16   IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]

# iic

set_property  -dict {PACKAGE_PIN  B15  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  A15  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_sda]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  B14  IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]           ; ## GPIO_DIP_SW4_PB0
set_property  -dict {PACKAGE_PIN  A14  IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]           ; ## GPIO_DIP_SW5_PB1
set_property  -dict {PACKAGE_PIN  A13  IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]           ; ## GPIO_DIP_SW6_PB2
set_property  -dict {PACKAGE_PIN  A12  IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]           ; ## GPIO_DIP_SW7_PB3

set_property  -dict {PACKAGE_PIN  C7   IOSTANDARD LVCMOS15} [get_ports gpio_bd[4]]           ; ## GPIO_SW_0
set_property  -dict {PACKAGE_PIN  B7   IOSTANDARD LVCMOS15} [get_ports gpio_bd[5]]           ; ## GPIO_SW_1
set_property  -dict {PACKAGE_PIN  A7   IOSTANDARD LVCMOS15} [get_ports gpio_bd[6]]           ; ## GPIO_SW_2
set_property  -dict {PACKAGE_PIN  B9   IOSTANDARD LVCMOS15} [get_ports gpio_bd[7]]           ; ## GPIO_SW_3
set_property  -dict {PACKAGE_PIN  A8   IOSTANDARD LVCMOS15} [get_ports gpio_bd[8]]           ; ## GPIO_SW_4
set_property  -dict {PACKAGE_PIN  A9   IOSTANDARD LVCMOS15} [get_ports gpio_bd[9]]           ; ## GPIO_SW_5
set_property  -dict {PACKAGE_PIN  B10  IOSTANDARD LVCMOS15} [get_ports gpio_bd[10]]          ; ## GPIO_SW_6
set_property  -dict {PACKAGE_PIN  A10  IOSTANDARD LVCMOS15} [get_ports gpio_bd[11]]          ; ## GPIO_SW_7

