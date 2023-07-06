###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
# Parameter description:
#   RX_JESD_M : Number of converters per link
#   RX_JESD_L : Number of lanes per link
#   RX_JESD_S : Number of samples per frame
#   RX_JESD_NP : Number of bits per sample
#

# RX parameters for each converter
set RX_NUM_OF_LANES $ad_project_params(RX_JESD_L)      ; # L
set RX_NUM_OF_CONVERTERS $ad_project_params(RX_JESD_M) ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S) ; # S
set RX_SAMPLE_WIDTH $ad_project_params(RX_JESD_NP)     ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr ($RX_NUM_OF_LANES*32) / ($RX_NUM_OF_CONVERTERS*$RX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)
set ADC_DMA_DATA_WIDTH [expr $RX_SAMPLE_WIDTH*$RX_NUM_OF_CONVERTERS*$RX_SAMPLES_PER_CHANNEL]

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9250_xcvr
ad_ip_parameter axi_ad9250_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9250_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.LPM_OR_DFE_N 0
ad_ip_parameter axi_ad9250_xcvr CONFIG.OUT_CLK_SEL 0x2
ad_ip_parameter axi_ad9250_xcvr CONFIG.SYS_CLK_SEL 0x0

adi_axi_jesd204_rx_create axi_ad9250_jesd $RX_NUM_OF_LANES

adi_tpl_jesd204_rx_create axi_ad9250_core $RX_NUM_OF_LANES \
                                          $RX_NUM_OF_CONVERTERS \
                                          $RX_SAMPLES_PER_FRAME \
                                          $RX_SAMPLE_WIDTH
ad_ip_parameter axi_ad9250_core/adc_tpl_core CONFIG.CONVERTER_RESOLUTION 14
ad_ip_parameter axi_ad9250_core/adc_tpl_core CONFIG.TWOS_COMPLEMENT 0

ad_ip_instance util_cpack2 axi_ad9250_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_ip_instance axi_dmac axi_ad9250_dma
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9250_dma CONFIG.ID 0
ad_ip_parameter axi_ad9250_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9250_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9250_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9250_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_DATA_WIDTH_SRC $ADC_DMA_DATA_WIDTH
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_DATA_WIDTH_DEST $ADC_DMA_DATA_WIDTH
ad_ip_parameter axi_ad9250_dma CONFIG.FIFO_SIZE 8

# transceiver core

ad_ip_instance util_adxcvr util_fmcjesdadc1_xcvr
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.QPLL_FBDIV 0x80
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_NUM_OF_LANES 4
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_CDR_CFG 0x03000023ff10200020

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcjesdadc1_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9250_xcvr/up_pll_rst util_fmcjesdadc1_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_fmcjesdadc1_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_fmcjesdadc1_xcvr/up_clk

create_bd_port -dir O rx_core_clk

# connections (adc)

if {$RX_NUM_OF_LANES == 2} {
    # The ad-fmcjesdadc1-ebz board contains two ad9250 chips each exposing a 
    # maximum of two JESD204B physical lanes. 
    # When the user configures the JESD204B interface for 4 lanes communication
    # (two lanes per ad9250 chip) the A and B lanes contain information from the
    # first chip and the C nd D lanes contain information from the second chip. 
    # When the user configures the JESD204B interface for 2 lanes communication
    # (1 lane per ad9250 chip) only one lane from ech ad9250 chip will be used.
    # So only physical lanes A and C will contain usable information, thus the need to
    # swap of the lanes "{0 2}": This means that JESD204B link layer 0 will be 
    # connected to the JESD204B physical lane 0 and JESD204B link layer 1 will be
    # connected to the JESD204B physical lane 2.  
    ad_xcvrcon  util_fmcjesdadc1_xcvr axi_ad9250_xcvr axi_ad9250_jesd {0 2}
} else {
    ad_xcvrcon  util_fmcjesdadc1_xcvr axi_ad9250_xcvr axi_ad9250_jesd 
}
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 rx_core_clk

ad_connect axi_ad9250_core/adc_valid_0 axi_ad9250_cpack/fifo_wr_en

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect axi_ad9250_core/adc_enable_$i axi_ad9250_cpack/enable_$i
  ad_connect axi_ad9250_core/adc_data_$i axi_ad9250_cpack/fifo_wr_data_$i
}

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_core/link_clk
ad_connect  axi_ad9250_jesd/rx_sof axi_ad9250_core/link_sof
ad_connect  axi_ad9250_core/link_data axi_ad9250_jesd/rx_data_tdata

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_cpack/clk
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_cpack/reset

ad_connect  axi_ad9250_core/adc_dovf axi_ad9250_cpack/fifo_wr_overflow

ad_connect  axi_ad9250_core/link_clk axi_ad9250_dma/fifo_wr_clk
ad_connect  axi_ad9250_dma/fifo_wr axi_ad9250_cpack/packed_fifo_wr

ad_connect  axi_ad9250_core/link_valid axi_ad9250_jesd/rx_data_tvalid

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9250_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9250_core
ad_cpu_interconnect 0x44AA0000 axi_ad9250_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9250_dma

# xcvr uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9250_xcvr/m_axi

# interconnect (adc)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9250_dma/m_dest_axi

ad_connect  $sys_dma_resetn axi_ad9250_dma/m_dest_axi_aresetn

#interrupts

ad_cpu_interrupt ps-11 mb-14 axi_ad9250_jesd/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9250_dma/irq

# Create dummy outputs for unused Rx lanes
for {set i $RX_NUM_OF_LANES} {$i < 4} {incr i} {
    create_bd_port -dir I rx_data_${i}_n
    create_bd_port -dir I rx_data_${i}_p
}

# Connect unused input pins in util_fmcjesdadc1_xcvr
if {$RX_NUM_OF_LANES == 2} {
    ad_connect util_fmcjesdadc1_xcvr/rx_clk_1 util_fmcjesdadc1_xcvr/rx_clk_0
    ad_connect util_fmcjesdadc1_xcvr/rx_clk_3 util_fmcjesdadc1_xcvr/rx_clk_0
    ad_connect util_fmcjesdadc1_xcvr/rx_2_p rx_data_2_p
    ad_connect util_fmcjesdadc1_xcvr/rx_2_n rx_data_2_n
    ad_connect util_fmcjesdadc1_xcvr/rx_3_p rx_data_3_p
    ad_connect util_fmcjesdadc1_xcvr/rx_3_n rx_data_3_n
    ad_connect util_fmcjesdadc1_xcvr/rx_calign_1 util_fmcjesdadc1_xcvr/rx_calign_0
    ad_connect util_fmcjesdadc1_xcvr/rx_calign_3 util_fmcjesdadc1_xcvr/rx_calign_0
}
