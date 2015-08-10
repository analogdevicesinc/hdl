# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_jesd_gt
adi_ip_files util_jesd_gt [list \
  "util_jesd_gt.v" ]

adi_ip_properties_lite util_jesd_gt

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

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports rx_p -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_n -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_out_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_sof -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_data -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_rst_done -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_sof -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_ip_data -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 0 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*0* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 1 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 2 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 3 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 4 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 5 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 6 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.RX_NUM_OF_LANES')) > 7 and \
  spirit:decode(id('MODELPARAM_VALUE.RX_ENABLE')) == 1} \
  [ipx::get_ports *rx_*7* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports tx_p -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_n -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_out_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_clk -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_data -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_rst -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_rst_done -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_sysref -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_sync -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_ip_data -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 0 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*0* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 1 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*1* -of_objects [ipx::current_core]] 
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 2 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 3 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 4 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 5 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 6 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.TX_NUM_OF_LANES')) > 7 and \
  spirit:decode(id('MODELPARAM_VALUE.TX_ENABLE')) == 1} \
  [ipx::get_ports *tx_*7* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]

