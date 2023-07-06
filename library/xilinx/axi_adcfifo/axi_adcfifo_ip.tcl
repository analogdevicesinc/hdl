###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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

