###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir I ref_clk_c
create_bd_port -dir I ref_clk_d

create_bd_port -dir I core_clk_c
create_bd_port -dir I core_clk_d

create_bd_port -dir I dac_fifo_bypass

#
# Parameter description:
#   [TX/RX/RX_OS]_JESD_M  : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L  : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S  : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#

set MAX_TX_NUM_OF_LANES 8
set MAX_RX_NUM_OF_LANES 4
set MAX_RX_OS_NUM_OF_LANES 4

set DATAPATH_WIDTH 4
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# TX parameters
set TX_NUM_OF_LANES $ad_project_params(TX_JESD_L)      ; # L
set TX_NUM_OF_CONVERTERS $ad_project_params(TX_JESD_M) ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S) ; # S
set TX_SAMPLE_WIDTH 16                                 ; # N/NP

set TX_TPL_WIDTH [ expr { [info exists ad_project_params(TX_TPL_WIDTH)] \
                          ? $ad_project_params(TX_TPL_WIDTH) : {} } ]

set TX_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $TX_NUM_OF_LANES $TX_NUM_OF_CONVERTERS $TX_SAMPLES_PER_FRAME $TX_SAMPLE_WIDTH $TX_TPL_WIDTH]
set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8 * $TX_DATAPATH_WIDTH / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)      ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M) ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S) ; # S
set RX_SAMPLE_WIDTH 16                                 ; # N/NP

set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8 * $RX_NUM_OF_LANES)] ; # F
set DPW [expr max(4, $RX_OCTETS_PER_FRAME)] ; #max(4, F)
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $DPW / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 8 * DPW / (M* N)

set adc_dma_data_width [expr $RX_NUM_OF_LANES * 8 * $DPW]

# RX Observation parameters
set RX_OS_NUM_OF_LANES $ad_project_params(RX_OS_JESD_L)      ; # L
set RX_OS_NUM_OF_CONVERTERS $ad_project_params(RX_OS_JESD_M) ; # M
set RX_OS_SAMPLES_PER_FRAME $ad_project_params(RX_OS_JESD_S) ; # S
set RX_OS_SAMPLE_WIDTH 16                                    ; # N/NP

set RX_OS_TPL_WIDTH [ expr { [info exists ad_project_params(RX_OS_TPL_WIDTH)] \
                          ? $ad_project_params(RX_OS_TPL_WIDTH) : {} } ]

set RX_OS_DATAPATH_WIDTH [adi_jesd204_calc_tpl_width $DATAPATH_WIDTH $RX_OS_NUM_OF_LANES $RX_OS_NUM_OF_CONVERTERS $RX_OS_SAMPLES_PER_FRAME $RX_OS_SAMPLE_WIDTH $RX_OS_TPL_WIDTH]
set RX_OS_SAMPLES_PER_CHANNEL [expr $RX_OS_NUM_OF_LANES * 8 * $RX_OS_DATAPATH_WIDTH / ($RX_OS_NUM_OF_CONVERTERS * $RX_OS_SAMPLE_WIDTH)]

set dac_fifo_name axi_adrv9009_fmc_tx_fifo
set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_data_width $dac_fifo_address_width

ad_ip_instance axi_adxcvr axi_adrv9009_fmc_tx_xcvr
ad_ip_parameter axi_adrv9009_fmc_tx_xcvr CONFIG.NUM_OF_LANES $MAX_TX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_fmc_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_adrv9009_fmc_tx_xcvr CONFIG.TX_OR_RX_N 1

adi_axi_jesd204_tx_create axi_adrv9009_fmc_tx_jesd $TX_NUM_OF_LANES
set_property -dict [list CONFIG.SYSREF_IOB {false}] [get_bd_cells axi_adrv9009_fmc_tx_jesd/tx]

ad_ip_instance util_upack2 util_fmc_tx_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

adi_tpl_jesd204_tx_create tx_adrv9009_fmc_tpl_core $TX_NUM_OF_LANES \
                                               $TX_NUM_OF_CONVERTERS \
                                               $TX_SAMPLES_PER_FRAME \
                                               $TX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9009_fmc_tx_dma
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_data_width
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_fmc_tx_dma CONFIG.MAX_BYTES_PER_BURST 512

ad_ip_instance axi_adxcvr axi_adrv9009_fmc_rx_xcvr
ad_ip_parameter axi_adrv9009_fmc_rx_xcvr CONFIG.NUM_OF_LANES $MAX_RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_fmc_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_fmc_rx_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_adrv9009_fmc_rx_jesd $RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_fmc_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_adrv9009_fmc_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $DPW

ad_ip_instance util_cpack2 util_fmc_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_adrv9009_fmc_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9009_fmc_rx_dma
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_adrv9009_fmc_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance axi_adxcvr axi_adrv9009_fmc_obs_xcvr
ad_ip_parameter axi_adrv9009_fmc_obs_xcvr CONFIG.NUM_OF_LANES $MAX_RX_OS_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_fmc_obs_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_fmc_obs_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_adrv9009_fmc_obs_jesd  $RX_OS_NUM_OF_LANES

ad_ip_instance util_cpack2 util_fmc_obs_cpack [list \
  NUM_OF_CHANNELS $RX_OS_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_OS_SAMPLES_PER_CHANNEL\
  SAMPLE_DATA_WIDTH $RX_OS_SAMPLE_WIDTH \
]

adi_tpl_jesd204_rx_create obs_adrv9009_fmc_tpl_core $RX_OS_NUM_OF_LANES \
                                                  $RX_OS_NUM_OF_CONVERTERS \
                                                  $RX_OS_SAMPLES_PER_FRAME \
                                                  $RX_OS_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9009_fmc_obs_dma
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_OS_NUM_OF_LANES]
ad_ip_parameter axi_adrv9009_fmc_obs_dma CONFIG.DMA_DATA_WIDTH_DEST 128

ad_ip_instance util_adxcvr util_adrv9009_fmc_xcvr
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.RX_NUM_OF_LANES [expr $MAX_RX_NUM_OF_LANES+$MAX_RX_OS_NUM_OF_LANES]
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.TX_NUM_OF_LANES $MAX_TX_NUM_OF_LANES
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.TX_OUT_DIV 2
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_fmc_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/qpll_ref_clk_0
ad_xcvrpll  ref_clk_d util_adrv9009_fmc_xcvr/cpll_ref_clk_0
ad_xcvrpll  ref_clk_d util_adrv9009_fmc_xcvr/cpll_ref_clk_1
ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/cpll_ref_clk_2
ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/cpll_ref_clk_3
ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/qpll_ref_clk_4
ad_xcvrpll  ref_clk_d util_adrv9009_fmc_xcvr/cpll_ref_clk_4
ad_xcvrpll  ref_clk_d util_adrv9009_fmc_xcvr/cpll_ref_clk_5
ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/cpll_ref_clk_6
ad_xcvrpll  ref_clk_c util_adrv9009_fmc_xcvr/cpll_ref_clk_7

ad_xcvrpll  axi_adrv9009_fmc_tx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_qpll_rst_0
ad_xcvrpll  axi_adrv9009_fmc_rx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_0
ad_xcvrpll  axi_adrv9009_fmc_rx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_1
ad_xcvrpll  axi_adrv9009_fmc_obs_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_2
ad_xcvrpll  axi_adrv9009_fmc_obs_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_3
ad_xcvrpll  axi_adrv9009_fmc_tx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_qpll_rst_4
ad_xcvrpll  axi_adrv9009_fmc_rx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_4
ad_xcvrpll  axi_adrv9009_fmc_rx_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_5
ad_xcvrpll  axi_adrv9009_fmc_obs_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_6
ad_xcvrpll  axi_adrv9009_fmc_obs_xcvr/up_pll_rst util_adrv9009_fmc_xcvr/up_cpll_rst_7
ad_connect  $sys_cpu_resetn util_adrv9009_fmc_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_adrv9009_fmc_xcvr/up_clk

# Tx
if {$TX_NUM_OF_LANES == 8} {
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_tx_xcvr axi_adrv9009_fmc_tx_jesd {1 0 2 3 4 5 6 7} core_clk_c
} else {
    if {$TX_NUM_OF_LANES == 4} {
  #TX_JESD_L=4, it is recommanded to use RX_OS_JESD_M=TX_JESD_M because they share the same device clock
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_tx_xcvr axi_adrv9009_fmc_tx_jesd {1 0 2 3 4 5 6 7} core_clk_c {} $MAX_TX_NUM_OF_LANES {1 0 4 5}
    } else {
      ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_tx_xcvr axi_adrv9009_fmc_tx_jesd {1 0 2 3 4 5 6 7} core_clk_c {} $MAX_TX_NUM_OF_LANES {1 4}
    }
}

# Rx
if {$RX_NUM_OF_LANES == 4} {
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_rx_xcvr axi_adrv9009_fmc_rx_jesd {0 1 4 5} core_clk_d
} else {
  # for RX_JESD_L=2, RX_OCTETS_PER_FRAME = 8
  # {0 1 4 5} are the lanes for rx
  ad_connect adrv9009_fmc_rx_link_clk util_adrv9009_fmc_xcvr/rx_out_clk_0
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_rx_xcvr axi_adrv9009_fmc_rx_jesd {0 1 2 3 4 5 6 7} adrv9009_fmc_rx_link_clk core_clk_d $MAX_RX_NUM_OF_LANES {0 4} 0
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_es_0 util_adrv9009_fmc_xcvr/up_es_0
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_es_1 util_adrv9009_fmc_xcvr/up_es_1
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_es_2 util_adrv9009_fmc_xcvr/up_es_4
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_es_3 util_adrv9009_fmc_xcvr/up_es_5
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_ch_0 util_adrv9009_fmc_xcvr/up_rx_0
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_ch_1 util_adrv9009_fmc_xcvr/up_rx_1
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_ch_2 util_adrv9009_fmc_xcvr/up_rx_4
  ad_connect axi_adrv9009_fmc_rx_xcvr/up_ch_3 util_adrv9009_fmc_xcvr/up_rx_5

  ad_connect adrv9009_fmc_rx_link_clk util_adrv9009_fmc_xcvr/rx_clk_0
  ad_connect adrv9009_fmc_rx_link_clk util_adrv9009_fmc_xcvr/rx_clk_1
  ad_connect adrv9009_fmc_rx_link_clk util_adrv9009_fmc_xcvr/rx_clk_4
  ad_connect adrv9009_fmc_rx_link_clk util_adrv9009_fmc_xcvr/rx_clk_5

  create_bd_port -dir I rx_data_0_p
  create_bd_port -dir I rx_data_0_n
  create_bd_port -dir I rx_data_1_p
  create_bd_port -dir I rx_data_1_n
  create_bd_port -dir I rx_data_4_p
  create_bd_port -dir I rx_data_4_n
  create_bd_port -dir I rx_data_5_p
  create_bd_port -dir I rx_data_5_n
  ad_connect util_adrv9009_fmc_xcvr/rx_0_p rx_data_0_p
  ad_connect util_adrv9009_fmc_xcvr/rx_0_n rx_data_0_n
  ad_connect util_adrv9009_fmc_xcvr/rx_1_p rx_data_1_p
  ad_connect util_adrv9009_fmc_xcvr/rx_1_n rx_data_1_n
  ad_connect util_adrv9009_fmc_xcvr/rx_4_p rx_data_4_p
  ad_connect util_adrv9009_fmc_xcvr/rx_4_n rx_data_4_n
  ad_connect util_adrv9009_fmc_xcvr/rx_5_p rx_data_5_p
  ad_connect util_adrv9009_fmc_xcvr/rx_5_n rx_data_5_n
}

# Rx - Obs
if {$RX_OS_NUM_OF_LANES == 4} {
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_obs_xcvr axi_adrv9009_fmc_obs_jesd {2 3 6 7} core_clk_c
} else {
  # ORX_JESD_L=2
  # {2 3 6 7} are the lanes for orx
  ad_xcvrcon  util_adrv9009_fmc_xcvr axi_adrv9009_fmc_obs_xcvr axi_adrv9009_fmc_obs_jesd {0 1 2 3 4 5 6 7} core_clk_c {} $MAX_RX_OS_NUM_OF_LANES {2 6} 0
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_es_0 util_adrv9009_fmc_xcvr/up_es_2
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_es_1 util_adrv9009_fmc_xcvr/up_es_3
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_es_2 util_adrv9009_fmc_xcvr/up_es_6
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_es_3 util_adrv9009_fmc_xcvr/up_es_7
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_ch_0 util_adrv9009_fmc_xcvr/up_rx_2
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_ch_1 util_adrv9009_fmc_xcvr/up_rx_3
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_ch_2 util_adrv9009_fmc_xcvr/up_rx_6
  ad_connect axi_adrv9009_fmc_obs_xcvr/up_ch_3 util_adrv9009_fmc_xcvr/up_rx_7

  ad_connect core_clk_c util_adrv9009_fmc_xcvr/rx_clk_2
  ad_connect core_clk_c util_adrv9009_fmc_xcvr/rx_clk_3
  ad_connect core_clk_c util_adrv9009_fmc_xcvr/rx_clk_6
  ad_connect core_clk_c util_adrv9009_fmc_xcvr/rx_clk_7

  create_bd_port -dir I rx_data_2_p
  create_bd_port -dir I rx_data_2_n
  create_bd_port -dir I rx_data_3_p
  create_bd_port -dir I rx_data_3_n
  create_bd_port -dir I rx_data_6_p
  create_bd_port -dir I rx_data_6_n
  create_bd_port -dir I rx_data_7_p
  create_bd_port -dir I rx_data_7_n
  ad_connect util_adrv9009_fmc_xcvr/rx_2_p rx_data_2_p
  ad_connect util_adrv9009_fmc_xcvr/rx_2_n rx_data_2_n
  ad_connect util_adrv9009_fmc_xcvr/rx_3_p rx_data_3_p
  ad_connect util_adrv9009_fmc_xcvr/rx_3_n rx_data_3_n
  ad_connect util_adrv9009_fmc_xcvr/rx_6_p rx_data_6_p
  ad_connect util_adrv9009_fmc_xcvr/rx_6_n rx_data_6_n
  ad_connect util_adrv9009_fmc_xcvr/rx_7_p rx_data_7_p
  ad_connect util_adrv9009_fmc_xcvr/rx_7_n rx_data_7_n
}

ad_connect  core_clk_c tx_adrv9009_fmc_tpl_core/link_clk
ad_connect  axi_adrv9009_fmc_tx_jesd/tx_data tx_adrv9009_fmc_tpl_core/link

ad_connect  core_clk_c util_fmc_tx_upack/clk
ad_connect  core_clk_c_rstgen/peripheral_reset util_fmc_tx_upack/reset

ad_connect  tx_adrv9009_fmc_tpl_core/dac_valid_0 util_fmc_tx_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_fmc_tx_upack/fifo_rd_data_$i tx_adrv9009_fmc_tpl_core/dac_data_$i
  ad_connect  tx_adrv9009_fmc_tpl_core/dac_enable_$i  util_fmc_tx_upack/enable_$i
}

ad_connect tx_adrv9009_fmc_tpl_core/dac_dunf util_fmc_tx_upack/fifo_rd_underflow

ad_connect  core_clk_c axi_adrv9009_fmc_tx_fifo/dac_clk
ad_connect  core_clk_c_rstgen/peripheral_reset axi_adrv9009_fmc_tx_fifo/dac_rst

ad_connect  util_fmc_tx_upack/s_axis_valid VCC
ad_connect  util_fmc_tx_upack/s_axis_ready axi_adrv9009_fmc_tx_fifo/dac_valid
ad_connect  util_fmc_tx_upack/s_axis_data axi_adrv9009_fmc_tx_fifo/dac_data

ad_connect  core_clk_c axi_adrv9009_fmc_tx_fifo/dma_clk
ad_connect  core_clk_c_rstgen/peripheral_reset axi_adrv9009_fmc_tx_fifo/dma_rst
ad_connect  core_clk_c axi_adrv9009_fmc_tx_dma/m_axis_aclk
ad_connect  axi_adrv9009_fmc_tx_fifo/dma_xfer_req axi_adrv9009_fmc_tx_dma/m_axis_xfer_req
ad_connect  axi_adrv9009_fmc_tx_fifo/dma_ready axi_adrv9009_fmc_tx_dma/m_axis_ready
ad_connect  axi_adrv9009_fmc_tx_fifo/dma_data axi_adrv9009_fmc_tx_dma/m_axis_data
ad_connect  axi_adrv9009_fmc_tx_fifo/dma_valid axi_adrv9009_fmc_tx_dma/m_axis_valid
ad_connect  axi_adrv9009_fmc_tx_fifo/dma_xfer_last axi_adrv9009_fmc_tx_dma/m_axis_last

ad_connect  axi_adrv9009_fmc_tx_fifo/bypass dac_fifo_bypass

ad_connect  core_clk_d rx_adrv9009_fmc_tpl_core/link_clk
ad_connect  axi_adrv9009_fmc_rx_jesd/rx_sof rx_adrv9009_fmc_tpl_core/link_sof
ad_connect  axi_adrv9009_fmc_rx_jesd/rx_data_tdata rx_adrv9009_fmc_tpl_core/link_data
ad_connect  axi_adrv9009_fmc_rx_jesd/rx_data_tvalid rx_adrv9009_fmc_tpl_core/link_valid
ad_connect  core_clk_d util_fmc_rx_cpack/clk
ad_connect  core_clk_d_rstgen/peripheral_reset util_fmc_rx_cpack/reset

ad_connect rx_adrv9009_fmc_tpl_core/adc_valid_0 util_fmc_rx_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_adrv9009_fmc_tpl_core/adc_enable_$i util_fmc_rx_cpack/enable_$i
  ad_connect  rx_adrv9009_fmc_tpl_core/adc_data_$i util_fmc_rx_cpack/fifo_wr_data_$i
}
ad_connect rx_adrv9009_fmc_tpl_core/adc_dovf util_fmc_rx_cpack/fifo_wr_overflow
ad_connect axi_adrv9009_fmc_rx_dma/fifo_wr util_fmc_rx_cpack/packed_fifo_wr
ad_connect core_clk_d axi_adrv9009_fmc_rx_dma/fifo_wr_clk

# connections (adc-os)

ad_connect  core_clk_c obs_adrv9009_fmc_tpl_core/link_clk
ad_connect  axi_adrv9009_fmc_obs_jesd/rx_sof obs_adrv9009_fmc_tpl_core/link_sof
ad_connect  axi_adrv9009_fmc_obs_jesd/rx_data_tdata obs_adrv9009_fmc_tpl_core/link_data
ad_connect  axi_adrv9009_fmc_obs_jesd/rx_data_tvalid obs_adrv9009_fmc_tpl_core/link_valid
ad_connect  core_clk_c util_fmc_obs_cpack/clk
ad_connect  core_clk_c_rstgen/peripheral_reset util_fmc_obs_cpack/reset
ad_connect  core_clk_c axi_adrv9009_fmc_obs_dma/fifo_wr_clk

ad_connect  obs_adrv9009_fmc_tpl_core/adc_valid_0 util_fmc_obs_cpack/fifo_wr_en
for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  obs_adrv9009_fmc_tpl_core/adc_enable_$i util_fmc_obs_cpack/enable_$i
  ad_connect  obs_adrv9009_fmc_tpl_core/adc_data_$i util_fmc_obs_cpack/fifo_wr_data_$i
}
ad_connect  obs_adrv9009_fmc_tpl_core/adc_dovf util_fmc_obs_cpack/fifo_wr_overflow
ad_connect  util_fmc_obs_cpack/packed_fifo_wr axi_adrv9009_fmc_obs_dma/fifo_wr


ad_cpu_interconnect 0x45A00000 rx_adrv9009_fmc_tpl_core
ad_cpu_interconnect 0x45A04000 tx_adrv9009_fmc_tpl_core
ad_cpu_interconnect 0x45A08000 obs_adrv9009_fmc_tpl_core
ad_cpu_interconnect 0x45A20000 axi_adrv9009_fmc_tx_xcvr
ad_cpu_interconnect 0x45A30000 axi_adrv9009_fmc_tx_jesd
ad_cpu_interconnect 0x45A40000 axi_adrv9009_fmc_rx_xcvr
ad_cpu_interconnect 0x45A50000 axi_adrv9009_fmc_rx_jesd
ad_cpu_interconnect 0x45A60000 axi_adrv9009_fmc_obs_xcvr
ad_cpu_interconnect 0x45A70000 axi_adrv9009_fmc_obs_jesd
ad_cpu_interconnect 0x7d400000 axi_adrv9009_fmc_tx_dma
ad_cpu_interconnect 0x7d420000 axi_adrv9009_fmc_rx_dma
ad_cpu_interconnect 0x7d440000 axi_adrv9009_fmc_obs_dma

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_adrv9009_fmc_rx_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_adrv9009_fmc_obs_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_dma_clk axi_adrv9009_fmc_tx_dma/m_src_axi
ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_adrv9009_fmc_rx_dma/m_dest_axi
ad_mem_hp3_interconnect $sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_dma_clk axi_adrv9009_fmc_obs_dma/m_dest_axi
ad_connect $sys_dma_resetn axi_adrv9009_fmc_rx_dma/m_dest_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9009_fmc_tx_dma/m_src_axi_aresetn
ad_connect $sys_dma_resetn axi_adrv9009_fmc_obs_dma/m_dest_axi_aresetn


ad_cpu_interrupt ps-8 mb-8 axi_adrv9009_fmc_obs_dma/irq
ad_cpu_interrupt ps-9 mb-9 axi_adrv9009_fmc_tx_dma/irq
ad_cpu_interrupt ps-10 mb-15 axi_adrv9009_fmc_rx_dma/irq
ad_cpu_interrupt ps-11 mb-14 axi_adrv9009_fmc_obs_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_adrv9009_fmc_tx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9009_fmc_rx_jesd/irq
