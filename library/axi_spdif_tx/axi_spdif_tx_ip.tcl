# ip

source ../scripts/adi_ip.tcl

adi_ip_create axi_spdif_tx
adi_ip_files axi_spdif_tx [list \
  "../common/axi_ctrlif.vhd" \
  "../common/axi_streaming_dma_tx_fifo.vhd" \
  "../common/pl330_dma_fifo.vhd" \
  "../common/dma_fifo.vhd" \
  "tx_package.vhd" \
  "tx_encoder.vhd" \
  "axi_spdif_tx.vhd" ]

adi_ip_properties_lite axi_spdif_tx

adi_add_bus "S_AXIS" "axis" "slave" \
	[list {"S_AXIS_ACLK" "ACLK"} \
	  {"S_AXIS_ARESETN" "ARESETN"} \
	  {"S_AXIS_TREADY" "TREADY"} \
	  {"S_AXIS_TVALID" "VALID"} \
	  {"S_AXIS_TDATA" "TDATA"} \
	  {"S_AXIS_TLAST" "TLAST"} ]

adi_add_bus "DMA_ACK" "axis" "slave" \
	[list {"DMA_REQ_DAVALID" "TVALID"} \
		{"DMA_REQ_DAREADY" "TREADY"} \
		{"DMA_REQ_DATYPE" "TUSER"} ]
adi_add_bus "DMA_REQ" "axis" "master" \
	[list {"DMA_REQ_DRVALID" "TVALID"} \
		{"DMA_REQ_DRREADY" "TREADY"} \
		{"DMA_REQ_DRTYPE" "TUSER"} \
		{"DMA_REQ_DRLAST" "TLAST"} ]

adi_set_bus_dependency "S_AXIS" "S_AXIS" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 0)"

adi_set_bus_dependency "DMA_ACK" "DMA_REQ_DA" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_bus_dependency "DMA_REQ" "DMA_REQ_DR" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_ACLK" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"
adi_set_ports_dependency "DMA_REQ_RSTN" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE')) = 1)"

ipx::save_core [ipx::current_core]

