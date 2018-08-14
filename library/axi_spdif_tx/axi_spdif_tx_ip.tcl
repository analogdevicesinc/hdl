# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_spdif_tx
adi_ip_files axi_spdif_tx [list \
  "$ad_hdl_dir/library/common/axi_ctrlif.vhd" \
  "$ad_hdl_dir/library/common/axi_streaming_dma_tx_fifo.vhd" \
  "$ad_hdl_dir/library/common/pl330_dma_fifo.vhd" \
  "$ad_hdl_dir/library/common/dma_fifo.vhd" \
  "tx_package.vhd" \
  "tx_encoder.vhd" \
  "axi_spdif_tx.vhd" \
  "axi_spdif_tx_constr.xdc" ]

adi_ip_properties axi_spdif_tx
adi_ip_infer_streaming_interfaces axi_spdif_tx

adi_add_bus "dma_ack" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"dma_req_davalid" "TVALID"} \
		{"dma_req_daready" "TREADY"} \
		{"dma_req_datype" "TUSER"} ]
adi_add_bus "dma_req" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"dma_req_drvalid" "TVALID"} \
		{"dma_req_drready" "TREADY"} \
		{"dma_req_drtype" "TUSER"} \
		{"dma_req_drlast" "TLAST"} ]

# Clock and reset are for both dma_req and dma_ack
adi_add_bus_clock "dma_req_aclk" "dma_req:dma_ack" "dma_req_rstn"

adi_set_bus_dependency "s_axis" "s_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 0)"

adi_set_bus_dependency "dma_ack" "dma_req_da" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_bus_dependency "dma_req" "dma_req_dr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_aclk" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"
adi_set_ports_dependency "dma_req_rstn" \
	"(spirit:decode(id('MODELPARAM_VALUE.DMA_TYPE')) = 1)"

ipx::save_core [ipx::current_core]

