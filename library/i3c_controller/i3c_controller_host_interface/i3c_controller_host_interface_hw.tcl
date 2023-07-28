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
  i3c_controller_regmap_defs.v \
  i3c_controller_cmd_parser.v \
  i3c_controller_write_byte.v \
  i3c_controller_read_byte.v \
  i3c_controller_write_ibi.v \
]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter ASYNC_CLK INTEGER 0
ad_ip_parameter PID INTEGER 0xC00FFE123456
ad_ip_parameter DCR INTEGER 0x7B
ad_ip_parameter BCR INTEGER 0x40
ad_ip_parameter OFFLOAD INTEGER 0

proc p_elaboration {} {

  set disabled_intfs {}

  # read parameters

  set id [get_parameter_value "ID"]
  set async_clk [get_parameter_value "ASYNC_CLK"]
  set pid [get_parameter_value "PID"]
  set dcr [get_parameter_value "DCR"]
  set bcr [get_parameter_value "BCR"]
  set offload [get_parameter_value "OFFLOAD"]

  # interrupt

  add_interface interrupt_sender interrupt end
  add_interface_port interrupt_sender irq irq Output 1

  # AXI Memory Mapped interface

  ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

  set_interface_property interrupt_sender associatedAddressablePoint s_axi
  set_interface_property interrupt_sender associatedClock s_axi_clock
  set_interface_property interrupt_sender associatedReset s_axi_reset
  set_interface_property interrupt_sender ENABLED true

  if {!($offload)} {
    lappend disabled_intfs offload offload_trigger
  }

  if {!($async_clk)} {
    lappend disabled_intfs clk
  }

  foreach interface $disabled_intfs {
    set_interface_property $interface ENABLED false
  }

  # I3C Controller interfaces

  ad_interface clock clk      input 1
  ad_interface reset reset_n  output 1 if_clk

  add_interface sdo axi4stream start
  add_interface_port sdo sdo_ready tready input  1
  add_interface_port sdo sdo_valid tvalid output 1
  add_interface_port sdo sdo_data  tdata  output 8

  set_interface_property sdo associatedClock if_clk
  set_interface_property sdo associatedReset if_reset_n

  add_interface sdi axi4stream end
  add_interface_port sdi sdi_ready tready output 1
  add_interface_port sdi sdi_valid tvalid input  1
  add_interface_port sdi sdi_data  tdata  input  8

  set_interface_property sdi associatedClock if_clk
  set_interface_property sdi associatedReset if_reset_n

  add_interface ibi axi4stream end
  add_interface_port ibi ibi_ready tready output 1
  add_interface_port ibi ibi_valid tvalid input  1
  add_interface_port ibi ibi_data  tdata  input  16

  set_interface_property ibi associatedClock if_clk
  set_interface_property ibi associatedReset if_reset_n

  add_interface offload_sdi axi4stream start
  add_interface_port offload_sdi offload_sdi_ready tready input  1
  add_interface_port offload_sdi offload_sdi_valid tvalid output 1
  add_interface_port offload_sdi offload_sdi       tdata  output 32

  set_interface_property offload_sdi associatedClock if_clk
  set_interface_property offload_sdi associatedReset if_resetn
}

