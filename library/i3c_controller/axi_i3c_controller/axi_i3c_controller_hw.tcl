package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create axi_i3c_controller {AXI I3C Controller} p_elaboration
ad_ip_files axi_i3c_controller [list\
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  axi_i3c_controller_constr.sdc \
  axi_i3c_controller.v]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter MM_IF_TYPE INTEGER 1
ad_ip_parameter ASYNC_I3C_CLK INTEGER 0

proc p_elaboration {} {

  # read parameters

  set mm_if_type [get_parameter_value "MM_IF_TYPE"]
  set async_i3c_clk [get_parameter_value "ASYNC_I3C_CLK"]

  # interrupt

  add_interface interrupt_sender interrupt end
  add_interface_port interrupt_sender irq irq Output 1

  # Microprocessor interface

  ad_interface clock   up_clk    input                  1
  ad_interface reset   up_rstn   input                  1   if_up_clk
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

  if {!($async_i3c_clk)} {
    lappend disabled_intfs i3c_clk
  }

  foreach interface $disabled_intfs {
    set_interface_property $interface ENABLED false
  }

  # I3C Controller interfaces
  ad_interface clock i3c_clk     input 1
  ad_interface reset i3c_reset_n  output 1

  add_interface cmd axi4stream start
  add_interface_port cmd cmd_ready tready   input  1
  add_interface_port cmd cmd_valid tvalid   output 1
  add_interface_port cmd cmd_data  tdata    output 32

  set_interface_property cmd associatedClock if_i3c_clk
  set_interface_property cmd associatedReset if_i3c_reset_n

  add_interface cmdr axi4stream end
  add_interface_port cmdr cmdr_ready  tready output 1
  add_interface_port cmdr cmdr_valid  tvalid input  1
  add_interface_port cmdr cmdr_data   tdata  input  32

  set_interface_property cmdr associatedClock if_i3c_clk
  set_interface_property cmdr associatedReset if_i3c_reset_n

  add_interface sdo axi4stream start
  add_interface_port sdo sdo_ready tready   input  1
  add_interface_port sdo sdo_valid tvalid   output 1
  add_interface_port sdo sdo_data  tdata    output 32

  set_interface_property sdo associatedClock if_i3c_clk
  set_interface_property sdo associatedReset if_i3c_reset_n

  add_interface sdi axi4stream end
  add_interface_port sdi sdi_ready  tready output 1
  add_interface_port sdi sdi_valid  tvalid input  1
  add_interface_port sdi sdi_data   tdata  input  32

  set_interface_property sdi associatedClock if_i3c_clk
  set_interface_property sdi associatedReset if_i3c_reset_n

  add_interface ibi axi4stream end
  add_interface_port ibi ibi_ready  tready output 1
  add_interface_port ibi ibi_valid  tvalid input  1
  add_interface_port ibi ibi_data   tdata  input  32

  set_interface_property ibi associatedClock if_i3c_clk
  set_interface_property ibi associatedReset if_i3c_reset_n
}

