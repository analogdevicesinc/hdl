# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_gpreg
adi_ip_files axi_gpreg [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_gpreg_io.v" \
  "axi_gpreg_clock_mon.v" \
  "axi_gpreg.v" ]

adi_ip_properties axi_gpreg

adi_ip_add_core_dependencies { \
	analog.com:user:util_cdc:1.0 \
}

# Standalone(axi_interface) - or part of a subcore(read/write interaface)
set_property widget {checkBox} [ipgui::get_guiparamspec -name "STAND_ALONE" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters STAND_ALONE -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters STAND_ALONE -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters STAND_ALONE -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters STAND_ALONE -of_objects [ipx::current_core]]

# Destination clock
set_property widget {checkBox} [ipgui::get_guiparamspec -name "DESTINATION_CLK" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters DESTINATION_CLK -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters DESTINATION_CLK -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters DESTINATION_CLK -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters DESTINATION_CLK -of_objects [ipx::current_core]]

# Number of IOs
set_property value_format long [ipx::get_user_parameters NUM_OF_IO -of_objects [ipx::current_core]]
set_property value_format long [ipx::get_hdl_parameters NUM_OF_IO -of_objects [ipx::current_core]]
set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
	"value_validation_range_maximum" "8" \
	] \
	[ipx::get_user_parameters NUM_OF_IO -of_objects [ipx::current_core]]

# Number of clock monitors
set_property value_format long [ipx::get_user_parameters NUM_OF_CLK_MONS -of_objects [ipx::current_core]]
set_property value_format long [ipx::get_hdl_parameters NUM_OF_CLK_MONS -of_objects [ipx::current_core]]
set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
	"value_validation_range_maximum" "8" \
	] \
	[ipx::get_user_parameters NUM_OF_CLK_MONS -of_objects [ipx::current_core]]

# Enable ports

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 0} \
  [ipx::get_ports up_*_ext -of_objects [ipx::current_core]]

adi_set_bus_dependency "s_axi" "s_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 1)"

#set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 1} \
  [ipx::get_ports s_axi* -of_objects [ipx::current_core]]

for {set i 0} {$i < 8} {incr i} {
	adi_set_ports_dependency "up_gp_*_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > $i)"
}

for {set i 0} {$i < 8} {incr i} {
	adi_set_ports_dependency "d_clk_$i" \
		"(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > $i)"
}

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.DESTINATION_CLK')) = 1} \
  [ipx::get_ports clk -of_objects [ipx::current_core]]

# Drive to GND the unused input ports
set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

