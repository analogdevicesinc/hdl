###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_dmac
adi_ip_files axi_dmac [list \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "inc_id.vh" \
  "resp.vh" \
  "axi_dmac_ext_sync.v" \
  "axi_dmac_framelock.v" \
  "axi_dmac_burst_memory.v" \
  "axi_dmac_regmap.v" \
  "axi_dmac_regmap_request.v" \
  "axi_dmac_reset_manager.v" \
  "axi_dmac_resize_dest.v" \
  "axi_dmac_resize_src.v" \
  "axi_dmac_response_manager.v" \
  "axi_dmac_transfer.v" \
  "address_generator.v" \
  "data_mover.v" \
  "request_arb.v" \
  "request_generator.v" \
  "response_handler.v" \
  "axi_register_slice.v" \
  "dmac_2d_transfer.v" \
  "dmac_sg.v" \
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
  "axi_dmac_pkg_sv.ttcl" \
  "bd/bd.tcl" ]

set_property used_in_simulation false [get_files ./bd/bd.tcl]
set_property used_in_synthesis false [get_files ./bd/bd.tcl]

adi_ip_properties axi_dmac
adi_ip_infer_mm_interfaces axi_dmac
adi_ip_ttcl axi_dmac "axi_dmac_constr.ttcl"
adi_ip_sim_ttcl axi_dmac "axi_dmac_pkg_sv.ttcl"
adi_ip_bd axi_dmac "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_dmac} [ipx::current_core]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property display_name "ADI AXI DMA Controller" [ipx::current_core]
set_property description "ADI AXI DMA Controller" [ipx::current_core]

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"} \
    {"s_axis_strb" "TSTRB"} \
    {"s_axis_keep" "TKEEP"} \
    {"s_axis_user" "TUSER"} \
    {"s_axis_id" "TID"} \
    {"s_axis_dest" "TDEST"} \
    {"s_axis_last" "TLAST"}]
adi_add_bus_clock "s_axis_aclk" "s_axis"

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"} \
    {"m_axis_strb" "TSTRB"} \
    {"m_axis_keep" "TKEEP"} \
    {"m_axis_user" "TUSER"} \
    {"m_axis_id" "TID"} \
    {"m_axis_dest" "TDEST"} \
    {"m_axis_last" "TLAST"}]
adi_add_bus_clock "m_axis_aclk" "m_axis"

adi_set_bus_dependency "m_src_axi" "m_src_axi" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 0)"
adi_set_bus_dependency "m_dest_axi" "m_dest_axi" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 0)"
adi_set_bus_dependency "m_sg_axi" "m_sg_axi" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_SG_TRANSFER')) = 1)"
adi_set_bus_dependency "s_axis" "s_axis" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 1)"
adi_set_bus_dependency "m_axis" "m_axis" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 1)"
adi_set_ports_dependency "sync" \
  "(spirit:decode(id('MODELPARAM_VALUE.SYNC_TRANSFER_START')) = 1) && \
   (spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) != 1 || \
    spirit:decode(id('MODELPARAM_VALUE.AXIS_TUSER_SYNC')) != 1)"
adi_set_ports_dependency "dest_diag_level_bursts" \
  "(spirit:decode(id('MODELPARAM_VALUE.ENABLE_DIAGNOSTICS_IF')) = 1)"

# These are in the design to keep the Intel tools happy which can't handle
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
  "m_src_axi_awaddr" \
  "m_src_axi_awlen" \
  "m_src_axi_awsize" \
  "m_src_axi_awburst" \
  "m_src_axi_awcache" \
  "m_src_axi_awprot" \
  "m_src_axi_wvalid" \
  "m_src_axi_wready" \
  "m_src_axi_wdata" \
  "m_src_axi_wstrb" \
  "m_src_axi_wlast" \
  "m_src_axi_bready" \
  "m_src_axi_bvalid" \
  "m_src_axi_bresp" \
  "m_sg_axi_awvalid" \
  "m_sg_axi_awready" \
  "m_sg_axi_awaddr" \
  "m_sg_axi_awlen" \
  "m_sg_axi_awsize" \
  "m_sg_axi_awburst" \
  "m_sg_axi_awcache" \
  "m_sg_axi_awprot" \
  "m_sg_axi_wvalid" \
  "m_sg_axi_wready" \
  "m_sg_axi_wdata" \
  "m_sg_axi_wstrb" \
  "m_sg_axi_wlast" \
  "m_sg_axi_bready" \
  "m_sg_axi_bvalid" \
  "m_sg_axi_bresp" \
]

# These are in the design to keep the Intel tools happy which require
# certain signals in AXI3 mode even if these are defined as optinal in the standard.
lappend dummy_axi_ports \
  "m_dest_axi_awid" \
  "m_dest_axi_awlock" \
  "m_dest_axi_wid" \
  "m_dest_axi_bid" \
  "m_dest_axi_arid" \
  "m_dest_axi_arlock" \
  "m_dest_axi_rid" \
  "m_dest_axi_rlast" \
  "m_src_axi_arid" \
  "m_src_axi_arlock" \
  "m_src_axi_rid" \
  "m_src_axi_awid" \
  "m_src_axi_awlock" \
  "m_src_axi_wid" \
  "m_src_axi_bid" \
  "m_sg_axi_arid" \
  "m_sg_axi_arlock" \
  "m_sg_axi_rid" \
  "m_sg_axi_awid" \
  "m_sg_axi_awlock" \
  "m_sg_axi_wid" \
  "m_sg_axi_bid"


foreach p $dummy_axi_ports {
  adi_set_ports_dependency $p "false"
}

set_property master_address_space_ref m_dest_axi \
  [ipx::get_bus_interfaces m_dest_axi \
  -of_objects [ipx::current_core]]
set_property master_address_space_ref m_src_axi \
  [ipx::get_bus_interfaces m_src_axi \
  -of_objects [ipx::current_core]]
set_property master_address_space_ref m_sg_axi \
  [ipx::get_bus_interfaces m_sg_axi \
  -of_objects [ipx::current_core]]

adi_add_bus "fifo_wr" "slave" \
  "analog.com:interface:fifo_wr_rtl:1.0" \
  "analog.com:interface:fifo_wr:1.0" \
  { \
    {"fifo_wr_en" "EN"} \
    {"fifo_wr_din" "DATA"} \
    {"fifo_wr_overflow" "OVERFLOW"} \
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

foreach port {"m_dest_axi_aresetn" "m_src_axi_aresetn" "m_sg_axi_aresetn" \
  "s_axis_valid" "s_axis_data" "s_axis_last" "m_axis_ready" \
  "fifo_wr_en" "fifo_wr_din" "fifo_rd_en"} {
  set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}

foreach port {"s_axis_user" "sync"} {
  set_property DRIVER_VALUE "1" [ipx::get_ports $port]
}

# Infer interrupt
ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

adi_if_infer_bus analog.com:interface:if_framelock master m_framelock [list \
  "s2m_framelock       m_frame_in" \
  "s2m_framelock_valid m_frame_in_valid" \
  "m2s_framelock       m_frame_out" \
  "m2s_framelock_valid m_frame_out_valid" \
]

adi_set_bus_dependency "m_framelock" "m_framelock" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) != 0 and \
    spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) = 0 and \
    spirit:decode(id('MODELPARAM_VALUE.FRAMELOCK')) = 1)"

adi_if_infer_bus analog.com:interface:if_framelock slave s_framelock [list \
  "m2s_framelock       s_frame_in" \
  "m2s_framelock_valid s_frame_in_valid" \
  "s2m_framelock       s_frame_out" \
  "s2m_framelock_valid s_frame_out_valid" \
]

adi_set_bus_dependency "s_framelock" "s_framelock" \
  "(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_SRC')) = 0 and \
    spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE_DEST')) != 0 and \
    spirit:decode(id('MODELPARAM_VALUE.FRAMELOCK')) = 1)"

adi_set_ports_dependency "src_ext_sync" \
  "spirit:decode(id('MODELPARAM_VALUE.USE_EXT_SYNC')) = 1"
adi_set_ports_dependency "dest_ext_sync" \
  "spirit:decode(id('MODELPARAM_VALUE.USE_EXT_SYNC')) = 1"

set cc [ipx::current_core]

# The core does not issue narrow bursts
foreach intf [ipx::get_bus_interfaces m_*_axi -of_objects $cc] {
  set para [ipx::add_bus_parameter SUPPORTS_NARROW_BURST $intf]
  set_property "VALUE" "0" $para
}

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "2 4 8 16 32" \
] [ipx::get_user_parameters FIFO_SIZE -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "32" \
] [ipx::get_user_parameters DMA_LENGTH_WIDTH -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "16" \
  "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters DMA_AXI_ADDR_WIDTH -of_objects $cc]

foreach {k v} { \
  "ASYNC_CLK_REQ_SRC" "true" \
  "ASYNC_CLK_SRC_DEST" "true" \
  "ASYNC_CLK_DEST_REQ" "true" \
  "ASYNC_CLK_REQ_SG" "true" \
  "ASYNC_CLK_SRC_SG" "true" \
  "ASYNC_CLK_DEST_SG" "true" \
  "CYCLIC" "false" \
  "DMA_SG_TRANSFER" "false" \
  "DMA_2D_TRANSFER" "false" \
  "FRAMELOCK" "false" \
  "SYNC_TRANSFER_START" "false" \
  "AXI_SLICE_SRC" "false" \
  "AXI_SLICE_DEST" "false" \
  "AXIS_TUSER_SYNC" "true" \
  "DISABLE_DEBUG_REGISTERS" "false" \
  "ENABLE_DIAGNOSTICS_IF" "false" \
  "CACHE_COHERENT" "false" \
  "USE_EXT_SYNC" "false" \
  "AUTORUN" "false" \
  } { \
  set_property -dict [list \
    "value_format" "bool" \
    "value" $v \
  ] [ipx::get_user_parameters $k -of_objects $cc]
  set_property -dict [list \
    "value_format" "bool" \
    "value" $v \
  ] [ipx::get_hdl_parameters $k -of_objects $cc]
}

foreach dir {"SRC" "DEST"} {
  set_property -dict [list \
    "value_validation_type" "list" \
    "value_validation_list" "16 32 64 128 256 512 1024 2048" \
  ] [ipx::get_user_parameters DMA_DATA_WIDTH_${dir} -of_objects $cc]

  set_property -dict [list \
    "value_validation_type" "pairs" \
    "value_validation_pairs" {"AXI3" "1" "AXI4" "0"} \
    "enablement_tcl_expr" "\$DMA_TYPE_${dir} == 0" \
  ] [ipx::get_user_parameters DMA_AXI_PROTOCOL_${dir} -of_objects $cc]

  set_property -dict [list \
    "value_validation_type" "pairs" \
    "value_validation_pairs" { \
      "Memory-Mapped AXI" "0" \
      "Streaming AXI" "1" \
      "FIFO Interface" "2" \
    } \
  ] [ipx::get_user_parameters DMA_TYPE_${dir} -of_objects $cc]
}

set_property -dict [list \
  "enablement_tcl_expr" "\$DMA_2D_TRANSFER == true" \
  "value_validation_type" "pairs" \
  "value_validation_pairs" {"End of Frame" "0" "End of Line" "1"} \
] \
[ipx::get_user_parameters DMA_2D_TLAST_MODE -of_objects $cc]

set_property -dict [list \
  "enablement_tcl_expr" "\$DMA_2D_TRANSFER == true && \$CYCLIC == true" \
] \
[ipx::get_user_parameters FRAMELOCK -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" {\
    "4 buffers"  "2" \
    "8 buffers"  "3" \
    "16 buffers" "4" \
    "32 buffers" "5" \
  } \
] \
[ipx::get_user_parameters MAX_NUM_FRAMES_WIDTH -of_objects $cc]

# Set up page layout
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]
set_property display_name {General settings} $page0
set g [ipgui::add_group -name {DMA Endpoint Configuration} -component $cc \
  -parent $page0 -display_name {DMA Endpoint Configuration} \
  -layout "horizontal"]
set src_group [ipgui::add_group -name {Source} -component $cc -parent $g \
  -display_name {Source}]
set dest_group [ipgui::add_group -name {Destination} -component $cc -parent $g \
  -display_name {Destination}]
set sg_group [ipgui::add_group -name {Scatter-Gather} -component $cc -parent $g \
  -display_name {Scatter-Gather}]

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
    "tooltip" "Bus Width: For Memory-Mapped interface the valid range is 32-1024 bits" \
  ] $p

  set p [ipgui::get_guiparamspec -name "AXI_SLICE_${dir}" -component $cc]
  ipgui::move_param -component $cc -order 3 $p -parent $group
  set_property -dict [list \
    "display_name" "Insert Register Slice" \
  ] $p
}

set p [ipgui::get_guiparamspec -name "AXIS_TUSER_SYNC" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $src_group
set_property -dict [list \
  "tooltip" "Transfer Start Synchronization on TUSER"
] $p
set_property -dict [list \
  "display_name" "TUSER Synchronization" \
  "enablement_tcl_expr" "\$DMA_TYPE_SRC == 1 && \$SYNC_TRANSFER_START == true" \
  "enablement_value" "true" \
] [ipx::get_user_parameters AXIS_TUSER_SYNC -of_objects $cc]

set p [ipgui::get_guiparamspec -name "DMA_AXI_PROTOCOL_SG" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $sg_group
set_property -dict [list \
  "display_name" "AXI Protocol" \
] $p
set_property -dict [list \
  "enablement_tcl_expr" "\$DMA_SG_TRANSFER == true" \
] [ipx::get_user_parameters DMA_AXI_PROTOCOL_SG -of_objects $cc]
set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" {"AXI3" "1" "AXI4" "0"} \
] [ipx::get_user_parameters DMA_AXI_PROTOCOL_SG -of_objects $cc]

set p [ipgui::get_guiparamspec -name "DMA_DATA_WIDTH_SG" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $sg_group
set_property -dict [list \
  "display_name" "Bus Width" \
] $p
set_property -dict [list \
  "enablement_tcl_expr" "\$DMA_SG_TRANSFER == true" \
] [ipx::get_user_parameters DMA_DATA_WIDTH_SG -of_objects $cc]
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "64" \
] [ipx::get_user_parameters DMA_DATA_WIDTH_SG -of_objects $cc]

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
  "widget" "comboBox" \
  "display_name" "Store-and-Forward Memory Size (In Bursts)" \
] $p

set p [ipgui::get_guiparamspec -name "MAX_BYTES_PER_BURST" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $general_group
set_property -dict [list \
  "display_name" "Maximum Bytes per Burst" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_AXI_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $general_group
set_property -dict [list \
  "display_name" "DMA AXI Address Width" \
] $p

set p [ipgui::get_guiparamspec -name "AXI_AXCACHE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $general_group
set_property -dict [list \
  "display_name" "ARCACHE/AWCACHE" \
] $p
set_property -dict [list \
  "enablement_tcl_expr" "\$CACHE_COHERENT == true" \
] [ipx::get_user_parameters AXI_AXCACHE -of_objects $cc]

set p [ipgui::get_guiparamspec -name "AXI_AXPROT" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $general_group
set_property -dict [list \
  "display_name" "ARPROT/AWPROT" \
] $p
set_property -dict [list \
  "enablement_tcl_expr" "\$CACHE_COHERENT == true" \
] [ipx::get_user_parameters AXI_AXPROT -of_objects $cc]

set feature_group [ipgui::add_group -name "Features" -component $cc \
  -parent $page0 -display_name "Features"]

set p [ipgui::get_guiparamspec -name "CYCLIC" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $feature_group
set_property -dict [list \
  "display_name" "Cyclic Transfer Support" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_SG_TRANSFER" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $feature_group
set_property -dict [list \
  "display_name" "SG Transfer Support" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_2D_TRANSFER" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $feature_group
set_property -dict [list \
  "display_name" "2D Transfer Support" \
] $p

set p [ipgui::get_guiparamspec -name "SYNC_TRANSFER_START" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $feature_group
set_property -dict [list \
  "display_name" "Transfer Start Synchronization Support" \
] $p

set p [ipgui::get_guiparamspec -name "CACHE_COHERENT" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $feature_group
set_property -dict [list \
  "tooltip" "Assume DMA ports ensure cache coherence (e.g. Ultrascale HPC port)" \
] $p
set_property -dict [list \
  "display_name" "Cache Coherent" \
  "enablement_tcl_expr" "\$DMA_TYPE_SRC == 0 || \$DMA_TYPE_DEST == 0" \
] [ipx::get_user_parameters CACHE_COHERENT -of_objects $cc]

set feature_group_2d [ipgui::add_group -name "2D Settings" -component $cc \
  -parent $feature_group -display_name "2D Settings"]

set p [ipgui::get_guiparamspec -name "DMA_2D_TLAST_MODE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $feature_group_2d
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "AXIS TLAST function" \
  "tooltip" "AXI Stream TLAST port function" \
] $p

set p [ipgui::get_guiparamspec -name "FRAMELOCK" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $feature_group_2d
set_property -dict [list \
  "display_name" "Framelock Support" \
  "tooltip" "Requires Cyclic mode" \
] $p

set p [ipgui::get_guiparamspec -name "MAX_NUM_FRAMES_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $feature_group_2d
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Max Number Of Frame Buffers" \
] $p

set p [ipgui::get_guiparamspec -name "USE_EXT_SYNC" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $feature_group
set_property -dict [list \
  "display_name" "External Synchronization Support" \
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

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_REQ_SG" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $clk_group
set_property -dict [list \
  "display_name" "Request and Scatter-Gather Clock Asynchronous" \
] $p

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_SRC_SG" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $clk_group
set_property -dict [list \
  "display_name" "Source and Scatter-Gather Clock Asynchronous" \
] $p

set p [ipgui::get_guiparamspec -name "ASYNC_CLK_DEST_SG" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $clk_group
set_property -dict [list \
  "display_name" "Destination and Scatter-Gather Clock Asynchronous" \
] $p

set dbg_group [ipgui::add_group -name {Debug} -component $cc \
  -parent $page0 -display_name {Debug}]

set p [ipgui::get_guiparamspec -name "DISABLE_DEBUG_REGISTERS" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $dbg_group
set_property -dict [list \
  "display_name" "Disable Debug Registers" \
] $p

set p [ipgui::get_guiparamspec -name "ENABLE_DIAGNOSTICS_IF" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $dbg_group
set_property -dict [list \
  "display_name" "Enable Diagnostics Interface" \
] $p

ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "DMA_AXI_ADDR_WIDTH" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "AXI_ID_WIDTH_SRC" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "AXI_ID_WIDTH_DEST" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "AXI_ID_WIDTH_SG" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "ALLOW_ASYM_MEM" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "DMA_AXIS_ID_W" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "DMA_AXIS_DEST_W" -component $cc]

# add registers default values config page
set page1 [ipgui::add_page -name {Autorun settings} -component [ipx::current_core] -display_name {Autorun settings}]

set p [ipgui::get_guiparamspec -name "AUTORUN" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $page1
set_property -dict [list \
  "display_name" "Enable AutoRun mode" \
  "tooltip" "Set default register values through parameters. Allows to start a transfer after reset deassertion, without software intervention" \
] $p

set group [ipgui::add_group -name "Register Defaults" -component $cc \
  -parent $page1 -display_name "Register Defaults"]

set defaults [list \
  "AUTORUN_FLAGS"            "Flags" \
  "AUTORUN_SRC_ADDR"         "Source address" \
  "AUTORUN_DEST_ADDR"        "Destination address" \
  "AUTORUN_X_LENGTH"         "X length" \
  "AUTORUN_Y_LENGTH"         "Y length" \
  "AUTORUN_SRC_STRIDE"       "Source stride" \
  "AUTORUN_DEST_STRIDE"      "Destination stride" \
  "AUTORUN_SG_ADDRESS"       "Scatter-Gather start address" \
  "AUTORUN_FRAMELOCK_CONFIG" "Framelock config" \
  "AUTORUN_FRAMELOCK_STRIDE" "Framelock stride" \
]
set order 0
foreach {param desc} $defaults {
  set_property -dict [list \
    "enablement_tcl_expr" "\$AUTORUN == true" \
    "value" "0x00000000" \
    "value_bit_string_length" "32" \
    "value_format" "bitString" \
  ] [ipx::get_user_parameters $param -of_objects $cc]

  set_property -dict [list \
    "value" "0x00000000" \
    "value_bit_string_length" "32" \
    "value_format" "bitString" \
  ] [ipx::get_hdl_parameters $param -of_objects $cc]

  set p [ipgui::get_guiparamspec -name $param -component $cc]
  set_property -dict [list \
    "display_name" $desc \
    "tooltip" "\[$p\] $desc" \
    "widget" "hexEdit" \
  ] $p

  ipgui::move_param $p -component $cc -order $order -parent $group

  incr order
}

ipx::create_xgui_files [ipx::current_core]
ipx::save_core $cc
