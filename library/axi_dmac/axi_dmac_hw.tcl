###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_dmac
set_module_property DESCRIPTION "AXI DMA Controller"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_dmac
set_module_property ELABORATION_CALLBACK axi_dmac_elaborate
set_module_property VALIDATION_CALLBACK axi_dmac_validate

# files

ad_ip_files axi_dmac [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/common/ad_mem_asym.v \
  inc_id.vh \
  resp.vh \
  axi_dmac_ext_sync.v \
  axi_dmac_framelock.v \
  axi_dmac_burst_memory.v \
  axi_dmac_regmap.v \
  axi_dmac_regmap_request.v \
  axi_dmac_reset_manager.v \
  axi_dmac_resize_dest.v \
  axi_dmac_resize_src.v \
  axi_dmac_response_manager.v \
  axi_dmac_transfer.v \
  address_generator.v \
  data_mover.v \
  request_arb.v \
  request_generator.v \
  response_handler.v \
  axi_register_slice.v \
  dmac_2d_transfer.v \
  dmac_sg.v \
  dest_axi_mm.v \
  dest_axi_stream.v \
  dest_fifo_inf.v \
  src_axi_mm.v \
  src_axi_stream.v \
  src_fifo_inf.v \
  splitter.v \
  response_generator.v \
  axi_dmac.v \
  axi_dmac_constr.sdc \
]

# Disable dual-clock RAM read-during-write behaviour warning.
set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 276027 -entity axi_dmac_burst_memory" }

# parameters

set tab_ip "General settings"
add_display_item "" $tab_ip GROUP "tab"

set group "General Configuration"
add_display_item $tab_ip $group "group"

add_parameter ID INTEGER 0
set_parameter_property ID DISPLAY_NAME "Core ID"
set_parameter_property ID HDL_PARAMETER true
set_parameter_property ID GROUP $group

add_parameter DMA_LENGTH_WIDTH INTEGER 24
set_parameter_property DMA_LENGTH_WIDTH DISPLAY_NAME "DMA Transfer Length Register Width"
set_parameter_property DMA_LENGTH_WIDTH UNITS Bits
set_parameter_property DMA_LENGTH_WIDTH HDL_PARAMETER true
set_parameter_property DMA_LENGTH_WIDTH ALLOWED_RANGES {8:32}
set_parameter_property DMA_LENGTH_WIDTH GROUP $group

add_parameter FIFO_SIZE INTEGER 8
set_parameter_property FIFO_SIZE DISPLAY_NAME "Store-and-Forward Memory Size (In Bursts)"
set_parameter_property FIFO_SIZE HDL_PARAMETER true
set_parameter_property FIFO_SIZE ALLOWED_RANGES {2 4 8 16 32}
set_parameter_property FIFO_SIZE GROUP $group

add_parameter MAX_BYTES_PER_BURST INTEGER 128
set_parameter_property MAX_BYTES_PER_BURST DISPLAY_NAME "Maximum bytes per burst"
set_parameter_property MAX_BYTES_PER_BURST HDL_PARAMETER true
set_parameter_property MAX_BYTES_PER_BURST GROUP $group

set group "Endpoint Configuration"
add_display_item $tab_ip $group "group"

add_parameter DMA_AXI_ADDR_WIDTH INTEGER 32
set_parameter_property DMA_AXI_ADDR_WIDTH DISPLAY_NAME "DMA AXI Address Width"
set_parameter_property DMA_AXI_ADDR_WIDTH UNITS Bits
set_parameter_property DMA_AXI_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property DMA_AXI_ADDR_WIDTH ALLOWED_RANGES {16:64}
set_parameter_property DMA_AXI_ADDR_WIDTH GROUP $group

add_parameter AXI_AXCACHE_AUTO BOOLEAN 1
set_parameter_property AXI_AXCACHE_AUTO DISPLAY_NAME "ARCACHE/AWCACHE Automatically Set"
set_parameter_property AXI_AXCACHE_AUTO HDL_PARAMETER false
set_parameter_property AXI_AXCACHE_AUTO GROUP $group

add_parameter AXI_AXPROT_AUTO BOOLEAN 1
set_parameter_property AXI_AXPROT_AUTO DISPLAY_NAME "ARPROT/AWPROT Automatically Set"
set_parameter_property AXI_AXPROT_AUTO HDL_PARAMETER false
set_parameter_property AXI_AXPROT_AUTO GROUP $group

add_parameter AXI_AXCACHE_MANUAL STD_LOGIC_VECTOR
set_parameter_property AXI_AXCACHE_MANUAL WIDTH 4
set_parameter_property AXI_AXCACHE_MANUAL DISPLAY_NAME "ARCACHE/AWCACHE"
set_parameter_property AXI_AXCACHE_MANUAL HDL_PARAMETER false
set_parameter_property AXI_AXCACHE_MANUAL ALLOWED_RANGES {0x0:0xF}
set_parameter_property AXI_AXCACHE_MANUAL GROUP $group

add_parameter AXI_AXPROT_MANUAL STD_LOGIC_VECTOR
set_parameter_property AXI_AXPROT_MANUAL WIDTH 3
set_parameter_property AXI_AXPROT_MANUAL DISPLAY_NAME "ARPROT/AWPROT"
set_parameter_property AXI_AXPROT_MANUAL HDL_PARAMETER false
set_parameter_property AXI_AXPROT_MANUAL ALLOWED_RANGES {0x0:0x7}
set_parameter_property AXI_AXPROT_MANUAL GROUP $group

add_parameter AXI_AXCACHE STD_LOGIC_VECTOR
set_parameter_property AXI_AXCACHE WIDTH 4
set_parameter_property AXI_AXCACHE DISPLAY_NAME "ARCACHE/AWCACHE"
set_parameter_property AXI_AXCACHE HDL_PARAMETER true
set_parameter_property AXI_AXCACHE ALLOWED_RANGES {0x0:0xF}
set_parameter_property AXI_AXCACHE DERIVED true
set_parameter_property AXI_AXCACHE GROUP $group

add_parameter AXI_AXPROT STD_LOGIC_VECTOR
set_parameter_property AXI_AXPROT WIDTH 3
set_parameter_property AXI_AXPROT DISPLAY_NAME "ARPROT/AWPROT"
set_parameter_property AXI_AXPROT HDL_PARAMETER true
set_parameter_property AXI_AXPROT ALLOWED_RANGES {0x0:0x7}
set_parameter_property AXI_AXPROT DERIVED true
set_parameter_property AXI_AXPROT GROUP $group

foreach {suffix group} { \
    "SRC" "Source" \
    "DEST" "Destination" \
  } {

  add_display_item "Endpoint Configuration" $group "group" "tab"

  add_parameter DMA_TYPE_$suffix INTEGER 0
  set_parameter_property DMA_TYPE_$suffix DISPLAY_NAME "Type"
  set_parameter_property DMA_TYPE_$suffix HDL_PARAMETER true
  set_parameter_property DMA_TYPE_$suffix ALLOWED_RANGES \
    { "0:Memory-Mapped AXI" "1:Streaming AXI" "2:FIFO Interface" }
  set_parameter_property DMA_TYPE_$suffix GROUP $group

  add_parameter  DMA_AXI_PROTOCOL_$suffix INTEGER 1
  set_parameter_property DMA_AXI_PROTOCOL_$suffix DISPLAY_NAME "AXI Protocol"
  set_parameter_property DMA_AXI_PROTOCOL_$suffix HDL_PARAMETER true
  set_parameter_property DMA_AXI_PROTOCOL_$suffix ALLOWED_RANGES { "0:AXI4" "1:AXI3" }
  set_parameter_property DMA_AXI_PROTOCOL_$suffix GROUP $group

  add_parameter DMA_DATA_WIDTH_$suffix INTEGER 64
  set_parameter_property DMA_DATA_WIDTH_$suffix DISPLAY_NAME "Bus Width"
  set_parameter_property DMA_DATA_WIDTH_$suffix UNITS Bits
  set_parameter_property DMA_DATA_WIDTH_$suffix HDL_PARAMETER true
  set_parameter_property DMA_DATA_WIDTH_$suffix ALLOWED_RANGES {16 32 64 128 256 512 1024}
  set_parameter_property DMA_DATA_WIDTH_$suffix GROUP $group

  add_parameter AXI_SLICE_$suffix INTEGER 0
  set_parameter_property AXI_SLICE_$suffix DISPLAY_NAME "Insert Register Slice"
  set_parameter_property AXI_SLICE_$suffix DISPLAY_HINT boolean
  set_parameter_property AXI_SLICE_$suffix HDL_PARAMETER true
  set_parameter_property AXI_SLICE_$suffix GROUP $group
}

add_parameter AXIS_TUSER_SYNC INTEGER 1
set_parameter_property AXIS_TUSER_SYNC DISPLAY_NAME "TUSER Synchronization"
set_parameter_property AXIS_TUSER_SYNC DESCRIPTION "Transfer Start Synchronization on TUSER"
set_parameter_property AXIS_TUSER_SYNC DISPLAY_HINT boolean
set_parameter_property AXIS_TUSER_SYNC HDL_PARAMETER true
set_parameter_property AXIS_TUSER_SYNC GROUP "Source"

# FIFO interface
set_parameter_property DMA_TYPE_SRC DEFAULT_VALUE 2

add_display_item "Endpoint Configuration" "Scatter-Gather" "group"

# Scatter-Gather interface
add_parameter DMA_AXI_PROTOCOL_SG INTEGER 1
set_parameter_property DMA_AXI_PROTOCOL_SG DISPLAY_NAME "AXI Protocol"
set_parameter_property DMA_AXI_PROTOCOL_SG HDL_PARAMETER true
set_parameter_property DMA_AXI_PROTOCOL_SG ALLOWED_RANGES { "0:AXI4" "1:AXI3" }
set_parameter_property DMA_AXI_PROTOCOL_SG VISIBLE true
set_parameter_property DMA_AXI_PROTOCOL_SG GROUP "Scatter-Gather"

add_parameter DMA_DATA_WIDTH_SG INTEGER 64
set_parameter_property DMA_DATA_WIDTH_SG DISPLAY_NAME "Bus Width"
set_parameter_property DMA_DATA_WIDTH_SG UNITS Bits
set_parameter_property DMA_DATA_WIDTH_SG HDL_PARAMETER true
set_parameter_property DMA_DATA_WIDTH_SG ALLOWED_RANGES {64}
set_parameter_property DMA_DATA_WIDTH_SG VISIBLE true
set_parameter_property DMA_DATA_WIDTH_SG GROUP "Scatter-Gather"

set group "Features"
add_display_item $tab_ip $group "group"

add_parameter CYCLIC INTEGER 1
set_parameter_property CYCLIC DISPLAY_NAME "Cyclic Transfer Support"
set_parameter_property CYCLIC DISPLAY_HINT boolean
set_parameter_property CYCLIC HDL_PARAMETER true
set_parameter_property CYCLIC GROUP $group

add_parameter DMA_SG_TRANSFER INTEGER 0
set_parameter_property DMA_SG_TRANSFER DISPLAY_NAME "SG Transfer Support"
set_parameter_property DMA_SG_TRANSFER DISPLAY_HINT boolean
set_parameter_property DMA_SG_TRANSFER HDL_PARAMETER true
set_parameter_property DMA_SG_TRANSFER GROUP $group

add_parameter DMA_2D_TRANSFER INTEGER 0
set_parameter_property DMA_2D_TRANSFER DISPLAY_NAME "2D Transfer Support"
set_parameter_property DMA_2D_TRANSFER DISPLAY_HINT boolean
set_parameter_property DMA_2D_TRANSFER HDL_PARAMETER true
set_parameter_property DMA_2D_TRANSFER GROUP $group

add_parameter SYNC_TRANSFER_START INTEGER 0
set_parameter_property SYNC_TRANSFER_START DISPLAY_NAME "Transfer Start Synchronization Support"
set_parameter_property SYNC_TRANSFER_START DISPLAY_HINT boolean
set_parameter_property SYNC_TRANSFER_START HDL_PARAMETER true
set_parameter_property SYNC_TRANSFER_START GROUP $group

add_parameter CACHE_COHERENT BOOLEAN 0
set_parameter_property CACHE_COHERENT DISPLAY_NAME "Cache Coherent"
set_parameter_property CACHE_COHERENT DESCRIPTION "Assume DMA ports ensure cache coherence"
set_parameter_property CACHE_COHERENT DISPLAY_HINT boolean
set_parameter_property CACHE_COHERENT HDL_PARAMETER true
set_parameter_property CACHE_COHERENT GROUP $group

set group_2d "2D settings"
add_display_item "Features" $group_2d "group"

add_parameter DMA_2D_TLAST_MODE INTEGER 0
set_parameter_property DMA_2D_TLAST_MODE DISPLAY_NAME "AXIS TLAST function"
set_parameter_property DMA_2D_TLAST_MODE HDL_PARAMETER true
set_parameter_property DMA_2D_TLAST_MODE ALLOWED_RANGES { "0:End of Frame" "1:End of Line" }
set_parameter_property DMA_2D_TLAST_MODE GROUP $group_2d

add_parameter FRAMELOCK INTEGER 0
set_parameter_property FRAMELOCK DISPLAY_NAME "Frame Lock Support"
set_parameter_property FRAMELOCK DISPLAY_HINT boolean
set_parameter_property FRAMELOCK HDL_PARAMETER true
set_parameter_property FRAMELOCK GROUP $group_2d

add_parameter MAX_NUM_FRAMES_WIDTH INTEGER 4
set_parameter_property MAX_NUM_FRAMES_WIDTH DISPLAY_NAME "Max Number Of Frame Buffers"
set_parameter_property MAX_NUM_FRAMES_WIDTH HDL_PARAMETER true
set_parameter_property MAX_NUM_FRAMES_WIDTH ALLOWED_RANGES {"2:4" "3:8" "4:16" "5:32"}
set_parameter_property MAX_NUM_FRAMES_WIDTH GROUP $group_2d

add_parameter USE_EXT_SYNC INTEGER 0
set_parameter_property USE_EXT_SYNC DISPLAY_NAME "External Synchronization Support"
set_parameter_property USE_EXT_SYNC DISPLAY_HINT boolean
set_parameter_property USE_EXT_SYNC HDL_PARAMETER true
set_parameter_property USE_EXT_SYNC GROUP $group

set group "Clock Domain Configuration"
add_display_item $tab_ip $group "group"

add_parameter AUTO_ASYNC_CLK BOOLEAN 1
set_parameter_property AUTO_ASYNC_CLK DISPLAY_NAME "Automatically Detect Clock Domains"
set_parameter_property AUTO_ASYNC_CLK HDL_PARAMETER false
set_parameter_property AUTO_ASYNC_CLK GROUP $group

foreach {p name} { \
    ASYNC_CLK_REQ_SRC "Request and Source" \
    ASYNC_CLK_SRC_DEST "Source and Destination" \
    ASYNC_CLK_DEST_REQ "Destination and Request" \
    ASYNC_CLK_REQ_SG "Request and Scatter-Gather" \
    ASYNC_CLK_SRC_SG "Source and Scatter-Gather" \
    ASYNC_CLK_DEST_SG "Destination and Scatter-Gather" \
  } {

  add_parameter ${p}_MANUAL INTEGER 1
  set_parameter_property ${p}_MANUAL DISPLAY_NAME [concat $name "Clock Asynchronous"]
  set_parameter_property ${p}_MANUAL DISPLAY_HINT boolean
  set_parameter_property ${p}_MANUAL HDL_PARAMETER false
  set_parameter_property ${p}_MANUAL VISIBLE false
  set_parameter_property ${p}_MANUAL GROUP $group

  add_parameter $p INTEGER 1
  set_parameter_property $p DISPLAY_NAME [concat $name "Clock Asynchronous"]
  set_parameter_property $p DISPLAY_HINT boolean
  set_parameter_property $p HDL_PARAMETER true
  set_parameter_property $p DERIVED true
  set_parameter_property $p GROUP $group
}

add_parameter CLK_DOMAIN_REQ INTEGER
set_parameter_property CLK_DOMAIN_REQ HDL_PARAMETER false
set_parameter_property CLK_DOMAIN_REQ SYSTEM_INFO {CLOCK_DOMAIN s_axi_clock}
set_parameter_property CLK_DOMAIN_REQ VISIBLE false
set_parameter_property CLK_DOMAIN_REQ GROUP $group

set src_clks { \
  {CLK_DOMAIN_SRC_AXI m_src_axi_clock} \
  {CLK_DOMAIN_SRC_SAXI if_s_axis_aclk} \
  {CLK_DOMAIN_SRC_FIFO if_fifo_wr_clk} \
}

set dest_clks { \
  {CLK_DOMAIN_DEST_AXI m_dest_axi_clock} \
  {CLK_DOMAIN_DEST_SAXI if_m_axis_aclk} \
  {CLK_DOMAIN_DEST_FIFO if_fifo_rd_clk} \
}

foreach domain [list {*}$src_clks {*}$dest_clks] {
  lassign $domain p clk
  add_parameter $p INTEGER
  set_parameter_property $p HDL_PARAMETER false
  set_parameter_property $p SYSTEM_INFO [list CLOCK_DOMAIN $clk]
  set_parameter_property $p VISIBLE false
  set_parameter_property $p GROUP $group
}

add_parameter CLK_DOMAIN_SG INTEGER
set_parameter_property CLK_DOMAIN_SG HDL_PARAMETER false
set_parameter_property CLK_DOMAIN_SG SYSTEM_INFO {CLOCK_DOMAIN m_sg_axi_clock}
set_parameter_property CLK_DOMAIN_SG VISIBLE false
set_parameter_property CLK_DOMAIN_SG GROUP $group

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 11

add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint s_axi
set_interface_property interrupt_sender associatedClock s_axi_clock
set_interface_property interrupt_sender associatedReset s_axi_reset
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1

proc axi_dmac_validate {} {
  set auto_clk [get_parameter_value AUTO_ASYNC_CLK]
  set type_src [get_parameter_value DMA_TYPE_SRC]
  set type_dest [get_parameter_value DMA_TYPE_DEST]
  set sync_start [get_parameter_value SYNC_TRANSFER_START]

  set max_burst 32768

  if {$auto_clk == true} {
    global src_clks dest_clks

    set req_domain [get_parameter_value CLK_DOMAIN_REQ]
    set src_domain [get_parameter_value [lindex $src_clks $type_src 0]]
    set dest_domain [get_parameter_value [lindex $dest_clks $type_dest 0]]
    set sg_domain [get_parameter_value CLK_DOMAIN_SG]

    if {$req_domain != 0 && $req_domain == $src_domain} {
      set_parameter_value ASYNC_CLK_REQ_SRC 0
    } else {
      set_parameter_value ASYNC_CLK_REQ_SRC 1
    }

    if {$src_domain != 0 && $src_domain == $dest_domain} {
      set_parameter_value ASYNC_CLK_SRC_DEST 0
    } else {
      set_parameter_value ASYNC_CLK_SRC_DEST 1
    }

    if {$dest_domain != 0 && $dest_domain == $req_domain} {
      set_parameter_value ASYNC_CLK_DEST_REQ 0
    } else {
      set_parameter_value ASYNC_CLK_DEST_REQ 1
    }

    if {$sg_domain != 0 && $sg_domain == $req_domain} {
      set_parameter_value ASYNC_CLK_REQ_SG 0
    } else {
      set_parameter_value ASYNC_CLK_REQ_SG 1
    }

    if {$sg_domain != 0 && $sg_domain == $src_domain} {
      set_parameter_value ASYNC_CLK_SRC_SG 0
    } else {
      set_parameter_value ASYNC_CLK_SRC_SG 1
    }

    if {$sg_domain != 0 && $sg_domain == $dest_domain} {
      set_parameter_value ASYNC_CLK_DEST_SG 0
    } else {
      set_parameter_value ASYNC_CLK_DEST_SG 1
    }
  } else {
    foreach p {ASYNC_CLK_REQ_SRC ASYNC_CLK_SRC_DEST ASYNC_CLK_DEST_REQ ASYNC_CLK_REQ_SG ASYNC_CLK_SRC_SG ASYNC_CLK_DEST_SG} {
      set_parameter_value $p [get_parameter_value ${p}_MANUAL]
    }
  }

  foreach p {ASYNC_CLK_REQ_SRC ASYNC_CLK_SRC_DEST ASYNC_CLK_DEST_REQ ASYNC_CLK_REQ_SG ASYNC_CLK_SRC_SG ASYNC_CLK_DEST_SG} {
    set_parameter_property ${p}_MANUAL VISIBLE [expr $auto_clk ? false : true]
    set_parameter_property $p VISIBLE $auto_clk
  }
  foreach suffix {SRC DEST} {
    if {[get_parameter_value DMA_TYPE_$suffix] == 0} {
      set show_axi_protocol true
      set proto [get_parameter_value DMA_AXI_PROTOCOL_$suffix]
      set width [get_parameter_value DMA_DATA_WIDTH_$suffix]
      if {$proto == 0} {
        set max_burst [expr min($max_burst, $width * 256 / 8)]
      } else {
        set max_burst [expr min($max_burst, $width * 16 / 8)]
      }
    } else {
      set show_axi_protocol false
    }
    set_parameter_property DMA_AXI_PROTOCOL_$suffix VISIBLE $show_axi_protocol
  }

  set_parameter_property MAX_BYTES_PER_BURST ALLOWED_RANGES "1:$max_burst"

  set_parameter_property AXIS_TUSER_SYNC ENABLED [expr {$type_src == 1 && $sync_start == 1} ? true : false]
  set_parameter_property AXIS_TUSER_SYNC VISIBLE [expr {$type_src == 1} ? true : false]

  set cache_coherent [get_parameter_value CACHE_COHERENT]
  set axcache_auto [get_parameter_value AXI_AXCACHE_AUTO]
  set axprot_auto [get_parameter_value AXI_AXPROT_AUTO]
  set axcache_manual [get_parameter_value AXI_AXCACHE_MANUAL]
  set axprot_manual [get_parameter_value AXI_AXPROT_MANUAL]
  set axcache_default [expr {$cache_coherent == true} ? 0xF : 0x3]
  set axprot_default [expr {$cache_coherent == true} ? 0x2 : 0x0]

  set_parameter_property AXI_AXCACHE_AUTO ENABLED $cache_coherent
  set_parameter_property AXI_AXPROT_AUTO ENABLED $cache_coherent
  set_parameter_property AXI_AXCACHE_MANUAL ENABLED $cache_coherent
  set_parameter_property AXI_AXPROT_MANUAL ENABLED $cache_coherent
  set_parameter_property AXI_AXCACHE_MANUAL VISIBLE [expr {$cache_coherent == true} ? [expr {$axcache_auto == true} ? false : true] : false]
  set_parameter_property AXI_AXPROT_MANUAL VISIBLE [expr {$cache_coherent == true} ? [expr {$axprot_auto == true} ? false : true] : false]
  set_parameter_property AXI_AXCACHE VISIBLE [expr {$cache_coherent == true} ? $axcache_auto : true]
  set_parameter_property AXI_AXPROT VISIBLE [expr {$cache_coherent == true} ? $axprot_auto : true]

  set_parameter_value AXI_AXCACHE [expr {$cache_coherent == true} ? [expr {$axcache_auto == true} ? $axcache_default : $axcache_manual] : $axcache_default]
  set_parameter_value AXI_AXPROT [expr {$cache_coherent == true} ? [expr {$axprot_auto == true} ? $axprot_default : $axprot_manual]  : $axprot_default]

  if {([get_parameter_value CYCLIC] == 0 ||
       [get_parameter_value DMA_2D_TRANSFER] == 0) &&
       [get_parameter_value FRAMELOCK] == 1 } {
    send_message error "FRAMELOCK can be set only in 2D Cyclic mode"
  }

  upvar defaults d
  foreach {p desc} $d {
    set_parameter_property $p ENABLED [get_parameter_value AUTORUN]
  }

}

# conditional interfaces

# axi4 destination/source

add_interface m_dest_axi_clock clock end
add_interface_port m_dest_axi_clock m_dest_axi_aclk clk Input 1

add_interface m_dest_axi_reset reset end
set_interface_property m_dest_axi_reset associatedClock m_dest_axi_clock
add_interface_port m_dest_axi_reset m_dest_axi_aresetn reset_n Input 1


add_interface m_src_axi_clock clock end
add_interface_port m_src_axi_clock m_src_axi_aclk clk Input 1

add_interface m_src_axi_reset reset end
set_interface_property m_src_axi_reset associatedClock m_src_axi_clock
add_interface_port m_src_axi_reset m_src_axi_aresetn reset_n Input 1

# axi4 scatter-gather

add_interface m_sg_axi_clock clock end
add_interface_port m_sg_axi_clock m_sg_axi_aclk clk Input 1

add_interface m_sg_axi_reset reset end
set_interface_property m_sg_axi_reset associatedClock m_sg_axi_clock
add_interface_port m_sg_axi_reset m_sg_axi_aresetn reset_n Input 1

# axis destination/source

ad_interface clock   m_axis_aclk       input   1                       clk
ad_interface signal  m_axis_xfer_req   output  1                       xfer_req

add_interface m_axis axi4stream start
set_interface_property m_axis associatedClock if_m_axis_aclk
set_interface_property m_axis associatedReset s_axi_reset
add_interface_port m_axis  m_axis_valid tvalid Output 1
add_interface_port m_axis  m_axis_last  tlast  Output 1
add_interface_port m_axis  m_axis_ready tready Input  1
add_interface_port m_axis  m_axis_data  tdata  Output DMA_DATA_WIDTH_DEST
add_interface_port m_axis  m_axis_user  tuser  Output 1
add_interface_port m_axis  m_axis_id    tid    Output DMA_AXIS_ID_W
add_interface_port m_axis  m_axis_dest  tdest  Output DMA_AXIS_DEST_W
add_interface_port m_axis  m_axis_strb  tstrb  Output DMA_DATA_WIDTH_DEST/8
add_interface_port m_axis  m_axis_keep  tkeep  Output DMA_DATA_WIDTH_DEST/8

ad_interface clock   s_axis_aclk       input   1                       clk
ad_interface signal  s_axis_xfer_req   output  1                       xfer_req

add_interface s_axis axi4stream end
set_interface_property s_axis associatedClock if_s_axis_aclk
set_interface_property s_axis associatedReset s_axi_reset
add_interface_port s_axis  s_axis_valid tvalid Input   1
add_interface_port s_axis  s_axis_last  tlast  Input   1
add_interface_port s_axis  s_axis_ready tready Output  1
add_interface_port s_axis  s_axis_data  tdata  Input   DMA_DATA_WIDTH_SRC
add_interface_port s_axis  s_axis_user  tuser  Input   1
add_interface_port s_axis  s_axis_id    tid    Input   DMA_AXIS_ID_W
add_interface_port s_axis  s_axis_dest  tdest  Input   DMA_AXIS_DEST_W
add_interface_port s_axis  s_axis_strb  tstrb  Input   DMA_DATA_WIDTH_SRC/8
add_interface_port s_axis  s_axis_keep  tkeep  Input   DMA_DATA_WIDTH_SRC/8

# fifo destination/source

ad_interface clock   fifo_rd_clk       input   1                       clk
ad_interface signal  fifo_rd_en        input   1                       valid
ad_interface signal  fifo_rd_valid     output  1                       valid
ad_interface signal  fifo_rd_dout      output  DMA_DATA_WIDTH_DEST     data
ad_interface signal  fifo_rd_underflow output  1                       unf
ad_interface signal  fifo_rd_xfer_req  output  1                       xfer_req

ad_interface clock   fifo_wr_clk       input   1                       clk
ad_interface signal  fifo_wr_en        input   1                       valid
ad_interface signal  fifo_wr_din       input   DMA_DATA_WIDTH_SRC      data
ad_interface signal  fifo_wr_overflow  output  1                       ovf
ad_interface signal  fifo_wr_xfer_req  output  1                       xfer_req

ad_interface signal  sync              input   1                       sync
# External synchronization interface
ad_interface signal  src_ext_sync      input   1                       src_sync
ad_interface signal  dest_ext_sync     input   1                       dest_sync

proc add_axi_master_interface {axi_type port suffix} {
  add_interface $port $axi_type start
  set_interface_property $port associatedClock ${port}_clock
  set_interface_property $port associatedReset ${port}_reset
  set_interface_property $port readIssuingCapability 1
  add_interface_port $port ${port}_awvalid awvalid Output 1
  add_interface_port $port ${port}_awaddr awaddr Output 32
  add_interface_port $port ${port}_awready awready Input 1
  add_interface_port $port ${port}_wvalid wvalid Output 1
  add_interface_port $port ${port}_wdata wdata Output DMA_DATA_WIDTH_${suffix}
  add_interface_port $port ${port}_wstrb wstrb Output DMA_DATA_WIDTH_${suffix}/8
  add_interface_port $port ${port}_wready wready Input 1
  add_interface_port $port ${port}_bvalid bvalid Input 1
  add_interface_port $port ${port}_bresp bresp Input 2
  add_interface_port $port ${port}_bready bready Output 1
  add_interface_port $port ${port}_arvalid arvalid Output 1
  add_interface_port $port ${port}_araddr araddr Output 32
  add_interface_port $port ${port}_arready arready Input 1
  add_interface_port $port ${port}_rvalid rvalid Input 1
  add_interface_port $port ${port}_rresp rresp Input 2
  add_interface_port $port ${port}_rdata rdata Input DMA_DATA_WIDTH_${suffix}
  add_interface_port $port ${port}_rready rready Output 1
  add_interface_port $port ${port}_awlen awlen Output "8-(4*DMA_AXI_PROTOCOL_${suffix})"
  add_interface_port $port ${port}_awsize awsize Output 3
  add_interface_port $port ${port}_awburst awburst Output 2
  add_interface_port $port ${port}_awcache awcache Output 4
  add_interface_port $port ${port}_awprot awprot Output 3
  add_interface_port $port ${port}_wlast wlast Output 1
  add_interface_port $port ${port}_arlen arlen Output "8-(4*DMA_AXI_PROTOCOL_${suffix})"
  add_interface_port $port ${port}_arsize arsize Output 3
  add_interface_port $port ${port}_arburst arburst Output 2
  add_interface_port $port ${port}_arcache arcache Output 4
  add_interface_port $port ${port}_arprot arprot Output 3
  # Some signals are mandatory in Intel's implementation of AXI3
  # awid, awlock, wid, bid, arid, arlock, rid, rlast
  # Hide them in AXI4
  add_interface_port $port ${port}_awid awid Output 1
  add_interface_port $port ${port}_awlock awlock Output "1+DMA_AXI_PROTOCOL_${suffix}"
  add_interface_port $port ${port}_wid wid Output 1
  add_interface_port $port ${port}_arid arid Output 1
  add_interface_port $port ${port}_arlock arlock Output "1+DMA_AXI_PROTOCOL_${suffix}"
  add_interface_port $port ${port}_rid rid Input 1
  add_interface_port $port ${port}_bid bid Input 1
  add_interface_port $port ${port}_rlast rlast Input 1
  if {$axi_type == "axi4"} {
    set_port_property ${port}_awid TERMINATION true
    set_port_property ${port}_awlock TERMINATION true
    set_port_property ${port}_wid TERMINATION true
    set_port_property ${port}_arid TERMINATION true
    set_port_property ${port}_arlock TERMINATION true
    set_port_property ${port}_rid TERMINATION true
    set_port_property ${port}_bid TERMINATION true
    if {$port == "m_dest_axi"} {
      set_port_property ${port}_rlast TERMINATION true
    }
  }
}
proc axi_dmac_elaborate {} {
  set fifo_size [get_parameter_value FIFO_SIZE]
  set disabled_intfs {}

  # add axi3 or axi4 interface depending on user selection
  foreach {suffix port} {SRC m_src_axi DEST m_dest_axi SG m_sg_axi} {
    if {[get_parameter_value DMA_AXI_PROTOCOL_${suffix}] == 0} {
      set axi_type axi4
    } else {
      set axi_type axi
    }
    add_axi_master_interface $axi_type $port $suffix
  }

  # axi4 destination/source

  if {[get_parameter_value DMA_TYPE_DEST] == 0} {
    set_interface_property m_dest_axi writeIssuingCapability $fifo_size
    set_interface_property m_dest_axi combinedIssuingCapability $fifo_size
  } else {
    lappend disabled_intfs m_dest_axi_clock m_dest_axi_reset m_dest_axi
  }

  if {[get_parameter_value DMA_TYPE_SRC] == 0} {
    set_interface_property m_src_axi readIssuingCapability $fifo_size
    set_interface_property m_src_axi combinedIssuingCapability $fifo_size
  } else {
    lappend disabled_intfs m_src_axi_clock m_src_axi_reset m_src_axi
  }

  if {[get_parameter_value DMA_SG_TRANSFER] == 1} {
    set_interface_property m_sg_axi readIssuingCapability $fifo_size
    set_interface_property m_sg_axi combinedIssuingCapability $fifo_size
  } else {
    lappend disabled_intfs m_sg_axi_clock m_sg_axi_reset m_sg_axi
  }

  # axis destination/source
  set_display_item_property  "AXI Stream common config" VISIBLE false

  if {[get_parameter_value DMA_TYPE_DEST] != 1} {
    lappend disabled_intfs if_m_axis_aclk if_m_axis_xfer_req m_axis
  } else {
    if {[get_parameter_value HAS_AXIS_TSTRB] == 0} {
      set_port_property m_axis_strb termination true
    }
    if {[get_parameter_value HAS_AXIS_TKEEP] == 0} {
      set_port_property m_axis_keep termination true
    }
    if {[get_parameter_value HAS_AXIS_TLAST] == 0} {
      set_port_property m_axis_last termination true
    }
    if {[get_parameter_value HAS_AXIS_TID] == 0} {
      set_port_property m_axis_id termination true
    }
    if {[get_parameter_value HAS_AXIS_TDEST] == 0} {
      set_port_property m_axis_dest termination true
    }
    if {[get_parameter_value HAS_AXIS_TUSER] == 0} {
      set_port_property m_axis_user termination true
    }
    set_display_item_property  "AXI Stream common config" VISIBLE true
  }

  if {[get_parameter_value DMA_TYPE_SRC] != 1} {
    lappend disabled_intfs if_s_axis_aclk if_s_axis_xfer_req s_axis
  } else {
    if {[get_parameter_value HAS_AXIS_TSTRB] == 0} {
      set_port_property s_axis_strb termination true
      set_port_property s_axis_strb termination_value 0xFF
    }
    if {[get_parameter_value HAS_AXIS_TKEEP] == 0} {
      set_port_property s_axis_keep termination true
      set_port_property s_axis_keep termination_value 0xFF
    }
    if {[get_parameter_value HAS_AXIS_TLAST] == 0} {
      set_port_property s_axis_last termination true
      set_port_property s_axis_last termination_value 0
    }
    if {[get_parameter_value HAS_AXIS_TID] == 0} {
      set_port_property s_axis_id termination true
      set_port_property s_axis_id termination_value 0
    }
    if {[get_parameter_value HAS_AXIS_TDEST] == 0} {
      set_port_property s_axis_dest termination true
      set_port_property s_axis_dest termination_value 0
    }
    if {[get_parameter_value HAS_AXIS_TUSER] == 0} {
      if {[get_parameter_value SYNC_TRANSFER_START] == 0} {
        set_port_property s_axis_user termination true
        set_port_property s_axis_user termination_value 0
      }
    }
    set_display_item_property  "AXI Stream common config" VISIBLE true
  }

  # fifo destination/source

  if {[get_parameter_value DMA_TYPE_DEST] != 2} {
    lappend disabled_intfs \
      if_fifo_rd_clk if_fifo_rd_en if_fifo_rd_valid if_fifo_rd_dout \
      if_fifo_rd_underflow if_fifo_rd_xfer_req
  }

  if {[get_parameter_value DMA_TYPE_SRC] != 2} {
    lappend disabled_intfs \
      if_fifo_wr_clk if_fifo_wr_en if_fifo_wr_din if_fifo_wr_overflow \
      if_fifo_wr_xfer_req
  }

  if {[get_parameter_value SYNC_TRANSFER_START] == 0 || \
     ([get_parameter_value DMA_TYPE_SRC] == 1 && \
      [get_parameter_value AXIS_TUSER_SYNC] == 1)} {
    lappend disabled_intfs if_sync
  }

  if {[get_parameter_value ENABLE_DIAGNOSTICS_IF] != 1} {
    lappend disabled_intfs diagnostics_if
  }

  if {[get_parameter_value USE_EXT_SYNC] != 1} {
    lappend disabled_intfs \
      if_src_ext_sync if_dest_ext_sync
  }

  foreach intf $disabled_intfs {
    set_interface_property $intf ENABLED false
  }

  if {[get_parameter_value FRAMELOCK] == 1} {
    set_parameter_property MAX_NUM_FRAMES_WIDTH VISIBLE true

    set flock_width [get_parameter_value MAX_NUM_FRAMES_WIDTH]
    set flock_width [expr int($flock_width)]
    # MM writer is master
    if {[get_parameter_value DMA_TYPE_DEST] == 0 &&
        [get_parameter_value DMA_TYPE_SRC] != 0} {
      add_interface m_frame_lock_if conduit end
      add_interface_port m_frame_lock_if m_frame_out       m2s_flock_if       Output $flock_width
      add_interface_port m_frame_lock_if m_frame_out_valid m2s_flock_if_valid Output 1
      add_interface_port m_frame_lock_if m_frame_in        s2m_flock_if       Input  $flock_width
      add_interface_port m_frame_lock_if m_frame_in_valid  s2m_flock_if_valid Input  1
    }
    # MM reader is slave
    if {[get_parameter_value DMA_TYPE_SRC]  == 0 &&
        [get_parameter_value DMA_TYPE_DEST] != 0} {
      add_interface s_frame_lock_if conduit end
      add_interface_port s_frame_lock_if s_frame_in        m2s_flock_if       Input  $flock_width
      add_interface_port s_frame_lock_if s_frame_in_valid  m2s_flock_if_valid Input  1
      add_interface_port s_frame_lock_if s_frame_out       s2m_flock_if       Output $flock_width
      add_interface_port s_frame_lock_if s_frame_out_valid s2m_flock_if_valid Output 1
    }

  } else {
    set_parameter_property MAX_NUM_FRAMES_WIDTH VISIBLE false
  }

}

set group "Debug"
add_display_item $tab_ip $group "group"

add_parameter DISABLE_DEBUG_REGISTERS INTEGER 0
set_parameter_property DISABLE_DEBUG_REGISTERS DISPLAY_NAME "Disable debug registers"
set_parameter_property DISABLE_DEBUG_REGISTERS DISPLAY_HINT boolean
set_parameter_property DISABLE_DEBUG_REGISTERS HDL_PARAMETER false
set_parameter_property DISABLE_DEBUG_REGISTERS GROUP $group

add_parameter ENABLE_DIAGNOSTICS_IF INTEGER 0
set_parameter_property ENABLE_DIAGNOSTICS_IF DISPLAY_NAME "Enable Diagnostics Interface"
set_parameter_property ENABLE_DIAGNOSTICS_IF DISPLAY_HINT boolean
set_parameter_property ENABLE_DIAGNOSTICS_IF HDL_PARAMETER true
set_parameter_property ENABLE_DIAGNOSTICS_IF GROUP $group

add_interface diagnostics_if conduit end
add_interface_port diagnostics_if dest_diag_level_bursts dest_diag_level_bursts Output "8"

set group "AXI Stream common config"
add_display_item "Endpoint Configuration" $group "group" "tab"

add_parameter HAS_AXIS_TSTRB INTEGER 0
set_parameter_property HAS_AXIS_TSTRB DISPLAY_NAME "AXI Stream interface has TSTRB"
set_parameter_property HAS_AXIS_TSTRB DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TSTRB HDL_PARAMETER false
set_parameter_property HAS_AXIS_TSTRB GROUP $group

add_parameter HAS_AXIS_TKEEP INTEGER 0
set_parameter_property HAS_AXIS_TKEEP DISPLAY_NAME "AXI Stream interface has TKEEP"
set_parameter_property HAS_AXIS_TKEEP DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TKEEP HDL_PARAMETER false
set_parameter_property HAS_AXIS_TKEEP GROUP $group

add_parameter HAS_AXIS_TLAST INTEGER 0
set_parameter_property HAS_AXIS_TLAST DISPLAY_NAME "AXI Stream interface has TLAST"
set_parameter_property HAS_AXIS_TLAST DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TLAST HDL_PARAMETER false
set_parameter_property HAS_AXIS_TLAST GROUP $group

add_parameter HAS_AXIS_TID INTEGER 0
set_parameter_property HAS_AXIS_TID DISPLAY_NAME "AXI Stream interface has TID"
set_parameter_property HAS_AXIS_TID DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TID HDL_PARAMETER false
set_parameter_property HAS_AXIS_TID GROUP $group

add_parameter DMA_AXIS_ID_W INTEGER 8
set_parameter_property DMA_AXIS_ID_W DISPLAY_NAME "AXI Stream TID width"
set_parameter_property DMA_AXIS_ID_W HDL_PARAMETER true
set_parameter_property DMA_AXIS_ID_W GROUP $group

add_parameter HAS_AXIS_TDEST INTEGER 0
set_parameter_property HAS_AXIS_TDEST DISPLAY_NAME "AXI Stream interface has TDEST"
set_parameter_property HAS_AXIS_TDEST DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TDEST HDL_PARAMETER false
set_parameter_property HAS_AXIS_TDEST GROUP $group

add_parameter DMA_AXIS_DEST_W INTEGER 4
set_parameter_property DMA_AXIS_DEST_W DISPLAY_NAME "AXI Stream TDEST width"
set_parameter_property DMA_AXIS_DEST_W HDL_PARAMETER true
set_parameter_property DMA_AXIS_DEST_W GROUP $group

add_parameter HAS_AXIS_TUSER INTEGER 0
set_parameter_property HAS_AXIS_TUSER DISPLAY_NAME "AXI Stream interface has TUSER"
set_parameter_property HAS_AXIS_TUSER DISPLAY_HINT boolean
set_parameter_property HAS_AXIS_TUSER HDL_PARAMETER false
set_parameter_property HAS_AXIS_TUSER GROUP $group

set tab_ip "Autorun settings"
add_display_item "" $tab_ip GROUP "tab"

add_parameter AUTORUN BOOLEAN 0
set_parameter_property AUTORUN DISPLAY_NAME "Enable autorun mode"
set_parameter_property AUTORUN DISPLAY_HINT boolean
set_parameter_property AUTORUN HDL_PARAMETER true
set_parameter_property AUTORUN GROUP $tab_ip

set group "Register Defaults"
add_display_item $tab_ip $group "group"

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

foreach {p desc} $defaults {
  add_parameter $p STD_LOGIC_VECTOR
  set_parameter_property $p DISPLAY_NAME $desc
  set_parameter_property $p HDL_PARAMETER true
  set_parameter_property $p VISIBLE true
  set_parameter_property $p GROUP $group
  set_parameter_property $p WIDTH 32
}
