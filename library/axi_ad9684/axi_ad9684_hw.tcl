###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_ad9684 {AXI AD9684 Interface} axi_ad9684_elab
set_module_property VALIDATION_CALLBACK info_param_validate

ad_ip_files axi_ad9684 [list \
    $ad_hdl_dir/library/common/ad_rst.v \
    $ad_hdl_dir/library/common/ad_datafmt.v \
    $ad_hdl_dir/library/common/ad_pnmon.v \
    $ad_hdl_dir/library/common/up_xfer_status.v \
    $ad_hdl_dir/library/common/up_xfer_cntrl.v \
    $ad_hdl_dir/library/common/up_clock_mon.v \
    $ad_hdl_dir/library/common/up_delay_cntrl.v \
    $ad_hdl_dir/library/common/up_adc_common.v \
    $ad_hdl_dir/library/common/up_adc_channel.v \
    $ad_hdl_dir/library/common/up_axi.v \
    axi_ad9684_pnmon.v \
    axi_ad9684_if.v \
    axi_ad9684_channel.v \
    axi_ad9684.v \
    $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
    axi_ad9684_constr.sdc] \
    axi_ad9684_fileset

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID DESCRIPTION "Instance ID"
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter FPGA_TECHNOLOGY INTEGER 0
set_parameter_property FPGA_TECHNOLOGY DEFAULT_VALUE 0
set_parameter_property FPGA_TECHNOLOGY DISPLAY_NAME FPGA_TECHNOLOGY
set_parameter_property FPGA_TECHNOLOGY TYPE INTEGER
set_parameter_property FPGA_TECHNOLOGY DESCRIPTION "Specify the FPGA device type"
set_parameter_property FPGA_TECHNOLOGY UNITS None
set_parameter_property FPGA_TECHNOLOGY HDL_PARAMETER true

add_parameter OR_STATUS INTEGER 1
set_parameter_property OR_STATUS DEFAULT_VALUE 1
set_parameter_property OR_STATUS DISPLAY_NAME OR_STATUS
set_parameter_property OR_STATUS DESCRIPTION "This parameter enables the OVER RANGE line at the physical interface"
set_parameter_property OR_STATUS UNITS None
set_parameter_property OR_STATUS HDL_PARAMETER true

adi_add_auto_fpga_spec_params

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# adc device interface

add_interface device_if conduit end
set_interface_property device_if associatedClock none
set_interface_property device_if associatedReset none

add_interface_port device_if adc_clk_in_p adc_clk_in_p Input 1
add_interface_port device_if adc_clk_in_n adc_clk_in_n Input 1
add_interface_port device_if adc_data_in_p adc_data_in_p Input 14
add_interface_port device_if adc_data_in_n adc_data_in_n Input 14

# dma interface

ad_interface clock adc_clk output 1
ad_interface reset adc_rst output 1 if_adc_clk

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0 adc_valid_0   valid   Output 1
add_interface_port adc_ch_0 adc_enable_0  enable  Output 1
add_interface_port adc_ch_0 adc_data_0   data    Output 32
set_interface_property adc_ch_0 associatedClock if_adc_clk
set_interface_property adc_ch_0 associatedReset none

add_interface adc_ch_1 conduit end
add_interface_port adc_ch_1 adc_valid_1   valid   Output 1
add_interface_port adc_ch_1 adc_enable_1  enable  Output 1
add_interface_port adc_ch_1 adc_data_1   data    Output 32
set_interface_property adc_ch_1 associatedClock if_adc_clk
set_interface_property adc_ch_1 associatedReset none

ad_interface signal adc_dovf input 1 ovf

# SERDES instances and configurations

add_hdl_instance ad_serdes_clk_core_rx intel_serdes
set_instance_parameter_value ad_serdes_clk_core_rx {MODE} {CLK}
set_instance_parameter_value ad_serdes_clk_core_rx {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_clk_core_rx {SERDES_FACTOR} {4}
set_instance_parameter_value ad_serdes_clk_core_rx {CLKIN_FREQUENCY} {500.0}

add_hdl_instance ad_serdes_in_core intel_serdes
set_instance_parameter_value ad_serdes_in_core {MODE} {IN}
set_instance_parameter_value ad_serdes_in_core {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_in_core {SERDES_FACTOR} {4}
set_instance_parameter_value ad_serdes_in_core {CLKIN_FREQUENCY} {500.0}

proc axi_ad9684_elab {} {

  set or_status [get_parameter_value OR_STATUS]

  if {$or_status == 1} {
    add_interface_port device_if adc_data_or_p adc_data_or_p Input 1
    add_interface_port device_if adc_data_or_n adc_data_or_n Input 1
  }
}

proc axi_ad9684_fileset { entityName } {

  ad_ip_modfile ad_serdes_in.v ad_serdes_in.v ad_serdes_in_core
  ad_ip_modfile ad_serdes_clk.v ad_serdes_clk.v ad_serdes_clk_core_rx

}

