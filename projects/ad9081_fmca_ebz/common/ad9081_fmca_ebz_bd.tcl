#
# Parameter description:
#   JESD_MODE : Used link layer encoder mode
#      64B66B - 64b66b link layer defined in JESD 204C
#      8B10B  - 8b10b link layer defined in JESD 204B
#
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_NP : Number of bits per sample
#   [RX/TX]_NUM_LINKS : Number of links, matches numer of MxFE devices
#

# Common parameter for TX and RX
set JESD_MODE  $ad_project_params(JESD_MODE)

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

set RX_JESD_F [expr ($RX_JESD_M*$RX_JESD_S*$RX_JESD_NP)/(8*$RX_JESD_L)]
# For F=3,6,12 use dual clock
if {$RX_JESD_F % 3 == 0} {
  set RX_DATAPATH_WIDTH [expr max($RX_JESD_F,$NP12_DATAPATH_WIDTH)]
} else {
  set RX_DATAPATH_WIDTH $DATAPATH_WIDTH
}

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

set TX_JESD_F [expr ($TX_JESD_M*$TX_JESD_S*$TX_JESD_NP)/(8*$TX_JESD_L)]
# For F=3,6,12 use dual clock
if {$TX_JESD_F % 3 == 0} {
  set TX_DATAPATH_WIDTH [expr max($TX_JESD_F,$NP12_DATAPATH_WIDTH)]
} else {
  set TX_DATAPATH_WIDTH $DATAPATH_WIDTH
}

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8* $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr $RX_DMA_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr $TX_DMA_SAMPLE_WIDTH*$TX_NUM_OF_CONVERTERS*$TX_SAMPLES_PER_CHANNEL]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]

create_bd_port -dir I rx_device_clk
create_bd_port -dir I tx_device_clk

# common xcvr
ad_ip_instance util_adxcvr util_mxfe_xcvr
ad_ip_parameter util_mxfe_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_mxfe_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_mxfe_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_mxfe_xcvr CONFIG.LINK_MODE $ENCODER_SEL

ad_ip_instance axi_adxcvr axi_mxfe_rx_xcvr
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.ID 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_mxfe_rx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

ad_ip_instance axi_adxcvr axi_mxfe_tx_xcvr
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.ID 0
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_mxfe_tx_xcvr CONFIG.SYS_CLK_SEL 0x3 ; # QPLL0

# adc peripherals

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
ad_ip_parameter axi_mxfe_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_SRC $dac_dma_data_width
ad_ip_parameter axi_mxfe_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width

# reference clocks & resets

create_bd_port -dir I ref_clk_q0
create_bd_port -dir I ref_clk_q1

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

ad_xcvrcon  util_mxfe_xcvr axi_mxfe_rx_xcvr axi_mxfe_rx_jesd {} {} rx_device_clk

# connections (dac)
ad_xcvrcon  util_mxfe_xcvr axi_mxfe_tx_xcvr axi_mxfe_tx_jesd {} {} tx_device_clk

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

#
# connect adc dataflow
#
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
ad_cpu_interconnect 0x44a60000 axi_mxfe_rx_xcvr
ad_cpu_interconnect 0x44b60000 axi_mxfe_tx_xcvr
ad_cpu_interconnect 0x44a10000 rx_mxfe_tpl_core
ad_cpu_interconnect 0x44b10000 tx_mxfe_tpl_core
ad_cpu_interconnect 0x44a90000 axi_mxfe_rx_jesd
ad_cpu_interconnect 0x44b90000 axi_mxfe_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_mxfe_rx_dma
ad_cpu_interconnect 0x7c430000 axi_mxfe_tx_dma

# interconnect (gt/adc)

ad_mem_hp0_interconnect $sys_cpu_clk axi_mxfe_rx_xcvr/m_axi
ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_mxfe_rx_dma/m_dest_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_mxfe_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-13 mb-12 axi_mxfe_rx_dma/irq
ad_cpu_interrupt ps-12 mb-13 axi_mxfe_tx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_mxfe_rx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_mxfe_tx_jesd/irq

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
