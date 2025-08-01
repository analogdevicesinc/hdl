###############################################################################
## Copyright (C) 2020-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create axi_spi_engine {AXI SPI Engine} p_elaboration
ad_ip_files axi_spi_engine [list\
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  axi_spi_engine_constr.sdc \
  axi_spi_engine.v]

# parameters

ad_ip_parameter CMD_FIFO_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter SYNC_FIFO_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter SDO_FIFO_ADDRESS_WIDTH INTEGER 5
ad_ip_parameter SDI_FIFO_ADDRESS_WIDTH INTEGER 5
ad_ip_parameter MM_IF_TYPE INTEGER 1
ad_ip_parameter ASYNC_SPI_CLK INTEGER 0
ad_ip_parameter NUM_OFFLOAD INTEGER 1
ad_ip_parameter OFFLOAD0_CMD_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter OFFLOAD0_SDO_MEM_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter ID INTEGER 0
ad_ip_parameter DATA_WIDTH INTEGER 8
ad_ip_parameter NUM_OF_SDI INTEGER 1

proc p_elaboration {} {

  # read parameters

  set mm_if_type [get_parameter_value "MM_IF_TYPE"]

  set num_of_sdi [get_parameter_value NUM_OF_SDI]
  set data_width [get_parameter_value DATA_WIDTH]

  # interrupt

  add_interface interrupt_sender interrupt end
  add_interface_port interrupt_sender irq irq Output 1

  # Microprocessor interface

  ad_interface clock   up_clk    input                  1
  ad_interface reset-n up_rstn   input                  1   if_up_clk
  ad_interface signal  up_wreq   input                  1
  ad_interface signal  up_wack   output                 1
  ad_interface signal  up_waddr  input                 14
  ad_interface signal  up_wdata  input                 32
  ad_interface signal  up_rreq   input                  1
  ad_interface signal  up_rack   output                 1
  ad_interface signal  up_raddr  output                14
  ad_interface signal  up_rdata  output                32

  # AXI Memory Mapped interface

  ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

  set disabled_intfs {}
  if {$mm_if_type} {

    # uProcessor interface active for regmap, deactivate S_AXI
    lappend disabled_intfs s_axi

    set_port_property s_axi_aclk termination true
    set_port_property s_axi_aresetn termination true
    set_port_property s_axi_aresetn termination_value 1
    set_port_property s_axi_awvalid termination true
    set_port_property s_axi_awaddr termination true
    set_port_property s_axi_awprot termination true
    set_port_property s_axi_wvalid termination true
    set_port_property s_axi_wdata termination true
    set_port_property s_axi_wstrb termination true
    set_port_property s_axi_bready termination true
    set_port_property s_axi_arvalid termination true
    set_port_property s_axi_araddr termination true
    set_port_property s_axi_arprot termination true
    set_port_property s_axi_rready termination true

  } else {

    set_interface_property interrupt_sender associatedAddressablePoint s_axi
    set_interface_property interrupt_sender associatedClock s_axi_clock
    set_interface_property interrupt_sender associatedReset s_axi_reset
    set_interface_property interrupt_sender ENABLED true

    # AXI4 Slave is active for regmap, deactivate uP
    lappend disabled_intfs if_up_clk if_up_rstn if_up_wreq if_up_wack if_up_waddr \
       if_up_wdata if_up_rreq if_up_rack if_up_raddr if_up_rdata

    set_port_property up_clk termination true
    set_port_property up_rstn termination true
    set_port_property up_rstn termination_value 1
    set_port_property up_wreq termination true
    set_port_property up_waddr termination true
    set_port_property up_wdata termination true
    set_port_property up_rreq termination true
    set_port_property up_raddr termination true

  }

  foreach interface $disabled_intfs {
    set_interface_property $interface ENABLED false
  }

  # SPI Engine interfaces

  ad_interface clock   spi_clk     input 1
  ad_interface reset-n spi_resetn  output 1 if_spi_clk

  add_interface cmd axi4stream start
  add_interface_port cmd cmd_ready tready   input  1
  add_interface_port cmd cmd_valid tvalid   output 1
  add_interface_port cmd cmd_data  tdata    output 16

  set_interface_property cmd associatedClock if_spi_clk
  set_interface_property cmd associatedReset if_spi_resetn

  add_interface sdo_data axi4stream start
  add_interface_port sdo_data sdo_data_ready tready input  1
  add_interface_port sdo_data sdo_data_valid tvalid output 1
  add_interface_port sdo_data sdo_data       tdata  output $data_width

  set_interface_property sdo_data associatedClock if_spi_clk
  set_interface_property sdo_data associatedReset if_spi_resetn

  add_interface sdi_data axi4stream end
  add_interface_port sdi_data sdi_data_ready  tready output 1
  add_interface_port sdi_data sdi_data_valid  tvalid input  1
  add_interface_port sdi_data sdi_data        tdata  input [expr $num_of_sdi * $data_width]

  set_interface_property sdi_data associatedClock if_spi_clk
  set_interface_property sdi_data associatedReset if_spi_resetn

  add_interface sync axi4stream end
  add_interface_port sync sync_valid  tvalid input   1
  add_interface_port sync sync_ready  tready output  1
  add_interface_port sync sync_data   tdata  input   8

  set_interface_property sync associatedClock if_spi_clk
  set_interface_property sync associatedReset if_spi_resetn

  # Offload interfaces

  add_interface offload0_cmd conduit end
  add_interface_port offload0_cmd offload0_cmd_wr_en    wre   output  1
  add_interface_port offload0_cmd offload0_cmd_wr_data  data  output  16

  set_interface_property offload0_cmd associatedClock if_spi_clk
  set_interface_property offload0_cmd associatedReset none

  add_interface offload0_sdo conduit end
  add_interface_port offload0_sdo offload0_sdo_wr_en    wre   output  1
  add_interface_port offload0_sdo offload0_sdo_wr_data  data  output  $data_width

  set_interface_property offload0_sdo associatedClock if_spi_clk
  set_interface_property offload0_sdo associatedReset none

  ad_interface signal  offload0_mem_reset  output  1   reset
  ad_interface signal  offload0_enable     output  1   enable
  ad_interface signal  offload0_enabled    input   1   enabled

  add_interface offload_sync axi4stream end
  add_interface_port offload_sync offload_sync_valid  tvalid input   1
  add_interface_port offload_sync offload_sync_ready  tready output  1
  add_interface_port offload_sync offload_sync_data   tdata  input   8

  set_interface_property offload_sync associatedClock if_spi_clk
  set_interface_property offload_sync associatedReset if_spi_resetn

}

