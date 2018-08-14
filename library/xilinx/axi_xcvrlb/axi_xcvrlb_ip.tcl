
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

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

ipx::save_core [ipx::current_core]

