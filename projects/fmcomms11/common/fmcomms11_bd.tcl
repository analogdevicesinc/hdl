###############################################################################
## Copyright (C) 2019-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

# JESD204 TX parameters
set TX_NUM_OF_LANES 8      ; # L
set TX_NUM_OF_CONVERTERS 2 ; # M
set TX_SAMPLES_PER_FRAME 2 ; # S
set TX_SAMPLE_WIDTH 16     ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr [expr $TX_NUM_OF_LANES * 32 ] / \
                                 [expr $TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH]] ; # L * 32 / (M * N)

# JESD204 RX parameters
set RX_NUM_OF_LANES 8      ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 4 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

# Data path attributes

set adc_offload_name ad9625_data_offload
set adc_data_width 256
set adc_dma_data_width 256

set dac_offload_name ad9162_data_offload
set dac_data_width 256
set dac_dma_data_width 256

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9162_xcvr [list \
  NUM_OF_LANES 8 \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 1 \
]

# create tx link layer with 8 lanes

adi_axi_jesd204_tx_create axi_ad9162_jesd 8

adi_tpl_jesd204_tx_create axi_ad9162_core $TX_NUM_OF_LANES \
                                          $TX_NUM_OF_CONVERTERS \
                                          $TX_SAMPLES_PER_FRAME \
                                          $TX_SAMPLE_WIDTH

ad_ip_instance util_upack2 util_ad9162_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9162_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  ID 1 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC 64 \
  DMA_DATA_WIDTH_DEST $dac_dma_data_width \
]

ad_data_offload_create $dac_offload_name \
                       1 \
                       $dac_offload_type \
                       $dac_offload_size \
                       $dac_dma_data_width \
                       $dac_data_width \
                       $plddr_offload_axi_data_width

ad_ip_parameter $dac_offload_name/i_data_offload CONFIG.HAS_BYPASS 0
ad_ip_parameter $dac_offload_name/i_data_offload CONFIG.SYNC_EXT_ADD_INTERNAL_CDC 0
ad_connect $dac_offload_name/sync_ext GND

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9625_xcvr [list \
  NUM_OF_LANES 8 \
  QPLL_ENABLE 0 \
  TX_OR_RX_N 0 \
]

adi_tpl_jesd204_rx_create axi_ad9625_core $RX_NUM_OF_LANES \
                                          $RX_NUM_OF_CONVERTERS \
                                          $RX_SAMPLES_PER_FRAME \
                                          $RX_SAMPLE_WIDTH

# create rx link layer with 8 lanes

adi_axi_jesd204_rx_create axi_ad9625_jesd 8

ad_ip_instance axi_dmac axi_ad9625_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  ID 0 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC $adc_dma_data_width \
  DMA_DATA_WIDTH_DEST 64 \
]

ad_data_offload_create $adc_offload_name \
                       0 \
                       $adc_offload_type \
                       $adc_offload_size \
                       $adc_data_width \
                       $adc_dma_data_width \
                       $plddr_offload_axi_data_width

ad_ip_parameter $adc_offload_name/i_data_offload CONFIG.HAS_BYPASS 0
ad_ip_parameter $adc_offload_name/i_data_offload CONFIG.SYNC_EXT_ADD_INTERNAL_CDC 0
ad_connect $adc_offload_name/sync_ext GND

# shared transceiver core

ad_ip_instance util_adxcvr util_fmcomms11_xcvr [list \
  QPLL_FBDIV 0x120 \
  CPLL_FBDIV 4 \
  TX_NUM_OF_LANES 8 \
  TX_CLK25_DIV 7 \
  RX_NUM_OF_LANES 8 \
  RX_CLK25_DIV 7 \
  RX_DFE_LPM_CFG 0x0904 \
  RX_CDR_CFG 0x03000023ff10400020 \
]

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_fmcomms11_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcomms11_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9162_xcvr/up_pll_rst util_fmcomms11_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcomms11_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_fmcomms11_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_fmcomms11_xcvr/up_clk

# connections (dac)
# lane mapping {0 1 2 3 4 5 6 7}

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9162_xcvr axi_ad9162_jesd
ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 axi_ad9162_core/link_clk
ad_connect  axi_ad9162_jesd/tx_data axi_ad9162_core/link

ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 util_ad9162_upack/clk
ad_connect  axi_ad9162_jesd_rstgen/peripheral_reset util_ad9162_upack/reset

ad_connect  axi_ad9162_core/dac_valid_0 util_ad9162_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  util_ad9162_upack/fifo_rd_data_$i axi_ad9162_core/dac_data_$i
  ad_connect  axi_ad9162_core/dac_enable_$i  util_ad9162_upack/enable_$i
}

ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 $dac_offload_name/m_axis_aclk
ad_connect  axi_ad9162_jesd_rstgen/peripheral_aresetn $dac_offload_name/m_axis_aresetn
ad_connect  $sys_cpu_clk $dac_offload_name/s_axis_aclk
ad_connect  $sys_cpu_resetn $dac_offload_name/s_axis_aresetn
ad_connect  $sys_cpu_clk axi_ad9162_dma/m_axis_aclk
ad_connect  $sys_cpu_resetn axi_ad9162_dma/m_src_axi_aresetn

ad_connect  util_ad9162_upack/s_axis $dac_offload_name/m_axis
ad_connect  axi_ad9162_core/dac_dunf util_ad9162_upack/fifo_rd_underflow

ad_connect  $dac_offload_name/s_axis axi_ad9162_dma/m_axis
ad_connect  $dac_offload_name/init_req axi_ad9162_dma/m_axis_xfer_req

# connections (adc)
# rx lane mapping {0 1 2 3 4 5 6 7}

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9625_xcvr axi_ad9625_jesd
ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 axi_ad9625_core/link_clk

ad_connect  axi_ad9625_jesd/rx_sof axi_ad9625_core/link_sof
ad_connect  axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/link_data
ad_connect  axi_ad9625_jesd/rx_data_tvalid axi_ad9625_core/link_valid

ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 $adc_offload_name/s_axis_aclk
ad_connect  axi_ad9625_jesd_rstgen/peripheral_aresetn $adc_offload_name/s_axis_aresetn

ad_connect  axi_ad9625_core/adc_valid_0 $adc_offload_name/s_axis_tvalid
ad_connect  axi_ad9625_core/adc_data_0 $adc_offload_name/s_axis_tdata
ad_connect  axi_ad9625_core/adc_dovf GND

ad_connect  $adc_offload_name/s_axis_tlast GND
ad_connect  $adc_offload_name/s_axis_tkeep VCC

ad_connect  $sys_cpu_clk $adc_offload_name/m_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  $sys_cpu_resetn $adc_offload_name/m_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn

ad_connect  $adc_offload_name/m_axis axi_ad9625_dma/s_axis
ad_connect  $adc_offload_name/init_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9162_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9162_core
ad_cpu_interconnect 0x44A90000 axi_ad9162_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9162_dma
ad_cpu_interconnect 0x7c430000 $dac_offload_name
ad_cpu_interconnect 0x44A50000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9625_dma
ad_cpu_interconnect 0x7c410000 $adc_offload_name

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9625_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9162_dma/m_src_axi
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9162_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9162_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9625_dma/irq

