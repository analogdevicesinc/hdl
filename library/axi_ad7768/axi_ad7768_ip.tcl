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

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad7768

adi_ip_files axi_ad7768 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_ad7768_if.v" \
  "axi_ad7768.v" ]

adi_ip_properties axi_ad7768

adi_init_bd_tcl
adi_ip_bd axi_ad7768 "bd/bd.tcl"

set cc [ipx::current_core]

set_property company_url {https://wiki.analog.com/resources/fpga/docs/ad7768} $cc


set_property driver_value 0 [ipx::get_ports *dovf* -of_objects $cc]
set_property driver_value 0 [ipx::get_ports *adc* -of_objects  $cc]

set_property -dict [list \
	value_validation_type list \
	value_validation_list {4 8} \
 ] [ipx::get_user_parameters NUM_CHANNELS -of_objects $cc]

set_property enablement_dependency { $NUM_CHANNELS == 8 } \
  [ipx::get_ports *_4   -of_objects $cc] \
  [ipx::get_ports *_5   -of_objects $cc] \
  [ipx::get_ports *_6   -of_objects $cc] \
  [ipx::get_ports *_7   -of_objects $cc]
 

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface clk_in xilinx.com:signal:clock_rtl:1.0 $cc
set reset_intf [ipx::infer_bus_interface adc_reset xilinx.com:signal:reset_rtl:1.0 $cc ]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
set_property value "ACTIVE_HIGH" $reset_polarity

adi_add_auto_fpga_spec_params
ipx::create_xgui_files $cc

ipx::save_core $cc
