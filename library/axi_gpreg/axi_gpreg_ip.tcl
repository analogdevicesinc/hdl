###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
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

adi_ip_create axi_gpreg
adi_ip_files axi_gpreg [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_gpreg_io.v" \
  "axi_gpreg_constr.ttcl" \
  "axi_gpreg_clock_mon.v" \
  "axi_gpreg.v" ]
  
set_property FILE_TYPE SystemVerilog [get_files "axi_gpreg.v"]

adi_ip_properties axi_gpreg
adi_ip_ttcl axi_gpreg "axi_gpreg_constr.ttcl"

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 0} \
  [ipx::get_ports up_gp_*_0 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 1} \
  [ipx::get_ports up_gp_*_1 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 2} \
  [ipx::get_ports up_gp_*_2 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 3} \
  [ipx::get_ports up_gp_*_3 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 4} \
  [ipx::get_ports up_gp_*_4 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 5} \
  [ipx::get_ports up_gp_*_5 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 6} \
  [ipx::get_ports up_gp_*_6 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_IO')) > 7} \
  [ipx::get_ports up_gp_*_7 -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 0} \
  [ipx::get_ports d_clk_0 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 1} \
  [ipx::get_ports d_clk_1 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 2} \
  [ipx::get_ports d_clk_2 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 3} \
  [ipx::get_ports d_clk_3 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 4} \
  [ipx::get_ports d_clk_4 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 5} \
  [ipx::get_ports d_clk_5 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 6} \
  [ipx::get_ports d_clk_6 -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CLK_MONS')) > 7} \
  [ipx::get_ports d_clk_7 -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

