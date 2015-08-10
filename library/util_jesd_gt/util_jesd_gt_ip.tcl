# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_jesd_gt
adi_ip_files util_jesd_gt [list \
  "util_jesd_gt.v" ]

adi_ip_properties_lite util_jesd_gt

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0} \
  [ipx::get_ports *rx_*_0* -of_objects [ipx::current_core]] 
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

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 0} \
  [ipx::get_ports *tx_*_0* -of_objects [ipx::current_core]] 
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

