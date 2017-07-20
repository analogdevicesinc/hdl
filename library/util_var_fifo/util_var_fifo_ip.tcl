# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_var_fifo
adi_ip_files util_var_fifo [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "util_var_fifo.v" ]

adi_ip_properties_lite util_var_fifo

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


