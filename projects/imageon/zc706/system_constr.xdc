
# fmc hdmi rx (adv7611)

set_property  -dict {PACKAGE_PIN  AC28    IOSTANDARD LVCMOS25}                [get_ports  hdmi_rx_clk]          ; ## G2   FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AG30    IOSTANDARD LVCMOS25}                [get_ports  hdmi_rx_spdif]        ; ## H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  AE26    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[0]]      ; ## H32  FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN  AD25    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[1]]      ; ## H31  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  AF25    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[2]]      ; ## G31  FMC_LPC_LA29_N
set_property  -dict {PACKAGE_PIN  AJ29    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[3]]      ; ## C27  FMC_LPC_LA27_N
set_property  -dict {PACKAGE_PIN  AK30    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[4]]      ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  AE25    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[5]]      ; ## G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  AJ28    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[6]]      ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  AJ30    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[7]]      ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  Y27     IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[8]]      ; ## H38  FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN  Y26     IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[9]]      ; ## H37  FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN  AA30    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[10]]     ; ## G37  FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN  Y30     IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[11]]     ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  AB30    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[12]]     ; ## H35  FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN  AB29    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[13]]     ; ## H34  FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN  AD29    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[14]]     ; ## G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  AC29    IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_rx_data[15]]     ; ## G33  FMC_LPC_LA31_P
set_property  -dict {PACKAGE_PIN  AF15    IOSTANDARD LVCMOS25}                [get_ports  hdmi_rx_int]          ; ## D08  FMC_LPC_LA01_CC_P

# fmc hdmi tx (adv7511)

set_property  -dict {PACKAGE_PIN   AD28   IOSTANDARD LVCMOS25}                [get_ports  hdmi_tx_clk]          ; ## G3   FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN   AF30   IOSTANDARD LVCMOS25}                [get_ports  hdmi_tx_spdif]        ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN   AG29   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[0]]      ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN   AF29   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[1]]      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN   AH29   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[2]]      ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN   AK26   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[3]]      ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN   AH28   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[4]]      ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN   AK28   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[5]]      ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN   AF27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[6]]      ; ## C23  FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN   AJ26   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[7]]      ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN   AK27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[8]]      ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN   AH27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[9]]      ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN   AE27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[10]]     ; ## C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN   AC27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[11]]     ; ## D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN   AH26   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[12]]     ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN   AG27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[13]]     ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN   AB27   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[14]]     ; ## D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN   AG26   IOSTANDARD LVCMOS25    IOB TRUE}    [get_ports  hdmi_tx_data[15]]     ; ## G21  FMC_LPC_LA20_P

# iic pins

set_property  -dict {PACKAGE_PIN   AE18   IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_scl]         ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN   AE17   IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_sda]         ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN   AG15   IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_rstn]        ; ## D9   FMC_LPC_LA01_CC_N

# clock definition

create_clock -period 6.000  -name hdmi_rx_clk  [get_ports hdmi_rx_clk]

# default constraints

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

