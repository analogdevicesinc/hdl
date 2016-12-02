# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_dacfifo
adi_ip_files util_dacfifo [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "util_dacfifo.v" \
  "util_dacfifo_constr.xdc"]

adi_ip_properties_lite util_dacfifo
adi_ip_constraints util_dacfifo [list \
  "util_dacfifo_constr.xdc" ]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]

