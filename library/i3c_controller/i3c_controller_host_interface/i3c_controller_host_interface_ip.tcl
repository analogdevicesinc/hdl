source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_host_interface
adi_ip_files i3c_controller_host_interface [list \
	"i3c_controller_host_interface_constr.ttcl" \
	"i3c_controller_host_interface.v" \
  "i3c_controller_cmd_parser.v" \
  "i3c_controller_write_byte.v" \
  "i3c_controller_read_byte.v" \
]

adi_ip_properties_lite i3c_controller_host_interface
adi_ip_ttcl i3c_controller_host_interface "i3c_controller_host_interface_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/engine} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions
adi_add_bus "ctrl" "slave" \
	"analog.com:interface:i3c_controller_ctrl_rtl:1.0" \
	"analog.com:interface:i3c_controller_ctrl:1.0" \
	{
		{"cmd_ready" "CMD_READY"} \
		{"cmd_valid" "CMD_VALID"} \
		{"cmd" "CMD_DATA"} \
		{"cmdr_ready" "CMDR_READY"} \
		{"cmdr_valid" "CMDR_VALID"} \
		{"cmdr" "CMDR_DATA"} \
		{"sdo_ready" "SDO_READY"} \
		{"sdo_valid" "SDO_VALID"} \
		{"sdo" "SDO_DATA"} \
		{"sdi_ready" "SDI_READY"} \
		{"sdi_valid" "SDI_VALID"} \
		{"sdi" "SDI_DATA"} \
		{"ibi_ready" "IBI_READY"} \
		{"ibi_valid" "IBI_VALID"} \
		{"ibi" "IBI_DATA"} \
	}
adi_add_bus_clock "clk" "ctrl" "resetn"

## Parameter validations
set cc [ipx::current_core]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Host Interface} -component [ipx::current_core] -display_name {AXI I3C Controller Host Interface}
set page0 [ipgui::get_pagespec -name "I3C Controller Host Interface" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
