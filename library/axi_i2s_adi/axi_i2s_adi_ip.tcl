# ip

source ../scripts/adi_env.tcl
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
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 0)"
adi_set_bus_dependency "m_axis" "m_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 0)"

adi_set_bus_dependency "dma_ack_tx" "dma_req_tx_da" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_bus_dependency "dma_req_tx" "dma_req_tx_dr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_tx_aclk" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_tx_rstn" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_bus_dependency "dma_ack_rx" "dma_req_rx_da" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_bus_dependency "dma_req_rx" "dma_req_rx_dr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_rx_aclk" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_rx_rstn" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"

# Tie-off optional inputs to 0
set_property driver_value 0 [ipx::get_ports -filter "direction==in && enablement_dependency!={}"  -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

