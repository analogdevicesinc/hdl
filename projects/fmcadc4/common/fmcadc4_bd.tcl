
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# fmcadc4

# adc peripherals

ad_ip_instance axi_ad9680 axi_ad9680_core_0
ad_ip_parameter axi_ad9680_core_0 CONFIG.ID 0
ad_ip_instance axi_ad9680 axi_ad9680_core_1
ad_ip_parameter axi_ad9680_core_1 CONFIG.ID 1

ad_ip_instance axi_adxcvr axi_ad9680_xcvr
ad_ip_parameter axi_ad9680_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9680_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9680_xcvr CONFIG.TX_OR_RX_N 0

adi_axi_jesd204_rx_create axi_ad9680_jesd 8

ad_ip_instance axi_dmac axi_ad9680_dma
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.ID 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9680_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9680_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9680_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_cpack2 axi_ad9680_cpack { \
  NUM_OF_CHANNELS 4 \
  SAMPLES_PER_CHANNEL 4 \
  SAMPLE_DATA_WIDTH 16 \
}

# adc common gt

ad_ip_instance util_adxcvr util_fmcadc4_xcvr
ad_ip_parameter util_fmcadc4_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_fmcadc4_xcvr CONFIG.TX_NUM_OF_LANES 0

ad_ip_instance util_bsplit util_bsplit_rx_data
ad_ip_parameter util_bsplit_rx_data CONFIG.CHANNEL_DATA_WIDTH 128
ad_ip_parameter util_bsplit_rx_data CONFIG.NUM_OF_CHANNELS 2

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_fmcadc4_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc4_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_fmcadc4_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9680_xcvr/up_pll_rst util_fmcadc4_xcvr/up_cpll_rst_*

# connections (gt)

ad_xcvrcon  util_fmcadc4_xcvr axi_ad9680_xcvr axi_ad9680_jesd
ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_cpack/clk
ad_connect  axi_ad9680_jesd/rx_data_tdata util_bsplit_rx_data/data
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_cpack/reset

# connections (adc)

ad_connect  axi_ad9680_core_0/adc_valid_0 axi_ad9680_cpack/fifo_wr_en

for {set i 0} {$i < 2} {incr i} {
  ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_core_${i}/rx_clk
  ad_connect  util_bsplit_rx_data/split_data_${i} axi_ad9680_core_${i}/rx_data
  ad_connect  axi_ad9680_jesd/rx_sof axi_ad9680_core_${i}/rx_sof
  for {set j 0} {$j < 2} {incr j} {
    set k [expr $i * 2 + $j]
    ad_connect  axi_ad9680_core_${i}/adc_enable_${j} axi_ad9680_cpack/enable_${k}
    ad_connect  axi_ad9680_core_${i}/adc_data_${j} axi_ad9680_cpack/fifo_wr_data_${k}
  }
}

ad_connect  util_fmcadc4_xcvr/rx_out_clk_0 axi_ad9680_fifo/adc_clk
ad_connect  axi_ad9680_jesd_rstgen/peripheral_reset axi_ad9680_fifo/adc_rst
ad_connect  axi_ad9680_cpack/packed_fifo_wr_en axi_ad9680_fifo/adc_wr
ad_connect  axi_ad9680_cpack/packed_fifo_wr_data axi_ad9680_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9680_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9680_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9680_dma/m_dest_axi_aresetn
ad_connect  axi_ad9680_fifo/dma_wr axi_ad9680_dma/s_axis_valid
ad_connect  axi_ad9680_fifo/dma_wdata axi_ad9680_dma/s_axis_data
ad_connect  axi_ad9680_fifo/dma_wready axi_ad9680_dma/s_axis_ready
ad_connect  axi_ad9680_fifo/dma_xfer_req axi_ad9680_dma/s_axis_xfer_req
ad_connect  axi_ad9680_core_0/adc_dovf axi_ad9680_fifo/adc_wovf

ad_connect  sys_cpu_clk util_fmcadc4_xcvr/up_clk
ad_connect  sys_cpu_resetn util_fmcadc4_xcvr/up_rstn

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9680_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9680_core_0
ad_cpu_interconnect 0x44A10000 axi_ad9680_core_1
ad_cpu_interconnect 0x44AA0000 axi_ad9680_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9680_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9680_xcvr/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9680_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9680_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9680_dma/irq

