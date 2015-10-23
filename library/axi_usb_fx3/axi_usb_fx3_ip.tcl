# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_usb_fx3
adi_ip_files axi_usb_fx3 [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_usb_fx3_core.v" \
  "axi_usb_fx3_if.v" \
  "axi_usb_fx3_reg.v" \
  "axi_usb_fx3.v"]

adi_ip_properties axi_usb_fx3

ipx::remove_bus_interface rst [ipx::current_core]
ipx::remove_bus_interface clk [ipx::current_core]
ipx::remove_bus_interface l_clk [ipx::current_core]
ipx::remove_bus_interface delay_clk [ipx::current_core]

adi_add_bus_clock "s_axi_aclk" "s_axis"
adi_add_bus_clock "s_axi_aclk" "m_axis"

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

#adi_ip_constraints axi_usb_fx3 [list \
#  "axi_usb_fx3_constr.xdc" ]

#set_property driver_value 0 [ipx::get_ports *dunf* -of_objects [ipx::current_core]]
#set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]
