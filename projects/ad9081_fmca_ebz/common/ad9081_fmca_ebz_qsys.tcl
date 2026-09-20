###############################################################################
## Copyright (C) 2021-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set JESD_MODE [ expr { [info exists ad_project_params(JESD_MODE)] \
                          ? $ad_project_params(JESD_MODE) : "8B10B" } ]
set LINK_MODE [expr {$JESD_MODE == "8B10B"} ? 1 : 2]

set DDS_DISABLED [ expr { [info exists ad_project_params(DDS_DISABLED)] \
                          ? $ad_project_params(DDS_DISABLED) : 0 } ]

set DDS_DUAL_TONE [ expr { [info exists ad_project_params(DDS_DUAL_TONE)] \
                          ? $ad_project_params(DDS_DUAL_TONE) : 1 } ]

set EXTERNAL_PHY [expr {$TRANSCEIVER_TYPE == "E-Tile"} ? 1 : 0]

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

set RX_OCTETS_PER_FRAME    [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
if {$RX_OCTETS_PER_FRAME > $RX_TPL_DATA_PATH_WIDTH} {
  set RX_TPL_DATA_PATH_WIDTH $RX_OCTETS_PER_FRAME
}

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$RX_TPL_DATA_PATH_WIDTH / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]


# RX OS parameters
set RX_OS_NUM_OF_LINKS $ad_project_params(RX_OS_NUM_LINKS)

# RX OS JESD parameter per link
set RX_OS_JESD_M     $ad_project_params(RX_OS_JESD_M)
set RX_OS_JESD_L     $ad_project_params(RX_OS_JESD_L)
set RX_OS_JESD_S     $ad_project_params(RX_OS_JESD_S)
set RX_OS_JESD_NP    $ad_project_params(RX_OS_JESD_NP)

if {$JESD_MODE == "8B10B"} {
  set RX_OS_DATA_PATH_WIDTH 4
  set RX_OS_TPL_DATA_PATH_WIDTH 4
  if {$RX_OS_JESD_NP==12} {
    set RX_OS_TPL_DATA_PATH_WIDTH 6
  }
} else {
  set RX_OS_DATA_PATH_WIDTH 8
  set RX_OS_TPL_DATA_PATH_WIDTH 8
  if {$RX_OS_JESD_NP==12} {
    set RX_OS_TPL_DATA_PATH_WIDTH 12
  }
}

set RX_OS_NUM_OF_LANES      [expr $RX_OS_JESD_L * $RX_OS_NUM_OF_LINKS]
set RX_OS_NUM_OF_CONVERTERS [expr $RX_OS_JESD_M * $RX_OS_NUM_OF_LINKS]
set RX_OS_SAMPLES_PER_FRAME $RX_OS_JESD_S
set RX_OS_SAMPLE_WIDTH      $RX_OS_JESD_NP
set RX_OS_DMA_SAMPLE_WIDTH  16

set RX_OS_OCTETS_PER_FRAME    [expr $RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLES_PER_FRAME * $RX_OS_SAMPLE_WIDTH / (8 * $RX_OS_NUM_OF_LANES)] ; # F
if {$RX_OS_OCTETS_PER_FRAME > $RX_OS_TPL_DATA_PATH_WIDTH} {
  set RX_OS_TPL_DATA_PATH_WIDTH $RX_OS_OCTETS_PER_FRAME
}

set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 8*$RX_OS_TPL_DATA_PATH_WIDTH / \
                                ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)]

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

set TX_OCTETS_PER_FRAME    [expr $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_FRAME * $TX_SAMPLE_WIDTH / (8 * $TX_NUM_OF_LANES)] ; # F
if {$TX_OCTETS_PER_FRAME > $TX_TPL_DATA_PATH_WIDTH} {
  set TX_TPL_DATA_PATH_WIDTH $TX_OCTETS_PER_FRAME
}

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

set adc_os_data_offload_name mxfe_rx_os_data_offload
set adc_os_data_width [expr 8*$RX_OS_TPL_DATA_PATH_WIDTH*$RX_OS_NUM_OF_LANES*$RX_OS_DMA_SAMPLE_WIDTH/$RX_OS_SAMPLE_WIDTH]
set adc_os_dma_data_width $adc_os_data_width

set dac_data_offload_name mxfe_tx_data_offload
set dac_data_width [expr 8*$TX_TPL_DATA_PATH_WIDTH*$TX_NUM_OF_LANES*$TX_DMA_SAMPLE_WIDTH/$TX_SAMPLE_WIDTH]
set dac_dma_data_width $dac_data_width

if {$EXTERNAL_PHY && $RX_NUM_OF_LANES < $TX_NUM_OF_LANES} {
  send_message error "In duplex mode RX_NUM_OF_LANES >= TX_NUM_OF_LANES!"
}

# JESD204 clock bridges

add_instance tx_device_clk altera_clock_bridge
set_instance_parameter_value tx_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $TX_DATA_PATH_WIDTH / $TX_TPL_DATA_PATH_WIDTH]

add_instance rx_device_clk altera_clock_bridge
set_instance_parameter_value rx_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $RX_DATA_PATH_WIDTH / $RX_TPL_DATA_PATH_WIDTH]

add_instance rx_os_device_clk altera_clock_bridge
set_instance_parameter_value rx_os_device_clk {EXPLICIT_CLOCK_RATE} [expr $DEVICE_CLK_RATE * $RX_OS_DATA_PATH_WIDTH / $RX_OS_TPL_DATA_PATH_WIDTH ]

#
## IP instantions and configuration
#

if {$EXTERNAL_PHY} {
  # The RX and the RX OS path each get their own transceiver IP, with the lanes
  # of both in the same shoreline bank.
  set PHY_LIST {jesd204_phy jesd204_phy_os}
  set PHY_NUM_OF_LANES [list $RX_NUM_OF_LANES $RX_OS_NUM_OF_LANES]

  set phy_id 0
  foreach phy $PHY_LIST {
    add_instance ${phy} jesd204_e_tile_phy
    # ID keeps the composed intel_directphy_gts instance names distinct.
    set_instance_parameter_value ${phy} {ID} $phy_id
    set_instance_parameter_value ${phy} {LINK_MODE} $LINK_MODE
    set_instance_parameter_value ${phy} {LANE_RATE} $RX_LANE_RATE
    set_instance_parameter_value ${phy} {REFCLK_FREQUENCY} $REF_CLK_RATE
    set_instance_parameter_value ${phy} {NUM_OF_LANES} [lindex $PHY_NUM_OF_LANES $phy_id]
    set_instance_parameter_value ${phy} {INPUT_PIPELINE_STAGES} {2}
    set_instance_parameter_value ${phy} {EXTERNAL_LINK_CLK} {1}
    set_instance_parameter_value ${phy} {INSTANTIATE_RESET_CONTROLLER} {0}
    incr phy_id
  }

  add_interface system_pll_clk clock sink
  set_interface_property system_pll_clk EXPORT_OF jesd204_phy.system_pll_clk

  add_interface system_pll_lock conduit end
  set_interface_property system_pll_lock EXPORT_OF jesd204_phy.system_pll_lock

  add_interface system_pll_clk_os clock sink
  set_interface_property system_pll_clk_os EXPORT_OF jesd204_phy_os.system_pll_clk

  add_interface system_pll_lock_os conduit end
  set_interface_property system_pll_lock_os EXPORT_OF jesd204_phy_os.system_pll_lock

  # GTS reset IP
  add_instance gts_reset_phy intel_srcss_gts
  set_instance_parameter_value gts_reset_phy NUM_BANKS_SHORELINE [expr int(ceil(($RX_NUM_OF_LANES + $RX_OS_NUM_OF_LANES) / 4.0))]
  set_instance_parameter_value gts_reset_phy NUM_LANES_SHORELINE [expr $RX_NUM_OF_LANES + $RX_OS_NUM_OF_LANES]

  set_interface_property gts_reset_src_rs_priority EXPORT_OF gts_reset_phy.i_src_rs_priority
  set_interface_property gts_reset_i_refclk_on EXPORT_OF gts_reset_phy.i_refclk_on
  set_interface_property gts_reset_o_refclk_on_ack EXPORT_OF gts_reset_phy.o_refclk_on_ack
  set_interface_property gts_reset_i_src_rs_refclk_status_bus EXPORT_OF gts_reset_phy.i_src_rs_refclk_status_bus
  set_interface_property gts_reset_o_src_rs_refclk_cmd_bus EXPORT_OF gts_reset_phy.o_src_rs_refclk_cmd_bus
  set_interface_property gts_reset_o_src_rs_grant EXPORT_OF gts_reset_phy.o_src_rs_grant
  set_interface_property gts_reset_i_src_rs_req EXPORT_OF gts_reset_phy.i_src_rs_req
  set_interface_property gts_reset_o_pma_cu_clk EXPORT_OF gts_reset_phy.o_pma_cu_clk
  set_interface_property gts_reset_o_refclk_fail_status EXPORT_OF gts_reset_phy.o_refclk_fail_status

  foreach phy $PHY_LIST {
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
set_instance_parameter_value mxfe_rx_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
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

# RX OS JESD204 PHY-Link layer

add_instance mxfe_rx_os_jesd204 adi_jesd204
set_instance_parameter_value mxfe_rx_os_jesd204 {ID} {0}
set_instance_parameter_value mxfe_rx_os_jesd204 {LINK_MODE} $LINK_MODE
set_instance_parameter_value mxfe_rx_os_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value mxfe_rx_os_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value mxfe_rx_os_jesd204 {LANE_RATE} $RX_LANE_RATE
set_instance_parameter_value mxfe_rx_os_jesd204 {SYSCLK_FREQUENCY} {100.0}
set_instance_parameter_value mxfe_rx_os_jesd204 {REFCLK_FREQUENCY} $REF_CLK_RATE
set_instance_parameter_value mxfe_rx_os_jesd204 {INPUT_PIPELINE_STAGES} {2}
set_instance_parameter_value mxfe_rx_os_jesd204 {NUM_OF_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value mxfe_rx_os_jesd204 {EXT_DEVICE_CLK_EN} {1}
set_instance_parameter_value mxfe_rx_os_jesd204 {TPL_DATA_PATH_WIDTH} $RX_OS_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_os_jesd204 {DATA_PATH_WIDTH} $RX_OS_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_os_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
# set_instance_parameter_value mxfe_rx_jesd204 {LANE_MAP} {5 7 0 1 2 3 4 6}


add_instance mxfe_rx_os_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value mxfe_rx_os_tpl {ID} {0}
set_instance_parameter_value mxfe_rx_os_tpl {NUM_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_os_tpl {NUM_LANES} $RX_OS_NUM_OF_LANES
set_instance_parameter_value mxfe_rx_os_tpl {BITS_PER_SAMPLE} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_os_tpl {CONVERTER_RESOLUTION} $RX_OS_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_os_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value mxfe_rx_os_tpl {OCTETS_PER_BEAT} $RX_OS_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_os_tpl {DMA_BITS_PER_SAMPLE} $RX_OS_DMA_SAMPLE_WIDTH

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
set_instance_parameter_value mxfe_tx_jesd204 {EXTERNAL_PHY} $EXTERNAL_PHY
# set_instance_parameter_value mxfe_tx_jesd204 {LANE_MAP} {5 7 0 1 2 3 4 6}


add_instance mxfe_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value mxfe_tx_tpl {ID} {0}
set_instance_parameter_value mxfe_tx_tpl {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_tx_tpl {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value mxfe_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {OCTETS_PER_BEAT} $TX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_tx_tpl {DMA_BITS_PER_SAMPLE} $TX_DMA_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {DATAPATH_DISABLE} $DDS_DISABLED
set_instance_parameter_value mxfe_tx_tpl {DDS_DUAL_TONE} $DDS_DUAL_TONE

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

add_instance mxfe_rx_os_cpack util_cpack2
set_instance_parameter_value mxfe_rx_os_cpack {NUM_OF_CHANNELS} $RX_OS_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_os_cpack {SAMPLES_PER_CHANNEL} $RX_OS_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_rx_os_cpack {SAMPLE_DATA_WIDTH} $RX_OS_DMA_SAMPLE_WIDTH

# RX and TX data offload buffers

# MEM_SIZE is in bytes and only accepts powers of two (adi_data_offload_hw.tcl
# log2's it), so the per-converter sample budget the project asks for is rounded
# up.

proc ad9081_offload_size {samples_per_converter num_of_converters sample_width} {
  set bytes [expr $samples_per_converter * $num_of_converters * $sample_width / 8]
  return [expr 1 << int(ceil(log($bytes) / log(2)))]
}

proc ad9081_offload_create {name datapath_type mem_size src_dwidth dst_dwidth} {
  add_instance $name adi_data_offload
  set_instance_parameter_value $name {INSTANCE_NAME} $name
  set_instance_parameter_value $name {DATAPATH_TYPE} $datapath_type
  # RX source is util_cpack2 in FIFO mode; TX source is the DMA on AXIS.
  set_instance_parameter_value $name {SRC_INTERFACE_TYPE} [expr {$datapath_type == 0}]
  set_instance_parameter_value $name {SRC_HAS_AXIS_TKEEP} {0}
  set_instance_parameter_value $name {SRC_HAS_AXIS_TLAST} [expr {$datapath_type == 1}]
  set_instance_parameter_value $name {MEM_TYPE} {0}
  set_instance_parameter_value $name {MEM_SIZE} $mem_size
  set_instance_parameter_value $name {SOURCE_DWIDTH} $src_dwidth
  set_instance_parameter_value $name {DESTINATION_DWIDTH} $dst_dwidth
  add_interface ${name}_sync_ext conduit end
  set_interface_property ${name}_sync_ext EXPORT_OF ${name}.sync_ext
}

ad9081_offload_create $adc_data_offload_name 0 \
  [ad9081_offload_size $adc_fifo_samples_per_converter $RX_NUM_OF_CONVERTERS $RX_DMA_SAMPLE_WIDTH] \
  $adc_data_width $adc_dma_data_width
ad9081_offload_create $adc_os_data_offload_name 0 \
  [ad9081_offload_size $adc_os_fifo_samples_per_converter $RX_OS_NUM_OF_CONVERTERS $RX_OS_DMA_SAMPLE_WIDTH] \
  $adc_os_data_width $adc_os_dma_data_width
ad9081_offload_create $dac_data_offload_name 1 \
  [ad9081_offload_size $dac_fifo_samples_per_converter $TX_NUM_OF_CONVERTERS $TX_DMA_SAMPLE_WIDTH] \
  $dac_dma_data_width $dac_data_width

# RX and TX DMA instance and connections

add_instance mxfe_tx_dma axi_dmac
set_instance_parameter_value mxfe_tx_dma {ID} {0}
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_SRC} $dac_dma_data_width
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value mxfe_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value mxfe_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_tx_dma {CYCLIC} {1}
set_instance_parameter_value mxfe_tx_dma {HAS_AXIS_TLAST} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_SRC} {0}
# set_instance_parameter_value mxfe_tx_dma {FIFO_SIZE} {8}
set_instance_parameter_value mxfe_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {MAX_BYTES_PER_BURST} {2048}

add_instance mxfe_rx_dma axi_dmac
set_instance_parameter_value mxfe_rx_dma {ID} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_DEST} $adc_dma_data_width
set_instance_parameter_value mxfe_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value mxfe_rx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_rx_dma {CYCLIC} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_SRC} {1}
# set_instance_parameter_value mxfe_rx_dma {FIFO_SIZE} {8}
set_instance_parameter_value mxfe_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {MAX_BYTES_PER_BURST} {2048}

add_instance mxfe_rx_os_dma axi_dmac
set_instance_parameter_value mxfe_rx_os_dma {ID} {0}
set_instance_parameter_value mxfe_rx_os_dma {DMA_DATA_WIDTH_SRC} $adc_os_dma_data_width
set_instance_parameter_value mxfe_rx_os_dma {DMA_DATA_WIDTH_DEST} $adc_os_dma_data_width
set_instance_parameter_value mxfe_rx_os_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_rx_os_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_rx_os_dma {AXI_SLICE_DEST} {1}
set_instance_parameter_value mxfe_rx_os_dma {AXI_SLICE_SRC} {1}
set_instance_parameter_value mxfe_rx_os_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_rx_os_dma {CYCLIC} {0}
set_instance_parameter_value mxfe_rx_os_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value mxfe_rx_os_dma {DMA_TYPE_SRC} {1}
# set_instance_parameter_value mxfe_rx_dma {FIFO_SIZE} {8}
set_instance_parameter_value mxfe_rx_os_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value mxfe_rx_os_dma {MAX_BYTES_PER_BURST} {2048}

# mxfe gpio

add_instance mxfe_gpio altera_avalon_pio
set_instance_parameter_value mxfe_gpio {direction} {Input}
set_instance_parameter_value mxfe_gpio {generateIRQ} {1}
set_instance_parameter_value mxfe_gpio {width} {15}
add_connection sys_clk.clk mxfe_gpio.clk
add_connection sys_clk.clk_reset mxfe_gpio.reset
add_interface mxfe_gpio conduit end
set_interface_property mxfe_gpio EXPORT_OF mxfe_gpio.external_connection


# clocks and resets

# system clock and reset

add_connection sys_clk.clk mxfe_rx_jesd204.sys_clk
add_connection sys_clk.clk mxfe_rx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx_dma.s_axi_clock
add_connection sys_clk.clk mxfe_rx_os_jesd204.sys_clk
add_connection sys_clk.clk mxfe_rx_os_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx_os_dma.s_axi_clock
add_connection sys_clk.clk mxfe_tx_jesd204.sys_clk
add_connection sys_clk.clk mxfe_tx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_tx_dma.s_axi_clock

add_connection sys_clk.clk_reset mxfe_rx_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_rx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx_dma.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx_os_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_rx_os_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx_os_dma.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_jesd204.sys_resetn
add_connection sys_clk.clk_reset mxfe_tx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_dma.s_axi_reset

# device clock and reset

add_connection rx_device_clk.out_clk mxfe_rx_jesd204.device_clk
add_connection rx_device_clk.out_clk mxfe_rx_tpl.link_clk
add_connection rx_os_device_clk.out_clk mxfe_rx_os_jesd204.device_clk
add_connection rx_os_device_clk.out_clk mxfe_rx_os_tpl.link_clk
if {$EXTERNAL_PHY} {
  add_connection jesd204_phy.rx_clkout jesd204_phy.rx_link_clock
  add_connection jesd204_phy_os.rx_clkout jesd204_phy_os.rx_link_clock
  if {$RX_TPL_DATA_PATH_WIDTH > $RX_DATA_PATH_WIDTH} {
    add_connection jesd204_phy.rx_clkout mxfe_rx_jesd204.phy_link_clk
  }
  if {$RX_OS_TPL_DATA_PATH_WIDTH > $RX_OS_DATA_PATH_WIDTH} {
    add_connection jesd204_phy_os.rx_clkout mxfe_rx_os_jesd204.phy_link_clk
  }
}
add_connection rx_device_clk.out_clk mxfe_rx_cpack.clk
add_connection rx_device_clk.out_clk $adc_data_offload_name.s_axis_aclk
add_connection rx_os_device_clk.out_clk mxfe_rx_os_cpack.clk
add_connection rx_os_device_clk.out_clk $adc_os_data_offload_name.s_axis_aclk

add_connection tx_device_clk.out_clk mxfe_tx_jesd204.device_clk
add_connection tx_device_clk.out_clk mxfe_tx_tpl.link_clk
if {$EXTERNAL_PHY} {
  add_connection jesd204_phy.tx_clkout jesd204_phy.tx_link_clock
  add_connection jesd204_phy_os.tx_clkout jesd204_phy_os.tx_link_clock
  if {$TX_TPL_DATA_PATH_WIDTH > $TX_DATA_PATH_WIDTH} {
    add_connection jesd204_phy.tx_clkout mxfe_tx_jesd204.phy_link_clk
  }
}
add_connection tx_device_clk.out_clk mxfe_tx_upack.clk
add_connection tx_device_clk.out_clk $dac_data_offload_name.m_axis_aclk


add_connection mxfe_rx_jesd204.link_reset mxfe_rx_cpack.reset
add_connection mxfe_rx_jesd204.link_reset $adc_data_offload_name.s_axis_aresetn

add_connection mxfe_rx_os_jesd204.link_reset mxfe_rx_os_cpack.reset
add_connection mxfe_rx_os_jesd204.link_reset $adc_os_data_offload_name.s_axis_aresetn

add_connection mxfe_tx_jesd204.link_reset mxfe_tx_upack.reset
add_connection mxfe_tx_jesd204.link_reset $dac_data_offload_name.m_axis_aresetn

# dma clock and reset

add_connection sys_clk.clk $adc_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $adc_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $adc_data_offload_name.m_axis_aclk
add_connection sys_dma_clk.clk_reset $adc_data_offload_name.m_axis_aresetn
add_connection sys_dma_clk.clk mxfe_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx_dma.m_dest_axi_reset

add_connection sys_clk.clk $adc_os_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $adc_os_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $adc_os_data_offload_name.m_axis_aclk
add_connection sys_dma_clk.clk_reset $adc_os_data_offload_name.m_axis_aresetn
add_connection sys_dma_clk.clk mxfe_rx_os_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx_os_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx_os_dma.m_dest_axi_reset

add_connection sys_clk.clk $dac_data_offload_name.sys_clk
add_connection sys_clk.clk_reset $dac_data_offload_name.sys_resetn
add_connection sys_dma_clk.clk $dac_data_offload_name.s_axis_aclk
add_connection sys_dma_clk.clk_reset $dac_data_offload_name.s_axis_aresetn
add_connection sys_dma_clk.clk mxfe_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk mxfe_tx_dma.m_src_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_tx_dma.m_src_axi_reset

#
## Exported signals
#

add_interface rx_sysref        conduit end
add_interface rx_sync          conduit end
add_interface rx_os_sysref     conduit end
add_interface rx_os_sync       conduit end
add_interface rx_device_clk    clock   sink
add_interface rx_os_device_clk clock   sink
add_interface tx_sysref        conduit end
add_interface tx_sync          conduit end
add_interface tx_device_clk    clock   sink

set_interface_property rx_sysref        EXPORT_OF mxfe_rx_jesd204.sysref
set_interface_property rx_sync          EXPORT_OF mxfe_rx_jesd204.sync
set_interface_property rx_os_sysref     EXPORT_OF mxfe_rx_os_jesd204.sysref
set_interface_property rx_os_sync       EXPORT_OF mxfe_rx_os_jesd204.sync
set_interface_property rx_device_clk    EXPORT_OF rx_device_clk.in_clk
set_interface_property tx_sysref        EXPORT_OF mxfe_tx_jesd204.sysref
set_interface_property tx_sync          EXPORT_OF mxfe_tx_jesd204.sync
set_interface_property tx_device_clk    EXPORT_OF tx_device_clk.in_clk
set_interface_property rx_os_device_clk EXPORT_OF rx_os_device_clk.in_clk

add_interface rx_ref_clk         clock   sink
add_interface rx_serial_data     conduit end
add_interface rx_os_ref_clk      clock   sink
add_interface tx_os_ref_clk      clock   sink
add_interface rx_os_serial_data  conduit end
add_interface tx_ref_clk         clock   sink
add_interface tx_serial_data     conduit end

if {$TRANSCEIVER_TYPE == "F-Tile" || $TRANSCEIVER_TYPE == "E-Tile"} {
  add_interface tx_serial_data_n     conduit end
  add_interface rx_serial_data_n     conduit end
  add_interface rx_os_serial_data_n  conduit end
}

if {!$EXTERNAL_PHY} {
  set_interface_property rx_ref_clk       EXPORT_OF mxfe_rx_jesd204.ref_clk
  set_interface_property rx_serial_data   EXPORT_OF mxfe_rx_jesd204.serial_data
  set_interface_property tx_ref_clk       EXPORT_OF mxfe_tx_jesd204.ref_clk
  set_interface_property tx_serial_data   EXPORT_OF mxfe_tx_jesd204.serial_data

  if {$TRANSCEIVER_TYPE == "F-Tile"} {
    set_interface_property rx_serial_data_n   EXPORT_OF mxfe_rx_jesd204.serial_data_n
    set_interface_property tx_serial_data_n   EXPORT_OF mxfe_tx_jesd204.serial_data_n
  }
} else {
  add_connection mxfe_tx_jesd204.if_up_rst jesd204_phy.tx_link_reset
  add_connection mxfe_tx_jesd204.reset     jesd204_phy.tx_reset
  add_connection jesd204_phy.tx_reset_ack  mxfe_tx_jesd204.reset_ack
  add_connection jesd204_phy.tx_ready      mxfe_tx_jesd204.ready

  # intel_directphy_gts is duplex only, so the RX OS PHY has a TX side with no
  # link layer behind it. It is taken through the same reset sequence as the TX
  # PHY, and its ready/ack/pll_locked are deliberately left unconnected.
  add_connection mxfe_tx_jesd204.if_up_rst jesd204_phy_os.tx_link_reset
  add_connection mxfe_tx_jesd204.reset     jesd204_phy_os.tx_reset

  # Export those two so we can have TX_L < RX_L otherwise Quartus complains about
  # the number of bits mismatch...
  add_interface phy_tx_pll_locked conduit end
  set_interface_property phy_tx_pll_locked EXPORT_OF jesd204_phy.tx_pll_locked

  add_interface tx_pll_locked conduit end
  set_interface_property tx_pll_locked EXPORT_OF mxfe_tx_jesd204.tx_pll_locked

  for {set i 0} {$i < $TX_NUM_OF_LANES} {incr i} {
    add_connection mxfe_tx_jesd204.tx_phy${i} jesd204_phy.phy_tx_${i}
  }

  add_connection mxfe_rx_jesd204.if_up_rst jesd204_phy.rx_link_reset
  add_connection mxfe_rx_jesd204.reset     jesd204_phy.rx_reset
  add_connection jesd204_phy.rx_reset_ack  mxfe_rx_jesd204.reset_ack
  add_connection jesd204_phy.rx_ready      mxfe_rx_jesd204.ready

  add_connection mxfe_rx_os_jesd204.if_up_rst  jesd204_phy_os.rx_link_reset
  add_connection mxfe_rx_os_jesd204.reset      jesd204_phy_os.rx_reset
  add_connection jesd204_phy_os.rx_reset_ack   mxfe_rx_os_jesd204.reset_ack
  add_connection jesd204_phy_os.rx_ready       mxfe_rx_os_jesd204.ready

  # rx_is_lockedtodata is one bit per lane; the link layer core does not expose a
  # matching conduit start, so it is wired up at the top level.
  add_interface jesd204_phy_rx_is_lockedtodata conduit end
  add_interface jesd204_phy_os_rx_is_lockedtodata conduit end
  add_interface mxfe_rx_jesd204_rx_is_lockedtodata conduit end
  add_interface mxfe_rx_os_jesd204_rx_is_lockedtodata conduit end

  set_interface_property jesd204_phy_rx_is_lockedtodata EXPORT_OF jesd204_phy.rx_is_lockedtodata
  set_interface_property jesd204_phy_os_rx_is_lockedtodata EXPORT_OF jesd204_phy_os.rx_is_lockedtodata
  set_interface_property mxfe_rx_jesd204_rx_is_lockedtodata EXPORT_OF mxfe_rx_jesd204.rx_is_lockedtodata
  set_interface_property mxfe_rx_os_jesd204_rx_is_lockedtodata EXPORT_OF mxfe_rx_os_jesd204.rx_is_lockedtodata

  for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
    add_connection jesd204_phy.phy_rx_${i} mxfe_rx_jesd204.rx_phy${i}
  }

  for {set i 0} {$i < $RX_OS_NUM_OF_LANES} {incr i} {
    add_connection jesd204_phy_os.phy_rx_${i} mxfe_rx_os_jesd204.rx_phy${i}
  }

  set_interface_property rx_ref_clk          EXPORT_OF jesd204_phy.rx_ref_clk
  set_interface_property rx_serial_data      EXPORT_OF jesd204_phy.rx_serial_data
  set_interface_property rx_serial_data_n    EXPORT_OF jesd204_phy.rx_serial_data_n
  set_interface_property rx_os_ref_clk       EXPORT_OF jesd204_phy_os.rx_ref_clk
  set_interface_property rx_os_serial_data   EXPORT_OF jesd204_phy_os.rx_serial_data
  set_interface_property rx_os_serial_data_n EXPORT_OF jesd204_phy_os.rx_serial_data_n
  set_interface_property tx_os_ref_clk       EXPORT_OF jesd204_phy_os.tx_ref_clk
  set_interface_property tx_ref_clk          EXPORT_OF jesd204_phy.tx_ref_clk
  set_interface_property tx_serial_data      EXPORT_OF jesd204_phy.tx_serial_data
  set_interface_property tx_serial_data_n    EXPORT_OF jesd204_phy.tx_serial_data_n
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
add_connection mxfe_rx_cpack.if_packed_fifo_wr_en $adc_data_offload_name.if_src_fifo_wr_en
add_connection mxfe_rx_cpack.if_packed_fifo_wr_data $adc_data_offload_name.if_src_fifo_wr_data
# RX offload to dma
add_connection mxfe_rx_dma.if_s_axis_xfer_req $adc_data_offload_name.init_req
add_connection $adc_data_offload_name.m_axis mxfe_rx_dma.s_axis
# RX dma to HPS
if {$TRANSCEIVER_TYPE == "E-Tile"} {
  ad_dma_interconnect mxfe_rx_dma.m_dest_axi 0x0000000 $adc_dma_data_width
} else {
  ad_dma_interconnect mxfe_rx_dma.m_dest_axi
}

# RX OS link to tpl
add_connection mxfe_rx_os_jesd204.link_sof mxfe_rx_os_tpl.if_link_sof
add_connection mxfe_rx_os_jesd204.link_data mxfe_rx_os_tpl.link_data
# RX OS tpl to cpack
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_rx_os_tpl.adc_ch_$i mxfe_rx_os_cpack.adc_ch_$i
}
add_connection mxfe_rx_os_tpl.if_adc_dovf mxfe_rx_os_cpack.if_fifo_wr_overflow
# RX OS cpack to offload
add_connection mxfe_rx_os_cpack.if_packed_fifo_wr_en $adc_os_data_offload_name.if_src_fifo_wr_en
add_connection mxfe_rx_os_cpack.if_packed_fifo_wr_data $adc_os_data_offload_name.if_src_fifo_wr_data
# RX OS offload to dma
add_connection mxfe_rx_os_dma.if_s_axis_xfer_req $adc_os_data_offload_name.init_req
add_connection $adc_os_data_offload_name.m_axis mxfe_rx_os_dma.s_axis
# RX OS dma to HPS
if {$TRANSCEIVER_TYPE == "E-Tile"} {
  ad_dma_interconnect mxfe_rx_os_dma.m_dest_axi 0x0000000 $adc_os_dma_data_width
} else {
  ad_dma_interconnect mxfe_rx_dma.m_dest_axi
}

# TX link to tpl
add_connection mxfe_tx_tpl.link_data mxfe_tx_jesd204.link_data
# TX tpl to pack
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_tx_upack.dac_ch_$i mxfe_tx_tpl.dac_ch_$i
}
# TX offload to pack
add_connection $dac_data_offload_name.m_axis mxfe_tx_upack.s_axis
add_connection mxfe_tx_tpl.if_dac_dunf mxfe_tx_upack.if_fifo_rd_underflow
# TX dma to offload
add_connection mxfe_tx_dma.if_m_axis_xfer_req $dac_data_offload_name.init_req
add_connection mxfe_tx_dma.m_axis $dac_data_offload_name.s_axis
# TX dma to HPS
if {$TRANSCEIVER_TYPE == "E-Tile"} {
  ad_dma_interconnect mxfe_tx_dma.m_src_axi 0x0000000 $dac_dma_data_width
} else {
  ad_dma_interconnect mxfe_tx_dma.m_src_axi
}

# reconfiguration interface sharing for A10soc

if {$TRANSCEIVER_TYPE != "F-Tile" && $TRANSCEIVER_TYPE != "E-Tile"} {
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
if {!$EXTERNAL_PHY} {
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

    ad_cpu_interconnect 0x00020000 mxfe_rx_os_jesd204.link_pll_reconfig "avl_mm_bridge_0" 0x000C0000
    if {$RX_OS_NUM_OF_LANES > 0} {ad_cpu_interconnect 0x00000000 avl_adxcfg_0.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 1} {ad_cpu_interconnect 0x00002000 avl_adxcfg_1.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 2} {ad_cpu_interconnect 0x00004000 avl_adxcfg_2.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 3} {ad_cpu_interconnect 0x00006000 avl_adxcfg_3.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 4} {ad_cpu_interconnect 0x00008000 avl_adxcfg_4.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 5} {ad_cpu_interconnect 0x0000A000 avl_adxcfg_5.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 6} {ad_cpu_interconnect 0x0000C000 avl_adxcfg_6.rcfg_s0    "avl_mm_bridge_2"}
    if {$RX_OS_NUM_OF_LANES > 7} {ad_cpu_interconnect 0x0000E000 avl_adxcfg_7.rcfg_s0    "avl_mm_bridge_2"}

    ad_cpu_interconnect 0x000D0000 mxfe_tx_jesd204.lane_pll_reconfig
  }
} else {
  # One bridge per transceiver IP
  ad_cpu_interconnect 0x00000000 jesd204_phy.reconfig_avmm "avl_mm_bridge_0" 0x01000000 22
  ad_cpu_interconnect 0x00000000 jesd204_phy_os.reconfig_avmm "avl_mm_bridge_1" 0x02000000 22
  set_instance_parameter_value avl_mm_bridge_0 {MAX_PENDING_RESPONSES} {1}
  set_instance_parameter_value avl_mm_bridge_1 {MAX_PENDING_RESPONSES} {1}
  add_connection sys_clk.clk jesd204_phy.reconfig_clk
  add_connection sys_clk.clk_reset jesd204_phy.reconfig_reset
  add_connection sys_clk.clk jesd204_phy_os.reconfig_clk
  add_connection sys_clk.clk_reset jesd204_phy_os.reconfig_reset
}

ad_cpu_interconnect 0x000B0000 mxfe_rx_os_jesd204.link_reconfig
ad_cpu_interconnect 0x000B4000 mxfe_rx_os_jesd204.link_management
ad_cpu_interconnect 0x000B8000 mxfe_rx_os_tpl.s_axi
ad_cpu_interconnect 0x000BC000 mxfe_rx_os_dma.s_axi
ad_cpu_interconnect 0x000C0000 mxfe_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x000C4000 mxfe_rx_jesd204.link_management
ad_cpu_interconnect 0x000C8000 mxfe_tx_jesd204.link_reconfig
ad_cpu_interconnect 0x000CC000 mxfe_tx_jesd204.link_management
ad_cpu_interconnect 0x000D2000 mxfe_rx_tpl.s_axi
ad_cpu_interconnect 0x000D4000 mxfe_tx_tpl.s_axi
ad_cpu_interconnect 0x000D8000 mxfe_rx_dma.s_axi
ad_cpu_interconnect 0x000DC000 mxfe_tx_dma.s_axi
ad_cpu_interconnect 0x000E0000 mxfe_gpio.s1

# data_offload s_axi spans 64 kB (16-bit address), so it cannot sit in the 8 kB
# grid the rest of the peripherals use.
ad_cpu_interconnect 0x00100000 $adc_data_offload_name.s_axi
ad_cpu_interconnect 0x00110000 $dac_data_offload_name.s_axi
ad_cpu_interconnect 0x00120000 $adc_os_data_offload_name.s_axi

#
## interrupts
#

ad_cpu_interrupt 10  mxfe_rx_dma.interrupt_sender
ad_cpu_interrupt 11  mxfe_tx_dma.interrupt_sender
ad_cpu_interrupt 12  mxfe_rx_os_dma.interrupt_sender
ad_cpu_interrupt 13  mxfe_rx_jesd204.interrupt
ad_cpu_interrupt 14  mxfe_tx_jesd204.interrupt
ad_cpu_interrupt 15  mxfe_rx_os_jesd204.interrupt
# ad_cpu_interrupt 15  mxfe_gpio.irq

# add_interface sys_100_clk clock source
# set_interface_property sys_100_clk EXPORT_OF sys_clk.clk
# add_interface sys_100_clk_rst reset source
# set_interface_property sys_100_clk_rst EXPORT_OF sys_clk.clk_reset