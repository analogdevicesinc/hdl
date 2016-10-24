
# DAQ1

# DAC core

add_instance axi_ad9122 axi_ad9122 1.0
set_instance_parameter_value axi_ad9122 {ID} {0}

add_connection sys_clk.clk_reset axi_ad9122.s_axi_reset
add_connection sys_clk.clk axi_ad9122.s_axi_clock
add_connection sys_cpu.data_master axi_ad9122.s_axi

# DAC unpack

add_instance util_ad9122_upack util_upack 1.0
set_instance_parameter_value util_ad9122_upack {CHANNEL_DATA_WIDTH} {64}
set_instance_parameter_value util_ad9122_upack {NUM_OF_CHANNELS} {2}

# DAC DMA

add_instance axi_ad9122_dma axi_dmac 1.0
set_instance_parameter_value axi_ad9122_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9122_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9122_dma {DMA_TYPE_DEST} {2}
set_instance_parameter_value axi_ad9122_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_ad9122_dma {CYCLIC} {1}
set_instance_parameter_value axi_ad9122_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_ad9122_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9122_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9122_dma {DMA_LENGTH_WIDTH} {24}

add_connection sys_clk.clk_reset axi_ad9122_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9122_dma.s_axi_clock
add_connection sys_cpu.data_master axi_ad9122_dma.s_axi
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9122_dma.m_src_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9122_dma.m_src_axi_clock
add_connection axi_ad9122_dma.m_src_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.irq axi_ad9122_dma.interrupt_sender
add_connection sys_clk.clk axi_ad9122_dma.if_fifo_rd_clk

# DAC path

add_connection axi_ad9122.if_dac_div_clk util_ad9122_upack.if_dac_clk
add_connection util_ad9122_upack.if_dac_valid axi_ad9122_dma.if_fifo_rd_en
add_connection util_ad9122_upack.if_dac_data axi_ad9122_dma.if_fifo_rd_dout
add_connection axi_ad9122_dma.if_fifo_rd_underflow axi_ad9122.if_dac_dunf
add_connection util_ad9122_upack.dac_ch_0 axi_ad9122.dac_ch_0
add_connection util_ad9122_upack.dac_ch_1 axi_ad9122.dac_ch_1

# ADC core

add_instance axi_ad9684 axi_ad9684 1.0
set_instance_parameter_value axi_ad9684 {OR_STATUS} {0}

add_connection sys_clk.clk_reset axi_ad9684.s_axi_reset
add_connection sys_clk.clk axi_ad9684.s_axi_clock
add_connection sys_cpu.data_master axi_ad9684.s_axi

# ADC pack

add_instance util_ad9684_cpack util_cpack 1.0
set_instance_parameter_value util_ad9684_cpack {CHANNEL_DATA_WIDTH} {32}
set_instance_parameter_value util_ad9684_cpack {NUM_OF_CHANNELS} {2}

add_connection sys_clk.clk_reset util_ad9684_cpack.if_adc_rst
add_connection sys_ddr3_cntrl.emif_usr_reset_n util_ad9684_cpack.if_adc_rst
add_connection axi_ad9684.if_adc_clk util_ad9684_cpack.if_adc_clk
add_connection util_ad9684_cpack.adc_ch_0 axi_ad9684.adc_ch_0
add_connection util_ad9684_cpack.adc_ch_1 axi_ad9684.adc_ch_1

# ADC FIFO

add_instance ad9684_adcfifo util_adcfifo 1.0
set_instance_parameter_value ad9684_adcfifo {ADC_DATA_WIDTH} {64}
set_instance_parameter_value ad9684_adcfifo {DMA_DATA_WIDTH} {64}
set_instance_parameter_value ad9684_adcfifo {DMA_ADDRESS_WIDTH} {16}

add_connection sys_clk.clk_reset ad9684_adcfifo.if_adc_rst
add_connection sys_ddr3_cntrl.emif_usr_reset_n ad9684_adcfifo.if_adc_rst
add_connection axi_ad9684.if_adc_clk ad9684_adcfifo.if_adc_clk
add_connection util_ad9684_cpack.if_adc_valid ad9684_adcfifo.if_adc_wr
add_connection util_ad9684_cpack.if_adc_data ad9684_adcfifo.if_adc_wdata
add_connection sys_ddr3_cntrl.emif_usr_clk ad9684_adcfifo.if_dma_clk

# ADC DMA

add_instance axi_ad9684_dma axi_dmac 1.0
set_instance_parameter_value axi_ad9684_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value axi_ad9684_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9684_dma {ID} {1}
set_instance_parameter_value axi_ad9684_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9684_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9684_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9684_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9684_dma {FIFO_SIZE} {16}
set_instance_parameter_value axi_ad9684_dma {CYCLIC} {0}

add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9684_dma.if_s_axis_aclk
add_connection ad9684_adcfifo.if_dma_wr axi_ad9684_dma.if_s_axis_valid
add_connection ad9684_adcfifo.if_dma_wdata axi_ad9684_dma.if_s_axis_data
add_connection ad9684_adcfifo.if_dma_wready axi_ad9684_dma.if_s_axis_ready
add_connection ad9684_adcfifo.if_dma_xfer_req axi_ad9684_dma.if_s_axis_xfer_req
add_connection sys_clk.clk_reset axi_ad9684_dma.s_axi_reset
add_connection sys_clk.clk axi_ad9684_dma.s_axi_clock
add_connection sys_cpu.data_master axi_ad9684_dma.s_axi
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_ad9684_dma.m_dest_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_clk axi_ad9684_dma.m_dest_axi_clock
add_connection axi_ad9684_dma.m_dest_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.irq axi_ad9684_dma.interrupt_sender

# setting interface property

set_interface_property axi_ad9122_device_if EXPORT_OF axi_ad9122.device_if
set_interface_property axi_ad9684_device_if EXPORT_OF axi_ad9684.device_if

# IRQ bridge for the CPLD IRQ signal

add_instance irq_bridge altera_irq_bridge 16.0
set_instance_parameter_value irq_bridge {IRQ_WIDTH} {1}

add_connection sys_clk.clk_reset irq_bridge.clk_reset
add_connection sys_clk.clk irq_bridge.clk
add_connection sys_cpu.irq irq_bridge.sender0_irq

set_interface_property spi_int EXPORT_OF irq_bridge.receiver_irq

# addresses

set_connection_parameter_value sys_cpu.data_master/axi_ad9122.s_axi baseAddress {0x44A00000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9684.s_axi baseAddress {0x44A20000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9122_dma.s_axi baseAddress {0x44A40000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9684_dma.s_axi baseAddress {0x44A60000}

# interrupts

set_connection_parameter_value sys_cpu.irq/irq_bridge.sender0_irq irqNumber {9}
set_connection_parameter_value sys_cpu.irq/axi_ad9122_dma.interrupt_sender irqNumber {10}
set_connection_parameter_value sys_cpu.irq/axi_ad9684_dma.interrupt_sender irqNumber {11}

