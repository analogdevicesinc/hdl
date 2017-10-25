# de10 generic qsys
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

variable hps_gpio_list
for {set i 0} {$i < 100} {incr i} {
  lappend hps_gpio_list No
}

proc set_hps_gpio_enable {gpio_index} {

  global hps_gpio_list

  regsub -all {[^0-9]} $gpio_index "" m_gpio_index
  set hps_gpio_list [lreplace $hps_gpio_list $m_gpio_index $m_gpio_index Yes]
}

set_hps_gpio_enable GPIO40
set_hps_gpio_enable GPIO53
set_hps_gpio_enable GPIO54
set_hps_gpio_enable GPIO61

add_instance sys_hps altera_hps
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {F2SDRAM_Type} {}
set_instance_parameter_value sys_hps {F2SDRAM_Width} {}
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
set_instance_parameter_value sys_hps {SPIM0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {SPIM0_Mode} {Full}
set_instance_parameter_value sys_hps {SPIM1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {SPIM1_Mode} {Single Slave Select}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {UART0_Mode} {No Flow Control}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {UART1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C0_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {I2C0_Mode} {I2C}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {I2C1_Mode} {I2C}
set_instance_parameter_value sys_hps {I2C2_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {I2C2_Mode} {Full}
set_instance_parameter_value sys_hps {GPIO_Enable} $hps_gpio_list
set_instance_parameter_value sys_hps {desired_cfg_clk_mhz} {80.0}
set_instance_parameter_value sys_hps {S2FCLK_USER0CLK_Enable} {0}
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
set_instance_parameter_value sys_hps {MEM_TCL} {7}
set_instance_parameter_value sys_hps {MEM_DRV_STR} {RZQ/6}
set_instance_parameter_value sys_hps {MEM_RTT_NOM} {RZQ/6}
set_instance_parameter_value sys_hps {MEM_WTCL} {7}
set_instance_parameter_value sys_hps {MEM_RTT_WR} {Dynamic ODT off}
set_instance_parameter_value sys_hps {TIMING_TIS} {175}
set_instance_parameter_value sys_hps {TIMING_TIH} {250}
set_instance_parameter_value sys_hps {TIMING_TDS} {50}
set_instance_parameter_value sys_hps {TIMING_TDH} {125}
set_instance_parameter_value sys_hps {TIMING_TDQSQ} {120}
set_instance_parameter_value sys_hps {TIMING_TQH} {0.38}
set_instance_parameter_value sys_hps {TIMING_TDQSCK} {400}
set_instance_parameter_value sys_hps {TIMING_TDQSS} {0.25}
set_instance_parameter_value sys_hps {TIMING_TQSH} {0.38}
set_instance_parameter_value sys_hps {TIMING_TDSH} {0.2}
set_instance_parameter_value sys_hps {TIMING_TDSS} {0.2}
set_instance_parameter_value sys_hps {MEM_TINIT_US} {500}
set_instance_parameter_value sys_hps {MEM_TMRD_CK} {4}
set_instance_parameter_value sys_hps {MEM_TRAS_NS} {35.0}
set_instance_parameter_value sys_hps {MEM_TRCD_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TRP_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TREFI_US} {7.8}
set_instance_parameter_value sys_hps {MEM_TRFC_NS} {300.0}
set_instance_parameter_value sys_hps {MEM_TWR_NS} {15.0}
set_instance_parameter_value sys_hps {MEM_TWTR} {4}
set_instance_parameter_value sys_hps {MEM_TFAW_NS} {37.5}
set_instance_parameter_value sys_hps {MEM_TRRD_NS} {7.5}
set_instance_parameter_value sys_hps {MEM_TRTP_NS} {7.5}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_CK_DELAY} {0.6}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_DQS_DELAY} {0.6}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MIN} {-0.01}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MAX} {0.01}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_WITHIN_DQS} {0.02}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_BETWEEN_DQS} {0.02}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQ_TO_DQS_SKEW} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_SKEW} {0.02}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_TO_CK_SKEW} {0.0}
add_interface sys_hps_memory conduit end
set_interface_property sys_hps_memory EXPORT_OF sys_hps.memory
add_interface sys_hps_hps_io conduit end
set_interface_property sys_hps_hps_io EXPORT_OF sys_hps.hps_io
add_interface sys_hps_h2f_reset reset source
set_interface_property sys_hps_h2f_reset EXPORT_OF sys_hps.h2f_reset
add_connection sys_clk.clk sys_hps.h2f_axi_clock
add_connection sys_clk.clk sys_hps.f2h_axi_clock
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_interface sys_hps_i2c2 conduit end
set_interface_property sys_hps_i2c2 EXPORT_OF sys_hps.i2c2
add_interface sys_hps_i2c2_clk clock source
set_interface_property sys_hps_i2c2_clk EXPORT_OF sys_hps.i2c2_clk
add_interface sys_hps_i2c2_scl_in clock sink
set_interface_property sys_hps_i2c2_scl_in EXPORT_OF sys_hps.i2c2_scl_in
add_interface sys_hps_spim0 conduit end
set_interface_property sys_hps_spim0 EXPORT_OF sys_hps.spim0
add_interface sys_hps_spim0_clk clock source
set_interface_property sys_hps_spim0_clk EXPORT_OF sys_hps.spim0_sclk_out

# cpu/hps handling

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_hps.f2h_irq0 ${m_port}
  set_connection_parameter_value sys_hps.f2h_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_hps.h2f_lw_axi_master ${m_port}
  set_connection_parameter_value sys_hps.h2f_lw_axi_master/${m_port} baseAddress ${m_base}
}

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

# id

add_instance sys_id altera_avalon_sysid_qsys
set_instance_parameter_value sys_id {id} {-1395322110}
add_connection sys_clk.clk sys_id.clk
add_connection sys_clk.clk_reset sys_id.reset

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio
set_instance_parameter_value sys_gpio_bd {direction} {Bidir}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {14}
add_connection sys_clk.clk sys_gpio_bd.clk
add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_interface sys_gpio_bd conduit end
set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection

# gpio-0

add_instance sys_gpio_0_0 altera_avalon_pio
set_instance_parameter_value sys_gpio_0_0 {direction} {Bidir}
set_instance_parameter_value sys_gpio_0_0 {generateIRQ} {1}
set_instance_parameter_value sys_gpio_0_0 {width} {32}
add_connection sys_clk.clk sys_gpio_0_0.clk
add_connection sys_clk.clk_reset sys_gpio_0_0.reset
add_interface sys_gpio_0_0 conduit end
set_interface_property sys_gpio_0_0 EXPORT_OF sys_gpio_0_0.external_connection

add_instance sys_gpio_0_1 altera_avalon_pio
set_instance_parameter_value sys_gpio_0_1 {direction} {Bidir}
set_instance_parameter_value sys_gpio_0_1 {generateIRQ} {1}
set_instance_parameter_value sys_gpio_0_1 {width} {4}
add_connection sys_clk.clk sys_gpio_0_1.clk
add_connection sys_clk.clk_reset sys_gpio_0_1.reset
add_interface sys_gpio_0_1 conduit end
set_interface_property sys_gpio_0_1 EXPORT_OF sys_gpio_0_1.external_connection

# gpio-1

add_instance sys_gpio_1_0 altera_avalon_pio
set_instance_parameter_value sys_gpio_1_0 {direction} {Bidir}
set_instance_parameter_value sys_gpio_1_0 {generateIRQ} {1}
set_instance_parameter_value sys_gpio_1_0 {width} {32}
add_connection sys_clk.clk_reset sys_gpio_1_0.reset
add_connection sys_clk.clk sys_gpio_1_0.clk
add_interface sys_gpio_1_0 conduit end
set_interface_property sys_gpio_1_0 EXPORT_OF sys_gpio_1_0.external_connection

add_instance sys_gpio_1_1 altera_avalon_pio
set_instance_parameter_value sys_gpio_1_1 {direction} {Bidir}
set_instance_parameter_value sys_gpio_1_1 {generateIRQ} {1}
set_instance_parameter_value sys_gpio_1_1 {width} {4}
add_connection sys_clk.clk_reset sys_gpio_1_1.reset
add_connection sys_clk.clk sys_gpio_1_1.clk
add_interface sys_gpio_1_1 conduit end
set_interface_property sys_gpio_1_1 EXPORT_OF sys_gpio_1_1.external_connection

# gpio-arduino

add_instance sys_gpio_arduino altera_avalon_pio
set_instance_parameter_value sys_gpio_arduino {direction} {Bidir}
set_instance_parameter_value sys_gpio_arduino {generateIRQ} {1}
set_instance_parameter_value sys_gpio_arduino {width} {8}
add_connection sys_clk.clk sys_gpio_arduino.clk
add_connection sys_clk.clk_reset sys_gpio_arduino.reset
add_interface sys_gpio_arduino conduit end
set_interface_property sys_gpio_arduino EXPORT_OF sys_gpio_arduino.external_connection

# io-interrupts

add_instance sys_hps_irq altera_irq_bridge
set_instance_parameter_value sys_hps_irq {IRQ_N} {0}
set_instance_parameter_value sys_hps_irq {IRQ_WIDTH} {1}
add_connection sys_clk.clk sys_hps_irq.clk
add_connection sys_clk.clk_reset sys_hps_irq.clk_reset
add_interface sys_hps_irq_in interrupt receiver
set_interface_property sys_hps_irq_in EXPORT_OF sys_hps_irq.receiver_irq

# interrupts

ad_cpu_interrupt 0 sys_gpio_bd.irq
ad_cpu_interrupt 1 sys_gpio_0_0.irq
ad_cpu_interrupt 2 sys_gpio_0_1.irq
ad_cpu_interrupt 3 sys_gpio_1_0.irq
ad_cpu_interrupt 4 sys_gpio_1_1.irq
ad_cpu_interrupt 5 sys_gpio_arduino.irq
ad_cpu_interrupt 6 sys_hps_irq.sender0_irq

# cpu interconnects

ad_cpu_interconnect 0x00010000 sys_id.control_slave
ad_cpu_interconnect 0x00010080 sys_gpio_bd.s1
ad_cpu_interconnect 0x00010100 sys_gpio_0_0.s1
ad_cpu_interconnect 0x00010200 sys_gpio_0_1.s1
ad_cpu_interconnect 0x00010300 sys_gpio_1_0.s1
ad_cpu_interconnect 0x00010400 sys_gpio_1_1.s1
ad_cpu_interconnect 0x00010500 sys_gpio_arduino.s1

