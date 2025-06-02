###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE [expr $ad_project_params(RX_LANE_RATE) * 1000]
set TX_LANE_RATE [expr $ad_project_params(TX_LANE_RATE) * 1000]

set ASYMMETRIC_A_B_MODE [ expr { [info exists ad_project_params(ASYMMETRIC_A_B_MODE)] \
                          ? $ad_project_params(ASYMMETRIC_A_B_MODE) : 0 } ]
if {$ASYMMETRIC_A_B_MODE} {
  error "ASYMMETRIC_A_B_MODE not supported for this carrier!"
}

set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 0 } ]
set adc_do_mem_type [ expr { [info exists ad_project_params(ADC_DO_MEM_TYPE)] \
                          ? $ad_project_params(ADC_DO_MEM_TYPE) : 0 } ]
set dac_do_mem_type [ expr { [info exists ad_project_params(DAC_DO_MEM_TYPE)] \
                          ? $ad_project_params(DAC_DO_MEM_TYPE) : 0 } ]
set do_axi_data_width [ expr { [info exists do_axi_data_width] \
                          ? $do_axi_data_width : 256 } ]

if {$JESD_MODE == "8B10B"} {
  set ENCODER_SEL 1
} else {
  set ENCODER_SEL 2
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 12
set MAX_TX_LANES_PER_LINK 12
set MAX_RX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_TX_LINKS [expr $ASYMMETRIC_A_B_MODE ? 1 : 2]
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]
set MAX_APOLLO_LANES 24

# RX parameters
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)

set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP

set RX_DMA_SAMPLE_WIDTH $RX_JESD_NP
if {$RX_DMA_SAMPLE_WIDTH == 12} {
  set RX_DMA_SAMPLE_WIDTH 16
}

if {$JESD_MODE == "8B10B"} {
  set RX_DATAPATH_WIDTH 4
  if {$RX_JESD_NP == 12} {
    set RX_DATAPATH_WIDTH 6
  }
} else {
  set RX_DATAPATH_WIDTH 8
  if {$RX_JESD_NP == 12} {
    set RX_DATAPATH_WIDTH 12
  }
}

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8* $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set TX_NUM_LINKS 1
}

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP

set TX_DMA_SAMPLE_WIDTH $TX_JESD_NP
if {$TX_DMA_SAMPLE_WIDTH == 12} {
  set TX_DMA_SAMPLE_WIDTH 16
}

if {$JESD_MODE == "8B10B"} {
  set TX_DATAPATH_WIDTH 4
  if {$TX_JESD_NP == 12} {
    set TX_DATAPATH_WIDTH 6
  }
} else {
  set TX_DATAPATH_WIDTH 8
  if {$TX_JESD_NP == 12} {
    set TX_DATAPATH_WIDTH 12
  }
}

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8* $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_fifo_name apollo_rx_fifo
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name apollo_tx_fifo
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

# RX B JESD parameter per link
if {$ASYMMETRIC_A_B_MODE} {
  set RX_B_JESD_M     $ad_project_params(RX_B_JESD_M)
  set RX_B_JESD_L     $ad_project_params(RX_B_JESD_L)
  set RX_B_JESD_S     $ad_project_params(RX_B_JESD_S)
  set RX_B_JESD_NP    $ad_project_params(RX_B_JESD_NP)

  set RX_B_NUM_OF_LANES      [expr $RX_B_JESD_L * $RX_NUM_LINKS]
  set RX_B_NUM_OF_CONVERTERS [expr $RX_B_JESD_M * $RX_NUM_LINKS]
  set RX_B_SAMPLES_PER_FRAME $RX_B_JESD_S
  set RX_B_SAMPLE_WIDTH      $RX_B_JESD_NP

  set RX_B_DMA_SAMPLE_WIDTH $RX_B_JESD_NP
  if {$RX_B_DMA_SAMPLE_WIDTH == 12} {
    set RX_B_DMA_SAMPLE_WIDTH 16
  }

  if {$JESD_MODE == "8B10B"} {
    set RX_B_DATAPATH_WIDTH 4
    if {$RX_B_JESD_NP == 12} {
      set RX_B_DATAPATH_WIDTH 6
    }
  } else {
    set RX_B_DATAPATH_WIDTH 8
    if {$RX_B_JESD_NP == 12} {
      set RX_B_DATAPATH_WIDTH 12
    }
  }

  set RX_B_SAMPLES_PER_CHANNEL [expr $RX_B_NUM_OF_LANES * 8* $RX_B_DATAPATH_WIDTH / ($RX_B_NUM_OF_CONVERTERS * $RX_B_SAMPLE_WIDTH)]

  set adc_b_fifo_name apollo_rx_b_fifo
  set adc_b_data_width [expr $RX_B_DMA_SAMPLE_WIDTH*$RX_B_NUM_OF_CONVERTERS*$RX_B_SAMPLES_PER_CHANNEL]
  set adc_b_dma_data_width $adc_data_width
  set adc_b_fifo_address_width [expr int(ceil(log(($adc_b_fifo_samples_per_converter*$RX_B_NUM_OF_CONVERTERS) / ($adc_b_data_width/$RX_B_DMA_SAMPLE_WIDTH))/log(2)))]
} else {
  set RX_B_JESD_M     0
  set RX_B_JESD_L     0
  set RX_B_JESD_S     1
  set RX_B_JESD_NP    16

  set RX_B_NUM_OF_LANES      [expr $RX_B_JESD_L * $RX_NUM_LINKS]
  set RX_B_NUM_OF_CONVERTERS [expr $RX_B_JESD_M * $RX_NUM_LINKS]
  set RX_B_SAMPLES_PER_FRAME $RX_B_JESD_S
  set RX_B_SAMPLE_WIDTH      $RX_B_JESD_NP
}

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
if {$ASYMMETRIC_A_B_MODE} {
  set TX_NUM_LINKS 1
}

# TX JESD parameter per link
if {$ASYMMETRIC_A_B_MODE} {
  set TX_B_JESD_M     $ad_project_params(TX_B_JESD_M)
  set TX_B_JESD_L     $ad_project_params(TX_B_JESD_L)
  set TX_B_JESD_S     $ad_project_params(TX_B_JESD_S)
  set TX_B_JESD_NP    $ad_project_params(TX_B_JESD_NP)

  set TX_B_NUM_OF_LANES      [expr $TX_B_JESD_L * $TX_NUM_LINKS]
  set TX_B_NUM_OF_CONVERTERS [expr $TX_B_JESD_M * $TX_NUM_LINKS]
  set TX_B_SAMPLES_PER_FRAME $TX_B_JESD_S
  set TX_B_SAMPLE_WIDTH      $TX_B_JESD_NP

  set TX_B_DMA_SAMPLE_WIDTH $TX_B_JESD_NP
  if {$TX_B_DMA_SAMPLE_WIDTH == 12} {
    set TX_B_DMA_SAMPLE_WIDTH 16
  }

  if {$JESD_MODE == "8B10B"} {
    set TX_B_DATAPATH_WIDTH 4
    if {$TX_B_JESD_NP == 12} {
      set TX_B_DATAPATH_WIDTH 6
    }
  } else {
    set TX_B_DATAPATH_WIDTH 8
    if {$TX_B_JESD_NP == 12} {
      set TX_DATAPATH_WIDTH 12
    }
  }

  set TX_B_SAMPLES_PER_CHANNEL [expr $TX_B_NUM_OF_LANES * 8* $TX_B_DATAPATH_WIDTH / ($TX_B_NUM_OF_CONVERTERS * $TX_B_SAMPLE_WIDTH)]

  set dac_b_fifo_name apollo_tx_b_fifo
  set dac_b_data_width [expr $TX_B_DMA_SAMPLE_WIDTH*$TX_B_NUM_OF_CONVERTERS*$TX_B_SAMPLES_PER_CHANNEL]
  set dac_b_dma_data_width $dac_data_width
  set dac_b_fifo_address_width [expr int(ceil(log(($dac_b_fifo_samples_per_converter*$TX_B_NUM_OF_CONVERTERS) / ($dac_b_data_width/$TX_B_DMA_SAMPLE_WIDTH))/log(2)))]
} else {
  set TX_B_JESD_M     0
  set TX_B_JESD_L     0
  set TX_B_JESD_S     1
  set TX_B_JESD_NP    16

  set TX_B_NUM_OF_LANES      [expr $TX_B_JESD_L * $TX_NUM_LINKS]
  set TX_B_NUM_OF_CONVERTERS [expr $TX_B_JESD_M * $TX_NUM_LINKS]
  set TX_B_SAMPLES_PER_FRAME $TX_B_JESD_S
  set TX_B_SAMPLE_WIDTH      $TX_B_JESD_NP
}

# Reference Clock Rate = Lane Rate / 40 or Lane Rate / 66
set REF_CLK_RATE $ad_project_params(REF_CLK_RATE)

# Device Clock Rate
set DEVICE_CLK_RATE [expr $ad_project_params(DEVICE_CLK_RATE)*1000000]

# JESD204B clock bridges

add_instance rx_device_clk altera_clock_bridge
set_instance_parameter_value rx_device_clk {EXPLICIT_CLOCK_RATE} $DEVICE_CLK_RATE

add_instance tx_device_clk altera_clock_bridge
set_instance_parameter_value tx_device_clk {EXPLICIT_CLOCK_RATE} $DEVICE_CLK_RATE

# RX JESD204 PHY-Link layer

add_instance apollo_rx_jesd204 adi_jesd204
set_instance_parameter_value apollo_rx_jesd204 {ID} {0}
set_instance_parameter_value apollo_rx_jesd204 {LINK_MODE} $ENCODER_SEL
set_instance_parameter_value apollo_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value apollo_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value apollo_rx_jesd204 {LANE_RATE} $RX_LANE_RATE
set_instance_parameter_value apollo_rx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value apollo_rx_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value apollo_rx_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value apollo_rx_jesd204 {NUM_OF_LANES} [expr $RX_NUM_OF_LANES + $RX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_rx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value apollo_rx_jesd204 {DATA_PATH_WIDTH} $RX_DATAPATH_WIDTH
set_instance_parameter_value apollo_rx_jesd204 {TPL_DATA_PATH_WIDTH} $RX_DATAPATH_WIDTH

add_instance apollo_rx_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value apollo_rx_tpl {ID} {0}
set_instance_parameter_value apollo_rx_tpl {NUM_CHANNELS} [expr $RX_NUM_OF_CONVERTERS + $RX_B_NUM_OF_CONVERTERS]
set_instance_parameter_value apollo_rx_tpl {NUM_LANES} [expr $RX_NUM_OF_LANES + $RX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_rx_tpl {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_tpl {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value apollo_rx_tpl {OCTETS_PER_BEAT} $RX_DATAPATH_WIDTH
set_instance_parameter_value apollo_rx_tpl {DMA_BITS_PER_SAMPLE} $RX_DMA_SAMPLE_WIDTH

# TX JESD204 PHY+Link

add_instance apollo_tx_jesd204 adi_jesd204
set_instance_parameter_value apollo_tx_jesd204 {ID} {0}
set_instance_parameter_value apollo_tx_jesd204 {LINK_MODE} $ENCODER_SEL
set_instance_parameter_value apollo_tx_jesd204 {TX_OR_RX_N} {1}
set_instance_parameter_value apollo_tx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value apollo_tx_jesd204 {LANE_RATE} $TX_LANE_RATE
set_instance_parameter_value apollo_tx_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value apollo_tx_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value apollo_tx_jesd204 {NUM_OF_LANES} [expr $TX_NUM_OF_LANES + $TX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_tx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value apollo_tx_jesd204 {DATA_PATH_WIDTH} $TX_DATAPATH_WIDTH
set_instance_parameter_value apollo_tx_jesd204 {TPL_DATA_PATH_WIDTH} $TX_DATAPATH_WIDTH

add_instance apollo_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value apollo_tx_tpl {ID} {0}
set_instance_parameter_value apollo_tx_tpl {NUM_CHANNELS} [expr $TX_NUM_OF_CONVERTERS + $TX_B_NUM_OF_CONVERTERS]
set_instance_parameter_value apollo_tx_tpl {NUM_LANES} [expr $TX_NUM_OF_LANES + $TX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_tpl {OCTETS_PER_BEAT} $TX_DATAPATH_WIDTH
set_instance_parameter_value apollo_tx_tpl {DMA_BITS_PER_SAMPLE} $TX_DMA_SAMPLE_WIDTH

# pack(s) & unpack(s)

add_instance apollo_tx_upack util_upack2
set_instance_parameter_value apollo_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value apollo_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value apollo_tx_upack {SAMPLE_DATA_WIDTH} $TX_DMA_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_upack {INTERFACE_TYPE} {1}
set_instance_parameter_value apollo_tx_upack {PARALLEL_OR_SERIAL_N} {1}

add_instance apollo_rx_cpack util_cpack2
set_instance_parameter_value apollo_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value apollo_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value apollo_rx_cpack {SAMPLE_DATA_WIDTH} $RX_DMA_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_cpack {PARALLEL_OR_SERIAL_N} {1}

if {$ASYMMETRIC_A_B_MODE} {
  add_instance apollo_tx_b_upack util_upack2
  set_instance_parameter_value apollo_tx_b_upack {NUM_OF_CHANNELS} $TX_B_NUM_OF_CONVERTERS
  set_instance_parameter_value apollo_tx_b_upack {SAMPLES_PER_CHANNEL} $TX_B_SAMPLES_PER_CHANNEL
  set_instance_parameter_value apollo_tx_b_upack {SAMPLE_DATA_WIDTH} $TX_B_DMA_SAMPLE_WIDTH
  set_instance_parameter_value apollo_tx_b_upack {INTERFACE_TYPE} {1}

  add_instance apollo_rx_b_cpack util_cpack2
  set_instance_parameter_value apollo_rx_b_cpack {NUM_OF_CHANNELS} $RX_B_NUM_OF_CONVERTERS
  set_instance_parameter_value apollo_rx_b_cpack {SAMPLES_PER_CHANNEL} $RX_B_SAMPLES_PER_CHANNEL
  set_instance_parameter_value apollo_rx_b_cpack {SAMPLE_DATA_WIDTH} $RX_B_DMA_SAMPLE_WIDTH
}
# RX and TX data offload buffers

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width
ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width true

if {$ASYMMETRIC_A_B_MODE} {
  ad_adcfifo_create $adc_b_fifo_name $adc_b_data_width $adc_b_dma_data_width $adc_b_fifo_address_width
  ad_dacfifo_create $dac_b_fifo_name $dac_b_data_width $dac_b_dma_data_width $dac_b_fifo_address_width false
}

# RX and TX DMA instance and connections

add_instance apollo_tx_dma axi_dmac
set_instance_parameter_value apollo_tx_dma {ID} {0}
set_instance_parameter_value apollo_tx_dma {DMA_DATA_WIDTH_SRC} $dac_dma_data_width
set_instance_parameter_value apollo_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value apollo_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value apollo_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value apollo_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value apollo_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value apollo_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value apollo_tx_dma {CYCLIC} {1}
set_instance_parameter_value apollo_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value apollo_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value apollo_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value apollo_tx_dma {HAS_AXIS_TLAST} {1}
set_instance_parameter_value apollo_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value apollo_tx_dma {MAX_BYTES_PER_BURST} {4096}

add_instance apollo_rx_dma axi_dmac
set_instance_parameter_value apollo_rx_dma {ID} {0}
set_instance_parameter_value apollo_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value apollo_rx_dma {DMA_DATA_WIDTH_DEST} $adc_dma_data_width
set_instance_parameter_value apollo_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value apollo_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value apollo_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value apollo_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value apollo_rx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value apollo_rx_dma {CYCLIC} {0}
set_instance_parameter_value apollo_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value apollo_rx_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value apollo_rx_dma {FIFO_SIZE} {16}
set_instance_parameter_value apollo_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value apollo_rx_dma {MAX_BYTES_PER_BURST} {4096}

if {$ASYMMETRIC_A_B_MODE} {
  add_instance apollo_tx_b_dma axi_dmac
  set_instance_parameter_value apollo_tx_b_dma {ID} {0}
  set_instance_parameter_value apollo_tx_b_dma {DMA_DATA_WIDTH_SRC} $dac_b_dma_data_width
  set_instance_parameter_value apollo_tx_b_dma {DMA_DATA_WIDTH_DEST} $dac_b_dma_data_width
  set_instance_parameter_value apollo_tx_b_dma {DMA_LENGTH_WIDTH} {24}
  set_instance_parameter_value apollo_tx_b_dma {DMA_2D_TRANSFER} {0}
  set_instance_parameter_value apollo_tx_b_dma {AXI_SLICE_DEST} {0}
  set_instance_parameter_value apollo_tx_b_dma {AXI_SLICE_SRC} {0}
  set_instance_parameter_value apollo_tx_b_dma {SYNC_TRANSFER_START} {0}
  set_instance_parameter_value apollo_tx_b_dma {CYCLIC} {1}
  set_instance_parameter_value apollo_tx_b_dma {DMA_TYPE_DEST} {1}
  set_instance_parameter_value apollo_tx_b_dma {DMA_TYPE_SRC} {0}
  set_instance_parameter_value apollo_tx_b_dma {FIFO_SIZE} {16}
  set_instance_parameter_value apollo_tx_b_dma {HAS_AXIS_TLAST} {1}
  set_instance_parameter_value apollo_tx_b_dma {DMA_AXI_PROTOCOL_SRC} {0}
  set_instance_parameter_value apollo_tx_b_dma {MAX_BYTES_PER_BURST} {2048}

  add_instance apollo_rx_b_dma axi_dmac
  set_instance_parameter_value apollo_rx_b_dma {ID} {0}
  set_instance_parameter_value apollo_rx_b_dma {DMA_DATA_WIDTH_SRC} $adc_b_dma_data_width
  set_instance_parameter_value apollo_rx_b_dma {DMA_DATA_WIDTH_DEST} $adc_b_dma_data_width
  set_instance_parameter_value apollo_rx_b_dma {DMA_LENGTH_WIDTH} {24}
  set_instance_parameter_value apollo_rx_b_dma {DMA_2D_TRANSFER} {0}
  set_instance_parameter_value apollo_rx_b_dma {AXI_SLICE_DEST} {0}
  set_instance_parameter_value apollo_rx_b_dma {AXI_SLICE_SRC} {0}
  set_instance_parameter_value apollo_rx_b_dma {SYNC_TRANSFER_START} {0}
  set_instance_parameter_value apollo_rx_b_dma {CYCLIC} {0}
  set_instance_parameter_value apollo_rx_b_dma {DMA_TYPE_DEST} {0}
  set_instance_parameter_value apollo_rx_b_dma {DMA_TYPE_SRC} {1}
  set_instance_parameter_value apollo_rx_b_dma {FIFO_SIZE} {16}
  set_instance_parameter_value apollo_rx_b_dma {DMA_AXI_PROTOCOL_DEST} {0}
  set_instance_parameter_value apollo_rx_b_dma {MAX_BYTES_PER_BURST} {2048}
}

# Apollo GPIO

add_instance apollo_gpio altera_avalon_pio
set_instance_parameter_value apollo_gpio {direction} {Input}
set_instance_parameter_value apollo_gpio {generateIRQ} {1}
set_instance_parameter_value apollo_gpio {width} {20}
add_connection sys_clk.clk apollo_gpio.clk
add_connection sys_clk.clk_reset apollo_gpio.reset
add_interface apollo_gpio conduit end
set_interface_property apollo_gpio EXPORT_OF apollo_gpio.external_connection

#
## clocks and resets
#

# system clock and reset

add_connection sys_clk.clk apollo_rx_jesd204.sys_clk
add_connection sys_clk.clk apollo_rx_tpl.s_axi_clock
add_connection sys_clk.clk apollo_rx_dma.s_axi_clock
add_connection sys_clk.clk apollo_tx_jesd204.sys_clk
add_connection sys_clk.clk apollo_tx_tpl.s_axi_clock
add_connection sys_clk.clk apollo_tx_dma.s_axi_clock
if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_clk.clk apollo_rx_b_dma.s_axi_clock
  add_connection sys_clk.clk apollo_tx_b_dma.s_axi_clock
}

add_connection sys_clk.clk_reset apollo_rx_jesd204.sys_resetn
add_connection sys_clk.clk_reset apollo_rx_tpl.s_axi_reset
add_connection sys_clk.clk_reset apollo_rx_dma.s_axi_reset
add_connection sys_clk.clk_reset apollo_tx_jesd204.sys_resetn
add_connection sys_clk.clk_reset apollo_tx_tpl.s_axi_reset
add_connection sys_clk.clk_reset apollo_tx_dma.s_axi_reset
if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_clk.clk_reset apollo_rx_b_dma.s_axi_reset
  add_connection sys_clk.clk_reset apollo_tx_b_dma.s_axi_reset
}

# device clock and reset

add_connection rx_device_clk.out_clk apollo_rx_jesd204.device_clk
add_connection rx_device_clk.out_clk apollo_rx_tpl.link_clk
add_connection rx_device_clk.out_clk apollo_rx_cpack.clk
add_connection rx_device_clk.out_clk $adc_fifo_name.if_adc_clk
if {$ASYMMETRIC_A_B_MODE} {
  add_connection rx_device_clk.out_clk apollo_rx_b_cpack.clk
  add_connection rx_device_clk.out_clk $adc_b_fifo_name.if_adc_clk
}

add_connection tx_device_clk.out_clk apollo_tx_jesd204.device_clk
add_connection tx_device_clk.out_clk apollo_tx_tpl.link_clk
add_connection tx_device_clk.out_clk apollo_tx_upack.clk
add_connection tx_device_clk.out_clk $dac_fifo_name.if_dac_clk
if {$ASYMMETRIC_A_B_MODE} {
  add_connection tx_device_clk.out_clk apollo_tx_b_upack.clk
  add_connection tx_device_clk.out_clk $dac_b_fifo_name.if_dac_clk
}

add_connection apollo_rx_jesd204.link_reset apollo_rx_cpack.reset
add_connection apollo_rx_jesd204.link_reset $adc_fifo_name.if_adc_rst
if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_rx_jesd204.link_reset apollo_rx_b_cpack.reset
  add_connection apollo_rx_jesd204.link_reset $adc_b_fifo_name.if_adc_rst
}

add_connection apollo_tx_jesd204.link_reset apollo_tx_upack.reset
add_connection apollo_tx_jesd204.link_reset $dac_fifo_name.if_dac_rst
if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_tx_jesd204.link_reset apollo_tx_b_upack.reset
  add_connection apollo_tx_jesd204.link_reset $dac_b_fifo_name.if_dac_rst
}

# dma clock and reset

add_connection sys_dma_clk.clk $adc_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk apollo_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk apollo_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset apollo_rx_dma.m_dest_axi_reset

if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_dma_clk.clk $adc_b_fifo_name.if_dma_clk
  add_connection sys_dma_clk.clk apollo_rx_b_dma.if_s_axis_aclk
  add_connection sys_dma_clk.clk apollo_rx_b_dma.m_dest_axi_clock

  add_connection sys_dma_clk.clk_reset apollo_rx_b_dma.m_dest_axi_reset
}

add_connection sys_dma_clk.clk $dac_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk apollo_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk apollo_tx_dma.m_src_axi_clock

if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_dma_clk.clk $dac_b_fifo_name.if_dma_clk
  add_connection sys_dma_clk.clk apollo_tx_b_dma.if_m_axis_aclk
  add_connection sys_dma_clk.clk apollo_tx_b_dma.m_src_axi_clock

  add_connection sys_dma_clk.clk_reset apollo_tx_b_dma.m_src_axi_reset
  add_connection sys_dma_clk.clk_reset $dac_b_fifo_name.if_dma_rst
}

add_connection sys_dma_clk.clk_reset apollo_tx_dma.m_src_axi_reset
add_connection sys_dma_clk.clk_reset $dac_fifo_name.if_dma_rst

#
## Exported signals
#

add_interface rx_ref_clk       clock   sink
add_interface rx_sysref        conduit end
add_interface rx_sync          conduit end
add_interface rx_serial_data   conduit end
add_interface rx_serial_data_n conduit end

add_interface tx_ref_clk       clock   sink
add_interface rx_device_clk    clock   sink
add_interface tx_serial_data   conduit end
add_interface tx_serial_data_n conduit end
add_interface tx_sysref        conduit end
add_interface tx_sync          conduit end
add_interface tx_device_clk    clock   sink
add_interface tx_fifo_bypass   conduit end
# add_interface tx_b_fifo_bypass conduit end

set_interface_property rx_ref_clk       EXPORT_OF apollo_rx_jesd204.ref_clk
set_interface_property rx_sysref        EXPORT_OF apollo_rx_jesd204.sysref
set_interface_property rx_sync          EXPORT_OF apollo_rx_jesd204.sync
set_interface_property rx_serial_data   EXPORT_OF apollo_rx_jesd204.serial_data
set_interface_property rx_serial_data_n EXPORT_OF apollo_rx_jesd204.serial_data_n
set_interface_property rx_device_clk    EXPORT_OF rx_device_clk.in_clk

set_interface_property tx_ref_clk       EXPORT_OF apollo_tx_jesd204.ref_clk
set_interface_property tx_sysref        EXPORT_OF apollo_tx_jesd204.sysref
set_interface_property tx_sync          EXPORT_OF apollo_tx_jesd204.sync
set_interface_property tx_serial_data   EXPORT_OF apollo_tx_jesd204.serial_data
set_interface_property tx_serial_data_n EXPORT_OF apollo_tx_jesd204.serial_data_n
set_interface_property tx_device_clk    EXPORT_OF tx_device_clk.in_clk
set_interface_property tx_fifo_bypass   EXPORT_OF $dac_fifo_name.if_bypass
if {$ASYMMETRIC_A_B_MODE} {
  set_interface_property tx_b_fifo_bypass EXPORT_OF $dac_b_fifo_name.if_bypass
}

#
## Data interface / data path
#

# RX link to tpl
add_connection apollo_rx_jesd204.link_sof apollo_rx_tpl.if_link_sof
add_connection apollo_rx_jesd204.link_data apollo_rx_tpl.link_data
# RX tpl to cpack (A side)
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection apollo_rx_tpl.adc_ch_$i apollo_rx_cpack.adc_ch_$i
}
add_connection apollo_rx_tpl.if_adc_dovf $adc_fifo_name.if_adc_wovf
if {$ASYMMETRIC_A_B_MODE} {
  # RX tpl to cpack (B side)
  for {set i 0} {$i < $RX_B_NUM_OF_CONVERTERS} {incr i} {
    set idx [expr $RX_NUM_OF_CONVERTERS + $i]
    add_connection apollo_rx_tpl.adc_ch_$idx apollo_rx_b_cpack.adc_ch_$i
  }
  add_connection apollo_rx_tpl.if_adc_dovf $adc_b_fifo_name.if_adc_wovf

  add_connection apollo_rx_b_cpack.if_packed_fifo_wr_en $adc_b_fifo_name.if_adc_wr
  add_connection apollo_rx_b_cpack.if_packed_fifo_wr_data $adc_b_fifo_name.if_adc_wdata
}
# RX cpack to offload
add_connection apollo_rx_cpack.if_packed_fifo_wr_en $adc_fifo_name.if_adc_wr
add_connection apollo_rx_cpack.if_packed_fifo_wr_data $adc_fifo_name.if_adc_wdata

# RX offload to dma
add_connection $adc_fifo_name.if_dma_xfer_req apollo_rx_dma.if_s_axis_xfer_req
add_connection $adc_fifo_name.m_axis apollo_rx_dma.s_axis
# RX dma to HPS
ad_dma_interconnect apollo_rx_dma.m_dest_axi

if {$ASYMMETRIC_A_B_MODE} {
  add_connection $adc_b_fifo_name.if_dma_xfer_req apollo_rx_b_dma.if_s_axis_xfer_req
  add_connection $adc_b_fifo_name.m_axis apollo_rx_b_dma.s_axis

  ad_dma_interconnect apollo_rx_b_dma.m_dest_axi
}

# TX link to tpl
add_connection apollo_tx_tpl.link_data apollo_tx_jesd204.link_data
# TX tpl to pack (A side)
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection apollo_tx_upack.dac_ch_$i apollo_tx_tpl.dac_ch_$i
}
if {$ASYMMETRIC_A_B_MODE} {
  # TX tpl to pack (B side)
  for {set i 0} {$i < $TX_B_NUM_OF_CONVERTERS} {incr i} {
    set idx [expr $TX_NUM_OF_CONVERTERS + $i]
    add_connection apollo_tx_b_upack.dac_ch_$i apollo_tx_tpl.dac_ch_$idx
  }
  add_connection apollo_tx_b_upack.if_packed_fifo_rd_en $dac_b_fifo_name.if_dac_valid
  add_connection $dac_b_fifo_name.if_dac_data apollo_tx_b_upack.if_packed_fifo_rd_data
  add_connection $dac_b_fifo_name.if_dac_dunf apollo_tx_tpl.if_dac_dunf
}
# TX pack to offload
add_connection apollo_tx_upack.if_packed_fifo_rd_en $dac_fifo_name.if_dac_valid
add_connection $dac_fifo_name.if_dac_data apollo_tx_upack.if_packed_fifo_rd_data
add_connection $dac_fifo_name.if_dac_dunf apollo_tx_tpl.if_dac_dunf

# TX offload to dma
add_connection apollo_tx_dma.if_m_axis_xfer_req $dac_fifo_name.if_dma_xfer_req
add_connection apollo_tx_dma.m_axis $dac_fifo_name.s_axis

# TX dma to HPS
ad_dma_interconnect apollo_tx_dma.m_src_axi


if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_tx_b_dma.if_m_axis_xfer_req $dac_b_fifo_name.if_dma_xfer_req
  add_connection apollo_tx_b_dma.m_axis $dac_b_fifo_name.s_axis

  ad_dma_interconnect apollo_tx_b_dma.m_src_axi
}

#
## address map
#

## NOTE: if bridge is used, the address will be bridge_base_addr + peripheral_base_addr
#

ad_cpu_interconnect 0x00000000 apollo_rx_jesd204.phy_reconfig "avl_mm_bridge_0" 0x10000000 25
ad_cpu_interconnect 0x01000000 apollo_tx_jesd204.phy_reconfig "avl_mm_bridge_0"

ad_cpu_interconnect 0x000C0000 apollo_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x000C4000 apollo_rx_jesd204.link_management
ad_cpu_interconnect 0x000C8000 apollo_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x000CC000 apollo_tx_jesd204.link_management
ad_cpu_interconnect 0x000D2000 apollo_rx_tpl.s_axi
ad_cpu_interconnect 0x000D4000 apollo_tx_tpl.s_axi
ad_cpu_interconnect 0x000D8000 apollo_rx_dma.s_axi
ad_cpu_interconnect 0x000DC000 apollo_tx_dma.s_axi
if {$ASYMMETRIC_A_B_MODE} {
ad_cpu_interconnect 0x000E0000 apollo_rx_b_dma.s_axi
ad_cpu_interconnect 0x000E4000 apollo_tx_b_dma.s_axi
}
ad_cpu_interconnect 0x000E8000 apollo_gpio.s1

#
## interrupts
#

ad_cpu_interrupt 11  apollo_rx_dma.interrupt_sender
ad_cpu_interrupt 12  apollo_tx_dma.interrupt_sender
if {$ASYMMETRIC_A_B_MODE} {
ad_cpu_interrupt 13  apollo_rx_b_dma.interrupt_sender
ad_cpu_interrupt 14  apollo_tx_b_dma.interrupt_sender
}
ad_cpu_interrupt 15  apollo_rx_jesd204.interrupt
ad_cpu_interrupt 16  apollo_tx_jesd204.interrupt
ad_cpu_interrupt 17  apollo_gpio.irq
