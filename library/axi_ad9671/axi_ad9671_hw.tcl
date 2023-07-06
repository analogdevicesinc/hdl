###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad9671
set_module_property DESCRIPTION "AXI AD9671 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9671
set_module_property VALIDATION_CALLBACK info_param_validate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9671
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_pnmon.v           VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file ad_datafmt.v         VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_adc_common.v      VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v     VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file ad_xcvr_rx_if.v      VERILOG PATH $ad_hdl_dir/library/common/ad_xcvr_rx_if.v
add_fileset_file ad_mem.v             VERILOG PATH $ad_hdl_dir/library/common/ad_mem.v
add_fileset_file axi_ad9671_pnmon.v   VERILOG PATH axi_ad9671_pnmon.v
add_fileset_file axi_ad9671_if.v      VERILOG PATH axi_ad9671_if.v
add_fileset_file axi_ad9671_channel.v VERILOG PATH axi_ad9671_channel.v
add_fileset_file axi_ad9671.v         VERILOG PATH axi_ad9671.v TOP_LEVEL_FILE
add_fileset_file up_xfer_cntrl_constr.sdc   SDC PATH  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc
add_fileset_file up_xfer_status_constr.sdc  SDC PATH  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc
add_fileset_file up_clock_mon_constr.sdc    SDC PATH  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc
add_fileset_file up_rst_constr.sdc          SDC PATH  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter QUAD_OR_DUAL_N INTEGER 0
set_parameter_property QUAD_OR_DUAL_N DEFAULT_VALUE 1
set_parameter_property QUAD_OR_DUAL_N DISPLAY_NAME QUAD_OR_DUAL_N
set_parameter_property QUAD_OR_DUAL_N UNITS None
set_parameter_property QUAD_OR_DUAL_N HDL_PARAMETER true

adi_add_auto_fpga_spec_params

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# transceiver interface

ad_interface clock   rx_clk        input   1
ad_interface signal  rx_sof        input   4 export

add_interface if_rx_data avalon_streaming sink
add_interface_port if_rx_data rx_data  data  input 64*QUAD_OR_DUAL_N+64
add_interface_port if_rx_data rx_valid valid input 1
add_interface_port if_rx_data rx_ready ready output 1
set_interface_property if_rx_data associatedClock if_rx_clk
set_interface_property if_rx_data dataBitsPerSymbol 64

add_interface if_sync conduit end
set_interface_property if_sync associatedClock if_clk
add_interface_port if_sync adc_sync_in sync_in Input 1
add_interface_port if_sync adc_sync_out sync_out Output 1
add_interface_port if_sync adc_raddr_in raddr_in Input 4
add_interface_port if_sync adc_raddr_out raddr_out Output 4

# dma interface

ad_interface clock   adc_clk     output  1
ad_interface reset   adc_rst     output  1 if_adc_clk

add_interface adc_ch conduit end
add_interface_port adc_ch adc_enable  enable  Output 8
add_interface_port adc_ch adc_valid   valid   Output 8
add_interface_port adc_ch adc_data    data    Output 128

set_interface_property adc_ch associatedClock if_rx_clk
set_interface_property adc_ch associatedReset none

ad_interface signal  adc_dovf      input   1     ovf

