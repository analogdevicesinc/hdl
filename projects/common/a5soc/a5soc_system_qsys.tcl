
package require qsys

set_module_property NAME {system_bd}
set_project_property DEVICE_FAMILY {Arria V}
set_project_property DEVICE {5ASTFD5K3F40I3ES}

set system_type nios

# clock-&-reset

add_instance sys_clk clock_source 16.0
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

# memory (int)

add_instance sys_int_mem altera_avalon_onchip_memory2 16.0
set_instance_parameter_value sys_int_mem {dataWidth} {64}
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
set_instance_parameter_value sys_int_mem {memorySize} {65536.0}
add_connection sys_clk.clk sys_int_mem.clk1
add_connection sys_clk.clk_reset sys_int_mem.reset1

# hps

add_instance sys_hps altera_hps 16.0
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {F2SDRAM_Type} {}
set_instance_parameter_value sys_hps {F2SDRAM_Width} {}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {EMAC1_Mode} {RGMII}
set_instance_parameter_value sys_hps {QSPI_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {QSPI_Mode} {1 SS}
set_instance_parameter_value sys_hps {SDIO_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {SDIO_Mode} {4-bit Data}
set_instance_parameter_value sys_hps {USB1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {USB1_Mode} {SDR}
set_instance_parameter_value sys_hps {SPIM0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {SPIM0_Mode} {Full}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {HPS I/O Set 1}
set_instance_parameter_value sys_hps {UART0_Mode} {No Flow Control}
set_instance_parameter_value sys_hps {I2C0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {I2C0_Mode} {Full}
set_instance_parameter_value sys_hps {use_default_mpu_clk} {0}
set_instance_parameter_value sys_hps {desired_cfg_clk_mhz} {50.0}
set_instance_parameter_value sys_hps {S2FCLK_USER0CLK_Enable} {1}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_Enable} {1}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK_Enable} {0}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {HPS_PROTOCOL} {DDR3}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ} {400.0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ} {25.0}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ_MAX} {800.0}
set_instance_parameter_value sys_hps {MEM_DQ_WIDTH} {40}
set_instance_parameter_value sys_hps {MEM_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value sys_hps {MEM_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_hps {MEM_BANKADDR_WIDTH} {3}
set_instance_parameter_value sys_hps {MEM_RTT_NOM} {RZQ/4}
set_instance_parameter_value sys_hps {TIMING_TIS} {170}
set_instance_parameter_value sys_hps {TIMING_TIH} {120}
set_instance_parameter_value sys_hps {TIMING_TDS} {10}
set_instance_parameter_value sys_hps {TIMING_TDH} {45}
set_instance_parameter_value sys_hps {TIMING_TDQSQ} {100}
set_instance_parameter_value sys_hps {TIMING_TQH} {0.38}
set_instance_parameter_value sys_hps {TIMING_TDQSCK} {225}
set_instance_parameter_value sys_hps {TIMING_TDQSS} {0.27}
set_instance_parameter_value sys_hps {TIMING_TQSH} {0.4}
set_instance_parameter_value sys_hps {TIMING_TDSH} {0.18}
set_instance_parameter_value sys_hps {TIMING_TDSS} {0.18}
set_instance_parameter_value sys_hps {MEM_TINIT_US} {500}
set_instance_parameter_value sys_hps {MEM_TMRD_CK} {4}
set_instance_parameter_value sys_hps {MEM_TRAS_NS} {35.0}
set_instance_parameter_value sys_hps {MEM_TRCD_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TRP_NS} {13.75}
set_instance_parameter_value sys_hps {MEM_TREFI_US} {7.8}
set_instance_parameter_value sys_hps {MEM_TRFC_NS} {260.0}
set_instance_parameter_value sys_hps {MEM_TWR_NS} {15.0}
set_instance_parameter_value sys_hps {MEM_TWTR} {4}
set_instance_parameter_value sys_hps {MEM_TFAW_NS} {35.0}
set_instance_parameter_value sys_hps {MEM_TRRD_NS} {6.0}
set_instance_parameter_value sys_hps {MEM_TRTP_NS} {7.5}

add_interface sys_hps_cpu_clk clock source
set_interface_property sys_hps_cpu_clk EXPORT_OF sys_hps.h2f_user0_clock
add_interface sys_hps_dma_clk clock source
set_interface_property sys_hps_dma_clk EXPORT_OF sys_hps.h2f_user1_clock
add_interface sys_hps_spim0 conduit end
set_interface_property sys_hps_spim0 EXPORT_OF sys_hps.spim0
add_interface sys_hps_spim0_sclk clock source
set_interface_property sys_hps_spim0_sclk EXPORT_OF sys_hps.spim0_sclk_out
add_interface sys_hps_i2c0_scl clock sink
set_interface_property sys_hps_i2c0_scl EXPORT_OF sys_hps.i2c0_scl_in
add_interface sys_hps_i2c0_clk clock source
set_interface_property sys_hps_i2c0_clk EXPORT_OF sys_hps.i2c0_clk
add_interface sys_hps_i2c0 conduit end
set_interface_property sys_hps_i2c0 EXPORT_OF sys_hps.i2c0
add_interface sys_hps_ddr3 conduit end
set_interface_property sys_hps_ddr3 EXPORT_OF sys_hps.memory
add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io
add_interface sys_hps_rstn conduit end
set_interface_property sys_hps_rstn EXPORT_OF sys_hps.h2f_reset
add_connection sys_clk.clk sys_hps.h2f_axi_clock
add_connection sys_hps.h2f_axi_master sys_int_mem.s1
set_connection_parameter_value sys_hps.h2f_axi_master/sys_int_mem.s1 baseAddress {0x0}
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock

# cpu/hps handling

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_hps.f2h_irq0 ${m_port}
  set_connection_parameter_value sys_hps.f2h_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_hps.h2f_lw_axi_master ${m_port}
  set_connection_parameter_value sys_hps.h2f_lw_axi_master/${m_port} baseAddress $m_base
}

proc ad_dma_interconnect {m_port} {

  add_connection ${m_port} sys_hps.f2h_axi_slave
  set_connection_parameter_value ${m_port}/sys_hps.f2h_axi_slave baseAddress {0x0}
}

# common dma interfaces

add_instance sys_dma_clk clock_source 16.0
add_interface sys_dma_clk clock sink
add_interface sys_dma_rst reset sink
set_interface_property sys_dma_clk EXPORT_OF sys_dma_clk.clk_in
set_interface_property sys_dma_rst EXPORT_OF sys_dma_clk.clk_in_reset
set_instance_parameter_value sys_dma_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
add_connection sys_dma_clk.clk sys_hps.f2h_axi_clock

# sys-id

add_instance sys_id altera_avalon_sysid_qsys 16.0
set_instance_parameter_value sys_id {id} {182193580}
add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk sys_id.clk

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {32}
add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_connection sys_clk.clk sys_gpio_bd.clk
add_interface sys_gpio_bd conduit end
set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection

# gpio-in

add_instance sys_gpio_in altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_in {direction} {Input}
set_instance_parameter_value sys_gpio_in {generateIRQ} {1}
set_instance_parameter_value sys_gpio_in {width} {32}
add_connection sys_clk.clk_reset sys_gpio_in.reset
add_connection sys_clk.clk sys_gpio_in.clk
add_interface sys_gpio_in conduit end
set_interface_property sys_gpio_in EXPORT_OF sys_gpio_in.external_connection

# gpio-out

add_instance sys_gpio_out altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_out {direction} {Output}
set_instance_parameter_value sys_gpio_out {generateIRQ} {0}
set_instance_parameter_value sys_gpio_out {width} {32}
add_connection sys_clk.clk_reset sys_gpio_out.reset
add_connection sys_clk.clk sys_gpio_out.clk
add_interface sys_gpio_out conduit end
set_interface_property sys_gpio_out EXPORT_OF sys_gpio_out.external_connection

# base-addresses

ad_cpu_interconnect 0x001814e8 sys_id.control_slave
ad_cpu_interconnect 0x001814d0 sys_gpio_bd.s1
ad_cpu_interconnect 0x001814c0 sys_gpio_in.s1
ad_cpu_interconnect 0x00181500 sys_gpio_out.s1

# interrupts

ad_cpu_interrupt 0 sys_gpio_in.irq
ad_cpu_interrupt 1 sys_gpio_bd.irq

