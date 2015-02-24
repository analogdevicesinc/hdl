
#DEBUG

# Motor Control
#set_property  -dict {PACKAGE_PIN  Y21  IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
#set_property  -dict {PACKAGE_PIN  Y20  IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
#set_property  -dict {PACKAGE_PIN  AB20 IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
#set_property  -dict {PACKAGE_PIN  AB19 IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25 } [get_ports {position_m1_i[0]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25 } [get_ports {position_m1_i[1]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS25 } [get_ports {position_m1_i[2]}]

set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[0]}] ; #M2_SENSOR_A
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[1]}] ; #M2_SENSOR_B
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports {position_m2_i[2]}] ; #M2_SENSOR_C

set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports vt_enable]

set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports fmc_m1_en_o]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports pwm_m1_ah_o]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS25} [get_ports pwm_m1_al_o]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports pwm_m1_bh_o]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports pwm_m1_bl_o]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports pwm_m1_ch_o]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports pwm_m1_cl_o]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports pwm_m1_dh_o]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports pwm_m1_dl_o]

set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports fmc_m2_en_o]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports pwm_m2_ah_o]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwm_m2_al_o]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pwm_m2_bh_o]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS25} [get_ports pwm_m2_bl_o]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports pwm_m2_ch_o]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports pwm_m2_cl_o]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports pwm_m2_dh_o]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS25} [get_ports pwm_m2_dl_o]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25 } [get_ports adc_clk_o]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25 } [get_ports adc_m1_vbus_dat_i]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25 } [get_ports adc_m2_vbus_dat_i]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25 } [get_ports adc_m1_ia_dat_i]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25 } [get_ports adc_m1_ib_dat_i]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25 } [get_ports adc_m2_ia_dat_i]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25 } [get_ports adc_m2_ib_dat_i]

# GPO
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25 } [get_ports {gpo[0]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS25 } [get_ports {gpo[1]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS25 } [get_ports {gpo[2]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS25 } [get_ports {gpo[3]}]

# GPI
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports {gpi[0]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports {gpi[1]}]


#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[0]}]
#set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[1]}]
#set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[2]}]
#set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS25} [get_ports {muxaddr_out[3]}]

#set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS25} [get_ports vauxn0]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS25} [get_ports vauxn8]
#set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS25} [get_ports vauxp0]
#set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS25} [get_ports vauxp8]

# SPI
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports fmc_spi1_sel1_rdc ]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS25} [get_ports fmc_spi1_miso ]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports fmc_spi1_mosi ]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS25} [get_ports fmc_spi1_sck ]

#FMC_SAMPLE_N
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports fmc_sample_n]

# IIC
set_property  -dict {PACKAGE_PIN  E21    IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_ee2_scl_io]
set_property  -dict {PACKAGE_PIN  D21    IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_ee2_sda_io]

# Ethernet common
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports eth_mdio_mdc]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25 PULLUP true} [get_ports eth_mdio_io]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports eth_phy_rst_n]

# Ethernet 1
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rxc]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_txc]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[0]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[2]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_td[3]}]

# Ethernet 2
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

# Ethernet common

set_property IODELAY_GROUP eth_idelay_grp [get_cells dlyctrl]

set_false_path -from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -to [get_clocks clk_out3_system_sys_audio_clkgen_0_1]
set_false_path -from [get_clocks clk_out3_system_sys_audio_clkgen_0_1] -to [get_clocks clk_out2_system_sys_audio_clkgen_0_1]
set_false_path -from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -to [get_clocks clk_2_5m_2]
set_false_path -from [get_clocks clk_out3_system_sys_audio_clkgen_0_1] -to [get_clocks clk_2_5m_2]
set_false_path -from [get_clocks clk_2_5m_2] -to [get_clocks clk_out2_system_sys_audio_clkgen_0_1]
set_false_path -from [get_clocks clk_2_5m_2] -to [get_clocks clk_out3_system_sys_audio_clkgen_0_1]
set_false_path -from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -to [get_clocks clk_2_5m_3]
set_false_path -from [get_clocks clk_out3_system_sys_audio_clkgen_0_1] -to [get_clocks clk_2_5m_3]
set_false_path -from [get_clocks clk_2_5m_3] -to [get_clocks clk_out2_system_sys_audio_clkgen_0_1]
set_false_path -from [get_clocks clk_2_5m_3] -to [get_clocks clk_out3_system_sys_audio_clkgen_0_1]

# Ethernet 1

# Clock Period Constraints
create_clock -period 8.000 -name rgmii_rxc1 [get_ports eth1_rgmii_rxc]
#set_clock_latency -source -early 0.5 [get_clocks rgmii_rxc1]
#set_clock_latency -source -late 0.5 [get_clocks rgmii_rxc1]

create_clock -name eth1_rx_clk_vir -period 8

set_property IDELAY_VALUE 18 [get_cells */*/gmii_to_rgmii_eth1/inst/*delay_rgmii_rx_ctl]
set_property IDELAY_VALUE 18 [get_cells -hier -filter {name =~ *gmii_to_rgmii_eth1*/*delay_rgmii_rd*}]
set_property IODELAY_GROUP eth_idelay_grp [get_cells */*/gmii_to_rgmii_eth1/inst/*delay_rgmii_rx_ctl]
set_property IODELAY_GROUP eth_idelay_grp [get_cells -hier -filter {name =~*gmii_to_rgmii_eth1*/*delay_rgmii_rd*}]

set_input_delay -clock [get_clocks eth1_rx_clk_vir] -max -1.2 [get_ports {eth1_rgmii_rd[*] eth1_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth1_rx_clk_vir] -min -2.8 [get_ports {eth1_rgmii_rd[*] eth1_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth1_rx_clk_vir] -clock_fall -max -1.2 -add_delay [get_ports {eth1_rgmii_rd[*] eth1_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth1_rx_clk_vir] -clock_fall -min -2.8 -add_delay [get_ports {eth1_rgmii_rd[*] eth1_rgmii_rx_ctl}]

set_false_path -rise_from [get_clocks eth1_rx_clk_vir] -fall_to rgmii_rxc1 -setup
set_false_path -fall_from [get_clocks eth1_rx_clk_vir] -rise_to rgmii_rxc1 -setup
set_false_path -rise_from [get_clocks eth1_rx_clk_vir] -rise_to rgmii_rxc1 -hold
set_false_path -fall_from [get_clocks eth1_rx_clk_vir] -fall_to rgmii_rxc1 -hold

set_multicycle_path -from [get_clocks eth1_rx_clk_vir] -to rgmii_rxc1 -setup 0
set_multicycle_path -from [get_clocks eth1_rx_clk_vir] -to rgmii_rxc1 -hold -1

set_output_delay -max -0.9 -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth1_rgmii_td[*] eth1_rgmii_tx_ctl}]
set_output_delay -min 2.7  -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth1_rgmii_td[*] eth1_rgmii_tx_ctl}]
set_output_delay -max -0.9  -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth1_rgmii_td[*] eth1_rgmii_tx_ctl}] -clock_fall -add_delay
set_output_delay -min 2.7 -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth1_rgmii_td[*] eth1_rgmii_tx_ctl}] -clock_fall -add_delay

# Ethernet 2

# Clock Period Constraints
create_clock -period 8.000 -name rgmii_rxc2 [get_ports eth2_rgmii_rxc]
#set_clock_latency -source -early 0.5 [get_clocks rgmii_rxc1]
#set_clock_latency -source -late 0.5 [get_clocks rgmii_rxc1]

create_clock -name eth2_rx_clk_vir -period 8
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/gmii_to_rgmii_eth2/inst/clk_100msps]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/sys_audio_clkgen/inst/clk_out3]

set_property IDELAY_VALUE 18 [get_cells */*/gmii_to_rgmii_eth2/inst/*delay_rgmii_rx_ctl]
set_property IDELAY_VALUE 18 [get_cells -hier -filter {name =~ *gmii_to_rgmii_eth2*/*delay_rgmii_rd*}]
set_property IODELAY_GROUP eth_idelay_grp [get_cells */*/gmii_to_rgmii_eth2/inst/*delay_rgmii_rx_ctl]
set_property IODELAY_GROUP eth_idelay_grp [get_cells -hier -filter {name =~*gmii_to_rgmii_eth2*/*delay_rgmii_rd*}]

set_input_delay -clock [get_clocks eth2_rx_clk_vir] -max -1.2 [get_ports {eth2_rgmii_rd[*] eth2_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth2_rx_clk_vir] -min -2.8 [get_ports {eth2_rgmii_rd[*] eth2_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth2_rx_clk_vir] -clock_fall -max -1.2 -add_delay [get_ports {eth2_rgmii_rd[*] eth2_rgmii_rx_ctl}]
set_input_delay -clock [get_clocks eth2_rx_clk_vir] -clock_fall -min -2.8 -add_delay [get_ports {eth2_rgmii_rd[*] eth2_rgmii_rx_ctl}]

set_false_path -rise_from [get_clocks eth2_rx_clk_vir] -fall_to rgmii_rxc2 -setup
set_false_path -fall_from [get_clocks eth2_rx_clk_vir] -rise_to rgmii_rxc2 -setup
set_false_path -rise_from [get_clocks eth2_rx_clk_vir] -rise_to rgmii_rxc2 -hold
set_false_path -fall_from [get_clocks eth2_rx_clk_vir] -fall_to rgmii_rxc2 -hold

set_multicycle_path -from [get_clocks eth2_rx_clk_vir] -to rgmii_rxc2 -setup 0
set_multicycle_path -from [get_clocks eth2_rx_clk_vir] -to rgmii_rxc2 -hold -1

set_false_path -rise_from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -fall_to [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -setup
set_false_path -fall_from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -rise_to [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -setup
set_false_path -rise_from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -rise_to [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -hold
set_false_path -fall_from [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -fall_to [get_clocks clk_out2_system_sys_audio_clkgen_0_1] -hold

set_output_delay -max -0.9 -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth2_rgmii_td[*] eth2_rgmii_tx_ctl}]
set_output_delay -min 2.7  -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth2_rgmii_td[*] eth2_rgmii_tx_ctl}]
set_output_delay -max -0.9  -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth2_rgmii_td[*] eth2_rgmii_tx_ctl}] -clock_fall -add_delay
set_output_delay -min 2.7 -clock clk_out2_system_sys_audio_clkgen_0_1 [get_ports {eth2_rgmii_td[*] eth2_rgmii_tx_ctl}] -clock_fall -add_delay
