set dac_fifo_name avl_ad9371_tx_fifo
set dac_data_width 128
set dac_dma_data_width 128

# ad9371_tx JESD204

add_instance ad9371_tx_jesd204 adi_jesd204
set_instance_parameter_value ad9371_tx_jesd204 {ID} {0}
set_instance_parameter_value ad9371_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value ad9371_tx_jesd204 {LANE_RATE} {4915.2}
set_instance_parameter_value ad9371_tx_jesd204 {REFCLK_FREQUENCY} {122.88}
set_instance_parameter_value ad9371_tx_jesd204 {NUM_OF_LANES} {4}
set_instance_parameter_value ad9371_tx_jesd204 {LANE_MAP} {3 0 1 2}
set_instance_parameter_value ad9371_tx_jesd204 {SOFT_PCS} {false}

add_connection sys_clk.clk ad9371_tx_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9371_tx_jesd204.sys_resetn
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF ad9371_tx_jesd204.ref_clk
add_interface tx_serial_data conduit end
set_interface_property tx_serial_data EXPORT_OF ad9371_tx_jesd204.serial_data
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF ad9371_tx_jesd204.sysref
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF ad9371_tx_jesd204.sync

# ad9371_rx JESD204

add_instance ad9371_rx_jesd204 adi_jesd204
set_instance_parameter_value ad9371_rx_jesd204 {ID} {1}
set_instance_parameter_value ad9371_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9371_rx_jesd204 {LANE_RATE} {4915.2}
set_instance_parameter_value ad9371_rx_jesd204 {REFCLK_FREQUENCY} {122.88}
set_instance_parameter_value ad9371_rx_jesd204 {NUM_OF_LANES} {2}
set_instance_parameter_value ad9371_rx_jesd204 {SOFT_PCS} {false}

add_connection sys_clk.clk ad9371_rx_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9371_rx_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF ad9371_rx_jesd204.ref_clk
add_interface rx_serial_data conduit end
set_interface_property rx_serial_data EXPORT_OF ad9371_rx_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF ad9371_rx_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF ad9371_rx_jesd204.sync

# ad9371_rx_os JESD204

add_instance ad9371_rx_os_jesd204 adi_jesd204
set_instance_parameter_value ad9371_rx_os_jesd204 {ID} {1}
set_instance_parameter_value ad9371_rx_os_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9371_rx_os_jesd204 {LANE_RATE} {4915.2}
set_instance_parameter_value ad9371_rx_os_jesd204 {REFCLK_FREQUENCY} {122.88}
set_instance_parameter_value ad9371_rx_os_jesd204 {SOFT_PCS} {false}
set_instance_parameter_value ad9371_rx_os_jesd204 {NUM_OF_LANES} {2}

add_connection sys_clk.clk ad9371_rx_os_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9371_rx_os_jesd204.sys_resetn
add_interface rx_os_ref_clk clock sink
set_interface_property rx_os_ref_clk EXPORT_OF ad9371_rx_os_jesd204.ref_clk
add_interface rx_os_serial_data conduit end
set_interface_property rx_os_serial_data EXPORT_OF ad9371_rx_os_jesd204.serial_data
add_interface rx_os_sysref conduit end
set_interface_property rx_os_sysref EXPORT_OF ad9371_rx_os_jesd204.sysref
add_interface rx_os_sync conduit end
set_interface_property rx_os_sync EXPORT_OF ad9371_rx_os_jesd204.sync

# ad9371-core

add_instance axi_ad9371 axi_ad9371
add_connection ad9371_tx_jesd204.link_clk axi_ad9371.if_dac_clk
add_connection axi_ad9371.if_dac_tx_data ad9371_tx_jesd204.link_data
add_connection ad9371_rx_jesd204.link_clk axi_ad9371.if_adc_clk
add_connection ad9371_rx_jesd204.link_sof axi_ad9371.if_adc_rx_sof
add_connection ad9371_rx_jesd204.link_data axi_ad9371.if_adc_rx_data
add_connection ad9371_rx_os_jesd204.link_clk axi_ad9371.if_adc_os_clk
add_connection ad9371_rx_os_jesd204.link_sof axi_ad9371.if_adc_rx_os_sof
add_connection ad9371_rx_os_jesd204.link_data axi_ad9371.if_adc_rx_os_data
add_connection sys_clk.clk axi_ad9371.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9371.s_axi_reset

# pack(s) & unpack(s)

add_instance axi_ad9371_tx_upack util_upack2
set_instance_parameter_value axi_ad9371_tx_upack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value axi_ad9371_tx_upack {SAMPLES_PER_CHANNEL} {2}
set_instance_parameter_value axi_ad9371_tx_upack {SAMPLE_DATA_WIDTH} {16}
set_instance_parameter_value axi_ad9371_tx_upack {INTERFACE_TYPE} {1}

add_connection ad9371_tx_jesd204.link_clk axi_ad9371_tx_upack.clk
add_connection ad9371_tx_jesd204.link_reset axi_ad9371_tx_upack.reset
add_connection axi_ad9371_tx_upack.dac_ch_0 axi_ad9371.dac_ch_0
add_connection axi_ad9371_tx_upack.dac_ch_1 axi_ad9371.dac_ch_1
add_connection axi_ad9371_tx_upack.dac_ch_2 axi_ad9371.dac_ch_2
add_connection axi_ad9371_tx_upack.dac_ch_3 axi_ad9371.dac_ch_3

add_instance axi_ad9371_rx_cpack util_cpack2
set_instance_parameter_value axi_ad9371_rx_cpack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value axi_ad9371_rx_cpack {SAMPLES_PER_CHANNEL} {1}
set_instance_parameter_value axi_ad9371_rx_cpack {SAMPLE_DATA_WIDTH} {16}
add_connection ad9371_rx_jesd204.link_clk axi_ad9371_rx_cpack.clk
add_connection ad9371_rx_jesd204.link_reset axi_ad9371_rx_cpack.reset
add_connection axi_ad9371.adc_ch_0 axi_ad9371_rx_cpack.adc_ch_0
add_connection axi_ad9371.adc_ch_1 axi_ad9371_rx_cpack.adc_ch_1
add_connection axi_ad9371.adc_ch_2 axi_ad9371_rx_cpack.adc_ch_2
add_connection axi_ad9371.adc_ch_3 axi_ad9371_rx_cpack.adc_ch_3
add_connection axi_ad9371_rx_cpack.if_fifo_wr_overflow axi_ad9371.if_adc_dovf

add_instance axi_ad9371_rx_os_cpack util_cpack2
set_instance_parameter_value axi_ad9371_rx_os_cpack {NUM_OF_CHANNELS} {2}
set_instance_parameter_value axi_ad9371_rx_os_cpack {SAMPLES_PER_CHANNEL} {2}
set_instance_parameter_value axi_ad9371_rx_os_cpack {SAMPLE_DATA_WIDTH} {16}
add_connection ad9371_rx_os_jesd204.link_clk axi_ad9371_rx_os_cpack.clk
add_connection ad9371_rx_os_jesd204.link_reset axi_ad9371_rx_os_cpack.reset
add_connection axi_ad9371.adc_os_ch_0 axi_ad9371_rx_os_cpack.adc_ch_0
add_connection axi_ad9371.adc_os_ch_1 axi_ad9371_rx_os_cpack.adc_ch_1
add_connection axi_ad9371_rx_os_cpack.if_fifo_wr_overflow axi_ad9371.if_adc_os_dovf

# dac fifo

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

add_interface tx_fifo_bypass conduit end
set_interface_property tx_fifo_bypass EXPORT_OF avl_ad9371_tx_fifo.if_bypass

add_connection ad9371_tx_jesd204.link_clk avl_ad9371_tx_fifo.if_dac_clk
add_connection ad9371_tx_jesd204.link_reset avl_ad9371_tx_fifo.if_dac_rst
add_connection axi_ad9371_tx_upack.if_packed_fifo_rd_en avl_ad9371_tx_fifo.if_dac_valid
add_connection avl_ad9371_tx_fifo.if_dac_data axi_ad9371_tx_upack.if_packed_fifo_rd_data
add_connection avl_ad9371_tx_fifo.if_dac_dunf axi_ad9371.if_dac_dunf

# dac & adc dma

add_instance axi_ad9371_tx_dma axi_dmac
set_instance_parameter_value axi_ad9371_tx_dma {ID} {0}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9371_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9371_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9371_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9371_tx_dma {CYCLIC} {1}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_ad9371_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_ad9371_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value axi_ad9371_tx_dma {HAS_AXIS_TLAST} {1}
add_connection sys_dma_clk.clk avl_ad9371_tx_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_ad9371_tx_fifo.if_dma_rst
add_connection sys_dma_clk.clk axi_ad9371_tx_dma.if_m_axis_aclk
add_connection axi_ad9371_tx_dma.m_axis avl_ad9371_tx_fifo.s_axis
add_connection axi_ad9371_tx_dma.if_m_axis_xfer_req avl_ad9371_tx_fifo.if_dma_xfer_req
add_connection sys_clk.clk axi_ad9371_tx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9371_tx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_ad9371_tx_dma.m_src_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9371_tx_dma.m_src_axi_reset

add_instance axi_ad9371_rx_dma axi_dmac
set_instance_parameter_value axi_ad9371_rx_dma {ID} {0}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9371_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9371_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9371_rx_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9371_rx_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9371_rx_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_ad9371_rx_dma {FIFO_SIZE} {16}
add_connection ad9371_rx_jesd204.link_clk axi_ad9371_rx_dma.if_fifo_wr_clk
add_connection axi_ad9371_rx_cpack.if_packed_fifo_wr_en axi_ad9371_rx_dma.if_fifo_wr_en
add_connection axi_ad9371_rx_cpack.if_packed_fifo_wr_sync axi_ad9371_rx_dma.if_fifo_wr_sync
add_connection axi_ad9371_rx_cpack.if_packed_fifo_wr_data axi_ad9371_rx_dma.if_fifo_wr_din
add_connection axi_ad9371_rx_dma.if_fifo_wr_overflow axi_ad9371_rx_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_ad9371_rx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9371_rx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_ad9371_rx_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9371_rx_dma.m_dest_axi_reset

add_instance axi_ad9371_rx_os_dma axi_dmac
set_instance_parameter_value axi_ad9371_rx_os_dma {ID} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9371_rx_os_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9371_rx_os_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_ad9371_rx_os_dma {FIFO_SIZE} {16}
add_connection ad9371_rx_os_jesd204.link_clk axi_ad9371_rx_os_dma.if_fifo_wr_clk
add_connection axi_ad9371_rx_os_cpack.if_packed_fifo_wr_en axi_ad9371_rx_os_dma.if_fifo_wr_en
add_connection axi_ad9371_rx_os_cpack.if_packed_fifo_wr_sync  axi_ad9371_rx_os_dma.if_fifo_wr_sync
add_connection axi_ad9371_rx_os_cpack.if_packed_fifo_wr_data axi_ad9371_rx_os_dma.if_fifo_wr_din
add_connection axi_ad9371_rx_os_dma.if_fifo_wr_overflow axi_ad9371_rx_os_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_ad9371_rx_os_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9371_rx_os_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_ad9371_rx_os_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9371_rx_os_dma.m_dest_axi_reset

# ad9371 gpio

add_instance avl_ad9371_gpio altera_avalon_pio
set_instance_parameter_value avl_ad9371_gpio {direction} {Bidir}
set_instance_parameter_value avl_ad9371_gpio {generateIRQ} {1}
set_instance_parameter_value avl_ad9371_gpio {width} {19}
add_connection sys_clk.clk avl_ad9371_gpio.clk
add_connection sys_clk.clk_reset avl_ad9371_gpio.reset
add_interface ad9371_gpio conduit end
set_interface_property ad9371_gpio EXPORT_OF avl_ad9371_gpio.external_connection

# reconfig sharing

for {set i 0} {$i < 4} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m0 ad9371_tx_jesd204.phy_reconfig_${i}

  if {$i < 2} {
    add_connection avl_adxcfg_${i}.rcfg_m1 ad9371_rx_jesd204.phy_reconfig_${i}
  } else {
    set j [expr $i - 2]
    add_connection avl_adxcfg_${i}.rcfg_m1 ad9371_rx_os_jesd204.phy_reconfig_${j}
  }
}

# addresses

ad_cpu_interconnect 0x00020000 ad9371_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x00024000 ad9371_tx_jesd204.link_management
ad_cpu_interconnect 0x00025000 ad9371_tx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00026000 ad9371_tx_jesd204.lane_pll_reconfig
ad_cpu_interconnect 0x00028000 avl_adxcfg_0.rcfg_s0
ad_cpu_interconnect 0x00029000 avl_adxcfg_1.rcfg_s0
ad_cpu_interconnect 0x0002a000 avl_adxcfg_2.rcfg_s0
ad_cpu_interconnect 0x0002b000 avl_adxcfg_3.rcfg_s0
ad_cpu_interconnect 0x0002c000 axi_ad9371_tx_dma.s_axi

ad_cpu_interconnect 0x00030000 ad9371_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x00034000 ad9371_rx_jesd204.link_management
ad_cpu_interconnect 0x00035000 ad9371_rx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00038000 avl_adxcfg_0.rcfg_s1
ad_cpu_interconnect 0x00039000 avl_adxcfg_1.rcfg_s1
ad_cpu_interconnect 0x0003c000 axi_ad9371_rx_dma.s_axi

ad_cpu_interconnect 0x00040000 ad9371_rx_os_jesd204.link_reconfig
ad_cpu_interconnect 0x00044000 ad9371_rx_os_jesd204.link_management
ad_cpu_interconnect 0x00045000 ad9371_rx_os_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00048000 avl_adxcfg_2.rcfg_s1
ad_cpu_interconnect 0x00049000 avl_adxcfg_3.rcfg_s1
ad_cpu_interconnect 0x0004c000 axi_ad9371_rx_os_dma.s_axi

ad_cpu_interconnect 0x00050000 axi_ad9371.s_axi
ad_cpu_interconnect 0x00060000 avl_ad9371_gpio.s1

# dma interconnects

ad_dma_interconnect axi_ad9371_tx_dma.m_src_axi
ad_dma_interconnect axi_ad9371_rx_dma.m_dest_axi
ad_dma_interconnect axi_ad9371_rx_os_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 11 axi_ad9371_tx_dma.interrupt_sender
ad_cpu_interrupt 12 axi_ad9371_rx_dma.interrupt_sender
ad_cpu_interrupt 13 axi_ad9371_rx_os_dma.interrupt_sender
ad_cpu_interrupt 14 avl_ad9371_gpio.irq

