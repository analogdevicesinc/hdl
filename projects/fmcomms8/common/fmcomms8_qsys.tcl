###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# TX parameters
set TX_NUM_OF_LANES 8      ; # L
set TX_NUM_OF_CONVERTERS 8 ; # M
set TX_SAMPLE_WIDTH 16     ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / \
                                ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX parameters
set RX_NUM_OF_LANES 4      ; # L
set RX_NUM_OF_CONVERTERS 8 ; # M
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX Observation parameters
set RX_OS_NUM_OF_LANES 4      ; # L
set RX_OS_NUM_OF_CONVERTERS 4 ; # M
set RX_OS_SAMPLE_WIDTH 16     ; # N/NP

set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 32 / \
                                   ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

set dac_fifo_name avl_fmcomms8_tx_fifo
set dac_data_width 256
set dac_dma_data_width 256

# NOTE: The real lane rate is 9830.4 Gbps (Tx/Rx/Rx_Obs), with a real reference
# clock frequency of 245.76 MHz. A round up needed because the fPLL's configuration
# interface does not support fractional numbers.

# JESD204B/C clock bridges

 add_instance core_clk_c altera_clock_bridge
 set_instance_parameter_value core_clk_c {EXPLICIT_CLOCK_RATE} {246000000}

 add_instance core_clk_d altera_clock_bridge
 set_instance_parameter_value core_clk_d {EXPLICIT_CLOCK_RATE} {246000000}

# fmcomms8_tx JESD204

add_instance fmcomms8_tx_jesd204 adi_jesd204
set_instance_parameter_value fmcomms8_tx_jesd204 {ID} {0}
set_instance_parameter_value fmcomms8_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value fmcomms8_tx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value fmcomms8_tx_jesd204 {LANE_RATE} {9840}
set_instance_parameter_value fmcomms8_tx_jesd204 {REFCLK_FREQUENCY} {246}
set_instance_parameter_value fmcomms8_tx_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value fmcomms8_tx_jesd204 {LANE_MAP} {1 0 2 3 4 5 6 7}
set_instance_parameter_value fmcomms8_tx_jesd204 {EXT_DEVICE_CLK_EN} {1}

add_connection sys_clk.clk fmcomms8_tx_jesd204.sys_clk
add_connection sys_clk.clk_reset fmcomms8_tx_jesd204.sys_resetn
add_interface tx_ref_clk clock sink
set_interface_property tx_ref_clk EXPORT_OF fmcomms8_tx_jesd204.ref_clk
add_interface tx_serial_data conduit end
set_interface_property tx_serial_data EXPORT_OF fmcomms8_tx_jesd204.serial_data
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF fmcomms8_tx_jesd204.sysref
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF fmcomms8_tx_jesd204.sync

# fmcomms8_rx JESD204

add_instance fmcomms8_rx_jesd204 adi_jesd204
set_instance_parameter_value fmcomms8_rx_jesd204 {ID} {1}
set_instance_parameter_value fmcomms8_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value fmcomms8_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value fmcomms8_rx_jesd204 {LANE_RATE} {9840}
set_instance_parameter_value fmcomms8_rx_jesd204 {REFCLK_FREQUENCY} {246}
set_instance_parameter_value fmcomms8_rx_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value fmcomms8_rx_jesd204 {EXT_DEVICE_CLK_EN} {1}

add_connection sys_clk.clk fmcomms8_rx_jesd204.sys_clk
add_connection sys_clk.clk_reset fmcomms8_rx_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF fmcomms8_rx_jesd204.ref_clk
add_interface rx_serial_data conduit end
set_interface_property rx_serial_data EXPORT_OF fmcomms8_rx_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF fmcomms8_rx_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF fmcomms8_rx_jesd204.sync

# fmcomms8_rx_os JESD204

add_instance fmcomms8_rx_os_jesd204 adi_jesd204
set_instance_parameter_value fmcomms8_rx_os_jesd204 {ID} {1}
set_instance_parameter_value fmcomms8_rx_os_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value fmcomms8_rx_os_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value fmcomms8_rx_os_jesd204 {LANE_RATE} {9840}
set_instance_parameter_value fmcomms8_rx_os_jesd204 {REFCLK_FREQUENCY} {246}
set_instance_parameter_value fmcomms8_rx_os_jesd204 {NUM_OF_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value fmcomms8_rx_os_jesd204 {EXT_DEVICE_CLK_EN} {1}

add_connection sys_clk.clk fmcomms8_rx_os_jesd204.sys_clk
add_connection sys_clk.clk_reset fmcomms8_rx_os_jesd204.sys_resetn
add_interface rx_os_ref_clk clock sink
set_interface_property rx_os_ref_clk EXPORT_OF fmcomms8_rx_os_jesd204.ref_clk
add_interface rx_os_serial_data conduit end
set_interface_property rx_os_serial_data EXPORT_OF fmcomms8_rx_os_jesd204.serial_data
add_interface rx_os_sysref conduit end
set_interface_property rx_os_sysref EXPORT_OF fmcomms8_rx_os_jesd204.sysref
add_interface rx_os_sync conduit end
set_interface_property rx_os_sync EXPORT_OF fmcomms8_rx_os_jesd204.sync

# fmcomms8 TPL cores

add_instance axi_fmcomms8_tx ad_ip_jesd204_tpl_dac
set_instance_parameter_value axi_fmcomms8_tx {ID} {0}
set_instance_parameter_value axi_fmcomms8_tx {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_tx {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value axi_fmcomms8_tx {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_tx {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH

add_instance axi_fmcomms8_rx ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_fmcomms8_rx {ID} {0}
set_instance_parameter_value axi_fmcomms8_rx {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_rx {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value axi_fmcomms8_rx {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_rx {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_rx {TWOS_COMPLEMENT} {1}

add_instance axi_fmcomms8_rx_os ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_fmcomms8_rx_os {ID} {1}
set_instance_parameter_value axi_fmcomms8_rx_os {NUM_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_rx_os {NUM_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value axi_fmcomms8_rx_os {BITS_PER_SAMPLE} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_rx_os {CONVERTER_RESOLUTION} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_rx_os {TWOS_COMPLEMENT} {1}

add_connection sys_clk.clk axi_fmcomms8_tx.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_tx.s_axi_reset
add_connection sys_clk.clk axi_fmcomms8_rx.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_rx.s_axi_reset
add_connection sys_clk.clk axi_fmcomms8_rx_os.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_rx_os.s_axi_reset

add_connection core_clk_c.out_clk axi_fmcomms8_tx.link_clk
add_connection core_clk_c.out_clk fmcomms8_tx_jesd204.device_clk
add_connection axi_fmcomms8_tx.link_data fmcomms8_tx_jesd204.link_data
add_connection core_clk_d.out_clk axi_fmcomms8_rx.link_clk
add_connection core_clk_d.out_clk fmcomms8_rx_jesd204.device_clk
add_connection fmcomms8_rx_jesd204.link_sof axi_fmcomms8_rx.if_link_sof
add_connection fmcomms8_rx_jesd204.link_data axi_fmcomms8_rx.link_data
add_connection core_clk_c.out_clk axi_fmcomms8_rx_os.link_clk
add_connection core_clk_c.out_clk fmcomms8_rx_os_jesd204.device_clk
add_connection fmcomms8_rx_os_jesd204.link_sof axi_fmcomms8_rx_os.if_link_sof
add_connection fmcomms8_rx_os_jesd204.link_data axi_fmcomms8_rx_os.link_data

# pack(s) & unpack(s)

add_instance axi_fmcomms8_tx_upack util_upack2
set_instance_parameter_value axi_fmcomms8_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_fmcomms8_tx_upack {SAMPLE_DATA_WIDTH} $TX_SAMPLE_WIDTH
set_instance_parameter_value axi_fmcomms8_tx_upack {INTERFACE_TYPE} {1}
add_connection core_clk_c.out_clk axi_fmcomms8_tx_upack.clk
add_connection fmcomms8_tx_jesd204.link_reset axi_fmcomms8_tx_upack.reset
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_fmcomms8_tx_upack.dac_ch_$i axi_fmcomms8_tx.dac_ch_$i
}

add_instance axi_fmcomms8_rx_cpack util_cpack2
set_instance_parameter_value axi_fmcomms8_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_fmcomms8_rx_cpack {SAMPLE_DATA_WIDTH} $RX_SAMPLE_WIDTH
add_connection fmcomms8_rx_jesd204.link_reset axi_fmcomms8_rx_cpack.reset
add_connection core_clk_d.out_clk axi_fmcomms8_rx_cpack.clk
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_fmcomms8_rx.adc_ch_$i axi_fmcomms8_rx_cpack.adc_ch_$i
}
add_connection axi_fmcomms8_rx_cpack.if_fifo_wr_overflow axi_fmcomms8_rx.if_adc_dovf

add_instance axi_fmcomms8_rx_os_cpack util_cpack2
set_instance_parameter_value axi_fmcomms8_rx_os_cpack {NUM_OF_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value axi_fmcomms8_rx_os_cpack {SAMPLES_PER_CHANNEL} $RX_OS_SAMPLES_PER_CHANNEL
set_instance_parameter_value axi_fmcomms8_rx_os_cpack {SAMPLE_DATA_WIDTH} $RX_OS_SAMPLE_WIDTH
add_connection fmcomms8_rx_os_jesd204.link_reset axi_fmcomms8_rx_os_cpack.reset
add_connection core_clk_c.out_clk axi_fmcomms8_rx_os_cpack.clk
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  add_connection axi_fmcomms8_rx_os.adc_ch_$i axi_fmcomms8_rx_os_cpack.adc_ch_$i
}
add_connection axi_fmcomms8_rx_os_cpack.if_fifo_wr_overflow axi_fmcomms8_rx_os.if_adc_dovf

# dac fifo

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

add_interface tx_fifo_bypass conduit end
set_interface_property tx_fifo_bypass EXPORT_OF avl_fmcomms8_tx_fifo.if_bypass

add_connection core_clk_c.out_clk avl_fmcomms8_tx_fifo.if_dac_clk
add_connection fmcomms8_tx_jesd204.link_reset avl_fmcomms8_tx_fifo.if_dac_rst
add_connection axi_fmcomms8_tx_upack.if_packed_fifo_rd_en avl_fmcomms8_tx_fifo.if_dac_valid
add_connection avl_fmcomms8_tx_fifo.if_dac_data axi_fmcomms8_tx_upack.if_packed_fifo_rd_data
add_connection avl_fmcomms8_tx_fifo.if_dac_dunf axi_fmcomms8_tx.if_dac_dunf

# dac & adc dma

add_instance axi_fmcomms8_tx_dma axi_dmac
set_instance_parameter_value axi_fmcomms8_tx_dma {ID} {0}
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_DATA_WIDTH_DEST} [expr $TX_SAMPLE_WIDTH * \
                                                                             $TX_NUM_OF_CONVERTERS * \
                                                                             $TX_SAMPLES_PER_CHANNEL]
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_fmcomms8_tx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value axi_fmcomms8_tx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value axi_fmcomms8_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_fmcomms8_tx_dma {CYCLIC} {1}
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_fmcomms8_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_fmcomms8_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value axi_fmcomms8_tx_dma {HAS_AXIS_TLAST} {1}

add_connection sys_dma_clk.clk avl_fmcomms8_tx_fifo.if_dma_clk
add_connection sys_dma_clk.clk_reset avl_fmcomms8_tx_fifo.if_dma_rst
add_connection sys_dma_clk.clk axi_fmcomms8_tx_dma.if_m_axis_aclk
add_connection axi_fmcomms8_tx_dma.m_axis avl_fmcomms8_tx_fifo.s_axis
add_connection axi_fmcomms8_tx_dma.if_m_axis_xfer_req avl_fmcomms8_tx_fifo.if_dma_xfer_req
add_connection sys_clk.clk axi_fmcomms8_tx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_tx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_fmcomms8_tx_dma.m_src_axi_clock
add_connection sys_dma_clk.clk_reset axi_fmcomms8_tx_dma.m_src_axi_reset

add_instance axi_fmcomms8_rx_dma axi_dmac
set_instance_parameter_value axi_fmcomms8_rx_dma {ID} {0}
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_DATA_WIDTH_SRC} [expr $RX_SAMPLE_WIDTH * \
                                                                            $RX_NUM_OF_CONVERTERS * \
                                                                            $RX_SAMPLES_PER_CHANNEL]
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_fmcomms8_rx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value axi_fmcomms8_rx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value axi_fmcomms8_rx_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_fmcomms8_rx_dma {CYCLIC} {0}
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_fmcomms8_rx_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_fmcomms8_rx_dma {FIFO_SIZE} {32}
add_connection core_clk_d.out_clk axi_fmcomms8_rx_dma.if_fifo_wr_clk
add_connection axi_fmcomms8_rx_cpack.if_packed_fifo_wr_en axi_fmcomms8_rx_dma.if_fifo_wr_en
add_connection axi_fmcomms8_rx_cpack.if_packed_fifo_wr_sync axi_fmcomms8_rx_dma.if_fifo_wr_sync
add_connection axi_fmcomms8_rx_cpack.if_packed_fifo_wr_data axi_fmcomms8_rx_dma.if_fifo_wr_din
add_connection axi_fmcomms8_rx_dma.if_fifo_wr_overflow axi_fmcomms8_rx_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_fmcomms8_rx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_rx_dma.s_axi_reset
add_connection sys_dma_clk_2.clk axi_fmcomms8_rx_dma.m_dest_axi_clock
add_connection sys_dma_clk_2.clk_reset axi_fmcomms8_rx_dma.m_dest_axi_reset

add_instance axi_fmcomms8_rx_os_dma axi_dmac
set_instance_parameter_value axi_fmcomms8_rx_os_dma {ID} {0}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_DATA_WIDTH_SRC} [expr 32*$RX_OS_NUM_OF_LANES]
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {CYCLIC} {0}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_fmcomms8_rx_os_dma {FIFO_SIZE} {32}
add_connection core_clk_c.out_clk axi_fmcomms8_rx_os_dma.if_fifo_wr_clk
add_connection axi_fmcomms8_rx_os_cpack.if_packed_fifo_wr_en axi_fmcomms8_rx_os_dma.if_fifo_wr_en
add_connection axi_fmcomms8_rx_os_cpack.if_packed_fifo_wr_sync  axi_fmcomms8_rx_os_dma.if_fifo_wr_sync
add_connection axi_fmcomms8_rx_os_cpack.if_packed_fifo_wr_data axi_fmcomms8_rx_os_dma.if_fifo_wr_din
add_connection axi_fmcomms8_rx_os_dma.if_fifo_wr_overflow axi_fmcomms8_rx_os_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_fmcomms8_rx_os_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_fmcomms8_rx_os_dma.s_axi_reset
add_connection sys_dma_clk_2.clk axi_fmcomms8_rx_os_dma.m_dest_axi_clock
add_connection sys_dma_clk_2.clk_reset axi_fmcomms8_rx_os_dma.m_dest_axi_reset

# fmcomms8 gpio

add_instance avl_fmcomms8_gpio altera_avalon_pio
set_instance_parameter_value avl_fmcomms8_gpio {direction} {Bidir}
set_instance_parameter_value avl_fmcomms8_gpio {generateIRQ} {1}
set_instance_parameter_value avl_fmcomms8_gpio {width} {22}
add_connection sys_clk.clk avl_fmcomms8_gpio.clk
add_connection sys_clk.clk_reset avl_fmcomms8_gpio.reset
add_interface fmcomms8_gpio conduit end
set_interface_property fmcomms8_gpio EXPORT_OF avl_fmcomms8_gpio.external_connection

# reconfig sharing

for {set i 0} {$i < 8} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m0 fmcomms8_tx_jesd204.phy_reconfig_${i}

#  if {$i < 2} {
#    add_connection avl_adxcfg_${i}.rcfg_m1 fmcomms8_rx_jesd204.phy_reconfig_${i}
#  } else {
#    set j [expr $i - 2]
#    add_connection avl_adxcfg_${i}.rcfg_m1 fmcomms8_rx_os_jesd204.phy_reconfig_${j}
#  }
}
    add_connection avl_adxcfg_0.rcfg_m1 fmcomms8_rx_jesd204.phy_reconfig_0
    add_connection avl_adxcfg_1.rcfg_m1 fmcomms8_rx_jesd204.phy_reconfig_1
    add_connection avl_adxcfg_4.rcfg_m1 fmcomms8_rx_jesd204.phy_reconfig_2
    add_connection avl_adxcfg_5.rcfg_m1 fmcomms8_rx_jesd204.phy_reconfig_3
    add_connection avl_adxcfg_2.rcfg_m1 fmcomms8_rx_os_jesd204.phy_reconfig_0
    add_connection avl_adxcfg_3.rcfg_m1 fmcomms8_rx_os_jesd204.phy_reconfig_1
    add_connection avl_adxcfg_6.rcfg_m1 fmcomms8_rx_os_jesd204.phy_reconfig_2
    add_connection avl_adxcfg_7.rcfg_m1 fmcomms8_rx_os_jesd204.phy_reconfig_3

add_interface core_clk_c   clock   sink
set_interface_property core_clk_c    EXPORT_OF core_clk_c.in_clk

add_interface core_clk_d   clock   sink
set_interface_property core_clk_d    EXPORT_OF core_clk_d.in_clk

# addresses

ad_cpu_interconnect 0x00020000 fmcomms8_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x00024000 fmcomms8_tx_jesd204.link_management
ad_cpu_interconnect 0x00025000 fmcomms8_tx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00026000 fmcomms8_tx_jesd204.lane_pll_reconfig
ad_cpu_interconnect 0x00028000 avl_adxcfg_0.rcfg_s0
ad_cpu_interconnect 0x00029000 avl_adxcfg_1.rcfg_s0
ad_cpu_interconnect 0x0002a000 avl_adxcfg_2.rcfg_s0
ad_cpu_interconnect 0x0002b000 avl_adxcfg_3.rcfg_s0
ad_cpu_interconnect 0x0002c000 avl_adxcfg_4.rcfg_s0
ad_cpu_interconnect 0x0002d000 avl_adxcfg_5.rcfg_s0
ad_cpu_interconnect 0x0002e000 avl_adxcfg_6.rcfg_s0
ad_cpu_interconnect 0x0002f000 avl_adxcfg_7.rcfg_s0
ad_cpu_interconnect 0x00070000 axi_fmcomms8_tx_dma.s_axi

ad_cpu_interconnect 0x00030000 fmcomms8_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x00034000 fmcomms8_rx_jesd204.link_management
ad_cpu_interconnect 0x00035000 fmcomms8_rx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00038000 avl_adxcfg_0.rcfg_s1
ad_cpu_interconnect 0x00039000 avl_adxcfg_1.rcfg_s1
ad_cpu_interconnect 0x0003a000 avl_adxcfg_4.rcfg_s1
ad_cpu_interconnect 0x0003b000 avl_adxcfg_5.rcfg_s1
ad_cpu_interconnect 0x0003c000 axi_fmcomms8_rx_dma.s_axi

ad_cpu_interconnect 0x00040000 fmcomms8_rx_os_jesd204.link_reconfig
ad_cpu_interconnect 0x00044000 fmcomms8_rx_os_jesd204.link_management
ad_cpu_interconnect 0x00045000 fmcomms8_rx_os_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00048000 avl_adxcfg_2.rcfg_s1
ad_cpu_interconnect 0x00049000 avl_adxcfg_3.rcfg_s1
ad_cpu_interconnect 0x0004a000 avl_adxcfg_6.rcfg_s1
ad_cpu_interconnect 0x0004b000 avl_adxcfg_7.rcfg_s1
ad_cpu_interconnect 0x0004c000 axi_fmcomms8_rx_os_dma.s_axi

ad_cpu_interconnect 0x00050000 axi_fmcomms8_rx.s_axi
ad_cpu_interconnect 0x00054000 axi_fmcomms8_tx.s_axi
ad_cpu_interconnect 0x00058000 axi_fmcomms8_rx_os.s_axi
ad_cpu_interconnect 0x00060000 avl_fmcomms8_gpio.s1

# dma interconnects

ad_dma_interconnect axi_fmcomms8_tx_dma.m_src_axi
ad_dma_interconnect_2 axi_fmcomms8_rx_dma.m_dest_axi
ad_dma_interconnect_2 axi_fmcomms8_rx_os_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 11 axi_fmcomms8_tx_dma.interrupt_sender
ad_cpu_interrupt 12 axi_fmcomms8_rx_dma.interrupt_sender
ad_cpu_interrupt 13 axi_fmcomms8_rx_os_dma.interrupt_sender
ad_cpu_interrupt 14 avl_fmcomms8_gpio.irq

