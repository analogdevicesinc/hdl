# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_pmod_adc
adi_ip_files util_pmod_adc [list \
  "util_pmod_adc_constr.xdc" \
  "util_pmod_adc.v"
]

adi_ip_properties_lite util_pmod_adc

adi_ip_constraints util_pmod_adc [list \
  "util_pmod_adc_constr.xdc" ]

# set reset polarity to high
set reset_inf [ipx::get_bus_interfaces "signal_reset" -of_objects [ipx::current_core]]
set reset_polarity [ipx::get_bus_parameters "POLARITY" -of_objects $reset_inf]
set_property value "ACTIVE_HIGH" $reset_polarity

ipx::save_core [ipx::current_core]


