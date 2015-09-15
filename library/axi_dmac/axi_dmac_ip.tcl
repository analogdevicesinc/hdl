# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_dmac
adi_ip_files axi_dmac [list \
  "$ad_hdl_dir/library/common/sync_bits.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "address_generator.v" \
  "data_mover.v" \
  "request_arb.v" \
  "request_generator.v" \
  "response_handler.v" \
  "axi_register_slice.v" \
  "2d_transfer.v" \
  "dest_axi_mm.v" \
  "dest_axi_stream.v" \
  "dest_fifo_inf.v" \
  "src_axi_mm.v" \
  "src_axi_stream.v" \
  "src_fifo_inf.v" \
  "splitter.v" \
  "response_generator.v" \
  "axi_dmac.v" \
  "axi_dmac_constr.ttcl" ]

adi_ip_properties axi_dmac
adi_ip_ttcl axi_dmac "axi_dmac_constr.ttcl"

adi_ip_add_core_dependencies { \
	analog.com:user:util_axis_resize:1.0 \
	analog.com:user:util_axis_fifo:1.0 \
}

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"s_axis_ready" "TREADY"} \
	  {"s_axis_valid" "TVALID"} \
	  {"s_axis_data" "TDATA"} \
	  {"s_axis_user" "TUSER"} ]
adi_add_bus_clock "s_axis_aclk" "s_axis"

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"m_axis_ready" "TREADY"} \
	  {"m_axis_valid" "TVALID"} \
	  {"m_axis_data" "TDATA"} ]
adi_add_bus_clock "m_axis_aclk" "m_axis"
   
adi_set_bus_dependency "m_src_axi" "m_src_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 0)"
adi_set_bus_dependency "m_dest_axi" "m_dest_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 0)"
adi_set_bus_dependency "s_axis" "s_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 1)"
adi_set_bus_dependency "m_axis" "m_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 1)"
adi_set_ports_dependency "fifo_rd" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 2)"

# These are in the design to keep the Altera tools happy which can't handle
# uni-directional AXI interfaces. The Xilinx tools can and do a better job when
# they know that the interface is uni-directional, so disable the ports.
set dummy_axi_ports [list \
	"m_dest_axi_arvalid" \
	"m_dest_axi_arready" \
	"m_dest_axi_araddr" \
	"m_dest_axi_arlen" \
	"m_dest_axi_arsize" \
	"m_dest_axi_arburst" \
	"m_dest_axi_arcache" \
	"m_dest_axi_arprot" \
	"m_dest_axi_rready" \
	"m_dest_axi_rvalid" \
	"m_dest_axi_rresp" \
	"m_dest_axi_rdata" \
	"m_src_axi_awvalid" \
	"m_src_axi_awready" \
	"m_src_axi_awvalid" \
	"m_src_axi_awaddr" \
	"m_src_axi_awlen" \
	"m_src_axi_awsize" \
	"m_src_axi_awburst" \
	"m_src_axi_awcache" \
	"m_src_axi_awprot" \
	"m_src_axi_wvalid" \
	"m_src_axi_wready" \
	"m_src_axi_wvalid" \
	"m_src_axi_wdata" \
	"m_src_axi_wstrb" \
	"m_src_axi_wlast" \
	"m_src_axi_bready" \
	"m_src_axi_bvalid" \
	"m_src_axi_bresp" \
]

foreach p $dummy_axi_ports {
	adi_set_ports_dependency $p "0"
}

adi_add_bus "fifo_wr" "slave" \
	"analog.com:interface:fifo_wr_rtl:1.0" \
	"analog.com:interface:fifo_wr:1.0" \
	{ \
		{"fifo_wr_en" "EN"} \
		{"fifo_wr_din" "DATA"} \
		{"fifo_wr_overflow" "OVERFLOW"} \
		{"fifo_wr_sync" "SYNC"} \
		{"fifo_wr_xfer_req" "XFER_REQ"} \
	}

adi_add_bus_clock "fifo_wr_clk" "fifo_wr"

adi_set_bus_dependency "fifo_wr" "fifo_wr" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 2)"

adi_add_bus "fifo_rd" "slave" \
	"analog.com:interface:fifo_rd_rtl:1.0" \
	"analog.com:interface:fifo_rd:1.0" \
	{
		{"fifo_rd_en" "EN"} \
		{"fifo_rd_dout" "DATA"} \
		{"fifo_rd_valid" "VALID"} \
		{"fifo_rd_underflow" "UNDERFLOW"} \
	}

adi_add_bus_clock "fifo_rd_clk" "fifo_rd"

adi_set_bus_dependency "fifo_rd" "fifo_rd" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 2)"

foreach port {"m_dest_axi_aresetn" "m_src_axi_aresetn" "s_axis_valid" \
	"s_axis_data" "m_axis_ready" "fifo_wr_en" "fifo_wr_din" "fifo_rd_en"} {
	set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}

foreach port {"s_axis_user" "fifo_wr_sync"} {
	set_property DRIVER_VALUE "1" [ipx::get_ports $port]
}

ipx::save_core [ipx::current_core]
