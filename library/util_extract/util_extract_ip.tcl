# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_extract
adi_ip_files util_extract [list \
  "util_extract.v" ]

adi_ip_properties_lite util_extract

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


