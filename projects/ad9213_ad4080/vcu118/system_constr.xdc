###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9213_ad4080


## AD9213 DATA INTERFACE

set_property -dict {PACKAGE_PIN AK38} [get_ports rx_ref_clk_p]
set_property -dict {PACKAGE_PIN AK39} [get_ports rx_ref_clk_n]
set_property -dict {PACKAGE_PIN V38} [get_ports rx_ref_clk_replica_p]
set_property -dict {PACKAGE_PIN V39} [get_ports rx_ref_clk_replica_n]

set_property -dict {PACKAGE_PIN AF38} [get_ports glbl_clk_0_p]
set_property -dict {PACKAGE_PIN AF39} [get_ports glbl_clk_0_n]

set_property IOSTANDARD LVDS [get_ports rx_sysref_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports rx_sysref_p]
set_property PACKAGE_PIN AJ32 [get_ports rx_sysref_p]
set_property PACKAGE_PIN AK32 [get_ports rx_sysref_n]
set_property IOSTANDARD LVDS [get_ports rx_sysref_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports rx_sysref_n]
set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVDS} [get_ports rx_sync_p]
set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVDS} [get_ports rx_sync_n]

set_property -dict {PACKAGE_PIN W45} [get_ports {rx_data_p[0]}]
set_property -dict {PACKAGE_PIN W46} [get_ports {rx_data_n[0]}]
set_property -dict {PACKAGE_PIN AR45} [get_ports {rx_data_p[1]}]
set_property -dict {PACKAGE_PIN AR46} [get_ports {rx_data_n[1]}]
set_property -dict {PACKAGE_PIN AL45} [get_ports {rx_data_p[2]}]
set_property -dict {PACKAGE_PIN AL46} [get_ports {rx_data_n[2]}]
set_property -dict {PACKAGE_PIN AN45} [get_ports {rx_data_p[3]}]
set_property -dict {PACKAGE_PIN AN46} [get_ports {rx_data_n[3]}]
set_property -dict {PACKAGE_PIN AJ45} [get_ports {rx_data_p[4]}]
set_property -dict {PACKAGE_PIN AJ46} [get_ports {rx_data_n[4]}]
set_property -dict {PACKAGE_PIN AC45} [get_ports {rx_data_p[5]}]
set_property -dict {PACKAGE_PIN AC46} [get_ports {rx_data_n[5]}]
set_property -dict {PACKAGE_PIN AB43} [get_ports {rx_data_p[6]}]
set_property -dict {PACKAGE_PIN AB44} [get_ports {rx_data_n[6]}]
set_property -dict {PACKAGE_PIN N45} [get_ports {rx_data_p[7]}]
set_property -dict {PACKAGE_PIN N46} [get_ports {rx_data_n[7]}]
set_property -dict {PACKAGE_PIN R45} [get_ports {rx_data_p[8]}]
set_property -dict {PACKAGE_PIN R46} [get_ports {rx_data_n[8]}]
set_property -dict {PACKAGE_PIN Y43} [get_ports {rx_data_p[9]}]
set_property -dict {PACKAGE_PIN Y44} [get_ports {rx_data_n[9]}]
set_property -dict {PACKAGE_PIN AA45} [get_ports {rx_data_p[10]}]
set_property -dict {PACKAGE_PIN AA46} [get_ports {rx_data_n[10]}]
set_property -dict {PACKAGE_PIN E45} [get_ports {rx_data_p[11]}]
set_property -dict {PACKAGE_PIN E46} [get_ports {rx_data_n[11]}]
set_property -dict {PACKAGE_PIN L45} [get_ports {rx_data_p[12]}]
set_property -dict {PACKAGE_PIN L46} [get_ports {rx_data_n[12]}]
set_property -dict {PACKAGE_PIN G45} [get_ports {rx_data_p[13]}]
set_property -dict {PACKAGE_PIN G46} [get_ports {rx_data_n[13]}]
set_property -dict {PACKAGE_PIN J45} [get_ports {rx_data_p[14]}]
set_property -dict {PACKAGE_PIN J46} [get_ports {rx_data_n[14]}]
set_property -dict {PACKAGE_PIN U45} [get_ports {rx_data_p[15]}]
set_property -dict {PACKAGE_PIN U46} [get_ports {rx_data_n[15]}]

## AD4080 DATA INTERFACE

set_property IOSTANDARD LVDS [get_ports da_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports da_p]
set_property PACKAGE_PIN Y32 [get_ports da_p]
set_property PACKAGE_PIN W32 [get_ports da_n]
set_property IOSTANDARD LVDS [get_ports da_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports da_n]
set_property IOSTANDARD LVDS [get_ports db_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports db_p]
set_property PACKAGE_PIN V32 [get_ports db_p]
set_property PACKAGE_PIN U33 [get_ports db_n]
set_property IOSTANDARD LVDS [get_ports db_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports db_n]
set_property IOSTANDARD LVDS [get_ports dco_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports dco_p]
set_property PACKAGE_PIN P35 [get_ports dco_p]
set_property PACKAGE_PIN P36 [get_ports dco_n]
set_property IOSTANDARD LVDS [get_ports dco_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports dco_n]
set_property -dict {PACKAGE_PIN R31 IOSTANDARD LVCMOS18} [get_ports cnv_in_p]

## ADL5580 SPI PORT

set_property -dict {PACKAGE_PIN N32 IOSTANDARD LVCMOS18} [get_ports adl5580_csb]
set_property -dict {PACKAGE_PIN M32 IOSTANDARD LVCMOS18} [get_ports adl5580_sclk]
set_property -dict {PACKAGE_PIN N34 IOSTANDARD LVCMOS18} [get_ports adl5580_sdio]

## AD4080 SPI PORT

set_property -dict {PACKAGE_PIN W34 IOSTANDARD LVCMOS18} [get_ports ad4080_sclk]
set_property -dict {PACKAGE_PIN U35 IOSTANDARD LVCMOS18} [get_ports ad4080_cs]
set_property -dict {PACKAGE_PIN T36 IOSTANDARD LVCMOS18} [get_ports ad4080_mosi]
set_property -dict {PACKAGE_PIN P37 IOSTANDARD LVCMOS18} [get_ports {ad4080_gpio[0]}]

## ltc2664 SPI PORT

set_property -dict {PACKAGE_PIN L35 IOSTANDARD LVCMOS18} [get_ports ltc2664_sclk]
set_property -dict {PACKAGE_PIN T35 IOSTANDARD LVCMOS18} [get_ports ltc2664_cs]
set_property -dict {PACKAGE_PIN T34 IOSTANDARD LVCMOS18} [get_ports ltc2664_mosi]
set_property -dict {PACKAGE_PIN M36 IOSTANDARD LVCMOS18} [get_ports ltc2664_miso]

## AD9213 SPI PORT

set_property -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18} [get_ports ad9213_csb]
set_property -dict {PACKAGE_PIN AT36 IOSTANDARD LVCMOS18} [get_ports ad9213_sclk]
set_property -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS18} [get_ports ad9213_sdio]

## HMC7044_ADF4371 SPI PORT

set_property -dict {PACKAGE_PIN N33 IOSTANDARD LVCMOS18} [get_ports adf4371_csb]
set_property -dict {PACKAGE_PIN AG31 IOSTANDARD LVCMOS18} [get_ports hmc7044_csb]
set_property -dict {PACKAGE_PIN AH31 IOSTANDARD LVCMOS18} [get_ports hmc7044_adf4371_sclk]
set_property -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18} [get_ports hmc7044_adf4371_sdio]

## GPIOs

set_property -dict {PACKAGE_PIN AP38 IOSTANDARD LVCMOS18} [get_ports fpga_seq_shdn]
set_property -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18} [get_ports ad9213_rstb]
set_property -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18} [get_ports hmc7044_sync_req]
set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18} [get_ports {ad9213_gpio[0]}]
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18} [get_ports {ad9213_gpio[1]}]
set_property -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18} [get_ports {ad9213_gpio[2]}]
set_property -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18} [get_ports {ad9213_gpio[3]}]
set_property -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18} [get_ports {ad9213_gpio[4]}]

set_property -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18} [get_ports adg5419_ctrl]
set_property -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18} [get_ports ada4945_disable]

set_property -dict {PACKAGE_PIN V33 IOSTANDARD LVCMOS18} [get_ports {adrf5203_ctrl[0]}]
set_property -dict {PACKAGE_PIN V34 IOSTANDARD LVCMOS18} [get_ports {adrf5203_ctrl[1]}]
set_property -dict {PACKAGE_PIN M33 IOSTANDARD LVCMOS18} [get_ports {adrf5203_ctrl[2]}]

set_property -dict {PACKAGE_PIN N35 IOSTANDARD LVCMOS18} [get_ports adl5580_en]

set_property -dict {PACKAGE_PIN N37 IOSTANDARD LVCMOS18} [get_ports {ad4080_gpio[1]}]
set_property -dict {PACKAGE_PIN L34 IOSTANDARD LVCMOS18} [get_ports {ad4080_gpio[2]}]
set_property -dict {PACKAGE_PIN K34 IOSTANDARD LVCMOS18} [get_ports {ad4080_gpio[3]}]

set_property -dict {PACKAGE_PIN L36 IOSTANDARD LVCMOS18} [get_ports ltc2664_ldac]
set_property -dict {PACKAGE_PIN N38 IOSTANDARD LVCMOS18} [get_ports ltc2664_clr]
set_property -dict {PACKAGE_PIN M38 IOSTANDARD LVCMOS18} [get_ports ltc2664_tgp]

## DIGITAL EXTERNAL PORTS

set_property -dict {PACKAGE_PIN L33 IOSTANDARD LVCMOS18} [get_ports dig_ext_hs_p]
set_property -dict {PACKAGE_PIN K33 IOSTANDARD LVCMOS18} [get_ports dig_ext_hs_n]
set_property -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18} [get_ports dig_ext_p]
set_property -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18} [get_ports dig_ext_n]
set_property -dict {PACKAGE_PIN AP37 IOSTANDARD LVCMOS18} [get_ports {dig_ext_gpio[0]}]
set_property -dict {PACKAGE_PIN AG33 IOSTANDARD LVCMOS18} [get_ports {dig_ext_gpio[1]}]

# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB

create_clock -period 1.600 -name rx_ref_clk [get_ports rx_ref_clk_p]
create_clock -period 1.600 -name rx_ref_clk_replica [get_ports rx_ref_clk_replica_p]

# The Global clock is routed from the REFCLK1 of the dual_ad9208 board
# since GLBLCLK0 and GLBLCLK1 are not connected to global clock capable pins.

create_clock -period 3.200 -name global_clk_0 [get_ports glbl_clk_0_p]

create_clock -period 2.500 -name dco_clk [get_ports dco_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK

set_input_delay -clock [get_clocks global_clk_0] 1.600 [get_ports rx_sysref_*]

# Create SPI clock

create_generated_clock -name adl5580_spi_clk -source [get_pins i_system_wrapper/system_i/adl5580_spi/ext_spi_clk] -divide_by 2 [get_pins i_system_wrapper/system_i/adl5580_spi/sck_o]

create_generated_clock -name hmc7044_spi_clk -source [get_pins i_system_wrapper/system_i/hmc7044_spi/ext_spi_clk] -divide_by 2 [get_pins i_system_wrapper/system_i/hmc7044_spi/sck_o]

set_false_path -through [get_nets i_system_wrapper/gpio_o[56]]
