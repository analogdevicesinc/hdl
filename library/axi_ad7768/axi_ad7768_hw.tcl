###############################################################################
## Copyright (C) 2022-2023, 2026 Analog Devices, Inc. All rights reserved.
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

package require qsys
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad7768
set_module_property DESCRIPTION "AXI AD7768 IP core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad7768
set_module_property ELABORATION_CALLBACK create_ports
# source files

ad_ip_files axi_ad7768 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "axi_ad7768_if.v" \
  "axi_ad7768.v"]

# IP parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME "ID"
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true


set group "General Configuration"

ad_ip_parameter NUM_CHANNELS INTEGER 8 true [list \
  DISPLAY_NAME "Number of channels" \
  DISPLAY_UNITS "channels" \
  ALLOWED_RANGES {4 8} \
  GROUP $group \
]

# AXI4 Memory Mapped Interface

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 15

# ad7768_if and axi_gpreg ports

ad_interface signal adc_dovf            input  1 ovf
ad_interface signal clk_in              input  1
ad_interface signal ready_in            input  1
ad_interface signal data_in             input  8

ad_interface reset  adc_reset           output 1 
ad_interface clock  adc_clk             output  1
ad_interface signal adc_sync            output  1 sync
ad_interface signal adc_valid           output  1  valid
ad_interface signal adc_data            output  32 data

set_interface_property if_adc_reset associatedClock if_adc_clk

proc create_ports {} {
set num_channels [get_parameter_value "NUM_CHANNELS"]
set samples_per_channel 1
set sample_data_width 32
set channel_data_width [expr $sample_data_width * $samples_per_channel]

for {set n 0} {$n < $num_channels} {incr n} {
add_interface adc_ch_$n conduit end
add_interface_port adc_ch_$n adc_enable_$n enable Output 1
add_interface_port adc_ch_$n adc_data_$n data Output $sample_data_width
add_interface_port adc_ch_$n adc_valid_$n valid Output 1
set_interface_property adc_ch_$n associatedClock if_adc_clk 
set_interface_property adc_ch_$n associatedReset none
}

}

