# ip

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl
set corundum_dir_common [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/common"]]
set corundum_dir_mod [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/lib"]]
set corundum_dir_zcu102 [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/mqnic/ZCU102/fpga"]]

global VIVADO_IP_LIBRARY

adi_ip_create nic_core

set_property PART xczu9eg-ffvb1156-2-e [current_project]
source $corundum_dir_zcu102/ip/eth_xcvr_gth.tcl

adi_ip_files nic_core [list \
  "nic_core.v" \
  "$corundum_dir_zcu102/rtl/fpga_core.v" \
  "$corundum_dir_common/rtl/mqnic_core_axi.v" \
  "$corundum_dir_common/rtl/mqnic_core.v" \
  "$corundum_dir_common/rtl/mqnic_dram_if.v" \
  "$corundum_dir_common/rtl/mqnic_interface.v" \
  "$corundum_dir_common/rtl/mqnic_interface_tx.v" \
  "$corundum_dir_common/rtl/mqnic_interface_rx.v" \
  "$corundum_dir_common/rtl/mqnic_port.v" \
  "$corundum_dir_common/rtl/mqnic_port_tx.v" \
  "$corundum_dir_common/rtl/mqnic_port_rx.v" \
  "$corundum_dir_common/rtl/mqnic_egress.v" \
  "$corundum_dir_common/rtl/mqnic_ingress.v" \
  "$corundum_dir_common/rtl/mqnic_l2_egress.v" \
  "$corundum_dir_common/rtl/mqnic_l2_ingress.v" \
  "$corundum_dir_common/rtl/mqnic_rx_queue_map.v" \
  "$corundum_dir_common/rtl/mqnic_ptp.v" \
  "$corundum_dir_common/rtl/mqnic_ptp_clock.v" \
  "$corundum_dir_common/rtl/mqnic_ptp_perout.v" \
  "$corundum_dir_common/rtl/mqnic_rb_clk_info.v" \
  "$corundum_dir_common/rtl/mqnic_port_map_phy_xgmii.v" \
  "$corundum_dir_common/rtl/cpl_write.v" \
  "$corundum_dir_common/rtl/cpl_op_mux.v" \
  "$corundum_dir_common/rtl/desc_fetch.v" \
  "$corundum_dir_common/rtl/desc_op_mux.v" \
  "$corundum_dir_common/rtl/queue_manager.v" \
  "$corundum_dir_common/rtl/cpl_queue_manager.v" \
  "$corundum_dir_common/rtl/tx_fifo.v" \
  "$corundum_dir_common/rtl/rx_fifo.v" \
  "$corundum_dir_common/rtl/tx_req_mux.v" \
  "$corundum_dir_common/rtl/tx_engine.v" \
  "$corundum_dir_common/rtl/rx_engine.v" \
  "$corundum_dir_common/rtl/tx_checksum.v" \
  "$corundum_dir_common/rtl/rx_hash.v" \
  "$corundum_dir_common/rtl/rx_checksum.v" \
  "$corundum_dir_common/rtl/rb_drp.v" \
  "$corundum_dir_common/rtl/stats_counter.v" \
  "$corundum_dir_common/rtl/stats_collect.v" \
  "$corundum_dir_common/rtl/stats_dma_if_axi.v" \
  "$corundum_dir_common/rtl/stats_dma_latency.v" \
  "$corundum_dir_common/rtl/mqnic_tx_scheduler_block_rr.v" \
  "$corundum_dir_common/rtl/tx_scheduler_rr.v" \
  "$corundum_dir_common/rtl/tdma_scheduler.v" \
  "$corundum_dir_common/rtl/tdma_ber.v" \
  "$corundum_dir_common/rtl/tdma_ber_ch.v" \
  "$corundum_dir_mod/eth/rtl/eth_mac_10g.v" \
  "$corundum_dir_mod/eth/rtl/axis_xgmii_rx_64.v" \
  "$corundum_dir_mod/eth/rtl/axis_xgmii_tx_64.v" \
  "$corundum_dir_mod/eth/rtl/lfsr.v" \
  "$corundum_dir_mod/eth/rtl/ptp_clock.v" \
  "$corundum_dir_mod/eth/rtl/ptp_clock_cdc.v" \
  "$corundum_dir_mod/eth/rtl/ptp_perout.v" \
  "$corundum_dir_mod/axi/rtl/axil_interconnect.v" \
  "$corundum_dir_mod/axi/rtl/axil_crossbar.v" \
  "$corundum_dir_mod/axi/rtl/axil_crossbar_addr.v" \
  "$corundum_dir_mod/axi/rtl/axil_crossbar_rd.v" \
  "$corundum_dir_mod/axi/rtl/axil_crossbar_wr.v" \
  "$corundum_dir_mod/axi/rtl/axil_reg_if.v" \
  "$corundum_dir_mod/axi/rtl/axil_reg_if_rd.v" \
  "$corundum_dir_mod/axi/rtl/axil_reg_if_wr.v" \
  "$corundum_dir_mod/axi/rtl/axil_register_rd.v" \
  "$corundum_dir_mod/axi/rtl/axil_register_wr.v" \
  "$corundum_dir_mod/axi/rtl/arbiter.v" \
  "$corundum_dir_mod/axi/rtl/priority_encoder.v" \
  "$corundum_dir_mod/axis/rtl/axis_adapter.v" \
  "$corundum_dir_mod/axis/rtl/axis_arb_mux.v" \
  "$corundum_dir_mod/axis/rtl/axis_async_fifo.v" \
  "$corundum_dir_mod/axis/rtl/axis_async_fifo_adapter.v" \
  "$corundum_dir_mod/axis/rtl/axis_demux.v" \
  "$corundum_dir_mod/axis/rtl/axis_fifo.v" \
  "$corundum_dir_mod/axis/rtl/axis_fifo_adapter.v" \
  "$corundum_dir_mod/axis/rtl/axis_pipeline_fifo.v" \
  "$corundum_dir_mod/axis/rtl/axis_register.v" \
  "$corundum_dir_mod/axis/rtl/sync_reset.v" \
  "$corundum_dir_mod/pcie/rtl/dma_client_axis_sink.v" \
  "$corundum_dir_mod/pcie/rtl/dma_client_axis_source.v" \
  "$corundum_dir_mod/pcie/rtl/irq_rate_limit.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_axi.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_axi_rd.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_axi_wr.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_mux.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_mux_rd.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_mux_wr.v" \
  "$corundum_dir_mod/pcie/rtl/dma_if_desc_mux.v" \
  "$corundum_dir_mod/pcie/rtl/dma_ram_demux_rd.v" \
  "$corundum_dir_mod/pcie/rtl/dma_ram_demux_wr.v" \
  "$corundum_dir_mod/pcie/rtl/dma_psdpram.v" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_port.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$corundum_dir_mod/eth/syn/vivado/ptp_clock_cdc.tcl" \
  "$corundum_dir_common/syn/vivado/rb_drp.tcl" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$corundum_dir_common/syn/vivado/tdma_ber_ch.tcl" \
  "$corundum_dir_common/rtl/eth_xcvr_phy_10g_gty_quad_wrapper.v" \
  "$corundum_dir_common/rtl/eth_xcvr_phy_10g_gty_wrapper.v" \
  "$corundum_dir_mod/eth/lib/axis/rtl/sync_reset.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_if.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_frame_sync.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_ber_mon.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_rx_watchdog.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_tx.v" \
  "$corundum_dir_mod/eth/rtl/eth_phy_10g_tx_if.v" \
  "$corundum_dir_mod/eth/rtl/lfsr.v" \
  "$corundum_dir_mod/eth/rtl/xgmii_baser_dec_64.v" \
  "$corundum_dir_mod/eth/rtl/xgmii_baser_enc_64.v" \
  "$corundum_dir_common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
]

adi_ip_properties_lite nic_core

set cc [ipx::current_core]

set_property display_name "NIC CORE" $cc
set_property description "CORUNDUM'S NIC CORE" $cc

adi_add_bus "axim_dma" "master" \
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

set_property master_address_space_ref axim_dma \
	[ipx::get_bus_interfaces axim_dma \
	-of_objects [ipx::current_core]]

adi_add_bus "axim_ddr" "master" \
	"xilinx.com:interface:aximm_rtl:1.0" \
	"xilinx.com:interface:aximm:1.0" \
        {
                {"m_axi_ddr_awid" "AWID"} \
                {"m_axi_ddr_awaddr" "AWADDR"} \
                {"m_axi_ddr_awlen" "AWLEN"} \
                {"m_axi_ddr_awsize" "AWSIZE"} \
                {"m_axi_ddr_awburst" "AWBURST"} \
                {"m_axi_ddr_awlock" "AWLOCK"} \
                {"m_axi_ddr_awcache" "AWCACHE"} \
                {"m_axi_ddr_awprot" "AWPROT"} \
                {"m_axi_ddr_awvalid" "AWVALID"} \
                {"m_axi_ddr_awready" "AWREADY"} \
		{"m_axi_ddr_wdata" "WDATA"} \
		{"m_axi_ddr_wstrb" "WSTRB"} \
		{"m_axi_ddr_wlast" "WLAST"} \
		{"m_axi_ddr_wvalid" "WVALID"} \
		{"m_axi_ddr_wready" "WREADY"} \
		{"m_axi_ddr_bid" "BID"} \
		{"m_axi_ddr_bresp" "BRESP"} \
		{"m_axi_ddr_bvalid" "BVALID"} \
		{"m_axi_ddr_bready" "BREADY"} \
		{"m_axi_ddr_arid" "ARID"} \
		{"m_axi_ddr_araddr" "ARADDR"} \
		{"m_axi_ddr_arlen" "ARLEN"} \
		{"m_axi_ddr_arsize" "ARSIZE"} \
		{"m_axi_ddr_arburst" "ARBURST"} \
		{"m_axi_ddr_arlock" "ARLOCK"} \
		{"m_axi_ddr_arcache" "ARCACHE"} \
		{"m_axi_ddr_arprot" "ARPROT"} \
		{"m_axi_ddr_arvalid" "ARVALID"} \
		{"m_axi_ddr_arready" "ARREADY"} \
		{"m_axi_ddr_rid" "RID"} \
		{"m_axi_ddr_rdata" "RDATA"} \
		{"m_axi_ddr_rresp" "RRESP"} \
		{"m_axi_ddr_rlast" "RLAST"} \
		{"m_axi_ddr_rvalid" "RVALID"} \
		{"m_axi_ddr_rready" "RREADY"} \
        }

adi_set_bus_dependency "axim_ddr" "axim_ddr" \
	"(spirit:decode(id('MODELPARAM_VALUE.DDR_ENABLE')) = 1)"

adi_add_bus "axil_app_ctrl" "slave" \
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

adi_set_bus_dependency "axil_app_ctrl" "axil_app_ctrl" \
	"(spirit:decode(id('MODELPARAM_VALUE.APP_ENABLE')) = 1)"

#foreach port {"s_axil_app_ctrl_awaddr" "s_axil_app_ctrl_awprot" \
  "s_axil_app_ctrl_awvalid" "s_axil_app_ctrl_awready" "s_axil_app_ctrl_wdata" "s_axil_app_ctrl_wstrb" \
  "s_axil_app_ctrl_wvalid" "s_axil_app_ctrl_wready" "s_axil_app_ctrl_bresp" "s_axil_app_ctrl_bvalid" \
  "s_axil_app_ctrl_bready" "s_axil_app_ctrl_araddr" "s_axil_app_ctrl_arprot" "s_axil_app_ctrl_arvalid" \
  "s_axil_app_ctrl_arready" s_axil_app_ctrl_rdata" "s_axil_app_ctrl_rresp" "s_axil_app_ctrl_rvalid" \
  "s_axil_app_ctrl_rready" } {
#	set_property DRIVER_VALUE "0" [ipx::get_ports $port]
#}

ipx::infer_bus_interface {\
    s_axi_awvalid \
    s_axi_awaddr \
    s_axi_awprot \
    s_axi_awready \
    s_axi_wvalid \
    s_axi_wdata \
    s_axi_wstrb \
    s_axi_wready \
    s_axi_bvalid \
    s_axi_bresp \

    s_axi_bready \
    s_axi_arvalid \
    s_axi_araddr \
    s_axi_arprot \
    s_axi_arready \
    s_axi_rvalid \
    s_axi_rdata \
    s_axi_rresp \
    s_axi_rready} \
  xilinx.com:interface:aximm_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface core_irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

ipx::infer_bus_interface core_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set core_rst_intf [ipx::infer_bus_interface core_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
set core_rst_polarity [ipx::add_bus_parameter "POLARITY" $core_rst_intf]
set_property value "ACTIVE_HIGH" $core_rst_polarity

set raddr_width [expr [get_property SIZE_LEFT [ipx::get_ports -nocase true s_axi_araddr -of_objects [ipx::current_core]]] + 1]
set waddr_width [expr [get_property SIZE_LEFT [ipx::get_ports -nocase true s_axi_awaddr -of_objects [ipx::current_core]]] + 1]

if {$raddr_width != $waddr_width} {
  puts [format "WARNING: AXI address width mismatch for %s (r=%d, w=%d)" $ip_name $raddr_width, $waddr_width]
  set range 65536
} else {
  if {$raddr_width >= 16} {
    set range 65536
  } else {
    set range [expr 1 << $raddr_width]
  }
}

ipx::add_memory_map {s_axi} [ipx::current_core]
set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]
ipx::add_address_block {axi_lite} [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]
set_property range $range [ipx::get_address_blocks axi_lite \
  -of_objects [ipx::get_memory_maps s_axi -of_objects [ipx::current_core]]]

ipx::associate_bus_interfaces -busif s_axi -clock core_clk -reset core_rst [ipx::current_core]
ipx::associate_bus_interfaces -busif axim_dma -clock core_clk -reset core_rst [ipx::current_core]
#ipx::associate_bus_interfaces -busif axim_dma -clock core_clk [ipx::current_core]
#ipx::associate_bus_interfaces -busif axil_ctrl -clock core_clk [ipx::current_core]

## customize XGUI layout

## remove the automatically generated GUI page

ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## create a new GUI page

ipgui::add_page -name {FW & Board Settings} -component $cc -display_name {FW & Board Settings}
set page0 [ipgui::get_pagespec -name "FW & Board Settings" -component $cc]

set group [ipgui::add_group -name "Board & Structural Configuration" -component $cc \
 -parent $page0 -display_name "Board & Structural Configuration"]

ipgui::add_param -name "TDMA_BER_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "TDMA_BER_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "TDMA_BER_ENABLE" \
] [ipgui::get_guiparamspec -name "TDMA_BER_ENABLE" -component $cc]

ipgui::add_param -name "IF_COUNT" -component $cc
set p [ipgui::get_guiparamspec -name "IF_COUNT" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "IF_COUNT" \
] [ipgui::get_guiparamspec -name "IF_COUNT" -component $cc]

ipgui::add_param -name "PORTS_PER_IF" -component $cc
set p [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "PORTS_PER_IF" \
] [ipgui::get_guiparamspec -name "PORTS_PER_IF" -component $cc]

ipgui::add_param -name "PORT_MASK" -component $cc
set p [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "PORT_MASK" \
] [ipgui::get_guiparamspec -name "PORT_MASK" -component $cc]

ipgui::add_page -name {Clock & PTP Settings} -component $cc -display_name {Clock & PTP Settings}
set page1 [ipgui::get_pagespec -name "Clock & PTP Settings" -component $cc]

set group [ipgui::add_group -name "Clock Configuration" -component $cc \
 -parent $page1 -display_name "Clock Configuration"]

ipgui::add_param -name "CLK_PERIOD_NS_NUM" -component $cc
set p [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_NUM" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "CLK_PERIOD_NS_NUM" \
] [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_NUM" -component $cc]

ipgui::add_param -name "CLK_PERIOD_NS_DENOM" -component $cc
set p [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_DENOM" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "CLK_PERIOD_NS_DENOM" \
] [ipgui::get_guiparamspec -name "CLK_PERIOD_NS_DENOM" -component $cc]

set group [ipgui::add_group -name "PTP Configuration" -component $cc \
 -parent $page1 -display_name "PTP Configuration"]

ipgui::add_param -name "PTP_CLK_PERIOD_NS_NUM" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_NUM" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_CLK_PERIOD_NS_NUM" \
] [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_NUM" -component $cc]

ipgui::add_param -name "PTP_CLK_PERIOD_NS_DENOM" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_DENOM" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_CLK_PERIOD_NS_DENOM" \
] [ipgui::get_guiparamspec -name "PTP_CLK_PERIOD_NS_DENOM" -component $cc]

ipgui::add_param -name "PTP_TS_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_TS_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_TS_WIDTH" \
] [ipgui::get_guiparamspec -name "PTP_TS_WIDTH" -component $cc]

ipgui::add_param -name "PTP_CLOCK_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_CLOCK_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_CLOCK_PIPELINE" \
] [ipgui::get_guiparamspec -name "PTP_CLOCK_PIPELINE" -component $cc]

ipgui::add_param -name "PTP_CLOCK_CDC_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_CLOCK_CDC_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_CLOCK_CDC_PIPELINE" \
] [ipgui::get_guiparamspec -name "PTP_CLOCK_CDC_PIPELINE" -component $cc]

ipgui::add_param -name "PTP_USE_SAMPLE_CLOCK" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_USE_SAMPLE_CLOCK" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP_USE_SAMPLE_CLOCK" \
] [ipgui::get_guiparamspec -name "PTP_USE_SAMPLE_CLOCK" -component $cc]

ipgui::add_param -name "PTP_PORT_CDC_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_PORT_CDC_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_PORT_CDC_PIPELINE" \
] [ipgui::get_guiparamspec -name "PTP_PORT_CDC_PIPELINE" -component $cc]

ipgui::add_param -name "PTP_PEROUT_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 7 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP_PEROUT_ENABLE" \
] [ipgui::get_guiparamspec -name "PTP_PEROUT_ENABLE" -component $cc]

ipgui::add_param -name "PTP_PEROUT_COUNT" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_PEROUT_COUNT" -component $cc]
ipgui::move_param -component $cc -order 8 $p -parent $group
set_property -dict [list \
  "display_name" "PTP_PEROUT_COUNT" \
] [ipgui::get_guiparamspec -name "PTP_PEROUT_COUNT" -component $cc]

ipgui::add_param -name "IF_PTP_PERIOD_NS" -component $cc
set p [ipgui::get_guiparamspec -name "IF_PTP_PERIOD_NS" -component $cc]
ipgui::move_param -component $cc -order 9 $p -parent $group
set_property -dict [list \
  "display_name" "IF_PTP_PERIOD_NS" \
] [ipgui::get_guiparamspec -name "IF_PTP_PERIOD_NS" -component $cc]

ipgui::add_param -name "IF_PTP_PERIOD_FNS" -component $cc
set p [ipgui::get_guiparamspec -name "IF_PTP_PERIOD_FNS" -component $cc]
ipgui::move_param -component $cc -order 10 $p -parent $group
set_property -dict [list \
  "display_name" "IF_PTP_PERIOD_FNS" \
] [ipgui::get_guiparamspec -name "IF_PTP_PERIOD_FNS" -component $cc]

ipgui::add_page -name {Queue Settings} -component $cc -display_name {Queue Settings}
set page2 [ipgui::get_pagespec -name "Queue Settings" -component $cc]

set group [ipgui::add_group -name "General Configuration" -component $cc \
 -parent $page2 -display_name "General Configuration"]

ipgui::add_param -name "EVENT_QUEUE_OP_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "EVENT_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "EVENT_QUEUE_OP_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "EVENT_QUEUE_OP_TABLE_SIZE" -component $cc]

ipgui::add_param -name "CQ_OP_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "CQ_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "CQ_OP_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "CQ_OP_TABLE_SIZE" -component $cc]

ipgui::add_param -name "EQN_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "EQN_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "EQN_WIDTH" \
] [ipgui::get_guiparamspec -name "EQN_WIDTH" -component $cc]

ipgui::add_param -name "EQ_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "EQ_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "EQ_PIPELINE" \
] [ipgui::get_guiparamspec -name "EQ_PIPELINE" -component $cc]

set group [ipgui::add_group -name "TX Configuration" -component $cc \
 -parent $page2 -display_name "TX Configuration"]

ipgui::add_param -name "TX_QUEUE_OP_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "TX_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "TX_QUEUE_OP_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "TX_QUEUE_OP_TABLE_SIZE" -component $cc]

ipgui::add_param -name "TX_QUEUE_INDEX_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "TX_QUEUE_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "TX_QUEUE_INDEX_WIDTH" \
] [ipgui::get_guiparamspec -name "TX_QUEUE_INDEX_WIDTH" -component $cc]

ipgui::add_param -name "TX_DESC_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "TX_DESC_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "TX_DESC_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "TX_DESC_TABLE_SIZE" -component $cc]

ipgui::add_param -name "TDMA_INDEX_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "TDMA_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "TDMA_INDEX_WIDTH" \
] [ipgui::get_guiparamspec -name "TDMA_INDEX_WIDTH" -component $cc]

set group [ipgui::add_group -name "RX Configuration" -component $cc \
 -parent $page2 -display_name "RX Configuration"]

ipgui::add_param -name "RX_QUEUE_OP_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "RX_QUEUE_OP_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "RX_QUEUE_OP_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "RX_QUEUE_OP_TABLE_SIZE" -component $cc]

ipgui::add_param -name "RX_QUEUE_INDEX_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "RX_QUEUE_INDEX_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "RX_QUEUE_INDEX_WIDTH" \
] [ipgui::get_guiparamspec -name "RX_QUEUE_INDEX_WIDTH" -component $cc]

ipgui::add_param -name "RX_DESC_TABLE_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "RX_DESC_TABLE_SIZE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "RX_DESC_TABLE_SIZE" \
] [ipgui::get_guiparamspec -name "RX_DESC_TABLE_SIZE" -component $cc]

ipgui::add_page -name {Interface Configuration} -component $cc -display_name {Interface Configuration}
set page3 [ipgui::get_pagespec -name "Interface Configuration" -component $cc]

set group [ipgui::add_group -name "General Configuration" -component $cc \
 -parent $page3 -display_name "General Configuration"]

ipgui::add_param -name "PTP_TS_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "PTP_TS_ENABLE" \
] [ipgui::get_guiparamspec -name "PTP_TS_ENABLE" -component $cc]

ipgui::add_param -name "ENABLE_PADDING" -component $cc
set p [ipgui::get_guiparamspec -name "ENABLE_PADDING" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "ENABLE_PADDING" \
] [ipgui::get_guiparamspec -name "ENABLE_PADDING" -component $cc]

ipgui::add_param -name "ENABLE_DIC" -component $cc
set p [ipgui::get_guiparamspec -name "ENABLE_DIC" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "ENABLE_DIC" \
] [ipgui::get_guiparamspec -name "ENABLE_DIC" -component $cc]

ipgui::add_param -name "MIN_FRAME_LENGTH" -component $cc
set p [ipgui::get_guiparamspec -name "MIN_FRAME_LENGTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "MIN_FRAME_LENGTH" \
] [ipgui::get_guiparamspec -name "MIN_FRAME_LENGTH" -component $cc]

set group [ipgui::add_group -name "TX Configuration" -component $cc \
 -parent $page3 -display_name "TX Configuration"]

ipgui::add_param -name "TX_CPL_FIFO_DEPTH" -component $cc
set p [ipgui::get_guiparamspec -name "TX_CPL_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "TX_CPL_FIFO_DEPTH" \
] [ipgui::get_guiparamspec -name "TX_CPL_FIFO_DEPTH" -component $cc]

ipgui::add_param -name "TX_TAG_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "TX_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "TX_TAG_WIDTH" \
] [ipgui::get_guiparamspec -name "TX_TAG_WIDTH" -component $cc]

ipgui::add_param -name "TX_CHECKSUM_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "TX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "TX_CHECKSUM_ENABLE" \
] [ipgui::get_guiparamspec -name "TX_CHECKSUM_ENABLE" -component $cc]

ipgui::add_param -name "TX_FIFO_DEPTH" -component $cc
set p [ipgui::get_guiparamspec -name "TX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "TX_FIFO_DEPTH" \
] [ipgui::get_guiparamspec -name "TX_FIFO_DEPTH" -component $cc]

ipgui::add_param -name "MAX_TX_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "MAX_TX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "MAX_TX_SIZE" \
] [ipgui::get_guiparamspec -name "MAX_TX_SIZE" -component $cc]

ipgui::add_param -name "TX_RAM_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "TX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property -dict [list \
  "display_name" "TX_RAM_SIZE" \
] [ipgui::get_guiparamspec -name "TX_RAM_SIZE" -component $cc]

set group [ipgui::add_group -name "RX Configuration" -component $cc \
 -parent $page3 -display_name "RX Configuration"]

ipgui::add_param -name "RX_HASH_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "RX_HASH_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "RX_HASH_ENABLE" \
] [ipgui::get_guiparamspec -name "RX_HASH_ENABLE" -component $cc]

ipgui::add_param -name "RX_CHECKSUM_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "RX_CHECKSUM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "RX_CHECKSUM_ENABLE" \
] [ipgui::get_guiparamspec -name "RX_CHECKSUM_ENABLE" -component $cc]

ipgui::add_param -name "RX_FIFO_DEPTH" -component $cc
set p [ipgui::get_guiparamspec -name "RX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "RX_FIFO_DEPTH" \
] [ipgui::get_guiparamspec -name "RX_FIFO_DEPTH" -component $cc]

ipgui::add_param -name "MAX_RX_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "MAX_RX_SIZE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "MAX_RX_SIZE" \
] [ipgui::get_guiparamspec -name "MAX_RX_SIZE" -component $cc]

ipgui::add_param -name "RX_RAM_SIZE" -component $cc
set p [ipgui::get_guiparamspec -name "RX_RAM_SIZE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "RX_RAM_SIZE" \
] [ipgui::get_guiparamspec -name "RX_RAM_SIZE" -component $cc]

set group [ipgui::add_group -name "RAM Configuration" -component $cc \
 -parent $page3 -display_name "RAM Configuration"]

ipgui::add_param -name "DDR_CH" -component $cc
set p [ipgui::get_guiparamspec -name "DDR_CH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "DDR_CH" \
] [ipgui::get_guiparamspec -name "DDR_CH" -component $cc]

ipgui::add_param -name "DDR_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "DDR_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "DDR_ENABLE" \
] [ipgui::get_guiparamspec -name "DDR_ENABLE" -component $cc]

ipgui::add_param -name "AXI_DDR_DATA_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DDR_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DDR_DATA_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_DDR_DATA_WIDTH" -component $cc]

ipgui::add_param -name "AXI_DDR_ADDR_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DDR_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DDR_ADDR_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_DDR_ADDR_WIDTH" -component $cc]

ipgui::add_param -name "AXI_DDR_ID_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DDR_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DDR_ID_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_DDR_ID_WIDTH" -component $cc]

ipgui::add_param -name "AXI_DDR_MAX_BURST_LEN" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DDR_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DDR_MAX_BURST_LEN" \
] [ipgui::get_guiparamspec -name "AXI_DDR_MAX_BURST_LEN" -component $cc]

ipgui::add_param -name "AXI_DDR_NARROW_BURST" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DDR_NARROW_BURST" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DDR_NARROW_BURST" \
] [ipgui::get_guiparamspec -name "AXI_DDR_NARROW_BURST" -component $cc]

ipgui::add_page -name {App Configuration} -component $cc -display_name {App Configuration}
set page4 [ipgui::get_pagespec -name "App Configuration" -component $cc]

set group [ipgui::add_group -name "General Configuration" -component $cc \
 -parent $page4 -display_name "General Configuration"]

ipgui::add_param -name "APP_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_ENABLE" -component $cc]

ipgui::add_param -name "APP_CTRL_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_CTRL_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_CTRL_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_CTRL_ENABLE" -component $cc]

ipgui::add_param -name "APP_DMA_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_DMA_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_DMA_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_DMA_ENABLE" -component $cc]

ipgui::add_param -name "APP_AXIS_DIRECT_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_AXIS_DIRECT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_AXIS_DIRECT_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_AXIS_DIRECT_ENABLE" -component $cc]

ipgui::add_param -name "APP_AXIS_SYNC_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_AXIS_SYNC_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_AXIS_SYNC_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_AXIS_SYNC_ENABLE" -component $cc]

ipgui::add_param -name "APP_AXIS_IF_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_AXIS_IF_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_AXIS_IF_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_AXIS_IF_ENABLE" -component $cc]

ipgui::add_param -name "APP_STAT_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "APP_STAT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 6 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "APP_STAT_ENABLE" \
] [ipgui::get_guiparamspec -name "APP_STAT_ENABLE" -component $cc]

set group [ipgui::add_group -name "AXI_DMA Configuration" -component $cc \
 -parent $page4 -display_name "AXI_DMA Configuration"]

ipgui::add_param -name "AXI_DATA_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DATA_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_DATA_WIDTH" -component $cc]

ipgui::add_param -name "AXI_ADDR_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_ADDR_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_ADDR_WIDTH" -component $cc]

ipgui::add_param -name "AXI_ID_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_ID_WIDTH" \
] [ipgui::get_guiparamspec -name "AXI_ID_WIDTH" -component $cc]

set group [ipgui::add_group -name "DMA Configuration" -component $cc \
 -parent $page4 -display_name "DMA Configuration"]

ipgui::add_param -name "DMA_IMM_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "DMA_IMM_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "DMA_IMM_ENABLE" \
] [ipgui::get_guiparamspec -name "DMA_IMM_ENABLE" -component $cc]

ipgui::add_param -name "DMA_IMM_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "DMA_IMM_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "DMA_IMM_WIDTH" \
] [ipgui::get_guiparamspec -name "DMA_IMM_WIDTH" -component $cc]

ipgui::add_param -name "DMA_LEN_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "DMA_LEN_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "DMA_LEN_WIDTH" \
] [ipgui::get_guiparamspec -name "DMA_LEN_WIDTH" -component $cc]

ipgui::add_param -name "DMA_TAG_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "DMA_TAG_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "DMA_TAG_WIDTH" \
] [ipgui::get_guiparamspec -name "DMA_TAG_WIDTH" -component $cc]

ipgui::add_param -name "RAM_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "RAM_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "RAM_PIPELINE" \
] [ipgui::get_guiparamspec -name "RAM_PIPELINE" -component $cc]

ipgui::add_param -name "AXI_DMA_MAX_BURST_LEN" -component $cc
set p [ipgui::get_guiparamspec -name "AXI_DMA_MAX_BURST_LEN" -component $cc]
ipgui::move_param -component $cc -order 5 $p -parent $group
set_property -dict [list \
  "display_name" "AXI_DMA_MAX_BURST_LEN" \
] [ipgui::get_guiparamspec -name "AXI_DMA_MAX_BURST_LEN" -component $cc]

set group [ipgui::add_group -name "IRQ & AXI-lite Configuration" -component $cc \
 -parent $page4 -display_name "IRQ & AXI-lite Configuration"]

ipgui::add_param -name "AXIL_CTRL_DATA_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXIL_CTRL_DATA_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "AXIL_CTRL_DATA_WIDTH" \
] [ipgui::get_guiparamspec -name "AXIL_CTRL_DATA_WIDTH" -component $cc]

ipgui::add_param -name "AXIL_CTRL_ADDR_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXIL_CTRL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "AXIL_CTRL_ADDR_WIDTH" \
] [ipgui::get_guiparamspec -name "AXIL_CTRL_ADDR_WIDTH" -component $cc]

ipgui::add_param -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "AXIL_APP_CTRL_ADDR_WIDTH" \
] [ipgui::get_guiparamspec -name "AXIL_APP_CTRL_ADDR_WIDTH" -component $cc]

set group [ipgui::add_group -name "Ethernet IF Configuration" -component $cc \
 -parent $page4 -display_name "Ethernet IF Configuration"]

ipgui::add_param -name "AXIS_ETH_TX_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "AXIS_ETH_TX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "AXIS_ETH_TX_PIPELINE" \
] [ipgui::get_guiparamspec -name "AXIS_ETH_TX_PIPELINE" -component $cc]

ipgui::add_param -name "AXIS_ETH_TX_FIFO_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "AXIS_ETH_TX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "AXIS_ETH_TX_FIFO_PIPELINE" \
] [ipgui::get_guiparamspec -name "AXIS_ETH_TX_FIFO_PIPELINE" -component $cc]

ipgui::add_param -name "AXIS_ETH_TX_TS_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "AXIS_ETH_TX_TS_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "display_name" "AXIS_ETH_TX_TS_PIPELINE" \
] [ipgui::get_guiparamspec -name "AXIS_ETH_TX_TS_PIPELINE" -component $cc]

ipgui::add_param -name "AXIS_ETH_RX_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "AXIS_ETH_RX_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "AXIS_ETH_RX_PIPELINE" \
] [ipgui::get_guiparamspec -name "AXIS_ETH_RX_PIPELINE" -component $cc]

ipgui::add_param -name "AXIS_ETH_RX_FIFO_PIPELINE" -component $cc
set p [ipgui::get_guiparamspec -name "AXIS_ETH_RX_FIFO_PIPELINE" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "AXIS_ETH_RX_FIFO_PIPELINE" \
] [ipgui::get_guiparamspec -name "AXIS_ETH_RX_FIFO_PIPELINE" -component $cc]

set group [ipgui::add_group -name "Statistics Configuration" -component $cc \
 -parent $page4 -display_name "Statistics Configuration"]

ipgui::add_param -name "STAT_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "STAT_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "STAT_ENABLE" \
] [ipgui::get_guiparamspec -name "STAT_ENABLE" -component $cc]

ipgui::add_param -name "STAT_DMA_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "STAT_DMA_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "STAT_DMA_ENABLE" \
] [ipgui::get_guiparamspec -name "STAT_DMA_ENABLE" -component $cc]

ipgui::add_param -name "STAT_AXI_ENABLE" -component $cc
set p [ipgui::get_guiparamspec -name "STAT_AXI_ENABLE" -component $cc]
ipgui::move_param -component $cc -order 2 $p -parent $group
set_property -dict [list \
  "widget" "checkBox" \
  "display_name" "STAT_AXI_ENABLE" \
] [ipgui::get_guiparamspec -name "STAT_AXI_ENABLE" -component $cc]

ipgui::add_param -name "STAT_INC_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "STAT_INC_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 3 $p -parent $group
set_property -dict [list \
  "display_name" "STAT_INC_WIDTH" \
] [ipgui::get_guiparamspec -name "STAT_INC_WIDTH" -component $cc]

ipgui::add_param -name "STAT_ID_WIDTH" -component $cc
set p [ipgui::get_guiparamspec -name "STAT_ID_WIDTH" -component $cc]
ipgui::move_param -component $cc -order 4 $p -parent $group
set_property -dict [list \
  "display_name" "STAT_ID_WIDTH" \
] [ipgui::get_guiparamspec -name "STAT_ID_WIDTH" -component $cc]

adi_add_auto_fpga_spec_params

## save the modifications

ipx::create_xgui_files  $cc
ipx::save_core $cc
