# c5soc carrier qsys

set system_type c5soc

# system clock

add_instance sys_clk clock_source
set_instance_parameter_value sys_clk {clockFrequency} {50000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {NONE}
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset

# hps

add_instance sys_hps altera_hps
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {F2SDRAM_Type} {Avalon-MM\ Bidirectional AXI-3 AXI-3}
set_instance_parameter_value sys_hps {F2SDRAM_Width} {64 64 64}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {EMAC0_Mode} {N/A}
set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {EMAC1_Mode} {RGMII}
set_instance_parameter_value sys_hps {QSPI_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {QSPI_Mode} {1 SS}
set_instance_parameter_value sys_hps {SDIO_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {SDIO_Mode} {4-bit Data}
set_instance_parameter_value sys_hps {USB0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {USB0_Mode} {N/A}
set_instance_parameter_value sys_hps {USB1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {USB1_Mode} {SDR}
set_instance_parameter_value sys_hps {SPIM0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {SPIM0_Mode} {N/A}
set_instance_parameter_value sys_hps {SPIM1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {SPIM1_Mode} {Single Slave Select}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {UART0_Mode} {No Flow Control}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {UART1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {I2C0_Mode} {Full}
set_instance_parameter_value sys_hps {desired_cfg_clk_mhz} {80.0}
set_instance_parameter_value sys_hps {S2FCLK_USER0CLK_Enable} {1}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_Enable} {0}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {HPS_PROTOCOL} {DDR3}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ} {400.0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ} {25.0}
set_instance_parameter_value sys_hps {MEM_VOLTAGE} {1.5V DDR3}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ_MAX} {800.0}
set_instance_parameter_value sys_hps {MEM_DQ_WIDTH} {32}
set_instance_parameter_value sys_hps {MEM_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value sys_hps {MEM_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_hps {MEM_BANKADDR_WIDTH} {3}
set_instance_parameter_value sys_hps {MEM_TCL} {11}
set_instance_parameter_value sys_hps {MEM_DRV_STR} {RZQ/7}
set_instance_parameter_value sys_hps {MEM_RTT_NOM} {RZQ/4}
set_instance_parameter_value sys_hps {MEM_WTCL} {8}
set_instance_parameter_value sys_hps {MEM_RTT_WR} {RZQ/4}
set_instance_parameter_value sys_hps {TIMING_TIS} {180}
set_instance_parameter_value sys_hps {TIMING_TIH} {140}
set_instance_parameter_value sys_hps {TIMING_TDS} {30}
set_instance_parameter_value sys_hps {TIMING_TDH} {65}
set_instance_parameter_value sys_hps {TIMING_TDQSQ} {125}
set_instance_parameter_value sys_hps {TIMING_TQH} {0.38}
set_instance_parameter_value sys_hps {TIMING_TDQSCK} {255}
set_instance_parameter_value sys_hps {TIMING_TDQSS} {0.25}
set_instance_parameter_value sys_hps {TIMING_TQSH} {0.4}
set_instance_parameter_value sys_hps {TIMING_TDSH} {0.2}
set_instance_parameter_value sys_hps {TIMING_TDSS} {0.2}
set_instance_parameter_value sys_hps {MEM_TINIT_US} {500}
set_instance_parameter_value sys_hps {MEM_TMRD_CK} {4}
set_instance_parameter_value sys_hps {MEM_TRAS_NS} {35.0}
set_instance_parameter_value sys_hps {MEM_TRCD_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TRP_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TREFI_US} {7.8}
set_instance_parameter_value sys_hps {MEM_TRFC_NS} {260.0}
set_instance_parameter_value sys_hps {MEM_TWR_NS} {15.0}
set_instance_parameter_value sys_hps {MEM_TWTR} {4}
set_instance_parameter_value sys_hps {MEM_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps {MEM_TRRD_NS} {7.5}
set_instance_parameter_value sys_hps {MEM_TRTP_NS} {7.5}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_CK_DELAY} {0.03}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_DQS_DELAY} {0.02}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MIN} {0.09}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MAX} {0.16}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_WITHIN_DQS} {0.01}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_BETWEEN_DQS} {0.08}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQ_TO_DQS_SKEW} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_SKEW} {0.03}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_TO_CK_SKEW} {0.0}
add_interface sys_hps_memory conduit end
set_interface_property sys_hps_memory EXPORT_OF sys_hps.memory
add_interface sys_hps_hps_io conduit end
set_interface_property sys_hps_hps_io EXPORT_OF sys_hps.hps_io
add_interface sys_hps_h2f_reset reset source
set_interface_property sys_hps_h2f_reset EXPORT_OF sys_hps.h2f_reset
add_connection sys_clk.clk sys_hps.f2h_sdram0_clock
add_connection sys_clk.clk sys_hps.h2f_axi_clock
add_connection sys_clk.clk sys_hps.f2h_axi_clock
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_interface sys_hps_i2c0 conduit end
set_interface_property sys_hps_i2c0 EXPORT_OF sys_hps.i2c0
add_interface sys_hps_i2c0_clk clock source
set_interface_property sys_hps_i2c0_clk EXPORT_OF sys_hps.i2c0_clk
add_interface sys_hps_i2c0_scl_in clock sink
set_interface_property sys_hps_i2c0_scl_in EXPORT_OF sys_hps.i2c0_scl_in

# cpu/hps handling

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_hps.f2h_irq0 ${m_port}
  set_connection_parameter_value sys_hps.f2h_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_hps.h2f_lw_axi_master ${m_port}
  set_connection_parameter_value sys_hps.h2f_lw_axi_master/${m_port} baseAddress ${m_base}
}

proc ad_dma_interconnect {m_port m_id} {

  if {${m_id} == 1} {
    add_connection ${m_port} sys_hps.f2h_sdram1_data
    set_connection_parameter_value ${m_port}/sys_hps.f2h_sdram1_data baseAddress {0x0000}
    return
  }

  add_connection ${m_port} sys_hps.f2h_sdram2_data
  set_connection_parameter_value ${m_port}/sys_hps.f2h_sdram2_data baseAddress {0x0000}
}

# common dma interfaces

add_instance sys_dma_clk clock_source
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_dma_clk.clk sys_hps.f2h_sdram1_clock
add_connection sys_dma_clk.clk sys_hps.f2h_sdram2_clock

# internal memory

add_instance sys_int_mem altera_avalon_onchip_memory2
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {dataWidth} {64}
set_instance_parameter_value sys_int_mem {memorySize} {65536.0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
add_connection sys_clk.clk sys_int_mem.clk1
add_connection sys_clk.clk_reset sys_int_mem.reset1
add_connection sys_hps.h2f_axi_master sys_int_mem.s1
set_connection_parameter_value sys_hps.h2f_axi_master/sys_int_mem.s1 baseAddress {0x0000}

# display (vga-pll)

add_instance vga_pll altera_pll
set_instance_parameter_value vga_pll {gui_device_speed_grade} {2}
set_instance_parameter_value vga_pll {gui_reference_clock_frequency} {50.0}
set_instance_parameter_value vga_pll {gui_use_locked} {0}
set_instance_parameter_value vga_pll {gui_number_of_clocks} {2}
set_instance_parameter_value vga_pll {gui_output_clock_frequency0} {85.5}
set_instance_parameter_value vga_pll {gui_output_clock_frequency1} {171.0}
add_connection sys_clk.clk vga_pll.refclk
add_connection sys_clk.clk_reset vga_pll.reset

# display (vga-frame-reader)

add_instance vga_frame_reader alt_vip_vfr
set_instance_parameter_value vga_frame_reader {BITS_PER_PIXEL_PER_COLOR_PLANE} {8}
set_instance_parameter_value vga_frame_reader {NUMBER_OF_CHANNELS_IN_PARALLEL} {4}
set_instance_parameter_value vga_frame_reader {NUMBER_OF_CHANNELS_IN_SEQUENCE} {1}
set_instance_parameter_value vga_frame_reader {MAX_IMAGE_WIDTH} {1360}
set_instance_parameter_value vga_frame_reader {MAX_IMAGE_HEIGHT} {768}
set_instance_parameter_value vga_frame_reader {MEM_PORT_WIDTH} {128}
set_instance_parameter_value vga_frame_reader {RMASTER_FIFO_DEPTH} {64}
set_instance_parameter_value vga_frame_reader {RMASTER_BURST_TARGET} {32}
set_instance_parameter_value vga_frame_reader {CLOCKS_ARE_SEPARATE} {1}
add_connection sys_clk.clk vga_frame_reader.clock_master
add_connection sys_clk.clk_reset vga_frame_reader.clock_master_reset
add_connection vga_frame_reader.avalon_master sys_hps.f2h_sdram0_data
set_connection_parameter_value vga_frame_reader.avalon_master/sys_hps.f2h_sdram0_data baseAddress {0x0000}
add_connection vga_pll.outclk0 vga_frame_reader.clock_reset
add_connection sys_clk.clk_reset vga_frame_reader.clock_reset_reset

# display (vga-out-clock)

add_instance vga_out_clock altera_clock_bridge
set_instance_parameter_value vga_out_clock {NUM_CLOCK_OUTPUTS} {1}
add_connection vga_pll.outclk0 vga_out_clock.in_clk
add_interface vga_out_clk clock source
set_interface_property vga_out_clk EXPORT_OF vga_out_clock.out_clk

# display (vga-out-data)

add_instance vga_out_data alt_vip_itc
set_instance_parameter_value vga_out_data {H_ACTIVE_PIXELS} {1360}
set_instance_parameter_value vga_out_data {V_ACTIVE_LINES} {768}
set_instance_parameter_value vga_out_data {BPS} {8}
set_instance_parameter_value vga_out_data {NUMBER_OF_COLOUR_PLANES} {4}
set_instance_parameter_value vga_out_data {COLOUR_PLANES_ARE_IN_PARALLEL} {1}
set_instance_parameter_value vga_out_data {ACCEPT_COLOURS_IN_SEQ} {0}
set_instance_parameter_value vga_out_data {INTERLACED} {0}
set_instance_parameter_value vga_out_data {USE_EMBEDDED_SYNCS} {0}
set_instance_parameter_value vga_out_data {AP_LINE} {0}
set_instance_parameter_value vga_out_data {ANC_LINE} {0}
set_instance_parameter_value vga_out_data {H_BLANK} {0}
set_instance_parameter_value vga_out_data {V_BLANK} {0}
set_instance_parameter_value vga_out_data {H_SYNC_LENGTH} {112}
set_instance_parameter_value vga_out_data {H_FRONT_PORCH} {64}
set_instance_parameter_value vga_out_data {H_BACK_PORCH} {256}
set_instance_parameter_value vga_out_data {V_SYNC_LENGTH} {6}
set_instance_parameter_value vga_out_data {V_FRONT_PORCH} {3}
set_instance_parameter_value vga_out_data {V_BACK_PORCH} {18}
set_instance_parameter_value vga_out_data {F_RISING_EDGE} {0}
set_instance_parameter_value vga_out_data {F_FALLING_EDGE} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_RISING_EDGE} {0}
set_instance_parameter_value vga_out_data {FIELD0_ANC_LINE} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_BLANK} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_SYNC_LENGTH} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_FRONT_PORCH} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_BACK_PORCH} {0}
set_instance_parameter_value vga_out_data {FIFO_DEPTH} {1920}
set_instance_parameter_value vga_out_data {THRESHOLD} {1919}
set_instance_parameter_value vga_out_data {CLOCKS_ARE_SAME} {0}
set_instance_parameter_value vga_out_data {USE_CONTROL} {0}
set_instance_parameter_value vga_out_data {GENERATE_SYNC} {0}
set_instance_parameter_value vga_out_data {NO_OF_MODES} {1}
set_instance_parameter_value vga_out_data {STD_WIDTH} {1}
add_connection vga_pll.outclk0 vga_out_data.is_clk_rst
add_connection sys_clk.clk_reset vga_out_data.is_clk_rst_reset
add_connection vga_frame_reader.avalon_streaming_source vga_out_data.din
add_interface vga_out_data conduit end
set_interface_property vga_out_data EXPORT_OF vga_out_data.clocked_video

# id

add_instance sys_id altera_avalon_sysid_qsys
set_instance_parameter_value sys_id {id} {-1395322110}
add_connection sys_clk.clk sys_id.clk
add_connection sys_clk.clk_reset sys_id.reset

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {32}
add_connection sys_clk.clk sys_gpio_bd.clk
add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_interface sys_gpio_bd conduit end
set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection

# gpio-in

add_instance sys_gpio_in altera_avalon_pio
set_instance_parameter_value sys_gpio_in {direction} {Input}
set_instance_parameter_value sys_gpio_in {generateIRQ} {1}
set_instance_parameter_value sys_gpio_in {width} {32}
add_connection sys_clk.clk_reset sys_gpio_in.reset
add_connection sys_clk.clk sys_gpio_in.clk
add_interface sys_gpio_in conduit end
set_interface_property sys_gpio_in EXPORT_OF sys_gpio_in.external_connection

# gpio-out

add_instance sys_gpio_out altera_avalon_pio
set_instance_parameter_value sys_gpio_out {direction} {Output}
set_instance_parameter_value sys_gpio_out {generateIRQ} {0}
set_instance_parameter_value sys_gpio_out {width} {32}
add_connection sys_clk.clk_reset sys_gpio_out.reset
add_connection sys_clk.clk sys_gpio_out.clk
add_interface sys_gpio_out conduit end
set_interface_property sys_gpio_out EXPORT_OF sys_gpio_out.external_connection

# spi

add_instance sys_spi altera_avalon_spi
set_instance_parameter_value sys_spi {clockPhase} {0}
set_instance_parameter_value sys_spi {clockPolarity} {1}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {1}
set_instance_parameter_value sys_spi {targetClockRate} {50000000.0}
add_connection sys_clk.clk sys_spi.clk
add_connection sys_clk.clk_reset sys_spi.reset
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external

# system id

add_instance axi_sysid_0 axi_sysid
add_instance rom_sys_0 sysid_rom

add_connection axi_sysid_0.if_rom_addr rom_sys_0.if_rom_addr
add_connection rom_sys_0.if_rom_data axi_sysid_0.if_sys_rom_data
add_connection sys_clk.clk rom_sys_0.if_clk
add_connection sys_clk.clk axi_sysid_0.s_axi_clock
add_connection sys_clk.clk_reset axi_sysid_0.s_axi_reset

add_interface pr_rom_data_nc conduit end
set_interface_property pr_rom_data_nc EXPORT_OF axi_sysid_0.if_pr_rom_data

# interrupts

ad_cpu_interrupt 0 sys_gpio_bd.irq
ad_cpu_interrupt 1 sys_spi.irq
ad_cpu_interrupt 4 vga_frame_reader.interrupt_sender

# cpu interconnects

ad_cpu_interconnect 0x00108000 sys_spi.spi_control_port
ad_cpu_interconnect 0x00009000 vga_frame_reader.avalon_slave
ad_cpu_interconnect 0x00010000 sys_id.control_slave
ad_cpu_interconnect 0x00010080 sys_gpio_bd.s1
ad_cpu_interconnect 0x00010100 sys_gpio_in.s1
ad_cpu_interconnect 0x00109000 sys_gpio_out.s1
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi
