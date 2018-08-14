source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_cic

add_files -fileset [get_filesets sources_1] [list \
  "cic_int.v" \
  "cic_comb.v" \
]

adi_ip_properties_lite util_cic

set_property name "util_cic" [ipx::current_core]
set_property display_name "CIC building blocks" [ipx::current_core]
set_property description "CIC building blocks" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::save_core [ipx::current_core]
