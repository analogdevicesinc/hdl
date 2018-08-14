# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9361
adi_ip_files axi_ad9361 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_out.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/common/ad_tdd_control.v" \
  "$ad_hdl_dir/library/common/ad_pps_receiver.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/up_tdd_cntrl.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_pps_receiver_constr.ttcl" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_ad9361_constr.xdc" \
  "xilinx/axi_ad9361_lvds_if.v" \
  "xilinx/axi_ad9361_cmos_if.v" \
  "axi_ad9361_rx_pnmon.v" \
  "axi_ad9361_rx_channel.v" \
  "axi_ad9361_rx.v" \
  "axi_ad9361_tx_channel.v" \
  "axi_ad9361_tx.v" \
  "axi_ad9361_tdd.v" \
  "axi_ad9361_tdd_if.v" \
  "axi_ad9361.v" ]

adi_ip_properties axi_ad9361
adi_ip_ttcl axi_ad9361 "$ad_hdl_dir/library/common/ad_pps_receiver_constr.ttcl"

adi_init_bd_tcl
adi_ip_bd axi_ad9361 "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *rx_clk_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *rx_frame_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *rx_data_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dac_sync_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dunf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *gpio_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *gps_pps* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CMOS_OR_LVDS_N')) == 0} \
  [ipx::get_ports rx_clk_in_p     -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_clk_in_n     -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_frame_in_p   -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_frame_in_n   -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_data_in_p    -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_data_in_n    -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_clk_out_p    -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_clk_out_n    -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_frame_out_p  -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_frame_out_n  -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_data_out_p   -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_data_out_n   -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.CMOS_OR_LVDS_N')) == 1} \
  [ipx::get_ports rx_clk_in       -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_frame_in     -of_objects [ipx::current_core]] \
  [ipx::get_ports rx_data_in      -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_clk_out      -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_frame_out    -of_objects [ipx::current_core]] \
  [ipx::get_ports tx_data_out     -of_objects [ipx::current_core]]

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface l_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
set reset_intf [ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
set_property value "ACTIVE_HIGH" $reset_polarity

ipx::infer_bus_interface gps_pps_irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

