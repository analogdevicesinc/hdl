###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9361

add_instance axi_ad9361 axi_ad9361
set_instance_parameter_value axi_ad9361 {ID} {0}
set_instance_parameter_value axi_ad9361 {MODE_1R1T} {0}
set_instance_parameter_value axi_ad9361 {TDD_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {CMOS_OR_LVDS_N} {0}
set_instance_parameter_value axi_ad9361 {ADC_DATAPATH_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_DATAPATH_DISABLE} {0}
add_interface axi_ad9361_device_if conduit end
set_interface_property axi_ad9361_device_if EXPORT_OF axi_ad9361.device_if
add_interface axi_ad9361_up_enable conduit end
set_interface_property axi_ad9361_up_enable EXPORT_OF axi_ad9361.if_up_enable
add_interface axi_ad9361_up_txnrx conduit end
set_interface_property axi_ad9361_up_txnrx EXPORT_OF axi_ad9361.if_up_txnrx
add_connection axi_ad9361.if_l_clk axi_ad9361.if_clk
add_connection sys_clk.clk axi_ad9361.if_delay_clk
add_connection sys_clk.clk axi_ad9361.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9361.s_axi_reset

# adc-wfifo & dac-rfifo

add_instance util_adc_wfifo util_wfifo
set_instance_parameter_value util_adc_wfifo {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_adc_wfifo {DIN_DATA_WIDTH} {16}
set_instance_parameter_value util_adc_wfifo {DOUT_DATA_WIDTH} {16}
set_instance_parameter_value util_adc_wfifo {DIN_ADDRESS_WIDTH} {5}
add_connection axi_ad9361.if_l_clk util_adc_wfifo.if_din_clk
add_connection axi_ad9361.if_rst util_adc_wfifo.if_din_rst
add_connection sys_dma_clk.clk util_adc_wfifo.if_dout_clk
add_connection sys_dma_clk.clk_reset util_adc_wfifo.if_dout_rstn
add_connection axi_ad9361.adc_ch_0 util_adc_wfifo.din_0
add_connection axi_ad9361.adc_ch_1 util_adc_wfifo.din_1
add_connection axi_ad9361.adc_ch_2 util_adc_wfifo.din_2
add_connection axi_ad9361.adc_ch_3 util_adc_wfifo.din_3
add_connection util_adc_wfifo.if_din_ovf axi_ad9361.if_adc_dovf

# adc-wfifo & dac-rfifo

add_instance util_dac_rfifo util_rfifo
set_instance_parameter_value util_dac_rfifo {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_dac_rfifo {DIN_DATA_WIDTH} {16}
set_instance_parameter_value util_dac_rfifo {DOUT_DATA_WIDTH} {16}
set_instance_parameter_value util_dac_rfifo {DIN_ADDRESS_WIDTH} {5}
add_connection axi_ad9361.if_l_clk util_dac_rfifo.if_dout_clk
add_connection axi_ad9361.if_rst util_dac_rfifo.if_dout_rst
add_connection sys_dma_clk.clk util_dac_rfifo.if_din_clk
add_connection sys_dma_clk.clk_reset util_dac_rfifo.if_din_rstn
add_connection util_dac_rfifo.dout_0 axi_ad9361.dac_ch_0
add_connection util_dac_rfifo.dout_1 axi_ad9361.dac_ch_1
add_connection util_dac_rfifo.dout_2 axi_ad9361.dac_ch_2
add_connection util_dac_rfifo.dout_3 axi_ad9361.dac_ch_3
add_connection util_dac_rfifo.if_dout_unf axi_ad9361.if_dac_dunf

# adc-pack & dac-unpack

add_instance util_adc_pack util_cpack2
set_instance_parameter_value util_adc_pack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_adc_pack {SAMPLE_DATA_WIDTH} {16}
add_connection sys_dma_clk.clk util_adc_pack.clk
add_connection sys_dma_clk.clk_reset util_adc_pack.reset
add_connection util_adc_wfifo.dout_0 util_adc_pack.adc_ch_0
add_connection util_adc_wfifo.dout_1 util_adc_pack.adc_ch_1
add_connection util_adc_wfifo.dout_2 util_adc_pack.adc_ch_2
add_connection util_adc_wfifo.dout_3 util_adc_pack.adc_ch_3
add_connection util_adc_pack.if_fifo_wr_overflow util_adc_wfifo.if_dout_ovf

# adc-pack & dac-unpack

add_instance util_dac_upack util_upack2
set_instance_parameter_value util_dac_upack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_dac_upack {SAMPLE_DATA_WIDTH} {16}
add_connection sys_dma_clk.clk util_dac_upack.clk
add_connection sys_dma_clk.clk_reset util_dac_upack.reset
add_connection util_dac_upack.dac_ch_0 util_dac_rfifo.din_0
add_connection util_dac_upack.dac_ch_1 util_dac_rfifo.din_1
add_connection util_dac_upack.dac_ch_2 util_dac_rfifo.din_2
add_connection util_dac_upack.dac_ch_3 util_dac_rfifo.din_3
add_connection util_dac_upack.if_fifo_rd_underflow util_dac_rfifo.if_din_unf

# adc-dma & dac-dma

add_instance axi_adc_dma axi_dmac
set_instance_parameter_value axi_adc_dma {ID} {0}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SG} {64}
set_instance_parameter_value axi_adc_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_adc_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adc_dma {DMA_SG_TRANSFER} {1}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adc_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_adc_dma {CYCLIC} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_adc_dma {FIFO_SIZE} {4}
add_connection sys_clk.clk axi_adc_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_adc_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_adc_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_adc_dma.m_dest_axi_reset
add_connection sys_dma_clk.clk axi_adc_dma.m_sg_axi_clock
add_connection sys_dma_clk.clk_reset axi_adc_dma.m_sg_axi_reset
add_connection sys_dma_clk.clk axi_adc_dma.if_fifo_wr_clk
add_connection util_adc_pack.if_packed_fifo_wr_en axi_adc_dma.if_fifo_wr_en
add_connection util_adc_pack.if_packed_fifo_wr_sync axi_adc_dma.if_fifo_wr_sync
add_connection util_adc_pack.if_packed_fifo_wr_data axi_adc_dma.if_fifo_wr_din
add_connection axi_adc_dma.if_fifo_wr_overflow util_adc_pack.if_packed_fifo_wr_overflow

# adc-dma & dac-dma

add_instance axi_dac_dma axi_dmac
set_instance_parameter_value axi_dac_dma {ID} {0}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_SG} {64}
set_instance_parameter_value axi_dac_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_dac_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_dac_dma {DMA_SG_TRANSFER} {1}
set_instance_parameter_value axi_dac_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_dac_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_dac_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_dac_dma {CYCLIC} {1}
set_instance_parameter_value axi_dac_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value axi_dac_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_dac_dma {FIFO_SIZE} {4}
add_connection sys_clk.clk axi_dac_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_dac_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_dac_dma.m_src_axi_clock
add_connection sys_dma_clk.clk_reset axi_dac_dma.m_src_axi_reset
add_connection sys_dma_clk.clk axi_dac_dma.m_sg_axi_clock
add_connection sys_dma_clk.clk_reset axi_dac_dma.m_sg_axi_reset
add_connection sys_dma_clk.clk axi_dac_dma.if_m_axis_aclk

add_connection axi_dac_dma.m_axis util_dac_upack.s_axis

# interrupts

ad_cpu_interrupt 2 axi_adc_dma.interrupt_sender
ad_cpu_interrupt 3 axi_dac_dma.interrupt_sender

# cpu interconnects

ad_cpu_interconnect 0x00120000 axi_ad9361.s_axi
ad_cpu_interconnect 0x00100000 axi_adc_dma.s_axi
ad_cpu_interconnect 0x00104000 axi_dac_dma.s_axi

# mem interconnects
set_instance_parameter_value sys_hps {F2SDRAM_Width} {64 128 64}

ad_dma_interconnect axi_adc_dma.m_dest_axi 1
ad_dma_interconnect axi_dac_dma.m_src_axi 2
ad_dma_interconnect axi_adc_dma.m_sg_axi 3
ad_dma_interconnect axi_dac_dma.m_sg_axi 4

