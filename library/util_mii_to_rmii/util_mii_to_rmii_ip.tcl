###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_mii_to_rmii

adi_ip_files util_mii_to_rmii [list \
        "mac_phy_link.v" \
        "phy_mac_link.v" \
        "util_mii_to_rmii.v" ]

adi_ip_properties_lite util_mii_to_rmii

adi_add_bus "GMII" "slave" \
        "xilinx.com:interface:gmii_rtl:1.0" \
        "xilinx.com:interface:gmii:1.0" \
        {
                {"mii_col" "COL"} \
                {"mii_crs" "CRS"} \
                {"mii_rxd" "RXD"} \
                {"mii_rx_clk" "RX_CLK"} \
                {"mii_rx_dv" "RX_DV"} \
                {"mii_rx_er" "RX_ER"} \
                {"mac_txd" "TXD"} \
                {"mii_tx_clk" "TX_CLK"} \
                {"mac_tx_en" "TX_EN"} \
                {"mac_tx_er" "TX_ER"} \
        }

adi_add_bus "MII" "slave" \
        "xilinx.com:interface:mii_rtl:1.0" \
        "xilinx.com:interface:mii:1.0" \
        {
                {"mii_col" "COL"} \
                {"mii_crs" "CRS"} \
                {"mii_rxd" "RXD"} \
                {"mii_rx_clk" "RX_CLK"} \
                {"mii_rx_dv" "RX_DV"} \
                {"mii_rx_er" "RX_ER"} \
                {"mac_txd" "TXD"} \
                {"mii_tx_clk" "TX_CLK"} \
                {"mac_tx_en" "TX_EN"} \
                {"mac_tx_er" "TX_ER"} \
        }

adi_add_bus "RMII" "master" \
        "xilinx.com:interface:rmii_rtl:1.0" \
        "xilinx.com:interface:rmii:1.0" \
        {
                {"phy_crs_dv" "CRS_DV"} \
                {"phy_rxd" "RXD"} \
                {"phy_rx_er" "RX_ER"} \
                {"rmii_txd" "TXD"} \
                {"rmii_tx_en" "TX_EN"} \
        }

adi_set_bus_dependency "MII" "MII" \
	"(spirit:decode(id('MODELPARAM_VALUE.INTF_CFG')) = 0)"
adi_set_bus_dependency "GMII" "GMII" \
	"(spirit:decode(id('MODELPARAM_VALUE.INTF_CFG')) = 1)"

set cc [ipx::current_core]

ipx::infer_bus_interface reset_n xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 $cc

## Customize XGUI layout

set_property display_name "util_mii_to_rmii" $cc
set_property description "MII to RMII Converter IP" $cc
set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"MII" "0" \
		"GMII" "1" \
	} \
] \
[ipx::get_user_parameters INTF_CFG -of_objects $cc]

set_property -dict [list \
        "value_validation_type" "pairs" \
        "value_validation_pairs" { \
                "100Mbps" "0" \
                "10Mbps" "1" \
        } \
] \
[ipx::get_user_parameters RATE_10_100 -of_objects $cc]

ipgui::add_param -name "INTF_CFG" -component $cc
set p [ipgui::get_guiparamspec -name "INTF_CFG" -component $cc]
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Interface Selection" \
] $p

ipgui::add_param -name "RATE_10_100" -component $cc
set p [ipgui::get_guiparamspec -name "RATE_10_100" -component $cc]
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Rate Selection" \
] $p

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]
ipx::save_core $cc
