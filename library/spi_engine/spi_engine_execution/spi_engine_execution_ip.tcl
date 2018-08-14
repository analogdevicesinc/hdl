
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create spi_engine_execution
adi_ip_files spi_engine_execution [list \
	"spi_engine_execution.v" \
]

adi_ip_properties_lite spi_engine_execution
# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

adi_add_bus "ctrl" "slave" \
	"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_ctrl:1.0" \
	{
		{"cmd_ready" "CMD_READY"} \
		{"cmd_valid" "CMD_VALID"} \
		{"cmd" "CMD_DATA"} \
		{"sdo_data_ready" "SDO_READY"} \
		{"sdo_data_valid" "SDO_VALID"} \
		{"sdo_data" "SDO_DATA"} \
		{"sdi_data_ready" "SDI_READY"} \
		{"sdi_data_valid" "SDI_VALID"} \
		{"sdi_data" "SDI_DATA"} \
		{"sync_ready" "SYNC_READY"} \
		{"sync_valid" "SYNC_VALID"} \
		{"sync" "SYNC_DATA"} \
	}
adi_add_bus_clock "clk" "ctrl" "resetn"

adi_add_bus "spi" "master" \
	"analog.com:interface:spi_master_rtl:1.0" \
	"analog.com:interface:spi_master:1.0" \
	{
		{"sclk" "SCLK"} \
		{"sdi" "SDI"} \
		{"sdi_1" "SDI_1"} \
		{"sdi_2" "SDI_2"} \
		{"sdi_3" "SDI_3"} \
		{"sdi_4" "SDI_4"} \
		{"sdi_5" "SDI_5"} \
		{"sdi_6" "SDI_6"} \
		{"sdi_7" "SDI_7"} \
		{"sdo" "SDO"} \
		{"sdo_t" "SDO_T"} \
		{"three_wire" "THREE_WIRE"} \
		{"cs" "CS"} \
	}
adi_add_bus_clock "clk" "spi" "resetn"

foreach port {"sdi_1" "sdi_2" "sdi_3" "sdi_4" "sdi_5" "sdi_6" "sdi_7"} {
  set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}
adi_set_ports_dependency "sdi_1" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 1)"
adi_set_ports_dependency "sdi_2" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 2)"
adi_set_ports_dependency "sdi_3" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 3)"
adi_set_ports_dependency "sdi_4" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 4)"
adi_set_ports_dependency "sdi_5" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 5)"
adi_set_ports_dependency "sdi_6" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 6)"
adi_set_ports_dependency "sdi_7" \
      "(spirit:decode(id('MODELPARAM_VALUE.NUM_OF_SDI')) > 7)"

ipx::save_core [ipx::current_core]
