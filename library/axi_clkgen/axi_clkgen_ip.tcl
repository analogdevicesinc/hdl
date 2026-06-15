###############################################################################
## Copyright (C) 2014-2026 Analog Devices, Inc. All rights reserved.
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

adi_ip_create axi_clkgen
adi_ip_files axi_clkgen [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clkgen.v" \
  "$ad_hdl_dir/library/scripts/adi_xilinx_device_info_enc.tcl" \
  "bd/bd.tcl" \
  "axi_clkgen.v" ]

set_property used_in_simulation false [get_files ./bd/bd.tcl]
set_property used_in_simulation false [get_files $ad_hdl_dir/library/scripts/adi_xilinx_device_info_enc.tcl]
set_property used_in_synthesis false [get_files ./bd/bd.tcl]
set_property used_in_synthesis false [get_files $ad_hdl_dir/library/scripts/adi_xilinx_device_info_enc.tcl]

adi_ip_properties axi_clkgen
adi_ip_bd axi_clkgen "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_clkgen} [ipx::current_core]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk2 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_0 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_1 xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set param [ipx::add_user_parameter ENABLE_CLKIN2 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKIN2} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock input} \
	widget {checkBox} \
] $param

set param [ipx::add_user_parameter ENABLE_CLKOUT1 $cc]
set_property -dict {value_resolve_type user value_format bool value false} $param

set param [ipgui::add_param -name {ENABLE_CLKOUT1} -component $cc -parent $page0]
set_property -dict [list \
	display_name {Enable secondary clock output} \
	widget {checkBox} \
] $param

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

set_property enablement_tcl_expr {$ENABLE_CLKIN2} [ipx::get_user_parameters CLKIN2_PERIOD -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_DIV -of_objects $cc]
set_property enablement_tcl_expr {$ENABLE_CLKOUT1} [ipx::get_user_parameters CLK1_PHASE -of_objects $cc]

adi_set_ports_dependency clk2 ENABLE_CLKIN2 0
adi_set_ports_dependency clk_1 ENABLE_CLKOUT1

ipx::create_xgui_files $cc
ipx::save_core $cc
