

package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_dmac
set_module_property DESCRIPTION "AXI DMA Controller"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_dmac
set_module_property ELABORATION_CALLBACK axi_dmac_elaborate
set_module_property VALIDATION_CALLBACK axi_dmac_validate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_dmac
add_fileset_file sync_bits.v              VERILOG PATH $ad_hdl_dir/library/util_cdc/sync_bits.v
add_fileset_file sync_gray.v              VERILOG PATH $ad_hdl_dir/library/util_cdc/sync_gray.v
add_fileset_file up_axi.v                 VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file axi_repack.v             VERILOG PATH $ad_hdl_dir/library/util_axis_resize/util_axis_resize.v
add_fileset_file fifo.v                   VERILOG PATH $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v
add_fileset_file address_gray.v           VERILOG PATH $ad_hdl_dir/library/util_axis_fifo/address_gray.v
add_fileset_file address_gray_pipelined.v VERILOG PATH $ad_hdl_dir/library/util_axis_fifo/address_gray_pipelined.v
add_fileset_file address_sync.v           VERILOG PATH $ad_hdl_dir/library/util_axis_fifo/address_sync.v
add_fileset_file inc_id.h                 VERILOG_INCLUDE PATH inc_id.h
add_fileset_file resp.h                   VERILOG_INCLUDE PATH resp.h
add_fileset_file address_generator.v      VERILOG PATH address_generator.v
add_fileset_file data_mover.v             VERILOG PATH data_mover.v
add_fileset_file request_arb.v            VERILOG PATH request_arb.v
add_fileset_file request_generator.v      VERILOG PATH request_generator.v
add_fileset_file response_handler.v       VERILOG PATH response_handler.v
add_fileset_file axi_register_slice.v     VERILOG PATH axi_register_slice.v
add_fileset_file 2d_transfer.v            VERILOG PATH 2d_transfer.v
add_fileset_file dest_axi_mm.v            VERILOG PATH dest_axi_mm.v
add_fileset_file dest_axi_stream.v        VERILOG PATH dest_axi_stream.v
add_fileset_file dest_fifo_inf.v          VERILOG PATH dest_fifo_inf.v
add_fileset_file src_axi_mm.v             VERILOG PATH src_axi_mm.v
add_fileset_file src_axi_stream.v         VERILOG PATH src_axi_stream.v
add_fileset_file src_fifo_inf.v           VERILOG PATH src_fifo_inf.v
add_fileset_file splitter.v               VERILOG PATH splitter.v
add_fileset_file response_generator.v     VERILOG PATH response_generator.v
add_fileset_file axi_dmac.v               VERILOG PATH axi_dmac.v
add_fileset_file axi_dmac_constr.sdc      SDC     PATH axi_dmac_constr.sdc

# Disable dual-clock RAM read-during-write behaviour warning.
set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 276027 -entity util_axis_fifo" }

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

add_parameter FIFO_SIZE INTEGER 4
set_parameter_property FIFO_SIZE DISPLAY_NAME "FIFO Size (In Bursts)"
set_parameter_property FIFO_SIZE HDL_PARAMETER true
set_parameter_property FIFO_SIZE GROUP $group

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

set group "Features"

add_parameter CYCLIC INTEGER 1
set_parameter_property CYCLIC DISPLAY_NAME "Cyclic Transfer Support"
set_parameter_property CYCLIC DISPLAY_HINT boolean
set_parameter_property CYCLIC HDL_PARAMETER true
set_parameter_property CYCLIC GROUP $group

add_parameter DMA_2D_TRANSFER INTEGER 1
set_parameter_property DMA_2D_TRANSFER DISPLAY_NAME "2D Transfer Support"
set_parameter_property DMA_2D_TRANSFER DISPLAY_HINT boolean
set_parameter_property DMA_2D_TRANSFER HDL_PARAMETER true
set_parameter_property DMA_2D_TRANSFER GROUP $group

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

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 12

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

  if {$auto_clk == true} {
    global src_clks dest_clks

    set req_domain [get_parameter_value CLK_DOMAIN_REQ]
    set src_domain [get_parameter_value [lindex $src_clks $type_src 0]]
    set dest_domain [get_parameter_value [lindex $dest_clks $type_dest 0]]

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
  } else {
    foreach p {ASYNC_CLK_REQ_SRC ASYNC_CLK_SRC_DEST ASYNC_CLK_DEST_REQ} {
      set_parameter_value $p [get_parameter_value ${p}_MANUAL]
    }
  }

  foreach p {ASYNC_CLK_REQ_SRC ASYNC_CLK_SRC_DEST ASYNC_CLK_DEST_REQ} {
    set_parameter_property ${p}_MANUAL VISIBLE [expr $auto_clk ? false : true]
    set_parameter_property $p VISIBLE $auto_clk
  }
}

# conditional interfaces

# axi4 destination/source

add_interface m_dest_axi_clock clock end
add_interface_port m_dest_axi_clock m_dest_axi_aclk clk Input 1

add_interface m_dest_axi_reset reset end
set_interface_property m_dest_axi_reset associatedClock m_dest_axi_clock
add_interface_port m_dest_axi_reset m_dest_axi_aresetn reset_n Input 1

add_interface m_dest_axi axi4 start
set_interface_property m_dest_axi associatedClock m_dest_axi_clock
set_interface_property m_dest_axi associatedReset m_dest_axi_reset
set_interface_property m_dest_axi readIssuingCapability 1
add_interface_port m_dest_axi m_dest_axi_awvalid awvalid Output 1
add_interface_port m_dest_axi m_dest_axi_awaddr awaddr Output 32
add_interface_port m_dest_axi m_dest_axi_awready awready Input 1
add_interface_port m_dest_axi m_dest_axi_wvalid wvalid Output 1
add_interface_port m_dest_axi m_dest_axi_wdata wdata Output DMA_DATA_WIDTH_DEST
add_interface_port m_dest_axi m_dest_axi_wstrb wstrb Output DMA_DATA_WIDTH_DEST/8
add_interface_port m_dest_axi m_dest_axi_wready wready Input 1
add_interface_port m_dest_axi m_dest_axi_bvalid bvalid Input 1
add_interface_port m_dest_axi m_dest_axi_bresp bresp Input 2
add_interface_port m_dest_axi m_dest_axi_bready bready Output 1
add_interface_port m_dest_axi m_dest_axi_arvalid arvalid Output 1
add_interface_port m_dest_axi m_dest_axi_araddr araddr Output 32
add_interface_port m_dest_axi m_dest_axi_arready arready Input 1
add_interface_port m_dest_axi m_dest_axi_rvalid rvalid Input 1
add_interface_port m_dest_axi m_dest_axi_rresp rresp Input 2
add_interface_port m_dest_axi m_dest_axi_rdata rdata Input DMA_DATA_WIDTH_DEST
add_interface_port m_dest_axi m_dest_axi_rready rready Output 1
add_interface_port m_dest_axi m_dest_axi_awlen awlen Output 8
add_interface_port m_dest_axi m_dest_axi_awsize awsize Output 3
add_interface_port m_dest_axi m_dest_axi_awburst awburst Output 2
add_interface_port m_dest_axi m_dest_axi_awcache awcache Output 4
add_interface_port m_dest_axi m_dest_axi_awprot awprot Output 3
add_interface_port m_dest_axi m_dest_axi_wlast wlast Output 1
add_interface_port m_dest_axi m_dest_axi_arlen arlen Output 8
add_interface_port m_dest_axi m_dest_axi_arsize arsize Output 3
add_interface_port m_dest_axi m_dest_axi_arburst arburst Output 2
add_interface_port m_dest_axi m_dest_axi_arcache arcache Output 4
add_interface_port m_dest_axi m_dest_axi_arprot arprot Output 3

add_interface m_src_axi_clock clock end
add_interface_port m_src_axi_clock m_src_axi_aclk clk Input 1

add_interface m_src_axi_reset reset end
set_interface_property m_src_axi_reset associatedClock m_src_axi_clock
add_interface_port m_src_axi_reset m_src_axi_aresetn reset_n Input 1

add_interface m_src_axi axi4 start
set_interface_property m_src_axi associatedClock m_src_axi_clock
set_interface_property m_src_axi associatedReset m_src_axi_reset
set_interface_property m_src_axi readIssuingCapability 1
set_interface_property m_src_axi writeIssuingCapability 1
set_interface_property m_src_axi combinedIssuingCapability 1
add_interface_port m_src_axi m_src_axi_awvalid awvalid Output 1
add_interface_port m_src_axi m_src_axi_awaddr awaddr Output 32
add_interface_port m_src_axi m_src_axi_awready awready Input 1
add_interface_port m_src_axi m_src_axi_wvalid wvalid Output 1
add_interface_port m_src_axi m_src_axi_wdata wdata Output DMA_DATA_WIDTH_SRC
add_interface_port m_src_axi m_src_axi_wstrb wstrb Output DMA_DATA_WIDTH_SRC/8
add_interface_port m_src_axi m_src_axi_wready wready Input 1
add_interface_port m_src_axi m_src_axi_bvalid bvalid Input 1
add_interface_port m_src_axi m_src_axi_bresp bresp Input 2
add_interface_port m_src_axi m_src_axi_bready bready Output 1
add_interface_port m_src_axi m_src_axi_arvalid arvalid Output 1
add_interface_port m_src_axi m_src_axi_araddr araddr Output 32
add_interface_port m_src_axi m_src_axi_arready arready Input 1
add_interface_port m_src_axi m_src_axi_rvalid rvalid Input 1
add_interface_port m_src_axi m_src_axi_rresp rresp Input 2
add_interface_port m_src_axi m_src_axi_rdata rdata Input DMA_DATA_WIDTH_SRC
add_interface_port m_src_axi m_src_axi_rready rready Output 1
add_interface_port m_src_axi m_src_axi_awlen awlen Output 8
add_interface_port m_src_axi m_src_axi_awsize awsize Output 3
add_interface_port m_src_axi m_src_axi_awburst awburst Output 2
add_interface_port m_src_axi m_src_axi_awcache awcache Output 4
add_interface_port m_src_axi m_src_axi_awprot awprot Output 3
add_interface_port m_src_axi m_src_axi_wlast wlast Output 1
add_interface_port m_src_axi m_src_axi_arlen arlen Output 8
add_interface_port m_src_axi m_src_axi_arsize arsize Output 3
add_interface_port m_src_axi m_src_axi_arburst arburst Output 2
add_interface_port m_src_axi m_src_axi_arcache arcache Output 4
add_interface_port m_src_axi m_src_axi_arprot arprot Output 3

# axis destination/source

ad_alt_intf clock   m_axis_aclk       input   1                       clk
ad_alt_intf signal  m_axis_valid      output  1                       valid
ad_alt_intf signal  m_axis_data       output  DMA_DATA_WIDTH_DEST     data
ad_alt_intf signal  m_axis_ready      input   1                       ready
ad_alt_intf signal  m_axis_last       output  1                       last
ad_alt_intf signal  m_axis_xfer_req   output  1                       xfer_req

ad_alt_intf clock   s_axis_aclk       input   1                       clk
ad_alt_intf signal  s_axis_valid      input   1                       valid
ad_alt_intf signal  s_axis_data       input   DMA_DATA_WIDTH_SRC      data
ad_alt_intf signal  s_axis_ready      output  1                       ready
ad_alt_intf signal  s_axis_xfer_req   output  1                       xfer_req
ad_alt_intf signal  s_axis_user       input   1                       user

# fifo destination/source

ad_alt_intf clock   fifo_rd_clk       input   1                       clk
ad_alt_intf signal  fifo_rd_en        input   1                       valid
ad_alt_intf signal  fifo_rd_valid     output  1                       valid
ad_alt_intf signal  fifo_rd_dout      output  DMA_DATA_WIDTH_DEST     data
ad_alt_intf signal  fifo_rd_underflow output  1                       unf
ad_alt_intf signal  fifo_rd_xfer_req  output  1                       xfer_req

ad_alt_intf clock   fifo_wr_clk       input   1                       clk
ad_alt_intf signal  fifo_wr_en        input   1                       valid
ad_alt_intf signal  fifo_wr_din       input   DMA_DATA_WIDTH_SRC      data
ad_alt_intf signal  fifo_wr_overflow  output  1                       ovf
ad_alt_intf signal  fifo_wr_sync      input   1                       sync
ad_alt_intf signal  fifo_wr_xfer_req  output  1                       xfer_req

proc axi_dmac_elaborate {} {
  set fifo_size [get_parameter_value FIFO_SIZE]
  set disabled_intfs {}

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

  # axis destination/source

  if {[get_parameter_value DMA_TYPE_DEST] != 1} {
    lappend disabled_intfs \
      if_m_axis_aclk if_m_axis_valid if_m_axis_data if_m_axis_ready \
	  if_m_axis_last if_m_axis_xfer_req
  }

  if {[get_parameter_value DMA_TYPE_SRC] != 1} {
    lappend disabled_intfs \
      if_s_axis_aclk if_s_axis_valid if_s_axis_data if_s_axis_ready \
	  if_s_axis_xfer_req if_s_axis_user
  }

  if {[get_parameter_value DMA_TYPE_SRC] == 1 &&
      [get_parameter_value SYNC_TRANSFER_START] == 0} {
    set_port_property s_axis_user termination true
    set_port_property s_axis_user termination_value 1
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

  foreach intf $disabled_intfs {
    set_interface_property $intf ENABLED false
  }
}

