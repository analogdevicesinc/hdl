###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# RX parameters
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)           ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M)      ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S)      ; # S
set RX_SAMPLE_WIDTH 16                                      ; # N/NP

set RX_OCTETS_PER_FRAME [expr $RX_NUM_OF_CONVERTERS * $RX_SAMPLES_PER_FRAME * $RX_SAMPLE_WIDTH / (8*$RX_NUM_OF_LANES)] ; # F
set DPW [expr max(4,$RX_OCTETS_PER_FRAME)] ;# max(4,F)
set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8 * $DPW / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 8* DPW /

set adc_dma_data_width [expr $RX_NUM_OF_LANES * 8 * $DPW]

# adc peripherals
# rx_out_clk = ref_clk
# qpll0 selected

ad_ip_instance axi_adxcvr axi_ad9083_rx_xcvr [list \
  NUM_OF_LANES $RX_NUM_OF_LANES \
  QPLL_ENABLE 1 \
  TX_OR_RX_N 0 \
  SYS_CLK_SEL 3 \
  OUT_CLK_SEL 4 \
  ]

adi_axi_jesd204_rx_create axi_ad9083_rx_jesd $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9083_rx_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_ad9083_rx_jesd/rx CONFIG.TPL_DATA_PATH_WIDTH $DPW

ad_ip_instance util_cpack2 util_ad9083_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_ad9083_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_ad9083_rx_dma [list \
  DMA_TYPE_SRC 2 \
  DMA_TYPE_DEST 0 \
  CYCLIC 0 \
  SYNC_TRANSFER_START 0 \
  DMA_2D_TRANSFER 0 \
  MAX_BYTES_PER_BURST 4096 \
  AXI_SLICE_DEST 1 \
  AXI_SLICE_SRC 1 \
  FIFO_SIZE 32\
  DMA_LENGTH_WIDTH 31 \
  DMA_DATA_WIDTH_DEST 128 \
  DMA_DATA_WIDTH_SRC $adc_dma_data_width \
]

# common cores
# fPLLClkin = 500 MHz => RX_CLK25_DIV = 20
# fPLLClkout = 5000 MHz
# VCO = 10000 MHz - qpll0

ad_ip_instance util_adxcvr util_ad9083_xcvr [list \
  RX_NUM_OF_LANES $RX_NUM_OF_LANES \
  TX_NUM_OF_LANES 0 \
  QPLL_FBDIV 40 \
  QPLL_REFCLK_DIV 2 \
  RX_OUT_DIV 1 \
  RX_CLK25_DIV 20 \
  POR_CFG 0x0 \
  QPLL_CFG0 0x391c \
  QPLL_CFG1 0x0000 \
  QPLL_CFG1_G3 0x0020 \
  QPLL_CFG2 0x0f80 \
  QPLL_CFG2_G3 0x0f80 \
  QPLL_CFG3 0x0120 \
  QPLL_CFG4 0x0002 \
  QPLL_CP 0x1f \
  QPLL_CP_G3 0x1f \
  QPLL_LPF 0x2ff \
  CH_HSPMUX 0x2424 \
  PREIQ_FREQ_BST 0 \
  RXPI_CFG0 0x0102 \
  RXPI_CFG1 0x15 \
  RXCDR_CFG0 0x3 \
  RXCDR_CFG2_GEN2 0x265 \
  RXCDR_CFG2_GEN4 0x164 \
  RXCDR_CFG3 0x12 \
  RXCDR_CFG3_GEN2 0x12 \
  RXCDR_CFG3_GEN3 0x12 \
  RXCDR_CFG3_GEN4 0x12 \
  RX_WIDEMODE_CDR 0x0 \
  ]

# xcvr interfaces

set rx_ref_clk     rx_ref_clk_0

create_bd_port -dir I $rx_ref_clk
create_bd_port -dir I rx_core_clk_0

ad_connect  $sys_cpu_resetn util_ad9083_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_ad9083_xcvr/up_clk

# Rx
ad_connect ad9083_rx_device_clk rx_core_clk_0
ad_connect ad9083_rx_link_clk util_ad9083_xcvr/rx_out_clk_0

ad_xcvrcon  util_ad9083_xcvr axi_ad9083_rx_xcvr axi_ad9083_rx_jesd {} ad9083_rx_link_clk ad9083_rx_device_clk
ad_xcvrpll $rx_ref_clk util_ad9083_xcvr/qpll_ref_clk_0
for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
  set ch [expr $i]
  ad_xcvrpll  $rx_ref_clk util_ad9083_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_ad9083_rx_xcvr/up_pll_rst util_ad9083_xcvr/up_cpll_rst_$ch
}

ad_xcvrpll  axi_ad9083_rx_xcvr/up_pll_rst util_ad9083_xcvr/up_qpll_rst_*

ad_ip_instance clk_wiz dma_clk_generator
ad_ip_parameter dma_clk_generator CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_generator CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_generator CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_generator CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 332.9
ad_ip_parameter dma_clk_generator CONFIG.PRIM_SOURCE No_buffer

ad_connect $sys_cpu_clk dma_clk_generator/clk_in1
ad_connect $sys_cpu_resetn dma_clk_generator/resetn

set sys_dma_clk_pin [get_bd_pins -filter {DIR == O} -of [get_bd_nets $sys_dma_clk]]
ad_disconnect $sys_dma_clk $sys_dma_clk_pin

ad_connect $sys_dma_clk [get_bd_pins dma_clk_generator/clk_out1]

ad_connect axi_ad9083_rx_dma/fifo_wr util_ad9083_rx_cpack/packed_fifo_wr

# connections (adc)

ad_connect $sys_dma_resetn axi_ad9083_rx_dma/m_dest_axi_aresetn
ad_connect ad9083_rx_device_clk axi_ad9083_rx_dma/fifo_wr_clk

ad_connect ad9083_rx_device_clk rx_ad9083_tpl_core/link_clk
ad_connect ad9083_rx_device_clk util_ad9083_rx_cpack/clk
ad_connect rx_ad9083_tpl_core/adc_tpl_core/adc_rst util_ad9083_rx_cpack/reset

ad_connect axi_ad9083_rx_jesd/rx_sof rx_ad9083_tpl_core/link_sof
ad_connect axi_ad9083_rx_jesd/rx_data_tdata rx_ad9083_tpl_core/link_data
ad_connect axi_ad9083_rx_jesd/rx_data_tvalid rx_ad9083_tpl_core/link_valid

ad_connect rx_ad9083_tpl_core/adc_valid_0 util_ad9083_rx_cpack/fifo_wr_en
ad_connect rx_ad9083_tpl_core/adc_dovf util_ad9083_rx_cpack/fifo_wr_overflow

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_ad9083_tpl_core/adc_enable_$i util_ad9083_rx_cpack/enable_$i
  ad_connect  rx_ad9083_tpl_core/adc_data_$i util_ad9083_rx_cpack/fifo_wr_data_$i
}

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_ad9083_tpl_core
ad_cpu_interconnect 0x44A60000 axi_ad9083_rx_xcvr
ad_cpu_interconnect 0x44AA0000 axi_ad9083_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9083_rx_dma

ad_mem_hp1_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect $sys_cpu_clk axi_ad9083_rx_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9083_rx_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9083_rx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9083_rx_dma/irq

# Create dummy outputs for unused Rx lanes
for {set i $RX_NUM_OF_LANES} {$i < 4} {incr i} {
  create_bd_port -dir I rx_data_${i}_n
  create_bd_port -dir I rx_data_${i}_p
}
