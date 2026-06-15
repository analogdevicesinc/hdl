###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_adcfifo
adi_ip_files axi_adcfifo [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "axi_adcfifo_adc.v" \
  "axi_adcfifo_dma.v" \
  "axi_adcfifo_wr.v" \
  "axi_adcfifo_rd.v" \
  "axi_adcfifo.v" \
  "axi_adcfifo_constr.xdc" ]

adi_ip_properties_lite axi_adcfifo

ipx::infer_bus_interface {\
  axi_awvalid \
  axi_awid \
  axi_awburst \
  axi_awlock \
  axi_awcache \
  axi_awprot \
  axi_awqos \
  axi_awuser \
  axi_awlen \
  axi_awsize \
  axi_awaddr \
  axi_awready \
  axi_wvalid \
  axi_wdata \
  axi_wstrb \
  axi_wlast \
  axi_wuser \
  axi_wready \
  axi_bvalid \
  axi_bid \
  axi_bresp \
  axi_buser \
  axi_bready \
  axi_arvalid \
  axi_arid \
  axi_arburst \
  axi_arlock \
  axi_arcache \
  axi_arprot \
  axi_arqos \
  axi_aruser \
  axi_arlen \
  axi_arsize \
  axi_araddr \
  axi_arready \
  axi_rvalid \
  axi_rid \
  axi_ruser \
  axi_rresp \
  axi_rlast \
  axi_rdata \
  axi_rready} \
xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface axi_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface axi_resetn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]
ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces axi_clk \
  -of_objects [ipx::current_core]]
set_property value axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces axi_clk \
  -of_objects [ipx::current_core]]]

ipx::add_address_space axi [ipx::current_core]
set_property master_address_space_ref axi [ipx::get_bus_interfaces axi \
  -of_objects [ipx::current_core]]
set_property range 4294967296 [ipx::get_address_spaces axi \
  -of_objects [ipx::current_core]]
set_property width 512 [ipx::get_address_spaces axi \
  -of_objects [ipx::current_core]]

ipx::infer_bus_interface dma_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

