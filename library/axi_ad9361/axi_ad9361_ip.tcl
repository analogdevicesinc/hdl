# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_ad9361
adi_ip_files axi_ad9361 [list \
  "$ad_hdl_dir/library/common/ad_axi_ip_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_lvds_clk.v" \
  "$ad_hdl_dir/library/common/ad_lvds_in.v" \
  "$ad_hdl_dir/library/common/ad_lvds_out.v" \
  "$ad_hdl_dir/library/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/common/ad_tdd_control.v" \
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
  "axi_ad9361_constr.xdc" \
  "axi_ad9361_dev_if.v" \
  "axi_ad9361_rx_pnmon.v" \
  "axi_ad9361_rx_channel.v" \
  "axi_ad9361_rx.v" \
  "axi_ad9361_tx_channel.v" \
  "axi_ad9361_tx.v" \
  "axi_ad9361_tdd.v" \
  "axi_ad9361_tdd_if.v" \
  "axi_ad9361.v" ]

adi_ip_properties axi_ad9361
adi_ip_constraints axi_ad9361 [list \
  "axi_ad9361_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_axi_ip_constr.xdc" ]

set_property driver_value 0 [ipx::get_ports *dac_sync_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dunf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *gpio_in* -of_objects [ipx::current_core]]

ipx::remove_bus_interface rst [ipx::current_core]
ipx::remove_bus_interface clk [ipx::current_core]
ipx::remove_bus_interface l_clk [ipx::current_core]
ipx::remove_bus_interface delay_clk [ipx::current_core]

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF \
  -of_objects [ipx::get_bus_interfaces s_axi_aclk \
  -of_objects [ipx::current_core]]]

ipx::save_core [ipx::current_core]

