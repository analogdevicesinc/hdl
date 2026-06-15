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

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_xcvrlb
adi_ip_files axi_xcvrlb [list \
  "$ad_hdl_dir/library/xilinx/util_adxcvr/util_adxcvr_xch.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_xcvrlb_constr.xdc" \
  "axi_xcvrlb_1.v" \
  "axi_xcvrlb.v" ]

adi_ip_properties_lite axi_xcvrlb

adi_init_bd_tcl
adi_ip_bd axi_xcvrlb "bd/bd.tcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

ipx::remove_all_bus_interface [ipx::current_core]

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects [ipx::current_core]]

ipx::infer_bus_interface {\
  s_axi_awvalid \
  s_axi_awaddr \
  s_axi_awprot \
  s_axi_awready \
  s_axi_wvalid \
  s_axi_wdata \
  s_axi_wstrb \
  s_axi_wready \
  s_axi_bvalid \
  s_axi_bresp \
  s_axi_bready \
  s_axi_arvalid \
  s_axi_araddr \
  s_axi_arprot \
  s_axi_arready \
  s_axi_rvalid \
  s_axi_rdata \
  s_axi_rresp \
  s_axi_rready} \
xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface s_axi_aresetn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

ipx::add_memory_map {s_axi} [ipx::current_core]
set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]
ipx::add_address_block {axi_lite} [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]
set_property range {1024} [ipx::get_address_blocks axi_lite \
  -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]

adi_add_auto_fpga_spec_params

ipx::save_core [ipx::current_core]
