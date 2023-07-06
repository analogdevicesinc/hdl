###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
# Parameter description:
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame
#

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

# JESD204B interface configurations

set TX_NUM_OF_LANES $ad_project_params(TX_JESD_L)           ; # L
set TX_NUM_OF_CONVERTERS $ad_project_params(TX_JESD_M)      ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S)      ; # S
set TX_SAMPLE_WIDTH 16                                      ; # N/NP
set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

set dac_data_width [expr $TX_SAMPLE_WIDTH * $TX_NUM_OF_CONVERTERS * $TX_SAMPLES_PER_CHANNEL]

set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)           ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M)      ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S)      ; # S
set RX_SAMPLE_WIDTH 16                                      ; # N/NP
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]

set MAX_TX_NUM_OF_LANES 4
set MAX_RX_NUM_OF_LANES 4

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9144_xcvr [list \
  NUM_OF_LANES $TX_NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 1 \
]

adi_axi_jesd204_tx_create axi_ad9144_jesd $TX_NUM_OF_LANES

adi_tpl_jesd204_tx_create axi_ad9144_tpl $TX_NUM_OF_LANES \
                                         $TX_NUM_OF_CONVERTERS \
                                         $TX_SAMPLES_PER_FRAME \
                                         $TX_SAMPLE_WIDTH \

ad_ip_instance util_upack2 axi_ad9144_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9144_dma [list \
  DMA_TYPE_SRC 0 \
  DMA_TYPE_DEST 1 \
  ID 1 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC 128 \
  DMA_DATA_WIDTH_DEST $dac_data_width \
]

ad_data_offload_create axi_ad9144_offload \
                       1 \
                       $dac_offload_type \
                       $dac_offload_size \
                       $dac_data_width \
                       $dac_data_width \
                       $plddr_offload_axi_data_width

# synchronization interface
ad_connect axi_ad9144_offload/init_req axi_ad9144_dma/m_axis_xfer_req
ad_connect axi_ad9144_offload/sync_ext GND

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9680_xcvr [list \
  NUM_OF_LANES $RX_NUM_OF_LANES \
  QPLL_ENABLE 0 \
  TX_OR_RX_N 0 \
]

adi_axi_jesd204_rx_create axi_ad9680_jesd $RX_NUM_OF_LANES

adi_tpl_jesd204_rx_create axi_ad9680_tpl $RX_NUM_OF_LANES \
                                         $RX_NUM_OF_CONVERTERS \
                                         $RX_SAMPLES_PER_FRAME \
                                         $RX_SAMPLE_WIDTH
ad_ip_parameter axi_ad9680_tpl/adc_tpl_core CONFIG.CONVERTER_RESOLUTION 14
ad_ip_parameter axi_ad9680_tpl/adc_tpl_core CONFIG.TWOS_COMPLEMENT 0

ad_ip_instance util_cpack2 axi_ad9680_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9680_dma [list \
  DMA_TYPE_SRC 1 \
  DMA_TYPE_DEST 0 \
  ID 0 \
  AXI_SLICE_SRC 0 \
  AXI_SLICE_DEST 0 \
  SYNC_TRANSFER_START 0 \
  DMA_LENGTH_WIDTH 24 \
  DMA_2D_TRANSFER 0 \
  CYCLIC 0 \
  DMA_DATA_WIDTH_SRC $adc_data_width \
  DMA_DATA_WIDTH_DEST 64 \
]

ad_data_offload_create axi_ad9680_offload \
                       0 \
                       $adc_offload_type \
                       $adc_offload_size \
                       $adc_data_width \
                       $adc_data_width \
                       $plddr_offload_axi_data_width

# synchronization interface
ad_connect axi_ad9680_offload/init_req axi_ad9680_dma/s_axis_xfer_req
ad_connect axi_ad9680_offload/sync_ext GND

# shared transceiver core

ad_ip_instance util_adxcvr util_daq2_xcvr [list \
  RX_NUM_OF_LANES $MAX_RX_NUM_OF_LANES \
  TX_NUM_OF_LANES $MAX_TX_NUM_OF_LANES \
  QPLL_REFCLK_DIV 1 \
  QPLL_FBDIV_RATIO 1 \
  QPLL_FBDIV 0x30 \
  RX_OUT_DIV 1 \
  TX_OUT_DIV 1 \
  RX_DFE_LPM_CFG 0x0104 \
  RX_CDR_CFG 0x0B000023FF10400020 \
]

ad_connect  $sys_cpu_resetn util_daq2_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_daq2_xcvr/up_clk

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_daq2_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_daq2_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9144_xcvr/up_pll_rst util_daq2_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_daq2_xcvr/up_cpll_rst_*

# connections (dac)

ad_xcvrcon  util_daq2_xcvr axi_ad9144_xcvr axi_ad9144_jesd {0 2 3 1} {} {} $MAX_TX_NUM_OF_LANES
ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_tpl/link_clk
ad_connect  axi_ad9144_jesd/tx_data axi_ad9144_tpl/link
ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_upack/clk
ad_connect  axi_ad9144_jesd_rstgen/peripheral_reset axi_ad9144_upack/reset
ad_connect  axi_ad9144_tpl/dac_dunf axi_ad9144_upack/fifo_rd_underflow

ad_connect  axi_ad9144_tpl/dac_valid_0 axi_ad9144_upack/fifo_rd_en
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  axi_ad9144_tpl/dac_enable_$i axi_ad9144_upack/enable_$i
  ad_connect  axi_ad9144_tpl/dac_data_$i axi_ad9144_upack/fifo_rd_data_$i
}

ad_connect  $sys_cpu_clk axi_ad9144_offload/s_axi_aclk
ad_connect  util_daq2_xcvr/tx_out_clk_0 axi_ad9144_offload/m_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9144_offload/s_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9144_dma/m_axis_aclk

ad_connect  $sys_cpu_resetn axi_ad9144_offload/s_axi_aresetn
ad_connect  axi_ad9144_jesd_rstgen/peripheral_aresetn axi_ad9144_offload/m_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9144_offload/s_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9144_dma/m_src_axi_aresetn

ad_connect axi_ad9144_upack/s_axis axi_ad9144_offload/m_axis
ad_connect axi_ad9144_offload/s_axis axi_ad9144_dma/m_axis

# connections (adc)

ad_xcvrcon  util_daq2_xcvr axi_ad9680_xcvr axi_ad9680_jesd {} {} {} $MAX_RX_NUM_OF_LANES
ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_tpl/link_clk
ad_connect  axi_ad9680_jesd/rx_sof axi_ad9680_tpl/link_sof
ad_connect  axi_ad9680_jesd/rx_data_tdata axi_ad9680_tpl/link_data
ad_connect  axi_ad9680_jesd/rx_data_tvalid axi_ad9680_tpl/link_valid

ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_cpack/clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_cpack/reset

ad_connect  axi_ad9680_tpl/adc_valid_0 axi_ad9680_cpack/fifo_wr_en
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  axi_ad9680_tpl/adc_enable_$i axi_ad9680_cpack/enable_$i
  ad_connect  axi_ad9680_tpl/adc_data_$i axi_ad9680_cpack/fifo_wr_data_$i
}
ad_connect  axi_ad9680_tpl/adc_dovf axi_ad9680_cpack/fifo_wr_overflow

ad_connect  $sys_cpu_clk axi_ad9680_offload/s_axi_aclk
ad_connect  util_daq2_xcvr/rx_out_clk_0 axi_ad9680_offload/s_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9680_offload/m_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9680_dma/s_axis_aclk

ad_connect  $sys_cpu_resetn axi_ad9680_offload/s_axi_aresetn
ad_connect  axi_ad9680_jesd_rstgen/peripheral_aresetn axi_ad9680_offload/s_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  $sys_cpu_resetn axi_ad9680_offload/m_axis_aresetn

ad_connect  axi_ad9680_cpack/packed_fifo_wr_en axi_ad9680_offload/i_data_offload/s_axis_valid
ad_connect  axi_ad9680_cpack/packed_fifo_wr_data axi_ad9680_offload/i_data_offload/s_axis_data

ad_connect axi_ad9680_offload/m_axis axi_ad9680_dma/s_axis

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9144_xcvr
ad_cpu_interconnect 0x44A04000 axi_ad9144_tpl
ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9144_dma
ad_cpu_interconnect 0x7c440000 axi_ad9144_offload
ad_cpu_interconnect 0x44A50000 axi_ad9680_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9680_tpl
ad_cpu_interconnect 0x44AA0000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma
ad_cpu_interconnect 0x7c460000 axi_ad9680_offload

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9680_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9144_dma/m_src_axi
ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9144_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9680_jesd/irq
ad_cpu_interrupt ps-12 mb-13 axi_ad9144_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq
