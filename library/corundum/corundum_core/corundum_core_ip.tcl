###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create corundum_core

# Corundum sources
adi_ip_files corundum_core [list \
  "corundum_core.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_core_axi.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_core.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_dram_if.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_interface.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_interface_tx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_interface_rx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_port.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_port_tx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_port_rx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_egress.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_ingress.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_l2_egress.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_l2_ingress.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_rx_queue_map.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_ptp.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_ptp_clock.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_ptp_perout.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_rb_clk_info.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cpl_write.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cpl_op_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/desc_fetch.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/desc_op_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/queue_manager.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/cpl_queue_manager.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/tx_fifo.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/rx_fifo.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/tx_req_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/tx_engine.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/rx_engine.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/tx_checksum.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/rx_hash.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/rx_checksum.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/stats_counter.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/stats_collect.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/stats_dma_if_axi.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/stats_dma_latency.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/mqnic_tx_scheduler_block_rr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/common/rtl/tx_scheduler_rr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/ptp_perout.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/ptp_td_phc.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/ptp_td_leaf.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/ptp_td_rel2tod.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/mac_ctrl_rx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/mac_pause_ctrl_rx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/mac_ctrl_tx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/rtl/mac_pause_ctrl_tx.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_crossbar.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_crossbar_addr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_crossbar_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_crossbar_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_reg_if.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_reg_if_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_reg_if_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_register_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/axil_register_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/arbiter.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/axi/rtl/priority_encoder.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_adapter.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_arb_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo_adapter.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_demux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_fifo_adapter.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/eth/lib/axis/rtl/axis_pipeline_fifo.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/irq_rate_limit.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_axi.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_axi_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_axi_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_mux_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_mux_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_if_desc_mux.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_ram_demux_rd.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_ram_demux_wr.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_psdpram.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_client_axis_sink.v" \
  "$ad_hdl_dir/../ucorundum/fpga/lib/pcie/rtl/dma_client_axis_source.v" \
]

adi_ip_properties_lite corundum_core
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Corundum Core" $cc
set_property description "Corundum MQNIC Core AXI IP" $cc

# Remove all inferred interfaces and address spaces
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

# Interface definitions

adi_add_bus "m_axi" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_awid" "AWID"} \
    {"m_axi_awaddr" "AWADDR"} \
    {"m_axi_awlen" "AWLEN"} \
    {"m_axi_awsize" "AWSIZE"} \
    {"m_axi_awburst" "AWBURST"} \
    {"m_axi_awlock" "AWLOCK"} \
    {"m_axi_awcache" "AWCACHE"} \
    {"m_axi_awprot" "AWPROT"} \
    {"m_axi_awvalid" "AWVALID"} \
    {"m_axi_awready" "AWREADY"} \
    {"m_axi_wdata" "WDATA"} \
    {"m_axi_wstrb" "WSTRB"} \
    {"m_axi_wlast" "WLAST"} \
    {"m_axi_wvalid" "WVALID"} \
    {"m_axi_wready" "WREADY"} \
    {"m_axi_bid" "BID"} \
    {"m_axi_bresp" "BRESP"} \
    {"m_axi_bvalid" "BVALID"} \
    {"m_axi_bready" "BREADY"} \
    {"m_axi_arid" "ARID"} \
    {"m_axi_araddr" "ARADDR"} \
    {"m_axi_arlen" "ARLEN"} \
    {"m_axi_arsize" "ARSIZE"} \
    {"m_axi_arburst" "ARBURST"} \
    {"m_axi_arlock" "ARLOCK"} \
    {"m_axi_arcache" "ARCACHE"} \
    {"m_axi_arprot" "ARPROT"} \
    {"m_axi_arvalid" "ARVALID"} \
    {"m_axi_arready" "ARREADY"} \
    {"m_axi_rid" "RID"} \
    {"m_axi_rdata" "RDATA"} \
    {"m_axi_rresp" "RRESP"} \
    {"m_axi_rlast" "RLAST"} \
    {"m_axi_rvalid" "RVALID"} \
    {"m_axi_rready" "RREADY"} \
  }
ipx::infer_address_space [ipx::get_bus_interfaces m_axi -of_objects $cc]

# ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 $cc

adi_add_bus "s_axil_app_ctrl" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"s_axil_app_ctrl_awaddr" "AWADDR"} \
    {"s_axil_app_ctrl_awprot" "AWPROT"} \
    {"s_axil_app_ctrl_awvalid" "AWVALID"} \
    {"s_axil_app_ctrl_awready" "AWREADY"} \
    {"s_axil_app_ctrl_wdata" "WDATA"} \
    {"s_axil_app_ctrl_wstrb" "WSTRB"} \
    {"s_axil_app_ctrl_wvalid" "WVALID"} \
    {"s_axil_app_ctrl_wready" "WREADY"} \
    {"s_axil_app_ctrl_bresp" "BRESP"} \
    {"s_axil_app_ctrl_bvalid" "BVALID"} \
    {"s_axil_app_ctrl_bready" "BREADY"} \
    {"s_axil_app_ctrl_araddr" "ARADDR"} \
    {"s_axil_app_ctrl_arprot" "ARPROT"} \
    {"s_axil_app_ctrl_arvalid" "ARVALID"} \
    {"s_axil_app_ctrl_arready" "ARREADY"} \
    {"s_axil_app_ctrl_rdata" "RDATA"} \
    {"s_axil_app_ctrl_rresp" "RRESP"} \
    {"s_axil_app_ctrl_rvalid" "RVALID"} \
    {"s_axil_app_ctrl_rready" "RREADY"} \
  }

adi_add_bus "s_axil_ctrl" "slave" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"s_axil_ctrl_awaddr" "AWADDR"} \
    {"s_axil_ctrl_awprot" "AWPROT"} \
    {"s_axil_ctrl_awvalid" "AWVALID"} \
    {"s_axil_ctrl_awready" "AWREADY"} \
    {"s_axil_ctrl_wdata" "WDATA"} \
    {"s_axil_ctrl_wstrb" "WSTRB"} \
    {"s_axil_ctrl_wvalid" "WVALID"} \
    {"s_axil_ctrl_wready" "WREADY"} \
    {"s_axil_ctrl_bresp" "BRESP"} \
    {"s_axil_ctrl_bvalid" "BVALID"} \
    {"s_axil_ctrl_bready" "BREADY"} \
    {"s_axil_ctrl_araddr" "ARADDR"} \
    {"s_axil_ctrl_arprot" "ARPROT"} \
    {"s_axil_ctrl_arvalid" "ARVALID"} \
    {"s_axil_ctrl_arready" "ARREADY"} \
    {"s_axil_ctrl_rdata" "RDATA"} \
    {"s_axil_ctrl_rresp" "RRESP"} \
    {"s_axil_ctrl_rvalid" "RVALID"} \
    {"s_axil_ctrl_rready" "RREADY"} \
  }

adi_add_bus "m_axil_csr" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axil_csr_awaddr" "AWADDR"} \
    {"m_axil_csr_awprot" "AWPROT"} \
    {"m_axil_csr_awvalid" "AWVALID"} \
    {"m_axil_csr_awready" "AWREADY"} \
    {"m_axil_csr_wdata" "WDATA"} \
    {"m_axil_csr_wstrb" "WSTRB"} \
    {"m_axil_csr_wvalid" "WVALID"} \
    {"m_axil_csr_wready" "WREADY"} \
    {"m_axil_csr_bresp" "BRESP"} \
    {"m_axil_csr_bvalid" "BVALID"} \
    {"m_axil_csr_bready" "BREADY"} \
    {"m_axil_csr_araddr" "ARADDR"} \
    {"m_axil_csr_arprot" "ARPROT"} \
    {"m_axil_csr_arvalid" "ARVALID"} \
    {"m_axil_csr_arready" "ARREADY"} \
    {"m_axil_csr_rdata" "RDATA"} \
    {"m_axil_csr_rresp" "RRESP"} \
    {"m_axil_csr_rvalid" "RVALID"} \
    {"m_axil_csr_rready" "RREADY"} \
  }

adi_add_bus_clock "clk" "m_axi:m_axi_dma:s_axil_app_ctrl:s_axil_ctrl:m_axil_csr" "rst"

adi_add_bus "m_axi_ddr" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_ddr_awid" "AWID"} \
    {"m_axi_ddr_awaddr" "AWADDR"} \
    {"m_axi_ddr_awlen" "AWLEN"} \
    {"m_axi_ddr_awsize" "AWSIZE"} \
    {"m_axi_ddr_awuser" "AWUSER"} \
    {"m_axi_ddr_awburst" "AWBURST"} \
    {"m_axi_ddr_awlock" "AWLOCK"} \
    {"m_axi_ddr_awcache" "AWCACHE"} \
    {"m_axi_ddr_awprot" "AWPROT"} \
    {"m_axi_ddr_awqos" "AWQOS"} \
    {"m_axi_ddr_awvalid" "AWVALID"} \
    {"m_axi_ddr_awready" "AWREADY"} \
    {"m_axi_ddr_wdata" "WDATA"} \
    {"m_axi_ddr_wstrb" "WSTRB"} \
    {"m_axi_ddr_wlast" "WLAST"} \
    {"m_axi_ddr_wvalid" "WVALID"} \
    {"m_axi_ddr_wready" "WREADY"} \
    {"m_axi_ddr_wuser" "WUSER"} \
    {"m_axi_ddr_bid" "BID"} \
    {"m_axi_ddr_bresp" "BRESP"} \
    {"m_axi_ddr_buser" "BUSER"} \
    {"m_axi_ddr_bvalid" "BVALID"} \
    {"m_axi_ddr_bready" "BREADY"} \
    {"m_axi_ddr_arid" "ARID"} \
    {"m_axi_ddr_araddr" "ARADDR"} \
    {"m_axi_ddr_arlen" "ARLEN"} \
    {"m_axi_ddr_arsize" "ARSIZE"} \
    {"m_axi_ddr_aruser" "ARUSER"} \
    {"m_axi_ddr_arburst" "ARBURST"} \
    {"m_axi_ddr_arlock" "ARLOCK"} \
    {"m_axi_ddr_arcache" "ARCACHE"} \
    {"m_axi_ddr_arprot" "ARPROT"} \
    {"m_axi_ddr_arqos" "ARQOS"} \
    {"m_axi_ddr_arvalid" "ARVALID"} \
    {"m_axi_ddr_arready" "ARREADY"} \
    {"m_axi_ddr_rid" "RID"} \
    {"m_axi_ddr_rdata" "RDATA"} \
    {"m_axi_ddr_rresp" "RRESP"} \
    {"m_axi_ddr_ruser" "RUSER"} \
    {"m_axi_ddr_rlast" "RLAST"} \
    {"m_axi_ddr_rvalid" "RVALID"} \
    {"m_axi_ddr_rready" "RREADY"} \
  }
ipx::infer_address_space [ipx::get_bus_interfaces m_axi_ddr -of_objects $cc]

adi_add_bus_clock "ddr_clk" "m_axi_ddr" "ddr_rst"

adi_add_bus "m_axi_hbm" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_hbm_awid" "AWID"} \
    {"m_axi_hbm_awaddr" "AWADDR"} \
    {"m_axi_hbm_awlen" "AWLEN"} \
    {"m_axi_hbm_awsize" "AWSIZE"} \
    {"m_axi_hbm_awuser" "AWUSER"} \
    {"m_axi_hbm_awburst" "AWBURST"} \
    {"m_axi_hbm_awlock" "AWLOCK"} \
    {"m_axi_hbm_awcache" "AWCACHE"} \
    {"m_axi_hbm_awprot" "AWPROT"} \
    {"m_axi_hbm_awqos" "AWQOS"} \
    {"m_axi_hbm_awvalid" "AWVALID"} \
    {"m_axi_hbm_awready" "AWREADY"} \
    {"m_axi_hbm_wdata" "WDATA"} \
    {"m_axi_hbm_wstrb" "WSTRB"} \
    {"m_axi_hbm_wlast" "WLAST"} \
    {"m_axi_hbm_wvalid" "WVALID"} \
    {"m_axi_hbm_wready" "WREADY"} \
    {"m_axi_hbm_wuser" "WUSER"} \
    {"m_axi_hbm_bid" "BID"} \
    {"m_axi_hbm_bresp" "BRESP"} \
    {"m_axi_hbm_buser" "BUSER"} \
    {"m_axi_hbm_bvalid" "BVALID"} \
    {"m_axi_hbm_bready" "BREADY"} \
    {"m_axi_hbm_arid" "ARID"} \
    {"m_axi_hbm_araddr" "ARADDR"} \
    {"m_axi_hbm_arlen" "ARLEN"} \
    {"m_axi_hbm_arsize" "ARSIZE"} \
    {"m_axi_hbm_aruser" "ARUSER"} \
    {"m_axi_hbm_arburst" "ARBURST"} \
    {"m_axi_hbm_arlock" "ARLOCK"} \
    {"m_axi_hbm_arcache" "ARCACHE"} \
    {"m_axi_hbm_arprot" "ARPROT"} \
    {"m_axi_hbm_arqos" "ARQOS"} \
    {"m_axi_hbm_arvalid" "ARVALID"} \
    {"m_axi_hbm_arready" "ARREADY"} \
    {"m_axi_hbm_rid" "RID"} \
    {"m_axi_hbm_rdata" "RDATA"} \
    {"m_axi_hbm_rresp" "RRESP"} \
    {"m_axi_hbm_ruser" "RUSER"} \
    {"m_axi_hbm_rlast" "RLAST"} \
    {"m_axi_hbm_rvalid" "RVALID"} \
    {"m_axi_hbm_rready" "RREADY"} \
  }
ipx::infer_address_space [ipx::get_bus_interfaces m_axi_hbm -of_objects $cc]

adi_add_bus_clock "hbm_clk" "m_axi_hbm" "hbm_rst"

adi_add_bus "m_axis_tx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"m_axis_tx_tdata" "TDATA"} \
    {"m_axis_tx_tkeep" "TKEEP"} \
    {"m_axis_tx_tvalid" "TVALID"} \
    {"m_axis_tx_tready" "TREADY"} \
    {"m_axis_tx_tlast" "TLAST"} \
    {"m_axis_tx_tuser" "TUSER"} ]

adi_add_bus_clock "tx_clk" "m_axis_tx" "tx_rst"

adi_add_bus "s_axis_rx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_rx_tdata" "TDATA"} \
    {"s_axis_rx_tkeep" "TKEEP"} \
    {"s_axis_rx_tvalid" "TVALID"} \
    {"s_axis_rx_tready" "TREADY"} \
    {"s_axis_rx_tlast" "TLAST"} \
    {"s_axis_rx_tuser" "TUSER"} ]

adi_add_bus "s_axis_stat" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_stat_tdata" "TDATA"} \
    {"s_axis_stat_tid" "TID"} \
    {"s_axis_stat_tvalid" "TVALID"} \
    {"s_axis_stat_tready" "TREADY"} ]

adi_add_bus_clock "rx_clk" "s_axis_rx:s_axis_stat" "rx_rst"

adi_if_infer_bus analog.com:interface:if_ctrl_reg master ctrl_reg [list \
  "ctrl_reg_wr_addr ctrl_reg_wr_addr" \
  "ctrl_reg_wr_data ctrl_reg_wr_data" \
  "ctrl_reg_wr_strb ctrl_reg_wr_strb" \
  "ctrl_reg_wr_en   ctrl_reg_wr_en" \
  "ctrl_reg_wr_wait ctrl_reg_wr_wait" \
  "ctrl_reg_wr_ack  ctrl_reg_wr_ack" \
  "ctrl_reg_rd_addr ctrl_reg_rd_addr" \
  "ctrl_reg_rd_data ctrl_reg_rd_data" \
  "ctrl_reg_rd_en   ctrl_reg_rd_en" \
  "ctrl_reg_rd_wait ctrl_reg_rd_wait" \
  "ctrl_reg_rd_ack  ctrl_reg_rd_ack" \
]

adi_if_infer_bus analog.com:interface:if_ptp_clock master ptp_clock [list \
  "ptp_clk              ptp_clk" \
  "ptp_rst              ptp_rst" \
  "ptp_sample_clk       ptp_sample_clk" \
  "ptp_td_sd            ptp_td_sd" \
  "ptp_pps              ptp_pps" \
  "ptp_pps_str          ptp_pps_str" \
  "ptp_sync_locked      ptp_sync_locked" \
  "ptp_sync_ts_rel      ptp_sync_ts_rel" \
  "ptp_sync_ts_rel_step ptp_sync_ts_rel_step" \
  "ptp_sync_ts_tod      ptp_sync_ts_tod" \
  "ptp_sync_ts_tod_step ptp_sync_ts_tod_step" \
  "ptp_sync_pps         ptp_sync_pps" \
  "ptp_sync_pps_str     ptp_sync_pps_str" \
  "ptp_perout_locked    ptp_perout_locked" \
  "ptp_perout_error     ptp_perout_error" \
  "ptp_perout_pulse     ptp_perout_pulse" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_tx master flow_control_tx [list \
  "tx_enable           tx_enable" \
  "tx_status           tx_status" \
  "tx_lfc_en           tx_lfc_en" \
  "tx_lfc_req          tx_lfc_req" \
  "tx_pfc_en           tx_pfc_en" \
  "tx_pfc_req          tx_pfc_req" \
  "tx_fc_quanta_clk_en tx_fc_quanta_clk_en" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx master flow_control_rx [list \
  "rx_enable           rx_enable" \
  "rx_status           rx_status" \
  "rx_lfc_en           rx_lfc_en" \
  "rx_lfc_req          rx_lfc_req" \
  "rx_lfc_ack          rx_lfc_ack" \
  "rx_pfc_en           rx_pfc_en" \
  "rx_pfc_req          rx_pfc_req" \
  "rx_pfc_ack          rx_pfc_ack" \
  "rx_fc_quanta_clk_en rx_fc_quanta_clk_en" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp master ethernet_ptp_tx [list \
  "ptp_clk     tx_ptp_clk" \
  "ptp_rst     tx_ptp_rst" \
  "ptp_ts      tx_ptp_ts" \
  "ptp_ts_step tx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_ethernet_ptp master ethernet_ptp_rx [list \
  "ptp_clk     rx_ptp_clk" \
  "ptp_rst     rx_ptp_rst" \
  "ptp_ts      rx_ptp_ts" \
  "ptp_ts_step rx_ptp_ts_step" \
]

adi_if_infer_bus analog.com:interface:if_axis_tx_ptp master axis_tx_ptp [list \
  "ts    s_axis_tx_cpl_ts" \
  "tag   s_axis_tx_cpl_tag" \
  "valid s_axis_tx_cpl_valid" \
  "ready s_axis_tx_cpl_ready" \
]

adi_if_infer_bus analog.com:interface:if_jtag master jtag [list \
  "tdi app_jtag_tdi" \
  "tdo app_jtag_tdo" \
  "tms app_jtag_tms" \
  "tck app_jtag_tck" \
]

adi_if_infer_bus analog.com:interface:if_gpio master gpio [list \
  "gpio_in     app_gpio_in" \
  "gpio_out    app_gpio_out" \
]

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
