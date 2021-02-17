
set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25} [get_ports mii_rx_clk]                ; ## D08  FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS25} [get_ports mii_rx_er]                 ; ## C22  FMC_LPC_LA18_CC_P
set_property -dict {PACKAGE_PIN G20  IOSTANDARD LVCMOS25} [get_ports mii_rx_dv]                 ; ## G21  FMC_LPC_LA20_P

set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS25} [get_ports {mii_rxd[0]}]              ; ## H26  FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS25} [get_ports {mii_rxd[1]}]              ; ## D27  FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS25} [get_ports {mii_rxd[2]}]              ; ## G27  FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN D21  IOSTANDARD LVCMOS25} [get_ports {mii_rxd[3]}]              ; ## C27  FMC_LPC_LA27_N

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_clk]      ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN K19  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_en]       ; ## C18  FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN K20  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports mii_tx_er]       ; ## C19  FMC_LPC_LA14_N

set_property -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd[0]}]    ; ## G13  FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN K18  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd[1]}]    ; ## D12  FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd[2]}]    ; ## G12  FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {mii_txd[3]}]    ; ## D11  FMC_LPC_LA05_P

set_property -dict {PACKAGE_PIN J20  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mdio_fmc]      ; ## G18  FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21  IOSTANDARD LVCMOS25} [get_ports mdc_fmc]                   ; ## G19  FMC_LPC_LA16_N

set_property -dict {PACKAGE_PIN C20  IOSTANDARD LVCMOS25} [get_ports link_st]                   ; ## C23  FMC_LPC_LA18_CC_N
set_property -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS25} [get_ports reset_n]                   ; ## H19  FMC_LPC_LA15_P

create_clock -name rx_clk -period 40.0 [get_ports mii_rx_clk]
create_clock -name tx_clk -period 40.0 [get_ports mii_tx_clk]

