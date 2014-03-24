# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_sync_reset
adi_ip_files util_sync_reset [list \
  "util_sync_reset.v" ]

adi_ip_properties_lite util_sync_reset

ipx::save_core [ipx::current_core]

