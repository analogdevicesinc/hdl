# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create sysid_rom
adi_ip_files sysid_rom [list \
  "sysid_rom.v"]

adi_ip_properties_lite sysid_rom
set cc [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::save_core $cc
