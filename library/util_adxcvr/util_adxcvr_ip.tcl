# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_adxcvr
adi_ip_files util_adxcvr [list \
  "util_adxcvr_intf.svh" \
  "util_adxcvr_xcm.sv" \
  "util_adxcvr_xch.sv" \
  "util_adxcvr.sv" ]

adi_ip_properties_lite util_adxcvr

ipx::save_core [ipx::current_core]

