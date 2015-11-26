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
  "axi_dmac_constr.ttcl" \
  "bd/bd.tcl" ]

adi_ip_properties axi_dmac
adi_ip_ttcl axi_dmac "axi_dmac_constr.ttcl"
adi_ip_bd axi_dmac "bd/bd.tcl"

adi_ip_add_core_dependencies { \
	analog.com:user:util_axis_resize:1.0 \
	analog.com:user:util_axis_fifo:1.0 \
}

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
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 0)"
adi_set_bus_dependency "m_dest_axi" "m_dest_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 0)"
adi_set_bus_dependency "s_axis" "s_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 1)"
adi_set_bus_dependency "m_axis" "m_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 1)"
adi_set_ports_dependency "fifo_rd" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 2)"

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
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 2)"

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
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 2)"

foreach port {"m_dest_axi_aresetn" "m_src_axi_aresetn" "s_axis_valid" \
	"s_axis_data" "m_axis_ready" "fifo_wr_en" "fifo_wr_din" "fifo_rd_en"} {
	set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}

foreach port {"s_axis_user" "fifo_wr_sync"} {
	set_property DRIVER_VALUE "1" [ipx::get_ports $port]
}

set cc [ipx::current_core]

# The core does not issue narrow bursts
foreach intf [ipx::get_bus_interfaces m_*_axi -of_objects $cc] {
	set para [ipx::add_bus_parameter SUPPORTS_NARROW_BURST $intf]
	set_property "VALUE" "0" $para
}

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "8" \
	"value_validation_range_maximum" "32" \
	] \
	[ipx::get_user_parameters DMA_LENGTH_WIDTH -of_objects $cc]

foreach {k v} { \
		"ASYNC_CLK_REQ_SRC" "true" \
		"ASYNC_CLK_SRC_DEST" "true" \
		"ASYNC_CLK_DEST_REQ" "true" \
		"CYCLIC" "false" \
		"DMA_2D_TRANSFER" "false" \
		"SYNC_TRANSFER_START" "false" \
		"AXI_SLICE_SRC" "false" \
		"AXI_SLICE_DEST" "false" \
	} { \
	set_property -dict [list \
			"value_format" "bool" \
			"value" $v \
		] \
		[ipx::get_user_parameters $k -of_objects $cc]
	set_property -dict [list \
			"value_format" "bool" \
			"value" $v \
		] \
		[ipx::get_hdl_parameters $k -of_objects $cc]
}

set_property -dict [list \
	"enablement_tcl_expr" "\$DMA_TYPE_SRC != 0" \
] \
[ipx::get_user_parameters SYNC_TRANSFER_START -of_objects $cc]

foreach dir {"SRC" "DEST"} {
	set_property -dict [list \
		"value_validation_type" "list" \
		"value_validation_list" "16 32 64 128 256 512 1024" \
	] \
	[ipx::get_user_parameters DMA_DATA_WIDTH_${dir} -of_objects $cc]

	set_property -dict [list \
		"value_validation_type" "pairs" \
		"value_validation_pairs" {"AXI3" "1" "AXI4" "0"} \
		"enablement_tcl_expr" "\$DMA_TYPE_${dir} == 0" \
	] \
	[ipx::get_user_parameters DMA_AXI_PROTOCOL_${dir} -of_objects $cc]

	set_property -dict [list \
		"value_validation_type" "pairs" \
		"value_validation_pairs" { \
			"Memory-Mapped AXI" "0" \
			"Streaming AXI" "1" \
			"FIFO Interface" "2" \
		} \
	] \
	[ipx::get_user_parameters DMA_TYPE_${dir} -of_objects $cc]
}

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]
set g [ipgui::add_group -name {DMA Endpoint Configuration} -component $cc \
		-parent $page0 -display_name {DMA Endpoint Configuration} \
		-layout "horizontal"]
set src_group [ipgui::add_group -name {Source} -component $cc -parent $g \
		-display_name {Source}]
set dest_group [ipgui::add_group -name {Destination} -component $cc -parent $g \
		-display_name {Destination}]

foreach {dir group} [list "SRC" $src_group "DEST" $dest_group] {
	set p [ipgui::get_guiparamspec -name "DMA_TYPE_${dir}" -component $cc]
	ipgui::move_param -component $cc -order 0 $p -parent $group
	set_property -dict [list \
			"widget" "comboBox" \
			"display_name" "Type" \
		] $p

	set p [ipgui::get_guiparamspec -name "DMA_AXI_PROTOCOL_${dir}" -component $cc]
	ipgui::move_param -component $cc -order 1 $p -parent $group
	set_property -dict [list \
		"widget" "comboBox" \
		"display_name" "AXI Protocol" \
	] $p

	set p [ipgui::get_guiparamspec -name "DMA_DATA_WIDTH_${dir}" -component $cc]
	ipgui::move_param -component $cc -order 2 $p -parent $group
	set_property -dict [list \
		"display_name" "Bus Width" \
	] $p

	set p [ipgui::get_guiparamspec -name "AXI_SLICE_${dir}" -component $cc]
	ipgui::move_param -component $cc -order 3 $p -parent $group
	set_property -dict [list \
		"display_name" "Insert Register Slice" \
	] $p
}

set p [ipgui::get_guiparamspec -name "SYNC_TRANSFER_START" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $src_group
set_property -dict [list \
	"display_name" "Transfer Start Synchronization Support" \
] $p

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
		-parent $page0 -display_name "General Configuration"]

set p [ipgui::get_guiparamspec -name "ID" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $general_group
set_property -dict [list \
	"display_name" "Core ID" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_LENGTH_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $general_group
set_property -dict [list \
	"display_name" "DMA Transfer Length Register Width" \
] $p

set p [ipgui::get_guiparamspec -name "FIFO_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $general_group
set_property -dict [list \
	"display_name" "FIFO Size (In Bursts)" \
] $p

set p [ipgui::get_guiparamspec -name "MAX_BYTES_PER_BURST" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $general_group
set_property -dict [list \
	"display_name" "Maximum Bytes per Burst" \
] $p

set feature_group [ipgui::add_group -name "Features" -component $cc \
		-parent $page0 -display_name "Features"]

set p [ipgui::get_guiparamspec -name "CYCLIC" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $feature_group
set_property -dict [list \
	"display_name" "Cyclic Transfer Support" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_2D_TRANSFER" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $feature_group
set_property -dict [list \
	"display_name" "2D Transfer Support" \
] $p

set clk_group [ipgui::add_group -name {Clock Domain Configuration} -component $cc \
		-parent $page0 -display_name {Clock Domain Configuration}]

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_REQ_SRC" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $clk_group
set_property -dict [list \
	"display_name" "Request and Source Clock Asynchronous" \
] $p

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_SRC_DEST" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $clk_group
set_property -dict [list \
	"display_name" "Source and Destination Clock Asynchronous" \
] $p

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_DEST_REQ" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $clk_group
set_property -dict [list \
	"display_name" "Destination and Request Clock Asynchronous" \
] $p

ipx::create_xgui_files [ipx::current_core]
ipx::save_core $cc
