###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

set mod_data [ipl::getmod ./axi_dmac.v]
set ip $::ipl::ip

set ip [ipl::addports -ip $ip -mod_data $mod_data]

set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
set ip [ipl::general -ip $ip -display_name "AXI_DMA ADI"]
set ip [ipl::general -ip $ip -supported_products {*}]
set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
set ip [ipl::general -ip $ip -href "https://analogdevicesinc.github.io/hdl/library/axi_dmac/index.html"]
set ip [ipl::general  -vendor "analog.com" \
    -library "ip" \
    -version "1.0" \
    -category "ADI" \
    -keywords "ADI IP" \
    -min_radiant_version "2022.1" \
    -max_radiant_version "2023.2" \
    -min_esi_version "2022.1" -ip $ip]

set ip [ipl::mmap -ip $ip \
    -name "axi_dmac_mem_map" \
    -description "axi_dmac_mem_map" \
    -baseAddress 0 \
    -range 65536 \
    -width 32]
set ip [ipl::addressp -ip $ip \
    -name "m_dest_axi_aspace" \
    -range 0x100000000 \
    -width 32]
set ip [ipl::addressp -ip $ip \
    -name "m_src_axi_aspace" \
    -range 0x100000000 \
    -width 32]
set ip [ipl::addressp -ip $ip \
    -name "m_sg_axi_aspace" \
    -range 0x100000000 \
    -width 32]

set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
    -exept_pl [list s_axi_aclk s_axi_aresetn] \
    -display_name s_axi \
    -description s_axi \
    -master_slave slave \
    -mmap_ref axi_dmac_mem_map \
    -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]
set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_dest_axi \
    -exept_pl [list m_dest_axi_aclk m_dest_axi_aresetn] \
    -iname m_dest_axi \
    -display_name m_dest_axi \
    -description m_dest_axi \
    -master_slave master \
    -aspace_ref m_dest_axi_aspace \
    -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]
set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_src_axi \
    -exept_pl [list m_src_axi_aclk m_src_axi_aresetn] \
    -iname m_src_axi \
    -display_name m_src_axi \
    -description m_src_axi \
    -master_slave master \
    -aspace_ref m_src_axi_aspace \
    -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]
set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_sg_axi \
    -exept_pl [list m_sg_axi_aclk m_sg_axi_aresetn] \
    -iname m_sg_axi \
    -display_name m_sg_axi \
    -description m_sg_axi \
    -master_slave master \
    -aspace_ref m_sg_axi_aspace \
    -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]

set if [ipl::createcif -vendor analog.com \
    -library ADI \
    -name fifo_wr \
    -version 1.0 \
    -directConnection true \
    -isAddressable false \
    -description "ADI fifo wr interface" \
    -ports {
        {-n DATA -d out -p required}
        {-n EN -d out -p required -w 1}
        {-n OVERFLOW -w 1 -p optional -d in}
        {-n SYNC -p optional -w 1 -d out}
        {-n XFER_REQ -p optional -w 1 -d in}
    }]
ipl::genif $if

set ip [ipl::addif -ip $ip \
    -iname fifo_wr \
    -display_name fifo_wr \
    -description fifo_wr \
    -master_slave slave \
    -portmap { \
        {"fifo_wr_en" "EN"} \
        {"fifo_wr_din" "DATA"} \
        {"fifo_wr_overflow" "OVERFLOW"} \
        {"fifo_wr_sync" "SYNC"} \
        {"fifo_wr_xfer_req" "XFER_REQ"} \
    } \
    -vendor analog.com -library ADI -name fifo_wr -version 1.0]

set if [ipl::createcif -vendor analog.com \
    -library ADI \
    -name fifo_rd \
    -version 1.0 \
    -directConnection true \
    -isAddressable false \
    -description "ADI fifo rd interface" \
    -ports {
        {-n DATA -d in -p required}
        {-n EN -d out -p required -w 1}
        {-n UNDERFLOW -d in -p optional -w 1}
        {-n VALID -d in -p optional -w 1}
        {-n XFER_REQ -d in -p optional -w 1}
    }]
ipl::genif $if

set ip [ipl::addif -ip $ip \
    -iname fifo_rd \
    -display_name fifo_rd \
    -description fifo_rd \
    -master_slave slave \
    -portmap 	{
        {"fifo_rd_en" "EN"} \
        {"fifo_rd_dout" "DATA"} \
        {"fifo_rd_valid" "VALID"} \
        {"fifo_rd_underflow" "UNDERFLOW"} \
    } \
    -vendor analog.com -library ADI -name fifo_rd -version 1.0]

set ip [ipl::addif -ip $ip \
    -iname s_axis \
    -display_name s_axis \
    -description s_axis \
    -master_slave slave \
    -portmap [list {"s_axis_ready" "TREADY"} \
                    {"s_axis_valid" "TVALID"} \
                    {"s_axis_data" "TDATA"} \
                    {"s_axis_strb" "TSTRB"} \
                    {"s_axis_keep" "TKEEP"} \
                    {"s_axis_user" "TUSER"} \
                    {"s_axis_id" "TID"} \
                    {"s_axis_dest" "TDEST"} \
                    {"s_axis_last" "TLAST"}] \
    -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]
set ip [ipl::addif -ip $ip \
    -iname m_axis \
    -display_name m_axis \
    -description m_axis \
    -master_slave master \
    -portmap [list {"m_axis_ready" "TREADY"} \
                    {"m_axis_valid" "TVALID"} \
                    {"m_axis_data" "TDATA"} \
                    {"m_axis_strb" "TSTRB"} \
                    {"m_axis_keep" "TKEEP"} \
                    {"m_axis_user" "TUSER"} \
                    {"m_axis_id" "TID"} \
                    {"m_axis_dest" "TDEST"} \
                    {"m_axis_last" "TLAST"}] \
    -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]

# Do not use a port name as interface name except if you use case differences.
set ip [ipl::addif -ip $ip \
    -iname IRQ \
    -display_name IRQ \
    -description IRQ \
    -master_slave master \
    -portmap [list {"irq" "IRQ"}] \
    -vendor spiritconsortium.org -library busdef.interrupt -name interrupt -version 1.0]

set ip [ipl::addfiles -spath ./ -dpath rtl -extl {*.v *.vh} -ip $ip]
set ip [ipl::addfiles -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]
set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
    -extl {ad_rst.v
           up_axi.v
           ad_mem.v
           ad_mem_asym.v}]
set ip [ipl::addfiles -spath ../util_axis_fifo -dpath rtl -ip $ip \
    -extl {util_axis_fifo.v
            util_axis_fifo_address_generator.v}]

# source
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
    -id SYNC_TRANSFER_START \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Transfer Start Synchronization Support} \
    -options {[(True, 1), (False, 0)]} \
    -editable {not(DMA_TYPE_SRC == 0)} \
    -default 0 \
    -output_formatter nostr \
    -group1 {Source} \
    -group2 Config]
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name m_src_axi \
    -expression {not(DMA_TYPE_SRC == 0)}]
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name s_axis \
    -expression {not(DMA_TYPE_SRC == 1)}]
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name fifo_rd \
    -expression {not(DMA_TYPE_SRC == 2)}]

# destination
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name m_dest_axi \
    -expression {not(DMA_TYPE_DEST == 0)}]
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name m_axis \
    -expression {not(DMA_TYPE_DEST == 1)}]
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name fifo_wr \
    -expression {not(DMA_TYPE_DEST == 2)}]

# scatter gather
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::igiports -ip $ip \
    -mod_data $mod_data \
    -v_name m_sg_axi \
    -expression {(DMA_SG_TRANSFER == 0)}]

# general
set ip [ipl::settpar -ip $ip \
    -id ID \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Core ID} \
    -default 0 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id DMA_LENGTH_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {DMA Transfer Length Register Width} \
    -default 24 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
    -id MAX_BYTES_PER_BURST \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {Maximum Bytes per Burst} \
    -default 128 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
    -id DMA_AXI_ADDR_WIDTH \
    -type param \
    -value_type int \
    -conn_mod axi_dmac \
    -title {DMA AXI Address Width} \
    -default 32 \
    -output_formatter nostr \
    -group1 {General Configuration} \
    -group2 Config]
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::igports -ip $ip \
    -portlist {dest_diag_level_bursts} \
    -expression {(ENABLE_DIAGNOSTICS_IF == 0)}]

# hidden
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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
set ip [ipl::settpar -ip $ip \
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

ipl::genip $ip
ipl::genip $ip ./
