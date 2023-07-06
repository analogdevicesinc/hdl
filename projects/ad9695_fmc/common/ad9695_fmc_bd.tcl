###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)           ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M)      ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S)      ; # S
set RX_SAMPLE_WIDTH 16                                      ; # N/NP
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

set adc_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]
set adc_dma_data_width [expr $RX_SAMPLE_WIDTH * $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_CHANNEL]

# These are max values specific to the board
set MAX_RX_NUM_OF_LANES 4

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9695_rx_xcvr [list \
  NUM_OF_LANES $RX_NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 0 \
  SYS_CLK_SEL 3 \
  OUT_CLK_SEL 3 \
  ]

adi_axi_jesd204_rx_create axi_ad9695_rx_jesd $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9695_rx_jesd/rx CONFIG.SYSREF_IOB false

ad_ip_instance util_cpack2 util_ad9695_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_ad9695_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance axi_dmac axi_ad9695_rx_dma [list \
  DMA_TYPE_SRC 2 \
  DMA_TYPE_DEST 0 \
  CYCLIC 0 \
  SYNC_TRANSFER_START 0 \
  DMA_2D_TRANSFER 0 \
  FIFO_SIZE 32 \
  MAX_BYTES_PER_BURST 2048 \
  AXI_SLICE_DEST 1 \
  AXI_SLICE_SRC 1 \
  DMA_LENGTH_WIDTH 24 \
  DMA_DATA_WIDTH_DEST 128 \
  DMA_DATA_WIDTH_SRC $adc_dma_data_width \
  ]

# common cores
# fPLLClkin = 325 MHz => RX_CLK25_DIV = 13
# fPLLClkout = 13000 MHz - qpll0

ad_ip_instance util_adxcvr util_ad9695_xcvr [list \
  RX_NUM_OF_LANES $MAX_RX_NUM_OF_LANES \
  TX_NUM_OF_LANES 0 \
  QPLL_FBDIV 40 \
  QPLL_REFCLK_DIV 1 \
  RX_OUT_DIV 1 \
  RX_CLK25_DIV 13 \
  POR_CFG 0x0 \
  QPLL_CFG0 0x331c \
  QPLL_CFG1 0xd038 \
  QPLL_CFG1_G3 0xd038 \
  QPLL_CFG2 0xfc1 \
  QPLL_CFG2_G3 0xfc1 \
  QPLL_CFG3 0x120 \
  QPLL_CFG4 0x4 \
  QPLL_CP 0xff \
  QPLL_CP_G3 0xf \
  QPLL_LPF 0x33f \
  CH_HSPMUX 0x4444 \
  PREIQ_FREQ_BST 1 \
  RXPI_CFG0 0x104 \
  RXPI_CFG1 0x0 \
  RXCDR_CFG0 0x3 \
  RXCDR_CFG2_GEN2 0x265 \
  RXCDR_CFG2_GEN4 0x164 \
  RXCDR_CFG3 0x18 \
  RXCDR_CFG3_GEN2 0x18 \
  RXCDR_CFG3_GEN3 0x18 \
  RXCDR_CFG3_GEN4 0x12 \
  ]

# xcvr interfaces

set rx_ref_clk     rx_ref_clk_0

create_bd_port -dir I $rx_ref_clk
create_bd_port -dir I rx_core_clk_0

ad_connect  $sys_cpu_resetn util_ad9695_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_ad9695_xcvr/up_clk

# Rx
ad_connect ad9695_rx_device_clk rx_core_clk_0
ad_xcvrcon  util_ad9695_xcvr axi_ad9695_rx_xcvr axi_ad9695_rx_jesd {} ad9695_rx_device_clk {} $MAX_RX_NUM_OF_LANES
ad_xcvrpll $rx_ref_clk util_ad9695_xcvr/qpll_ref_clk_0
for {set i 0} {$i < $MAX_RX_NUM_OF_LANES} {incr i} {
  set ch [expr $i]
  ad_xcvrpll  $rx_ref_clk util_ad9695_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_ad9695_rx_xcvr/up_pll_rst util_ad9695_xcvr/up_cpll_rst_$ch
}

ad_xcvrpll  axi_ad9695_rx_xcvr/up_pll_rst util_ad9695_xcvr/up_qpll_rst_*

# connections (adc)

ad_connect $sys_cpu_resetn axi_ad9695_rx_dma/m_dest_axi_aresetn
ad_connect dma_clk_wiz/clk_out1 axi_ad9695_rx_dma/m_dest_axi_aclk
ad_connect util_ad9695_rx_cpack/packed_fifo_wr axi_ad9695_rx_dma/fifo_wr

ad_connect $sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect $sys_cpu_resetn dma_clk_wiz/resetn

ad_connect ad9695_rx_device_clk rx_ad9695_tpl_core/link_clk
ad_connect ad9695_rx_device_clk util_ad9695_rx_cpack/clk
ad_connect ad9695_rx_device_clk axi_ad9695_rx_dma/fifo_wr_clk
ad_connect ad9695_rx_device_clk_rstgen/peripheral_reset util_ad9695_rx_cpack/reset

ad_connect axi_ad9695_rx_jesd/rx_sof rx_ad9695_tpl_core/link_sof
ad_connect axi_ad9695_rx_jesd/rx_data_tdata rx_ad9695_tpl_core/link_data
ad_connect axi_ad9695_rx_jesd/rx_data_tvalid rx_ad9695_tpl_core/link_valid

ad_connect rx_ad9695_tpl_core/adc_valid_0 util_ad9695_rx_cpack/fifo_wr_en
ad_connect rx_ad9695_tpl_core/adc_dovf util_ad9695_rx_cpack/fifo_wr_overflow
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect rx_ad9695_tpl_core/adc_enable_$i util_ad9695_rx_cpack/enable_$i
  ad_connect rx_ad9695_tpl_core/adc_data_$i util_ad9695_rx_cpack/fifo_wr_data_$i
}

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_ad9695_tpl_core
ad_cpu_interconnect 0x44A60000 axi_ad9695_rx_xcvr
ad_cpu_interconnect 0x44AA0000 axi_ad9695_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9695_rx_dma

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9695_rx_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp2_interconnect dma_clk_wiz/clk_out1 sys_ps7/S_AXI_HP1
ad_mem_hp2_interconnect dma_clk_wiz/clk_out1 axi_ad9695_rx_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9695_rx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9695_rx_dma/irq

