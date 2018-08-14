# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_spi_engine
adi_ip_files axi_spi_engine [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "axi_spi_engine_constr.ttcl" \
  "axi_spi_engine.v" \
]

adi_ip_properties axi_spi_engine
adi_ip_ttcl axi_spi_engine "axi_spi_engine_constr.ttcl"

adi_ip_add_core_dependencies { \
	analog.com:user:util_axis_fifo:1.0 \
	analog.com:user:util_cdc:1.0 \
}

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

foreach port {"up_clk" "up_rstn" "up_wreq" "up_waddr" "up_wdata" "up_rreq" "up_raddr"} {
  set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}
adi_set_bus_dependency "spi_engine_offload_ctrl0" "spi_engine_offload_ctrl0" \
	"(spirit:decode(id('MODELPARAM_VALUE.NUM_OFFLOAD')) > 0)"

adi_set_bus_dependency "s_axi" "s_axi" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 0)"

adi_set_ports_dependency "up_clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rstn" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_waddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_raddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"

ipx::save_core [ipx::current_core]
