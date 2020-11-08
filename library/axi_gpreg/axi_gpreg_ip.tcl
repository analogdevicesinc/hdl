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
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 0} \
  [ipx::get_ports up_gp_*_0 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 1} \
  [ipx::get_ports up_gp_*_1 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 2} \
  [ipx::get_ports up_gp_*_2 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 3} \
  [ipx::get_ports up_gp_*_3 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 4} \
  [ipx::get_ports up_gp_*_4 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 5} \
  [ipx::get_ports up_gp_*_5 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 6} \
  [ipx::get_ports up_gp_*_6 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 7} \
  [ipx::get_ports up_gp_*_7 -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 0} \
  [ipx::get_ports d_clk_0 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 1} \
  [ipx::get_ports d_clk_1 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 2} \
  [ipx::get_ports d_clk_2 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 3} \
  [ipx::get_ports d_clk_3 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 4} \
  [ipx::get_ports d_clk_4 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 5} \
  [ipx::get_ports d_clk_5 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 6} \
  [ipx::get_ports d_clk_6 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 7} \
  [ipx::get_ports d_clk_7 -of_objects [ipx::current_core]]

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
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 0} \
  [ipx::get_ports up_*_ext -of_objects [ipx::current_core]]

adi_set_bus_dependency "s_axi" "s_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 1)"

#set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.STAND_ALONE')) = 1} \
  [ipx::get_ports s_axi* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

