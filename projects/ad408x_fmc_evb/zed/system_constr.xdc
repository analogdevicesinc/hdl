###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_p]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_n]

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_p]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_n]

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports cnv_in_p]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports cnv_in_n]

set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports gpio0_fmc]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports gpio1_fmc]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports gpio2_fmc]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports gpio3_fmc]

set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports gp0_dir]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports gp1_dir]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports gp2_dir]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports gp3_dir]

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports en_psu]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwrgd]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pd_v33b]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports osc_en]

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports cs_n_src]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports sdio_src]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports sclk_src]

set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports cs1_0]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports cs1_1]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports sdo_1]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports sclk1]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports sdin1]

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports doa_fmc]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports dob_fmc]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports doc_fmc]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports dod_fmc]

set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS25} [get_ports {pbio[0]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports {pbio[1]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports {pbio[2]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports {pbio[3]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports {pbio[4]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports {pbio[5]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports {pbio[6]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports {pbio[7]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25} [get_ports {pbio[8]}]

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad9508_sync]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports adf435x_lock]

set_property IDELAY_VALUE 11 [get_cells -hier -filter {name =~ *da_iddr/i_rx_data_idelay*}]

# clocks

create_clock -period 2.500 -name dco_clk [get_ports dco_p]

