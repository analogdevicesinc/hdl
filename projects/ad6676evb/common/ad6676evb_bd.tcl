
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad6676_xcvr
ad_ip_parameter axi_ad6676_xcvr CONFIG.NUM_OF_LANES 2
ad_ip_parameter axi_ad6676_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad6676_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad6676_xcvr CONFIG.LPM_OR_DFE_N 0
ad_ip_parameter axi_ad6676_xcvr CONFIG.SYS_CLK_SEL 0x0
ad_ip_parameter axi_ad6676_xcvr CONFIG.OUT_CLK_SEL 0x4

adi_axi_jesd204_rx_create axi_ad6676_jesd 2

ad_ip_instance axi_ad6676 axi_ad6676_core

ad_ip_instance util_cpack2 axi_ad6676_cpack { \
  NUM_OF_CHANNELS 2 \
  SAMPLES_PER_CHANNEL 2 \
  SAMPLE_DATA_WIDTH 16 \
}

ad_ip_instance axi_dmac axi_ad6676_dma
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad6676_dma CONFIG.ID 0
ad_ip_parameter axi_ad6676_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad6676_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad6676_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad6676_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad6676_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# transceiver core

ad_ip_instance util_adxcvr util_ad6676_xcvr
ad_ip_parameter util_ad6676_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_ad6676_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_ad6676_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_ad6676_xcvr CONFIG.RX_NUM_OF_LANES 2
ad_ip_parameter util_ad6676_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_ad6676_xcvr CONFIG.RX_CLK25_DIV 8
ad_ip_parameter util_ad6676_xcvr CONFIG.RX_DFE_LPM_CFG 0x0954
ad_ip_parameter util_ad6676_xcvr CONFIG.RX_CDR_CFG 0x03000023ff20400020

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir O rx_core_clk

ad_xcvrpll  rx_ref_clk_0 util_ad6676_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_ad6676_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad6676_xcvr/up_pll_rst util_ad6676_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad6676_xcvr/up_pll_rst util_ad6676_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_ad6676_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_ad6676_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_ad6676_xcvr axi_ad6676_xcvr axi_ad6676_jesd
ad_connect  util_ad6676_xcvr/rx_out_clk_0 axi_ad6676_core/rx_clk
ad_connect  util_ad6676_xcvr/rx_out_clk_0 rx_core_clk
ad_connect  axi_ad6676_jesd/rx_sof axi_ad6676_core/rx_sof
ad_connect  axi_ad6676_jesd/rx_data_tdata axi_ad6676_core/rx_data

ad_connect  util_ad6676_xcvr/rx_out_clk_0 axi_ad6676_cpack/clk
ad_connect  axi_ad6676_jesd_rstgen/peripheral_reset axi_ad6676_cpack/reset
ad_connect  axi_ad6676_core/adc_dovf axi_ad6676_cpack/fifo_wr_overflow
ad_connect  axi_ad6676_core/adc_valid_0 axi_ad6676_cpack/fifo_wr_en
for {set i 0} {$i < 2} {incr i} {
  ad_connect  axi_ad6676_core/adc_enable_${i} axi_ad6676_cpack/enable_${i}
  ad_connect  axi_ad6676_core/adc_data_${i} axi_ad6676_cpack/fifo_wr_data_${i}
}
ad_connect  axi_ad6676_core/adc_clk axi_ad6676_dma/fifo_wr_clk
ad_connect  axi_ad6676_dma/fifo_wr axi_ad6676_cpack/packed_fifo_wr

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad6676_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad6676_core
ad_cpu_interconnect 0x44AA0000 axi_ad6676_jesd
ad_cpu_interconnect 0x7c420000 axi_ad6676_dma

# xcvr uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad6676_xcvr/m_axi

# interconnect (adc)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_ad6676_dma/m_dest_axi
ad_connect  $sys_dma_resetn axi_ad6676_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-12 axi_ad6676_jesd/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad6676_dma/irq

