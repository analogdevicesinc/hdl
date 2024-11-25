###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::parse_module ./axi_dmac.v]
set ip $::ipl::ip

set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

set mod_name [dict get $mod_data mod_name]

set ip [ipl::general -ip $ip -display_name "AXI_DMA ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/axi_dmac/index.html"]
set ip [ipl::general \
    -vlnv "analog.com:ip:${mod_name}:1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2022.1" \
    -min_esi_version "2022.1" -ip $ip]

set ip [ipl::add_memory_map -ip $ip \
    -name "axi_dmac_mem_map" \
    -description "axi_dmac_mem_map" \
    -baseAddress 0 \
    -range 65536 \
    -width 32]
set ip [ipl::add_address_space -ip $ip \
    -name "m_dest_axi_aspace" \
    -range 0x100000000 \
    -width 32]
set ip [ipl::add_address_space -ip $ip \
    -name "m_src_axi_aspace" \
    -range 0x100000000 \
    -width 32]
set ip [ipl::add_address_space -ip $ip \
    -name "m_sg_axi_aspace" \
    -range 0x100000000 \
    -width 32]

set ip [ipl::add_axi_interfaces -ip $ip -mod_data $mod_data]

set ip [ipl::add_interface -ip $ip \
    -inst_name fifo_wr \
    -display_name fifo_wr \
    -description fifo_wr \
    -master_slave slave \
    -portmap { \
        {"fifo_wr_en" "EN"} \
        {"fifo_wr_din" "DATA"} \
        {"fifo_wr_overflow" "OVERFLOW"} \
        {"fifo_wr_xfer_req" "XFER_REQ"} \
    } \
    -vlnv {analog.com:ADI:fifo_wr:1.0}]

set ip [ipl::add_interface -ip $ip \
    -inst_name fifo_rd \
    -display_name fifo_rd \
    -description fifo_rd \
    -master_slave slave \
    -portmap 	{
        {"fifo_rd_en" "EN"} \
        {"fifo_rd_dout" "DATA"} \
        {"fifo_rd_valid" "VALID"} \
        {"fifo_rd_underflow" "UNDERFLOW"} \
    } \
    -vlnv {analog.com:ADI:fifo_rd:1.0}]

# Do not use a port name as interface name except if you use case differences.
set ip [ipl::add_interface -ip $ip \
    -inst_name IRQ \
    -display_name IRQ \
    -description IRQ \
    -master_slave master \
    -portmap [list {"irq" "IRQ"}] \
    -vlnv {spiritconsortium.org:busdef.interrupt:interrupt:1.0}]

set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
    "$ad_hdl_dir/library/common/ad_mem_asym.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "inc_id.vh" \
    "resp.vh" \
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
    "../util_axis_fifo/util_axis_fifo.v" \
    "../util_axis_fifo/util_axis_fifo_address_generator.v" \
    "../util_cdc/sync_bits.v" \
    "../util_cdc/sync_event.v" \
    "../util_cdc/sync_gray.v" ]]

# source
set ip [ipl::set_parameter -ip $ip \
    -id DMA_TYPE_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Type} \
    -options {[('Memory-Mapped AXI', 0), ('Streaming AXI', 1), ('FIFO Interface', 2)]} \
    -default 2 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_AXI_PROTOCOL_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {AXI Protocol} \
    -options {[('AXI4', 0), ('AXI3', 1)]} \
    -editable {(DMA_TYPE_SRC == 0)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_DATA_WIDTH_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Bus Width} \
    -options {[16, 32, 64, 128, 256, 512, 1024, 2048]} \
    -default 64 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id AXI_SLICE_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Insert Register Slice} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id AXIS_TUSER_SYNC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {TUSER Synchronization} \
    -options {[(True, 1), (False, 0)]} \
    -editable {(DMA_TYPE_SRC == 1 and SYNC_TRANSFER_START == 1)} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix m_src_axi \
    -expression {not(DMA_TYPE_SRC == 0)}]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix s_axis \
    -expression {not(DMA_TYPE_SRC == 1)}]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix fifo_rd \
    -expression {not(DMA_TYPE_SRC == 2)}]

# destination
set ip [ipl::set_parameter -ip $ip \
    -id DMA_TYPE_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Type} \
    -default 2 \
    -options {[('Memory-Mapped AXI', 0), ('Streaming AXI', 1), ('FIFO Interface', 2)]} \
    -output_formatter nostr \
    -group1 {Destination} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_AXI_PROTOCOL_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {AXI Protocol} \
    -options {[('AXI4', 0), ('AXI3', 1)]} \
    -editable {(DMA_TYPE_DEST == 0)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Destination} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_DATA_WIDTH_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Bus Width} \
    -options {[16, 32, 64, 128, 256, 512, 1024, 2048]} \
    -default 64 \
    -output_formatter nostr \
    -group1 {Destination} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id AXI_SLICE_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Insert Register Slice} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Destination} \
    -group2 Config]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix m_dest_axi \
    -expression {not(DMA_TYPE_DEST == 0)}]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix m_axis \
    -expression {not(DMA_TYPE_DEST == 1)}]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix fifo_wr \
    -expression {not(DMA_TYPE_DEST == 2)}]
set ip [ipl::ignore_ports -ip $ip \
    -portlist {sync} \
    -expression {not((SYNC_TRANSFER_START == 1) and  (DMA_TYPE_SRC != 1 or AXIS_TUSER_SYNC != 1))}]

# scatter gather
set ip [ipl::set_parameter -ip $ip \
    -id DMA_AXI_PROTOCOL_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {AXI Protocol} \
    -editable {(DMA_SG_TRANSFER == 1)} \
    -options {[('AXI4', 0), ('AXI3', 1)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Scatter-Gather} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_DATA_WIDTH_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Bus Width} \
    -editable {(DMA_SG_TRANSFER == 1)} \
    -options {[64]} \
    -default 64 \
    -output_formatter nostr \
    -group1 {Scatter-Gather} \
    -group2 Config]
set ip [ipl::ignore_ports_by_prefix -ip $ip \
    -mod_data $mod_data \
    -v_prefix m_sg_axi \
    -expression {(DMA_SG_TRANSFER == 0)}]

# general
set ip [ipl::set_parameter -ip $ip \
    -id ID \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Core ID} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_LENGTH_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {DMA Transfer Length Register Width} \
    -default 24 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id FIFO_SIZE \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Store-and-Forward Memory Size (In Bursts)} \
    -options {[2, 4, 8, 16, 32]} \
    -default 8 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id MAX_BYTES_PER_BURST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Maximum Bytes per Burst} \
    -default 128 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_AXI_ADDR_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {DMA AXI Address Width} \
    -default 32 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id AXI_AXCACHE \
    -type param \
    -value_type string \
    -conn_mod axi_dmac \
    -title {ARCACHE/AWCACHE} \
    -default 4'b0011 \
    -output_formatter nostr \
    -editable {(CACHE_COHERENT == 1)} \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id AXI_AXPROT \
    -type param \
    -value_type string \
    -conn_mod axi_dmac \
    -title {ARPROT/AWPROT} \
    -default 3'b000 \
    -output_formatter nostr \
    -editable {(CACHE_COHERENT == 1)} \
    -group1 {General Configuration} \
    -group2 Config]

# features
set ip [ipl::set_parameter -ip $ip \
    -id CYCLIC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Cyclic Transfer Support} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Features} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_SG_TRANSFER \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {SG Transfer Support} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Features} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id DMA_2D_TRANSFER \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {2D Transfer Support} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Features} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id SYNC_TRANSFER_START \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Transfer Start Synchronization Support} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Features} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id CACHE_COHERENT \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Cache Coherent} \
    -options {[(True, 1), (False, 0)]} \
    -editable {(DMA_TYPE_SRC == 0 or DMA_TYPE_DEST == 0)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Features} \
    -group2 Config]

# clock domain configuration
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_REQ_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Request and Source Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_SRC_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Source and Destination Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_DEST_REQ \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Destination and Request Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_REQ_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Request and Scatter-Gather Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_SRC_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Source and Scatter-Gather Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ASYNC_CLK_DEST_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Destination and Scatter-Gather Clock Asynchronous} \
    -options {[(True, 1), (False, 0)]} \
    -default 1 \
    -output_formatter nostr \
    -group1 {Clock Domain Configuration} \
    -group2 Config]

# debug
set ip [ipl::set_parameter -ip $ip \
    -id DISABLE_DEBUG_REGISTERS \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Disable Debug Registers} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Debug} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -id ENABLE_DIAGNOSTICS_IF \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Enable Diagnostics Interface} \
    -options {[(True, 1), (False, 0)]} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Debug} \
    -group2 Config]
set ip [ipl::ignore_ports -ip $ip \
    -portlist {dest_diag_level_bursts} \
    -expression {(ENABLE_DIAGNOSTICS_IF == 0)}]

# hidden
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id AXI_ID_WIDTH_SRC \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title AXI_ID_WIDTH_SRC \
    -default 1 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id AXI_ID_WIDTH_DEST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title AXI_ID_WIDTH_DEST \
    -default 1 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id AXI_ID_WIDTH_SG \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title AXI_ID_WIDTH_SG \
    -default 1 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id DMA_AXIS_ID_W \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title DMA_AXIS_ID_W \
    -default 8 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id DMA_AXIS_DEST_W \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title DMA_AXIS_DEST_W \
    -default 4 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]
set ip [ipl::set_parameter -ip $ip \
    -hidden True \
    -id ALLOW_ASYM_MEM \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title ALLOW_ASYM_MEM \
    -default 0 \
    -output_formatter nostr \
    -group1 {Hidden} \
    -group2 Config]

ipl::generate_ip $ip
