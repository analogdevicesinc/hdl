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

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1} \
  [ipx::get_ports *rx_*_1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2} \
  [ipx::get_ports *rx_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3} \
  [ipx::get_ports *rx_*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4} \
  [ipx::get_ports *rx_*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5} \
  [ipx::get_ports *rx_*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6} \
  [ipx::get_ports *rx_*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7} \
  [ipx::get_ports *rx_*_7* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 1} \
  [ipx::get_ports *tx_*_1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 2} \
  [ipx::get_ports *tx_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 3} \
  [ipx::get_ports *tx_*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 4} \
  [ipx::get_ports *tx_*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 5} \
  [ipx::get_ports *tx_*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 6} \
  [ipx::get_ports *tx_*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 7} \
  [ipx::get_ports *tx_*_7* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

