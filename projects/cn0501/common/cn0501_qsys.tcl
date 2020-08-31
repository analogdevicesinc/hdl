
# receive dma

add_instance axi_dmac_0 axi_dmac
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_0 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_0 {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_SRC} {32}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_DEST} {64}

add_interface dma_fifo_wr_en         conduit end
add_interface dma_fifo_wr_din        conduit end
add_interface dma_fifo_wr_sync       conduit end
add_interface dma_fifo_wr_clk        clock sink

set_interface_property dma_fifo_wr_en      EXPORT_OF axi_dmac_0.if_fifo_wr_en
set_interface_property dma_fifo_wr_din     EXPORT_OF axi_dmac_0.if_fifo_wr_din
set_interface_property dma_fifo_wr_sync    EXPORT_OF axi_dmac_0.if_fifo_wr_sync
set_interface_property dma_fifo_wr_clk     EXPORT_OF axi_dmac_0.if_fifo_wr_clk

add_connection sys_clk.clk axi_dmac_0.s_axi_clock

add_connection sys_dma_clk.clk axi_dmac_0.m_dest_axi_clock

# resets

add_connection sys_clk.clk_reset axi_dmac_0.s_axi_reset
add_connection sys_dma_clk.clk_reset axi_dmac_0.m_dest_axi_reset

# interfaces

add_connection axi_dmac_0.m_dest_axi sys_hps.f2h_sdram0_data

# cpu interconnects

ad_cpu_interconnect 0x00020000 axi_dmac_0.s_axi

#interrupts

ad_cpu_interrupt 6 axi_dmac_0.interrupt_sender

