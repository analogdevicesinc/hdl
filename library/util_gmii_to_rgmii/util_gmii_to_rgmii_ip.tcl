# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_gmii_to_rgmii
adi_ip_files util_gmii_to_rgmii [list \
  "mdc_mdio.v" \
  "util_gmii_to_rgmii_constr.xdc" \
  "util_gmii_to_rgmii.v" ]

adi_ip_properties_lite util_gmii_to_rgmii

ipx::infer_bus_interface {gmii_tx_clk gmii_txd gmii_tx_en gmii_tx_er gmii_crs gmii_col gmii_rx_clk gmii_rxd gmii_rx_dv gmii_rx_er} xilinx.com:interface:gmii_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface {rgmii_td rgmii_tx_ctl rgmii_txc rgmii_rd rgmii_rx_ctl rgmii_rxc} xilinx.com:interface:rgmii_rtl:1.0 [ipx::current_core]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.IODELAY_CTRL')) = 1} \
  [ipx::get_ports idelayctrl_clk -of_objects [ipx::current_core]]

ipx::infer_bus_interface clk_20m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_25m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_125m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface idelayctrl_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]
