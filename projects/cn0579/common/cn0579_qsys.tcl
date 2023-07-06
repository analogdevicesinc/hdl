###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad77684
add_instance axi_ad77684_adc axi_ad7768
set_instance_parameter_value axi_ad77684_adc {NUM_CHANNELS} {4}
add_interface if_clk_in_bd                         conduit end
add_interface if_ready_in_bd                       conduit end
add_interface if_data_in_bd                        conduit end

set_interface_property if_clk_in_bd                EXPORT_OF axi_ad77684_adc.if_clk_in
set_interface_property if_ready_in_bd              EXPORT_OF axi_ad77684_adc.if_ready_in
set_interface_property if_data_in_bd               EXPORT_OF axi_ad77684_adc.if_data_in

# adc-path channel pack

add_instance cn0579_adc_pack util_cpack2 
set_instance_parameter_value cn0579_adc_pack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value cn0579_adc_pack {SAMPLE_DATA_WIDTH} {32}

add_connection axi_ad77684_adc.if_adc_clk   cn0579_adc_pack.clk
add_connection axi_ad77684_adc.if_adc_reset cn0579_adc_pack.reset
add_connection axi_ad77684_adc.if_adc_dovf  cn0579_adc_pack.if_fifo_wr_overflow
add_connection axi_ad77684_adc.adc_ch_0     cn0579_adc_pack.adc_ch_0    
add_connection axi_ad77684_adc.adc_ch_1     cn0579_adc_pack.adc_ch_1    
add_connection axi_ad77684_adc.adc_ch_2     cn0579_adc_pack.adc_ch_2    
add_connection axi_ad77684_adc.adc_ch_3     cn0579_adc_pack.adc_ch_3    

# adc(cn0579-dma)

add_instance cn0579_dma axi_dmac
set_instance_parameter_value cn0579_dma {ID} {0}
set_instance_parameter_value cn0579_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value cn0579_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value cn0579_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value cn0579_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value cn0579_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value cn0579_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value cn0579_dma {CYCLIC} {0}
set_instance_parameter_value cn0579_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value cn0579_dma {DMA_TYPE_SRC} {2}

add_connection axi_ad77684_adc.if_adc_clk                 cn0579_dma.if_fifo_wr_clk
add_connection cn0579_adc_pack.if_packed_fifo_wr_en       cn0579_dma.if_fifo_wr_en
add_connection cn0579_adc_pack.if_packed_fifo_wr_sync     cn0579_dma.if_fifo_wr_sync
add_connection cn0579_adc_pack.if_packed_fifo_wr_data     cn0579_dma.if_fifo_wr_din
add_connection cn0579_adc_pack.if_packed_fifo_wr_overflow cn0579_dma.if_fifo_wr_overflow

#clocks

add_connection sys_clk.clk     cn0579_dma.s_axi_clock
add_connection sys_clk.clk     axi_ad77684_adc.s_axi_clock
add_connection sys_dma_clk.clk cn0579_dma.m_dest_axi_clock

#resets

add_connection sys_clk.clk_reset     axi_ad77684_adc.s_axi_reset   
add_connection sys_clk.clk_reset     cn0579_dma.s_axi_reset
add_connection sys_dma_clk.clk_reset cn0579_dma.m_dest_axi_reset

# interrupts

ad_cpu_interrupt 5 cn0579_dma.interrupt_sender

# cpu interconnects

ad_cpu_interconnect 0x00028000  cn0579_dma.s_axi
ad_cpu_interconnect 0x00030000  axi_ad77684_adc.s_axi

# mem interconnects

ad_dma_interconnect cn0579_dma.m_dest_axi 
