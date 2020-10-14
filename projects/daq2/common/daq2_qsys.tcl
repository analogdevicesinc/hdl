
# JESD204B attributes

set RX_NUM_OF_LANES 4           ; # L
set RX_NUM_OF_CONVERTERS 2      ; # M
set RX_SAMPLES_PER_FRAME 1      ; # S
set RX_SAMPLE_WIDTH 16          ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]

set TX_NUM_OF_LANES 4           ; # L
set TX_NUM_OF_CONVERTERS 2      ; # M
set TX_SAMPLES_PER_FRAME 1      ; # S
set TX_SAMPLE_WIDTH 16          ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set dac_fifo_name avl_ad9144_fifo
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

# ad9144-xcvr

add_instance ad9144_jesd204 adi_jesd204
set_instance_parameter_value ad9144_jesd204 {ID} {0}
set_instance_parameter_value ad9144_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value ad9144_jesd204 {LANE_RATE} {10000}
set_instance_parameter_value ad9144_jesd204 {REFCLK_FREQUENCY} {333.333333}
set_instance_parameter_value ad9144_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value ad9144_jesd204 {LANE_MAP} {0 3 1 2}
set_instance_parameter_value ad9144_jesd204 {SOFT_PCS} {true}

add_connection sys_clk.clk ad9144_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9144_jesd204.sys_resetn
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF ad9144_jesd204.ref_clk
add_interface tx_serial_data conduit end
set_interface_property tx_serial_data EXPORT_OF ad9144_jesd204.serial_data
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF ad9144_jesd204.sysref
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF ad9144_jesd204.sync

# ad9144-core

add_instance axi_ad9144 ad_ip_jesd204_tpl_dac
set_instance_parameter_value axi_ad9144 {ID} {0}
set_instance_parameter_value axi_ad9144 {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_ad9144 {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value axi_ad9144 {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value axi_ad9144 {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH

add_connection ad9144_jesd204.link_clk axi_ad9144.link_clk
add_connection axi_ad9144.link_data ad9144_jesd204.link_data
add_connection sys_clk.clk_reset axi_ad9144.s_axi_reset
add_connection sys_clk.clk axi_ad9144.s_axi_clock

# ad9144-unpack

add_instance util_ad9144_upack util_upack2
set_instance_parameter_value util_ad9144_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value util_ad9144_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value util_ad9144_upack {SAMPLE_DATA_WIDTH} $TX_SAMPLE_WIDTH
set_instance_parameter_value util_ad9144_upack {INTERFACE_TYPE} {1}

add_connection ad9144_jesd204.link_clk util_ad9144_upack.clk
add_connection ad9144_jesd204.link_reset util_ad9144_upack.reset
add_connection axi_ad9144.dac_ch_0 util_ad9144_upack.dac_ch_0
add_connection axi_ad9144.dac_ch_1 util_ad9144_upack.dac_ch_1

# dac fifo

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_data_width $dac_fifo_address_width

add_interface tx_fifo_bypass conduit end
set_interface_property tx_fifo_bypass EXPORT_OF avl_ad9144_fifo.if_bypass

add_connection ad9144_jesd204.link_clk avl_ad9144_fifo.if_dac_clk
add_connection ad9144_jesd204.link_reset avl_ad9144_fifo.if_dac_rst
add_connection util_ad9144_upack.if_packed_fifo_rd_en avl_ad9144_fifo.if_dac_valid
add_connection avl_ad9144_fifo.if_dac_data util_ad9144_upack.if_packed_fifo_rd_data
add_connection avl_ad9144_fifo.if_dac_dunf axi_ad9144.if_dac_dunf

# ad9144-dma

add_instance axi_ad9144_dma axi_dmac
set_instance_parameter_value axi_ad9144_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_ad9144_dma {DMA_DATA_WIDTH_DEST} $dac_data_width
set_instance_parameter_value axi_ad9144_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9144_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9144_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9144_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9144_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9144_dma {CYCLIC} {1}
set_instance_parameter_value axi_ad9144_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_ad9144_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_ad9144_dma {FIFO_SIZE} {16}
set_instance_parameter_value axi_ad9144_dma {HAS_AXIS_TLAST} {1}

add_connection sys_dma_clk.clk avl_ad9144_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_ad9144_fifo.if_dma_rst
add_connection sys_dma_clk.clk axi_ad9144_dma.if_m_axis_aclk
add_connection axi_ad9144_dma.m_axis avl_ad9144_fifo.s_axis
add_connection axi_ad9144_dma.if_m_axis_xfer_req avl_ad9144_fifo.if_dma_xfer_req
add_connection sys_clk.clk_reset axi_ad9144_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9144_dma.s_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9144_dma.m_src_axi_reset
add_connection sys_dma_clk.clk axi_ad9144_dma.m_src_axi_clock

# ad9680-xcvr

add_instance ad9680_jesd204 adi_jesd204
set_instance_parameter_value ad9680_jesd204 {ID} {1}
set_instance_parameter_value ad9680_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9680_jesd204 {LANE_RATE} {10000.0}
set_instance_parameter_value ad9680_jesd204 {REFCLK_FREQUENCY} {333.333333}
set_instance_parameter_value ad9680_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value ad9680_jesd204 {SOFT_PCS} {true}

add_connection sys_clk.clk ad9680_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9680_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF ad9680_jesd204.ref_clk
add_interface rx_serial_data conduit end
set_interface_property rx_serial_data EXPORT_OF ad9680_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF ad9680_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF ad9680_jesd204.sync

# ad9680

add_instance axi_ad9680 ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_ad9680 {ID} {0}
set_instance_parameter_value axi_ad9680 {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_ad9680 {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value axi_ad9680 {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_ad9680 {CONVERTER_RESOLUTION} {14}
set_instance_parameter_value axi_ad9680 {TWOS_COMPLEMENT} {0}

add_connection ad9680_jesd204.link_clk axi_ad9680.link_clk
add_connection ad9680_jesd204.link_sof axi_ad9680.if_link_sof
add_connection ad9680_jesd204.link_data axi_ad9680.link_data
add_connection sys_clk.clk_reset axi_ad9680.s_axi_reset
add_connection sys_clk.clk axi_ad9680.s_axi_clock

# ad9680-pack

add_instance util_ad9680_cpack util_cpack2
set_instance_parameter_value util_ad9680_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value util_ad9680_cpack {SAMPLES_PER_CHANNEL} $RX_NUM_OF_LANES
set_instance_parameter_value util_ad9680_cpack {SAMPLE_DATA_WIDTH} $RX_SAMPLE_WIDTH

add_connection ad9680_jesd204.link_reset util_ad9680_cpack.reset
add_connection ad9680_jesd204.link_clk util_ad9680_cpack.clk
add_connection axi_ad9680.adc_ch_0 util_ad9680_cpack.adc_ch_0
add_connection axi_ad9680.adc_ch_1 util_ad9680_cpack.adc_ch_1

# ad9680-fifo

add_instance ad9680_adcfifo util_adcfifo
set_instance_parameter_value ad9680_adcfifo {ADC_DATA_WIDTH} $adc_data_width
set_instance_parameter_value ad9680_adcfifo {DMA_DATA_WIDTH} $adc_data_width
set_instance_parameter_value ad9680_adcfifo {DMA_ADDRESS_WIDTH} {16}

add_connection sys_clk.clk_reset ad9680_adcfifo.if_adc_rst
add_connection ad9680_jesd204.link_clk ad9680_adcfifo.if_adc_clk
add_connection util_ad9680_cpack.if_packed_fifo_wr_en ad9680_adcfifo.if_adc_wr
add_connection util_ad9680_cpack.if_packed_fifo_wr_data ad9680_adcfifo.if_adc_wdata
add_connection sys_dma_clk.clk ad9680_adcfifo.if_dma_clk
add_connection sys_dma_clk.clk_reset ad9680_adcfifo.if_adc_rst

# ad9680-dma

add_instance axi_ad9680_dma axi_dmac
set_instance_parameter_value axi_ad9680_dma {DMA_DATA_WIDTH_SRC} $adc_data_width
set_instance_parameter_value axi_ad9680_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9680_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9680_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9680_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9680_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9680_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9680_dma {DMA_TYPE_SRC} {1}

add_connection sys_dma_clk.clk axi_ad9680_dma.if_s_axis_aclk
add_connection ad9680_adcfifo.m_axis axi_ad9680_dma.s_axis
add_connection ad9680_adcfifo.if_dma_xfer_req axi_ad9680_dma.if_s_axis_xfer_req
add_connection ad9680_adcfifo.if_adc_wovf axi_ad9680.if_adc_dovf
add_connection sys_clk.clk_reset axi_ad9680_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9680_dma.s_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9680_dma.m_dest_axi_reset
add_connection sys_dma_clk.clk axi_ad9680_dma.m_dest_axi_clock

# reconfig sharing

for {set i 0} {$i < $TX_NUM_OF_LANES} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  set_instance_parameter_value avl_adxcfg_${i} {ADDRESS_WIDTH} $xcvr_reconfig_addr_width
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m0 ad9144_jesd204.phy_reconfig_${i}
  add_connection avl_adxcfg_${i}.rcfg_m1 ad9680_jesd204.phy_reconfig_${i}
}

# addresses

ad_cpu_interconnect 0x00000000 ad9144_jesd204.link_reconfig     "axi_mm_bridge_0"  0x00080000
ad_cpu_interconnect 0x00004000 ad9680_jesd204.link_reconfig     "axi_mm_bridge_0"
ad_cpu_interconnect 0x00008000 ad9144_jesd204.link_management   "axi_mm_bridge_0"
ad_cpu_interconnect 0x00009000 ad9680_jesd204.link_management   "axi_mm_bridge_0"
ad_cpu_interconnect 0x0000A000 axi_ad9144.s_axi                 "axi_mm_bridge_0"
ad_cpu_interconnect 0x0000E000 axi_ad9680.s_axi                 "axi_mm_bridge_0"
ad_cpu_interconnect 0x00012000 axi_ad9144_dma.s_axi             "axi_mm_bridge_0"
ad_cpu_interconnect 0x00012800 axi_ad9680_dma.s_axi             "axi_mm_bridge_0"
ad_cpu_interconnect 0x00000000 ad9144_jesd204.link_pll_reconfig "avl_mm_bridge_tx" 0x00060000
ad_cpu_interconnect 0x00001000 ad9144_jesd204.lane_pll_reconfig "avl_mm_bridge_tx"
ad_cpu_interconnect 0x00002000 avl_adxcfg_0.rcfg_s0             "avl_mm_bridge_tx"
ad_cpu_interconnect 0x00003000 avl_adxcfg_1.rcfg_s0             "avl_mm_bridge_tx"
ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s0             "avl_mm_bridge_tx"
ad_cpu_interconnect 0x00005000 avl_adxcfg_3.rcfg_s0             "avl_mm_bridge_tx"
ad_cpu_interconnect 0x00000000 ad9680_jesd204.link_pll_reconfig "avl_mm_bridge_rx" 0x00068000
ad_cpu_interconnect 0x00001000 avl_adxcfg_0.rcfg_s1             "avl_mm_bridge_rx"
ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s1             "avl_mm_bridge_rx"
ad_cpu_interconnect 0x00003000 avl_adxcfg_2.rcfg_s1             "avl_mm_bridge_rx"
ad_cpu_interconnect 0x00004000 avl_adxcfg_3.rcfg_s1             "avl_mm_bridge_rx"


# dma interconnects

ad_dma_interconnect axi_ad9144_dma.m_src_axi
ad_dma_interconnect axi_ad9680_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 8 ad9680_jesd204.interrupt
ad_cpu_interrupt 9 ad9144_jesd204.interrupt
ad_cpu_interrupt 10 axi_ad9680_dma.interrupt_sender
ad_cpu_interrupt 11 axi_ad9144_dma.interrupt_sender
