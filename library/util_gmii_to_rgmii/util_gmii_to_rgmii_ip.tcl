# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_gmii_to_rgmii
adi_ip_files util_gmii_to_rgmii [list \
  "mdc_mdio.v" \
  "util_gmii_to_rgmii_constr.xdc" \
  "util_gmii_to_rgmii.v" ]

adi_ip_properties_lite util_gmii_to_rgmii

adi_ip_constraints util_gmii_to_rgmii [list \
  "util_gmii_to_rgmii_constr.xdc" ]

ipx::infer_bus_interface {gmii_tx_clk gmii_txd gmii_tx_en gmii_tx_er gmii_crs gmii_col gmii_rx_clk gmii_rxd gmii_rx_dv gmii_rx_er} xilinx.com:interface:gmii_rtl:1.0 [ipx::current_core]
set_property name {gmii} [ipx::get_bus_interface gmii_rtl_1 [ipx::current_core]]
ipx::infer_bus_interface {rgmii_td rgmii_tx_ctl rgmii_txc rgmii_rd rgmii_rx_ctl rgmii_rxc} xilinx.com:interface:rgmii_rtl:1.0 [ipx::current_core]
set_property value ACTIVE_HIGH [ipx::get_bus_parameters POLARITY -of_objects [ipx::get_bus_interfaces signal_reset -of_objects [ipx::current_core]]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.IODELAY_CTRL')) = 1} \
  [ipx::get_ports idelayctrl_clk -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]
