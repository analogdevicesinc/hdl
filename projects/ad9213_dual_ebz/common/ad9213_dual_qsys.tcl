
set adc_data_width 512
set adc_dma_data_width 512

#
## IP instantiations and configuration
#

# ad9213_rx_0 JESD204B phy-link layer

add_instance ad9213_rx_0 adi_jesd204
set_instance_parameter_value ad9213_rx_0 {ID} {0}
set_instance_parameter_value ad9213_rx_0 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9213_rx_0 {SOFT_PCS} {true}
set_instance_parameter_value ad9213_rx_0 {LANE_RATE} {12812.5}
set_instance_parameter_value ad9213_rx_0 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value ad9213_rx_0 {REFCLK_FREQUENCY} {320.3125}
set_instance_parameter_value ad9213_rx_0 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value ad9213_rx_0 {NUM_OF_LANES} {16}

# ad9213_rx_1 JESD204B phy-link layer

add_instance ad9213_rx_1 adi_jesd204
set_instance_parameter_value ad9213_rx_1 {ID} {1}
set_instance_parameter_value ad9213_rx_1 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9213_rx_1 {SOFT_PCS} {true}
set_instance_parameter_value ad9213_rx_1 {LANE_RATE} {12812.5}
set_instance_parameter_value ad9213_rx_1 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value ad9213_rx_1 {REFCLK_FREQUENCY} {320.3125}
set_instance_parameter_value ad9213_rx_1 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value ad9213_rx_1 {NUM_OF_LANES} {16}

# ad9213_tpl_0 JESD204B transport layer

add_instance axi_ad9213_0 ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_ad9213_0 {ID} {0}
set_instance_parameter_value axi_ad9213_0 {NUM_CHANNELS} {2}
set_instance_parameter_value axi_ad9213_0 {NUM_LANES} {16}
set_instance_parameter_value axi_ad9213_0 {BITS_PER_SAMPLE} {16}
set_instance_parameter_value axi_ad9213_0 {CONVERTER_RESOLUTION} {16}
set_instance_parameter_value axi_ad9213_0 {TWOS_COMPLEMENT} {1}

add_instance axi_ad9213_1 ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_ad9213_1 {ID} {1}
set_instance_parameter_value axi_ad9213_1 {NUM_CHANNELS} {2}
set_instance_parameter_value axi_ad9213_1 {NUM_LANES} {16}
set_instance_parameter_value axi_ad9213_1 {BITS_PER_SAMPLE} {16}
set_instance_parameter_value axi_ad9213_1 {CONVERTER_RESOLUTION} {16}
set_instance_parameter_value axi_ad9213_1 {TWOS_COMPLEMENT} {1}

# pack(s)

add_instance util_ad9213_cpack_0 util_cpack2
set_instance_parameter_value util_ad9213_cpack_0 {NUM_OF_CHANNELS} {2}
set_instance_parameter_value util_ad9213_cpack_0 {SAMPLES_PER_CHANNEL} {16}
set_instance_parameter_value util_ad9213_cpack_0 {SAMPLE_DATA_WIDTH} {16}

add_instance util_ad9213_cpack_1 util_cpack2
set_instance_parameter_value util_ad9213_cpack_1 {NUM_OF_CHANNELS} {2}
set_instance_parameter_value util_ad9213_cpack_1 {SAMPLES_PER_CHANNEL} {16}
set_instance_parameter_value util_ad9213_cpack_1 {SAMPLE_DATA_WIDTH} {16}

# ADC FIFO's

ad_adcfifo_create "ad9213_adcfifo_0" $adc_data_width $adc_dma_data_width $adc_fifo_address_width
ad_adcfifo_create "ad9213_adcfifo_1" $adc_data_width $adc_dma_data_width $adc_fifo_address_width

# DMA instances

add_instance axi_ad9213_dma_0 axi_dmac
set_instance_parameter_value axi_ad9213_dma_0 {ID} {0}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_DATA_WIDTH_SRC} {512}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9213_dma_0 {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9213_dma_0 {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9213_dma_0 {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9213_dma_0 {CYCLIC} {0}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9213_dma_0 {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_ad9213_dma_0 {FIFO_SIZE} {8}

add_instance axi_ad9213_dma_1 axi_dmac
set_instance_parameter_value axi_ad9213_dma_1 {ID} {1}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_DATA_WIDTH_SRC} {512}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9213_dma_1 {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9213_dma_1 {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9213_dma_1 {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9213_dma_1 {CYCLIC} {0}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9213_dma_1 {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_ad9213_dma_1 {FIFO_SIZE} {8}

# SPI interfaces

add_instance adf4371_spi altera_avalon_spi
set_instance_parameter_value adf4371_spi {clockPhase} {0}
set_instance_parameter_value adf4371_spi {clockPolarity} {0}
set_instance_parameter_value adf4371_spi {dataWidth} {8}
set_instance_parameter_value adf4371_spi {masterSPI} {1}
set_instance_parameter_value adf4371_spi {numberOfSlaves} {1}
set_instance_parameter_value adf4371_spi {targetClockRate} {10000000.0}

add_instance ltc6952_spi altera_avalon_spi
set_instance_parameter_value ltc6952_spi {clockPhase} {0}
set_instance_parameter_value ltc6952_spi {clockPolarity} {0}
set_instance_parameter_value ltc6952_spi {dataWidth} {8}
set_instance_parameter_value ltc6952_spi {masterSPI} {1}
set_instance_parameter_value ltc6952_spi {numberOfSlaves} {1}
set_instance_parameter_value ltc6952_spi {targetClockRate} {10000000.0}

# ad9213x2 gpio

add_instance ad9213_dual_pio altera_avalon_pio
set_instance_parameter_value ad9213_dual_pio {direction} {Bidir}
set_instance_parameter_value ad9213_dual_pio {generateIRQ} {1}
set_instance_parameter_value ad9213_dual_pio {width} {10}
set_instance_parameter_value ad9213_dual_pio {edgeType} {RISING}

#
## clocks and resets
#

# system clock and reset

add_connection sys_clk.clk ad9213_rx_0.sys_clk
add_connection sys_clk.clk ad9213_rx_1.sys_clk
add_connection sys_clk.clk axi_ad9213_0.s_axi_clock
add_connection sys_clk.clk axi_ad9213_1.s_axi_clock
add_connection sys_clk.clk axi_ad9213_dma_0.s_axi_clock
add_connection sys_clk.clk axi_ad9213_dma_1.s_axi_clock
add_connection sys_clk.clk adf4371_spi.clk
add_connection sys_clk.clk ltc6952_spi.clk
add_connection sys_clk.clk ad9213_dual_pio.clk

add_connection sys_clk.clk_reset ad9213_rx_0.sys_resetn
add_connection sys_clk.clk_reset ad9213_rx_1.sys_resetn
add_connection sys_clk.clk_reset axi_ad9213_0.s_axi_reset
add_connection sys_clk.clk_reset axi_ad9213_1.s_axi_reset
add_connection sys_clk.clk_reset axi_ad9213_dma_0.s_axi_reset
add_connection sys_clk.clk_reset axi_ad9213_dma_1.s_axi_reset
add_connection sys_clk.clk_reset adf4371_spi.reset
add_connection sys_clk.clk_reset ltc6952_spi.reset
add_connection sys_clk.clk_reset ad9213_dual_pio.reset

# device clock and reset

add_connection ad9213_rx_0.link_clk axi_ad9213_0.link_clk
add_connection ad9213_rx_1.link_clk axi_ad9213_1.link_clk
add_connection ad9213_rx_0.link_clk util_ad9213_cpack_0.clk
add_connection ad9213_rx_1.link_clk util_ad9213_cpack_1.clk
add_connection ad9213_rx_0.link_clk ad9213_adcfifo_0.if_adc_clk
add_connection ad9213_rx_1.link_clk ad9213_adcfifo_1.if_adc_clk

add_connection ad9213_rx_0.link_reset util_ad9213_cpack_0.reset
add_connection ad9213_rx_1.link_reset util_ad9213_cpack_1.reset
add_connection ad9213_rx_0.link_reset ad9213_adcfifo_0.if_adc_rst
add_connection ad9213_rx_1.link_reset ad9213_adcfifo_1.if_adc_rst

# dma clock and reset

add_connection sys_dma_clk.clk ad9213_adcfifo_0.if_dma_clk
add_connection sys_dma_clk.clk ad9213_adcfifo_1.if_dma_clk
add_connection sys_dma_clk.clk axi_ad9213_dma_0.if_s_axis_aclk
add_connection sys_dma_clk.clk axi_ad9213_dma_1.if_s_axis_aclk
add_connection sys_dma_clk.clk axi_ad9213_dma_0.m_dest_axi_clock
add_connection sys_dma_clk.clk axi_ad9213_dma_1.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset axi_ad9213_dma_0.m_dest_axi_reset
add_connection sys_dma_clk.clk_reset axi_ad9213_dma_1.m_dest_axi_reset

#
## exported signals
#

add_interface rx_ref_clk_0            clock     sink
add_interface rx_ref_clk_1            clock     sink
add_interface rx_sysref_0             conduit   end
add_interface rx_sysref_1             conduit   end
add_interface rx_sync_0               conduit   end
add_interface rx_sync_1               conduit   end
add_interface ad9213_rx_0_serial_data conduit   end
add_interface ad9213_rx_1_serial_data conduit   end
add_interface ad9213_dual_pio         conduit   end
add_interface adf4371_spi             conduit   end
add_interface ltc6952_spi             conduit   end

set_interface_property rx_ref_clk_0            EXPORT_OF ad9213_rx_0.ref_clk
set_interface_property rx_ref_clk_1            EXPORT_OF ad9213_rx_1.ref_clk
set_interface_property rx_sysref_0             EXPORT_OF ad9213_rx_0.sysref
set_interface_property rx_sysref_1             EXPORT_OF ad9213_rx_1.sysref
set_interface_property rx_sync_0               EXPORT_OF ad9213_rx_0.sync
set_interface_property rx_sync_1               EXPORT_OF ad9213_rx_1.sync
set_interface_property ad9213_rx_0_serial_data EXPORT_OF ad9213_rx_0.serial_data
set_interface_property ad9213_rx_1_serial_data EXPORT_OF ad9213_rx_1.serial_data
set_interface_property ad9213_dual_pio         EXPORT_OF ad9213_dual_pio.external_connection
set_interface_property adf4371_spi             EXPORT_OF adf4371_spi.external
set_interface_property ltc6952_spi             EXPORT_OF ltc6952_spi.external

#
## data interfaces / data path
#

# phy/link to tpl
add_connection ad9213_rx_0.link_sof axi_ad9213_0.if_link_sof
add_connection ad9213_rx_1.link_sof axi_ad9213_1.if_link_sof
add_connection ad9213_rx_0.link_data axi_ad9213_0.link_data
add_connection ad9213_rx_1.link_data axi_ad9213_1.link_data

# tpl to pack
add_connection util_ad9213_cpack_0.adc_ch_0 axi_ad9213_0.adc_ch_0
add_connection util_ad9213_cpack_0.adc_ch_1 axi_ad9213_0.adc_ch_1
add_connection util_ad9213_cpack_1.adc_ch_0 axi_ad9213_1.adc_ch_0
add_connection util_ad9213_cpack_1.adc_ch_1 axi_ad9213_1.adc_ch_1

# pack to ADC buffer
add_connection util_ad9213_cpack_0.if_packed_fifo_wr_data ad9213_adcfifo_0.if_adc_wdata
add_connection util_ad9213_cpack_0.if_packed_fifo_wr_en ad9213_adcfifo_0.if_adc_wr
add_connection util_ad9213_cpack_1.if_packed_fifo_wr_data ad9213_adcfifo_1.if_adc_wdata
add_connection util_ad9213_cpack_1.if_packed_fifo_wr_en ad9213_adcfifo_1.if_adc_wr

# ADC buffer to DMA
add_connection ad9213_adcfifo_0.m_axis axi_ad9213_dma_0.s_axis
add_connection ad9213_adcfifo_1.m_axis axi_ad9213_dma_1.s_axis

add_connection axi_ad9213_dma_0.if_s_axis_xfer_req ad9213_adcfifo_0.if_dma_xfer_req
add_connection axi_ad9213_0.if_adc_dovf ad9213_adcfifo_0.if_adc_wovf
add_connection axi_ad9213_dma_1.if_s_axis_xfer_req ad9213_adcfifo_1.if_dma_xfer_req
add_connection axi_ad9213_1.if_adc_dovf ad9213_adcfifo_1.if_adc_wovf

# DMA to HPS memory
ad_dma_interconnect axi_ad9213_dma_0.m_dest_axi
ad_dma_interconnect axi_ad9213_dma_1.m_dest_axi

#
## address Map
#

##
## NOTE: if bridge is used, the address will be bridge_base_addr + peripheral_base_addr
##

ad_cpu_interconnect 0x00020000 ad9213_rx_0.link_pll_reconfig "avl_mm_bridge_0" 0x00040000
ad_cpu_interconnect 0x00000000 ad9213_rx_0.phy_reconfig_0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00002000 ad9213_rx_0.phy_reconfig_1    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00004000 ad9213_rx_0.phy_reconfig_2    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00006000 ad9213_rx_0.phy_reconfig_3    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00008000 ad9213_rx_0.phy_reconfig_4    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000A000 ad9213_rx_0.phy_reconfig_5    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000C000 ad9213_rx_0.phy_reconfig_6    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000E000 ad9213_rx_0.phy_reconfig_7    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00010000 ad9213_rx_0.phy_reconfig_8    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00012000 ad9213_rx_0.phy_reconfig_9    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00014000 ad9213_rx_0.phy_reconfig_10   "avl_mm_bridge_0"
ad_cpu_interconnect 0x00016000 ad9213_rx_0.phy_reconfig_11   "avl_mm_bridge_0"
ad_cpu_interconnect 0x00018000 ad9213_rx_0.phy_reconfig_12   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001A000 ad9213_rx_0.phy_reconfig_13   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001C000 ad9213_rx_0.phy_reconfig_14   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001E000 ad9213_rx_0.phy_reconfig_15   "avl_mm_bridge_0"

ad_cpu_interconnect 0x00020000 ad9213_rx_1.link_pll_reconfig "avl_mm_bridge_1" 0x00080000
ad_cpu_interconnect 0x00000000 ad9213_rx_1.phy_reconfig_0    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00002000 ad9213_rx_1.phy_reconfig_1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00004000 ad9213_rx_1.phy_reconfig_2    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00006000 ad9213_rx_1.phy_reconfig_3    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00008000 ad9213_rx_1.phy_reconfig_4    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000A000 ad9213_rx_1.phy_reconfig_5    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000C000 ad9213_rx_1.phy_reconfig_6    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000E000 ad9213_rx_1.phy_reconfig_7    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00010000 ad9213_rx_1.phy_reconfig_8    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00012000 ad9213_rx_1.phy_reconfig_9    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00014000 ad9213_rx_1.phy_reconfig_10   "avl_mm_bridge_1"
ad_cpu_interconnect 0x00016000 ad9213_rx_1.phy_reconfig_11   "avl_mm_bridge_1"
ad_cpu_interconnect 0x00018000 ad9213_rx_1.phy_reconfig_12   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001A000 ad9213_rx_1.phy_reconfig_13   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001C000 ad9213_rx_1.phy_reconfig_14   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001E000 ad9213_rx_1.phy_reconfig_15   "avl_mm_bridge_1"

ad_cpu_interconnect 0x000C0000 ad9213_rx_0.link_reconfig
ad_cpu_interconnect 0x000C4000 ad9213_rx_0.link_management
ad_cpu_interconnect 0x000C8000 ad9213_rx_1.link_reconfig
ad_cpu_interconnect 0x000CC000 ad9213_rx_1.link_management
ad_cpu_interconnect 0x000D0000 axi_ad9213_0.s_axi
ad_cpu_interconnect 0x000D1000 axi_ad9213_1.s_axi
ad_cpu_interconnect 0x000D2000 axi_ad9213_dma_0.s_axi
ad_cpu_interconnect 0x000D3800 axi_ad9213_dma_1.s_axi

ad_cpu_interconnect 0x00000200 ltc6952_spi.spi_control_port "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000400 adf4371_spi.spi_control_port "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000800 ad9213_dual_pio.s1 "avl_peripheral_mm_bridge"

#
## interrupts
#

ad_cpu_interrupt 11 ad9213_rx_0.interrupt
ad_cpu_interrupt 12 ad9213_rx_1.interrupt
ad_cpu_interrupt 13 axi_ad9213_dma_0.interrupt_sender
ad_cpu_interrupt 14 axi_ad9213_dma_1.interrupt_sender
ad_cpu_interrupt 15 ad9213_dual_pio.irq
ad_cpu_interrupt 16 adf4371_spi.irq
ad_cpu_interrupt 17 ltc6952_spi.irq

