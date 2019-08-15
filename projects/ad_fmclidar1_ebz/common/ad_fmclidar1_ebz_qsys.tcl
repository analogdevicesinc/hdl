
# interfaces and IO ports

# NOTE: For the ADC SPI we are using the sys_spi instance of the base design

# SPI interface for DAQ's clock chip - fSCLK = 10 MHz

add_instance sys_spi_clockgen altera_avalon_spi
set_instance_parameter_value sys_spi_clockgen {clockPhase} {0}
set_instance_parameter_value sys_spi_clockgen {clockPolarity} {0}
set_instance_parameter_value sys_spi_clockgen {dataWidth} {8}
set_instance_parameter_value sys_spi_clockgen {masterSPI} {1}
set_instance_parameter_value sys_spi_clockgen {numberOfSlaves} {8}
set_instance_parameter_value sys_spi_clockgen {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset sys_spi_clockgen.reset
add_connection sys_clk.clk sys_spi_clockgen.clk
add_interface sys_spi_clockgen conduit end
set_interface_property sys_spi_clockgen EXPORT_OF sys_spi_clockgen.external

# SPI interface for DAQ's VCO chip - fSCLK = 10 MHz

add_instance sys_spi_vco altera_avalon_spi
set_instance_parameter_value sys_spi_vco {clockPhase} {0}
set_instance_parameter_value sys_spi_vco {clockPolarity} {0}
set_instance_parameter_value sys_spi_vco {dataWidth} {8}
set_instance_parameter_value sys_spi_vco {masterSPI} {1}
set_instance_parameter_value sys_spi_vco {numberOfSlaves} {8}
set_instance_parameter_value sys_spi_vco {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset sys_spi_vco.reset
add_connection sys_clk.clk sys_spi_vco.clk
add_interface sys_spi_vco conduit end
set_interface_property sys_spi_vco EXPORT_OF sys_spi_vco.external

# I2C interface for AFE's DAC chip - activate the second I2C HPS interface

set_hps_io IO_SHARED_Q4_08 I2C0:SDA
set_hps_io IO_SHARED_Q4_08 I2C0:SCL
set_instance_parameter_value sys_hps {HPS_IO_Enable} $hps_io_list

# SPI interface for AFE's ADC chip - fSCLK = 10 MHz

add_instance sys_spi_afe_adc altera_avalon_spi
set_instance_parameter_value sys_spi_afe_adc {clockPhase} {0}
set_instance_parameter_value sys_spi_afe_adc {clockPolarity} {0}
set_instance_parameter_value sys_spi_afe_adc {dataWidth} {8}
set_instance_parameter_value sys_spi_afe_adc {masterSPI} {1}
set_instance_parameter_value sys_spi_afe_adc {numberOfSlaves} {8}
set_instance_parameter_value sys_spi_afe_adc {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset sys_spi_afe_adc.reset
add_connection sys_clk.clk sys_spi_afe_adc.clk
add_interface sys_spi_afe_adc conduit end
set_interface_property sys_spi_afe_adc EXPORT_OF sys_spi_afe_adc.external

# AD9694 data interface - JESD204B interface framework

add_instance ad9694_jesd204 adi_jesd204
set_instance_parameter_value ad9694_jesd204 {ID} {0}
set_instance_parameter_value ad9694_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9694_jesd204 {LANE_RATE} $LANE_RATE
set_instance_parameter_value ad9694_jesd204 {NUM_OF_LANES} $NUM_OF_LANES
set_instance_parameter_value ad9694_jesd204 {REFCLK_FREQUENCY} {250}
set_instance_parameter_value ad9694_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value ad9694_jesd204 {EXT_DEVICE_CLK_EN} {true}
set_instance_parameter_value ad9694_jesd204 {LANE_MAP} "3 2 0 1"

add_connection sys_clk.clk ad9694_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9694_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF ad9694_jesd204.ref_clk
add_interface rx_data conduit end
set_interface_property rx_data EXPORT_OF ad9694_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF ad9694_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF ad9694_jesd204.sync

add_instance rx_device_clock altera_clock_bridge
add_interface rx_device_clk clock sink
set_interface_property rx_device_clk EXPORT_OF rx_device_clock.in_clk

add_connection rx_device_clock.out_clk ad9694_jesd204.device_clk

# JESD204B - Transport Layer

add_instance axi_ad9694 ad_ip_jesd204_tpl_adc
set_instance_parameter_value axi_ad9694 {NUM_LANES} $NUM_OF_LANES
set_instance_parameter_value axi_ad9694 {NUM_CHANNELS} $NUM_OF_CHANNELS
set_instance_parameter_value axi_ad9694 {BITS_PER_SAMPLE} $ADC_RESOLUTION
set_instance_parameter_value axi_ad9694 {CONVERTER_RESOLUTION} $ADC_RESOLUTION
set_instance_parameter_value axi_ad9694 {SAMPLES_PER_FRAME} {1}
set_instance_parameter_value axi_ad9694 {OCTETS_PER_FRAME} {1}

add_connection rx_device_clock.out_clk axi_ad9694.link_clk
add_connection axi_ad9694.if_link_sof ad9694_jesd204.link_sof
add_connection ad9694_jesd204.link_data axi_ad9694.link_data
add_connection sys_clk.clk_reset axi_ad9694.s_axi_reset
add_connection sys_clk.clk axi_ad9694.s_axi_clock

# channel packing and DMA instance (plus one dummy channel for TIA_CHSEL)

## NOTE: we round up the NUM_OF_CHANNELS to the next power of two
add_instance util_ad9694_cpack util_cpack2
set_instance_parameter_value util_ad9694_cpack {NUM_OF_CHANNELS} {8}
set_instance_parameter_value util_ad9694_cpack {SAMPLES_PER_CHANNEL} {4}
set_instance_parameter_value util_ad9694_cpack {SAMPLE_DATA_WIDTH} {8}

add_connection rx_device_clock.out_clk util_ad9694_cpack.clk

for {set i 0} {$i < $NUM_OF_CHANNELS} {incr i} {
  add_connection axi_ad9694.adc_ch_$i util_ad9694_cpack.adc_ch_$i
}

# Increase the dma_clk frequency and the data width of the F2SDRAM interface,
# so we can stream 1kSPS@50kHz
set_instance_parameter_value sys_hps {H2F_USER0_CLK_FREQ} {250}
set_instance_parameter_value sys_hps {F2SDRAM_PORT_CONFIG} {7}

add_instance axi_ad9694_dma axi_dmac
set_instance_parameter_value axi_ad9694_dma {DMA_DATA_WIDTH_SRC} {256}
set_instance_parameter_value axi_ad9694_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9694_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9694_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9694_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9694_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9694_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9694_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_ad9694_dma {FIFO_SIZE} {32}

add_connection rx_device_clock.out_clk axi_ad9694_dma.if_fifo_wr_clk
add_connection sys_clk.clk axi_ad9694_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9694_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_ad9694_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9694_dma.m_dest_axi_reset

add_connection util_ad9694_cpack.if_packed_fifo_wr_data axi_ad9694_dma.if_fifo_wr_din
add_connection util_ad9694_cpack.if_packed_fifo_wr_overflow axi_ad9694_dma.if_fifo_wr_overflow
add_connection util_ad9694_cpack.if_fifo_wr_overflow axi_ad9694.if_adc_dovf

ad_dma_interconnect axi_ad9694_dma.m_dest_axi

# laser driver - runs in asynchronous mode, using a 250MHz reference clock
# NOTE: After power up the driver will not generate any pulses, the software
# must configure the AXI Memory Mapped registers and load the configuration.
# This is why the parameter PULSE_PERIOD is 0.

add_instance axi_laser_driver_0 axi_laser_driver
set_instance_parameter_value axi_laser_driver_0 {ASYNC_CLK_EN}  {1}
set_instance_parameter_value axi_laser_driver_0 {PULSE_WIDTH}   {1}
set_instance_parameter_value axi_laser_driver_0 {PULSE_PERIOD}  {0}

add_connection sys_clk.clk axi_laser_driver_0.s_axi_clock
add_connection sys_clk.clk_reset axi_laser_driver_0.s_axi_reset

# laser driver and sync synchronizer

add_connection rx_device_clock.out_clk axi_laser_driver_0.if_ext_clk

add_interface laser_driver conduit end
set_interface_property laser_driver EXPORT_OF axi_laser_driver_0.if_driver_pulse
add_interface laser_driver_en_n conduit end
set_interface_property laser_driver_en_n EXPORT_OF axi_laser_driver_0.if_driver_en_n
add_interface laser_driver_otw_n conduit end
set_interface_property laser_driver_otw_n EXPORT_OF axi_laser_driver_0.if_driver_otw_n
add_interface tia_chsel conduit end
set_interface_property tia_chsel EXPORT_OF axi_laser_driver_0.if_tia_chsel

add_connection axi_laser_driver_0.if_driver_dp_reset util_ad9694_cpack.reset

# the synchronization module, which make sure that the DMA will catch the pulse as
# its sync signal, is instantiate in system_top, export all the necessary signals

add_interface fifo_wr_en_out conduit end
set_interface_property fifo_wr_en_out EXPORT_OF util_ad9694_cpack.if_packed_fifo_wr_en
add_interface fifo_wr_en_in conduit end
set_interface_property fifo_wr_en_in EXPORT_OF axi_ad9694_dma.if_fifo_wr_en
add_interface fifo_wr_sync conduit end
set_interface_property fifo_wr_sync EXPORT_OF axi_ad9694_dma.if_fifo_wr_sync

# software needs to know the used TIA channel selection for each transfer, so
# we create an addition dummy ADC channel whit this information

add_interface adc_data_tia_chsel conduit end
set_interface_property adc_data_tia_chsel EXPORT_OF util_ad9694_cpack.adc_ch_$NUM_OF_CHANNELS

# laser GPIOs

add_instance avl_laser_gpio altera_avalon_pio
set_instance_parameter_value avl_laser_gpio {direction} {Bidir}
set_instance_parameter_value avl_laser_gpio {generateIRQ} {1}
set_instance_parameter_value avl_laser_gpio {width} {14}
add_connection sys_clk.clk avl_laser_gpio.clk
add_connection sys_clk.clk_reset avl_laser_gpio.reset
add_interface laser_gpio conduit end
set_interface_property laser_gpio EXPORT_OF avl_laser_gpio.external_connection

# base addresses

ad_cpu_interconnect 0x00000060 sys_spi_clockgen.spi_control_port
ad_cpu_interconnect 0x00000080 sys_spi_vco.spi_control_port
ad_cpu_interconnect 0x000000A0 sys_spi_afe_adc.spi_control_port
ad_cpu_interconnect 0x00040000 ad9694_jesd204.link_reconfig
ad_cpu_interconnect 0x00044000 ad9694_jesd204.link_management
ad_cpu_interconnect 0x00045000 ad9694_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00048000 ad9694_jesd204.phy_reconfig_0
ad_cpu_interconnect 0x00049000 ad9694_jesd204.phy_reconfig_1
ad_cpu_interconnect 0x0004a000 ad9694_jesd204.phy_reconfig_2
ad_cpu_interconnect 0x0004b000 ad9694_jesd204.phy_reconfig_3
ad_cpu_interconnect 0x0004c000 axi_ad9694_dma.s_axi
ad_cpu_interconnect 0x00050000 axi_ad9694.s_axi
ad_cpu_interconnect 0x00060000 axi_laser_driver_0.s_axi
ad_cpu_interconnect 0x00070000 avl_laser_gpio.s1

# interrupts

ad_cpu_interrupt  8 sys_spi_clockgen.irq
ad_cpu_interrupt  9 sys_spi_vco.irq
ad_cpu_interrupt 10 sys_spi_afe_adc.irq
ad_cpu_interrupt 11 ad9694_jesd204.interrupt
ad_cpu_interrupt 12 axi_ad9694_dma.interrupt_sender
ad_cpu_interrupt 13 axi_laser_driver_0.interrupt_sender
ad_cpu_interrupt 14 avl_laser_gpio.irq

