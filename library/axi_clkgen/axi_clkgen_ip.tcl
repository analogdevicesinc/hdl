# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_clkgen
adi_ip_files axi_clkgen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clkgen.v" \
  "$ad_hdl_dir/library/scripts/adi_xilinx_device_info_enc.tcl" \
  "bd/bd.tcl" \
  "axi_clkgen.v" ]

adi_ip_properties axi_clkgen
adi_ip_bd axi_clkgen "bd/bd.tcl"

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk2 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_0 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_1 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set param [ipx::add_user_parameter ENABLE_CLKIN2 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKIN2} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock input} \
	widget {checkBox} \
] $param

set param [ipx::add_user_parameter ENABLE_CLKOUT1 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKOUT1} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock output} \
	widget {checkBox} \
] $param

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

set_property enablement_tcl_expr {$ENABLE_CLKIN2} [ipx::get_user_parameters CLKIN2_PERIOD -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_DIV -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_PHASE -of_objects $cc]

adi_set_ports_dependency clk2 ENABLE_CLKIN2 0
adi_set_ports_dependency clk_1 ENABLE_CLKOUT1

ipx::create_xgui_files $cc
ipx::save_core $cc
