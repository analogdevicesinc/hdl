# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

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

adi_ip_properties_lite axi_i2s_adi
adi_ip_constraints axi_spdif_tx axi_i2s_adi_constr.xdc late

adi_add_bus "DMA_ACK_RX" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"DMA_REQ_RX_DAVALID" "TVALID"} \
		{"DMA_REQ_RX_DAREADY" "TREADY"} \
		{"DMA_REQ_RX_DATYPE" "TUSER"} \
	}
adi_add_bus "DMA_REQ_RX" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"DMA_REQ_RX_DRVALID" "TVALID"} \
		{"DMA_REQ_RX_DRREADY" "TREADY"} \
		{"DMA_REQ_RX_DRTYPE" "TUSER"} \
		{"DMA_REQ_RX_DRLAST" "TLAST"} \
	}
# Clock and reset are for both DMA_REQ and DMA_ACK
adi_add_bus_clock "DMA_REQ_RX_ACLK" "DMA_REQ_RX:DMA_ACK_RX" "DMA_REQ_RX_RSTN"

adi_add_bus "DMA_ACK_TX" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"DMA_REQ_TX_DAVALID" "TVALID"} \
		{"DMA_REQ_TX_DAREADY" "TREADY"} \
		{"DMA_REQ_TX_DATYPE" "TUSER"} \
	}
adi_add_bus "DMA_REQ_TX" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"DMA_REQ_TX_DRVALID" "TVALID"} \
		{"DMA_REQ_TX_DRREADY" "TREADY"} \
		{"DMA_REQ_TX_DRTYPE" "TUSER"} \
		{"DMA_REQ_TX_DRLAST" "TLAST"} \
	}
# Clock and reset are for both DMA_REQ and DMA_ACK
adi_add_bus_clock "DMA_REQ_TX_ACLK" "DMA_REQ_TX:DMA_ACK_TX" "DMA_REQ_TX_RSTN"

adi_add_bus "I2S" "master" \
	"analog.com:interface:i2s_rtl:1.0" \
	"analog.com:interface:i2s:1.0" \
	{ \
		{"BCLK_O" "BCLK"} \
		{"LRCLK_O" "LRCLK"} \
		{"SDATA_O" "SDATA_OUT"} \
		{"SDATA_I" "SDATA_IN"} \
	}
adi_add_bus_clock "DATA_CLK_I" "i2s"

adi_set_bus_dependency "S_AXIS" "S_AXIS" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 0)"
adi_set_bus_dependency "M_AXIS" "M_AXIS" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 0)"

adi_set_bus_dependency "DMA_ACK_TX" "DMA_REQ_TX_DA" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_bus_dependency "DMA_REQ_TX" "DMA_REQ_TX_DR" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_TX_ACLK" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_TX_RSTN" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_bus_dependency "DMA_ACK_RX" "DMA_REQ_RX_DA" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_bus_dependency "DMA_REQ_RX" "DMA_REQ_RX_DR" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_RX_ACLK" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_RX_RSTN" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"

ipx::save_core [ipx::current_core]

