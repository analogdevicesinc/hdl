
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create spi_engine_interconnect
adi_ip_files spi_engine_interconnect [list \
	"spi_engine_interconnect.v" \
]

adi_ip_properties_lite spi_engine_interconnect
# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

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

ipx::save_core [ipx::current_core]
