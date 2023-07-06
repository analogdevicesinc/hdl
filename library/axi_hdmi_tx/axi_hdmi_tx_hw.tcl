###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl
source $ad_hdl_dir/library/scripts/adi_intel_device_info_enc.tcl

set_module_property NAME axi_hdmi_tx
set_module_property DESCRIPTION "AXI HDMI Transmit Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_hdmi_tx
set_module_property VALIDATION_CALLBACK info_param_validate
set_module_property ELABORATION_CALLBACK add_out_interface

# files

ad_ip_files axi_hdmi_tx [list \
  $ad_hdl_dir/library/common/ad_mem.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/ad_csc.v \
  $ad_hdl_dir/library/common/ad_csc_RGB2CrYCb.v \
  $ad_hdl_dir/library/common/ad_ss_444to422.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_hdmi_tx.v \
  $ad_hdl_dir/library/intel/common/ad_mul.v \
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  axi_hdmi_tx_vdma.v \
  axi_hdmi_tx_es.v \
  axi_hdmi_tx_core.v \
  axi_hdmi_tx.v \
  axi_hdmi_tx_constr.sdc \
  ]

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter CR_CB_N INTEGER 0
set_parameter_property CR_CB_N DEFAULT_VALUE 0
set_parameter_property CR_CB_N DISPLAY_NAME CR_CB_N
set_parameter_property CR_CB_N UNITS None
set_parameter_property CR_CB_N HDL_PARAMETER true

add_parameter INTERFACE STRING "16_BIT"
set_parameter_property INTERFACE DEFAULT_VALUE "16_BIT"
set_parameter_property INTERFACE DISPLAY_NAME INTERFACE
set_parameter_property INTERFACE TYPE STRING
set_parameter_property INTERFACE ALLOWED_RANGES { "16_BIT" "24_BIT" "36_BIT" "16_BIT_EMBEDDED_SYNC" "VGA_INTERFACE" }
set_parameter_property INTERFACE HDL_PARAMETER false

add_parameter DEVICE STRING ""
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
set_parameter_property DEVICE HDL_PARAMETER false
set_parameter_property DEVICE VISIBLE false

adi_add_device_spec_param "FPGA_TECHNOLOGY"

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# reference clock  interface

add_interface reference_clk clock end
add_interface_port reference_clk reference_clk clk Input 1

# streaming dma

add_interface vdma_clock  clock end
add_interface_port vdma_clock vdma_clk clk Input 1

add_interface vdma_if axi4stream end
set_interface_property vdma_if associatedClock vdma_clock
set_interface_property vdma_if associatedReset s_axi_reset
add_interface_port vdma_if vdma_valid         tvalid Input 1
add_interface_port vdma_if vdma_data          tdata  Input 64
add_interface_port vdma_if vdma_ready         tready Output 1
add_interface_port vdma_if vdma_end_of_frame  tlast  Input 1

proc add_out_interface {} {

  set interface [get_parameter_value INTERFACE]
  switch $interface {
    "16_BIT" {
        add_interface hdmi_if conduit end
        set_interface_property hdmi_if associatedClock reference_clk
        add_interface_port hdmi_if hdmi_out_clk  h_clk Output 1
        add_interface_port hdmi_if hdmi_16_hsync h16_hsync Output 1
        add_interface_port hdmi_if hdmi_16_vsync h16_vsync Output 1
        add_interface_port hdmi_if hdmi_16_data_e h16_data_e Output 1
        add_interface_port hdmi_if hdmi_16_data h16_data Output 16
      }
    "24_BIT" {
        add_interface hdmi_if conduit end
        set_interface_property hdmi_if associatedClock reference_clk
        add_interface_port hdmi_if hdmi_out_clk h_clk Output 1
        add_interface_port hdmi_if hdmi_24_hsync h24_hsync Output 1
        add_interface_port hdmi_if hdmi_24_vsync h24_vsync Output 1
        add_interface_port hdmi_if hdmi_24_data_e h24_data_e Output 1
        add_interface_port hdmi_if hdmi_24_data h24_data Output 24
      }
    "36_BIT" {
        add_interface hdmi_if conduit end
        set_interface_property hdmi_if associatedClock reference_clk
        add_interface_port hdmi_if hdmi_out_clk h_clk Output 1
        add_interface_port hdmi_if hdmi_36_hsync h36_hsync Output 1
        add_interface_port hdmi_if hdmi_36_vsync h36_vsync Output 1
        add_interface_port hdmi_if hdmi_36_data_e h36_data_e Output 1
        add_interface_port hdmi_if hdmi_36_data h36_data Output 36
      }
    "16_BIT_EMBEDDED_SYNC" {
        add_interface hdmi_if conduit end
        set_interface_property hdmi_if associatedClock reference_clk
        add_interface_port hdmi_if hdmi_out_clk h_clk Output 1
        add_interface_port hdmi_if hdmi_16_es_data h16_es_data Output 16
      }
      "VGA_INTERFACE" {
        add_interface vga_if conduit end
        set_interface_property vga_if associatedClock reference_clk
        add_interface_port vga_if  vga_out_clk vga_clk      Output 1
        add_interface_port vga_if  vga_hsync   vga_hsync    Output 1
        add_interface_port vga_if  vga_vsync   vga_vsync    Output 1
        add_interface_port vga_if  vga_red     vga_red      Output 8
        add_interface_port vga_if  vga_green   vga_green    Output 8
        add_interface_port vga_if  vga_blue    vga_blue     Output 8
     }
  }
}

