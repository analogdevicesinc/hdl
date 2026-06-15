###############################################################################
## Copyright (C) 2016-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_ad9122 {AXI AD9122 Interface}
set_module_property VALIDATION_CALLBACK info_param_validate

ad_ip_files axi_ad9122 [list \
    $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v \
    $ad_hdl_dir/library/common/ad_dds_sine_cordic.v \
    $ad_hdl_dir/library/common/ad_dds_sine.v \
    $ad_hdl_dir/library/common/ad_dds_2.v \
    $ad_hdl_dir/library/common/ad_dds_1.v \
    $ad_hdl_dir/library/common/ad_dds.v \
    $ad_hdl_dir/library/intel/common/ad_mul.v \
    $ad_hdl_dir/library/common/ad_rst.v \
    $ad_hdl_dir/library/common/up_axi.v \
    $ad_hdl_dir/library/common/up_xfer_cntrl.v \
    $ad_hdl_dir/library/common/up_xfer_status.v \
    $ad_hdl_dir/library/common/up_clock_mon.v \
    $ad_hdl_dir/library/common/up_dac_common.v \
    $ad_hdl_dir/library/common/up_dac_channel.v \
    axi_ad9122_channel.v \
    axi_ad9122_core.v \
    axi_ad9122_if.v \
    axi_ad9122.v \
    $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
    axi_ad9122_constr.sdc] \
    axi_ad9122_fileset

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter FPGA_TECHNOLOGY INTEGER 0
set_parameter_property FPGA_TECHNOLOGY DEFAULT_VALUE 0
set_parameter_property FPGA_TECHNOLOGY DISPLAY_NAME FPGA_TECHNOLOGY
set_parameter_property FPGA_TECHNOLOGY TYPE INTEGER
set_parameter_property FPGA_TECHNOLOGY UNITS None
set_parameter_property FPGA_TECHNOLOGY HDL_PARAMETER true

adi_add_auto_fpga_spec_params

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# dac device interface

add_interface device_if conduit end
set_interface_property device_if associatedClock none
set_interface_property device_if associatedReset none

add_interface_port device_if dac_clk_in_p dac_clk_in_p Input 1
add_interface_port device_if dac_clk_in_n dac_clk_in_n Input 1
add_interface_port device_if dac_clk_out_p dac_clk_out_p Output 1
add_interface_port device_if dac_clk_out_n dac_clk_out_n Output 1
add_interface_port device_if dac_frame_out_p dac_frame_out_p Output 1
add_interface_port device_if dac_frame_out_n dac_frame_out_n Output 1
add_interface_port device_if dac_data_out_p dac_data_out_p Output 16
add_interface_port device_if dac_data_out_n dac_data_out_n Output 16

add_interface_port device_if dac_sync_out dac_sync_out Output 1
add_interface_port device_if dac_sync_in  dac_sync_in  Input 1

# dma interface

ad_interface clock dac_div_clk Output 1

add_interface dac_ch_0 conduit end
add_interface_port dac_ch_0 dac_valid_0   valid  Output 1
add_interface_port dac_ch_0 dac_enable_0  enable Output 1
add_interface_port dac_ch_0 dac_ddata_0   data   Input 64
set_interface_property dac_ch_0 associatedClock if_dac_div_clk
set_interface_property dac_ch_0 associatedReset none

add_interface dac_ch_1 conduit end
add_interface_port dac_ch_1 dac_valid_1   valid  Output 1
add_interface_port dac_ch_1 dac_enable_1  enable Output 1
add_interface_port dac_ch_1 dac_ddata_1   data   Input 64
set_interface_property dac_ch_1 associatedClock if_dac_div_clk
set_interface_property dac_ch_1 associatedReset none

ad_interface signal dac_dunf input 1 unf

# SERDES instances and configurations

add_hdl_instance ad_serdes_clk_core_tx intel_serdes
set_instance_parameter_value ad_serdes_clk_core_tx {MODE} {CLK}
set_instance_parameter_value ad_serdes_clk_core_tx {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_clk_core_tx {SERDES_FACTOR} {8}
set_instance_parameter_value ad_serdes_clk_core_tx {CLKIN_FREQUENCY} {500.0}

add_hdl_instance ad_serdes_out_core intel_serdes
set_instance_parameter_value ad_serdes_out_core {MODE} {OUT}
set_instance_parameter_value ad_serdes_out_core {DDR_OR_SDR_N} {1}
set_instance_parameter_value ad_serdes_out_core {SERDES_FACTOR} {8}
set_instance_parameter_value ad_serdes_out_core {CLKIN_FREQUENCY} {500.0}

proc axi_ad9122_fileset { entityName } {

  ad_ip_modfile ad_serdes_out.v ad_serdes_out.v ad_serdes_out_core
  ad_ip_modfile ad_serdes_clk.v ad_serdes_clk.v ad_serdes_clk_core_tx

}

