# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_rfifo
adi_ip_files util_rfifo [list \
  "util_rfifo.v" ]

adi_ip_properties_lite util_rfifo

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


