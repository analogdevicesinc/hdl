###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create corundum

set_property board_part xilinx.com:k26i:part0:1.4 [current_project]
source $ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/ip/eth_xcvr_gth.tcl

adi_ip_files corundum [list \
  "corundum.v" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/rtl/fpga_core.v" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/rtl/sync_signal.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_quad_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/eth_xcvr_phy_10g_gty_wrapper.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_core_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_core.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_dram_if.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_interface_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_egress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ingress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_l2_egress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_l2_ingress.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_rx_queue_map.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp_clock.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_ptp_perout.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_rb_clk_info.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_port_map_phy_xgmii.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_write.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_op_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/desc_fetch.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/desc_op_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/queue_manager.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cpl_queue_manager.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_req_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_engine.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_engine.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_checksum.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_hash.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rx_checksum.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/rb_drp.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_counter.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_collect.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_if_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/stats_dma_latency.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mqnic_tx_scheduler_block_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tx_scheduler_rr.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_scheduler.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_ber.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/tdma_ber_ch.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_mac_10g.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_rx_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/axis_xgmii_tx_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/lfsr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_clock.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_clock_cdc.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/ptp_perout.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_interconnect.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_addr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_crossbar_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_reg_if_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_register_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/axil_register_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/arbiter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/priority_encoder.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_arb_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_async_fifo_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_demux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_pipeline_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_register.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/irq_rate_limit.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_axi_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_mux_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_if_desc_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_ram_demux_rd.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_ram_demux_wr.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_psdpram.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_client_axis_sink.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/dma_client_axis_source.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/pcie/rtl/pulse_merge.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_tx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_frame_sync.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_if.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_ber_mon.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/eth_phy_10g_rx_watchdog.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/xgmii_baser_dec_64.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/rtl/xgmii_baser_enc_64.v" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/lib/eth/syn/vivado/ptp_clock_cdc.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/lib/axis/syn/vivado/sync_reset.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/KR260/fpga/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/tdma_ber_ch.tcl" \
]

adi_ip_properties_lite corundum
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum} [ipx::current_core]

set cc [ipx::current_core]

set_property display_name "Corundum" $cc
set_property description "Corundum NIC IP Core" $cc

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

# Interface definitions

adi_add_bus "m_axi_dma" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  {
    {"m_axi_dma_awid" "AWID"} \
    {"m_axi_dma_awaddr" "AWADDR"} \
    {"m_axi_dma_awlen" "AWLEN"} \
    {"m_axi_dma_awsize" "AWSIZE"} \
    {"m_axi_dma_awuser" "AWUSER"} \
    {"m_axi_dma_awburst" "AWBURST"} \
    {"m_axi_dma_awlock" "AWLOCK"} \
    {"m_axi_dma_awcache" "AWCACHE"} \
    {"m_axi_dma_awprot" "AWPROT"} \
    {"m_axi_dma_awqos" "AWQOS"} \
    {"m_axi_dma_awvalid" "AWVALID"} \
    {"m_axi_dma_awready" "AWREADY"} \
    {"m_axi_dma_wdata" "WDATA"} \
    {"m_axi_dma_wstrb" "WSTRB"} \
    {"m_axi_dma_wlast" "WLAST"} \
    {"m_axi_dma_wvalid" "WVALID"} \
    {"m_axi_dma_wready" "WREADY"} \
    {"m_axi_dma_bid" "BID"} \
    {"m_axi_dma_bresp" "BRESP"} \
    {"m_axi_dma_bvalid" "BVALID"} \
    {"m_axi_dma_bready" "BREADY"} \
    {"m_axi_dma_arid" "ARID"} \
    {"m_axi_dma_araddr" "ARADDR"} \
    {"m_axi_dma_arlen" "ARLEN"} \
    {"m_axi_dma_arsize" "ARSIZE"} \
    {"m_axi_dma_aruser" "ARUSER"} \
    {"m_axi_dma_arburst" "ARBURST"} \
    {"m_axi_dma_arlock" "ARLOCK"} \
    {"m_axi_dma_arcache" "ARCACHE"} \
    {"m_axi_dma_arprot" "ARPROT"} \
    {"m_axi_dma_arqos" "ARQOS"} \
    {"m_axi_dma_arvalid" "ARVALID"} \
    {"m_axi_dma_arready" "ARREADY"} \
    {"m_axi_dma_rid" "RID"} \
    {"m_axi_dma_rdata" "RDATA"} \
    {"m_axi_dma_rresp" "RRESP"} \
    {"m_axi_dma_rlast" "RLAST"} \
    {"m_axi_dma_rvalid" "RVALID"} \
    {"m_axi_dma_rready" "RREADY"} \
  }
adi_add_bus_clock "core_clk" "m_axi_dma" "core_rst" "master"

set_property master_address_space_ref m_axi_dma \
  [ipx::get_bus_interfaces m_axi_dma \
  -of_objects [ipx::current_core]] \

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
adi_add_bus_clock "core_clk" "s_axil_app_ctrl" "core_rst"

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
adi_add_bus_clock "core_clk" "s_axil_ctrl" "core_rst"

adi_add_bus "iic" "master" \
  "xilinx.com:interface:iic_rtl:1.0" \
  "xilinx.com:interface:iic:1.0" \
  {
    {"scl_i" "SCL_I"} \
    {"scl_o" "SCL_O"} \
    {"scl_t" "SCL_T"} \
    {"sda_i" "SDA_I"} \
    {"sda_o" "SDA_O"} \
    {"sda_t" "SDA_T"} \

  }

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
