###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad777x
set_module_property DESCRIPTION "AXI AD777x IP"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad777x

# source files

ad_ip_files axi_ad777x [list\
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  $ad_hdl_dir/library/intel/common/ad_dcfilter.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/ad_datafmt.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_delay_cntrl.v \
  $ad_hdl_dir/library/common/up_adc_channel.v \
  $ad_hdl_dir/library/common/up_adc_common.v \
  axi_ad777x_if.v \
  axi_ad777x.v ]

# IP parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME "ID"
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

  # adc clock  interface

add_interface adc_if conduit end
set_interface_property adc_if associatedClock clk_in
add_interface_port adc_if  ready_in        adc_ready       Input  1
add_interface_port adc_if  data_in         adc_data_in     Input  4
add_interface_port adc_if  sync_adc_miso   sync_adc_miso   Input  1
add_interface_port adc_if  sync_adc_mosi   sync_adc_mosi   Output 1

ad_interface signal clk_in              input  1
ad_interface clock  adc_clk             output 1
ad_interface reset  adc_reset           output 1 
set_interface_property if_adc_reset associatedClock if_adc_clk
ad_interface signal adc_crc_ch_mismatch output 8 
ad_interface signal adc_dovf            input  1 ovf

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0 adc_enable_0 enable Output 1
add_interface_port adc_ch_0 adc_data_0 data Output 32
add_interface_port adc_ch_0 adc_valid_0 valid Output 1
set_interface_property adc_ch_0 associatedClock if_adc_clk 
set_interface_property adc_ch_0 associatedReset none

add_interface adc_ch_1 conduit end
add_interface_port adc_ch_1 adc_enable_1 enable Output 1
add_interface_port adc_ch_1 adc_data_1 data Output 32
add_interface_port adc_ch_1 adc_valid_1 valid Output 1
set_interface_property adc_ch_1 associatedClock if_adc_clk 
set_interface_property adc_ch_1 associatedReset none

add_interface adc_ch_2 conduit end
add_interface_port adc_ch_2 adc_enable_2 enable Output 1
add_interface_port adc_ch_2 adc_data_2 data Output 32
add_interface_port adc_ch_2 adc_valid_2 valid Output 1
set_interface_property adc_ch_2 associatedClock if_adc_clk 
set_interface_property adc_ch_2 associatedReset none

add_interface adc_ch_3 conduit end
add_interface_port adc_ch_3 adc_enable_3 enable Output 1
add_interface_port adc_ch_3 adc_data_3 data Output 32
add_interface_port adc_ch_3 adc_valid_3 valid Output 1
set_interface_property adc_ch_3 associatedClock if_adc_clk 
set_interface_property adc_ch_3 associatedReset none

add_interface adc_ch_4 conduit end
add_interface_port adc_ch_4 adc_enable_4 enable Output 1
add_interface_port adc_ch_4 adc_data_4 data Output 32
add_interface_port adc_ch_4 adc_valid_4 valid Output 1
set_interface_property adc_ch_4 associatedClock if_adc_clk 
set_interface_property adc_ch_4 associatedReset none

add_interface adc_ch_5 conduit end
add_interface_port adc_ch_5 adc_enable_5 enable Output 1
add_interface_port adc_ch_5 adc_data_5 data Output 32
add_interface_port adc_ch_5 adc_valid_5 valid Output 1
set_interface_property adc_ch_5 associatedClock if_adc_clk 
set_interface_property adc_ch_5 associatedReset none

add_interface adc_ch_6 conduit end
add_interface_port adc_ch_6 adc_enable_6 enable Output 1
add_interface_port adc_ch_6 adc_data_6 data Output 32
add_interface_port adc_ch_6 adc_valid_6 valid Output 1
set_interface_property adc_ch_6 associatedClock if_adc_clk 
set_interface_property adc_ch_6 associatedReset none

add_interface adc_ch_7 conduit end
add_interface_port adc_ch_7 adc_enable_7 enable Output 1
add_interface_port adc_ch_7 adc_data_7 data Output 32
add_interface_port adc_ch_7 adc_valid_7 valid Output 1
set_interface_property adc_ch_7 associatedClock if_adc_clk 
set_interface_property adc_ch_7 associatedReset none
