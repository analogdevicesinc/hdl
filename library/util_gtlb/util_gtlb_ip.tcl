# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_gtlb
adi_ip_files util_gtlb [list \
  "util_gtlb.v" ]

adi_ip_properties_lite util_gtlb
adi_ip_constraints util_gtlb [list \
  "util_gtlb_constr.xdc" ]

ipx::remove_all_bus_interface [ipx::current_core]
ipx::save_core [ipx::current_core]


