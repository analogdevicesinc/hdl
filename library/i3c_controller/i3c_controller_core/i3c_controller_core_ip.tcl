source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_core
adi_ip_files i3c_controller_core [list \
	"i3c_controller_core_constr.ttcl" \
	"i3c_controller_core.v" \
  "i3c_controller_framing.v" \
  "i3c_controller_daa.v" \
  "i3c_controller_bit_mod.v" \
  "i3c_controller_quarter_clk.v"
]

adi_ip_properties_lite i3c_controller_core
adi_ip_ttcl i3c_controller_core "i3c_controller_core_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/engine} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions
adi_add_bus "i3c" "master" \
	"analog.com:interface:i3c_controller_rtl:1.0" \
	"analog.com:interface:i3c_controller:1.0" \
	{
		{"scl" "SCL"} \
		{"sda" "SDA"} \
	}
adi_add_bus_clock "clk" "i3c" "resetn"

## Parameter validations
set cc [ipx::current_core]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Core} -component [ipx::current_core] -display_name {AXI I3C Controller Core}
set page0 [ipgui::get_pagespec -name "I3C Controller Core" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
