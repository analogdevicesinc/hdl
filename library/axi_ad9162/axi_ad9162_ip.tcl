# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9162
adi_ip_files axi_ad9162 [list \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "axi_ad9162_channel.v" \
  "axi_ad9162_core.v" \
  "axi_ad9162_if.v" \
  "axi_ad9162.v" ]

adi_ip_properties axi_ad9162

adi_init_bd_tcl
adi_ip_bd axi_ad9162 "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *dunf* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *tx_ready* -of_objects [ipx::current_core]]

ipx::infer_bus_interface tx_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]
