# Motor Control

#set_property  -dict {PACKAGE_PIN  Y21  IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
#set_property  -dict {PACKAGE_PIN  Y20  IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
#set_property  -dict {PACKAGE_PIN  AB20 IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
#set_property  -dict {PACKAGE_PIN  AB19 IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports {position_i[0]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25} [get_ports {position_i[1]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS25} [get_ports {position_i[2]}]

#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[0]}] ;#M2_SENSOR_A
#set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[1]}] ;#M2_SENSOR_B
#set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[2]}] ;#M2_SENSOR_C

set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports fmc_m1_en_o]
#set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports pwm_m1_ah_o]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS25} [get_ports pwm_m1_al_o]
#set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports pwm_m1_bh_o]
#set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports pwm_m1_bl_o]
#set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports pwm_m1_ch_o]
#set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports pwm_m1_cl_o]
#set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports pwm_m1_dh_o]
#set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports pwm_m1_dl_o]

set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports fmc_m2_en_o]
#set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports pwm_m2_ah_o]
#set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwm_m2_al_o]
#set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pwm_m2_bh_o]
#set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS25} [get_ports pwm_m2_bl_o]
#set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports pwm_m2_ch_o]
#set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports pwm_m2_cl_o]
#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports pwm_m2_dh_o]
#set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS25} [get_ports pwm_m2_dl_o]

set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports adc_clk_o]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports adc_m1_vbus_dat_i]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports adc_m2_vbus_dat_i]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports adc_m1_ia_dat_i]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports adc_m1_ib_dat_i]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports adc_m2_ia_dat_i]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports adc_m2_ib_dat_i]

set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports {gpo_o[0]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS25} [get_ports {gpo_o[1]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS25} [get_ports {gpo_o[2]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS25} [get_ports {gpo_o[3]}]

#set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports {gpi_i[0]}]
#set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports {gpi_i[1]}]

#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[0]}]
#set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[1]}]
#set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[2]}]
#set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[3]}]

set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS25} [get_ports vauxn0]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS25} [get_ports vauxn8]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS25} [get_ports vauxp0]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS25} [get_ports vauxp8]
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS25} [get_ports vn_in]
set_property -dict {PACKAGE_PIN L11 IOSTANDARD LVCMOS25} [get_ports vp_in]

set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports eth2_mdio_mdc]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25} [get_ports eth2_mdio_io]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports eth2_phy_rst_n]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_rxc]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_txc]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_td[0]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_td[1]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_td[2]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_td[3]}]

#set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rxc]
#set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rx_ctl]
#set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[0]}]
#set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[1]}]
#set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[2]}]
#set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[3]}]

#set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_txc]
#set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_tx_ctl]
#set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[0]}]
#set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[1]}]
#set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[2]}]
#set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[3]}]
