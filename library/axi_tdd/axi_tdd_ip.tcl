# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_tdd
adi_ip_files axi_tdd [list \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/common/ad_tdd_control.v" \
  "$ad_hdl_dir/library/common/up_tdd_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "axi_tdd.v" ]

adi_ip_properties axi_tdd
adi_ip_ttcl axi_tdd "axi_tdd_constr.ttcl"
set_property display_name "ADI AXI TDD Controller" [ipx::current_core]
set_property description "ADI AXI TDD Controller" [ipx::current_core]
set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_tdd} [ipx::current_core]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset rst ACTIVE_HIGH
add_reset s_axi_aresetn ACTIVE_LOW

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]]

set cc [ipx::current_core]
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create a new GUI page
ipgui::add_page -name {ADI AXI TDD Controller} -component [ipx::current_core] -display_name {ADI AXI TDD Controller}
set page0 [ipgui::get_pagespec -name "ADI AXI TDD Controller" -component $cc]

## General Configurations
set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

set param [ipgui::add_param -name {ASYNC_TDD_SYNC} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Insert false path for tdd_sync} \
	widget {checkBox} \
] $param

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

