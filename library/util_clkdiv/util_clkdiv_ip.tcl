source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_clkdiv
adi_ip_files util_clkdiv [list \
  "util_clkdiv_constr.xdc" \
  "util_clkdiv.v" ]

adi_ip_properties_lite util_clkdiv

adi_ip_constraints util_clkdiv [list \
  "util_clkdiv_constr.xdc" ]

set_property driver_value 0 [ipx::get_ports clk_sel -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]
