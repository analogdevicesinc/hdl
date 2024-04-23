# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create io_vip
adi_ip_files io_vip [list \
  "io_vip.sv" \
  "io_vip_if.sv" ]

adi_ip_properties_lite io_vip
ipx::save_core [ipx::current_core]


