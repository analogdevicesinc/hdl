###############################################################################
## Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# TX parameters
set TX_NUM_OF_LANES 4      ; # L
set TX_NUM_OF_CONVERTERS 4 ; # M
set TX_SAMPLE_WIDTH 16     ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / \
                                ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX parameters
set RX_NUM_OF_LANES 2      ; # L
set RX_NUM_OF_CONVERTERS 4 ; # M
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX Observation parameters
set RX_OS_NUM_OF_LANES 2      ; # L
set RX_OS_NUM_OF_CONVERTERS 2 ; # M
set RX_OS_SAMPLE_WIDTH 16     ; # N/NP

set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 32 / \
                                   ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

set dac_fifo_name avl_adrv9009_tx_fifo
set dac_data_width 128
set dac_dma_data_width 128

# NOTE: The real lane rate is 2457.6 Gbps (Tx) and 4915.2 Gbps (RX/Rx_Obs),
# with a real reference clock frequency of 122.88 MHz. A round up needed
# because the fPLL's configuration interface does not support fractional numbers.

# adrv9009_tx JESD204

add_instance adrv9009_tx_jesd204 adi_jesd204
set_instance_parameter_value adrv9009_tx_jesd204 {ID} {0}
set_instance_parameter_value adrv9009_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value adrv9009_tx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value adrv9009_tx_jesd204 {LANE_RATE} {2460}
set_instance_parameter_value adrv9009_tx_jesd204 {REFCLK_FREQUENCY} {123}
set_instance_parameter_value adrv9009_tx_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value adrv9009_tx_jesd204 {LANE_MAP} {0 3 2 1}

add_connection sys_clk.clk adrv9009_tx_jesd204.sys_clk
add_connection sys_clk.clk_reset adrv9009_tx_jesd204.sys_resetn
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF adrv9009_tx_jesd204.ref_clk
add_interface tx_serial_data conduit end
set_interface_property tx_serial_data EXPORT_OF adrv9009_tx_jesd204.serial_data
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF adrv9009_tx_jesd204.sysref
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF adrv9009_tx_jesd204.sync

# adrv9009_rx JESD204

add_instance adrv9009_rx_jesd204 adi_jesd204
set_instance_parameter_value adrv9009_rx_jesd204 {ID} {1}
set_instance_parameter_value adrv9009_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value adrv9009_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value adrv9009_rx_jesd204 {LANE_RATE} {4920}
set_instance_parameter_value adrv9009_rx_jesd204 {REFCLK_FREQUENCY} {123}
set_instance_parameter_value adrv9009_rx_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value adrv9009_rx_jesd204 {INPUT_PIPELINE_STAGES} {1}

add_connection sys_clk.clk adrv9009_rx_jesd204.sys_clk
add_connection sys_clk.clk_reset adrv9009_rx_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF adrv9009_rx_jesd204.ref_clk
add_interface rx_serial_data conduit end
set_interface_property rx_serial_data EXPORT_OF adrv9009_rx_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF adrv9009_rx_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF adrv9009_rx_jesd204.sync

# adrv9009_rx_os JESD204

add_instance adrv9009_rx_os_jesd204 adi_jesd204
set_instance_parameter_value adrv9009_rx_os_jesd204 {ID} {1}
set_instance_parameter_value adrv9009_rx_os_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value adrv9009_rx_os_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value adrv9009_rx_os_jesd204 {LANE_RATE} {4920}
set_instance_parameter_value adrv9009_rx_os_jesd204 {REFCLK_FREQUENCY} {123}
set_instance_parameter_value adrv9009_rx_os_jesd204 {NUM_OF_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value adrv9009_rx_os_jesd204 {INPUT_PIPELINE_STAGES} {1}

add_connection sys_clk.clk adrv9009_rx_os_jesd204.sys_clk
add_connection sys_clk.clk_reset adrv9009_rx_os_jesd204.sys_resetn
add_interface rx_os_ref_clk clock sink
set_interface_property rx_os_ref_clk EXPORT_OF adrv9009_rx_os_jesd204.ref_clk
add_interface rx_os_serial_data conduit end
set_interface_property rx_os_serial_data EXPORT_OF adrv9009_rx_os_jesd204.serial_data
add_interface rx_os_sysref conduit end
set_interface_property rx_os_sysref EXPORT_OF adrv9009_rx_os_jesd204.sysref
add_interface rx_os_sync conduit end
set_interface_property rx_os_sync EXPORT_OF adrv9009_rx_os_jesd204.sync

# adrv9009 TPL cores

add_instance axi_adrv9009_tx ad_ip_jesd204_tpl_dac
set_instance_parameter_value axi_adrv9009_tx {ID} {0}
set_instance_parameter_value axi_adrv9009_tx {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_tx {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value axi_adrv9009_tx {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_tx {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH

add_instance axi_adrv9009_rx ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_adrv9009_rx {ID} {0}
set_instance_parameter_value axi_adrv9009_rx {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_rx {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value axi_adrv9009_rx {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_rx {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_rx {TWOS_COMPLEMENT} {1}

add_instance axi_adrv9009_rx_os ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_adrv9009_rx_os {ID} {1}
set_instance_parameter_value axi_adrv9009_rx_os {NUM_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_rx_os {NUM_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value axi_adrv9009_rx_os {BITS_PER_SAMPLE} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_rx_os {CONVERTER_RESOLUTION} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_rx_os {TWOS_COMPLEMENT} {1}

add_connection sys_clk.clk axi_adrv9009_tx.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_tx.s_axi_reset
add_connection sys_clk.clk axi_adrv9009_rx.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_rx.s_axi_reset
add_connection sys_clk.clk axi_adrv9009_rx_os.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_rx_os.s_axi_reset

add_connection adrv9009_tx_jesd204.link_clk axi_adrv9009_tx.link_clk
add_connection axi_adrv9009_tx.link_data adrv9009_tx_jesd204.link_data
add_connection adrv9009_rx_jesd204.link_clk axi_adrv9009_rx.link_clk
add_connection adrv9009_rx_jesd204.link_sof axi_adrv9009_rx.if_link_sof
add_connection adrv9009_rx_jesd204.link_data axi_adrv9009_rx.link_data
add_connection adrv9009_rx_os_jesd204.link_clk axi_adrv9009_rx_os.link_clk
add_connection adrv9009_rx_os_jesd204.link_sof axi_adrv9009_rx_os.if_link_sof
add_connection adrv9009_rx_os_jesd204.link_data axi_adrv9009_rx_os.link_data

# pack(s) & unpack(s)

add_instance axi_adrv9009_tx_upack util_upack2
set_instance_parameter_value axi_adrv9009_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_adrv9009_tx_upack {SAMPLE_DATA_WIDTH} $TX_SAMPLE_WIDTH
set_instance_parameter_value axi_adrv9009_tx_upack {INTERFACE_TYPE} {1}
add_connection adrv9009_tx_jesd204.link_clk axi_adrv9009_tx_upack.clk
add_connection adrv9009_tx_jesd204.link_reset axi_adrv9009_tx_upack.reset
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_adrv9009_tx_upack.dac_ch_$i axi_adrv9009_tx.dac_ch_$i
}

add_instance axi_adrv9009_rx_cpack util_cpack2
set_instance_parameter_value axi_adrv9009_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_adrv9009_rx_cpack {SAMPLE_DATA_WIDTH} $RX_SAMPLE_WIDTH
add_connection adrv9009_rx_jesd204.link_reset axi_adrv9009_rx_cpack.reset
add_connection adrv9009_rx_jesd204.link_clk axi_adrv9009_rx_cpack.clk
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_adrv9009_rx.adc_ch_$i axi_adrv9009_rx_cpack.adc_ch_$i
}
add_connection axi_adrv9009_rx_cpack.if_fifo_wr_overflow axi_adrv9009_rx.if_adc_dovf

add_instance axi_adrv9009_rx_os_cpack util_cpack2
set_instance_parameter_value axi_adrv9009_rx_os_cpack {NUM_OF_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value axi_adrv9009_rx_os_cpack {SAMPLES_PER_CHANNEL} $RX_OS_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_adrv9009_rx_os_cpack {SAMPLE_DATA_WIDTH} $RX_OS_SAMPLE_WIDTH
add_connection adrv9009_rx_os_jesd204.link_reset axi_adrv9009_rx_os_cpack.reset
add_connection adrv9009_rx_os_jesd204.link_clk axi_adrv9009_rx_os_cpack.clk
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_adrv9009_rx_os.adc_ch_$i axi_adrv9009_rx_os_cpack.adc_ch_$i
}
add_connection axi_adrv9009_rx_os_cpack.if_fifo_wr_overflow axi_adrv9009_rx_os.if_adc_dovf

# dac fifo

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

add_interface tx_fifo_bypass conduit end
set_interface_property tx_fifo_bypass EXPORT_OF avl_adrv9009_tx_fifo.if_bypass

add_connection adrv9009_tx_jesd204.link_clk avl_adrv9009_tx_fifo.if_dac_clk
add_connection adrv9009_tx_jesd204.link_reset avl_adrv9009_tx_fifo.if_dac_rst
add_connection axi_adrv9009_tx_upack.if_packed_fifo_rd_en avl_adrv9009_tx_fifo.if_dac_valid
add_connection avl_adrv9009_tx_fifo.if_dac_data axi_adrv9009_tx_upack.if_packed_fifo_rd_data
add_connection avl_adrv9009_tx_fifo.if_dac_dunf axi_adrv9009_tx.if_dac_dunf

# dac & adc dma

add_instance axi_adrv9009_tx_dma axi_dmac
set_instance_parameter_value axi_adrv9009_tx_dma {ID} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_DATA_WIDTH_DEST} [expr $TX_SAMPLE_WIDTH * \
                                                                             $TX_NUM_OF_CONVERTERS * \
                                                                             $TX_SAMPLES_PER_CHANNEL]
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {CYCLIC} {1}
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_adrv9009_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_adrv9009_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value axi_adrv9009_tx_dma {HAS_AXIS_TLAST} {1}

add_connection sys_dma_clk.clk avl_adrv9009_tx_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_adrv9009_tx_fifo.if_dma_rst
add_connection sys_dma_clk.clk axi_adrv9009_tx_dma.if_m_axis_aclk
add_connection axi_adrv9009_tx_dma.m_axis avl_adrv9009_tx_fifo.s_axis
add_connection axi_adrv9009_tx_dma.if_m_axis_xfer_req avl_adrv9009_tx_fifo.if_dma_xfer_req
add_connection sys_clk.clk axi_adrv9009_tx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_tx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_adrv9009_tx_dma.m_src_axi_clock
add_connection sys_dma_clk.clk_reset axi_adrv9009_tx_dma.m_src_axi_reset

add_instance axi_adrv9009_rx_dma axi_dmac
set_instance_parameter_value axi_adrv9009_rx_dma {ID} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_DATA_WIDTH_SRC} [expr $RX_SAMPLE_WIDTH * \
                                                                            $RX_NUM_OF_CONVERTERS * \
                                                                            $RX_SAMPLES_PER_CHANNEL]
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_adrv9009_rx_dma {CYCLIC} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_adrv9009_rx_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_adrv9009_rx_dma {FIFO_SIZE} {16}
add_connection adrv9009_rx_jesd204.link_clk axi_adrv9009_rx_dma.if_fifo_wr_clk
add_connection axi_adrv9009_rx_cpack.if_packed_fifo_wr_en axi_adrv9009_rx_dma.if_fifo_wr_en
add_connection axi_adrv9009_rx_cpack.if_packed_fifo_wr_sync axi_adrv9009_rx_dma.if_fifo_wr_sync
add_connection axi_adrv9009_rx_cpack.if_packed_fifo_wr_data axi_adrv9009_rx_dma.if_fifo_wr_din
add_connection axi_adrv9009_rx_dma.if_fifo_wr_overflow axi_adrv9009_rx_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_adrv9009_rx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_rx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_adrv9009_rx_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_adrv9009_rx_dma.m_dest_axi_reset

add_instance axi_adrv9009_rx_os_dma axi_dmac
set_instance_parameter_value axi_adrv9009_rx_os_dma {ID} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_DATA_WIDTH_SRC} [expr 32*$RX_OS_NUM_OF_LANES]
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_adrv9009_rx_os_dma {CYCLIC} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_adrv9009_rx_os_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_adrv9009_rx_os_dma {FIFO_SIZE} {16}
add_connection adrv9009_rx_os_jesd204.link_clk axi_adrv9009_rx_os_dma.if_fifo_wr_clk
add_connection axi_adrv9009_rx_os_cpack.if_packed_fifo_wr_en axi_adrv9009_rx_os_dma.if_fifo_wr_en
add_connection axi_adrv9009_rx_os_cpack.if_packed_fifo_wr_sync  axi_adrv9009_rx_os_dma.if_fifo_wr_sync
add_connection axi_adrv9009_rx_os_cpack.if_packed_fifo_wr_data axi_adrv9009_rx_os_dma.if_fifo_wr_din
add_connection axi_adrv9009_rx_os_dma.if_fifo_wr_overflow axi_adrv9009_rx_os_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_adrv9009_rx_os_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_adrv9009_rx_os_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_adrv9009_rx_os_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_adrv9009_rx_os_dma.m_dest_axi_reset

# adrv9009 gpio

add_instance avl_adrv9009_gpio altera_avalon_pio
set_instance_parameter_value avl_adrv9009_gpio {direction} {Bidir}
set_instance_parameter_value avl_adrv9009_gpio {generateIRQ} {1}
set_instance_parameter_value avl_adrv9009_gpio {width} {19}
add_connection sys_clk.clk avl_adrv9009_gpio.clk
add_connection sys_clk.clk_reset avl_adrv9009_gpio.reset
add_interface adrv9009_gpio conduit end
set_interface_property adrv9009_gpio EXPORT_OF avl_adrv9009_gpio.external_connection

# reconfig sharing

for {set i 0} {$i < 4} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m0 adrv9009_tx_jesd204.phy_reconfig_${i}

  set_instance_parameter_value avl_adxcfg_${i} {ADDRESS_WIDTH} $xcvr_reconfig_addr_width

  if {$i < 2} {
    add_connection avl_adxcfg_${i}.rcfg_m1 adrv9009_rx_jesd204.phy_reconfig_${i}
  } else {
    set j [expr $i - 2]
    add_connection avl_adxcfg_${i}.rcfg_m1 adrv9009_rx_os_jesd204.phy_reconfig_${j}
  }
}

# addresses

ad_cpu_interconnect 0x00020000 adrv9009_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x00024000 adrv9009_tx_jesd204.link_management
ad_cpu_interconnect 0x00026000 adrv9009_tx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00028000 adrv9009_tx_jesd204.lane_pll_reconfig
ad_cpu_interconnect 0x0002a000 avl_adxcfg_0.rcfg_s0
ad_cpu_interconnect 0x0002c000 avl_adxcfg_1.rcfg_s0
ad_cpu_interconnect 0x0002e000 avl_adxcfg_2.rcfg_s0
ad_cpu_interconnect 0x00030000 avl_adxcfg_3.rcfg_s0
ad_cpu_interconnect 0x00032000 axi_adrv9009_tx_dma.s_axi

ad_cpu_interconnect 0x00040000 adrv9009_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x00044000 adrv9009_rx_jesd204.link_management
ad_cpu_interconnect 0x00046000 adrv9009_rx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00048000 avl_adxcfg_0.rcfg_s1
ad_cpu_interconnect 0x0004a000 avl_adxcfg_1.rcfg_s1
ad_cpu_interconnect 0x0004c000 axi_adrv9009_rx_dma.s_axi

ad_cpu_interconnect 0x00050000 adrv9009_rx_os_jesd204.link_reconfig
ad_cpu_interconnect 0x00054000 adrv9009_rx_os_jesd204.link_management
ad_cpu_interconnect 0x00056000 adrv9009_rx_os_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00058000 avl_adxcfg_2.rcfg_s1
ad_cpu_interconnect 0x0005a000 avl_adxcfg_3.rcfg_s1
ad_cpu_interconnect 0x0005c000 axi_adrv9009_rx_os_dma.s_axi

ad_cpu_interconnect 0x00060000 axi_adrv9009_rx.s_axi
ad_cpu_interconnect 0x00064000 axi_adrv9009_tx.s_axi
ad_cpu_interconnect 0x00068000 axi_adrv9009_rx_os.s_axi
ad_cpu_interconnect 0x00070000 avl_adrv9009_gpio.s1

# dma interconnects

ad_dma_interconnect axi_adrv9009_tx_dma.m_src_axi
ad_dma_interconnect axi_adrv9009_rx_dma.m_dest_axi
ad_dma_interconnect axi_adrv9009_rx_os_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 11 axi_adrv9009_tx_dma.interrupt_sender
ad_cpu_interrupt 12 axi_adrv9009_rx_dma.interrupt_sender
ad_cpu_interrupt 13 axi_adrv9009_rx_os_dma.interrupt_sender
ad_cpu_interrupt 14 avl_adrv9009_gpio.irq

