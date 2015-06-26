# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_jesd_xmit
adi_ip_files util_jesd_xmit [list \
  "util_jesd_xmit.v" \
  "util_jesd_xmit_constr.xdc" ]

adi_ip_properties_lite util_jesd_xmit
adi_ip_constraints util_jesd_xmit [list \
  "util_jesd_xmit_constr.xdc" ]

ipx::save_core [ipx::current_core]


