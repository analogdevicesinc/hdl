# Common block design


# IP cores related to JESD framework
source jesd_cores_bd.tcl


# connect main control path interconnect to the qmxfe smart connects
set masters [get_property CONFIG.NUM_MI [get_bd_cells axi_cpu_interconnect]]
set_property -dict [list CONFIG.NUM_MI [expr $masters+4]] [get_bd_cells axi_cpu_interconnect]
for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_AXI qmxfe$i/interconnect/S00_AXI
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_ACLK $sys_cpu_clk
  ad_connect axi_cpu_interconnect/M[expr $masters+$i]_ARESETN $sys_cpu_resetn
  #fake an ad_cpu_interconnect
  global sys_cpu_interconnect_index
  incr sys_cpu_interconnect_index
}
assign_bd_address

# crate dummy DMACs to consume/drive adc/dac data so complete datapath

for {set i 0} {$i < 4} {incr i} {

  ad_ip_instance axi_dmac axi_mxfe_rx_dma_$i [list \
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

  ad_ip_instance axi_dmac axi_mxfe_tx_dma_$i [list \
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

  ad_cpu_interconnect 0x7c4[expr $i*2]0000 axi_mxfe_rx_dma_${i}
  ad_cpu_interconnect 0x7c4[expr $i*2+1]0000 axi_mxfe_tx_dma_${i}

  ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_tx_dma_$i/m_src_axi
  ad_mem_hp0_interconnect $sys_dma_clk axi_mxfe_rx_dma_$i/m_dest_axi

  ad_connect  qmxfe${i}/rx_mxfe_tpl_core/adc_data axi_mxfe_rx_dma_${i}/fifo_wr_din
  ad_connect  qmxfe${i}/rx_mxfe_tpl_core/adc_valid axi_mxfe_rx_dma_${i}/fifo_wr_en

  ad_connect  axi_mxfe_tx_dma_${i}/fifo_rd_dout qmxfe${i}/tx_mxfe_tpl_core/dac_ddata
  ad_connect  qmxfe${i}/tx_mxfe_tpl_core/dac_valid  axi_mxfe_tx_dma_${i}/fifo_rd_en

  ad_connect  device_clk axi_mxfe_rx_dma_$i/fifo_wr_clk
  ad_connect  device_clk axi_mxfe_tx_dma_$i/fifo_rd_clk

  ad_connect  $sys_dma_resetn axi_mxfe_rx_dma_$i/m_dest_axi_aresetn
  ad_connect  $sys_dma_resetn axi_mxfe_tx_dma_$i/m_src_axi_aresetn

}





