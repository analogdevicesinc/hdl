# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_upack
adi_ip_files util_upack [list \
  "util_upack_dmx.v" \
  "util_upack_dsf.v" \
  "util_upack.v" \
  "util_upack_constr.xdc" ]

adi_ip_properties_lite util_upack
adi_ip_constraints util_upack [list \
  "util_upack_constr.xdc" ]

set_property driver_value 0 [ipx::get_ports *dac_enable* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dac_valid* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dac_data* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dma_xfer_in* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 1} \
  [ipx::get_ports *_1* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 2} \
  [ipx::get_ports *_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 3} \
  [ipx::get_ports *_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 4} \
  [ipx::get_ports *_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 5} \
  [ipx::get_ports *_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 6} \
  [ipx::get_ports *_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > 7} \
  [ipx::get_ports *_7* -of_objects [ipx::current_core]]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


