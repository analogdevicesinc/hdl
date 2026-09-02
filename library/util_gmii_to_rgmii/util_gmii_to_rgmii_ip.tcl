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

adi_ip_create util_gmii_to_rgmii
adi_ip_files util_gmii_to_rgmii [list \
  "mdc_mdio.v" \
  "util_gmii_to_rgmii_constr.xdc" \
  "util_gmii_to_rgmii.v" ]

adi_ip_properties_lite util_gmii_to_rgmii

ipx::infer_bus_interface {gmii_tx_clk gmii_txd gmii_tx_en gmii_tx_er gmii_crs gmii_col gmii_rx_clk gmii_rxd gmii_rx_dv gmii_rx_er} xilinx.com:interface:gmii_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface {rgmii_td rgmii_tx_ctl rgmii_txc rgmii_rd rgmii_rx_ctl rgmii_rxc} xilinx.com:interface:rgmii_rtl:1.0 [ipx::current_core]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.IODELAY_CTRL')) = 1} \
  [ipx::get_ports idelayctrl_clk -of_objects [ipx::current_core]]

ipx::infer_bus_interface clk_20m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_25m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface clk_125m xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface idelayctrl_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface reset xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]
