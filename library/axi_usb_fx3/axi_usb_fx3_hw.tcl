# ip, copied the structure from ad9371/avl_dacfifo
package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_usb_fx3
set_module_property DESCRIPTION "AXI USB FX3 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_usb_fx3

# files

ad_ip_files axi_usb_fx3 [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_usb_fx3_core.v" \
  "axi_usb_fx3_if.v" \
  "axi_usb_fx3_reg.v" \
  "axi_usb_fx3.v"]

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# Interrupt interface

add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint s_axi
set_interface_property interrupt_sender associatedClock s_axi_clock
set_interface_property interrupt_sender associatedReset s_axi_reset
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""
add_interface_port interrupt_sender irq irq output 1

# gpif ii

add_interface if_gpif conduit end
add_interface_port if_gpif pclk pclk output 1
add_interface_port if_gpif dma_rdy dma_rdy input 1
add_interface_port if_gpif dma_wmk dma_wmk input 1
add_interface_port if_gpif fifo_rdy fifo_rdy input 4
add_interface_port if_gpif data data input 32
add_interface_port if_gpif addr address output 4
add_interface_port if_gpif slcs_n slcs_n output 1
add_interface_port if_gpif slrd_n slrd_n output 1
add_interface_port if_gpif sloe_n sloe_n output 1
add_interface_port if_gpif slwr_n slwr_n output 1
add_interface_port if_gpif pktend_n pktend_n output 1
add_interface_port if_gpif epswitch_n epswitch_n output 1
set_interface_property if_gpif associatedClock s_axi_clock
set_interface_property if_gpif associatedReset s_axi_reset

# axi streaming slave
add_interface s_axis axi4stream end
add_interface_port s_axis s_axis_tdata tdata input 32
add_interface_port s_axis s_axis_tkeep tkeep input 4
add_interface_port s_axis s_axis_tlast tlast input 1
add_interface_port s_axis s_axis_tvalid tvalid input 1
add_interface_port s_axis s_axis_tready tready output 1
set_interface_property s_axis associatedClock s_axi_clock
set_interface_property s_axis associatedReset s_axi_reset

# axi streaming master
add_interface m_axis axi4stream start
add_interface_port m_axis m_axis_tdata tdata output 32
add_interface_port m_axis m_axis_tkeep tkeep output 4
add_interface_port m_axis m_axis_tlast tlast output 1
add_interface_port m_axis m_axis_tvalid tvalid output 1
add_interface_port m_axis m_axis_tready tready input 1
set_interface_property m_axis associatedClock s_axi_clock
set_interface_property m_axis associatedReset s_axi_reset

#debug
add_interface if_debug conduit end
add_interface_port if_debug debug_fx32dma debug_fx32dma output 75
add_interface_port if_debug debug_dma2fx3 debug_dma2fx3 output 74
add_interface_port if_debug debug_status  debug_status  output 15
