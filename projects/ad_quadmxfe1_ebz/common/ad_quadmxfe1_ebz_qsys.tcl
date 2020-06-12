# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set ENCODER_SEL 1
  set ADI_PHY_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set ENCODER_SEL 2
  set ADI_PHY_SEL 0
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 4
set MAX_TX_LANES_PER_LINK 4
set MAX_RX_LINKS 4
set MAX_TX_LINKS 4
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]

# RX parameters
set RX_NUM_OF_LINKS $ad_project_params(RX_NUM_LINKS)

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)


set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_OF_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_OF_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_OF_LINKS $ad_project_params(TX_NUM_LINKS)

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_OF_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_OF_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8*$DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr 8*$DATAPATH_WIDTH*$RX_NUM_OF_LANES]
set adc_dma_data_width [expr 8*$DATAPATH_WIDTH*$RX_NUM_OF_LANES]
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr 8*$DATAPATH_WIDTH*$TX_NUM_OF_LANES]
set dac_dma_data_width [expr 8*$DATAPATH_WIDTH*$TX_NUM_OF_LANES]
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_SAMPLE_WIDTH))/log(2)))]

# JESD204B/C clock bridges

add_instance tx_device_clk altera_clock_bridge 19.1
set_instance_parameter_value tx_device_clk {EXPLICIT_CLOCK_RATE} {250000000}

add_instance rx_device_clk altera_clock_bridge 19.1
set_instance_parameter_value rx_device_clk {EXPLICIT_CLOCK_RATE} {250000000}

#
## IP instantions and configuration
#

# RX JESD204 PHY-Link layer

add_instance quad_mxfe_rx_jesd204 adi_jesd204
set_instance_parameter_value quad_mxfe_rx_jesd204 {ID} {0}
set_instance_parameter_value quad_mxfe_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value quad_mxfe_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value quad_mxfe_rx_jesd204 {LANE_RATE} {10000}
set_instance_parameter_value quad_mxfe_rx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value quad_mxfe_rx_jesd204 {REFCLK_FREQUENCY} {250.0}
set_instance_parameter_value quad_mxfe_rx_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value quad_mxfe_rx_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value quad_mxfe_rx_jesd204 {EXT_DEVICE_CLK_EN} {1}


add_instance quad_mxfe_rx_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value quad_mxfe_rx_tpl {ID} {0}
set_instance_parameter_value quad_mxfe_rx_tpl {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value quad_mxfe_rx_tpl {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value quad_mxfe_rx_tpl {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value quad_mxfe_rx_tpl {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value quad_mxfe_rx_tpl {TWOS_COMPLEMENT} {1}

# TX JESD204 PHY+Link

add_instance quad_mxfe_tx_jesd204 adi_jesd204
set_instance_parameter_value quad_mxfe_tx_jesd204 {ID} {0}
set_instance_parameter_value quad_mxfe_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value quad_mxfe_tx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value quad_mxfe_tx_jesd204 {LANE_RATE} {10000}
set_instance_parameter_value quad_mxfe_tx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value quad_mxfe_tx_jesd204 {REFCLK_FREQUENCY} {250.0}
set_instance_parameter_value quad_mxfe_tx_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value quad_mxfe_tx_jesd204 {EXT_DEVICE_CLK_EN} {1}


add_instance quad_mxfe_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value quad_mxfe_tx_tpl {ID} {0}
set_instance_parameter_value quad_mxfe_tx_tpl {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value quad_mxfe_tx_tpl {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value quad_mxfe_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value quad_mxfe_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH

# pack(s) & unpack(s)

add_instance quad_mxfe_tx_upack util_upack2
set_instance_parameter_value quad_mxfe_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value quad_mxfe_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value quad_mxfe_tx_upack {SAMPLE_DATA_WIDTH} $TX_SAMPLE_WIDTH
set_instance_parameter_value quad_mxfe_tx_upack {INTERFACE_TYPE} {1}

add_instance quad_mxfe_rx_cpack util_cpack2
set_instance_parameter_value quad_mxfe_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value quad_mxfe_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value quad_mxfe_rx_cpack {SAMPLE_DATA_WIDTH} $RX_SAMPLE_WIDTH

# RX and TX data offload buffers

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width
ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

# RX and TX DMA instance and connections

add_instance quad_mxfe_tx_dma axi_dmac
set_instance_parameter_value quad_mxfe_tx_dma {ID} {0}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value quad_mxfe_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value quad_mxfe_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value quad_mxfe_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value quad_mxfe_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value quad_mxfe_tx_dma {CYCLIC} {1}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value quad_mxfe_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value quad_mxfe_tx_dma {HAS_AXIS_TLAST} {1}
set_instance_parameter_value quad_mxfe_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value quad_mxfe_tx_dma {MAX_BYTES_PER_BURST} {4096}

add_instance quad_mxfe_rx_dma axi_dmac
set_instance_parameter_value quad_mxfe_rx_dma {ID} {0}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value quad_mxfe_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value quad_mxfe_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value quad_mxfe_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value quad_mxfe_rx_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value quad_mxfe_rx_dma {CYCLIC} {0}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value quad_mxfe_rx_dma {FIFO_SIZE} {16}
set_instance_parameter_value quad_mxfe_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value quad_mxfe_rx_dma {MAX_BYTES_PER_BURST} {4096}

#
## clocks and resets
#

# system clock and reset

add_connection sys_clk.clk quad_mxfe_rx_jesd204.sys_clk
add_connection sys_clk.clk quad_mxfe_rx_tpl.s_axi_clock
add_connection sys_clk.clk quad_mxfe_rx_dma.s_axi_clock
add_connection sys_clk.clk quad_mxfe_tx_jesd204.sys_clk
add_connection sys_clk.clk quad_mxfe_tx_tpl.s_axi_clock
add_connection sys_clk.clk quad_mxfe_tx_dma.s_axi_clock

add_connection sys_clk.clk_reset quad_mxfe_rx_jesd204.sys_resetn
add_connection sys_clk.clk_reset quad_mxfe_rx_tpl.s_axi_reset
add_connection sys_clk.clk_reset quad_mxfe_rx_dma.s_axi_reset
add_connection sys_clk.clk_reset quad_mxfe_tx_jesd204.sys_resetn
add_connection sys_clk.clk_reset quad_mxfe_tx_tpl.s_axi_reset
add_connection sys_clk.clk_reset quad_mxfe_tx_dma.s_axi_reset

# device clock and reset

add_connection rx_device_clk.out_clk quad_mxfe_rx_jesd204.device_clk
add_connection rx_device_clk.out_clk quad_mxfe_rx_tpl.link_clk
add_connection rx_device_clk.out_clk quad_mxfe_rx_cpack.clk
add_connection rx_device_clk.out_clk $adc_fifo_name.if_adc_clk

add_connection tx_device_clk.out_clk quad_mxfe_tx_jesd204.device_clk
add_connection tx_device_clk.out_clk quad_mxfe_tx_tpl.link_clk
add_connection tx_device_clk.out_clk quad_mxfe_tx_upack.clk
add_connection tx_device_clk.out_clk $dac_fifo_name.if_dac_clk

add_connection quad_mxfe_rx_jesd204.link_reset quad_mxfe_rx_cpack.reset
add_connection quad_mxfe_rx_jesd204.link_reset $adc_fifo_name.if_adc_rst

add_connection quad_mxfe_tx_jesd204.link_reset quad_mxfe_tx_upack.reset
add_connection quad_mxfe_tx_jesd204.link_reset $dac_fifo_name.if_dac_rst

# dma clock and reset

add_connection sys_dma_clk.clk $adc_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk quad_mxfe_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk quad_mxfe_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset quad_mxfe_rx_dma.m_dest_axi_reset
add_connection sys_dma_clk.clk_reset $adc_fifo_name.if_dma_rst

add_connection sys_dma_clk.clk $dac_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk quad_mxfe_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk quad_mxfe_tx_dma.m_src_axi_clock

add_connection sys_dma_clk.clk_reset quad_mxfe_tx_dma.m_src_axi_reset
add_connection sys_dma_clk.clk_reset $dac_fifo_name.if_dma_rst

#
## Exported signals
#

add_interface rx_ref_clk      clock   sink
add_interface rx_sysref       conduit end
add_interface rx_sync         conduit end
add_interface rx_serial_data  conduit end
add_interface tx_ref_clk      clock   sink
add_interface rx_device_clk   clock   sink
add_interface tx_serial_data  conduit end
add_interface tx_sysref       conduit end
add_interface tx_sync         conduit end
add_interface tx_fifo_bypass  conduit end
add_interface tx_device_clk   clock   sink

set_interface_property rx_ref_clk       EXPORT_OF quad_mxfe_rx_jesd204.ref_clk
set_interface_property rx_sysref        EXPORT_OF quad_mxfe_rx_jesd204.sysref
set_interface_property rx_sync          EXPORT_OF quad_mxfe_rx_jesd204.sync
set_interface_property rx_serial_data   EXPORT_OF quad_mxfe_rx_jesd204.serial_data
set_interface_property rx_device_clk    EXPORT_OF rx_device_clk.in_clk

set_interface_property tx_ref_clk       EXPORT_OF quad_mxfe_tx_jesd204.ref_clk
set_interface_property tx_sysref        EXPORT_OF quad_mxfe_tx_jesd204.sysref
set_interface_property tx_sync          EXPORT_OF quad_mxfe_tx_jesd204.sync
set_interface_property tx_serial_data   EXPORT_OF quad_mxfe_tx_jesd204.serial_data
set_interface_property tx_fifo_bypass   EXPORT_OF $dac_fifo_name.if_bypass
set_interface_property tx_device_clk    EXPORT_OF tx_device_clk.in_clk

#
## Data interface / data path
#

# RX link to tpl
add_connection quad_mxfe_rx_jesd204.link_sof quad_mxfe_rx_tpl.if_link_sof
add_connection quad_mxfe_rx_jesd204.link_data quad_mxfe_rx_tpl.link_data
# RX tpl to cpack
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection quad_mxfe_rx_tpl.adc_ch_$i quad_mxfe_rx_cpack.adc_ch_$i
}
add_connection quad_mxfe_rx_tpl.if_adc_dovf $adc_fifo_name.if_adc_wovf
# RX cpack to offload
add_connection quad_mxfe_rx_cpack.if_packed_fifo_wr_en $adc_fifo_name.if_adc_wr
add_connection quad_mxfe_rx_cpack.if_packed_fifo_wr_data $adc_fifo_name.if_adc_wdata
# RX offload to dma
add_connection $adc_fifo_name.if_dma_xfer_req quad_mxfe_rx_dma.if_s_axis_xfer_req
add_connection $adc_fifo_name.m_axis quad_mxfe_rx_dma.s_axis
# RX dma to HPS
ad_dma_interconnect quad_mxfe_rx_dma.m_dest_axi

# TX link to tpl
add_connection quad_mxfe_tx_tpl.link_data quad_mxfe_tx_jesd204.link_data
# TX tpl to pack
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection quad_mxfe_tx_upack.dac_ch_$i quad_mxfe_tx_tpl.dac_ch_$i
}
# TX pack to offload
add_connection quad_mxfe_tx_upack.if_packed_fifo_rd_en $dac_fifo_name.if_dac_valid
add_connection $dac_fifo_name.if_dac_data quad_mxfe_tx_upack.if_packed_fifo_rd_data
add_connection $dac_fifo_name.if_dac_dunf quad_mxfe_tx_tpl.if_dac_dunf
# TX offload to dma
add_connection quad_mxfe_tx_dma.if_m_axis_xfer_req $dac_fifo_name.if_dma_xfer_req
add_connection quad_mxfe_tx_dma.m_axis $dac_fifo_name.s_axis
# TX dma to HPS
ad_dma_interconnect quad_mxfe_tx_dma.m_src_axi

# reconfiguration interface sharing

for {set i 0} {$i < $TX_NUM_OF_LANES} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m0 quad_mxfe_tx_jesd204.phy_reconfig_${i}
  add_connection avl_adxcfg_${i}.rcfg_m1 quad_mxfe_rx_jesd204.phy_reconfig_${i}

  set_instance_parameter_value avl_adxcfg_${i} {ADDRESS_WIDTH} $xcvr_reconfig_addr_width

}

#
## address map
#

## NOTE: if bridge is used, the address will be bridge_base_addr + peripheral_base_addr
#

ad_cpu_interconnect 0x00020000 quad_mxfe_rx_jesd204.link_pll_reconfig "avl_mm_bridge_0" 0x00040000
ad_cpu_interconnect 0x00000000 avl_adxcfg_0.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00006000 avl_adxcfg_3.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00008000 avl_adxcfg_4.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000A000 avl_adxcfg_5.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000C000 avl_adxcfg_6.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x0000E000 avl_adxcfg_7.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00010000 avl_adxcfg_8.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00012000 avl_adxcfg_9.rcfg_s0    "avl_mm_bridge_0"
ad_cpu_interconnect 0x00014000 avl_adxcfg_10.rcfg_s0   "avl_mm_bridge_0"
ad_cpu_interconnect 0x00016000 avl_adxcfg_11.rcfg_s0   "avl_mm_bridge_0"
ad_cpu_interconnect 0x00018000 avl_adxcfg_12.rcfg_s0   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001A000 avl_adxcfg_13.rcfg_s0   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001C000 avl_adxcfg_14.rcfg_s0   "avl_mm_bridge_0"
ad_cpu_interconnect 0x0001E000 avl_adxcfg_15.rcfg_s0   "avl_mm_bridge_0"

ad_cpu_interconnect 0x00020000 quad_mxfe_tx_jesd204.link_pll_reconfig "avl_mm_bridge_1" 0x00080000
ad_cpu_interconnect 0x00000000 avl_adxcfg_0.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00006000 avl_adxcfg_3.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00008000 avl_adxcfg_4.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000A000 avl_adxcfg_5.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000C000 avl_adxcfg_6.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x0000E000 avl_adxcfg_7.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00010000 avl_adxcfg_8.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00012000 avl_adxcfg_9.rcfg_s1    "avl_mm_bridge_1"
ad_cpu_interconnect 0x00014000 avl_adxcfg_10.rcfg_s1   "avl_mm_bridge_1"
ad_cpu_interconnect 0x00016000 avl_adxcfg_11.rcfg_s1   "avl_mm_bridge_1"
ad_cpu_interconnect 0x00018000 avl_adxcfg_12.rcfg_s1   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001A000 avl_adxcfg_13.rcfg_s1   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001C000 avl_adxcfg_14.rcfg_s1   "avl_mm_bridge_1"
ad_cpu_interconnect 0x0001E000 avl_adxcfg_15.rcfg_s1   "avl_mm_bridge_1"

ad_cpu_interconnect 0x000C0000 quad_mxfe_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x000C4000 quad_mxfe_rx_jesd204.link_management
ad_cpu_interconnect 0x000C8000 quad_mxfe_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x000CC000 quad_mxfe_tx_jesd204.link_management
ad_cpu_interconnect 0x000D0000 quad_mxfe_tx_jesd204.lane_pll_reconfig
ad_cpu_interconnect 0x000D2000 quad_mxfe_rx_tpl.s_axi
ad_cpu_interconnect 0x000D4000 quad_mxfe_tx_tpl.s_axi
ad_cpu_interconnect 0x000D8000 quad_mxfe_rx_dma.s_axi
ad_cpu_interconnect 0x000DC000 quad_mxfe_tx_dma.s_axi

#
## interrupts
#

ad_cpu_interrupt 11  quad_mxfe_rx_dma.interrupt_sender
ad_cpu_interrupt 12  quad_mxfe_tx_dma.interrupt_sender
ad_cpu_interrupt 13  quad_mxfe_rx_jesd204.interrupt
ad_cpu_interrupt 14  quad_mxfe_tx_jesd204.interrupt

