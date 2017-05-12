
# fmcomms2

# ad9361 core

add_instance axi_ad9361 axi_ad9361
set_instance_parameter_value axi_ad9361 {ID} {0}
set_instance_parameter_value axi_ad9361 {DEVICE_TYPE} {0}

add_connection sys_clk.clk_reset axi_ad9361.s_axi_reset
add_connection sys_clk.clk axi_ad9361.s_axi_clock
add_connection sys_cpu.data_master axi_ad9361.s_axi
add_connection  axi_ad9361.if_l_clk axi_ad9361.if_clk

# ad9361-unpack (dac)

add_instance util_ad9361_dac_upack util_upack
set_instance_parameter_value util_ad9361_dac_upack {CHANNEL_DATA_WIDTH} {16}
set_instance_parameter_value util_ad9361_dac_upack {NUM_OF_CHANNELS} {4}

add_connection  axi_ad9361.if_l_clk util_ad9361_dac_upack.if_dac_clk

# ad9361-dma (dac)

add_instance axi_ad9361_dac_dma axi_dmac
set_instance_parameter_value axi_ad9361_dac_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value axi_ad9361_dac_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9361_dac_dma {DMA_TYPE_DEST} {2}
set_instance_parameter_value axi_ad9361_dac_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_ad9361_dac_dma {CYCLIC} {1}
set_instance_parameter_value axi_ad9361_dac_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9361_dac_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9361_dac_dma {AXI_SLICE_DEST} {1}

add_connection sys_clk.clk_reset axi_ad9361_dac_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9361_dac_dma.s_axi_clock
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9361_dac_dma.m_src_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9361_dac_dma.m_src_axi_clock
add_connection axi_ad9361_dac_dma.m_src_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.irq axi_ad9361_dac_dma.interrupt_sender

# dac path connections

add_connection  sys_cpu.data_master axi_ad9361_dac_dma.s_axi
add_connection  util_ad9361_dac_upack.if_dac_valid axi_ad9361_dac_dma.if_fifo_rd_en
add_connection  util_ad9361_dac_upack.if_dac_data axi_ad9361_dac_dma.if_fifo_rd_dout
add_connection  axi_ad9361_dac_dma.if_fifo_rd_underflow axi_ad9361.if_dac_dunf
add_connection  util_ad9361_dac_upack.dac_ch_0 axi_ad9361.dac_ch_0
add_connection  util_ad9361_dac_upack.dac_ch_1 axi_ad9361.dac_ch_1
add_connection  util_ad9361_dac_upack.dac_ch_2 axi_ad9361.dac_ch_2
add_connection  util_ad9361_dac_upack.dac_ch_3 axi_ad9361.dac_ch_3
add_connection  axi_ad9361.if_l_clk axi_ad9361_dac_dma.if_fifo_rd_clk

# ad9361-adc-fifo

add_instance util_ad9361_adc_fifo util_wfifo
set_instance_parameter_value util_ad9361_adc_fifo {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_ad9361_adc_fifo {DIN_ADDRESS_WIDTH} {4}
set_instance_parameter_value util_ad9361_adc_fifo {DIN_DATA_WIDTH} {16}
set_instance_parameter_value util_ad9361_adc_fifo {DOUT_DATA_WIDTH} {16}

add_connection  axi_ad9361.if_l_clk util_ad9361_adc_fifo.if_din_clk
add_connection  axi_ad9361.if_rst util_ad9361_adc_fifo.if_din_rst
add_connection  sys_clk.clk_reset util_ad9361_adc_fifo.if_dout_rstn
add_connection  sys_clk.clk util_ad9361_adc_fifo.if_dout_clk

# ad9361-pack (adc)

add_instance util_ad9361_adc_cpack util_cpack
set_instance_parameter_value util_ad9361_adc_cpack {CHANNEL_DATA_WIDTH} {16}
set_instance_parameter_value util_ad9361_adc_cpack {NUM_OF_CHANNELS} {4}

add_connection  sys_clk.clk util_ad9361_adc_cpack.if_adc_clk
add_connection  sys_clk.clk_reset util_ad9361_adc_cpack.if_adc_rst

# ad9361-dma (adc)

add_instance axi_ad9361_adc_dma axi_dmac
set_instance_parameter_value axi_ad9361_adc_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_ad9361_adc_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9361_adc_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9361_adc_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9361_adc_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9361_adc_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9361_adc_dma {DMA_TYPE_SRC} {2}

add_connection sys_clk.clk_reset axi_ad9361_adc_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9361_adc_dma.s_axi_clock
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9361_adc_dma.m_dest_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9361_adc_dma.m_dest_axi_clock
add_connection sys_clk.clk axi_ad9361_adc_dma.if_fifo_wr_clk
add_connection sys_cpu.irq axi_ad9361_adc_dma.interrupt_sender
add_connection axi_ad9361_adc_dma.if_fifo_wr_overflow util_ad9361_adc_fifo.if_dout_ovf
add_connection axi_ad9361_adc_dma.m_dest_axi sys_ddr3_cntrl.ctrl_amm_0

# adc path connections

add_connection  axi_ad9361.adc_ch_0 util_ad9361_adc_fifo.din_0
add_connection  axi_ad9361.adc_ch_1 util_ad9361_adc_fifo.din_1
add_connection  axi_ad9361.adc_ch_2 util_ad9361_adc_fifo.din_2
add_connection  axi_ad9361.adc_ch_3 util_ad9361_adc_fifo.din_3
add_connection  util_ad9361_adc_fifo.if_din_ovf axi_ad9361.if_adc_dovf
add_connection  util_ad9361_adc_fifo.dout_0 util_ad9361_adc_cpack.adc_ch_0
add_connection  util_ad9361_adc_fifo.dout_1 util_ad9361_adc_cpack.adc_ch_1
add_connection  util_ad9361_adc_fifo.dout_2 util_ad9361_adc_cpack.adc_ch_2
add_connection  util_ad9361_adc_fifo.dout_3 util_ad9361_adc_cpack.adc_ch_3
add_connection  util_ad9361_adc_cpack.if_adc_valid axi_ad9361_adc_dma.if_fifo_wr_en
add_connection  util_ad9361_adc_cpack.if_adc_sync axi_ad9361_adc_dma.if_fifo_wr_sync
add_connection  util_ad9361_adc_cpack.if_adc_data axi_ad9361_adc_dma.if_fifo_wr_din
add_connection sys_cpu.data_master axi_ad9361_adc_dma.s_axi
add_interface up_enable conduit end
add_interface up_txnrx conduit end
add_interface delay_clk conduit end

# setting interface propriety

set_interface_property  axi_ad9361_device_if EXPORT_OF axi_ad9361.device_if
set_interface_property  up_enable EXPORT_OF axi_ad9361.if_up_enable
set_interface_property  up_txnrx EXPORT_OF axi_ad9361.if_up_txnrx
set_interface_property  delay_clk EXPORT_OF axi_ad9361.if_delay_clk

# addresses

set_connection_parameter_value sys_cpu.data_master/axi_ad9361.s_axi                       baseAddress {0x10000000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9361_dac_dma.s_axi               baseAddress {0x10034000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9361_adc_dma.s_axi               baseAddress {0x10010000}

set_connection_parameter_value axi_ad9361_adc_dma.m_dest_axi/sys_ddr3_cntrl.ctrl_amm_0    baseAddress {0x00000000}
set_connection_parameter_value axi_ad9361_dac_dma.m_src_axi/sys_ddr3_cntrl.ctrl_amm_0     baseAddress {0x00000000}


# interrupts

set_connection_parameter_value sys_cpu.irq/axi_ad9361_adc_dma.interrupt_sender irqNumber {10}
set_connection_parameter_value sys_cpu.irq/axi_ad9361_dac_dma.interrupt_sender irqNumber {11}

