###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad777x

add_instance axi_ad777x_adc axi_ad777x 

add_interface axi_ad777x_adc_if conduit end
set_interface_property axi_ad777x_adc_if EXPORT_OF axi_ad777x_adc.adc_if

add_interface axi_ad777x_adc_clk_if conduit end
set_interface_property axi_ad777x_adc_clk_if EXPORT_OF axi_ad777x_adc.if_clk_in

# adc-path channel pack

add_instance ad777x_adc_pack util_cpack2 
set_instance_parameter_value ad777x_adc_pack {NUM_OF_CHANNELS} {8}
set_instance_parameter_value ad777x_adc_pack {SAMPLE_DATA_WIDTH} {32}

add_connection axi_ad777x_adc.if_adc_clk   ad777x_adc_pack.clk
add_connection axi_ad777x_adc.if_adc_reset ad777x_adc_pack.reset
add_connection axi_ad777x_adc.if_adc_dovf  ad777x_adc_pack.if_fifo_wr_overflow
add_connection ad777x_adc_pack.adc_ch_0    axi_ad777x_adc.adc_ch_0
add_connection ad777x_adc_pack.adc_ch_1    axi_ad777x_adc.adc_ch_1
add_connection ad777x_adc_pack.adc_ch_2    axi_ad777x_adc.adc_ch_2
add_connection ad777x_adc_pack.adc_ch_3    axi_ad777x_adc.adc_ch_3
add_connection ad777x_adc_pack.adc_ch_4    axi_ad777x_adc.adc_ch_4
add_connection ad777x_adc_pack.adc_ch_5    axi_ad777x_adc.adc_ch_5
add_connection ad777x_adc_pack.adc_ch_6    axi_ad777x_adc.adc_ch_6
add_connection ad777x_adc_pack.adc_ch_7    axi_ad777x_adc.adc_ch_7

# adc(ad777x-dma)

add_instance ad777x_dma axi_dmac
set_instance_parameter_value ad777x_dma {ID} {0}
set_instance_parameter_value ad777x_dma {DMA_DATA_WIDTH_SRC} {256}
set_instance_parameter_value ad777x_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value ad777x_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value ad777x_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value ad777x_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value ad777x_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value ad777x_dma {CYCLIC} {0}
set_instance_parameter_value ad777x_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value ad777x_dma {DMA_TYPE_SRC} {2}

add_connection sys_clk.clk     ad777x_dma.s_axi_clock
add_connection sys_clk.clk     ad777x_dma.m_dest_axi_clock
add_connection sys_clk.clk     axi_ad777x_adc.s_axi_clock

add_connection axi_ad777x_adc.if_adc_clk                  ad777x_dma.if_fifo_wr_clk
add_connection ad777x_adc_pack.if_packed_fifo_wr_en       ad777x_dma.if_fifo_wr_en
add_connection ad777x_adc_pack.if_packed_fifo_wr_sync     ad777x_dma.if_fifo_wr_sync
add_connection ad777x_adc_pack.if_packed_fifo_wr_data     ad777x_dma.if_fifo_wr_din
add_connection ad777x_adc_pack.if_packed_fifo_wr_overflow ad777x_dma.if_fifo_wr_overflow

#resets

add_connection sys_dma_clk.clk_reset axi_ad777x_adc.s_axi_reset   
add_connection sys_clk.clk_reset     ad777x_dma.s_axi_reset
add_connection sys_dma_clk.clk_reset ad777x_dma.m_dest_axi_reset

# interrupts

ad_cpu_interrupt 5 ad777x_dma.interrupt_sender

# cpu interconnects

ad_cpu_interconnect 0x00020000  axi_ad777x_adc.s_axi
ad_cpu_interconnect 0x00030000  ad777x_dma.s_axi

# mem interconnects

ad_dma_interconnect ad777x_dma.m_dest_axi 
