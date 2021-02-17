
set_property -dict {PACKAGE_PIN AJ6  IOSTANDARD LVCMOS18} [get_ports mii_rx_clk]                ; ## D08  FMC_HPC1_LA01_CC_P
set_property -dict {PACKAGE_PIN Y8   IOSTANDARD LVCMOS18} [get_ports mii_rx_er]                 ; ## C22  FMC_HPC1_LA18_CC_P
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports mii_rx_dv]                 ; ## G21  FMC_HPC1_LA20_P

set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18} [get_ports {mii_rxd[0]}]              ; ## H26  FMC_HPC1_LA21_N
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18} [get_ports {mii_rxd[1]}]              ; ## D27  FMC_HPC1_LA26_N
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports {mii_rxd[2]}]              ; ## G27  FMC_HPC1_LA25_P
set_property -dict {PACKAGE_PIN T10  IOSTANDARD LVCMOS18} [get_ports {mii_rxd[3]}]              ; ## C27  FMC_HPC1_LA27_N

set_property -dict {PACKAGE_PIN AE5  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports mii_tx_clk]      ; ## G06  FMC_HPC1_LA00_CC_P
set_property -dict {PACKAGE_PIN AH7  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports mii_tx_en]       ; ## C18  FMC_HPC1_LA14_P
set_property -dict {PACKAGE_PIN AH6  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports mii_tx_er]       ; ## C19  FMC_HPC1_LA14_N

set_property -dict {PACKAGE_PIN AF3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd[0]}]    ; ## G13  FMC_HPC1_LA08_N
set_property -dict {PACKAGE_PIN AH3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd[1]}]    ; ## D12  FMC_HPC1_LA05_N
set_property -dict {PACKAGE_PIN AE3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd[2]}]    ; ## G12  FMC_HPC1_LA08_P
set_property -dict {PACKAGE_PIN AG3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {mii_txd[3]}]    ; ## D11  FMC_HPC1_LA05_P

set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18 PULLUP true} [get_ports mdio_fmc]      ; ## G18  FMC_HPC1_LA16_P
set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVCMOS18} [get_ports mdc_fmc]                   ; ## G19  FMC_HPC1_LA16_N

set_property -dict {PACKAGE_PIN Y7   IOSTANDARD LVCMOS18} [get_ports link_st]                   ; ## C23  FMC_HPC1_LA18_CC_N
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports reset_n]                   ; ## H19  FMC_HPC1_LA15_P

create_clock -name rx_clk -period 40.0 [get_ports mii_rx_clk]
create_clock -name tx_clk -period 40.0 [get_ports mii_tx_clk]

create_clock -name mdio_clk_b -period 400.0 [get_pins i_system_wrapper/system_i/sys_ps8/inst/emio_enet1_mdio_mdc]

