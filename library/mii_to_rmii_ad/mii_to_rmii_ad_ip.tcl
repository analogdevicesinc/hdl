# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create mii_to_rmii_ad
adi_ip_files mii_to_rmii_ad [list \
	"rx_fifo_loader.vhd" \
	"rx_fifo_disposer.vhd" \
	"rx_fifo.vhd" \
	"srl_fifo.vhd" \
	"rmii_tx_fixed.vhd" \
	"rmii_tx_agile.vhd" \
	"rmii_rx_fixed.vhd" \
	"rmii_rx_agile.vhd" \
	"mii_to_rmii.vhd" ]
adi_ip_properties_lite mii_to_rmii_ad
adi_add_bus "MII" "slave" \
        "xilinx.com:interface:mii_rtl:1.0" \
        "xilinx.com:interface:mii:1.0" \
        {
                {"rmii2mac_col" "COL"} \
                {"rmii2mac_crs" "CRS"} \
                {"rmii2mac_rxd" "RXD"} \
                {"rmii2mac_rx_clk" "RX_CLK"} \
                {"rmii2mac_rx_dv" "RX_DV"} \
                {"rmii2mac_rx_er" "RX_ER"} \
                {"mac2rmii_txd" "TXD"} \
                {"rmii2mac_tx_clk" "TX_CLK"} \
                {"mac2rmii_tx_en" "TX_EN"} \
                {"mac2rmii_tx_er" "TX_ER"} \
        }

adi_add_bus "GMII" "slave" \
        "xilinx.com:interface:gmii_rtl:1.0" \
        "xilinx.com:interface:gmii:1.0" \
        {
              {"rmii2mac_col" "COL"} \
              {"rmii2mac_crs" "CRS"} \
	        {"rmii2mac_rxd" "RXD"} \
		{"rmii2mac_rx_clk" "RX_CLK"} \
		{"rmii2mac_rx_dv" "RX_DV"} \
		{"rmii2mac_rx_er" "RX_ER"} \
		{"mac2rmii_txd" "TXD"} \
		{"rmii2mac_tx_clk" "TX_CLK"} \
		{"mac2rmii_tx_en" "TX_EN"} \
		{"mac2rmii_tx_er" "TX_ER"} \
        }

adi_add_bus "RMII_PHY_M" "master" \
        "xilinx.com:interface:rmii_rtl:1.0" \
        "xilinx.com:interface:rmii:1.0" \
        {
              {"phy2rmii_crs_dv" "CRS_DV"} \
              {"phy2rmii_rxd" "RXD"} \
              {"phy2rmii_rx_er" "RX_ER"} \
		{"rmii2phy_txd" "TXD"} \
		{"rmii2phy_tx_en" "TX_EN"} \
        }
adi_set_bus_dependency "MII" "MII" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_MODE')) = 0)"
adi_set_bus_dependency "GMII" "GMII" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_MODE')) = 1)"

ipx::infer_bus_interface rst_n xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

## Customize XGUI layout
set cc [ipx::current_core]

set_property display_name "mii_to_rmii_ad" $cc
set_property description "MII to RMII provides the RMII between RMII-compliant ethernet physical media devices and XPS Ethernet Lite." $cc

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Tri-Mode Ethernet MAC" "0" \
		"Zynq PS Gigabit Ethernet Controller" "1" \
	} \
] \
[ipx::get_user_parameters C_MODE -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"NONE" "0" \
		"BUFG" "1" \
		"BUFH" "2" \
	} \
] \
[ipx::get_user_parameters C_INCLUDE_BUF -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Yes" "1" \
		"No" "0" \
	} \
] \
[ipx::get_user_parameters C_FIXED_SPEED -of_objects $cc]

set_property -dict [list \
        "value_validation_type" "pairs" \
        "value_validation_pairs" { \
                "100 Mb/s" "1" \
                "10 Mb/s" "0" \
        } \
] \
[ipx::get_user_parameters C_SPEED_100 -of_objects $cc]


ipgui::add_param -name "C_MODE" -component $cc
set p [ipgui::get_guiparamspec -name "C_MODE" -component $cc]
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Mode Selection" \
] $p

ipgui::add_param -name "C_FIXED_SPEED" -component $cc
set p [ipgui::get_guiparamspec -name "C_FIXED_SPEED" -component $cc]
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Fixed Speed" \
	"tooltip" "Fixed ethernet throughput" \
] $p

ipgui::add_param -name "C_SPEED_100" -component $cc
set p [ipgui::get_guiparamspec -name "C_SPEED_100" -component $cc]
set_property -dict [list \
	"widget" "comboBox" \
      "display_name" "Speed" \
      "tooltip" "Throughput set at 100 Mb/s" \
] $p

ipgui::add_param -name "C_INCLUDE_BUF" -component $cc
set p [ipgui::get_guiparamspec -name "C_INCLUDE_BUF" -component $cc]
set_property -dict [list \
        "display_name" "Insert buffer in output clock path" \
        "tooltip" "(Optional) Insertion of buffer (BUFG/BUFH) in the rx and tx output clock path will help in handling high fanout" \
        "widget" "comboBox" \
] $p

ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "C_INSTANCE" -component $cc]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]
ipx::save_core $cc
