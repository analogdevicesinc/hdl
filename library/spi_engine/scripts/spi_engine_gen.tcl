###############################################################################
## Copyright (C) 2020-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Unified SPI Engine generation script
## This script provides a single implementation that works for both Xilinx and Intel
## by using the vendor-agnostic ad_* procedures from adi_board.tcl or <intel_carrier>_system_qsys.tcl

## Detect the current vendor environment
proc ad_detect_vendor {} {
  # Check for Vivado (Xilinx)
  if {[info commands get_bd_cells] != ""} {
    return "xilinx"
  }
  # Check for Platform Designer/Qsys (Intel)
  if {[info commands add_instance] != ""} {
    return "intel"
  }
  # Default to xilinx for backward compatibility
  return "xilinx"
}

proc spi_engine_create {args} {

  # Detect vendor using the abstraction layer
  set vendor [ad_detect_vendor]

  # Parse arguments based on vendor expectations
  if {$vendor == "xilinx"} {
    # Xilinx: name + optional parameters
    set name [lindex $args 0]
    set data_width [expr {[llength $args] > 1 ? [lindex $args 1] : 32}]
    set async_spi_clk [expr {[llength $args] > 2 ? [lindex $args 2] : 1}]
    set num_cs [expr {[llength $args] > 3 ? [lindex $args 3] : 1}]
    set num_sdi [expr {[llength $args] > 4 ? [lindex $args 4] : 1}]
    set num_sdo [expr {[llength $args] > 5 ? [lindex $args 5] : 1}]
    set sdi_delay [expr {[llength $args] > 6 ? [lindex $args 6] : 0}]
    set echo_sclk [expr {[llength $args] > 7 ? [lindex $args 7] : 0}]
    set sdo_streaming [expr {[llength $args] > 8 ? [lindex $args 8] : 0}]
    set cmd_mem_addr_width [expr {[llength $args] > 9 ? [lindex $args 9] : 4}]
    set data_mem_addr_width [expr {[llength $args] > 10 ? [lindex $args 10] : 4}]
    set sdi_fifo_addr_width [expr {[llength $args] > 11 ? [lindex $args 11] : 5}]
    set sdo_fifo_addr_width [expr {[llength $args] > 12 ? [lindex $args 12] : 5}]
    set sync_fifo_addr_width [expr {[llength $args] > 13 ? [lindex $args 13] : 4}]
    set cmd_fifo_addr_width [expr {[llength $args] > 14 ? [lindex $args 14] : 4}]

  } elseif {$vendor == "intel"} {
    # Intel: name + clocks + optional parameters
    if {[llength $args] < 4} {
      error "ERROR: Intel implementation requires at least: name, axi_clk, axi_reset, spi_clk"
    }

    set name [lindex $args 0]
    set axi_clk [lindex $args 1]
    set axi_reset [lindex $args 2]
    set spi_clk [lindex $args 3]
    set data_width [expr {[llength $args] > 4 ? [lindex $args 4] : 32}]
    set async_spi_clk [expr {[llength $args] > 5 ? [lindex $args 5] : 1}]
    set num_cs [expr {[llength $args] > 6 ? [lindex $args 6] : 1}]
    set num_sdi [expr {[llength $args] > 7 ? [lindex $args 7] : 1}]
    set num_sdo [expr {[llength $args] > 8 ? [lindex $args 8] : 1}]
    set sdi_delay [expr {[llength $args] > 9 ? [lindex $args 9] : 0}]
    set echo_sclk [expr {[llength $args] > 10 ? [lindex $args 10] : 0}]
    set sdo_streaming [expr {[llength $args] > 11 ? [lindex $args 11] : 0}]
    set cmd_mem_addr_width [expr {[llength $args] > 12 ? [lindex $args 12] : 4}]
    set data_mem_addr_width [expr {[llength $args] > 13 ? [lindex $args 13] : 4}]
    set sdi_fifo_addr_width [expr {[llength $args] > 14 ? [lindex $args 14] : 5}]
    set sdo_fifo_addr_width [expr {[llength $args] > 15 ? [lindex $args 15] : 5}]
    set sync_fifo_addr_width [expr {[llength $args] > 16 ? [lindex $args 16] : 4}]
    set cmd_fifo_addr_width [expr {[llength $args] > 17 ? [lindex $args 17] : 4}]
  }

  # Debug output for Xilinx
  if {$vendor == "xilinx" && $echo_sclk == 1} {
    puts "echo_sclk: $echo_sclk"
  }

  # Component instance names
  set execution "${name}_execution"
  set axi_regmap "${name}_axi_regmap"
  set offload "${name}_offload"
  set interconnect "${name}_interconnect"

  # Create hierarchy for Xilinx only
  if {$vendor == "xilinx"} {
    create_bd_cell -type hier $name
    current_bd_instance /$name

    # Create pins for the hierarchy
    if {$async_spi_clk == 1} {
      create_bd_pin -dir I -type clk spi_clk
    }
    if {$echo_sclk == 1} {
      create_bd_pin -dir I -type clk echo_sclk
    }
    create_bd_pin -dir I -type clk clk
    create_bd_pin -dir I -type rst resetn
    create_bd_pin -dir I trigger
    create_bd_pin -dir O irq
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_engine_rtl:1.0 m_spi
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_sample
    if {$sdo_streaming == 1} {
      create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_sample
    }
  }

  # Create IP instances using vendor-agnostic functions
  ad_ip_instance spi_engine_execution $execution
  ad_ip_parameter $execution CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter $execution CONFIG.NUM_OF_CS $num_cs
  ad_ip_parameter $execution CONFIG.NUM_OF_SDI $num_sdi
  ad_ip_parameter $execution CONFIG.SDO_DEFAULT 1
  ad_ip_parameter $execution CONFIG.SDI_DELAY $sdi_delay
  ad_ip_parameter $execution CONFIG.ECHO_SCLK $echo_sclk

  ad_ip_instance axi_spi_engine $axi_regmap
  ad_ip_parameter $axi_regmap CONFIG.MM_IF_TYPE 0
  ad_ip_parameter $axi_regmap CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter $axi_regmap CONFIG.NUM_OFFLOAD 1
  ad_ip_parameter $axi_regmap CONFIG.NUM_OF_SDI $num_sdi
  ad_ip_parameter $axi_regmap CONFIG.ASYNC_SPI_CLK $async_spi_clk
  ad_ip_parameter $axi_regmap CONFIG.OFFLOAD0_CMD_MEM_ADDRESS_WIDTH $cmd_mem_addr_width
  ad_ip_parameter $axi_regmap CONFIG.OFFLOAD0_SDO_MEM_ADDRESS_WIDTH $data_mem_addr_width
  ad_ip_parameter $axi_regmap CONFIG.SDI_FIFO_ADDRESS_WIDTH $sdi_fifo_addr_width
  ad_ip_parameter $axi_regmap CONFIG.SDO_FIFO_ADDRESS_WIDTH $sdo_fifo_addr_width
  ad_ip_parameter $axi_regmap CONFIG.SYNC_FIFO_ADDRESS_WIDTH $sync_fifo_addr_width
  ad_ip_parameter $axi_regmap CONFIG.CMD_FIFO_ADDRESS_WIDTH $cmd_fifo_addr_width

  ad_ip_instance spi_engine_offload $offload
  ad_ip_parameter $offload CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter $offload CONFIG.ASYNC_SPI_CLK 0
  ad_ip_parameter $offload CONFIG.NUM_OF_SDI $num_sdi
  ad_ip_parameter $offload CONFIG.CMD_MEM_ADDRESS_WIDTH $cmd_mem_addr_width
  ad_ip_parameter $offload CONFIG.SDO_MEM_ADDRESS_WIDTH $data_mem_addr_width
  ad_ip_parameter $offload CONFIG.SDO_STREAMING $sdo_streaming

  # Intel-specific: Set ASYNC_TRIG parameter if needed
  if {$vendor == "intel"} {
    ad_ip_parameter $offload CONFIG.ASYNC_TRIG 0
  }

  ad_ip_instance spi_engine_interconnect $interconnect
  ad_ip_parameter $interconnect CONFIG.DATA_WIDTH $data_width
  ad_ip_parameter $interconnect CONFIG.NUM_OF_SDI $num_sdi

  # Create connections based on vendor
  if {$vendor == "xilinx"} {
    # Xilinx connection style (hierarchical with internal pins)
    ad_connect $axi_regmap/spi_engine_offload_ctrl0 $offload/spi_engine_offload_ctrl
    ad_connect $offload/m_interconnect_ctrl $interconnect/s_interconnect_ctrl
    ad_connect $offload/spi_engine_ctrl $interconnect/s0_ctrl
    ad_connect $axi_regmap/spi_engine_ctrl $interconnect/s1_ctrl
    ad_connect $interconnect/m_ctrl $execution/ctrl
    ad_connect $offload/offload_sdi m_axis_sample
    ad_connect $offload/trigger trigger
    ad_connect $execution/spi m_spi

    if {$sdo_streaming == 1} {
      ad_connect $offload/s_axis_sdo s_axis_sample
    }

    # Clock connections
    ad_connect clk $axi_regmap/s_axi_aclk

    if {$async_spi_clk == 1} {
      ad_connect spi_clk $offload/spi_clk
      ad_connect spi_clk $offload/ctrl_clk
      ad_connect spi_clk $execution/clk
      ad_connect spi_clk $axi_regmap/spi_clk
      ad_connect spi_clk $interconnect/clk
    } else {
      ad_connect clk $offload/spi_clk
      ad_connect clk $offload/ctrl_clk
      ad_connect clk $execution/clk
      ad_connect clk $axi_regmap/spi_clk
      ad_connect clk $interconnect/clk
    }

    if {$echo_sclk == 1} {
      ad_connect echo_sclk $execution/echo_sclk
    }

    # Reset connections
    ad_connect $axi_regmap/spi_resetn $offload/spi_resetn
    ad_connect $axi_regmap/spi_resetn $execution/resetn
    ad_connect $axi_regmap/spi_resetn $interconnect/resetn
    ad_connect resetn $axi_regmap/s_axi_aresetn
    ad_connect irq $axi_regmap/irq

    # Exit hierarchy
    current_bd_instance /

  } elseif {$vendor == "intel"} {
    # Intel connection style (flat with different interface naming)

    # Clock connections
    ad_connect $axi_clk $axi_regmap.s_axi_clock
    ad_connect $spi_clk $axi_regmap.if_spi_clk
    ad_connect $spi_clk $execution.if_clk
    ad_connect $spi_clk $interconnect.if_clk
    ad_connect $spi_clk $offload.if_ctrl_clk
    ad_connect $spi_clk $offload.if_spi_clk

    # Reset connections
    ad_connect $axi_reset $axi_regmap.s_axi_reset
    ad_connect $axi_regmap.if_spi_resetn $execution.if_resetn
    ad_connect $axi_regmap.if_spi_resetn $interconnect.if_resetn
    ad_connect $axi_regmap.if_spi_resetn $offload.if_spi_resetn

    # Data path connections
    ad_connect $interconnect.m_cmd $execution.cmd
    ad_connect $execution.sdi_data $interconnect.m_sdi
    ad_connect $interconnect.m_sdo $execution.sdo_data
    ad_connect $execution.sync $interconnect.m_sync
    ad_connect $axi_regmap.cmd $interconnect.s1_cmd
    ad_connect $interconnect.s1_sdi $axi_regmap.sdi_data
    ad_connect $axi_regmap.sdo_data $interconnect.s1_sdo
    ad_connect $interconnect.s1_sync $axi_regmap.sync
    ad_connect $offload.cmd $interconnect.s0_cmd
    ad_connect $interconnect.s0_sdi $offload.sdi_data
    ad_connect $offload.sdo_data $interconnect.s0_sdo
    ad_connect $interconnect.s0_sync $offload.sync
    ad_connect $offload.m_interconnect_ctrl $interconnect.s_interconnect_ctrl
    ad_connect $offload.ctrl_cmd_wr $axi_regmap.offload0_cmd
    ad_connect $offload.ctrl_sdo_wr $axi_regmap.offload0_sdo
    ad_connect $offload.if_ctrl_enable $axi_regmap.if_offload0_enable
    ad_connect $offload.if_ctrl_enabled $axi_regmap.if_offload0_enabled
    ad_connect $offload.if_ctrl_mem_reset $axi_regmap.if_offload0_mem_reset
    ad_connect $offload.status_sync $axi_regmap.offload_sync
  }
}