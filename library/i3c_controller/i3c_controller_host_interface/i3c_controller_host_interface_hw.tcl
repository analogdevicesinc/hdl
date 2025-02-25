###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create i3c_controller_host_interface {I3C Controller Host Interface}
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files i3c_controller_host_interface [list \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  $ad_hdl_dir/library/common/ad_mem_dual.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  i3c_controller_host_interface_constr.sdc \
  i3c_controller_host_interface.v \
  i3c_controller_regmap.v \
  i3c_controller_regmap.vh \
  i3c_controller_cmd_parser.v \
  i3c_controller_pack.v \
  i3c_controller_unpack.v \
  i3c_controller_write_ibi.v \
]

# Parameters

ad_ip_parameter CMD_FIFO_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter CMDR_FIFO_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter SDO_FIFO_ADDRESS_WIDTH INTEGER 5
ad_ip_parameter SDI_FIFO_ADDRESS_WIDTH INTEGER 5
ad_ip_parameter IBI_FIFO_ADDRESS_WIDTH INTEGER 4
ad_ip_parameter ID INTEGER 0
ad_ip_parameter DA INTEGER 49
ad_ip_parameter ASYNC_CLK INTEGER 0
ad_ip_parameter OFFLOAD INTEGER 0
ad_ip_parameter PID_MANUF_ID INTEGER 0
ad_ip_parameter PID_TYPE_SELECTOR INTEGER 0
ad_ip_parameter PID_PART_ID INTEGER 0
ad_ip_parameter PID_INSTANCE_ID INTEGER 0
ad_ip_parameter PID_EXTRA_ID INTEGER 0

proc p_elaboration {} {

  set disabled_intfs {}

  # Read parameters

  set id [get_parameter_value "ID"]
  set async_clk [get_parameter_value "ASYNC_CLK"]
  set offload [get_parameter_value "OFFLOAD"]

  # Interrupt

  add_interface interrupt_sender interrupt end
  add_interface_port interrupt_sender irq irq Output 1

  # AXI Memory Mapped interface

  ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

  set_interface_property interrupt_sender associatedAddressablePoint s_axi
  set_interface_property interrupt_sender associatedClock s_axi_clock
  set_interface_property interrupt_sender associatedReset s_axi_reset
  set_interface_property interrupt_sender ENABLED true

  ad_interface clock clk input 1

  if {!($async_clk)} {
    set if_clk s_axi_clock
  } else {
    set if_clk if_clk
  }

  ad_interface reset-n reset_n output 1 $if_clk

  ad_interface signal offload_trigger input 1 if_pwm

  add_interface sdo axi4stream start
  add_interface_port sdo sdo_ready tready input  1
  add_interface_port sdo sdo_valid tvalid output 1
  add_interface_port sdo sdo       tdata  output 8

  set_interface_property sdo associatedClock $if_clk
  set_interface_property sdo associatedReset if_reset_n

  add_interface sdi axi4stream end
  add_interface_port sdi sdi_ready tready output 1
  add_interface_port sdi sdi_valid tvalid input  1
  add_interface_port sdi sdi_last  tlast  input  1
  add_interface_port sdi sdi       tdata  input  8

  set_interface_property sdi associatedClock $if_clk
  set_interface_property sdi associatedReset if_reset_n

  add_interface ibi axi4stream end
  add_interface_port ibi ibi_ready tready output  1
  add_interface_port ibi ibi_valid tvalid input   1
  add_interface_port ibi ibi       tdata  input  15

  set_interface_property ibi associatedClock $if_clk
  set_interface_property ibi associatedReset if_reset_n

  add_interface offload_sdi axi4stream start
  add_interface_port offload_sdi offload_sdi_ready tready input   1
  add_interface_port offload_sdi offload_sdi_valid tvalid output  1
  add_interface_port offload_sdi offload_sdi       tdata  output 32

  set_interface_property offload_sdi associatedClock $if_clk
  set_interface_property offload_sdi associatedReset if_reset_n

  add_interface cmdp conduit start
  add_interface_port cmdp cmdp_ready       cready      input   1
  add_interface_port cmdp cmdp_valid       cvalid      output  1
  add_interface_port cmdp cmdp             cdata       output 31
  add_interface_port cmdp cmdp_error       error       input   3
  add_interface_port cmdp cmdp_nop         nop         input   1
  add_interface_port cmdp cmdp_daa_trigger daa_trigger input   1

  set_interface_property cmdp associatedClock $if_clk
  set_interface_property cmdp associatedReset if_reset_n

  add_interface rmap conduit start
  add_interface_port rmap rmap_ibi_config    ibi_config    output 2
  add_interface_port rmap rmap_pp_sg         pp_sg         output 2
  add_interface_port rmap rmap_dev_char_addr dev_char_addr input  7
  add_interface_port rmap rmap_dev_char_data dev_char_data output 4

  set_interface_property rmap associatedClock $if_clk
  set_interface_property rmap associatedReset if_reset_n

  if {!($offload)} {
    lappend disabled_intfs offload_sdi if_offload_trigger
  }

  if {!($async_clk)} {
    lappend disabled_intfs if_clk
  }

  foreach interface $disabled_intfs {
    set_interface_property $interface ENABLED false
  }
}
