
# fmc hdmi rx (adv7611)

set_property  -dict {PACKAGE_PIN  D18     IOSTANDARD LVCMOS25}                 [get_ports  hdmi_rx_clk]          ; ## G2   FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  A17     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[0]]      ; ## H32  FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN  A16     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[1]]      ; ## H31  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  C18     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[2]]      ; ## G31  FMC_LPC_LA29_N
set_property  -dict {PACKAGE_PIN  D21     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[3]]      ; ## C27  FMC_LPC_LA27_N
set_property  -dict {PACKAGE_PIN  E18     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[4]]      ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  C17     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[5]]      ; ## G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  E21     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[6]]      ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  F18     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[7]]      ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  A22     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[8]]      ; ## H38  FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN  A21     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[9]]      ; ## H37  FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN  B22     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[10]]     ; ## G37  FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN  B21     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[11]]     ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  B15     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[12]]     ; ## H35  FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN  C15     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[13]]     ; ## H34  FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN  B17     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[14]]     ; ## G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  B16     IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_rx_data[15]]     ; ## G33  FMC_LPC_LA31_P
set_property  -dict {PACKAGE_PIN  N19     IOSTANDARD LVCMOS25}                 [get_ports  hdmi_rx_int]          ; ## D08  FMC_LPC_LA01_CC_P

# fmc hdmi tx (adv7511)

set_property  -dict {PACKAGE_PIN   C19    IOSTANDARD LVCMOS25}                 [get_ports  hdmi_tx_clk]          ; ## G3   FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN   A18    IOSTANDARD LVCMOS25}                 [get_ports  hdmi_tx_spdif]        ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN   C22    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[0]]      ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN   D22    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[1]]      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN   E20    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[2]]      ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN   D15    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[3]]      ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN   E19    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[4]]      ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN   F19    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[5]]      ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN   C20    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[6]]      ; ## C23  FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN   E15    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[7]]      ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN   G19    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[8]]      ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN   G16    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[9]]      ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN   D20    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[10]]     ; ## C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN   B20    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[11]]     ; ## D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN   G15    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[12]]     ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN   G21    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[13]]     ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN   B19    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[14]]     ; ## D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN   G20    IOSTANDARD LVCMOS25     IOB TRUE}    [get_ports  hdmi_tx_data[15]]     ; ## G21  FMC_LPC_LA20_P

# iic pins

set_property  -dict {PACKAGE_PIN   J20    IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_scl]         ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN   K21    IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_sda]         ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN   N20    IOSTANDARD LVCMOS25}    [get_ports  hdmi_iic_rstn]        ; ## D9   FMC_LPC_LA01_CC_N

# clock definition

create_clock -period 6.66667  -name hdmi_rx_clk  [get_ports hdmi_rx_clk]

