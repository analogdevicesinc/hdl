###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_i2s_adi
adi_ip_files axi_i2s_adi [list \
  "$ad_hdl_dir/library/common/axi_ctrlif.vhd" \
  "$ad_hdl_dir/library/common/axi_streaming_dma_tx_fifo.vhd" \
  "$ad_hdl_dir/library/common/axi_streaming_dma_rx_fifo.vhd" \
  "$ad_hdl_dir/library/common/pl330_dma_fifo.vhd" \
  "$ad_hdl_dir/library/common/dma_fifo.vhd" \
  "i2s_controller.vhd" \
  "i2s_rx.vhd" \
  "i2s_tx.vhd" \
  "i2s_clkgen.vhd" \
  "fifo_synchronizer.vhd" \
  "axi_i2s_adi.vhd" \
  "axi_i2s_adi_constr.xdc" \
]

adi_ip_properties axi_i2s_adi

set_property PROCESSING_ORDER LATE [ipx::get_files axi_i2s_adi_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_infer_streaming_interfaces axi_i2s_adi

set_property display_name "ADI AXI I2S Controller" [ipx::current_core]
set_property description "ADI AXI I2S Controller" [ipx::current_core]

adi_add_bus "dma_ack_rx" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"dma_req_rx_davalid" "TVALID"} \
		{"dma_req_rx_daready" "TREADY"} \
		{"dma_req_rx_datype" "TUSER"} \
	}

adi_add_bus "dma_req_rx" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"dma_req_rx_drvalid" "TVALID"} \
		{"dma_req_rx_drready" "TREADY"} \
		{"dma_req_rx_drtype" "TUSER"} \
		{"dma_req_rx_drlast" "TLAST"} \
	}
# Clock and reset are for both dma_req and dma_ack
adi_add_bus_clock "dma_req_rx_aclk" "dma_req_rx:dma_ack_rx" "dma_req_rx_rstn"

adi_add_bus "dma_ack_tx" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"dma_req_tx_davalid" "TVALID"} \
		{"dma_req_tx_daready" "TREADY"} \
		{"dma_req_tx_datype" "TUSER"} \
	}
adi_add_bus "dma_req_tx" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"dma_req_tx_drvalid" "TVALID"} \
		{"dma_req_tx_drready" "TREADY"} \
		{"dma_req_tx_drtype" "TUSER"} \
		{"dma_req_tx_drlast" "TLAST"} \
	}
# Clock and reset are for both dma_req and dma_ack
adi_add_bus_clock "dma_req_tx_aclk" "dma_req_tx:dma_ack_tx" "dma_req_tx_rstn"

adi_add_bus "i2s" "master" \
	"analog.com:interface:i2s_rtl:1.0" \
	"analog.com:interface:i2s:1.0" \
	{ \
		{"bclk_o" "BCLK"} \
		{"lrclk_o" "LRCLK"} \
		{"sdata_o" "SDATA_OUT"} \
		{"sdata_i" "SDATA_IN"} \
	}
adi_add_bus_clock "data_clk_i" "i2s"

adi_set_bus_dependency "s_axis" "s_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 0 and spirit:decode(id('MODELPARAM_VALUE.HAS_TX')) = 1)"
adi_set_bus_dependency "m_axis" "m_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 0 and spirit:decode(id('MODELPARAM_VALUE.HAS_RX')) = 1)"

adi_set_bus_dependency "dma_ack_tx" "dma_req_tx_da" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_TX')) = 1)"
adi_set_bus_dependency "dma_req_tx" "dma_req_tx_dr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_TX')) = 1)"
adi_set_ports_dependency "dma_req_tx_aclk" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_TX')) = 1)"
adi_set_ports_dependency "dma_req_tx_rstn" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_TX')) = 1)"
adi_set_bus_dependency "dma_ack_rx" "dma_req_rx_da" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_RX')) = 1)"
adi_set_bus_dependency "dma_req_rx" "dma_req_rx_dr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_RX')) = 1)"
adi_set_ports_dependency "dma_req_rx_aclk" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_RX')) = 1)"
adi_set_ports_dependency "dma_req_rx_rstn" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1 and spirit:decode(id('MODELPARAM_VALUE.HAS_RX')) = 1)"

# Tie-off optional inputs to 0
set_property driver_value 0 [ipx::get_ports -filter "direction==in && enablement_dependency!={}"  -of_objects [ipx::current_core]]

set cc [ipx::current_core]

set_property -dict [list \
	"value_validation_type" "list" \
	"value_validation_list" "16 20 24 32" \
 ] \
 [ipx::get_user_parameters SLOT_WIDTH -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Falling Edge" "0" \
		"Rising Edge" "1" \
	} \
] \
[ipx::get_user_parameters LRCLK_POL -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"Falling Edge" "0" \
		"Rising Edge" "1" \
	} \
] \
[ipx::get_user_parameters BCLK_POL -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"AXI Stream" "0" \
		"PL330" "1" \
	} \
] \
[ipx::get_user_parameters DMA_TYPE -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
	"value_validation_range_maximum" "1" \
 ] \
 [ipx::get_user_parameters HAS_RX -of_objects $cc]
 
set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "0" \
	"value_validation_range_maximum" "1" \
 ] \
 [ipx::get_user_parameters HAS_TX -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "32" \
 ] \
 [ipx::get_user_parameters NUM_OF_CHANNEL -of_objects $cc]

set_property -dict [list \
	"value_validation_type" "range_long" \
	"value_validation_range_minimum" "1" \
	"value_validation_range_maximum" "32" \
 ] \
 [ipx::get_user_parameters S_AXI_ADDRESS_WIDTH -of_objects $cc]

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set i2s_group [ipgui::add_group -name "I2S Configuration" -component $cc \
		-parent $page0 -display_name "I2S Configuration"]

set p [ipgui::get_guiparamspec -name "SLOT_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $i2s_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Slot Width" \
] $p

set p [ipgui::get_guiparamspec -name "LRCLK_POL" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $i2s_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Left-Right Clock Polarity" \
] $p

set p [ipgui::get_guiparamspec -name "BCLK_POL" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $i2s_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "Bit Clock Polarity" \
] $p

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
		-parent $page0 -display_name "General Configuration"]

set p [ipgui::get_guiparamspec -name "HAS_RX" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $general_group
set_property -dict [list \
	"widget" "checkBox" \
	"display_name" "Enable I2S Receiver Support" \
] $p

set p [ipgui::get_guiparamspec -name "HAS_TX" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $general_group
set_property -dict [list \
	"widget" "checkBox" \
	"display_name" "Enable I2S Transmitter Support" \
] $p

set p [ipgui::get_guiparamspec -name "DMA_TYPE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $general_group
set_property -dict [list \
	"widget" "comboBox" \
	"display_name" "DMA Interface Type" \
] $p

set p [ipgui::get_guiparamspec -name "NUM_OF_CHANNEL" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $general_group
set_property -dict [list \
	"display_name" "Number of Audio Channels" \
] $p

set p [ipgui::get_guiparamspec -name "S_AXI_ADDRESS_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $general_group
set_property -dict [list \
	"display_name" "AXI Address Width" \
] $p

ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "S_AXI_DATA_WIDTH" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "DEVICE_FAMILY" -component $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc
