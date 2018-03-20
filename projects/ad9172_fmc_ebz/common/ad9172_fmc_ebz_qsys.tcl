
# ad9172-xcvr

add_instance ad9172_jesd204 adi_jesd204
set_instance_parameter_value ad9172_jesd204 {ID} {0}
set_instance_parameter_value ad9172_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value ad9172_jesd204 {NUM_OF_LANES} {8}
set_instance_parameter_value ad9172_jesd204 {LANE_RATE} {14200}
set_instance_parameter_value ad9172_jesd204 {REFCLK_FREQUENCY} {355}
set_instance_parameter_value ad9172_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value ad9172_jesd204 {LANE_MAP} {7 6 5 4 2 0 1 3}
set_instance_parameter_value ad9172_jesd204 {LANE_INVERT} 0xf0


add_connection sys_clk.clk ad9172_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9172_jesd204.sys_resetn
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF ad9172_jesd204.ref_clk
add_interface tx_serial_data conduit end
set_interface_property tx_serial_data EXPORT_OF ad9172_jesd204.serial_data
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF ad9172_jesd204.sysref
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF ad9172_jesd204.sync

# ad9172-core

add_instance axi_ad9172_core ad_ip_jesd204_tpl_dac
set_instance_parameter_value axi_ad9172_core {NUM_LANES} {8}
set_instance_parameter_value axi_ad9172_core {NUM_CHANNELS} {2}
set_instance_parameter_value axi_ad9172_core {CHANNEL_WIDTH} {16}

add_connection ad9172_jesd204.link_clk axi_ad9172_core.device_clk
add_connection axi_ad9172_core.link_data ad9172_jesd204.link_data
add_connection sys_clk.clk_reset axi_ad9172_core.s_axi_reset
add_connection sys_clk.clk axi_ad9172_core.s_axi_clock

# ad9172-unpack

add_instance util_ad9172_upack util_upack
set_instance_parameter_value util_ad9172_upack {CHANNEL_DATA_WIDTH} {128}
set_instance_parameter_value util_ad9172_upack {NUM_OF_CHANNELS} {2}

add_connection ad9172_jesd204.link_clk util_ad9172_upack.if_dac_clk
add_connection axi_ad9172_core.dac_ch_0 util_ad9172_upack.dac_ch_0
add_connection axi_ad9172_core.dac_ch_1 util_ad9172_upack.dac_ch_1

# dac fifo

add_interface tx_fifo_bypass conduit end
set_interface_property tx_fifo_bypass EXPORT_OF avl_ad9172_fifo.if_bypass

add_connection ad9172_jesd204.link_clk avl_ad9172_fifo.if_dac_clk
add_connection ad9172_jesd204.link_reset avl_ad9172_fifo.if_dac_rst
add_connection util_ad9172_upack.if_dac_valid avl_ad9172_fifo.if_dac_valid
add_connection avl_ad9172_fifo.if_dac_data util_ad9172_upack.if_dac_data
add_connection avl_ad9172_fifo.if_dac_dunf axi_ad9172_core.if_dac_dunf

# ad9172-dma

add_instance axi_ad9172_dma axi_dmac
set_instance_parameter_value axi_ad9172_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_ad9172_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9172_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9172_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9172_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9172_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9172_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9172_dma {CYCLIC} {1}
set_instance_parameter_value axi_ad9172_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_ad9172_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_ad9172_dma {FIFO_SIZE} {16}

add_connection sys_dma_clk.clk avl_ad9172_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_ad9172_fifo.if_dma_rst
add_connection sys_dma_clk.clk axi_ad9172_dma.if_m_axis_aclk
add_connection axi_ad9172_dma.if_m_axis_valid avl_ad9172_fifo.if_dma_valid
add_connection axi_ad9172_dma.if_m_axis_data avl_ad9172_fifo.if_dma_data
add_connection axi_ad9172_dma.if_m_axis_last avl_ad9172_fifo.if_dma_xfer_last
add_connection axi_ad9172_dma.if_m_axis_xfer_req avl_ad9172_fifo.if_dma_xfer_req
add_connection avl_ad9172_fifo.if_dma_ready axi_ad9172_dma.if_m_axis_ready
add_connection sys_clk.clk_reset axi_ad9172_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9172_dma.s_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9172_dma.m_src_axi_reset
add_connection sys_dma_clk.clk axi_ad9172_dma.m_src_axi_clock

# addresses

ad_cpu_interconnect 0x00020000 ad9172_jesd204.link_reconfig
ad_cpu_interconnect 0x00024000 ad9172_jesd204.link_management
ad_cpu_interconnect 0x00025000 ad9172_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00026000 ad9172_jesd204.lane_pll_reconfig
for {set i 0} {$i < 8} {incr i} {
  ad_cpu_interconnect [expr 0x00028000 + $i * 0x1000] ad9172_jesd204.phy_reconfig_${i}
}
ad_cpu_interconnect 0x00030000 axi_ad9172_core.s_axi
ad_cpu_interconnect 0x00040000 axi_ad9172_dma.s_axi

# dma interconnects

ad_dma_interconnect axi_ad9172_dma.m_src_axi

# interrupts

ad_cpu_interrupt 9 ad9172_jesd204.interrupt
ad_cpu_interrupt 11 axi_ad9172_dma.interrupt_sender
