# ethernet-1

set_property  -dict {PACKAGE_PIN  AA20  IOSTANDARD LVCMOS18} [get_ports ETH1_MDC]
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS18} [get_ports ETH1_MDIO]
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxclk]
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxctl]
set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[0]]
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[1]]
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[2]]
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[3]]
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txclk]
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txctl]
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[0]]
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[1]]
set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[2]]
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[3]]

# uart

set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS18} [get_ports UART0_rxd]
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS18} [get_ports UART0_txd]

# hdmi

set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS18} [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  AB19  IOSTANDARD LVCMOS18} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  AA19  IOSTANDARD LVCMOS18} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS18} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  AA25  IOSTANDARD LVCMOS18} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AB25  IOSTANDARD LVCMOS18} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AB26  IOSTANDARD LVCMOS18} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  AC26  IOSTANDARD LVCMOS18} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS18} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  AE26  IOSTANDARD LVCMOS18} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AD25  IOSTANDARD LVCMOS18} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  AD26  IOSTANDARD LVCMOS18} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS18} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS18} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS18} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS18} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  AE22  IOSTANDARD LVCMOS18} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  AF22  IOSTANDARD LVCMOS18} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS18} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS18} [get_ports hdmi_data[15]]

# hdmi-spdif

set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS18} [get_ports spdif]

# hdmi-iic

set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_scl[0]]
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_sda[0]]

# audio

set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD LVCMOS18} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS18} [get_ports i2s_bclk]
set_property  -dict {PACKAGE_PIN  V19   IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]
set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]
set_property  -dict {PACKAGE_PIN  L9    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]

# audio-iic

set_property  -dict {PACKAGE_PIN  F13   IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_scl[1]]
set_property  -dict {PACKAGE_PIN  E13   IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_sda[1]]


