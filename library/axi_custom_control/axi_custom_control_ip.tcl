# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_custom_control
adi_ip_files axi_custom_control [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "axi_custom_control_reg.v" \
  "axi_custom_control.v" ]

adi_ip_properties axi_custom_control
ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

set_property driver_value 0 [ipx::get_ports *reg_status_* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *reg_control_* -of_objects [ipx::current_core]]

set_property value_format long [ipx::get_user_parameters N_STATUS_REG -of_objects [ipx::current_core]]
set_property value_format long [ipx::get_hdl_parameters N_STATUS_REG -of_objects [ipx::current_core]]
set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "16" \
	] \
	[ipx::get_user_parameters N_STATUS_REG -of_objects [ipx::current_core]]

set_property value_format long [ipx::get_user_parameters N_CONTROL_REG -of_objects [ipx::current_core]]
set_property value_format long [ipx::get_hdl_parameters N_CONTROL_REG -of_objects [ipx::current_core]]
set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "16" \
	] \
	[ipx::get_user_parameters N_CONTROL_REG -of_objects [ipx::current_core]]

for {set i 1} {$i < 16} {incr i} {
	adi_set_ports_dependency "reg_status_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.N_STATUS_REG')) > $i)"
}

for {set i 1} {$i < 16} {incr i} {
	adi_set_ports_dependency "reg_control_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.N_CONTROL_REG')) > $i)"

ipx::associate_bus_interfaces -busif s_axis -clock clk [ipx::current_core]

ipx::save_core [ipx::current_core]

