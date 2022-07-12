
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create spi_engine_interconnect
adi_ip_files spi_engine_interconnect [list \
	"spi_engine_interconnect.v" \
]

adi_ip_properties_lite spi_engine_interconnect

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/spi_engine/interconnect} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions

adi_add_bus "m_ctrl" "master" \
	"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_ctrl:1.0" \
	{ \
		{"m_cmd_ready" "CMD_READY"} \
		{"m_cmd_valid" "CMD_VALID"} \
		{"m_cmd_data" "CMD_DATA"} \
		{"m_sdo_ready" "SDO_READY"} \
		{"m_sdo_valid" "SDO_VALID"} \
		{"m_sdo_data" "SDO_DATA"} \
		{"m_sdi_ready" "SDI_READY"} \
		{"m_sdi_valid" "SDI_VALID"} \
		{"m_sdi_data" "SDI_DATA"} \
		{"m_sync_ready" "SYNC_READY"} \
		{"m_sync_valid" "SYNC_VALID"} \
		{"m_sync" "SYNC_DATA"} \
	}
adi_add_bus_clock "clk" "m_ctrl" "resetn"

foreach prefix [list "s0" "s1"] {
	adi_add_bus [format "%s_ctrl" $prefix] "slave" \
		"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
		"analog.com:interface:spi_engine_ctrl:1.0" \
		[list \
			[list [format "%s_cmd_ready" $prefix] "CMD_READY"] \
			[list [format "%s_cmd_valid" $prefix] "CMD_VALID"] \
			[list [format "%s_cmd_data" $prefix] "CMD_DATA"] \
			[list [format "%s_sdo_ready" $prefix] "SDO_READY"] \
			[list [format "%s_sdo_valid" $prefix] "SDO_VALID"] \
			[list [format "%s_sdo_data" $prefix] "SDO_DATA"] \
			[list [format "%s_sdi_ready" $prefix] "SDI_READY"] \
			[list [format "%s_sdi_valid" $prefix] "SDI_VALID"] \
			[list [format "%s_sdi_data" $prefix] "SDI_DATA"] \
			[list [format "%s_sync_ready" $prefix] "SYNC_READY"] \
			[list [format "%s_sync_valid" $prefix] "SYNC_VALID"] \
			[list [format "%s_sync" $prefix] "SYNC_DATA"] \
		]
	adi_add_bus_clock "clk" [format "%s_ctrl" $prefix] "resetn"
}

## Parameter validations

set cc [ipx::current_core]

## DATA_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "256" \
 ] \
 [ipx::get_user_parameters DATA_WIDTH -of_objects $cc]

## NUM_OF_SDI
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OF_SDI -of_objects $cc]

## Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {SPI Engine interconnect} -component [ipx::current_core] -display_name {SPI Engine interconnect}
set page0 [ipgui::get_pagespec -name "SPI Engine interconnect" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Parallel data width" \
  "tooltip" "\[DATA_WIDTH\] Define the data interface width"
] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component $cc]

ipgui::add_param -name "NUM_OF_SDI" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Number of MISO lines" \
  "tooltip" "\[NUM_OF_SDI\] Define the number of MISO lines" \
] [ipgui::get_guiparamspec -name "NUM_OF_SDI" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
