
source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_dec256sinc24b
adi_ip_files  util_dec256sinc24b [list \
	"$ad_hdl_dir/library/common/util_dec256sinc24b.v"]

adi_ip_properties_lite util_dec256sinc24b
ipx::remove_all_bus_interface [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

