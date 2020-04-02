for {set i 0} {$i < 4} {incr i} {

  set H_NAME moover_$i

  create_bd_cell -type hier $H_NAME

  ad_ip_instance axi_dmac axi_mxfe_rx_dma_${i} [list \
    DMA_TYPE_SRC 2 \
    DMA_TYPE_DEST 0 \
    ID 0 \
    AXI_SLICE_SRC 1 \
    AXI_SLICE_DEST 1 \
    SYNC_TRANSFER_START 0 \
    DMA_LENGTH_WIDTH 24 \
    DMA_2D_TRANSFER 0 \
    CYCLIC 0 \
    DMA_DATA_WIDTH_SRC 512 \
    DMA_DATA_WIDTH_DEST 64 \
  ]

  ad_ip_instance axi_dmac axi_mxfe_tx_dma_${i} [list \
    DMA_TYPE_SRC 0 \
    DMA_TYPE_DEST 2 \
    ID 0 \
    AXI_SLICE_SRC 1 \
    AXI_SLICE_DEST 1 \
    SYNC_TRANSFER_START 0 \
    DMA_LENGTH_WIDTH 24 \
    DMA_2D_TRANSFER 0 \
    CYCLIC 1 \
    DMA_DATA_WIDTH_SRC 64 \
    DMA_DATA_WIDTH_DEST 512 \
  ]

  ad_ip_instance xlconcat $H_NAME/rx_data_concat [list NUM_PORTS {32}]
  for {set j 0} {$j < 32} {incr j} {
    ad_ip_parameter $H_NAME/rx_data_concat CONFIG.IN${j}_WIDTH {16}
    ad_connect qmxfe${i}/adc_data_$j $H_NAME/rx_data_concat/In$j
  }

  ad_connect  $H_NAME/rx_data_concat/dout axi_mxfe_rx_dma_${i}/fifo_wr_din
  ad_connect  axi_mxfe_rx_dma_${i}/fifo_wr_en VCC


  for {set j 0} {$j < 32} {incr j} {
    ad_ip_instance xlslice $H_NAME/tx_out_slice_$j [list \
      DIN_WIDTH {512} \
      DOUT_WIDTH {16} \
      DIN_TO [expr $j * 16] \
      DIN_FROM [expr ($j+1) * 16 - 1] \
    ]
    ad_connect  axi_mxfe_tx_dma_${i}/fifo_rd_dout  $H_NAME/tx_out_slice_$j/Din
    ad_connect  $H_NAME/tx_out_slice_$j/Dout  qmxfe${i}/dac_data_$j
  }

  ad_connect axi_mxfe_tx_dma_${i}/fifo_rd_en VCC

  ad_connect  device_clk axi_mxfe_rx_dma_${i}/fifo_wr_clk
  ad_connect  device_clk axi_mxfe_tx_dma_${i}/fifo_rd_clk
}
