source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl
 
adi_ip_create util_clkdiv
adi_ip_files util_clkdiv [list \
"util_clkdiv.v" ]
 
adi_ip_properties_lite util_clkdiv
 
ipx::save_core [ipx::current_core]
