
# constraints
# hdmi

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS25}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AA21  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AB22  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  V19   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  V20   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  U20   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  W21   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  T19   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  R19   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  T17   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  T16   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS25} [get_ports spdif]

# iic

set_property  -dict {PACKAGE_PIN  W11   IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  W8    IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  G19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]   ; ## GPIO_SW_N
set_property  -dict {PACKAGE_PIN  F19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]   ; ## GPIO_SW_S
set_property  -dict {PACKAGE_PIN  W6    IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]   ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  W7    IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]   ; ## GPIO_DIP_SW1

set_property  -dict {PACKAGE_PIN  P17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]   ; ## PMOD2_3_LS
set_property  -dict {PACKAGE_PIN  P18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[5]]   ; ## PMOD2_2_LS
set_property  -dict {PACKAGE_PIN  W10   IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]   ; ## PMOD2_1_LS
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]   ; ## PMOD2_0_LS
set_property  -dict {PACKAGE_PIN  E15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]   ; ## PMOD1_0_LS
set_property  -dict {PACKAGE_PIN  D15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]   ; ## PMOD1_1_LS
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]  ; ## PMOD1_2_LS
set_property  -dict {PACKAGE_PIN  W5    IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]  ; ## PMOD1_3_LS

set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]  ; ## XADC_GPIO_0
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]  ; ## XADC_GPIO_1
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]  ; ## XADC_GPIO_2
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]  ; ## XADC_GPIO_3
