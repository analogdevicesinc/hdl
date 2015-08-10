# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_jesd_gt
adi_ip_files axi_jesd_gt [list \
  "axi_jesd_gt_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel.v" \
  "$ad_hdl_dir/library/common/ad_gt_common.v" \
  "$ad_hdl_dir/library/common/ad_gt_es.v" \
  "$ad_hdl_dir/library/common/ad_gt_es_axi.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_common_1.v" \
  "$ad_hdl_dir/library/common/ad_jesd_align.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_gt_channel.v" \
  "$ad_hdl_dir/library/common/up_gt.v" \
  "axi_jesd_gt.v" ]

adi_ip_properties axi_jesd_gt

adi_ip_constraints axi_jesd_gt [list \
  "axi_jesd_gt_constr.xdc" ]

set_property value m_axi:s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

set_property value axi_aresetn [ipx::get_bus_parameters ASSOCIATED_RESET \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.QPLL0_ENABLE')) == 1} \
  [ipx::get_ports qpll0_* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.QPLL1_ENABLE')) == 1} \
  [ipx::get_ports qpll1_* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 0} \
  [ipx::get_ports pll_*_0* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_0* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 1} \
  [ipx::get_ports pll_*_1* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_1* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 2} \
  [ipx::get_ports pll_*_2* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 3} \
  [ipx::get_ports pll_*_3* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 4} \
  [ipx::get_ports pll_*_4* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 5} \
  [ipx::get_ports pll_*_5* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 6} \
  [ipx::get_ports pll_*_6* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_LANES')) > 7} \
  [ipx::get_ports pll_*_7* -of_objects [ipx::current_core]] \
  [ipx::get_ports cpll_*_7* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0} \
  [ipx::get_ports *rx_*0* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1} \
  [ipx::get_ports *rx_*1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2} \
  [ipx::get_ports *rx_*2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3} \
  [ipx::get_ports *rx_*3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4} \
  [ipx::get_ports *rx_*4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5} \
  [ipx::get_ports *rx_*5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6} \
  [ipx::get_ports *rx_*6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7} \
  [ipx::get_ports *rx_*7* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 0} \
  [ipx::get_ports *tx_*0* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 1} \
  [ipx::get_ports *tx_*1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 2} \
  [ipx::get_ports *tx_*2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 3} \
  [ipx::get_ports *tx_*3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 4} \
  [ipx::get_ports *tx_*4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 5} \
  [ipx::get_ports *tx_*5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 6} \
  [ipx::get_ports *tx_*6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 7} \
  [ipx::get_ports *tx_*7* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

