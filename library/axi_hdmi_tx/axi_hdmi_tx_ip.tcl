###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_hdmi_tx
adi_ip_files axi_hdmi_tx [list \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_csc.v" \
  "$ad_hdl_dir/library/common/ad_csc_RGB2CrYCb.v" \
  "$ad_hdl_dir/library/common/ad_ss_444to422.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_hdmi_tx.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_hdmi_tx_constr.xdc" \
  "axi_hdmi_tx_vdma.v" \
  "axi_hdmi_tx_es.v" \
  "axi_hdmi_tx_core.v" \
  "axi_hdmi_tx.v" ]

adi_ip_properties axi_hdmi_tx

adi_init_bd_tcl
adi_ip_bd axi_hdmi_tx "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_hdmi_tx} [ipx::current_core]

set_property driver_value 0 [ipx::get_ports *hsync* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *vsync* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *data* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *es_data* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *red* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *green* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *blue* -of_objects [ipx::current_core]]

set_property driver_value 0 [ipx::get_ports *vdma_end_of_frame* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *vdma_valid* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *vdma_data* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *vdma_ready* -of_objects [ipx::current_core]]

set_property value_format string [ipx::get_user_parameters INTERFACE -of_objects [ipx::current_core]]
set_property value_format string [ipx::get_hdl_parameters INTERFACE -of_objects [ipx::current_core]]
set_property value_validation_list {16_BIT 24_BIT 36_BIT 16_BIT_EMBEDDED_SYNC VGA_INTERFACE} \
  [ipx::get_user_parameters INTERFACE -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "16_BIT" || spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "24_BIT" || spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "36_BIT" || spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "16_BIT_EMBEDDED_SYNC" } \
  [ipx::get_ports *hdmi_out_clk* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "16_BIT"} \
  [ipx::get_ports *hdmi_16* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "24_BIT"} \
  [ipx::get_ports *hdmi_24* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "36_BIT"} \
  [ipx::get_ports *hdmi_36* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "16_BIT_EMBEDDED_SYNC"} \
  [ipx::get_ports *hdmi_16_es_data* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INTERFACE')) == "VGA_INTERFACE"} \
  [ipx::get_ports *vga* -of_objects [ipx::current_core]]

adi_add_bus "s_axis" "slave" \
         "xilinx.com:interface:axis_rtl:1.0" \
         "xilinx.com:interface:axis:1.0" \
         [list {"vdma_ready" "TREADY"} \
           {"vdma_valid" "TVALID"} \
           {"vdma_data" "TDATA"} \
           {"vdma_end_of_frame" "TLAST"} ]

ipx::infer_bus_interface reference_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface hdmi_out_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface vga_out_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface vdma_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::associate_bus_interfaces -busif s_axis -clock vdma_clk [ipx::current_core]


adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

