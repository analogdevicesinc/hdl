# ip

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl
set corundum_dir_common [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/common"]]
set corundum_dir_mod [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/lib"]]
set corundum_dir_zcu102 [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/mqnic/ZCU102/fpga"]]

global VIVADO_IP_LIBRARY

adi_ip_create nic_phy

set_property PART xczu9eg-ffvb1156-2-e [current_project]
source $corundum_dir_zcu102/ip/eth_xcvr_gth.tcl

adi_ip_files nic_phy [list \
  "nic_phy.v" \
  "$corundum_dir_mod/eth/rtl/lfsr.v" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$corundum_dir_common/rtl/eth_xcvr_phy_10g_gty_quad_wrapper.v" \
  "$corundum_dir_common/rtl/eth_xcvr_phy_10g_gty_wrapper.v" \
  "$corundum_dir_mod/eth/lib/axis/rtl/sync_reset.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_if.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_frame_sync.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_ber_mon.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_watchdog.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_tx.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_tx_if.v" \
  "$corundum_dir_mod/eth/rtl/lfsr.v" \
  "$corundum_dir_mod/eth/rtl/xgmii_baser_dec_64.v" \
  "$corundum_dir_mod/eth/rtl/xgmii_baser_enc_64.v" \
  "$corundum_dir_common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
]

adi_ip_properties_lite nic_phy

adi_add_bus "phy_drp" "slave" \
	"analog.com:interface:phy_drp_rtl:1.0" \
	"analog.com:interface:phy_drp:1.0" \
	{
		{"sfp_drp_addr" "SFP_DRP_ADDR"} \
		{"sfp_drp_di" "SFP_DRP_DI"} \
		{"sfp_drp_en" "SFP_DRP_EN"} \
		{"sfp_drp_we" "SFP_DRP_WE"} \
		{"sfp_drp_do" "SFP_DRP_DO"} \
		{"sfp_drp_rdy" "SFP_DRP_RDY"} \
	}
adi_add_bus_clock "sfp_drp_clk" "phy_drp" "sfp_drp_rst" "slave"

adi_add_bus "phy_mac_0" "slave" \
	"analog.com:interface:phy_mac_rtl:1.0" \
	"analog.com:interface:phy_mac:1.0" \
	{
		{"sfp0_tx_clk" "SFP_TX_CLK"} \
		{"sfp0_tx_rst" "SFP_XT_RST"} \
		{"sfp0_txd" "SFP_TXD"} \
		{"sfp0_txc" "SFP_TXC"} \
		{"sfp0_tx_prbs31_enable" "SFP_TX_PRBS31_ENABLE"} \
		{"sfp0_rx_clk" "SFP_RX_CLK"} \
		{"sfp0_rx_rst" "SFP_RX_RST"} \
		{"sfp0_rxd" "SFP_RXD"} \
		{"sfp0_rxc" "SFP_RXC"} \
		{"sfp0_rx_prbs31_enable" "SFP_RX_PRBS31_ENABLE"} \
		{"sfp0_rx_error_count" "SFP_RX_ERROR_COUNT"} \
		{"sfp0_rx_status" "SFP_RX_STATUS"} \
	}

adi_add_bus "phy_mac_1" "slave" \
	"analog.com:interface:phy_mac_rtl:1.0" \
	"analog.com:interface:phy_mac:1.0" \
	{
		{"sfp1_tx_clk" "SFP_TX_CLK"} \
		{"sfp1_tx_rst" "SFP_XT_RST"} \
		{"sfp1_txd" "SFP_TXD"} \
		{"sfp1_txc" "SFP_TXC"} \
		{"sfp1_tx_prbs31_enable" "SFP_TX_PRBS31_ENABLE"} \
		{"sfp1_rx_clk" "SFP_RX_CLK"} \
		{"sfp1_rx_rst" "SFP_RX_RST"} \
		{"sfp1_rxd" "SFP_RXD"} \
		{"sfp1_rxc" "SFP_RXC"} \
		{"sfp1_rx_prbs31_enable" "SFP_RX_PRBS31_ENABLE"} \
		{"sfp1_rx_error_count" "SFP_RX_ERROR_COUNT"} \
		{"sfp1_rx_status" "SFP_RX_STATUS"} \
	}

adi_add_bus "phy_mac_2" "slave" \
	"analog.com:interface:phy_mac_rtl:1.0" \
	"analog.com:interface:phy_mac:1.0" \
	{
		{"sfp2_tx_clk" "SFP_TX_CLK"} \
		{"sfp2_tx_rst" "SFP_XT_RST"} \
		{"sfp2_txd" "SFP_TXD"} \
		{"sfp2_txc" "SFP_TXC"} \
		{"sfp2_tx_prbs31_enable" "SFP_TX_PRBS31_ENABLE"} \
		{"sfp2_rx_clk" "SFP_RX_CLK"} \
		{"sfp2_rx_rst" "SFP_RX_RST"} \
		{"sfp2_rxd" "SFP_RXD"} \
		{"sfp2_rxc" "SFP_RXC"} \
		{"sfp2_rx_prbs31_enable" "SFP_RX_PRBS31_ENABLE"} \
		{"sfp2_rx_error_count" "SFP_RX_ERROR_COUNT"} \
		{"sfp2_rx_status" "SFP_RX_STATUS"} \
	}

adi_add_bus "phy_mac_3" "slave" \
	"analog.com:interface:phy_mac_rtl:1.0" \
	"analog.com:interface:phy_mac:1.0" \
	{
		{"sfp3_tx_clk" "SFP_TX_CLK"} \
		{"sfp3_tx_rst" "SFP_XT_RST"} \
		{"sfp3_txd" "SFP_TXD"} \
		{"sfp3_txc" "SFP_TXC"} \
		{"sfp3_tx_prbs31_enable" "SFP_TX_PRBS31_ENABLE"} \
		{"sfp3_rx_clk" "SFP_RX_CLK"} \
		{"sfp3_rx_rst" "SFP_RX_RST"} \
		{"sfp3_rxd" "SFP_RXD"} \
		{"sfp3_rxc" "SFP_RXC"} \
		{"sfp3_rx_prbs31_enable" "SFP_RX_PRBS31_ENABLE"} \
		{"sfp3_rx_error_count" "SFP_RX_ERROR_COUNT"} \
		{"sfp3_rx_status" "SFP_RX_STATUS"} \
	}


set cc [ipx::current_core]

ipx::infer_bus_interface ctrl_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface ptp_mgt_refclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::add_bus_interface mgt_refclk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:diff_clock_rtl:1.0 [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:diff_clock:1.0 [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
set_property display_name mgt_refclk [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
ipx::add_port_map CLK_P [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
set_property physical_name sfp_mgt_refclk_0_p [ipx::get_port_maps CLK_P -of_objects [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]]
ipx::add_port_map CLK_N [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]
set_property physical_name sfp_mgt_refclk_0_n [ipx::get_port_maps CLK_N -of_objects [ipx::get_bus_interfaces mgt_refclk -of_objects [ipx::current_core]]]



#ipx::infer_bus_interface {sfp_mgt_refclk_0_p sfp_mgt_refclk_0_n} xilinx.com:signal:gt_refclk_rtl:1.0 [ipx::current_core]

#ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

#set_property display_name "NIC PHY" $cc
#set_property description "CORUNDUM NIC PHY" $cc

#ipx::create_xgui_files  $cc
ipx::save_core $cc
