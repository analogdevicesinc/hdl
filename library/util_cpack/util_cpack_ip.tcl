# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_cpack
adi_ip_files util_cpack [list \
  "util_cpack_mux.v" \
  "util_cpack_dsf.v" \
  "util_cpack.v" \
  "util_cpack_constr.xdc" ]

adi_ip_properties_lite util_cpack
adi_ip_constraints util_cpack [list \
  "util_cpack_constr.xdc" ]

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


