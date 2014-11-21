# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_cpack
adi_ip_files util_cpack [list \
  "util_cpack_mux.v" \
  "util_cpack_dsf.v" \
  "util_cpack.v" \
  "util_cpack_constr.xdc" ]

adi_ip_properties_lite util_cpack
adi_ip_constraints util_cpack [list \
  "util_cpack_constr.xdc" ]

ipx::save_core [ipx::current_core]


