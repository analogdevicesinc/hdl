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

set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 1}} \
  [ipx::get_port dac_enable_1 [ipx::current_core]] \
  [ipx::get_port dac_valid_1 [ipx::current_core]] \
  [ipx::get_port dac_data_1 [ipx::current_core]] \
  [ipx::get_port upack_valid_1 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 2}} \
  [ipx::get_port dac_enable_2 [ipx::current_core]] \
  [ipx::get_port dac_valid_2 [ipx::current_core]] \
  [ipx::get_port dac_data_2 [ipx::current_core]] \
  [ipx::get_port upack_valid_2 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 3}} \
  [ipx::get_port dac_enable_3 [ipx::current_core]] \
  [ipx::get_port dac_valid_3 [ipx::current_core]] \
  [ipx::get_port dac_data_3 [ipx::current_core]] \
  [ipx::get_port upack_valid_3 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 4}} \
  [ipx::get_port dac_enable_4 [ipx::current_core]] \
  [ipx::get_port dac_valid_4 [ipx::current_core]] \
  [ipx::get_port dac_data_4 [ipx::current_core]] \
  [ipx::get_port upack_valid_4 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 5}} \
  [ipx::get_port dac_enable_5 [ipx::current_core]] \
  [ipx::get_port dac_valid_5 [ipx::current_core]] \
  [ipx::get_port dac_data_5 [ipx::current_core]] \
  [ipx::get_port upack_valid_5 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 6}} \
  [ipx::get_port dac_enable_6 [ipx::current_core]] \
  [ipx::get_port dac_valid_6 [ipx::current_core]] \
  [ipx::get_port dac_data_6 [ipx::current_core]] \
  [ipx::get_port upack_valid_6 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 7}} \
  [ipx::get_port dac_enable_7 [ipx::current_core]] \
  [ipx::get_port dac_valid_7 [ipx::current_core]] \
  [ipx::get_port dac_data_7 [ipx::current_core]] \
  [ipx::get_port upack_valid_7 [ipx::current_core]] \


ipx::save_core [ipx::current_core]


