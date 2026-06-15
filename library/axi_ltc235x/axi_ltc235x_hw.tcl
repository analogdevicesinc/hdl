###############################################################################
## Copyright (C) 2023, 2026 Analog Devices, Inc. All rights reserved.
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
# ip

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_ltc235x {AXI LTC235x Interface} axi_ltc235x_elab
set_module_property AUTHOR {Geronimo, John Erasmus Mari F.}
set_module_property VALIDATION_CALLBACK info_param_validate
ad_ip_files axi_ltc235x [list \
    $ad_hdl_dir/library/common/up_axi.v \
    $ad_hdl_dir/library/common/up_adc_common.v \
    $ad_hdl_dir/library/common/ad_rst.v \
    $ad_hdl_dir/library/common/up_xfer_cntrl.v \
    $ad_hdl_dir/library/common/up_xfer_status.v \
    $ad_hdl_dir/library/common/up_clock_mon.v \
    $ad_hdl_dir/library/common/up_adc_channel.v \
    $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
    axi_ltc235x_cmos.v \
    axi_ltc235x_lvds.v \
    axi_ltc235x.v]
add_documentation_link "AXI_LTC235x IP core" https://wiki.analog.com/resources/fpga/docs/axi_ltc235x

ad_ip_parameter ID INTEGER 0
ad_ip_parameter XILINX_INTEL_N INTEGER 0
ad_ip_parameter LVDS_CMOS_N INTEGER 0
ad_ip_parameter LANE_0_ENABLE INTEGER 1
ad_ip_parameter LANE_1_ENABLE INTEGER 1
ad_ip_parameter LANE_2_ENABLE INTEGER 1
ad_ip_parameter LANE_3_ENABLE INTEGER 1
ad_ip_parameter LANE_4_ENABLE INTEGER 1
ad_ip_parameter LANE_5_ENABLE INTEGER 1
ad_ip_parameter LANE_6_ENABLE INTEGER 1
ad_ip_parameter LANE_7_ENABLE INTEGER 1
ad_ip_parameter EXTERNAL_CLK INTEGER 0
ad_ip_parameter LTC235X_FAMILY INTEGER 0
ad_ip_parameter NUM_CHANNELS INTEGER 8
ad_ip_parameter DATA_WIDTH INTEGER 18

adi_add_auto_fpga_spec_params

proc axi_ltc235x_elab {} {
  # interfaces

  # physical interface
  add_interface device_if conduit end
  # common
  add_interface_port device_if busy busy Input 1
  add_interface_port device_if lvds_cmos_n lvds_cmos_n Output 1

  set interface [get_parameter_value LVDS_CMOS_N]
  switch $interface {
    "0" { ;# cmos
        add_interface_port device_if scki scki Output 1
        add_interface_port device_if scko scko Input 1
        add_interface_port device_if sdi sdi Output 1
        add_interface_port device_if sdo sdo Input 8}
    "1" { ;# lvds
        add_interface_port device_if scki_p scki_p Output 1
        add_interface_port device_if scki_n scki_n Output 1
        add_interface_port device_if scko_p scko_p Input 1
        add_interface_port device_if scko_n scko_n Input 1
        add_interface_port device_if sdi_p sdi_p Output 1
        add_interface_port device_if sdi_n sdi_n Output 1
        add_interface_port device_if sdo_p sdo_p Input 1
        add_interface_port device_if sdo_n sdo_n Input 1}
  }

  # clock
  ad_interface clock external_clk input 1

  # axi
  ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

  # others
  ad_interface signal adc_dovf Input 1 ovf

  set num_channels [get_parameter_value NUM_CHANNELS]
  for {set i 0} {$i < $num_channels} {incr i} {
    add_interface adc_ch_$i conduit end
    add_interface_port adc_ch_$i adc_enable_$i enable Output 1
    add_interface_port adc_ch_$i adc_valid_$i valid Output 1
    add_interface_port adc_ch_$i adc_data_$i data Output 32

    set_interface_property adc_ch_$i associatedClock if_external_clk
    set_interface_property adc_ch_$i associatedReset ""
  }
}
