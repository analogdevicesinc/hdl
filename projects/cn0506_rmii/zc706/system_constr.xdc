
set_property -dict {PACKAGE_PIN AF15  IOSTANDARD LVCMOS25} [get_ports rmii_rx_ref_clk_a]           ; ## D08 FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN AG15  IOSTANDARD LVCMOS25} [get_ports rmii_rx_er_a]                ; ## D09  FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN AA14  IOSTANDARD LVCMOS25 PULLUP true} [get_ports rmii_rx_dv_a]    ; ## H14 FMC_LPC_LA07_N
set_property -dict {PACKAGE_PIN AE13  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mac_if_sel_0_a]  ; ## G06 FMC_HPC1_LA00_CC_P
set_property -dict {PACKAGE_PIN AE12  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_a[0]}]             ; ## H07 FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN AF12  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_a[1]}]             ; ## H08 FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN AA15  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rmii_tx_en_a]      ; ## H13 FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN AH14  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_a[0]}]   ; ## D14 FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN AH13  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_a[1]}]   ; ## D15 FMC_LPC_LA09_N

set_property -dict {PACKAGE_PIN AJ16  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mdio_fmc_a]      ; ## H16 FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN AK16  IOSTANDARD LVCMOS25} [get_ports mdc_fmc_a]                   ; ## H17 FMC_LPC_LA11_N

set_property -dict {PACKAGE_PIN AB15  IOSTANDARD LVCMOS25} [get_ports reset_a]                     ; ## H19 FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN AJ15  IOSTANDARD LVCMOS25} [get_ports link_st_a]                   ; ## H10 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN AD14  IOSTANDARD LVCMOS25} [get_ports led_0_a]                     ; ## G12 FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN AD16  IOSTANDARD LVCMOS25} [get_ports led_ar_c_c2m]                ; ## G15 FMC_HPC1_LA12_P
set_property -dict {PACKAGE_PIN AD15  IOSTANDARD LVCMOS25} [get_ports led_ar_a_c2m]                ; ## G16 FMC_HPC1_LA12_N
set_property -dict {PACKAGE_PIN AH17  IOSTANDARD LVCMOS25} [get_ports led_al_c_c2m]                ; ## D17 FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN AH16  IOSTANDARD LVCMOS25} [get_ports led_al_a_c2m]                ; ## D18 FMC_LPC_LA13_N

set_property -dict {PACKAGE_PIN AB27  IOSTANDARD LVCMOS25} [get_ports rmii_rx_ref_clk_b]           ; ## D20 FMC_LPC_LA17_CC_P
set_property -dict {PACKAGE_PIN AC27  IOSTANDARD LVCMOS25} [get_ports rmii_rx_er_b]                ; ## D21  FMC_LPC_LA17_CC_N
set_property -dict {PACKAGE_PIN AG30  IOSTANDARD LVCMOS25 PULLUP true} [get_ports rmii_rx_dv_b]    ; ## H29 FMC_LPC_LA24_N
set_property -dict {PACKAGE_PIN AE27  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mac_if_sel_0_b]  ; ## C22 FMC_HPC1_LA18_CC_P
set_property -dict {PACKAGE_PIN AH26  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_b[0]}]             ; ## H22 FMC_LPC_LA19_P
set_property -dict {PACKAGE_PIN AH27  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd_b[1]}]             ; ## H23 FMC_LPC_LA19_N
set_property -dict {PACKAGE_PIN AF30  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports rmii_tx_en_b]      ; ## H28 FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN AH28  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_b[0]}]   ; ## H25 FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN AH29  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {rmii_txd_b[1]}]   ; ## H26 FMC_LPC_LA21_N

set_property -dict {PACKAGE_PIN AD25  IOSTANDARD LVCMOS25 PULLUP true} [get_ports mdio_fmc_b]      ; ## H31 FMC_LPC_LA28_P
set_property -dict {PACKAGE_PIN AE26  IOSTANDARD LVCMOS25} [get_ports mdc_fmc_b]                   ; ## H32 FMC_LPC_LA28_N

set_property -dict {PACKAGE_PIN AB14  IOSTANDARD LVCMOS25} [get_ports reset_b]                     ; ## H20 FMC_LPC_LA15_N
set_property -dict {PACKAGE_PIN AF29  IOSTANDARD LVCMOS25} [get_ports link_st_b]                   ; ## G27 FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN AJ26  IOSTANDARD LVCMOS25} [get_ports led_0_b]                     ; ## D23 FMC_LPC_LA23_P
set_property -dict {PACKAGE_PIN AJ30  IOSTANDARD LVCMOS25} [get_ports led_bl_c_c2m]                ; ## D26 FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN AK30  IOSTANDARD LVCMOS25} [get_ports led_bl_a_c2m]                ; ## D27 FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN AE18  IOSTANDARD LVCMOS25} [get_ports led_br_c_c2m]                ; ## G18 FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN AE17  IOSTANDARD LVCMOS25} [get_ports led_br_a_c2m]                ; ## G19 FMC_LPC_LA16_N

create_clock -name rmii_ref_clk_a  -period 20.0 [get_ports rmii_rx_ref_clk_a]
create_clock -name rmii_ref_clk_b  -period 20.0 [get_ports rmii_rx_ref_clk_b]

create_clock -name rmii_rx_clk_0   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/inst/mii_rx_clk_r1_reg/Q]
create_clock -name rmii_rx_clk_1   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_1/inst/mii_rx_clk_r1_reg/Q]
create_clock -name rmii_tx_clk_0   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/inst/mii_tx_clk_r1_reg/Q]
create_clock -name rmii_tx_clk_1   -period  20 [get_pins i_system_wrapper/system_i/mii_to_rmii_1/inst/mii_tx_clk_r1_reg/Q]

