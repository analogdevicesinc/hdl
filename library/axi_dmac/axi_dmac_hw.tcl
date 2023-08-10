###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

set group "General Configuration"

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

add_parameter DMA_AXI_ADDR_WIDTH INTEGER 32
set_parameter_property DMA_AXI_ADDR_WIDTH DISPLAY_NAME "DMA AXI Address Width"
set_parameter_property DMA_AXI_ADDR_WIDTH UNITS Bits
set_parameter_property DMA_AXI_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property DMA_AXI_ADDR_WIDTH ALLOWED_RANGES {16:64}
set_parameter_property DMA_AXI_ADDR_WIDTH GROUP $group

foreach {suffix group} { \
    "SRC" "Source" \
    "DEST" "Destination" \
  } {

  add_display_item "Endpoint Configuration" $group "group"

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

# FIFO interface
set_parameter_property DMA_TYPE_SRC DEFAULT_VALUE 2

# Scatter-Gather interface
add_parameter DMA_AXI_PROTOCOL_SG INTEGER 1
set_parameter_property DMA_AXI_PROTOCOL_SG DISPLAY_NAME "AXI Protocol"
set_parameter_property DMA_AXI_PROTOCOL_SG HDL_PARAMETER true
set_parameter_property DMA_AXI_PROTOCOL_SG ALLOWED_RANGES { "0:AXI4" "1:AXI3" }
set_parameter_property DMA_AXI_PROTOCOL_SG VISIBLE true
set_parameter_property DMA_AXI_PROTOCOL_SG GROUP $group

add_parameter DMA_DATA_WIDTH_SG INTEGER 64
set_parameter_property DMA_DATA_WIDTH_SG DISPLAY_NAME "Bus Width"
set_parameter_property DMA_DATA_WIDTH_SG UNITS Bits
set_parameter_property DMA_DATA_WIDTH_SG HDL_PARAMETER true
set_parameter_property DMA_DATA_WIDTH_SG ALLOWED_RANGES {64}
set_parameter_property DMA_DATA_WIDTH_SG VISIBLE true
set_parameter_property DMA_DATA_WIDTH_SG GROUP $group

set group "Features"

add_parameter CYCLIC INTEGER 1
set_parameter_property CYCLIC DISPLAY_NAME "Cyclic Transfer Support"
set_parameter_property CYCLIC DISPLAY_HINT boolean
set_parameter_property CYCLIC HDL_PARAMETER true
set_parameter_property CYCLIC GROUP $group

add_parameter DMA_2D_TRANSFER INTEGER 0
set_parameter_property DMA_2D_TRANSFER DISPLAY_NAME "2D Transfer Support"
set_parameter_property DMA_2D_TRANSFER DISPLAY_HINT boolean
set_parameter_property DMA_2D_TRANSFER HDL_PARAMETER true
set_parameter_property DMA_2D_TRANSFER GROUP $group

add_parameter DMA_SG_TRANSFER INTEGER 0
set_parameter_property DMA_SG_TRANSFER DISPLAY_NAME "SG Transfer Support"
set_parameter_property DMA_SG_TRANSFER DISPLAY_HINT boolean
set_parameter_property DMA_SG_TRANSFER HDL_PARAMETER true
set_parameter_property DMA_SG_TRANSFER GROUP $group

add_parameter SYNC_TRANSFER_START INTEGER 0
set_parameter_property SYNC_TRANSFER_START DISPLAY_NAME "Transfer Start Synchronization Support"
set_parameter_property SYNC_TRANSFER_START DISPLAY_HINT boolean
set_parameter_property SYNC_TRANSFER_START HDL_PARAMETER true
set_parameter_property SYNC_TRANSFER_START GROUP $group

set group "Clock Domain Configuration"

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
ad_interface signal  fifo_wr_sync      input   1                       sync
ad_interface signal  fifo_wr_xfer_req  output  1                       xfer_req

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
      if_fifo_wr_sync if_fifo_wr_xfer_req
  }

  if {[get_parameter_value DMA_TYPE_SRC] == 2 &&
      [get_parameter_value SYNC_TRANSFER_START] == 0} {
    set_port_property fifo_wr_sync termination true
    set_port_property fifo_wr_sync termination_value 1
  }

  if {[get_parameter_value ENABLE_DIAGNOSTICS_IF] != 1} {
    lappend disabled_intfs diagnostics_if
  }

  foreach intf $disabled_intfs {
    set_interface_property $intf ENABLED false
  }
}

set group "Debug"

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

set group "AXI Stream interface common configuration"

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
