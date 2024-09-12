###############################################################################
## Copyright (C) 2020-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_adrv9001
adi_ip_files axi_adrv9001 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_out.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_tdd_cntrl.v" \
  "$ad_hdl_dir/library/common/ad_tdd_control.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/util_ext_sync.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/ad_pngen.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_event.v" \
  "adrv9001_rx.v" \
  "adrv9001_tx.v" \
  "adrv9001_pack.v" \
  "adrv9001_aligner4.v" \
  "adrv9001_aligner8.v" \
  "adrv9001_rx_link.v" \
  "adrv9001_tx_link.v" \
  "axi_adrv9001_rx.v" \
  "axi_adrv9001_rx_channel.v" \
  "axi_adrv9001_if.v" \
  "axi_adrv9001_tx.v" \
  "axi_adrv9001_tx_channel.v" \
  "axi_adrv9001_core.v" \
  "axi_adrv9001_sync.v" \
  "axi_adrv9001_sync_ctrl.v" \
  "axi_adrv9001_constr.xdc" \
  "axi_adrv9001_constr.ttcl" \
  "axi_adrv9001_tdd.v" \
  "axi_adrv9001.v" ]

adi_ip_properties axi_adrv9001

adi_init_bd_tcl
adi_ip_bd axi_adrv9001 "bd/bd.tcl"

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface adc_1_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface adc_2_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface dac_1_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface dac_2_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface adc_1_rst xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface adc_2_rst xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface dac_1_rst xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface dac_2_rst xilinx.com:signal:reset_rtl:1.0 $cc

ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces adc_1_rst -of_objects $cc]
ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces adc_2_rst -of_objects $cc]
ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces dac_1_rst -of_objects $cc]
ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces dac_2_rst -of_objects $cc]

## Customize XGUI layout

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

ipgui::add_param -name "EXT_SYNC" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "External sync" \
  "tooltip" "NOTE: If active enables the external synchronization features for Rx and Tx. The external sync signals must be synchronous with to ref_clk" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXT_SYNC" -component $cc]

ipgui::add_param -name "USE_RX_CLK_FOR_TX1" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Tx1 SSI ref clock source" \
] [ipgui::get_guiparamspec -name "USE_RX_CLK_FOR_TX1" -component $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Tx1 SSI ref clk" "0" \
    "Rx1 SSI ref clk" "1" \
    "Rx2 SSI ref clk" "2" \
  } \
] \
[ipx::get_user_parameters USE_RX_CLK_FOR_TX1 -of_objects $cc]

ipgui::add_param -name "USE_RX_CLK_FOR_TX2" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Tx2 SSI ref clock source" \
] [ipgui::get_guiparamspec -name "USE_RX_CLK_FOR_TX2" -component $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Tx2 SSI ref clk" "0" \
    "Rx1 SSI ref clk" "1" \
    "Rx2 SSI ref clk" "2" \
  } \
] \
[ipx::get_user_parameters USE_RX_CLK_FOR_TX2 -of_objects $cc]

ipgui::add_param -name "DISABLE_RX1_SSI" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Disable Rx1 SSI" \
  "tooltip" "NOTE: If checked, it disables Rx1 source synchronous interface" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "DISABLE_RX1_SSI" -component $cc]

set_property value_format bool [ipx::get_user_parameters DISABLE_RX1_SSI -of_objects $cc]
set_property value_format bool [ipx::get_hdl_parameters DISABLE_RX1_SSI -of_objects $cc]
set_property value false [ipx::get_user_parameters DISABLE_RX1_SSI -of_objects $cc]
set_property value false [ipx::get_hdl_parameters DISABLE_RX1_SSI -of_objects $cc]
set_property enablement_tcl_expr {expr {[info exists USE_RX_CLK_FOR_TX1] ?
                                        ($USE_RX_CLK_FOR_TX1 == 1 || $USE_RX_CLK_FOR_TX2 == 1) ? 0 : 1 : 1}
} [ipx::get_user_parameters DISABLE_RX1_SSI -of_objects $cc]
set_property value_tcl_expr {expr {[info exists USE_RX_CLK_FOR_TX1] ?
                                   ($USE_RX_CLK_FOR_TX1 == 1 || $USE_RX_CLK_FOR_TX2 == 1 )? 0 : 1 : 1}
} [ipx::get_user_parameters DISABLE_RX1_SSI -of_objects $cc]

ipgui::add_param -name "EN_RX_MCS_TO_STRB_M" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Enable 6'th MCS to Rx strobe measurment" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EN_RX_MCS_TO_STRB_M" -component $cc]

ipgui::add_param -name "DISABLE_RX2_SSI" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Disable Rx2 SSI" \
  "tooltip" "NOTE: If checked, it disables Rx2 source synchronous interface" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "DISABLE_RX2_SSI" -component $cc]

set_property value_format bool [ipx::get_user_parameters DISABLE_RX2_SSI -of_objects $cc]
set_property value_format bool [ipx::get_hdl_parameters DISABLE_RX2_SSI -of_objects $cc]
set_property value false [ipx::get_user_parameters DISABLE_RX2_SSI -of_objects $cc]
set_property value false [ipx::get_hdl_parameters DISABLE_RX2_SSI -of_objects $cc]
set_property enablement_tcl_expr {expr {[info exists USE_RX_CLK_FOR_TX1] ?
                                        ($USE_RX_CLK_FOR_TX1 == 2 || $USE_RX_CLK_FOR_TX2 == 2) ? 0 : 1 : 1}
} [ipx::get_user_parameters DISABLE_RX2_SSI -of_objects $cc]
set_property value_tcl_expr {expr {[info exists USE_RX_CLK_FOR_TX1] ?
                                   ($USE_RX_CLK_FOR_TX1 == 2 || $USE_RX_CLK_FOR_TX2 == 2) ? 0 : 1 : 1}
} [ipx::get_user_parameters DISABLE_RX2_SSI -of_objects $cc]

ipgui::add_param -name "DISABLE_TX1_SSI" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Disable Tx1 SSI" \
  "tooltip" "NOTE: If checked, it disables Tx1 source synchronous interface" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "DISABLE_TX1_SSI" -component $cc]

ipgui::add_param -name "DISABLE_TX2_SSI" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Disable Tx2 SSI" \
  "tooltip" "NOTE: If checked, it disables Tx2 source synchronous interface" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "DISABLE_TX2_SSI" -component $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INDEPENDENT_1R1T_SUPPORT')) == 1 && spirit:decode(id('MODELPARAM_VALUE.DISABLE_TX2_SSI')) == 0} \
  [ipx::get_ports dac_2* -of_objects $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.INDEPENDENT_1R1T_SUPPORT')) == 1 && spirit:decode(id('MODELPARAM_VALUE.DISABLE_RX2_SSI')) == 0} \
  [ipx::get_ports adc_2* -of_objects $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.DISABLE_TX1_SSI')) == 0} \
  [ipx::get_ports *tx1_* -of_objects $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.DISABLE_TX2_SSI')) == 0} \
  [ipx::get_ports *tx2_* -of_objects $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.DISABLE_RX2_SSI')) == 0} \
  [ipx::get_ports *rx2_* -of_objects $cc]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.DISABLE_RX1_SSI')) == 0} \
  [ipx::get_ports *rx1_* -of_objects $cc]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files $cc

ipx::save_core $cc
