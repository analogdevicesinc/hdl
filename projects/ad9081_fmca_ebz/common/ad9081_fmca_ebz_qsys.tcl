###############################################################################
## Copyright (C) 2021-2024, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set JESD_MODE [ expr { [info exists ad_project_params(JESD_MODE)] \
                          ? $ad_project_params(JESD_MODE) : "8B10B" } ]
set LINK_MODE [expr {$JESD_MODE == "8B10B"} ? 1 : 2]

# RX parameters
set RX_NUM_OF_LINKS $ad_project_params(RX_NUM_LINKS)

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)

if {$JESD_MODE == "8B10B"} {
  set RX_DATA_PATH_WIDTH 4
  set RX_TPL_DATA_PATH_WIDTH 4
  if {$RX_JESD_NP==12} {
    set RX_TPL_DATA_PATH_WIDTH 6
  }
} else {
  set RX_DATA_PATH_WIDTH 8
  set RX_TPL_DATA_PATH_WIDTH 8
  if {$RX_JESD_NP==12} {
    set RX_TPL_DATA_PATH_WIDTH 12
  }
}

set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_OF_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_OF_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP
set RX_DMA_SAMPLE_WIDTH  16

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$RX_TPL_DATA_PATH_WIDTH / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_OF_LINKS $ad_project_params(TX_NUM_LINKS)

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

if {$JESD_MODE == "8B10B"} {
  set TX_DATA_PATH_WIDTH 4
  set TX_TPL_DATA_PATH_WIDTH 4
  if {$TX_JESD_NP==12} {
    set TX_TPL_DATA_PATH_WIDTH 6
  }
} else {
  set TX_DATA_PATH_WIDTH 8
  set TX_TPL_DATA_PATH_WIDTH 8
  if {$TX_JESD_NP==12} {
    set TX_TPL_DATA_PATH_WIDTH 12
  }
}


set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_OF_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_OF_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP
set TX_DMA_SAMPLE_WIDTH  16

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8*$TX_TPL_DATA_PATH_WIDTH / \
                                ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L
set RX_LANE_RATE [expr $ad_project_params(RX_LANE_RATE)*1000]
set TX_LANE_RATE [expr $ad_project_params(TX_LANE_RATE)*1000]

# Reference Clock Rate = Lane Rate / 40
set REF_CLK_RATE $ad_project_params(REF_CLK_RATE)

# Device Clock Rate
set DEVICE_CLK_RATE [expr $ad_project_params(DEVICE_CLK_RATE)*1000000]

set adc_data_offload_name mxfe_rx_data_offload
set adc_data_width [expr 8*$RX_TPL_DATA_PATH_WIDTH*$RX_NUM_OF_LANES*$RX_DMA_SAMPLE_WIDTH/$RX_SAMPLE_WIDTH]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]
set adc_data_offload_size [expr {$adc_data_width / 8 * int(pow(2, $adc_fifo_address_width))}]

set dac_data_offload_name mxfe_tx_data_offload
set dac_data_width [expr 8*$TX_TPL_DATA_PATH_WIDTH*$TX_NUM_OF_LANES*$TX_DMA_SAMPLE_WIDTH/$TX_SAMPLE_WIDTH]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]
set dac_data_offload_size [expr {$dac_data_width / 8 * int(pow(2, $dac_fifo_address_width))}]

# JESD204 clock bridges

add_instance tx_device_clk altera_clock_bridge
set_instance_parameter_value tx_device_clk {EXPLICIT_CLOCK_RATE} $DEVICE_CLK_RATE

add_instance rx_device_clk altera_clock_bridge
set_instance_parameter_value rx_device_clk {EXPLICIT_CLOCK_RATE} $DEVICE_CLK_RATE

#
## IP instantions and configuration
#

# RX JESD204 PHY-Link layer

add_instance mxfe_rx_jesd204 adi_jesd204
set_instance_parameter_value mxfe_rx_jesd204 {ID} {0}
set_instance_parameter_value mxfe_rx_jesd204 {LINK_MODE} $LINK_MODE
set_instance_parameter_value mxfe_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value mxfe_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value mxfe_rx_jesd204 {LANE_RATE} $RX_LANE_RATE
set_instance_parameter_value mxfe_rx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value mxfe_rx_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value mxfe_rx_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value mxfe_rx_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value mxfe_rx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value mxfe_rx_jesd204 {TPL_DATA_PATH_WIDTH} $RX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_jesd204 {DATA_PATH_WIDTH} $RX_DATA_PATH_WIDTH
# set_instance_parameter_value mxfe_rx_jesd204 {LANE_MAP} {5 7 0 1 2 3 4 6}


add_instance mxfe_rx_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value mxfe_rx_tpl {ID} {0}
set_instance_parameter_value mxfe_rx_tpl {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_tpl {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value mxfe_rx_tpl {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_tpl {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value mxfe_rx_tpl {OCTETS_PER_BEAT} $RX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_tpl {DMA_BITS_PER_SAMPLE} $RX_DMA_SAMPLE_WIDTH

# TX JESD204 PHY+Link

add_instance mxfe_tx_jesd204 adi_jesd204
set_instance_parameter_value mxfe_tx_jesd204 {ID} {0}
set_instance_parameter_value mxfe_tx_jesd204 {LINK_MODE} $LINK_MODE
set_instance_parameter_value mxfe_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value mxfe_tx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value mxfe_tx_jesd204 {LANE_RATE} $TX_LANE_RATE
set_instance_parameter_value mxfe_tx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value mxfe_tx_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value mxfe_tx_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value mxfe_tx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value mxfe_tx_jesd204 {TPL_DATA_PATH_WIDTH} $TX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_tx_jesd204 {DATA_PATH_WIDTH} $TX_DATA_PATH_WIDTH
# set_instance_parameter_value mxfe_tx_jesd204 {LANE_MAP} {5 7 0 1 2 3 4 6}


add_instance mxfe_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value mxfe_tx_tpl {ID} {0}
set_instance_parameter_value mxfe_tx_tpl {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_tx_tpl {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value mxfe_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {OCTETS_PER_BEAT} $TX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_tx_tpl {DMA_BITS_PER_SAMPLE} $TX_DMA_SAMPLE_WIDTH
# Disable DDS for now to make implementation faster
# set_instance_parameter_value mxfe_tx_tpl {DATAPATH_DISABLE} {true}

# pack(s) & unpack(s)

add_instance mxfe_tx_upack util_upack2
set_instance_parameter_value mxfe_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_tx_upack {SAMPLE_DATA_WIDTH} $TX_DMA_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_upack {INTERFACE_TYPE} {0}

add_instance mxfe_rx_cpack util_cpack2
set_instance_parameter_value mxfe_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_rx_cpack {SAMPLE_DATA_WIDTH} $RX_DMA_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_cpack {INTERFACE_TYPE} {0}

# RX and TX data offload buffers

add_instance $adc_data_offload_name adi_data_offload
set_instance_parameter_value $adc_data_offload_name {DATAPATH_TYPE} {0}
set_instance_parameter_value $adc_data_offload_name {MEM_TYPE} {0}
set_instance_parameter_value $adc_data_offload_name {MEM_SIZE} $adc_data_offload_size
set_instance_parameter_value $adc_data_offload_name {SOURCE_DWIDTH} $adc_data_width
set_instance_parameter_value $adc_data_offload_name {DESTINATION_DWIDTH} $adc_dma_data_width

add_instance $dac_data_offload_name adi_data_offload
set_instance_parameter_value $dac_data_offload_name {DATAPATH_TYPE} {1}
set_instance_parameter_value $dac_data_offload_name {MEM_TYPE} {0}
set_instance_parameter_value $dac_data_offload_name {MEM_SIZE} $dac_data_offload_size
set_instance_parameter_value $dac_data_offload_name {SOURCE_DWIDTH} $dac_dma_data_width
set_instance_parameter_value $dac_data_offload_name {DESTINATION_DWIDTH} $dac_data_width

# RX and TX DMA instance and connections

add_instance mxfe_tx_dma axi_dmac
set_instance_parameter_value mxfe_tx_dma {ID} {0}
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_SRC} $dac_dma_data_width
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value mxfe_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_tx_dma {CYCLIC} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value mxfe_tx_dma {HAS_AXIS_TLAST} {1}
set_instance_parameter_value mxfe_tx_dma {HAS_AXIS_TKEEP} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {MAX_BYTES_PER_BURST} {2048}

add_instance mxfe_rx_dma axi_dmac
set_instance_parameter_value mxfe_rx_dma {ID} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_DEST} $adc_dma_data_width
set_instance_parameter_value mxfe_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value mxfe_rx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_rx_dma {CYCLIC} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value mxfe_rx_dma {FIFO_SIZE} {16}
set_instance_parameter_value mxfe_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {MAX_BYTES_PER_BURST} {2048}

# mxfe gpio

add_instance mxfe_gpio altera_avalon_pio
set_instance_parameter_value mxfe_gpio {direction} {Input}
set_instance_parameter_value mxfe_gpio {generateIRQ} {1}
set_instance_parameter_value mxfe_gpio {width} {15}
add_connection sys_clk.clk mxfe_gpio.clk
add_connection sys_clk.clk_reset mxfe_gpio.reset
add_interface mxfe_gpio conduit end
set_interface_property mxfe_gpio EXPORT_OF mxfe_gpio.external_connection

#
## clocks and resets
#

# system clock and reset

add_connection sys_clk.clk mxfe_rx_jesd204.sys_clk
add_connection sys_clk.clk mxfe_rx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx_dma.s_axi_clock
add_connection sys_clk.clk mxfe_tx_jesd204.sys_clk
add_connection sys_clk.clk mxfe_tx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_tx_dma.s_axi_clock
add_connection sys_clk.clk $dac_data_offload_name.sys_clk
add_connection sys_clk.clk $adc_data_offload_name.sys_clk

add_connection sys_clk.clk_reset mxfe_rx_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_rx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx_dma.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_tx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_dma.s_axi_reset
add_connection sys_clk.clk_reset $dac_data_offload_name.sys_resetn
add_connection sys_clk.clk_reset $adc_data_offload_name.sys_resetn

# device clock and reset

add_connection rx_device_clk.out_clk mxfe_rx_jesd204.device_clk
add_connection rx_device_clk.out_clk mxfe_rx_tpl.link_clk
add_connection rx_device_clk.out_clk mxfe_rx_cpack.clk
add_connection rx_device_clk.out_clk $adc_data_offload_name.s_axis_aclk

add_connection tx_device_clk.out_clk mxfe_tx_jesd204.device_clk
add_connection tx_device_clk.out_clk mxfe_tx_tpl.link_clk
add_connection tx_device_clk.out_clk mxfe_tx_upack.clk
add_connection tx_device_clk.out_clk $dac_data_offload_name.m_axis_aclk

add_connection mxfe_rx_jesd204.link_reset mxfe_rx_cpack.reset
add_connection mxfe_rx_jesd204.link_reset $adc_data_offload_name.s_axis_aresetn

add_connection mxfe_tx_jesd204.link_reset mxfe_tx_upack.reset
add_connection mxfe_tx_jesd204.link_reset $dac_data_offload_name.m_axis_aresetn

# dma clock and reset

add_connection sys_dma_clk.clk $adc_data_offload_name.m_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx_dma.m_dest_axi_reset
add_connection sys_dma_clk.clk_reset $adc_data_offload_name.m_axis_aresetn

add_connection sys_dma_clk.clk $dac_data_offload_name.s_axis_aclk
add_connection sys_dma_clk.clk mxfe_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk mxfe_tx_dma.m_src_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_tx_dma.m_src_axi_reset
add_connection sys_dma_clk.clk_reset $dac_data_offload_name.s_axis_aresetn

#
## Exported signals
#

add_interface rx_ref_clk      clock   sink
# add_interface rx_pll_clk      clock   sink
add_interface rx_sysref       conduit end
add_interface rx_sync         conduit end
add_interface rx_serial_data  conduit end
add_interface tx_ref_clk      clock   sink
# add_interface tx_pll_clk      clock   sink
add_interface rx_device_clk   clock   sink
add_interface tx_serial_data  conduit end
add_interface tx_sysref       conduit end
add_interface tx_sync         conduit end
add_interface tx_device_clk   clock   sink

set_interface_property rx_ref_clk       EXPORT_OF mxfe_rx_jesd204.ref_clk
# set_interface_property rx_pll_clk       EXPORT_OF mxfe_rx_jesd204.pll_clk
set_interface_property rx_sysref        EXPORT_OF mxfe_rx_jesd204.sysref
set_interface_property rx_sync          EXPORT_OF mxfe_rx_jesd204.sync
set_interface_property rx_serial_data   EXPORT_OF mxfe_rx_jesd204.serial_data
set_interface_property rx_device_clk    EXPORT_OF rx_device_clk.in_clk

set_interface_property tx_ref_clk       EXPORT_OF mxfe_tx_jesd204.ref_clk
# set_interface_property tx_pll_clk       EXPORT_OF mxfe_tx_jesd204.pll_clk
set_interface_property tx_sysref        EXPORT_OF mxfe_tx_jesd204.sysref
set_interface_property tx_sync          EXPORT_OF mxfe_tx_jesd204.sync
set_interface_property tx_serial_data   EXPORT_OF mxfe_tx_jesd204.serial_data
set_interface_property tx_device_clk    EXPORT_OF tx_device_clk.in_clk

if {$TRANSCEIVER_TYPE == "F-Tile"} {
  add_interface tx_serial_data_n   conduit end
  add_interface rx_serial_data_n   conduit end

  set_interface_property rx_serial_data_n   EXPORT_OF mxfe_rx_jesd204.serial_data_n
  set_interface_property tx_serial_data_n   EXPORT_OF mxfe_tx_jesd204.serial_data_n
}

#
## Data interface / data path
#

# RX link to tpl
add_connection mxfe_rx_jesd204.link_sof mxfe_rx_tpl.if_link_sof
add_connection mxfe_rx_jesd204.link_data mxfe_rx_tpl.link_data
# RX tpl to cpack
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_rx_tpl.adc_ch_$i mxfe_rx_cpack.adc_ch_$i
}
add_connection mxfe_rx_tpl.if_adc_dovf mxfe_rx_cpack.if_fifo_wr_overflow
# RX cpack to offload
add_connection mxfe_rx_cpack.m_axis $adc_data_offload_name.s_axis
# RX offload to dma
add_connection $adc_data_offload_name.init_req mxfe_rx_dma.if_s_axis_xfer_req
add_connection $adc_data_offload_name.m_axis mxfe_rx_dma.s_axis
# RX dma to HPS
ad_dma_interconnect mxfe_rx_dma.m_dest_axi

# TX link to tpl
add_connection mxfe_tx_tpl.link_data mxfe_tx_jesd204.link_data
# TX tpl to pack
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_tx_upack.dac_ch_$i mxfe_tx_tpl.dac_ch_$i
}
add_connection mxfe_tx_upack.if_fifo_rd_underflow mxfe_tx_tpl.if_dac_dunf
# TX pack to offload
add_connection $dac_data_offload_name.m_axis mxfe_tx_upack.s_axis
# TX offload to dma
add_connection mxfe_tx_dma.if_m_axis_xfer_req $dac_data_offload_name.init_req
add_connection mxfe_tx_dma.m_axis $dac_data_offload_name.s_axis
# TX dma to HPS
ad_dma_interconnect mxfe_tx_dma.m_src_axi

# reconfiguration interface sharing for A10soc

if {$TRANSCEIVER_TYPE != "F-Tile"} {
  set MAX_NUM_OF_LANES $TX_NUM_OF_LANES
  if {$RX_NUM_OF_LANES > $TX_NUM_OF_LANES} {
    set MAX_NUM_OF_LANES $RX_NUM_OF_LANES
  }
  for {set i 0} {$i < $MAX_NUM_OF_LANES} {incr i} {
    add_instance avl_adxcfg_${i} avl_adxcfg
    add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
    add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
    add_connection avl_adxcfg_${i}.rcfg_m0 mxfe_tx_jesd204.phy_reconfig_${i}
    add_connection avl_adxcfg_${i}.rcfg_m1 mxfe_rx_jesd204.phy_reconfig_${i}

    set_instance_parameter_value avl_adxcfg_${i} {ADDRESS_WIDTH} $xcvr_reconfig_addr_width
  }
}

#
## address map
#

## NOTE: if bridge is used, the address will be bridge_base_addr + peripheral_base_addr
#

if {$TRANSCEIVER_TYPE == "F-Tile"} {
  ad_cpu_interconnect 0x00000000 mxfe_rx_jesd204.phy_reconfig "avl_mm_bridge_0" 0x10000000 25
  ad_cpu_interconnect 0x00800000 mxfe_tx_jesd204.phy_reconfig "avl_mm_bridge_0"
} else {
  ad_cpu_interconnect 0x00020000 mxfe_rx_jesd204.link_pll_reconfig "avl_mm_bridge_0" 0x00040000
  if {$RX_NUM_OF_LANES > 0} {ad_cpu_interconnect 0x00000000 avl_adxcfg_0.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 1} {ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 2} {ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 3} {ad_cpu_interconnect 0x00006000 avl_adxcfg_3.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 4} {ad_cpu_interconnect 0x00008000 avl_adxcfg_4.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 5} {ad_cpu_interconnect 0x0000A000 avl_adxcfg_5.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 6} {ad_cpu_interconnect 0x0000C000 avl_adxcfg_6.rcfg_s0    "avl_mm_bridge_0"}
  if {$RX_NUM_OF_LANES > 7} {ad_cpu_interconnect 0x0000E000 avl_adxcfg_7.rcfg_s0    "avl_mm_bridge_0"}

  ad_cpu_interconnect 0x00020000 mxfe_tx_jesd204.link_pll_reconfig "avl_mm_bridge_1" 0x00080000
  if {$TX_NUM_OF_LANES > 0} {ad_cpu_interconnect 0x00000000 avl_adxcfg_0.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 1} {ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 2} {ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 3} {ad_cpu_interconnect 0x00006000 avl_adxcfg_3.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 4} {ad_cpu_interconnect 0x00008000 avl_adxcfg_4.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 5} {ad_cpu_interconnect 0x0000A000 avl_adxcfg_5.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 6} {ad_cpu_interconnect 0x0000C000 avl_adxcfg_6.rcfg_s1    "avl_mm_bridge_1"}
  if {$TX_NUM_OF_LANES > 7} {ad_cpu_interconnect 0x0000E000 avl_adxcfg_7.rcfg_s1    "avl_mm_bridge_1"}

  ad_cpu_interconnect 0x000D0000 mxfe_tx_jesd204.lane_pll_reconfig
}

ad_cpu_interconnect 0x000C0000 mxfe_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x000C4000 mxfe_rx_jesd204.link_management
ad_cpu_interconnect 0x000C8000 mxfe_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x000CC000 mxfe_tx_jesd204.link_management
ad_cpu_interconnect 0x000D2000 mxfe_rx_tpl.s_axi
ad_cpu_interconnect 0x000D4000 mxfe_tx_tpl.s_axi
ad_cpu_interconnect 0x000D8000 mxfe_rx_dma.s_axi
ad_cpu_interconnect 0x000DC000 mxfe_tx_dma.s_axi
ad_cpu_interconnect 0x000E0000 mxfe_gpio.s1
ad_cpu_interconnect 0x000F0000 $adc_data_offload_name.s_axi
ad_cpu_interconnect 0x00100000 $dac_data_offload_name.s_axi

#
## interrupts
#

ad_cpu_interrupt 11  mxfe_rx_dma.interrupt_sender
ad_cpu_interrupt 12  mxfe_tx_dma.interrupt_sender
ad_cpu_interrupt 13  mxfe_rx_jesd204.interrupt
ad_cpu_interrupt 14  mxfe_tx_jesd204.interrupt
ad_cpu_interrupt 15  mxfe_gpio.irq
