#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C, uses Xilinx IP as Physical layer
#      8B10B  - 8b10b link layer defined in JESD 204B, uses ADI IP as Physical layer
#
#   RX_RATE :  Line rate of the Rx link ( MxFE to FPGA ) used in 64B66B mode
#   TX_RATE :  Line rate of the Tx link ( FPGA to MxFE ) used in 64B66B mode
#   [RX/TX]_PLL_SEL :  Used PLL in the Xilinx PHY used in 64B66B mode
#                      Encoding is:
#                         0 - CPLL
#                         1 - QPLL0
#                         2 - QPLL1
#   REF_CLK_RATE : Frequency of reference clock in MHz used in 64B66B mode
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample, only 16 is supported
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#

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

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$DATAPATH_WIDTH / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

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

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8*$DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr 8*$DATAPATH_WIDTH*$RX_NUM_OF_LANES]
set adc_dma_data_width [expr 8*$DATAPATH_WIDTH*$RX_NUM_OF_LANES]
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr 8*$DATAPATH_WIDTH*$TX_NUM_OF_LANES]
set dac_dma_data_width [expr 8*$DATAPATH_WIDTH*$TX_NUM_OF_LANES]
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_SAMPLE_WIDTH))/log(2)))]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk

if {$ADI_PHY_SEL == 1} {
# common xcvr
ad_ip_instance util_adxcvr util_mxfe_xcvr
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_OUT_DIV 1

ad_ip_instance axi_adxcvr axi_mxfe_rx_xcvr
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.ID 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

ad_ip_instance axi_adxcvr axi_mxfe_tx_xcvr
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.ID 0
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

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
create_bd_port -dir O  rx_sync_0
create_bd_port -dir I  tx_sync_0

# reset generator
ad_ip_instance proc_sys_reset rx_device_clk_rstgen
ad_connect  rx_device_clk rx_device_clk_rstgen/slowest_sync_clk
ad_connect  $sys_cpu_resetn rx_device_clk_rstgen/ext_reset_in

ad_ip_instance proc_sys_reset tx_device_clk_rstgen
ad_connect  tx_device_clk tx_device_clk_rstgen/slowest_sync_clk
ad_connect  $sys_cpu_resetn tx_device_clk_rstgen/ext_reset_in

# Common PHYs
# Use two instances since they are located on different SLRS
set rx_rate $ad_project_params(RX_RATE)
set tx_rate $ad_project_params(TX_RATE)
set ref_clk_rate $ad_project_params(REF_CLK_RATE)

ad_ip_instance jesd204_phy jesd204_phy_121 [list \
  C_LANES {4} \
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

ad_ip_instance jesd204_phy jesd204_phy_126 [list \
  C_LANES {4} \
  GT_Line_Rate $tx_rate \
  GT_REFCLK_FREQ $ref_clk_rate \
  DRPCLK_FREQ {50} \
  C_PLL_SELECTION $ad_project_params(TX_PLL_SEL) \
  RX_GT_Line_Rate $rx_rate \
  RX_GT_REFCLK_FREQ $ref_clk_rate \
  RX_PLL_SELECTION $ad_project_params(RX_PLL_SEL) \
  GT_Location {X0Y28} \
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

adi_axi_jesd204_rx_create axi_mxfe_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL

ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_mxfe_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 1

adi_tpl_jesd204_rx_create rx_mxfe_tpl_core $RX_NUM_OF_LANES \
                                           $RX_NUM_OF_CONVERTERS \
                                           $RX_SAMPLES_PER_FRAME \
                                           $RX_SAMPLE_WIDTH \
                                           $DATAPATH_WIDTH

ad_ip_instance util_cpack2 util_mxfe_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

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
ad_ip_parameter axi_mxfe_rx_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_dma_data_width

# dac peripherals

adi_axi_jesd204_tx_create axi_mxfe_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL

ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.SYSREF_IOB false
#ad_ip_parameter axi_mxfe_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

adi_tpl_jesd204_tx_create tx_mxfe_tpl_core $TX_NUM_OF_LANES \
                                           $TX_NUM_OF_CONVERTERS \
                                           $TX_SAMPLES_PER_FRAME \
                                           $TX_SAMPLE_WIDTH \
                                           $DATAPATH_WIDTH

ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.IQCORRECTION_DISABLE 0
ad_ip_parameter tx_mxfe_tpl_core/dac_tpl_core CONFIG.XBAR_ENABLE 1

ad_ip_instance util_upack2 util_mxfe_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

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
ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_dma_data_width
ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width

# reference clocks & resets

create_bd_port -dir I ref_clk_q0
create_bd_port -dir I ref_clk_q1

if {$ADI_PHY_SEL == 1} {
for {set i 0} {$i < [expr max($TX_NUM_OF_LANES,$RX_NUM_OF_LANES)]} {incr i} {
  set quad_index [expr int($i / 4)]
  ad_xcvrpll  ref_clk_q$quad_index  util_mxfe_xcvr/cpll_ref_clk_$i
  if {[expr $i % 4] == 0} {
    ad_xcvrpll  ref_clk_q$quad_index  util_mxfe_xcvr/qpll_ref_clk_$i
  }
}

ad_xcvrpll  axi_mxfe_tx_xcvr/up_pll_rst util_mxfe_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_mxfe_rx_xcvr/up_pll_rst util_mxfe_xcvr/up_cpll_rst_*

ad_connect  $sys_cpu_resetn util_mxfe_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_mxfe_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_mxfe_xcvr axi_mxfe_rx_xcvr axi_mxfe_rx_jesd {} rx_device_clk

# connections (dac)
ad_xcvrcon  util_mxfe_xcvr axi_mxfe_tx_xcvr axi_mxfe_tx_jesd {} tx_device_clk
} else {
ad_connect  ref_clk_q0 jesd204_phy_121/cpll_refclk
ad_connect  ref_clk_q0 jesd204_phy_121/qpll0_refclk
ad_connect  ref_clk_q0 jesd204_phy_121/qpll1_refclk
ad_connect  ref_clk_q1 jesd204_phy_126/cpll_refclk
ad_connect  ref_clk_q1 jesd204_phy_126/qpll0_refclk
ad_connect  ref_clk_q1 jesd204_phy_126/qpll1_refclk

# device clock domain
ad_connect  tx_device_clk jesd204_phy_121/tx_core_clk
ad_connect  tx_device_clk jesd204_phy_126/tx_core_clk
ad_connect  tx_device_clk axi_mxfe_tx_jesd/device_clk

ad_connect  rx_device_clk jesd204_phy_121/rx_core_clk
ad_connect  rx_device_clk jesd204_phy_126/rx_core_clk
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
ad_connect  rx_device_clk_rstgen/peripheral_reset util_mxfe_cpack/reset
ad_connect  tx_device_clk_rstgen/peripheral_reset util_mxfe_upack/reset
ad_connect  $sys_cpu_resetn axi_mxfe_rx_dma/m_dest_axi_aresetn
ad_connect  $sys_dma_resetn axi_mxfe_tx_dma/m_src_axi_aresetn
ad_connect  $sys_dma_reset  mxfe_dac_fifo/dma_rst

if {$ADI_PHY_SEL == 0} {
ad_connect  tx_device_clk_rstgen/peripheral_reset jesd204_phy_121/tx_sys_reset
ad_connect  tx_device_clk_rstgen/peripheral_reset jesd204_phy_126/tx_sys_reset

ad_connect  rx_device_clk_rstgen/peripheral_reset jesd204_phy_121/rx_sys_reset
ad_connect  rx_device_clk_rstgen/peripheral_reset jesd204_phy_126/rx_sys_reset

ad_connect  axi_mxfe_tx_jesd/tx_axi/core_reset jesd204_phy_121/tx_reset_gt
ad_connect  axi_mxfe_rx_jesd/rx_axi/core_reset jesd204_phy_121/rx_reset_gt
ad_connect  axi_mxfe_tx_jesd/tx_axi/core_reset jesd204_phy_126/tx_reset_gt
ad_connect  axi_mxfe_rx_jesd/rx_axi/core_reset jesd204_phy_126/rx_reset_gt
}
#
# connect adc dataflow
#
if {$ADI_PHY_SEL == 0} {
# Rx Physical lanes to PHY
ad_ip_instance xlconcat rx_concat_3_0_p [list NUM_PORTS {4}]
ad_ip_instance xlconcat rx_concat_3_0_n [list NUM_PORTS {4}]

ad_connect  rx_data_0_p rx_concat_3_0_p/In0
ad_connect  rx_data_1_p rx_concat_3_0_p/In1
ad_connect  rx_data_2_p rx_concat_3_0_p/In2
ad_connect  rx_data_3_p rx_concat_3_0_p/In3

ad_connect  rx_data_0_n rx_concat_3_0_n/In0
ad_connect  rx_data_1_n rx_concat_3_0_n/In1
ad_connect  rx_data_2_n rx_concat_3_0_n/In2
ad_connect  rx_data_3_n rx_concat_3_0_n/In3

ad_connect  jesd204_phy_121/rxp_in rx_concat_3_0_p/dout
ad_connect  jesd204_phy_121/rxn_in rx_concat_3_0_n/dout

ad_ip_instance xlconcat rx_concat_7_4_p [list NUM_PORTS {4}]
ad_ip_instance xlconcat rx_concat_7_4_n [list NUM_PORTS {4}]

ad_connect  rx_data_4_p rx_concat_7_4_p/In0
ad_connect  rx_data_5_p rx_concat_7_4_p/In1
ad_connect  rx_data_6_p rx_concat_7_4_p/In2
ad_connect  rx_data_7_p rx_concat_7_4_p/In3

ad_connect  rx_data_4_n rx_concat_7_4_n/In0
ad_connect  rx_data_5_n rx_concat_7_4_n/In1
ad_connect  rx_data_6_n rx_concat_7_4_n/In2
ad_connect  rx_data_7_n rx_concat_7_4_n/In3

ad_connect  jesd204_phy_126/rxp_in rx_concat_7_4_p/dout
ad_connect  jesd204_phy_126/rxn_in rx_concat_7_4_n/dout

# Connect PHY to Link Layer
set logic_lane(0) jesd204_phy_121/gt0_rx
set logic_lane(1) jesd204_phy_121/gt1_rx
set logic_lane(2) jesd204_phy_121/gt2_rx
set logic_lane(3) jesd204_phy_121/gt3_rx
set logic_lane(4) jesd204_phy_126/gt0_rx
set logic_lane(5) jesd204_phy_126/gt1_rx
set logic_lane(6) jesd204_phy_126/gt2_rx
set logic_lane(7) jesd204_phy_126/gt3_rx
for {set j 0}  {$j < $RX_NUM_OF_LANES} {incr j} {
 ad_connect  axi_mxfe_rx_jesd/rx_phy$j $logic_lane($j)
}

ad_connect  rx_sysref_0  axi_mxfe_rx_jesd/sysref

}
# Connect Link Layer to Transport Layer
#
ad_connect  axi_mxfe_rx_jesd/rx_sof rx_mxfe_tpl_core/link_sof
ad_connect  axi_mxfe_rx_jesd/rx_data_tdata rx_mxfe_tpl_core/link_data
ad_connect  axi_mxfe_rx_jesd/rx_data_tvalid rx_mxfe_tpl_core/link_valid

ad_connect rx_mxfe_tpl_core/adc_valid_0 util_mxfe_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_mxfe_tpl_core/adc_enable_$i util_mxfe_cpack/enable_$i
  ad_connect  rx_mxfe_tpl_core/adc_data_$i util_mxfe_cpack/fifo_wr_data_$i
}
ad_connect rx_mxfe_tpl_core/adc_dovf util_mxfe_cpack/fifo_wr_overflow

ad_connect  util_mxfe_cpack/packed_fifo_wr_data mxfe_adc_fifo/adc_wdata
ad_connect  util_mxfe_cpack/packed_fifo_wr_en mxfe_adc_fifo/adc_wr

ad_connect  mxfe_adc_fifo/dma_wr axi_mxfe_rx_dma/s_axis_valid
ad_connect  mxfe_adc_fifo/dma_wdata axi_mxfe_rx_dma/s_axis_data
ad_connect  mxfe_adc_fifo/dma_wready axi_mxfe_rx_dma/s_axis_ready
ad_connect  mxfe_adc_fifo/dma_xfer_req axi_mxfe_rx_dma/s_axis_xfer_req

# connect dac dataflow
#
if {$ADI_PHY_SEL == 0} {
# Tx Physical lanes to PHY
#
for {set i 0} {$i < $MAX_TX_LANES} {incr i} {
  ad_ip_instance xlslice txp_out_slice_$i [list \
    DIN_TO [expr $i % 4] \
    DIN_FROM [expr $i % 4] \
    DIN_WIDTH {4} \
    DOUT_WIDTH {1} \
  ]
  ad_ip_instance xlslice txn_out_slice_$i [list \
    DIN_TO [expr $i % 4] \
    DIN_FROM [expr $i % 4] \
    DIN_WIDTH {4} \
    DOUT_WIDTH {1} \
  ]
}

for {set i 0} {$i < 4} {incr i} {
  ad_connect  jesd204_phy_121/txn_out  txn_out_slice_$i/Din
  ad_connect  jesd204_phy_121/txp_out  txp_out_slice_$i/Din
  ad_connect  jesd204_phy_126/txn_out  txn_out_slice_[expr $i+4]/Din
  ad_connect  jesd204_phy_126/txp_out  txp_out_slice_[expr $i+4]/Din
}

for {set i 0} {$i < $MAX_TX_LANES} {incr i} {
  ad_connect  txn_out_slice_$i/Dout tx_data_${i}_n
  ad_connect  txp_out_slice_$i/Dout tx_data_${i}_p
}

# Tx connect PHY to Link Layer
set logic_lane(0) jesd204_phy_121/gt0_tx
set logic_lane(1) jesd204_phy_121/gt1_tx
set logic_lane(2) jesd204_phy_121/gt2_tx
set logic_lane(3) jesd204_phy_121/gt3_tx
set logic_lane(4) jesd204_phy_126/gt0_tx
set logic_lane(5) jesd204_phy_126/gt1_tx
set logic_lane(6) jesd204_phy_126/gt2_tx
set logic_lane(7) jesd204_phy_126/gt3_tx
for {set j 0}  {$j < $TX_NUM_OF_LANES} {incr j} {
 ad_connect  axi_mxfe_tx_jesd/tx_phy$j $logic_lane($j)
}

ad_connect  tx_sysref_0  axi_mxfe_tx_jesd/sysref

}

# Connect Link Layer to Transport Layer
#
ad_connect  tx_mxfe_tpl_core/link axi_mxfe_tx_jesd/tx_data

ad_connect  tx_mxfe_tpl_core/dac_valid_0 util_mxfe_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_mxfe_upack/fifo_rd_data_$i tx_mxfe_tpl_core/dac_data_$i
  ad_connect  tx_mxfe_tpl_core/dac_enable_$i  util_mxfe_upack/enable_$i
}

# TODO: Add streaming AXI interface for DAC FIFO
ad_connect  util_mxfe_upack/s_axis_valid VCC
ad_connect  util_mxfe_upack/s_axis_ready mxfe_dac_fifo/dac_valid
ad_connect  util_mxfe_upack/s_axis_data mxfe_dac_fifo/dac_data

ad_connect  mxfe_dac_fifo/dma_valid axi_mxfe_tx_dma/m_axis_valid
ad_connect  mxfe_dac_fifo/dma_data axi_mxfe_tx_dma/m_axis_data
ad_connect  mxfe_dac_fifo/dma_ready axi_mxfe_tx_dma/m_axis_ready
ad_connect  mxfe_dac_fifo/dma_xfer_req axi_mxfe_tx_dma/m_axis_xfer_req
ad_connect  mxfe_dac_fifo/dma_xfer_last axi_mxfe_tx_dma/m_axis_last
ad_connect  mxfe_dac_fifo/dac_dunf tx_mxfe_tpl_core/dac_dunf

create_bd_port -dir I dac_fifo_bypass
ad_connect  mxfe_dac_fifo/bypass dac_fifo_bypass

# interconnect (cpu)
if {$ADI_PHY_SEL == 1} {
ad_cpu_interconnect 0x44a60000 axi_mxfe_rx_xcvr
ad_cpu_interconnect 0x44b60000 axi_mxfe_tx_xcvr
} else {
ad_cpu_interconnect 0x44a60000 jesd204_phy_121
ad_cpu_interconnect 0x44b60000 jesd204_phy_126
}
ad_cpu_interconnect 0x44a10000 rx_mxfe_tpl_core
ad_cpu_interconnect 0x44b10000 tx_mxfe_tpl_core
ad_cpu_interconnect 0x44a90000 axi_mxfe_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_mxfe_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_mxfe_rx_dma
ad_cpu_interconnect 0x7c430000 axi_mxfe_tx_dma

# interconnect (gt/adc)

if {$ADI_PHY_SEL == 1} {
ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_xcvr/m_axi
}

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_mxfe_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_mxfe_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_mxfe_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_mxfe_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_mxfe_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_mxfe_tx_jesd/irq

if {$ADI_PHY_SEL == 1} {
# Create dummy outputs for unused Tx lanes
for {set i $TX_NUM_OF_LANES} {$i < 8} {incr i} {
  create_bd_port -dir O tx_data_${i}_n
  create_bd_port -dir O tx_data_${i}_p
}
# Create dummy outputs for unused Rx lanes
for {set i $RX_NUM_OF_LANES} {$i < 8} {incr i} {
  create_bd_port -dir I rx_data_${i}_n
  create_bd_port -dir I rx_data_${i}_p
}
}
