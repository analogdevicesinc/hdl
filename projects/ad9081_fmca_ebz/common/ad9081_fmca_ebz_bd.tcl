###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   RX_LANE_RATE :  Lane rate of the Rx link ( MxFE to FPGA )
#   TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to MxFE )
#   GENERATE_LINK_CLK : If 1 use the generated link clocks from the physical layer, else use the reference clock as the link clock (versal only)
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#   INTF_CFG : Used to select betwen RX, TX or RX & TX
#       RXTX : RX & TX
#         RX : RX only
#         Tx : TX only

if {![info exists ADI_PHY_SEL]} {
  set ADI_PHY_SEL 1
}

source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/library/axi_tdd/scripts/axi_tdd.tcl

if {![info exists INTF_CFG]} {
  set INTF_CFG RXTX
}

if {![info exists TRANSCEIVER_TYPE]} {
  set TRANSCEIVER_TYPE GTY
}

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)

set RX_TPL_WIDTH [ expr { [info exists ad_project_params(RX_TPL_WIDTH)] \
                          ? $ad_project_params(RX_TPL_WIDTH) : {} } ]
set TX_TPL_WIDTH [ expr { [info exists ad_project_params(TX_TPL_WIDTH)] \
                          ? $ad_project_params(TX_TPL_WIDTH) : {} } ]

set TDD_SUPPORT [ expr { [info exists ad_project_params(TDD_SUPPORT)] \
                          ? $ad_project_params(TDD_SUPPORT) : 0 } ]
set SHARED_DEVCLK [ expr { [info exists ad_project_params(SHARED_DEVCLK)] \
                            ? $ad_project_params(SHARED_DEVCLK) : 0 } ]

if {$TDD_SUPPORT && !$SHARED_DEVCLK} {
  error "ERROR: Cannot enable TDD support without shared deviceclocks!"
}

if {$TDD_SUPPORT && $INTF_CFG != "RXTX"} {
  error "ERROR: Cannot enable TDD support with INTF_CFG != RXTX!"
}

set adc_do_mem_type [ expr { [info exists ad_project_params(ADC_DO_MEM_TYPE)] \
                          ? $ad_project_params(ADC_DO_MEM_TYPE) : 0 } ]
set dac_do_mem_type [ expr { [info exists ad_project_params(DAC_DO_MEM_TYPE)] \
                          ? $ad_project_params(DAC_DO_MEM_TYPE) : 0 } ]

set do_axi_data_width [ expr { [info exists do_axi_data_width] \
                          ? $do_axi_data_width : 256 } ]

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set NP12_DATAPATH_WIDTH 6
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set NP12_DATAPATH_WIDTH 12
  set ENCODER_SEL 2
}

# These are max values specific to the board
set MAX_RX_LANES_PER_LINK 4
set MAX_TX_LANES_PER_LINK 4
set MAX_RX_LINKS 2
set MAX_TX_LINKS 2
set MAX_RX_LANES [expr $MAX_RX_LANES_PER_LINK*$MAX_RX_LINKS]
set MAX_TX_LANES [expr $MAX_TX_LANES_PER_LINK*$MAX_TX_LINKS]

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

set RX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_JESD_L $RX_JESD_M $RX_JESD_S $RX_JESD_NP $RX_TPL_WIDTH]

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8* $RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)

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

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_JESD_L $TX_JESD_M $TX_JESD_S $TX_JESD_NP $TX_TPL_WIDTH]

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8 * $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# TODO: Increase the maximum number of quads if necessary
set max_num_quads 2
set num_quads [expr int(round(1.0 * $RX_NUM_OF_LANES / 4))]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_data_offload_name mxfe_rx_data_offload
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_data_offload_name mxfe_tx_data_offload
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

# Common ports
create_bd_port -dir I ref_clk_q0
create_bd_port -dir I ref_clk_q1
create_bd_port -dir I tx_device_clk
create_bd_port -dir I rx_device_clk
if {!$ADI_PHY_SEL} {
  create_bd_port -dir I rx_sysref_0
  create_bd_port -dir I tx_sysref_0
  create_bd_port -dir O rx_sync_0
  create_bd_port -dir I tx_sync_0
}

# common xcvr
if {$ADI_PHY_SEL == 1} {
  ad_ip_instance util_adxcvr util_mxfe_xcvr
  ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV_4_5 5
  switch $INTF_CFG {
    "RXTX" {
      # Rx & Tx
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_OUT_DIV 1
      ad_ip_parameter util_mxfe_xcvr CONFIG.LINK_MODE $ENCODER_SEL
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_LANE_RATE $RX_LANE_RATE
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_LANE_RATE $TX_LANE_RATE
    }
    "RX" {
      # Rx only
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_NUM_OF_LANES 0
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_OUT_DIV 1
      ad_ip_parameter util_mxfe_xcvr CONFIG.LINK_MODE $ENCODER_SEL
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_LANE_RATE $RX_LANE_RATE
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_LANE_RATE 0
    }
    "TX" {
      # Tx only
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_NUM_OF_LANES 0
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_OUT_DIV 1
      ad_ip_parameter util_mxfe_xcvr CONFIG.LINK_MODE $ENCODER_SEL
      ad_ip_parameter util_mxfe_xcvr CONFIG.RX_LANE_RATE 0
      ad_ip_parameter util_mxfe_xcvr CONFIG.TX_LANE_RATE $TX_LANE_RATE
    }
  }
} else {
  source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/versal_transceiver.tcl

  set REF_CLK_RATE [ expr { [info exists ad_project_params(REF_CLK_RATE)] \
                            ? $ad_project_params(REF_CLK_RATE) : 375 } ]

  create_bd_port -dir I gt_reset
  create_bd_port -dir I gt_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_reset_tx_pll_and_datapath
  create_bd_port -dir I gt_reset_rx_datapath
  create_bd_port -dir I gt_reset_tx_datapath
  create_bd_port -dir O gt_powergood
  create_bd_port -dir O rx_resetdone
  create_bd_port -dir O tx_resetdone

  switch $INTF_CFG {
    "RXTX" {
      create_versal_phy jesd204_phy_rxtx $JESD_MODE $RX_NUM_OF_LANES $TX_NUM_OF_LANES $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set rx_phy jesd204_phy_rxtx
      set tx_phy jesd204_phy_rxtx
      ad_connect ref_clk_q0      ${rx_phy}/GT_REFCLK
      ad_connect gt_reset        ${rx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${rx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${rx_phy}/s_axi_resetn
      ad_connect ${rx_phy}/gtpowergood gt_powergood
      ad_connect ${rx_phy}/gtreset_rx_datapath gt_reset_rx_datapath
      ad_connect ${rx_phy}/gtreset_tx_datapath gt_reset_tx_datapath
      ad_connect ${rx_phy}/gtreset_rx_pll_and_datapath gt_reset_rx_pll_and_datapath
      ad_connect ${rx_phy}/gtreset_tx_pll_and_datapath gt_reset_tx_pll_and_datapath
      ad_connect ${rx_phy}/rx_resetdone rx_resetdone
      ad_connect ${rx_phy}/tx_resetdone tx_resetdone
    }
    "RX" {
      create_versal_phy jesd204_phy_rx $JESD_MODE $RX_NUM_OF_LANES 0 $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set rx_phy jesd204_phy_rx
      ad_connect ref_clk_q0      ${rx_phy}/GT_REFCLK
      ad_connect gt_reset        ${rx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${rx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${rx_phy}/s_axi_resetn
      ad_connect ${rx_phy}/gtpowergood gt_powergood
      ad_connect ${rx_phy}/gtreset_rx_datapath gt_reset_rx_datapath
      ad_connect ${rx_phy}/gtreset_rx_pll_and_datapath gt_reset_rx_pll_and_datapath
      ad_connect ${rx_phy}/rx_resetdone rx_resetdone
    }
    "TX" {
      create_versal_phy jesd204_phy_tx $JESD_MODE 0 $TX_NUM_OF_LANES $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set tx_phy jesd204_phy_tx
      ad_connect ref_clk_q0      ${tx_phy}/GT_REFCLK
      ad_connect gt_reset        ${tx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${tx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${tx_phy}/s_axi_resetn
      ad_connect ${tx_phy}/gtpowergood gt_powergood
      ad_connect ${tx_phy}/gtreset_tx_datapath gt_reset_tx_datapath
      ad_connect ${tx_phy}/gtreset_tx_pll_and_datapath gt_reset_tx_pll_and_datapath
      ad_connect ${tx_phy}/tx_resetdone tx_resetdone
    }
  }
}

# Instantiate ADC (Rx) path
if {$INTF_CFG != "TX"} {
  if {$ADI_PHY_SEL == 1} {
    ad_ip_instance axi_adxcvr axi_mxfe_rx_xcvr
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.ID 0
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.TX_OR_RX_N 0
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.QPLL_ENABLE 0
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.LPM_OR_DFE_N 1
    ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0
  }
  if {$ADI_PHY_SEL == 0} {
    # reset generator
    ad_ip_instance proc_sys_reset rx_device_clk_rstgen
    ad_connect  rx_device_clk rx_device_clk_rstgen/slowest_sync_clk
    ad_connect  $sys_cpu_resetn rx_device_clk_rstgen/ext_reset_in
  }

  adi_axi_jesd204_rx_create axi_mxfe_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_DATAPATH_WIDTH

  ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.SYSREF_IOB false
  ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

  adi_tpl_jesd204_rx_create rx_mxfe_tpl_core $RX_NUM_OF_LANES \
                                            $RX_NUM_OF_CONVERTERS \
                                            $RX_SAMPLES_PER_FRAME \
                                            $RX_SAMPLE_WIDTH \
                                            $RX_DATAPATH_WIDTH \
                                            $RX_DMA_SAMPLE_WIDTH

  ad_ip_instance util_cpack2 util_mxfe_cpack [list \
    NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH \
  ]

  set adc_data_offload_size [expr $adc_data_width / 8 * 2**$adc_fifo_address_width]
  ad_data_offload_create $adc_data_offload_name \
                        0 \
                        $adc_do_mem_type \
                        $adc_data_offload_size \
                        $adc_data_width \
                        $adc_data_width \
                        $do_axi_data_width \
                        $SHARED_DEVCLK

  ad_ip_instance axi_dmac axi_mxfe_rx_dma
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_TYPE_SRC 1
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_TYPE_DEST 0
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.ID 0
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.CYCLIC 0
  ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_dma_data_width
  } else {
    ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_DATA_WIDTH_DEST [expr min(512, $adc_dma_data_width)]
  }
}

# Instantiate DAC (Tx) path
if {$INTF_CFG != "RX"} {
  if {$ADI_PHY_SEL == 1} {
    ad_ip_instance axi_adxcvr axi_mxfe_tx_xcvr
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.ID 0
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.TX_OR_RX_N 1
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.QPLL_ENABLE 1
    ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0
  }
  if {$ADI_PHY_SEL == 0} {
    # reset generator
    ad_ip_instance proc_sys_reset tx_device_clk_rstgen
    ad_connect  tx_device_clk tx_device_clk_rstgen/slowest_sync_clk
    ad_connect  $sys_cpu_resetn tx_device_clk_rstgen/ext_reset_in
  }

  adi_axi_jesd204_tx_create axi_mxfe_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL
  ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_DATAPATH_WIDTH

  ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.SYSREF_IOB false
  #ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

  adi_tpl_jesd204_tx_create tx_mxfe_tpl_core $TX_NUM_OF_LANES \
                                            $TX_NUM_OF_CONVERTERS \
                                            $TX_SAMPLES_PER_FRAME \
                                            $TX_SAMPLE_WIDTH \
                                            $TX_DATAPATH_WIDTH \
                                            $TX_DMA_SAMPLE_WIDTH

  ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0

  ad_ip_instance util_upack2 util_mxfe_upack [list \
    NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
    SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
    SAMPLE_DATA_WIDTH $TX_DMA_SAMPLE_WIDTH \
  ]

  set dac_data_offload_size [expr $dac_data_width / 8 * 2**$dac_fifo_address_width]
  ad_data_offload_create $dac_data_offload_name \
                        1 \
                        $dac_do_mem_type \
                        $dac_data_offload_size \
                        $dac_data_width \
                        $dac_data_width \
                        $do_axi_data_width \
                        $SHARED_DEVCLK

  ad_ip_instance axi_dmac axi_mxfe_tx_dma
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_TYPE_SRC 0
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_TYPE_DEST 1
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.ID 0
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.AXI_SLICE_SRC 1
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.AXI_SLICE_DEST 1
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.SYNC_TRANSFER_START 0
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_LENGTH_WIDTH 24
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_2D_TRANSFER 0
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.CYCLIC 1
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
  if {$ADI_PHY_SEL} {
    ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_dma_data_width
  } else {
    ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr min(512, $dac_dma_data_width)]
  }
  ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width
}

if {$ADI_PHY_SEL == 1} {
  for {set i 0} {$i < [expr max($TX_NUM_OF_LANES,$RX_NUM_OF_LANES)]} {incr i} {
    set quad_index [expr int($i / 4)]
    ad_xcvrpll  ref_clk_q$quad_index  util_mxfe_xcvr/cpll_ref_clk_$i
    if {[expr $i % 4] == 0} {
      ad_xcvrpll  ref_clk_q$quad_index  util_mxfe_xcvr/qpll_ref_clk_$i
    }
  }
  ad_connect  $sys_cpu_resetn util_mxfe_xcvr/up_rstn
  ad_connect  $sys_cpu_clk util_mxfe_xcvr/up_clk

  if {$INTF_CFG != "TX"} {
    ad_xcvrpll  axi_mxfe_rx_xcvr/up_pll_rst util_mxfe_xcvr/up_cpll_rst_*
    ad_xcvrcon  util_mxfe_xcvr axi_mxfe_rx_xcvr axi_mxfe_rx_jesd {} {} rx_device_clk
  }
  if {$INTF_CFG != "RX"} {
    ad_xcvrpll  axi_mxfe_tx_xcvr/up_pll_rst util_mxfe_xcvr/up_qpll_rst_*
    ad_xcvrcon  util_mxfe_xcvr axi_mxfe_tx_xcvr axi_mxfe_tx_jesd {} {} tx_device_clk
  }
} else {
  if {$INTF_CFG != "TX"} {
    set rx_link_clock  ${rx_phy}/rxusrclk_out
    # Connect PHY to Link Layer
    for {set j 0}  {$j < $RX_NUM_OF_LANES} {incr j} {
      ad_connect  axi_mxfe_rx_jesd/rx_phy${j} ${rx_phy}/rx${j}
    }
    ad_connect  $rx_link_clock /axi_mxfe_rx_jesd/link_clk
    ad_connect  rx_device_clk /axi_mxfe_rx_jesd/device_clk


    ad_connect axi_mxfe_rx_jesd/sysref rx_sysref_0
    if {$JESD_MODE == "8B10B"} {
      ad_connect axi_mxfe_rx_jesd/phy_en_char_align ${rx_phy}/en_char_align
      ad_connect axi_mxfe_rx_jesd/sync rx_sync_0
    } else {
      ad_connect GND ${rx_phy}/en_char_align
    }
  }
  if {$INTF_CFG != "RX"} {
    set tx_link_clock  ${tx_phy}/txusrclk_out
    # Connect PHY to Link Layer
    for {set j 0}  {$j < $TX_NUM_OF_LANES} {incr j} {
      ad_connect  axi_mxfe_tx_jesd/tx_phy${j} ${tx_phy}/tx${j}
    }
    ad_connect  $tx_link_clock /axi_mxfe_tx_jesd/link_clk
    ad_connect  tx_device_clk /axi_mxfe_tx_jesd/device_clk
    ad_connect axi_mxfe_tx_jesd/sysref tx_sysref_0
    if {$JESD_MODE == "8B10B"} {
      ad_connect axi_mxfe_tx_jesd/sync tx_sync_0
    }
  }
}

if {$INTF_CFG != "TX"} {
  # RX connections
  # Device clock domain
  ad_connect  rx_device_clk rx_mxfe_tpl_core/link_clk
  ad_connect  rx_device_clk util_mxfe_cpack/clk
  ad_connect  rx_device_clk $adc_data_offload_name/s_axis_aclk

  # Clocks
  ad_connect  $sys_dma_clk $adc_data_offload_name/m_axis_aclk
  ad_connect  $sys_dma_clk axi_mxfe_rx_dma/s_axis_aclk

  # Resets
  ad_connect  rx_device_clk_rstgen/peripheral_aresetn $adc_data_offload_name/s_axis_aresetn
  ad_connect  $sys_dma_resetn $adc_data_offload_name/m_axis_aresetn
  ad_connect  $sys_dma_resetn axi_mxfe_rx_dma/m_dest_axi_aresetn
  ad_connect  $sys_cpu_resetn $adc_data_offload_name/s_axi_aresetn

  # Link Layer to Transport Layer
  ad_connect  axi_mxfe_rx_jesd/rx_sof rx_mxfe_tpl_core/link_sof
  ad_connect  axi_mxfe_rx_jesd/rx_data_tdata rx_mxfe_tpl_core/link_data
  ad_connect  axi_mxfe_rx_jesd/rx_data_tvalid rx_mxfe_tpl_core/link_valid

  ad_connect rx_mxfe_tpl_core/adc_valid_0 util_mxfe_cpack/fifo_wr_en
  for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  rx_mxfe_tpl_core/adc_enable_$i util_mxfe_cpack/enable_$i
    ad_connect  rx_mxfe_tpl_core/adc_data_$i util_mxfe_cpack/fifo_wr_data_$i
  }

  ad_connect  util_mxfe_cpack/fifo_wr_overflow rx_mxfe_tpl_core/adc_dovf
  ad_connect  util_mxfe_cpack/packed_fifo_wr_data $adc_data_offload_name/s_axis_tdata
  ad_connect  util_mxfe_cpack/packed_fifo_wr_en $adc_data_offload_name/s_axis_tvalid
  ad_connect  $adc_data_offload_name/s_axis_tlast GND
  ad_connect  $adc_data_offload_name/s_axis_tkeep VCC

  ad_connect $adc_data_offload_name/m_axis axi_mxfe_rx_dma/s_axis

  ad_connect $adc_data_offload_name/init_req axi_mxfe_rx_dma/s_axis_xfer_req

  # Interconnect
  # CPU
  if {$ADI_PHY_SEL == 1} {
    ad_cpu_interconnect 0x44a60000 axi_mxfe_rx_xcvr
  }
  ad_cpu_interconnect 0x44a10000 rx_mxfe_tpl_core
  ad_cpu_interconnect 0x44a90000 axi_mxfe_rx_jesd
  ad_cpu_interconnect 0x7c420000 axi_mxfe_rx_dma
  ad_cpu_interconnect 0x7c450000 $adc_data_offload_name
  # GT / ADC
  if {$ADI_PHY_SEL == 1} {
    ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_xcvr/m_axi
  }
  ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
  ad_mem_hp1_interconnect $sys_dma_clk axi_mxfe_rx_dma/m_dest_axi

  # Interrupts
  ad_cpu_interrupt ps-13 mb-12 axi_mxfe_rx_dma/irq
  ad_cpu_interrupt ps-11 mb-14 axi_mxfe_rx_jesd/irq
}

if {$INTF_CFG != "RX"} {
  # TX connections
  # Device clock domain
  ad_connect  tx_device_clk tx_mxfe_tpl_core/link_clk
  ad_connect  tx_device_clk util_mxfe_upack/clk
  ad_connect  tx_device_clk $dac_data_offload_name/m_axis_aclk

  # Clocks
  ad_connect  $sys_dma_clk $dac_data_offload_name/s_axis_aclk
  ad_connect  $sys_dma_clk axi_mxfe_tx_dma/m_axis_aclk

  # Resets
  ad_connect  tx_device_clk_rstgen/peripheral_aresetn $dac_data_offload_name/m_axis_aresetn
  ad_connect  $sys_dma_resetn $dac_data_offload_name/s_axis_aresetn
  ad_connect  $sys_dma_resetn axi_mxfe_tx_dma/m_src_axi_aresetn
  ad_connect  $sys_cpu_resetn $dac_data_offload_name/s_axi_aresetn

  # Link Layer to Transport Layer
  ad_connect  tx_mxfe_tpl_core/link axi_mxfe_tx_jesd/tx_data
  ad_connect  tx_mxfe_tpl_core/dac_valid_0 util_mxfe_upack/fifo_rd_en
  for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
    ad_connect  util_mxfe_upack/fifo_rd_data_$i tx_mxfe_tpl_core/dac_data_$i
    ad_connect  tx_mxfe_tpl_core/dac_enable_$i  util_mxfe_upack/enable_$i
  }

  ad_connect $dac_data_offload_name/s_axis axi_mxfe_tx_dma/m_axis

  ad_connect  util_mxfe_upack/s_axis $dac_data_offload_name/m_axis

  ad_connect $dac_data_offload_name/init_req axi_mxfe_tx_dma/m_axis_xfer_req
  ad_connect tx_mxfe_tpl_core/dac_dunf GND

  # Interconnect
  if {$ADI_PHY_SEL == 1} {
    # CPU
    ad_cpu_interconnect 0x44b60000 axi_mxfe_tx_xcvr
  }
  # CPU
  ad_cpu_interconnect 0x44b10000 tx_mxfe_tpl_core
  ad_cpu_interconnect 0x44b90000 axi_mxfe_tx_jesd
  ad_cpu_interconnect 0x7c430000 axi_mxfe_tx_dma
  ad_cpu_interconnect 0x7c440000 $dac_data_offload_name
  # GT / ADC
  ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
  ad_mem_hp2_interconnect $sys_dma_clk axi_mxfe_tx_dma/m_src_axi

  # Interrupts
  ad_cpu_interrupt ps-12 mb-13 axi_mxfe_tx_dma/irq
  ad_cpu_interrupt ps-10 mb-15 axi_mxfe_tx_jesd/irq
}

# Dummy outputs for unused lanes
if {$ADI_PHY_SEL == 1} {
  if {$INTF_CFG != "TX"} {
    # Unused Rx lanes
    for {set i $RX_NUM_OF_LANES} {$i < 8} {incr i} {
      create_bd_port -dir I rx_data_${i}_n
      create_bd_port -dir I rx_data_${i}_p
    }
  }
  if {$INTF_CFG != "RX"} {
    # Unused Tx lanes
    for {set i $TX_NUM_OF_LANES} {$i < 8} {incr i} {
      create_bd_port -dir O tx_data_${i}_n
      create_bd_port -dir O tx_data_${i}_p
    }
  }
} else {
  for {set j 0} {$j < $num_quads} {incr j} {
    if {$INTF_CFG != "TX"} {
      create_bd_port -dir I -from 3 -to 0 rx_${j}_p
      create_bd_port -dir I -from 3 -to 0 rx_${j}_n
      ad_connect rx_${j}_p ${rx_phy}/rx_${j}_p
      ad_connect rx_${j}_n ${rx_phy}/rx_${j}_n
    }
    if {$INTF_CFG != "RX"} {
      create_bd_port -dir O -from 3 -to 0 tx_${j}_p
      create_bd_port -dir O -from 3 -to 0 tx_${j}_n
      ad_connect tx_${j}_p ${rx_phy}/tx_${j}_p
      ad_connect tx_${j}_n ${rx_phy}/tx_${j}_n
    }
  }
  # Unused serial lanes
  for {set j $num_quads} {$j < $max_num_quads} {incr j} {
    if {$INTF_CFG != "TX"} {
      create_bd_port -dir I -from 3 -to 0 rx_${j}_p
      create_bd_port -dir I -from 3 -to 0 rx_${j}_n
    }
    if {$INTF_CFG != "RX"} {
      create_bd_port -dir O -from 3 -to 0 tx_${j}_p
      create_bd_port -dir O -from 3 -to 0 tx_${j}_n
    }
  }
}

# Sync at TPL level
create_bd_port -dir I ext_sync_in

if {$INTF_CFG != "TX"} {
  # ADC (Rx) external sync
  ad_ip_parameter rx_mxfe_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in rx_mxfe_tpl_core/adc_tpl_core/adc_sync_in
  if {$INTF_CFG == "RXTX"} {
    # Rx & Tx
    ad_ip_instance util_vector_logic manual_sync_or [list \
      C_SIZE 1 \
      C_OPERATION {or} \
    ]
    ad_connect rx_mxfe_tpl_core/adc_tpl_core/adc_sync_manual_req_out manual_sync_or/Op1
    ad_connect manual_sync_or/Res rx_mxfe_tpl_core/adc_tpl_core/adc_sync_manual_req_in
  } else {
    # Only Rx
    ad_connect rx_mxfe_tpl_core/adc_tpl_core/adc_sync_manual_req_out rx_mxfe_tpl_core/adc_tpl_core/adc_sync_manual_req_in
  }
  # Reset pack cores
  ad_ip_instance util_reduced_logic cpack_rst_logic
  ad_ip_parameter cpack_rst_logic config.c_operation {or}
  ad_ip_parameter cpack_rst_logic config.c_size {3}

  ad_ip_instance util_vector_logic rx_do_rstout_logic
  ad_ip_parameter rx_do_rstout_logic config.c_operation {not}
  ad_ip_parameter rx_do_rstout_logic config.c_size {1}

  ad_connect $adc_data_offload_name/s_axis_tready rx_do_rstout_logic/Op1

  ad_ip_instance xlconcat cpack_reset_sources
  ad_ip_parameter cpack_reset_sources config.num_ports {3}
  ad_connect rx_device_clk_rstgen/peripheral_reset cpack_reset_sources/in0
  ad_connect rx_mxfe_tpl_core/adc_tpl_core/adc_rst cpack_reset_sources/in1
  ad_connect rx_do_rstout_logic/res cpack_reset_sources/in2

  ad_connect cpack_reset_sources/dout cpack_rst_logic/op1
  ad_connect cpack_rst_logic/res util_mxfe_cpack/reset
}
if {$INTF_CFG != "RX"} {
  # DAC (Tx) external sync
  ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1
  ad_connect ext_sync_in tx_mxfe_tpl_core/dac_tpl_core/dac_sync_in
  if {$INTF_CFG == "RXTX"} {
    # Rx & Tx
    ad_connect tx_mxfe_tpl_core/dac_tpl_core/dac_sync_manual_req_out manual_sync_or/Op2
    ad_connect manual_sync_or/Res tx_mxfe_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  } else {
    # Only Tx
    ad_connect tx_mxfe_tpl_core/dac_tpl_core/dac_sync_manual_req_out tx_mxfe_tpl_core/dac_tpl_core/dac_sync_manual_req_in
  }
  # Reset upack cores
  ad_ip_instance util_reduced_logic upack_rst_logic
  ad_ip_parameter upack_rst_logic config.c_operation {or}
  ad_ip_parameter upack_rst_logic config.c_size {2}

  ad_ip_instance xlconcat upack_reset_sources
  ad_ip_parameter upack_reset_sources config.num_ports {2}
  ad_connect tx_device_clk_rstgen/peripheral_reset upack_reset_sources/in0
  ad_connect tx_mxfe_tpl_core/dac_tpl_core/dac_rst upack_reset_sources/in1

  ad_connect upack_reset_sources/dout upack_rst_logic/op1
  ad_connect upack_rst_logic/res util_mxfe_upack/reset
}

if {$TDD_SUPPORT} {
  set TDD_CHANNEL_CNT $ad_project_params(TDD_CHANNEL_CNT)

  set TDD_DEFAULT_POL [ expr { [info exists ad_project_params(TDD_DEFAULT_POL)] \
                               ? $ad_project_params(TDD_DEFAULT_POL) : 0 } ]
  set TDD_REG_WIDTH [ expr { [info exists ad_project_params(TDD_REG_WIDTH)] \
                             ? $ad_project_params(TDD_REG_WIDTH) : 32 } ]
  set TDD_BURST_WIDTH [ expr { [info exists ad_project_params(TDD_BURST_WIDTH)] \
                               ? $ad_project_params(TDD_BURST_WIDTH) : 32 } ]
  set TDD_SYNC_WIDTH [ expr { [info exists ad_project_params(TDD_SYNC_WIDTH)] \
                              ? $ad_project_params(TDD_SYNC_WIDTH) : 64 } ]

  set TDD_SYNC_INT $ad_project_params(TDD_SYNC_INT)
  set TDD_SYNC_EXT $ad_project_params(TDD_SYNC_EXT)
  set TDD_SYNC_EXT_CDC $ad_project_params(TDD_SYNC_EXT_CDC)

  ad_tdd_gen_create axi_tdd_0 $TDD_CHANNEL_CNT \
                              $TDD_DEFAULT_POL \
                              $TDD_REG_WIDTH \
                              $TDD_BURST_WIDTH \
                              $TDD_SYNC_WIDTH \
                              $TDD_SYNC_INT \
                              $TDD_SYNC_EXT \
                              $TDD_SYNC_EXT_CDC

  ad_connect tx_device_clk axi_tdd_0/clk
  ad_connect tx_device_clk_rstgen/peripheral_aresetn axi_tdd_0/resetn
  ad_connect $sys_cpu_clk axi_tdd_0/s_axi_aclk
  ad_connect $sys_cpu_resetn axi_tdd_0/s_axi_aresetn
  ad_connect axi_tdd_0/sync_in GND
  ad_cpu_interconnect 0x7c460000 axi_tdd_0

  ad_connect axi_tdd_0/tdd_channel_0 $dac_data_offload_name/sync_ext
  ad_connect axi_tdd_0/tdd_channel_1 $adc_data_offload_name/sync_ext
} else {
  if {$INTF_CFG != "TX"} {
    ad_connect GND $adc_data_offload_name/sync_ext
  }
  if {$INTF_CFG != "RX"} {
    ad_connect GND $dac_data_offload_name/sync_ext
  }
}
