###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE [expr $ad_project_params(RX_LANE_RATE) * 1000]
set TX_LANE_RATE [expr $ad_project_params(TX_LANE_RATE) * 1000]

# Transceiver tile of the carrier. The default is the Agilex 7 F-Tile, where the
# PHY is embedded in the adi_jesd204 core. On the Agilex 5 E-Tile (GTS) the PHY
# is a separate core shared by the RX and TX links.
set TRANSCEIVER_TYPE [ expr { [info exists TRANSCEIVER_TYPE] \
                          ? $TRANSCEIVER_TYPE : "F-Tile" } ]
set EXTERNAL_PHY [expr {$TRANSCEIVER_TYPE == "E-Tile"} ? 1 : 0]

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
  set RX_TPL_DATAPATH_WIDTH 4
  if {$RX_JESD_NP == 12} {
    set RX_TPL_DATAPATH_WIDTH 6
  }
} else {
  set RX_DATAPATH_WIDTH 8
  set RX_TPL_DATAPATH_WIDTH 8
  if {$RX_JESD_NP == 12} {
    set RX_TPL_DATAPATH_WIDTH 12
  }
}

# The transport layer must process at least one full frame per beat, otherwise
# the samples per channel would round down to zero.
set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
if {$RX_OCTETS_PER_FRAME > $RX_TPL_DATAPATH_WIDTH} {
  set RX_TPL_DATAPATH_WIDTH $RX_OCTETS_PER_FRAME
}

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8* $RX_TPL_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

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
  set TX_TPL_DATAPATH_WIDTH 4
  if {$TX_JESD_NP == 12} {
    set TX_TPL_DATAPATH_WIDTH 6
  }
} else {
  set TX_DATAPATH_WIDTH 8
  set TX_TPL_DATAPATH_WIDTH 8
  if {$TX_JESD_NP == 12} {
    set TX_TPL_DATAPATH_WIDTH 12
  }
}

set TX_OCTETS_PER_FRAME [expr $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_FRAME * $TX_SAMPLE_WIDTH / (8 * $TX_NUM_OF_LANES)] ; # F
if {$TX_OCTETS_PER_FRAME > $TX_TPL_DATAPATH_WIDTH} {
  set TX_TPL_DATAPATH_WIDTH $TX_OCTETS_PER_FRAME
}

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8* $TX_TPL_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_data_offload_name apollo_rx_data_offload
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width

set dac_data_offload_name apollo_tx_data_offload
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width

# The DMA memory side goes through f2sdram_adapter, which tops out at 256 bits.
# The stream side keeps the offload width; the offload does the conversion.
set adc_mem_data_width [expr $adc_dma_data_width > 256 ? 256 : $adc_dma_data_width]
set dac_mem_data_width [expr $dac_dma_data_width > 256 ? 256 : $dac_dma_data_width]

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

  set adc_b_data_offload_name apollo_rx_b_data_offload
  set adc_b_data_width [expr $RX_B_DMA_SAMPLE_WIDTH*$RX_B_NUM_OF_CONVERTERS*$RX_B_SAMPLES_PER_CHANNEL]
  set adc_b_dma_data_width $adc_data_width
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

  set dac_b_data_offload_name apollo_tx_b_data_offload
  set dac_b_data_width [expr $TX_B_DMA_SAMPLE_WIDTH*$TX_B_NUM_OF_CONVERTERS*$TX_B_SAMPLES_PER_CHANNEL]
  set dac_b_dma_data_width $dac_data_width
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
set_instance_parameter_value rx_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $RX_DATAPATH_WIDTH / $RX_TPL_DATAPATH_WIDTH]

add_instance tx_device_clk altera_clock_bridge
set_instance_parameter_value tx_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $TX_DATAPATH_WIDTH / $TX_TPL_DATAPATH_WIDTH]

if {$EXTERNAL_PHY} {
  set PHY_LIST {jesd204_phy_a jesd204_phy_b}
  set NUM_OF_PHYS [llength $PHY_LIST]

  set phy_id 0
  foreach phy $PHY_LIST {
    add_instance ${phy} jesd204_e_tile_phy
    # ID keeps the composed intel_directphy_gts instance names distinct.
    set_instance_parameter_value ${phy} {ID} $phy_id
    set_instance_parameter_value ${phy} {LINK_MODE} $ENCODER_SEL
    set_instance_parameter_value ${phy} {LANE_RATE} $RX_LANE_RATE
    set_instance_parameter_value ${phy} {REFCLK_FREQUENCY} $REF_CLK_RATE
    set_instance_parameter_value ${phy} {NUM_OF_LANES} $RX_JESD_L
    set_instance_parameter_value ${phy} {INPUT_PIPELINE_STAGES} {2}
    set_instance_parameter_value ${phy} {EXTERNAL_LINK_CLK} {1}
    set_instance_parameter_value ${phy} {INSTANTIATE_RESET_CONTROLLER} {0}
    incr phy_id

    add_interface ${phy}_system_pll_clk clock sink
    set_interface_property ${phy}_system_pll_clk EXPORT_OF ${phy}.system_pll_clk

    add_interface ${phy}_system_pll_lock conduit end
    set_interface_property ${phy}_system_pll_lock EXPORT_OF ${phy}.system_pll_lock
  }

  # GTS reset sequencer
  #
  # NUM_BANKS_SHORELINE must be the exact bank count, not derived from the lane
  # count (GTS Transceiver PHY UG 817660, table 91): the lanes are split over the
  # two banks that jesd204_phy_a and jesd204_phy_b are placed in.
  add_instance gts_reset_phy intel_srcss_gts
  set_instance_parameter_value gts_reset_phy NUM_BANKS_SHORELINE 2
  set_instance_parameter_value gts_reset_phy NUM_LANES_SHORELINE $RX_NUM_OF_LANES

  set_interface_property gts_reset_src_rs_priority EXPORT_OF gts_reset_phy.i_src_rs_priority
  set_interface_property gts_reset_i_refclk_on EXPORT_OF gts_reset_phy.i_refclk_on
  set_interface_property gts_reset_o_refclk_on_ack EXPORT_OF gts_reset_phy.o_refclk_on_ack
  set_interface_property gts_reset_i_src_rs_refclk_status_bus EXPORT_OF gts_reset_phy.i_src_rs_refclk_status_bus
  set_interface_property gts_reset_o_src_rs_refclk_cmd_bus EXPORT_OF gts_reset_phy.o_src_rs_refclk_cmd_bus
  set_interface_property gts_reset_o_src_rs_grant EXPORT_OF gts_reset_phy.o_src_rs_grant
  set_interface_property gts_reset_i_src_rs_req EXPORT_OF gts_reset_phy.i_src_rs_req
  set_interface_property gts_reset_o_pma_cu_clk EXPORT_OF gts_reset_phy.o_pma_cu_clk
  set_interface_property gts_reset_o_refclk_fail_status EXPORT_OF gts_reset_phy.o_refclk_fail_status

  foreach phy {jesd204_phy_a jesd204_phy_b} {
    add_interface ${phy}_i_pma_cu_clk conduit end
    add_interface ${phy}_i_src_rs_grant conduit end
    add_interface ${phy}_o_src_rs_req conduit end
    add_interface ${phy}_i_refclk_cmd_bus_in conduit end
    add_interface ${phy}_o_refclk_status_bus_out conduit end

    set_interface_property ${phy}_i_pma_cu_clk EXPORT_OF ${phy}.i_pma_cu_clk
    set_interface_property ${phy}_i_src_rs_grant EXPORT_OF ${phy}.i_src_rs_grant
    set_interface_property ${phy}_o_src_rs_req EXPORT_OF ${phy}.o_src_rs_req
    set_interface_property ${phy}_i_refclk_cmd_bus_in EXPORT_OF ${phy}.i_refclk_cmd_bus_in
    set_interface_property ${phy}_o_refclk_status_bus_out EXPORT_OF ${phy}.o_refclk_status_bus_out
  }
}

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
set_instance_parameter_value apollo_rx_jesd204 {NUM_OF_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value apollo_rx_jesd204 {NUM_OF_LINKS} $RX_NUM_LINKS
set_instance_parameter_value apollo_rx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value apollo_rx_jesd204 {DATA_PATH_WIDTH} $RX_DATAPATH_WIDTH
set_instance_parameter_value apollo_rx_jesd204 {TPL_DATA_PATH_WIDTH} $RX_TPL_DATAPATH_WIDTH
set_instance_parameter_value apollo_rx_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
if {$EXTERNAL_PHY} {
  set_instance_parameter_value apollo_rx_jesd204 {NUM_OF_PHYS} $NUM_OF_PHYS
  set_instance_parameter_value apollo_rx_jesd204 {RESET_FSM_EN} {1}
}

add_instance apollo_rx_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value apollo_rx_tpl {ID} {0}
set_instance_parameter_value apollo_rx_tpl {NUM_CHANNELS} [expr $RX_NUM_OF_CONVERTERS + $RX_B_NUM_OF_CONVERTERS]
set_instance_parameter_value apollo_rx_tpl {NUM_LANES} [expr $RX_NUM_OF_LANES + $RX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_rx_tpl {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_tpl {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value apollo_rx_tpl {OCTETS_PER_BEAT} $RX_TPL_DATAPATH_WIDTH
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
set_instance_parameter_value apollo_tx_jesd204 {NUM_OF_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value apollo_tx_jesd204 {NUM_OF_LINKS} $TX_NUM_LINKS
set_instance_parameter_value apollo_tx_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value apollo_tx_jesd204 {DATA_PATH_WIDTH} $TX_DATAPATH_WIDTH
set_instance_parameter_value apollo_tx_jesd204 {TPL_DATA_PATH_WIDTH} $TX_TPL_DATAPATH_WIDTH
set_instance_parameter_value apollo_tx_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
if {$EXTERNAL_PHY} {
  set_instance_parameter_value apollo_tx_jesd204 {NUM_OF_PHYS} $NUM_OF_PHYS
  set_instance_parameter_value apollo_tx_jesd204 {RESET_FSM_EN} {1}
}

add_instance apollo_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value apollo_tx_tpl {ID} {0}
set_instance_parameter_value apollo_tx_tpl {NUM_CHANNELS} [expr $TX_NUM_OF_CONVERTERS + $TX_B_NUM_OF_CONVERTERS]
set_instance_parameter_value apollo_tx_tpl {NUM_LANES} [expr $TX_NUM_OF_LANES + $TX_B_NUM_OF_LANES]
set_instance_parameter_value apollo_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_tpl {OCTETS_PER_BEAT} $TX_TPL_DATAPATH_WIDTH
set_instance_parameter_value apollo_tx_tpl {DMA_BITS_PER_SAMPLE} $TX_DMA_SAMPLE_WIDTH

# pack(s) & unpack(s)

add_instance apollo_tx_upack util_upack2
set_instance_parameter_value apollo_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value apollo_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value apollo_tx_upack {SAMPLE_DATA_WIDTH} $TX_DMA_SAMPLE_WIDTH
set_instance_parameter_value apollo_tx_upack {INTERFACE_TYPE} {0}
set_instance_parameter_value apollo_tx_upack {PARALLEL_OR_SERIAL_N} {0}

add_instance apollo_rx_cpack util_cpack2
set_instance_parameter_value apollo_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value apollo_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value apollo_rx_cpack {SAMPLE_DATA_WIDTH} $RX_DMA_SAMPLE_WIDTH
set_instance_parameter_value apollo_rx_cpack {INTERFACE_TYPE} {1}
set_instance_parameter_value apollo_rx_cpack {PARALLEL_OR_SERIAL_N} {0}

if {$ASYMMETRIC_A_B_MODE} {
  add_instance apollo_tx_b_upack util_upack2
  set_instance_parameter_value apollo_tx_b_upack {NUM_OF_CHANNELS} $TX_B_NUM_OF_CONVERTERS
  set_instance_parameter_value apollo_tx_b_upack {SAMPLES_PER_CHANNEL} $TX_B_SAMPLES_PER_CHANNEL
  set_instance_parameter_value apollo_tx_b_upack {SAMPLE_DATA_WIDTH} $TX_B_DMA_SAMPLE_WIDTH
  set_instance_parameter_value apollo_tx_b_upack {INTERFACE_TYPE} {0}
  set_instance_parameter_value apollo_tx_b_upack {PARALLEL_OR_SERIAL_N} {0}

  add_instance apollo_rx_b_cpack util_cpack2
  set_instance_parameter_value apollo_rx_b_cpack {NUM_OF_CHANNELS} $RX_B_NUM_OF_CONVERTERS
  set_instance_parameter_value apollo_rx_b_cpack {SAMPLES_PER_CHANNEL} $RX_B_SAMPLES_PER_CHANNEL
  set_instance_parameter_value apollo_rx_b_cpack {SAMPLE_DATA_WIDTH} $RX_B_DMA_SAMPLE_WIDTH
  set_instance_parameter_value apollo_rx_b_cpack {INTERFACE_TYPE} {1}
  set_instance_parameter_value apollo_rx_b_cpack {PARALLEL_OR_SERIAL_N} {0}
}
# RX and TX data offload buffers
#
# MEM_SIZE is in bytes and only accepts powers of two (adi_data_offload_hw.tcl),
# so the per-converter sample budget the project asks for is rounded up.

proc ad9084_offload_size {samples_per_converter num_of_converters sample_width} {
  set bytes [expr $samples_per_converter * $num_of_converters * $sample_width / 8]
  return [expr 1 << int(ceil(log($bytes) / log(2)))]
}

proc ad9084_offload_create {name datapath_type mem_size src_dwidth dst_dwidth} {
  add_instance $name adi_data_offload
  set_instance_parameter_value $name {INSTANCE_NAME} $name
  set_instance_parameter_value $name {DATAPATH_TYPE} $datapath_type
  # RX source is util_cpack2 in FIFO mode; TX source is the DMA on AXIS.
  set_instance_parameter_value $name {SRC_INTERFACE_TYPE} [expr {$datapath_type == 0}]
  set_instance_parameter_value $name {SRC_HAS_AXIS_TKEEP} {0}
  set_instance_parameter_value $name {SRC_HAS_AXIS_TLAST} {0}
  set_instance_parameter_value $name {MEM_TYPE} {0}
  set_instance_parameter_value $name {MEM_SIZE} $mem_size
  set_instance_parameter_value $name {SOURCE_DWIDTH} $src_dwidth
  set_instance_parameter_value $name {DESTINATION_DWIDTH} $dst_dwidth

  # Qsys has no GND node, so sync_ext cannot be tied off here the way the Xilinx
  # projects do (ad9084_ebz_bd.tcl "ad_connect GND .../sync_ext"). Export it and
  # let system_top.v drive it; left unconnected it generates as
  # ".sync_ext_sync_ext ()" and takes whatever value synthesis resolves an
  # undriven input to.
  add_interface ${name}_sync_ext conduit end
  set_interface_property ${name}_sync_ext EXPORT_OF ${name}.sync_ext
}

set adc_data_offload_size [ad9084_offload_size $adc_fifo_samples_per_converter \
                             $RX_NUM_OF_CONVERTERS $RX_DMA_SAMPLE_WIDTH]
set dac_data_offload_size [ad9084_offload_size $dac_fifo_samples_per_converter \
                             $TX_NUM_OF_CONVERTERS $TX_DMA_SAMPLE_WIDTH]

ad9084_offload_create $adc_data_offload_name 0 $adc_data_offload_size \
                      $adc_data_width $adc_dma_data_width
ad9084_offload_create $dac_data_offload_name 1 $dac_data_offload_size \
                      $dac_dma_data_width $dac_data_width

if {$ASYMMETRIC_A_B_MODE} {
  set adc_b_data_offload_size [ad9084_offload_size $adc_b_fifo_samples_per_converter \
                                 $RX_B_NUM_OF_CONVERTERS $RX_B_DMA_SAMPLE_WIDTH]
  set dac_b_data_offload_size [ad9084_offload_size $dac_b_fifo_samples_per_converter \
                                 $TX_B_NUM_OF_CONVERTERS $TX_B_DMA_SAMPLE_WIDTH]

  ad9084_offload_create $adc_b_data_offload_name 0 $adc_b_data_offload_size \
                        $adc_b_data_width $adc_b_dma_data_width
  ad9084_offload_create $dac_b_data_offload_name 1 $dac_b_data_offload_size \
                        $dac_b_dma_data_width $dac_b_data_width
}

# RX and TX DMA instance and connections

add_instance apollo_tx_dma axi_dmac
set_instance_parameter_value apollo_tx_dma {ID} {0}
set_instance_parameter_value apollo_tx_dma {DMA_DATA_WIDTH_SRC} $dac_mem_data_width
set_instance_parameter_value apollo_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value apollo_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value apollo_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value apollo_tx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value apollo_tx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value apollo_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value apollo_tx_dma {CYCLIC} {1}
set_instance_parameter_value apollo_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value apollo_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value apollo_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value apollo_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value apollo_tx_dma {MAX_BYTES_PER_BURST} {2048}

add_instance apollo_rx_dma axi_dmac
set_instance_parameter_value apollo_rx_dma {ID} {0}
set_instance_parameter_value apollo_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value apollo_rx_dma {DMA_DATA_WIDTH_DEST} $adc_mem_data_width
set_instance_parameter_value apollo_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value apollo_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value apollo_rx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value apollo_rx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value apollo_rx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value apollo_rx_dma {CYCLIC} {0}
set_instance_parameter_value apollo_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value apollo_rx_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value apollo_rx_dma {FIFO_SIZE} {16}
set_instance_parameter_value apollo_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value apollo_rx_dma {MAX_BYTES_PER_BURST} {2048}

if {$ASYMMETRIC_A_B_MODE} {
  add_instance apollo_tx_b_dma axi_dmac
  set_instance_parameter_value apollo_tx_b_dma {ID} {0}
  set_instance_parameter_value apollo_tx_b_dma {DMA_DATA_WIDTH_SRC} [expr $dac_b_dma_data_width > 256 ? 256 : $dac_b_dma_data_width]
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
  set_instance_parameter_value apollo_tx_b_dma {DMA_AXI_PROTOCOL_SRC} {0}
  set_instance_parameter_value apollo_tx_b_dma {MAX_BYTES_PER_BURST} {2048}

  add_instance apollo_rx_b_dma axi_dmac
  set_instance_parameter_value apollo_rx_b_dma {ID} {0}
  set_instance_parameter_value apollo_rx_b_dma {DMA_DATA_WIDTH_SRC} $adc_b_dma_data_width
  set_instance_parameter_value apollo_rx_b_dma {DMA_DATA_WIDTH_DEST} [expr $adc_b_dma_data_width > 256 ? 256 : $adc_b_dma_data_width]
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
if {$EXTERNAL_PHY} {
  add_connection jesd204_phy_a.rx_clkout jesd204_phy_a.rx_link_clock
  add_connection jesd204_phy_a.rx_clkout jesd204_phy_b.rx_link_clock
  add_connection jesd204_phy_a.rx_clkout apollo_rx_jesd204.phy_link_clk
}
add_connection rx_device_clk.out_clk apollo_rx_cpack.clk
add_connection rx_device_clk.out_clk $adc_data_offload_name.s_axis_aclk
if {$ASYMMETRIC_A_B_MODE} {
  add_connection rx_device_clk.out_clk apollo_rx_b_cpack.clk
  add_connection rx_device_clk.out_clk $adc_b_data_offload_name.s_axis_aclk
}

add_connection tx_device_clk.out_clk apollo_tx_jesd204.device_clk
add_connection tx_device_clk.out_clk apollo_tx_tpl.link_clk
if {$EXTERNAL_PHY} {
  add_connection jesd204_phy_a.tx_clkout jesd204_phy_a.tx_link_clock
  add_connection jesd204_phy_a.tx_clkout jesd204_phy_b.tx_link_clock
  add_connection jesd204_phy_a.tx_clkout apollo_tx_jesd204.phy_link_clk
}
add_connection tx_device_clk.out_clk apollo_tx_upack.clk
add_connection tx_device_clk.out_clk $dac_data_offload_name.m_axis_aclk
if {$ASYMMETRIC_A_B_MODE} {
  add_connection tx_device_clk.out_clk apollo_tx_b_upack.clk
  add_connection tx_device_clk.out_clk $dac_b_data_offload_name.m_axis_aclk
}

add_connection apollo_rx_jesd204.link_reset apollo_rx_cpack.reset
add_connection apollo_rx_jesd204.link_reset $adc_data_offload_name.s_axis_aresetn
if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_rx_jesd204.link_reset apollo_rx_b_cpack.reset
  add_connection apollo_rx_jesd204.link_reset $adc_b_data_offload_name.s_axis_aresetn
}

add_connection apollo_tx_jesd204.link_reset apollo_tx_upack.reset
add_connection apollo_tx_jesd204.link_reset $dac_data_offload_name.m_axis_aresetn
if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_tx_jesd204.link_reset apollo_tx_b_upack.reset
  add_connection apollo_tx_jesd204.link_reset $dac_b_data_offload_name.m_axis_aresetn
}

# dma clock and reset

add_connection sys_clk.clk $adc_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $adc_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $adc_data_offload_name.m_axis_aclk
add_connection sys_dma_clk.clk_reset $adc_data_offload_name.m_axis_aresetn
add_connection sys_dma_clk.clk apollo_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk apollo_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset apollo_rx_dma.m_dest_axi_reset

if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_clk.clk $adc_b_data_offload_name.sys_clk
  add_connection sys_clk.clk_reset $adc_b_data_offload_name.sys_resetn
  add_connection sys_dma_clk.clk $adc_b_data_offload_name.m_axis_aclk
  add_connection sys_dma_clk.clk_reset $adc_b_data_offload_name.m_axis_aresetn
  add_connection sys_dma_clk.clk apollo_rx_b_dma.if_s_axis_aclk
  add_connection sys_dma_clk.clk apollo_rx_b_dma.m_dest_axi_clock

  add_connection sys_dma_clk.clk_reset apollo_rx_b_dma.m_dest_axi_reset
}

add_connection sys_clk.clk $dac_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $dac_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $dac_data_offload_name.s_axis_aclk
add_connection sys_dma_clk.clk_reset $dac_data_offload_name.s_axis_aresetn
add_connection sys_dma_clk.clk apollo_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk apollo_tx_dma.m_src_axi_clock

if {$ASYMMETRIC_A_B_MODE} {
  add_connection sys_clk.clk $dac_b_data_offload_name.sys_clk
  add_connection sys_clk.clk_reset $dac_b_data_offload_name.sys_resetn
  add_connection sys_dma_clk.clk $dac_b_data_offload_name.s_axis_aclk
  add_connection sys_dma_clk.clk_reset $dac_b_data_offload_name.s_axis_aresetn
  add_connection sys_dma_clk.clk apollo_tx_b_dma.if_m_axis_aclk
  add_connection sys_dma_clk.clk apollo_tx_b_dma.m_src_axi_clock

  add_connection sys_dma_clk.clk_reset apollo_tx_b_dma.m_src_axi_reset
}

add_connection sys_dma_clk.clk_reset apollo_tx_dma.m_src_axi_reset

#
## Exported signals
#

add_interface rx_ref_clk_a       clock   sink
add_interface rx_ref_clk_b       clock   sink
add_interface rx_sysref          conduit end
add_interface rx_sync            conduit end
add_interface rx_serial_data_a   conduit end
add_interface rx_serial_data_a_n conduit end
add_interface rx_serial_data_b   conduit end
add_interface rx_serial_data_b_n conduit end

add_interface tx_ref_clk_a       clock   sink
add_interface tx_ref_clk_b       clock   sink
add_interface rx_device_clk      clock   sink
add_interface tx_serial_data_a   conduit end
add_interface tx_serial_data_a_n conduit end
add_interface tx_serial_data_b   conduit end
add_interface tx_serial_data_b_n conduit end
add_interface tx_sysref          conduit end
add_interface tx_sync            conduit end
add_interface tx_device_clk      clock   sink

set_interface_property rx_sysref        EXPORT_OF apollo_rx_jesd204.sysref
set_interface_property rx_sync          EXPORT_OF apollo_rx_jesd204.sync
set_interface_property rx_device_clk    EXPORT_OF rx_device_clk.in_clk

set_interface_property tx_sysref        EXPORT_OF apollo_tx_jesd204.sysref
set_interface_property tx_sync          EXPORT_OF apollo_tx_jesd204.sync
set_interface_property tx_device_clk    EXPORT_OF tx_device_clk.in_clk

if {!$EXTERNAL_PHY} {
  set_interface_property rx_ref_clk       EXPORT_OF apollo_rx_jesd204.ref_clk
  set_interface_property rx_serial_data   EXPORT_OF apollo_rx_jesd204.serial_data
  set_interface_property rx_serial_data_n EXPORT_OF apollo_rx_jesd204.serial_data_n
  set_interface_property tx_ref_clk       EXPORT_OF apollo_tx_jesd204.ref_clk
  set_interface_property tx_serial_data   EXPORT_OF apollo_tx_jesd204.serial_data
  set_interface_property tx_serial_data_n EXPORT_OF apollo_tx_jesd204.serial_data_n
} else {
  # The external PHY owns the serial data and reference clock pins, and the link
  # layer cores drive its reset/ready handshake.
  set_interface_property rx_ref_clk_a         EXPORT_OF jesd204_phy_a.rx_ref_clk
  set_interface_property rx_ref_clk_b         EXPORT_OF jesd204_phy_b.rx_ref_clk
  set_interface_property rx_serial_data_a     EXPORT_OF jesd204_phy_a.rx_serial_data
  set_interface_property rx_serial_data_a_n   EXPORT_OF jesd204_phy_a.rx_serial_data_n
  set_interface_property rx_serial_data_b     EXPORT_OF jesd204_phy_b.rx_serial_data
  set_interface_property rx_serial_data_b_n   EXPORT_OF jesd204_phy_b.rx_serial_data_n
  set_interface_property tx_ref_clk_a         EXPORT_OF jesd204_phy_a.tx_ref_clk
  set_interface_property tx_ref_clk_b         EXPORT_OF jesd204_phy_b.tx_ref_clk
  set_interface_property tx_serial_data_a     EXPORT_OF jesd204_phy_a.tx_serial_data
  set_interface_property tx_serial_data_a_n   EXPORT_OF jesd204_phy_a.tx_serial_data_n
  set_interface_property tx_serial_data_b     EXPORT_OF jesd204_phy_b.tx_serial_data
  set_interface_property tx_serial_data_b_n   EXPORT_OF jesd204_phy_b.tx_serial_data_n

  add_connection apollo_tx_jesd204.if_up_rst jesd204_phy_a.tx_link_reset
  add_connection apollo_tx_jesd204.if_up_rst jesd204_phy_b.tx_link_reset

  # axi_adxcvr inside the link core runs one reset sequencer per PHY and reports
  # the link ready only once every PHY is, so the handshake never leaves the
  # subsystem. Only the per-PHY status goes out, for the debug GPIOs.
  set phy_idx 0
  foreach phy $PHY_LIST {
    add_connection apollo_tx_jesd204.reset_${phy_idx} ${phy}.tx_reset
    add_connection ${phy}.tx_ready apollo_tx_jesd204.ready_${phy_idx}
    add_connection ${phy}.tx_reset_ack apollo_tx_jesd204.reset_ack_${phy_idx}
    incr phy_idx
  }

  add_interface tx_phy_status conduit end
  set_interface_property tx_phy_status EXPORT_OF apollo_tx_jesd204.phy_status

  # Exported separately so TX_L may be smaller than RX_L - the PHY is sized for
  # the RX lane count, so Quartus would complain about a width mismatch.
  add_interface phy_a_tx_pll_locked conduit end
  set_interface_property phy_a_tx_pll_locked EXPORT_OF jesd204_phy_a.tx_pll_locked

  add_interface phy_b_tx_pll_locked conduit end
  set_interface_property phy_b_tx_pll_locked EXPORT_OF jesd204_phy_b.tx_pll_locked

  add_interface tx_pll_locked conduit end
  set_interface_property tx_pll_locked EXPORT_OF apollo_tx_jesd204.tx_pll_locked

  for {set i 0} {$i < [expr $TX_NUM_OF_LANES / 2]} {incr i} {
    add_connection apollo_tx_jesd204.tx_phy${i} jesd204_phy_a.phy_tx_${i}
  }

  for {set i [expr $TX_NUM_OF_LANES / 2]} {$i < $TX_NUM_OF_LANES} {incr i} {
    set idx [expr $i - ${TX_NUM_OF_LANES} / 2]
    add_connection apollo_tx_jesd204.tx_phy${i} jesd204_phy_b.phy_tx_${idx}
  }

  add_connection apollo_rx_jesd204.if_up_rst jesd204_phy_a.rx_link_reset
  add_connection apollo_rx_jesd204.if_up_rst jesd204_phy_b.rx_link_reset

  set phy_idx 0
  foreach phy $PHY_LIST {
    add_connection apollo_rx_jesd204.reset_${phy_idx} ${phy}.rx_reset
    add_connection ${phy}.rx_ready apollo_rx_jesd204.ready_${phy_idx}
    add_connection ${phy}.rx_reset_ack apollo_rx_jesd204.reset_ack_${phy_idx}
    incr phy_idx
  }

  add_interface rx_phy_status conduit end
  set_interface_property rx_phy_status EXPORT_OF apollo_rx_jesd204.phy_status

  # rx_is_lockedtodata stays a top-level concat: it is one bit per lane, and the
  # link core sizes it from the RX lane count while each PHY only carries half.
  add_interface jesd204_phy_a_rx_is_lockedtodata conduit end
  add_interface jesd204_phy_b_rx_is_lockedtodata conduit end
  add_interface apollo_rx_jesd204_rx_is_lockedtodata conduit end

  set_interface_property jesd204_phy_a_rx_is_lockedtodata EXPORT_OF jesd204_phy_a.rx_is_lockedtodata
  set_interface_property jesd204_phy_b_rx_is_lockedtodata EXPORT_OF jesd204_phy_b.rx_is_lockedtodata
  set_interface_property apollo_rx_jesd204_rx_is_lockedtodata EXPORT_OF apollo_rx_jesd204.rx_is_lockedtodata

  for {set i 0} {$i < [expr $RX_NUM_OF_LANES / 2]} {incr i} {
    add_connection jesd204_phy_a.phy_rx_${i} apollo_rx_jesd204.rx_phy${i}
  }

  for {set i [expr $RX_NUM_OF_LANES / 2]} {$i < $RX_NUM_OF_LANES} {incr i} {
    set idx [expr $i - $RX_NUM_OF_LANES / 2]
    add_connection jesd204_phy_b.phy_rx_${idx} apollo_rx_jesd204.rx_phy${i}
  }
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
add_connection apollo_rx_tpl.if_adc_dovf apollo_rx_cpack.if_fifo_wr_overflow
if {$ASYMMETRIC_A_B_MODE} {
  # RX tpl to cpack (B side)
  for {set i 0} {$i < $RX_B_NUM_OF_CONVERTERS} {incr i} {
    set idx [expr $RX_NUM_OF_CONVERTERS + $i]
    add_connection apollo_rx_tpl.adc_ch_$idx apollo_rx_b_cpack.adc_ch_$i
  }
  add_connection apollo_rx_tpl.if_adc_dovf apollo_rx_b_cpack.if_fifo_wr_overflow

  add_connection apollo_rx_b_cpack.if_packed_fifo_wr_en $adc_b_data_offload_name.if_src_fifo_wr_en
  add_connection apollo_rx_b_cpack.if_packed_fifo_wr_data $adc_b_data_offload_name.if_src_fifo_wr_data
}
# RX cpack to offload
add_connection apollo_rx_cpack.if_packed_fifo_wr_en $adc_data_offload_name.if_src_fifo_wr_en
add_connection apollo_rx_cpack.if_packed_fifo_wr_data $adc_data_offload_name.if_src_fifo_wr_data

# RX offload to dma
add_connection $adc_data_offload_name.m_axis apollo_rx_dma.s_axis
add_connection apollo_rx_dma.if_s_axis_xfer_req $adc_data_offload_name.init_req
# RX dma to HPS
if {$EXTERNAL_PHY} {
  ad_dma_interconnect apollo_rx_dma.m_dest_axi 0x0000000 $adc_mem_data_width
} else {
  ad_dma_interconnect apollo_rx_dma.m_dest_axi
}

if {$ASYMMETRIC_A_B_MODE} {
  add_connection $adc_b_data_offload_name.m_axis apollo_rx_b_dma.s_axis
  add_connection apollo_rx_b_dma.if_s_axis_xfer_req $adc_b_data_offload_name.init_req

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
  add_connection $dac_b_data_offload_name.m_axis apollo_tx_b_upack.s_axis
  add_connection apollo_tx_tpl.if_dac_dunf apollo_tx_b_upack.if_fifo_rd_underflow
}
# TX pack to offload
add_connection $dac_data_offload_name.m_axis apollo_tx_upack.s_axis
add_connection apollo_tx_tpl.if_dac_dunf apollo_tx_upack.if_fifo_rd_underflow

# TX offload to dma
add_connection apollo_tx_dma.m_axis $dac_data_offload_name.s_axis
add_connection apollo_tx_dma.if_m_axis_xfer_req $dac_data_offload_name.init_req

# TX dma to HPS
if {$EXTERNAL_PHY} {
  ad_dma_interconnect apollo_tx_dma.m_src_axi 0x0000000 $dac_mem_data_width
} else {
  ad_dma_interconnect apollo_tx_dma.m_src_axi
}


if {$ASYMMETRIC_A_B_MODE} {
  add_connection apollo_tx_b_dma.m_axis $dac_b_data_offload_name.s_axis
  add_connection apollo_tx_b_dma.if_m_axis_xfer_req $dac_b_data_offload_name.init_req

  ad_dma_interconnect apollo_tx_b_dma.m_src_axi
}

#
## address map
#

## NOTE: if bridge is used, the address will be bridge_base_addr + peripheral_base_addr
#

if {!$EXTERNAL_PHY} {
  ad_cpu_interconnect 0x00000000 apollo_rx_jesd204.phy_reconfig "avl_mm_bridge_0" 0x10000000 25
  ad_cpu_interconnect 0x01000000 apollo_tx_jesd204.phy_reconfig "avl_mm_bridge_0"
} else {
  # One bridge for rx_adxcvr, the other for tx_adxcvr
  ad_cpu_interconnect 0x00000000 jesd204_phy_a.reconfig_avmm "avl_mm_bridge_0" 0x01000000 22
  ad_cpu_interconnect 0x00000000 jesd204_phy_b.reconfig_avmm "avl_mm_bridge_1" 0x02000000 22
  set_instance_parameter_value avl_mm_bridge_0 {MAX_PENDING_RESPONSES} {1}
  add_connection sys_clk.clk jesd204_phy_a.reconfig_clk
  add_connection sys_clk.clk_reset jesd204_phy_a.reconfig_reset
  add_connection sys_clk.clk jesd204_phy_b.reconfig_clk
  add_connection sys_clk.clk_reset jesd204_phy_b.reconfig_reset
}

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
ad_cpu_interconnect 0x00120000 $adc_b_data_offload_name.s_axi
ad_cpu_interconnect 0x00130000 $dac_b_data_offload_name.s_axi
}
ad_cpu_interconnect 0x000E8000 apollo_gpio.s1

# data_offload s_axi spans 64 kB (16-bit address), so it cannot sit in the 8 kB
# grid the rest of the peripherals use.
ad_cpu_interconnect 0x00100000 $adc_data_offload_name.s_axi
ad_cpu_interconnect 0x00110000 $dac_data_offload_name.s_axi

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
