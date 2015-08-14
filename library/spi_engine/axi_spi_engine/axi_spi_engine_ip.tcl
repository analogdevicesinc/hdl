# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_spi_engine
adi_ip_files axi_spi_engine [list \
  "axi_spi_engine.v" \
  "$ad_hdl_dir/library/common/sync_bits.v" \
  "$ad_hdl_dir/library/common/sync_gray.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
]

adi_ip_properties axi_spi_engine
# Remove auto inferred interfaces
ipx::remove_bus_interface offload0_mem_signal_reset [ipx::current_core]
ipx::remove_bus_interface spi_signal_clock [ipx::current_core]
ipx::remove_bus_interface spi_signal_reset [ipx::current_core]

adi_ip_add_core_dependencies { \
	analog.com:user:util_axis_fifo:1.0 \
}

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

adi_add_bus "spi_engine_ctrl" "master" \
	"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_ctrl:1.0" \
	{
		{"cmd_ready" "CMD_READY"} \
		{"cmd_valid" "CMD_VALID"} \
		{"cmd_data" "CMD_DATA"} \
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
adi_add_bus_clock "spi_clk" "spi_engine_ctrl" "spi_resetn" "master"

adi_add_bus "spi_engine_offload_ctrl0" "master" \
	"analog.com:interface:spi_engine_offload_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_offload_ctrl:1.0" \
	{ \
		{ "offload0_cmd_wr_en" "CMD_WR_EN"} \
		{ "offload0_cmd_wr_data" "CMD_WR_DATA"} \
		{ "offload0_sdo_wr_en" "SDO_WR_EN"} \
		{ "offload0_sdo_wr_data" "SDO_WR_DATA"} \
		{ "offload0_enable" "ENABLE"} \
		{ "offload0_enabled" "ENABLED"} \
		{ "offload0_mem_reset" "MEM_RESET"} \
	}

adi_add_bus_clock "s_axi_aclk" "spi_engine_offload_ctrl0:s_axi" "s_axi_aresetn"

ipx::save_core [ipx::current_core]
