source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_delay
adi_ip_files util_delay [list \
	"$ad_hdl_dir/library/common/util_delay.v"]

adi_ip_properties_lite util_delay
ipx::remove_all_bus_interface [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

set_property value_validation_range_minimum 1 [ipx::get_user_parameters DELAY_CYCLES -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]
