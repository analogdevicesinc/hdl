source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create spi_engine_offload
adi_ip_files spi_engine_offload [list \
	"spi_engine_offload.v" \
]

adi_ip_properties_lite spi_engine_offload
# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

adi_add_bus "spi_engine_ctrl" "master" \
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
		{"sync_data" "SYNC_DATA"} \
	}

adi_add_bus "spi_engine_offload_ctrl" "slave" \
	"analog.com:interface:spi_engine_offload_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_offload_ctrl:1.0" \
	{ \
		{ "ctrl_cmd_wr_en" "CMD_WR_EN"} \
		{ "ctrl_cmd_wr_data" "CMD_WR_DATA"} \
		{ "ctrl_sdo_wr_en" "SDO_WR_EN"} \
		{ "ctrl_sdo_wr_data" "SDO_WR_DATA"} \
		{ "ctrl_enable" "ENABLE"} \
		{ "ctrl_enabled" "ENABLED"} \
		{ "ctrl_mem_reset" "MEM_RESET"} \
	}

adi_add_bus "offload_sdi" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"offload_sdi_valid" "TVALID"} \
		{"offload_sdi_ready" "TREADY"} \
		{"offload_sdi_data" "TDATA"} \
	}

adi_add_bus_clock "spi_clk" "spi_engine_ctrl:offload_sdi" "spi_resetn"
adi_add_bus_clock "ctrl_clk" "spi_engine_offload_ctrl"

ipx::save_core [ipx::current_core]
