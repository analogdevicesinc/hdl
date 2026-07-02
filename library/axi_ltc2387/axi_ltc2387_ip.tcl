###############################################################################
## Copyright (C) 2022-2026 Analog Devices, Inc. All rights reserved.
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

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ltc2387

adi_ip_files axi_ltc2387 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "axi_ltc2387_if.v" \
  "axi_ltc2387_constr.xdc" \
  "axi_ltc2387_channel.v" \
  "axi_ltc2387.v" ]

adi_ip_properties axi_ltc2387

ipx::infer_bus_interface ref_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface dco_p xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface dco_n xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

ipx::add_user_parameter ADC_RES $cc
set_property value_resolve_type user [ipx::get_user_parameters ADC_RES -of_objects $cc]
ipgui::add_param -name "ADC_RES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "ADC resolution" \
  "tooltip" "ADC_RES" \
  "widget" "radioGroup" \
  "layout" "horizontal" \
] [ipgui::get_guiparamspec -name "ADC_RES" -component $cc]

set_property -dict [list \
  "value_format" "long" \
  "value_validation_type" "list" \
  "value_validation_list" "16 18" \
] [ipx::get_user_parameters ADC_RES -of_objects $cc]

ipx::add_user_parameter OUT_RES $cc
set_property value_resolve_type user [ipx::get_user_parameters OUT_RES -of_objects $cc]
ipgui::add_param -name "OUT_RES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Output data width" \
  "tooltip" "OUT_RES" \
  "widget" "radioGroup" \
  "layout" "horizontal" \
] [ipgui::get_guiparamspec -name "OUT_RES" -component $cc]

set_property -dict [list \
  "value_format" "long" \
  "value_validation_type" "list" \
  "value_validation_list" "16 32" \
] [ipx::get_user_parameters OUT_RES -of_objects $cc]

ipx::add_user_parameter TWOLANES $cc
set_property value_resolve_type user [ipx::get_user_parameters TWOLANES -of_objects $cc]
ipgui::add_param -name "TWOLANES" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Lane mode" \
  "tooltip" "TWOLANES" \
  "widget" "radioGroup" \
  "layout" "horizontal" \
] [ipgui::get_guiparamspec -name "TWOLANES" -component $cc]

set_property -dict [list \
  "value_format" "long" \
  "value_validation_type" "list" \
  "value_validation_list" "0 1" \
] [ipx::get_user_parameters TWOLANES -of_objects $cc]

# if TWOLANES=0, disable and tie to GND, ports db_p, db_n
adi_set_ports_dependency "db_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.TWOLANES')) == 1)"
adi_set_ports_dependency "db_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.TWOLANES')) == 1)"

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects $cc]

#adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::update_checksums $cc
ipx::save_core $cc
