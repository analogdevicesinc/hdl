
# RX parameters for each converter
set RX_NUM_OF_LANES 4      ; # L
set RX_NUM_OF_CONVERTERS 4 ; # M
set RX_SAMPLES_PER_FRAME 1 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 2 ; # L * 32 / (M * N)

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
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_ad9250_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9250_dma CONFIG.FIFO_SIZE 8

# transceiver core

ad_ip_instance util_adxcvr util_fmcjesdadc1_xcvr
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.QPLL_FBDIV 0x80
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_fmcjesdadc1_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
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

ad_xcvrcon  util_fmcjesdadc1_xcvr axi_ad9250_xcvr axi_ad9250_jesd
ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 rx_core_clk

ad_connect axi_ad9250_core/adc_valid_0 axi_ad9250_cpack/fifo_wr_en

ad_connect axi_ad9250_core/adc_enable_0 axi_ad9250_cpack/enable_0
ad_connect axi_ad9250_core/adc_enable_1 axi_ad9250_cpack/enable_1
ad_connect axi_ad9250_core/adc_enable_2 axi_ad9250_cpack/enable_2
ad_connect axi_ad9250_core/adc_enable_3 axi_ad9250_cpack/enable_3

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_core/link_clk
ad_connect  axi_ad9250_jesd/rx_sof axi_ad9250_core/link_sof
ad_connect  axi_ad9250_core/link_data axi_ad9250_jesd/rx_data_tdata

ad_connect  util_fmcjesdadc1_xcvr/rx_out_clk_0 axi_ad9250_cpack/clk
ad_connect  axi_ad9250_jesd_rstgen/peripheral_reset axi_ad9250_cpack/reset

ad_connect  axi_ad9250_core/adc_dovf axi_ad9250_cpack/fifo_wr_overflow
ad_connect  axi_ad9250_core/adc_data_0 axi_ad9250_cpack/fifo_wr_data_0
ad_connect  axi_ad9250_core/adc_data_1 axi_ad9250_cpack/fifo_wr_data_1
ad_connect  axi_ad9250_core/adc_data_2 axi_ad9250_cpack/fifo_wr_data_2
ad_connect  axi_ad9250_core/adc_data_3 axi_ad9250_cpack/fifo_wr_data_3

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

