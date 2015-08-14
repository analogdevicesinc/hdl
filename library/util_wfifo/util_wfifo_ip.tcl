# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_wfifo
adi_ip_files util_wfifo [list \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "util_wfifo_constr.xdc" \
  "util_wfifo.v" ]

adi_ip_properties_lite util_wfifo

adi_ip_constraints util_wfifo [list \
  "util_wfifo_constr.xdc" ]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


