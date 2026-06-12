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

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_clock_monitor
adi_ip_files axi_clock_monitor [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_clock_monitor.v" ]

adi_ip_properties axi_clock_monitor

set cc [ipx::current_core]
set_property display_name {AXI Clock Monitor} $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/axi_clock_monitor/index.html} $cc

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 1} \
  [ipx::get_ports *_1* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 2} \
  [ipx::get_ports *_2* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 3} \
  [ipx::get_ports *_3* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 4} \
  [ipx::get_ports *_4* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 5} \
  [ipx::get_ports *_5* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 6} \
  [ipx::get_ports *_6* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 7} \
  [ipx::get_ports *_7* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 8 } \
  [ipx::get_ports *_8*  -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 9 } \
  [ipx::get_ports *_9*  -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 10} \
  [ipx::get_ports *_10* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 11} \
  [ipx::get_ports *_11* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 12} \
  [ipx::get_ports *_12* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 13} \
  [ipx::get_ports *_13* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 14} \
  [ipx::get_ports *_14* -of_objects $cc]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLOCKS')) > 15} \
  [ipx::get_ports *_15* -of_objects $cc]

adi_init_bd_tcl
adi_ip_bd axi_clock_monitor "bd/bd.tcl"

set_property widget {textEdit} [ipgui::get_guiparamspec -name "NUM_OF_CLOCKS" -component [ipx::current_core] ]
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16"
] [ipx::get_user_parameters NUM_OF_CLOCKS -of_objects $cc]

ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 $cc

adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::save_core $cc
