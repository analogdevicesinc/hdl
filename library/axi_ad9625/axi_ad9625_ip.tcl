# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9625
adi_ip_files axi_ad9625 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mem.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/ad_xcvr_rx_if.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_ad9625_pnmon.v" \
  "axi_ad9625_channel.v" \
  "axi_ad9625_if.v" \
  "axi_ad9625.v" ]

adi_ip_properties axi_ad9625

adi_init_bd_tcl
adi_ip_bd axi_ad9625 "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *raddr_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *rx_valid* -of_objects [ipx::current_core]]

ipx::infer_bus_interface rx_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

