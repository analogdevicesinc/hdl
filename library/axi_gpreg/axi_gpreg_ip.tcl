###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_gpreg
adi_ip_files axi_gpreg [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_gpreg_io.v" \
  "axi_gpreg_constr.ttcl" \
  "axi_gpreg_clock_mon.v" \
  "axi_gpreg.v" ]
  
set_property FILE_TYPE SystemVerilog [get_files "axi_gpreg.v"]

adi_ip_properties axi_gpreg
adi_ip_ttcl axi_gpreg "axi_gpreg_constr.ttcl"

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

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

