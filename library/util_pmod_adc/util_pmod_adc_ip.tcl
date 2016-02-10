# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_pmod_adc
adi_ip_files util_pmod_adc [list \
  "util_pmod_adc.v" \
  "util_pmod_adc_constr.xdc"
]

adi_ip_properties_lite util_pmod_adc

adi_ip_constraints util_pmod_adc [list \
  "util_pmod_adc_constr.xdc" ]

ipx::save_core [ipx::current_core]

