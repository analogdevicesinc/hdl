###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

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

set RX_DMA_SAMPLE_WIDTH $RX_JESD_NP
if {$RX_DMA_SAMPLE_WIDTH == 12} {
  set RX_DMA_SAMPLE_WIDTH 16
}

set RX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_JESD_L $RX_JESD_M $RX_JESD_S $RX_JESD_NP]

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$RX_DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

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

set TX_DMA_SAMPLE_WIDTH $TX_JESD_NP
if {$TX_DMA_SAMPLE_WIDTH == 12} {
  set TX_DMA_SAMPLE_WIDTH 16
}

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_JESD_L $TX_JESD_M $TX_JESD_S $TX_JESD_NP]

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8*$TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr $TX_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_SAMPLE_WIDTH))/log(2)))]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk

create_bd_port -dir I ext_sync

if {$ADI_PHY_SEL == 1} {
# common xcvr
ad_ip_instance util_adxcvr util_mxfe_xcvr [list \
  CPLL_FBDIV_4_5 5 \
  TX_NUM_OF_LANES $MAX_TX_LANES \
  RX_NUM_OF_LANES $MAX_RX_LANES \
  RX_OUT_DIV 1 \
]

ad_ip_instance axi_adxcvr axi_mxfe_rx_xcvr [list \
  ID 0 \
  NUM_OF_LANES $MAX_RX_LANES\
  TX_OR_RX_N 0 \
  QPLL_ENABLE 0 \
  LPM_OR_DFE_N 1 \
  SYS_CLK_SEL 0x3 \
]

ad_ip_instance axi_adxcvr axi_mxfe_tx_xcvr [list \
  ID 0 \
  NUM_OF_LANES $MAX_TX_LANES \
  TX_OR_RX_N 1 \
  QPLL_ENABLE 1 \
  SYS_CLK_SEL 0x3 \
]
} else {
for {set i 0} {$i < $MAX_RX_LANES} {incr i} {
create_bd_port -dir I rx_data_${i}_n
create_bd_port -dir I rx_data_${i}_p
}

for {set i 0} {$i < $MAX_TX_LANES} {incr i} {
create_bd_port -dir O tx_data_${i}_n
create_bd_port -dir O tx_data_${i}_p
}

create_bd_port -dir I rx_sysref_0
create_bd_port -dir I tx_sysref_0

# unused, keep for port map compatibility with JESD204B
create_bd_port -from 0 -to [expr $MAX_RX_LINKS-1] -dir O  rx_sync_0
create_bd_port -from 0 -to [expr $MAX_TX_LINKS-1] -dir I  tx_sync_0

# reset generator
ad_ip_instance proc_sys_reset rx_device_clk_rstgen
ad_connect  rx_device_clk rx_device_clk_rstgen/slowest_sync_clk
ad_connect  $sys_cpu_resetn rx_device_clk_rstgen/ext_reset_in

ad_ip_instance proc_sys_reset tx_device_clk_rstgen
ad_connect  tx_device_clk tx_device_clk_rstgen/slowest_sync_clk
ad_connect  $sys_cpu_resetn tx_device_clk_rstgen/ext_reset_in

# Common PHYs
# Use two instances since they are located on different SLRS
set rx_rate $ad_project_params(RX_LANE_RATE)
set tx_rate $ad_project_params(TX_LANE_RATE)
set ref_clk_rate $ad_project_params(REF_CLK_RATE)

ad_ip_instance jesd204_phy jesd204_phy_121_122 [list \
  C_LANES {8} \
  GT_Line_Rate $tx_rate \
  GT_REFCLK_FREQ $ref_clk_rate \
  DRPCLK_FREQ {50} \
  C_PLL_SELECTION $ad_project_params(TX_PLL_SEL) \
  RX_GT_Line_Rate $rx_rate \
  RX_GT_REFCLK_FREQ $ref_clk_rate \
  RX_PLL_SELECTION $ad_project_params(RX_PLL_SEL) \
  GT_Location {X0Y8} \
  Tx_JesdVersion {1} \
  Rx_JesdVersion {1} \
  Tx_use_64b {1} \
  Rx_use_64b {1} \
  Min_Line_Rate [expr min($rx_rate,$tx_rate)] \
  Max_Line_Rate [expr max($rx_rate,$tx_rate)] \
  Axi_Lite {true} \
]

ad_ip_instance jesd204_phy jesd204_phy_125_126 [list \
  C_LANES {8} \
  GT_Line_Rate $tx_rate \
  GT_REFCLK_FREQ $ref_clk_rate \
  DRPCLK_FREQ {50} \
  C_PLL_SELECTION $ad_project_params(TX_PLL_SEL) \
  RX_GT_Line_Rate $rx_rate \
  RX_GT_REFCLK_FREQ $ref_clk_rate \
  RX_PLL_SELECTION $ad_project_params(RX_PLL_SEL) \
  GT_Location {X0Y24} \
  Tx_JesdVersion {1} \
  Rx_JesdVersion {1} \
  Tx_use_64b {1} \
  Rx_use_64b {1} \
  Min_Line_Rate [expr min($rx_rate,$tx_rate)] \
  Max_Line_Rate [expr max($rx_rate,$tx_rate)] \
  Axi_Lite {true} \
]
}

# adc peripherals

adi_axi_jesd204_rx_create axi_mxfe_rx_jesd $RX_NUM_OF_LANES $RX_NUM_OF_LINKS $ENCODER_SEL
ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $RX_DATAPATH_WIDTH

ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_OUTPUT_PIPELINE 0

adi_tpl_jesd204_rx_create rx_mxfe_tpl_core $RX_NUM_OF_LANES \
                                           $RX_NUM_OF_CONVERTERS \
                                           $RX_SAMPLES_PER_FRAME \
                                           $RX_SAMPLE_WIDTH \
                                           $RX_DATAPATH_WIDTH \
                                           $RX_DMA_SAMPLE_WIDTH

ad_ip_parameter rx_mxfe_tpl_core/adc_tpl_core CONFIG.EN_FRAME_ALIGN 0
ad_ip_parameter rx_mxfe_tpl_core/adc_tpl_core CONFIG.EXT_SYNC 1

ad_ip_instance util_cpack2 util_mxfe_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_DMA_SAMPLE_WIDTH \
]

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

ad_ip_instance axi_dmac axi_mxfe_rx_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  ID 0 \
  AXI_SLICE_SRC 1 \
  AXI_SLICE_DEST 1 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  MAX_BYTES_PER_BURST 4096 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC $adc_dma_data_width \
  DMA_DATA_WIDTH_DEST 512 \
]

# dac peripherals

adi_axi_jesd204_tx_create axi_mxfe_tx_jesd $TX_NUM_OF_LANES $TX_NUM_OF_LINKS $ENCODER_SEL
ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.TPL_DATA_PATH_WIDTH $TX_DATAPATH_WIDTH

ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 0

adi_tpl_jesd204_tx_create tx_mxfe_tpl_core $TX_NUM_OF_LANES \
                                           $TX_NUM_OF_CONVERTERS \
                                           $TX_SAMPLES_PER_FRAME \
                                           $TX_SAMPLE_WIDTH \
                                           $TX_DATAPATH_WIDTH \
                                           $TX_SAMPLE_WIDTH

ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0
ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.XBAR_ENABLE $ad_project_params(DAC_TPL_XBAR_ENABLE)
ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.EXT_SYNC 1

ad_ip_instance util_upack2 util_mxfe_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_data_width $dac_fifo_address_width

ad_ip_instance util_pad tx_util_pad [list \
  NUM_OF_SAMPLES [expr $TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL] \
  IN_BITS_PER_SAMPLE $TX_DMA_SAMPLE_WIDTH \
  OUT_BITS_PER_SAMPLE $TX_SAMPLE_WIDTH \
  PADDING_TO_MSB_LSB_N 0 \
]

ad_ip_instance axi_dmac axi_mxfe_tx_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  ID 0 \
  AXI_SLICE_SRC 1 \
  AXI_SLICE_DEST 1 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 1 \
  DMA_DATA_WIDTH_SRC 512 \
  DMA_DATA_WIDTH_DEST $dac_dma_data_width \
  MAX_BYTES_PER_BURST 4096 \
]

# extra GPIO peripheral
ad_ip_instance axi_gpio axi_gpio_2 [list \
  C_INTERRUPT_PRESENT 1 \
  C_IS_DUAL 1 \
]

create_bd_port -dir I -from 31 -to 0 gpio2_i
create_bd_port -dir O -from 31 -to 0 gpio2_o
create_bd_port -dir O -from 31 -to 0 gpio2_t
create_bd_port -dir I -from 31 -to 0 gpio3_i
create_bd_port -dir O -from 31 -to 0 gpio3_o
create_bd_port -dir O -from 31 -to 0 gpio3_t

# reference clocks & resets

create_bd_port -dir I ref_clk_q0
create_bd_port -dir I ref_clk_q1
create_bd_port -dir I ref_clk_q2
create_bd_port -dir I ref_clk_q3

if {$ADI_PHY_SEL == 1} {

ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/qpll_ref_clk_0
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_0
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_1
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_2
ad_xcvrpll  ref_clk_q0 util_mxfe_xcvr/cpll_ref_clk_3
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/qpll_ref_clk_4
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_4
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_5
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_6
ad_xcvrpll  ref_clk_q1 util_mxfe_xcvr/cpll_ref_clk_7
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/qpll_ref_clk_8
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_8
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_9
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_10
ad_xcvrpll  ref_clk_q2 util_mxfe_xcvr/cpll_ref_clk_11
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/qpll_ref_clk_12
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_12
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_13
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_14
ad_xcvrpll  ref_clk_q3 util_mxfe_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_mxfe_rx_xcvr/up_pll_rst util_mxfe_xcvr/up_cpll_rst_*

ad_xcvrpll  axi_mxfe_tx_xcvr/up_pll_rst util_mxfe_xcvr/up_qpll_rst_*

ad_connect  $sys_cpu_resetn util_mxfe_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_mxfe_xcvr/up_clk

# connections (adc)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
#  lane_map = {13 10 11  9  3 15 12 14  2  5  0  4  8  7  6  1}

set max_lane_map {13 10 11  9  3 15 12 14  2  5  0  4  8  7  6  1}
set lane_map {}

for {set i 0}  {$i < $RX_NUM_OF_LINKS} {incr i} {
  for {set j 0}  {$j < $RX_JESD_L} {incr j} {
    set cur_lane [expr $i*$MAX_RX_LANES_PER_LINK+$j]
    lappend lane_map [lindex $max_lane_map $cur_lane]
  }
}

ad_xcvrcon  util_mxfe_xcvr axi_mxfe_rx_xcvr axi_mxfe_rx_jesd $max_lane_map {} rx_device_clk $MAX_RX_LANES $lane_map

# connections (dac)
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
#  lane_map = {13  8  9  7  3 15 12 14  6  5  2  4  0 10  1 11}
#
set max_lane_map {13 8 9 7 3 15 12 14 6 5 2 4 0 10 1 11}
set lane_map {}

for {set i 0}  {$i < $TX_NUM_OF_LINKS} {incr i} {
  for {set j 0}  {$j < $TX_JESD_L} {incr j} {
    set cur_lane [expr $i*$MAX_TX_LANES_PER_LINK+$j]
    lappend lane_map [lindex $max_lane_map $cur_lane]
  }
}

ad_xcvrcon  util_mxfe_xcvr axi_mxfe_tx_xcvr axi_mxfe_tx_jesd $max_lane_map {} tx_device_clk $MAX_TX_LANES $lane_map

} else {

ad_connect  ref_clk_q0 jesd204_phy_121_122/cpll_refclk
ad_connect  ref_clk_q0 jesd204_phy_121_122/qpll0_refclk
ad_connect  ref_clk_q0 jesd204_phy_121_122/qpll1_refclk
ad_connect  ref_clk_q2 jesd204_phy_125_126/cpll_refclk
ad_connect  ref_clk_q2 jesd204_phy_125_126/qpll0_refclk
ad_connect  ref_clk_q2 jesd204_phy_125_126/qpll1_refclk

# link clock domain

ad_ip_instance util_ds_buf txoutclk_BUFG_GT
ad_ip_parameter txoutclk_BUFG_GT CONFIG.C_BUF_TYPE {BUFG_GT}
ad_connect txoutclk_BUFG_GT/BUFG_GT_CE VCC
ad_connect txoutclk_BUFG_GT/BUFG_GT_CEMASK GND
ad_connect txoutclk_BUFG_GT/BUFG_GT_CLR GND
ad_connect txoutclk_BUFG_GT/BUFG_GT_CLRMASK GND
ad_connect txoutclk_BUFG_GT/BUFG_GT_DIV GND
ad_connect jesd204_phy_121_122/txoutclk txoutclk_BUFG_GT/BUFG_GT_I

set tx_link_clock  txoutclk_BUFG_GT/BUFG_GT_O

ad_ip_instance util_ds_buf rxoutclk_BUFG_GT
ad_ip_parameter rxoutclk_BUFG_GT CONFIG.C_BUF_TYPE {BUFG_GT}
ad_connect rxoutclk_BUFG_GT/BUFG_GT_CE VCC
ad_connect rxoutclk_BUFG_GT/BUFG_GT_CEMASK GND
ad_connect rxoutclk_BUFG_GT/BUFG_GT_CLR GND
ad_connect rxoutclk_BUFG_GT/BUFG_GT_CLRMASK GND
ad_connect rxoutclk_BUFG_GT/BUFG_GT_DIV GND
ad_connect jesd204_phy_121_122/rxoutclk rxoutclk_BUFG_GT/BUFG_GT_I

set rx_link_clock  rxoutclk_BUFG_GT/BUFG_GT_O

ad_connect  $tx_link_clock jesd204_phy_121_122/tx_core_clk
ad_connect  $tx_link_clock jesd204_phy_125_126/tx_core_clk
ad_connect  $tx_link_clock axi_mxfe_tx_jesd/link_clk
ad_connect  tx_device_clk axi_mxfe_tx_jesd/device_clk

ad_connect  $rx_link_clock jesd204_phy_121_122/rx_core_clk
ad_connect  $rx_link_clock jesd204_phy_125_126/rx_core_clk
ad_connect  $rx_link_clock axi_mxfe_rx_jesd/link_clk
ad_connect  rx_device_clk axi_mxfe_rx_jesd/device_clk
}

# device clock domain
ad_connect  rx_device_clk rx_mxfe_tpl_core/link_clk
ad_connect  rx_device_clk util_mxfe_cpack/clk
ad_connect  rx_device_clk mxfe_adc_fifo/adc_clk

ad_connect  tx_device_clk tx_mxfe_tpl_core/link_clk
ad_connect  tx_device_clk util_mxfe_upack/clk
ad_connect  tx_device_clk mxfe_dac_fifo/dac_clk

# dma clock domain
ad_connect  $sys_cpu_clk mxfe_adc_fifo/dma_clk
ad_connect  $sys_dma_clk mxfe_dac_fifo/dma_clk
ad_connect  $sys_cpu_clk axi_mxfe_rx_dma/s_axis_aclk
ad_connect  $sys_dma_clk axi_mxfe_tx_dma/m_axis_aclk

# connect resets
ad_connect  rx_device_clk_rstgen/peripheral_reset mxfe_adc_fifo/adc_rst
ad_connect  tx_device_clk_rstgen/peripheral_reset mxfe_dac_fifo/dac_rst
ad_connect  tx_device_clk_rstgen/peripheral_reset util_mxfe_upack/reset
ad_connect  $sys_cpu_resetn axi_mxfe_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_mxfe_tx_dma/m_src_axi_aresetn
ad_connect  $sys_dma_reset mxfe_dac_fifo/dma_rst

if {$ADI_PHY_SEL == 0} {
ad_connect  jesd204_phy_121_122/tx_sys_reset GND
ad_connect  jesd204_phy_125_126/tx_sys_reset GND

ad_connect  jesd204_phy_121_122/rx_sys_reset GND
ad_connect  jesd204_phy_125_126/rx_sys_reset GND

ad_connect  axi_mxfe_tx_jesd/tx_axi/device_reset jesd204_phy_121_122/tx_reset_gt
ad_connect  axi_mxfe_rx_jesd/rx_axi/device_reset jesd204_phy_121_122/rx_reset_gt
ad_connect  axi_mxfe_tx_jesd/tx_axi/device_reset jesd204_phy_125_126/tx_reset_gt
ad_connect  axi_mxfe_rx_jesd/rx_axi/device_reset jesd204_phy_125_126/rx_reset_gt
}

#
# connect adc dataflow
#
if {$ADI_PHY_SEL == 0} {
# Rx Physical lanes to PHY
ad_ip_instance xlconcat rx_concat_7_0_p [list NUM_PORTS {8}]
ad_ip_instance xlconcat rx_concat_7_0_n [list NUM_PORTS {8}]

ad_connect  rx_data_0_p rx_concat_7_0_p/In0
ad_connect  rx_data_1_p rx_concat_7_0_p/In1
ad_connect  rx_data_2_p rx_concat_7_0_p/In2
ad_connect  rx_data_3_p rx_concat_7_0_p/In3
ad_connect  rx_data_4_p rx_concat_7_0_p/In4
ad_connect  rx_data_5_p rx_concat_7_0_p/In5
ad_connect  rx_data_6_p rx_concat_7_0_p/In6
ad_connect  rx_data_7_p rx_concat_7_0_p/In7

ad_connect  rx_data_0_n rx_concat_7_0_n/In0
ad_connect  rx_data_1_n rx_concat_7_0_n/In1
ad_connect  rx_data_2_n rx_concat_7_0_n/In2
ad_connect  rx_data_3_n rx_concat_7_0_n/In3
ad_connect  rx_data_4_n rx_concat_7_0_n/In4
ad_connect  rx_data_5_n rx_concat_7_0_n/In5
ad_connect  rx_data_6_n rx_concat_7_0_n/In6
ad_connect  rx_data_7_n rx_concat_7_0_n/In7

ad_connect  jesd204_phy_121_122/rxp_in rx_concat_7_0_p/dout
ad_connect  jesd204_phy_121_122/rxn_in rx_concat_7_0_n/dout

ad_ip_instance xlconcat rx_concat_15_8_p [list NUM_PORTS {8}]
ad_ip_instance xlconcat rx_concat_15_8_n [list NUM_PORTS {8}]

ad_connect  rx_data_8_p rx_concat_15_8_p/In0
ad_connect  rx_data_9_p rx_concat_15_8_p/In1
ad_connect  rx_data_10_p rx_concat_15_8_p/In2
ad_connect  rx_data_11_p rx_concat_15_8_p/In3
ad_connect  rx_data_12_p rx_concat_15_8_p/In4
ad_connect  rx_data_13_p rx_concat_15_8_p/In5
ad_connect  rx_data_14_p rx_concat_15_8_p/In6
ad_connect  rx_data_15_p rx_concat_15_8_p/In7

ad_connect  rx_data_8_n rx_concat_15_8_n/In0
ad_connect  rx_data_9_n rx_concat_15_8_n/In1
ad_connect  rx_data_10_n rx_concat_15_8_n/In2
ad_connect  rx_data_11_n rx_concat_15_8_n/In3
ad_connect  rx_data_12_n rx_concat_15_8_n/In4
ad_connect  rx_data_13_n rx_concat_15_8_n/In5
ad_connect  rx_data_14_n rx_concat_15_8_n/In6
ad_connect  rx_data_15_n rx_concat_15_8_n/In7

ad_connect  jesd204_phy_125_126/rxp_in rx_concat_15_8_p/dout
ad_connect  jesd204_phy_125_126/rxn_in rx_concat_15_8_n/dout

# Connect PHY to Link Layer
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
#  lane_map = {13 10 11  9  3 15 12 14  2  5  0  4  8  7  6  1}
#
# Logical lane to physical lane map for maximum of lanes per link
#     logical lane                                physical lane
set logic_lane(10) jesd204_phy_121_122/gt0_rx ; # 0
set logic_lane(15) jesd204_phy_121_122/gt1_rx ; # 1
set logic_lane(8)  jesd204_phy_121_122/gt2_rx ; # 2
set logic_lane(4)  jesd204_phy_121_122/gt3_rx ; # 3
set logic_lane(11) jesd204_phy_121_122/gt4_rx ; # 4
set logic_lane(9)  jesd204_phy_121_122/gt5_rx ; # 5
set logic_lane(14) jesd204_phy_121_122/gt6_rx ; # 6
set logic_lane(13) jesd204_phy_121_122/gt7_rx ; # 7
set logic_lane(12) jesd204_phy_125_126/gt0_rx ; # 8
set logic_lane(3)  jesd204_phy_125_126/gt1_rx ; # 9
set logic_lane(1)  jesd204_phy_125_126/gt2_rx ; # 10
set logic_lane(2)  jesd204_phy_125_126/gt3_rx ; # 11
set logic_lane(6)  jesd204_phy_125_126/gt4_rx ; # 12
set logic_lane(0)  jesd204_phy_125_126/gt5_rx ; # 13
set logic_lane(7)  jesd204_phy_125_126/gt6_rx ; # 14
set logic_lane(5)  jesd204_phy_125_126/gt7_rx ; # 15
set cur_lane 0
for {set i 0}  {$i < $RX_NUM_OF_LINKS} {incr i} {
  for {set j 0}  {$j < $RX_JESD_L} {incr j} {
   ad_connect  axi_mxfe_rx_jesd/rx_phy$cur_lane $logic_lane([expr $i*$MAX_RX_LANES_PER_LINK+$j])
   incr cur_lane
  }
}

ad_connect  rx_sysref_0  axi_mxfe_rx_jesd/sysref

}

#
# rx link layer to tpl
#
ad_connect  axi_mxfe_rx_jesd/rx_sof rx_mxfe_tpl_core/link_sof
ad_connect  axi_mxfe_rx_jesd/rx_data_tdata rx_mxfe_tpl_core/link_data
ad_connect  axi_mxfe_rx_jesd/rx_data_tvalid rx_mxfe_tpl_core/link_valid

ad_connect ext_sync rx_mxfe_tpl_core/adc_tpl_core/adc_sync_in
ad_connect rx_mxfe_tpl_core/adc_tpl_core/adc_rst util_mxfe_cpack/reset

#
# rx tpl to cpack
#
ad_connect rx_mxfe_tpl_core/adc_valid_0 util_mxfe_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_mxfe_tpl_core/adc_enable_$i util_mxfe_cpack/enable_$i
  ad_connect  rx_mxfe_tpl_core/adc_data_$i util_mxfe_cpack/fifo_wr_data_$i
}
ad_connect rx_mxfe_tpl_core/adc_dovf util_mxfe_cpack/fifo_wr_overflow

#
# cpack to adc_fifo
#
ad_connect  util_mxfe_cpack/packed_fifo_wr_data mxfe_adc_fifo/adc_wdata
ad_connect  util_mxfe_cpack/packed_fifo_wr_en mxfe_adc_fifo/adc_wr
#
# adc_fifo to dma
#
ad_connect  mxfe_adc_fifo/dma_wr axi_mxfe_rx_dma/s_axis_valid
ad_connect  mxfe_adc_fifo/dma_wdata axi_mxfe_rx_dma/s_axis_data
ad_connect  mxfe_adc_fifo/dma_wready axi_mxfe_rx_dma/s_axis_ready
ad_connect  mxfe_adc_fifo/dma_xfer_req axi_mxfe_rx_dma/s_axis_xfer_req

#
#connect dac dataflow
#
if {$ADI_PHY_SEL == 0} {
# Tx Physical lanes to PHY
#
for {set i 0} {$i < $MAX_TX_LANES} {incr i} {
  ad_ip_instance xlslice txp_out_slice_$i [list \
    DIN_TO [expr $i % 8] \
    DIN_FROM [expr $i % 8] \
    DIN_WIDTH {8} \
    DOUT_WIDTH {1} \
  ]
  ad_ip_instance xlslice txn_out_slice_$i [list \
    DIN_TO [expr $i % 8] \
    DIN_FROM [expr $i % 8] \
    DIN_WIDTH {8} \
    DOUT_WIDTH {1} \
  ]
}

for {set i 0} {$i < 8} {incr i} {
  ad_connect  jesd204_phy_121_122/txn_out  txn_out_slice_$i/Din
  ad_connect  jesd204_phy_121_122/txp_out  txp_out_slice_$i/Din
  ad_connect  jesd204_phy_125_126/txn_out  txn_out_slice_[expr $i+8]/Din
  ad_connect  jesd204_phy_125_126/txp_out  txp_out_slice_[expr $i+8]/Din
}

for {set i 0} {$i < $MAX_TX_LANES} {incr i} {
  ad_connect  txn_out_slice_$i/Dout tx_data_${i}_n
  ad_connect  txp_out_slice_$i/Dout tx_data_${i}_p
}

# Tx connect PHY to Link Layer
#  map the logical lane $n onto the physical lane  $lane_map[$n]
#         n     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
#  lane_map = {13  8  9  7  3 15 12 14  6  5  2  4  0 10  1 11}
#
# logical lane to physical lane map for maximum of lanes per link
#     logical lane                                physical lane
set logic_lane(12) jesd204_phy_121_122/gt0_tx ; # 0
set logic_lane(14) jesd204_phy_121_122/gt1_tx ; # 1
set logic_lane(10) jesd204_phy_121_122/gt2_tx ; # 2
set logic_lane(4)  jesd204_phy_121_122/gt3_tx ; # 3
set logic_lane(11) jesd204_phy_121_122/gt4_tx ; # 4
set logic_lane(9)  jesd204_phy_121_122/gt5_tx ; # 5
set logic_lane(8)  jesd204_phy_121_122/gt6_tx ; # 6
set logic_lane(3)  jesd204_phy_121_122/gt7_tx ; # 7
set logic_lane(1)  jesd204_phy_125_126/gt0_tx ; # 8
set logic_lane(2)  jesd204_phy_125_126/gt1_tx ; # 9
set logic_lane(13) jesd204_phy_125_126/gt2_tx ; # 10
set logic_lane(15) jesd204_phy_125_126/gt3_tx ; # 11
set logic_lane(6)  jesd204_phy_125_126/gt4_tx ; # 12
set logic_lane(0)  jesd204_phy_125_126/gt5_tx ; # 13
set logic_lane(7)  jesd204_phy_125_126/gt6_tx ; # 14
set logic_lane(5)  jesd204_phy_125_126/gt7_tx ; # 15
set cur_lane 0
for {set i 0}  {$i < $TX_NUM_OF_LINKS} {incr i} {
  for {set j 0}  {$j < $TX_JESD_L} {incr j} {
   ad_connect  axi_mxfe_tx_jesd/tx_phy$cur_lane $logic_lane([expr $i*$MAX_TX_LANES_PER_LINK+$j])
   incr cur_lane
  }
}

ad_connect  tx_sysref_0  axi_mxfe_tx_jesd/sysref

}

#
# tpl to link layer
#
ad_connect  tx_mxfe_tpl_core/link axi_mxfe_tx_jesd/tx_data

ad_connect  tx_mxfe_tpl_core/dac_valid_0 util_mxfe_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_mxfe_upack/fifo_rd_data_$i tx_mxfe_tpl_core/dac_data_$i
  ad_connect  tx_mxfe_tpl_core/dac_enable_$i  util_mxfe_upack/enable_$i
}

ad_connect ext_sync tx_mxfe_tpl_core/dac_tpl_core/dac_sync_in

#
# dac fifo to upack
#

# TODO: Add streaming AXI interface for DAC FIFO
ad_connect  util_mxfe_upack/s_axis_valid VCC
ad_connect  util_mxfe_upack/s_axis_ready mxfe_dac_fifo/dac_valid
ad_connect  util_mxfe_upack/s_axis_data mxfe_dac_fifo/dac_data

#
# dma to dac fifo
#
ad_connect  mxfe_dac_fifo/dma_valid axi_mxfe_tx_dma/m_axis_valid
ad_connect  tx_util_pad/data_out mxfe_dac_fifo/dma_data
ad_connect  axi_mxfe_tx_dma/m_axis_data tx_util_pad/data_in
ad_connect  mxfe_dac_fifo/dma_ready axi_mxfe_tx_dma/m_axis_ready
ad_connect  mxfe_dac_fifo/dma_xfer_req axi_mxfe_tx_dma/m_axis_xfer_req
ad_connect  mxfe_dac_fifo/dma_xfer_last axi_mxfe_tx_dma/m_axis_last
ad_connect  mxfe_dac_fifo/dac_dunf tx_mxfe_tpl_core/dac_dunf

create_bd_port -dir I dac_fifo_bypass
ad_connect  mxfe_dac_fifo/bypass dac_fifo_bypass

# extra GPIOs
ad_connect gpio2_i axi_gpio_2/gpio_io_i
ad_connect gpio2_o axi_gpio_2/gpio_io_o
ad_connect gpio2_t axi_gpio_2/gpio_io_t
ad_connect gpio3_i axi_gpio_2/gpio2_io_i
ad_connect gpio3_o axi_gpio_2/gpio2_io_o
ad_connect gpio3_t axi_gpio_2/gpio2_io_t

# interconnect (cpu)
if {$ADI_PHY_SEL == 1} {
ad_cpu_interconnect 0x44a60000 axi_mxfe_rx_xcvr
ad_cpu_interconnect 0x44b60000 axi_mxfe_tx_xcvr
} else {
ad_cpu_interconnect 0x44a60000 jesd204_phy_121_122
ad_cpu_interconnect 0x44b60000 jesd204_phy_125_126
}
ad_cpu_interconnect 0x44a10000 rx_mxfe_tpl_core
ad_cpu_interconnect 0x44b10000 tx_mxfe_tpl_core
ad_cpu_interconnect 0x44a90000 axi_mxfe_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_mxfe_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_mxfe_rx_dma
ad_cpu_interconnect 0x7c430000 axi_mxfe_tx_dma
ad_cpu_interconnect 0x7c440000 axi_gpio_2

# interconnect (gt/adc)
#
if {$ADI_PHY_SEL == 1} {
ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_xcvr/m_axi
}

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_mxfe_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_mxfe_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_mxfe_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_mxfe_tx_jesd/irq
ad_cpu_interrupt ps-14 mb-8  axi_gpio_2/ip2intc_irpt

