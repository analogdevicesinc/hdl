
# Motor Control

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
# Unset gpio_bd pins from XADC-GIO0 and XADC-GIO1  and connect them to GPI0 and GPI1
# XADC-GIO0 and XADC-GIO1 will be used by the XADC core
set_property  -dict {PACKAGE_PIN  A21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[27]]      ; ## GPI0
set_property  -dict {PACKAGE_PIN  A22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[28]]      ; ## GPI1

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS25} [get_ports muxaddr_out[0]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS25} [get_ports muxaddr_out[1]]      ; ## XADC-GIO1

set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS25} [get_ports vauxn0]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS25} [get_ports vauxn8]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS25} [get_ports vauxp0]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS25} [get_ports vauxp8]

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
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25 PULLUP true} [get_ports eth_mdio_p]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports eth_phy_rst_n]

# Ethernet 1
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rxc]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25} [get_ports eth1_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports {eth1_rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports eth1_rgmii_txc]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports eth1_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth1_rgmii_td[0]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth1_rgmii_td[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth1_rgmii_td[2]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth1_rgmii_td[3]}]

# Ethernet 2
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_rxc]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports eth2_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports {eth2_rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports eth2_rgmii_txc]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports eth2_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth2_rgmii_td[0]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth2_rgmii_td[1]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth2_rgmii_td[2]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25 SLEW FAST} [get_ports {eth2_rgmii_td[3]}]


#create clocks
# Clock Period Constraints
create_clock -name mdio_mdc -period 400 [get_pins i_system_wrapper/system_i/sys_ps7/inst/PS7_i/EMIOENET0MDIOMDC]

create_clock -period 8.000 -name rgmii_rxc1 [get_ports eth1_rgmii_rxc]

create_clock -period 8.000 -name rgmii_rxc2 [get_ports eth2_rgmii_rxc]

create_generated_clock -name pwm_ctrl_1 -source [get_pins i_system_wrapper/system_i/controller_m1/inst/ref_clk]  \
-divide_by 2 [get_pins i_system_wrapper/system_i/controller_m1/inst/pwm_gen_clk_reg/Q]
create_generated_clock -name pwm_ctrl_2 -source [get_pins i_system_wrapper/system_i/controller_m2/inst/ref_clk]  \
-divide_by 2 [get_pins i_system_wrapper/system_i/controller_m2/inst/pwm_gen_clk_reg/Q]

create_generated_clock -name cm1_ia -source [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/ia_if/filter/word_count_reg[7]/Q]
create_generated_clock -name cm1_ib -source [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/ib_if/filter/word_count_reg[7]/Q]
create_generated_clock -name cm1_vbus -source [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m1/inst/vbus_if/filter/word_count_reg[7]/Q]

create_generated_clock -name cm2_ia -source [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/ia_if/filter/word_count_reg[7]/Q]
create_generated_clock -name cm2_ib -source [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/ib_if/filter/word_count_reg[7]/Q]
create_generated_clock -name cm2_vbus -source [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/adc_clk_i]  \
-divide_by 256 [get_pins i_system_wrapper/system_i/current_monitor_m2/inst/vbus_if/filter/word_count_reg[7]/Q]

set_clock_groups -asynchronous \
    -group [get_clocks {cm1_ia cm1_ib cm1_vbus }]

set_clock_groups -asynchronous \
    -group [get_clocks {cm2_ia cm2_ib cm2_vbus }]

set_clock_groups -asynchronous \
        -group [get_clocks {pwm_ctrl_1 }] \
        -group [get_clocks {pwm_ctrl_2 }]
