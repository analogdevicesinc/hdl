# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_jesd_gt
adi_ip_files axi_jesd_gt [list \
  "$ad_hdl_dir/library/common/ad_gt_common_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_channel_1.v" \
  "$ad_hdl_dir/library/common/ad_gt_es.v" \
  "$ad_hdl_dir/library/common/ad_jesd_align.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_gt.v" \
  "axi_jesd_gt.v" \
  "axi_jesd_gt_constr.xdc" ]

adi_ip_properties axi_jesd_gt

adi_ip_constraints axi_jesd_gt [list \
  "axi_jesd_gt_constr.xdc" ]

set_property value m_axi:s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

set_property value axi_aresetn [ipx::get_bus_parameters ASSOCIATED_RESET \
  -of_objects [ipx::get_bus_interfaces axi_signal_clock \
  -of_objects [ipx::current_core]]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 1} \
  [ipx::get_ports *rx_gt_*_1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 2} \
  [ipx::get_ports *rx_gt_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 3} \
  [ipx::get_ports *rx_gt_*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 4} \
  [ipx::get_ports *rx_gt_*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 5} \
  [ipx::get_ports *rx_gt_*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 6} \
  [ipx::get_ports *rx_gt_*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_RX_LANES')) > 7} \
  [ipx::get_ports *rx_gt_*_7* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports *tx_gt_charisk_* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *tx_gt_data_* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 1} \
  [ipx::get_ports *tx_gt_*_1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 2} \
  [ipx::get_ports *tx_gt_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 3} \
  [ipx::get_ports *tx_gt_*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 4} \
  [ipx::get_ports *tx_gt_*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 5} \
  [ipx::get_ports *tx_gt_*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 6} \
  [ipx::get_ports *tx_gt_*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.PCORE_NUM_OF_TX_LANES')) > 7} \
  [ipx::get_ports *tx_gt_*_7* -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

