
# dma 0

add_instance axi_dmac_0 axi_dmac
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_dmac_0 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_0 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_0 {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_SRC} {32}
set_instance_parameter_value axi_dmac_0 {DMA_DATA_WIDTH_DEST} {64}

# dma 1

add_instance axi_dmac_1 axi_dmac
set_instance_parameter_value axi_dmac_1 {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_dmac_1 {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_dmac_1 {CYCLIC} {0}
set_instance_parameter_value axi_dmac_1 {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_dmac_1 {DMA_DATA_WIDTH_SRC} {256}
set_instance_parameter_value axi_dmac_1 {DMA_DATA_WIDTH_DEST} {64}

# cpack

add_instance util_ad7768_adc_pack util_cpack2
set_instance_parameter_value util_ad7768_adc_pack {NUM_OF_CHANNELS} {8}
set_instance_parameter_value util_ad7768_adc_pack {SAMPLE_DATA_WIDTH} {32}

# axi_ad7768

add_instance axi_ad7768_0 axi_ad7768
add_interface up_sshot_bd                          conduit end
add_interface up_format_bd                         conduit end
add_interface up_crc_enable_bd                     conduit end
add_interface up_crc_4_or_16_n_bd                  conduit end
add_interface up_status_clr_bd                     conduit end
add_interface up_status_bd                         conduit end
add_interface if_clk_in_bd                         conduit end
add_interface if_ready_in_bd                       conduit end
add_interface if_data_in_bd                        conduit end

set_interface_property up_sshot_bd                 EXPORT_OF axi_ad7768_0.if_up_sshot
set_interface_property up_format_bd                EXPORT_OF axi_ad7768_0.if_up_format
set_interface_property up_crc_enable_bd            EXPORT_OF axi_ad7768_0.if_up_crc_enable
set_interface_property up_crc_4_or_16_n_bd         EXPORT_OF axi_ad7768_0.if_up_crc_4_or_16_n
set_interface_property up_status_clr_bd            EXPORT_OF axi_ad7768_0.if_up_status_clr
set_interface_property up_status_bd                EXPORT_OF axi_ad7768_0.if_up_status
set_interface_property if_clk_in_bd                EXPORT_OF axi_ad7768_0.if_clk_in
set_interface_property if_ready_in_bd              EXPORT_OF axi_ad7768_0.if_ready_in
set_interface_property if_data_in_bd               EXPORT_OF axi_ad7768_0.if_data_in

#connections

add_connection sys_clk.clk axi_dmac_0.s_axi_clock
add_connection sys_dma_clk.clk axi_dmac_0.m_dest_axi_clock

add_connection sys_clk.clk axi_dmac_1.s_axi_clock
add_connection sys_dma_clk.clk axi_dmac_1.m_dest_axi_clock

add_connection sys_clk.clk axi_ad7768_0.s_axi_clock

add_connection axi_ad7768_0.if_adc_clk util_ad7768_adc_pack.clk
add_connection axi_ad7768_0.if_adc_clk axi_dmac_0.if_fifo_wr_clk
add_connection axi_ad7768_0.if_adc_clk axi_dmac_1.if_fifo_wr_clk

add_connection axi_dmac_0.if_fifo_wr_en axi_ad7768_0.if_adc_valid
add_connection axi_dmac_0.if_fifo_wr_din axi_ad7768_0.if_adc_data_p
add_connection axi_dmac_0.if_fifo_wr_sync axi_ad7768_0.if_adc_sync

add_connection util_ad7768_adc_pack.if_packed_fifo_wr_en  axi_dmac_1.if_fifo_wr_en
add_connection util_ad7768_adc_pack.if_packed_fifo_wr_sync axi_dmac_1.if_fifo_wr_sync
add_connection util_ad7768_adc_pack.if_packed_fifo_wr_data axi_dmac_1.if_fifo_wr_din
add_connection util_ad7768_adc_pack.if_packed_fifo_wr_overflow axi_dmac_1.if_fifo_wr_overflow

add_connection axi_ad7768_0.if_adc_dovf util_ad7768_adc_pack.if_fifo_wr_overflow
add_connection axi_ad7768_0.adc_ch_0 util_ad7768_adc_pack.adc_ch_0
add_connection axi_ad7768_0.adc_ch_1 util_ad7768_adc_pack.adc_ch_1
add_connection axi_ad7768_0.adc_ch_2 util_ad7768_adc_pack.adc_ch_2
add_connection axi_ad7768_0.adc_ch_3 util_ad7768_adc_pack.adc_ch_3
add_connection axi_ad7768_0.adc_ch_4 util_ad7768_adc_pack.adc_ch_4
add_connection axi_ad7768_0.adc_ch_5 util_ad7768_adc_pack.adc_ch_5
add_connection axi_ad7768_0.adc_ch_6 util_ad7768_adc_pack.adc_ch_6
add_connection axi_ad7768_0.adc_ch_7 util_ad7768_adc_pack.adc_ch_7

# resets

add_connection sys_clk.clk_reset axi_ad7768_0.s_axi_reset
add_connection sys_clk.clk_reset util_ad7768_adc_pack.reset
add_connection sys_clk.clk_reset axi_dmac_0.s_axi_reset
add_connection sys_dma_clk.clk_reset axi_dmac_0.m_dest_axi_reset
add_connection sys_clk.clk_reset axi_dmac_1.s_axi_reset
add_connection sys_dma_clk.clk_reset axi_dmac_1.m_dest_axi_reset

# interfaces

add_connection axi_dmac_0.m_dest_axi sys_hps.f2h_sdram0_data
add_connection axi_dmac_1.m_dest_axi sys_hps.f2h_sdram0_data

# cpu interconnects

ad_cpu_interconnect 0x00020000 axi_dmac_0.s_axi
ad_cpu_interconnect 0x00028000 axi_dmac_1.s_axi
ad_cpu_interconnect 0x00030000 axi_ad7768_0.s_axi

#interrupts

ad_cpu_interrupt 6 axi_dmac_0.interrupt_sender
ad_cpu_interrupt 5 axi_dmac_1.interrupt_sender

