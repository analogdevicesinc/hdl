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

set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 1}} \
  [ipx::get_port adc_enable_1 [ipx::current_core]] \
  [ipx::get_port adc_valid_1 [ipx::current_core]] \
  [ipx::get_port adc_data_1 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 2}} \
  [ipx::get_port adc_enable_2 [ipx::current_core]] \
  [ipx::get_port adc_valid_2 [ipx::current_core]] \
  [ipx::get_port adc_data_2 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 3}} \
  [ipx::get_port adc_enable_3 [ipx::current_core]] \
  [ipx::get_port adc_valid_3 [ipx::current_core]] \
  [ipx::get_port adc_data_3 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 4}} \
  [ipx::get_port adc_enable_4 [ipx::current_core]] \
  [ipx::get_port adc_valid_4 [ipx::current_core]] \
  [ipx::get_port adc_data_4 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 5}} \
  [ipx::get_port adc_enable_5 [ipx::current_core]] \
  [ipx::get_port adc_valid_5 [ipx::current_core]] \
  [ipx::get_port adc_data_5 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 6}} \
  [ipx::get_port adc_enable_6 [ipx::current_core]] \
  [ipx::get_port adc_valid_6 [ipx::current_core]] \
  [ipx::get_port adc_data_6 [ipx::current_core]] \


set_property -dict {driver_value {0} enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CH_CNT')) > 7}} \
  [ipx::get_port adc_enable_7 [ipx::current_core]] \
  [ipx::get_port adc_valid_7 [ipx::current_core]] \
  [ipx::get_port adc_data_7 [ipx::current_core]] \


ipx::save_core [ipx::current_core]


