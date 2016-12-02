
# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_tdd_sync
adi_ip_files util_tdd_sync [list \
  "$ad_hdl_dir/library/common/util_pulse_gen.v" \
  "util_tdd_sync.v"]

adi_ip_properties_lite util_tdd_sync
adi_ip_constraints util_tdd_sync [list \
  "util_tdd_sync_constr.xdc" \
]

ipx::save_core [ipx::current_core]

