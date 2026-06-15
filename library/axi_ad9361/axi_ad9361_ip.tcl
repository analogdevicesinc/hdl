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
source ../../scripts/adi_env.tcl
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
adi_ip_ttcl axi_ad9361 "../common/ad_pps_receiver_constr.ttcl"

adi_init_bd_tcl
adi_ip_bd axi_ad9361 "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad9361} [ipx::current_core]

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

ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "RX_NODPA" -component [ipx::current_core]]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

