# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_wfifo
adi_ip_files util_wfifo [list \
  "util_wfifo.v" ]

adi_ip_properties_lite util_wfifo
ipx::save_core [ipx::current_core]


