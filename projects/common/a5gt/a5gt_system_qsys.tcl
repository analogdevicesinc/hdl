
package require qsys

set_module_property NAME {system_bd}
set_project_property DEVICE_FAMILY {Arria V}
set_project_property DEVICE {5AGTFD7K3F40I3}

set system_type nios

# clock-&-reset

add_instance sys_ref_clk clock_source 16.0
add_interface sys_ref_clk clock sink
add_interface sys_ref_rst reset sink
set_interface_property sys_ref_clk EXPORT_OF sys_ref_clk.clk_in
set_interface_property sys_ref_rst EXPORT_OF sys_ref_clk.clk_in_reset
set_instance_parameter_value sys_ref_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_ref_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_ref_clk {resetSynchronousEdges} {DEASSERT}

add_instance sys_clk clock_source 16.0
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {50000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

# system-pll

add_instance sys_pll altera_pll 16.0
set_instance_parameter_value sys_pll {gui_reference_clock_frequency} {100.0}
set_instance_parameter_value sys_pll {gui_use_locked} {1}
set_instance_parameter_value sys_pll {gui_number_of_clocks} {3}
set_instance_parameter_value sys_pll {gui_output_clock_frequency0} {125.0}
set_instance_parameter_value sys_pll {gui_output_clock_frequency1} {25.0}
set_instance_parameter_value sys_pll {gui_output_clock_frequency2} {2.5}
add_connection sys_ref_clk.clk sys_pll.refclk
add_connection sys_ref_clk.clk_reset sys_pll.reset
add_interface sys_125m_clk clock source
add_interface sys_25m_clk clock source
add_interface sys_2m5_clk clock source
add_interface sys_pll_locked conduit end
set_interface_property sys_125m_clk EXPORT_OF sys_pll.outclk0
set_interface_property sys_25m_clk EXPORT_OF sys_pll.outclk1
set_interface_property sys_2m5_clk EXPORT_OF sys_pll.outclk2
set_interface_property sys_pll_locked EXPORT_OF sys_pll.locked

# memory (int)

add_instance sys_int_mem altera_avalon_onchip_memory2 16.0
set_instance_parameter_value sys_int_mem {dataWidth} {32}
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
set_instance_parameter_value sys_int_mem {memorySize} {163840.0}
add_connection sys_clk.clk sys_int_mem.clk1
add_connection sys_clk.clk_reset sys_int_mem.reset1

# memory (tlb)

add_instance sys_tlb_mem altera_avalon_onchip_memory2 16.0
set_instance_parameter_value sys_tlb_mem {dataWidth} {32}
set_instance_parameter_value sys_tlb_mem {dualPort} {1}
set_instance_parameter_value sys_tlb_mem {initMemContent} {1}
set_instance_parameter_value sys_tlb_mem {memorySize} {163840.0}
add_connection sys_clk.clk sys_tlb_mem.clk1
add_connection sys_clk.clk_reset sys_tlb_mem.reset1
add_connection sys_clk.clk sys_tlb_mem.clk2
add_connection sys_clk.clk_reset sys_tlb_mem.reset2

# memory (ddr)

add_instance sys_ddr3_cntrl altera_mem_if_ddr3_emif 16.0
set_instance_parameter_value sys_ddr3_cntrl {SPEED_GRADE} {3}
set_instance_parameter_value sys_ddr3_cntrl {MEM_CLK_FREQ} {400.0}
set_instance_parameter_value sys_ddr3_cntrl {REF_CLK_FREQ} {100.0}
set_instance_parameter_value sys_ddr3_cntrl {RATE} {Quarter}
set_instance_parameter_value sys_ddr3_cntrl {EXPORT_AFI_HALF_CLK} {1}
set_instance_parameter_value sys_ddr3_cntrl {MEM_VENDOR} {Micron}
set_instance_parameter_value sys_ddr3_cntrl {MEM_CLK_FREQ_MAX} {666.667}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DQ_WIDTH} {64}
set_instance_parameter_value sys_ddr3_cntrl {MEM_ROW_ADDR_WIDTH} {12}
set_instance_parameter_value sys_ddr3_cntrl {MEM_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TCL} {11}
set_instance_parameter_value sys_ddr3_cntrl {MEM_RTT_NOM} {RZQ/6}
set_instance_parameter_value sys_ddr3_cntrl {MEM_WTCL} {8}
set_instance_parameter_value sys_ddr3_cntrl {MEM_RTT_WR} {RZQ/4}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TIS} {170}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TIH} {120}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDS} {10}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDH} {45}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDQSQ} {100}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TQH} {0.38}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDQSCK} {255}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDQSS} {0.27}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TQSH} {0.4}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDSH} {0.18}
set_instance_parameter_value sys_ddr3_cntrl {TIMING_TDSS} {0.18}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TINIT_US} {500}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TMRD_CK} {4}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRAS_NS} {35.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRCD_NS} {13.75}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRP_NS} {13.75}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TREFI_US} {7.8}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRFC_NS} {110.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TWR_NS} {15.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TWTR} {6}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TFAW_NS} {30.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRRD_NS} {6.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_TRTP_NS} {7.5}
set_instance_parameter_value sys_ddr3_cntrl {AVL_MAX_SIZE} {256}
add_connection sys_ref_clk.clk sys_ddr3_cntrl.pll_ref_clk
add_connection sys_ref_clk.clk_reset sys_ddr3_cntrl.global_reset
add_connection sys_ref_clk.clk_reset sys_ddr3_cntrl.soft_reset
add_interface sys_ddr3_cntrl_mem conduit end
set_interface_property sys_ddr3_cntrl_mem EXPORT_OF sys_ddr3_cntrl.memory
add_interface sys_ddr3_cntrl_oct conduit end
set_interface_property sys_ddr3_cntrl_oct EXPORT_OF sys_ddr3_cntrl.oct

# cpu clock

add_instance sys_cpu_clk clock_source 16.0
add_connection sys_ddr3_cntrl.afi_half_clk sys_cpu_clk.clk_in
add_connection sys_ddr3_cntrl.afi_reset sys_cpu_clk.clk_in_reset
add_interface sys_cpu_clk clock source
set_interface_property sys_cpu_clk EXPORT_OF sys_cpu_clk.clk
add_interface sys_cpu_reset reset source
set_interface_property sys_cpu_reset EXPORT_OF sys_cpu_clk.clk_reset

# cpu

add_instance sys_cpu altera_nios2_gen2 16.0
set_instance_parameter_value sys_cpu {setting_support31bitdcachebypass} {0}
set_instance_parameter_value sys_cpu {setting_activateTrace} {1}
set_instance_parameter_value sys_cpu {mmu_autoAssignTlbPtrSz} {0}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcOffset} {4096}
set_instance_parameter_value sys_cpu {resetSlave} {sys_ddr3_cntrl.avl}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcSlave} {sys_tlb_mem.s2}
set_instance_parameter_value sys_cpu {exceptionSlave} {sys_ddr3_cntrl.avl}
set_instance_parameter_value sys_cpu {breakSlave} {sys_cpu.jtag_debug_module}
set_instance_parameter_value sys_cpu {mul_32_impl} {3}
set_instance_parameter_value sys_cpu {shift_rot_impl} {0}
set_instance_parameter_value sys_cpu {icache_size} {32768}
set_instance_parameter_value sys_cpu {icache_numTCIM} {1}
set_instance_parameter_value sys_cpu {dcache_size} {32768}
set_instance_parameter_value sys_cpu {dcache_numTCDM} {1}
set_instance_parameter_value sys_cpu {setting_dc_ecc_present} {0}
set_instance_parameter_value sys_cpu {setting_itcm_ecc_present} {0}
set_instance_parameter_value sys_cpu {setting_dtcm_ecc_present} {0}
set_instance_parameter_value sys_cpu {mmu_enabled} $mmu_enabled
add_connection sys_clk.clk sys_cpu.clk
add_connection sys_clk.clk_reset sys_cpu.reset
add_connection sys_cpu.debug_reset_request sys_cpu.reset
add_connection sys_cpu.instruction_master sys_cpu.debug_mem_slave
add_connection sys_cpu.instruction_master sys_int_mem.s1
add_connection sys_cpu.tightly_coupled_instruction_master_0 sys_tlb_mem.s2
add_connection sys_cpu.tightly_coupled_data_master_0 sys_tlb_mem.s1
add_connection sys_cpu.instruction_master sys_ddr3_cntrl.avl
add_connection sys_cpu.data_master sys_ddr3_cntrl.avl
set_connection_parameter_value sys_cpu.data_master/sys_ddr3_cntrl.avl baseAddress {0x0}
set_connection_parameter_value sys_cpu.instruction_master/sys_ddr3_cntrl.avl baseAddress {0x0}
set_connection_parameter_value sys_cpu.instruction_master/sys_cpu.debug_mem_slave baseAddress {0x10180800}
set_connection_parameter_value sys_cpu.instruction_master/sys_int_mem.s1 baseAddress {0x10140000}
set_connection_parameter_value sys_cpu.tightly_coupled_instruction_master_0/sys_tlb_mem.s2 baseAddress {0x10200000}
set_connection_parameter_value sys_cpu.tightly_coupled_data_master_0/sys_tlb_mem.s1 baseAddress {0x10200000}

# cpu/hps handling

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_cpu.irq ${m_port}
  set_connection_parameter_value sys_cpu.irq/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_cpu.data_master ${m_port}
  set_connection_parameter_value sys_cpu.data_master/${m_port} baseAddress [expr ($m_base + 0x10000000)]
}

proc ad_dma_interconnect {m_port} {

  add_connection ${m_port} sys_ddr3_cntrl.avl
  set_connection_parameter_value ${m_port}/sys_ddr3_cntrl.avl  baseAddress {0x0}
}

# common dma interfaces

add_instance sys_dma_clk clock_source 16.0
add_connection sys_ddr3_cntrl.afi_clk sys_dma_clk.clk_in
add_connection sys_ddr3_cntrl.afi_reset sys_dma_clk.clk_in_reset

# ethernet

add_instance sys_ethernet altera_eth_tse 16.0
set_instance_parameter_value sys_ethernet {core_variation} {MAC_ONLY}
set_instance_parameter_value sys_ethernet {ifGMII} {RGMII}
set_instance_parameter_value sys_ethernet {enable_mac_flow_ctrl} {1}
set_instance_parameter_value sys_ethernet {useMDIO} {1}
set_instance_parameter_value sys_ethernet {mdio_clk_div} {30}

add_instance sys_ethernet_dma_rx altera_msgdma 16.0
set_instance_parameter_value sys_ethernet_dma_rx {MODE} {2}
set_instance_parameter_value sys_ethernet_dma_rx {DATA_WIDTH} {64}
set_instance_parameter_value sys_ethernet_dma_rx {DATA_FIFO_DEPTH} {256}
set_instance_parameter_value sys_ethernet_dma_rx {DESCRIPTOR_FIFO_DEPTH} {512}
set_instance_parameter_value sys_ethernet_dma_rx {RESPONSE_PORT} {0}
set_instance_parameter_value sys_ethernet_dma_rx {MAX_BYTE} {2048}
set_instance_parameter_value sys_ethernet_dma_rx {TRANSFER_TYPE} {Unaligned Accesses}
set_instance_parameter_value sys_ethernet_dma_rx {BURST_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_rx {MAX_BURST_COUNT} {64}
set_instance_parameter_value sys_ethernet_dma_rx {ENHANCED_FEATURES} {1}
set_instance_parameter_value sys_ethernet_dma_rx {PACKET_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_rx {ERROR_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_rx {ERROR_WIDTH} {6}

add_instance sys_ethernet_dma_tx altera_msgdma 16.0
set_instance_parameter_value sys_ethernet_dma_tx {MODE} {1}
set_instance_parameter_value sys_ethernet_dma_tx {DATA_WIDTH} {64}
set_instance_parameter_value sys_ethernet_dma_tx {DATA_FIFO_DEPTH} {256}
set_instance_parameter_value sys_ethernet_dma_tx {DESCRIPTOR_FIFO_DEPTH} {512}
set_instance_parameter_value sys_ethernet_dma_tx {MAX_BYTE} {2048}
set_instance_parameter_value sys_ethernet_dma_tx {TRANSFER_TYPE} {Unaligned Accesses}
set_instance_parameter_value sys_ethernet_dma_tx {BURST_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_tx {MAX_BURST_COUNT} {64}
set_instance_parameter_value sys_ethernet_dma_tx {ENHANCED_FEATURES} {1}
set_instance_parameter_value sys_ethernet_dma_tx {PACKET_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_tx {ERROR_ENABLE} {1}
set_instance_parameter_value sys_ethernet_dma_tx {ERROR_WIDTH} {1}

add_connection sys_clk.clk_reset sys_ethernet.reset_connection
add_connection sys_clk.clk_reset sys_ethernet_dma_rx.reset_n
add_connection sys_clk.clk_reset sys_ethernet_dma_tx.reset_n
add_connection sys_clk.clk sys_ethernet.control_port_clock_connection
add_connection sys_clk.clk sys_ethernet.receive_clock_connection
add_connection sys_clk.clk sys_ethernet.transmit_clock_connection
add_connection sys_clk.clk sys_ethernet_dma_rx.clock
add_connection sys_clk.clk sys_ethernet_dma_tx.clock
add_connection sys_ethernet.receive sys_ethernet_dma_rx.st_sink
add_connection sys_ethernet_dma_tx.st_source sys_ethernet.transmit
add_interface sys_ethernet_rx_clk clock sink
add_interface sys_ethernet_tx_clk clock sink
add_interface sys_ethernet_rgmii conduit end
add_interface sys_ethernet_mdio conduit end
add_interface sys_ethernet_status conduit end

set_interface_property sys_ethernet_rx_clk EXPORT_OF sys_ethernet.pcs_mac_rx_clock_connection
set_interface_property sys_ethernet_tx_clk EXPORT_OF sys_ethernet.pcs_mac_tx_clock_connection
set_interface_property sys_ethernet_status EXPORT_OF sys_ethernet.mac_status_connection
set_interface_property sys_ethernet_rgmii EXPORT_OF sys_ethernet.mac_rgmii_connection
set_interface_property sys_ethernet_mdio EXPORT_OF sys_ethernet.mac_mdio_connection

# sys-id

add_instance sys_id altera_avalon_sysid_qsys 16.0
set_instance_parameter_value sys_id {id} {182193580}
add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk sys_id.clk

# timer-1

add_instance sys_timer_1 altera_avalon_timer 16.0
set_instance_parameter_value sys_timer_1 {counterSize} {32}
add_connection sys_clk.clk_reset sys_timer_1.reset
add_connection sys_clk.clk sys_timer_1.clk

# timer-2

add_instance sys_timer_2 altera_avalon_timer 16.0
set_instance_parameter_value sys_timer_2 {counterSize} {32}
add_connection sys_clk.clk_reset sys_timer_2.reset
add_connection sys_clk.clk sys_timer_2.clk

# uart

add_instance sys_uart altera_avalon_jtag_uart 16.0
set_instance_parameter_value sys_uart {allowMultipleConnections} {0}
add_connection sys_clk.clk_reset sys_uart.reset
add_connection sys_clk.clk sys_uart.clk

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

# spi

add_instance sys_spi altera_avalon_spi 16.0
set_instance_parameter_value sys_spi {clockPhase} {0}
set_instance_parameter_value sys_spi {clockPolarity} {0}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {8}
set_instance_parameter_value sys_spi {targetClockRate} {128000.0}
add_connection sys_clk.clk_reset sys_spi.reset
add_connection sys_clk.clk sys_spi.clk
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external

# base-addresses

ad_cpu_interconnect 0x00180800 sys_cpu.debug_mem_slave
ad_cpu_interconnect 0x00140000 sys_int_mem.s1
ad_cpu_interconnect 0x00181000 sys_ethernet.control_port
ad_cpu_interconnect 0x001814a0 sys_ethernet_dma_rx.csr
ad_cpu_interconnect 0x001814e0 sys_ethernet_dma_rx.response
ad_cpu_interconnect 0x00181440 sys_ethernet_dma_rx.descriptor_slave
ad_cpu_interconnect 0x00181480 sys_ethernet_dma_tx.csr
ad_cpu_interconnect 0x00181460 sys_ethernet_dma_tx.descriptor_slave
ad_cpu_interconnect 0x001814e8 sys_id.control_slave
ad_cpu_interconnect 0x00181420 sys_timer_1.s1
ad_cpu_interconnect 0x00181520 sys_timer_2.s1
ad_cpu_interconnect 0x001814f0 sys_uart.avalon_jtag_slave
ad_cpu_interconnect 0x001814d0 sys_gpio_bd.s1
ad_cpu_interconnect 0x001814c0 sys_gpio_in.s1
ad_cpu_interconnect 0x00181500 sys_gpio_out.s1
ad_cpu_interconnect 0x00181400 sys_spi.spi_control_port

# dma interconnects

ad_dma_interconnect sys_ethernet_dma_tx.mm_read
ad_dma_interconnect sys_ethernet_dma_rx.mm_write

# interrupts

ad_cpu_interrupt 0 sys_ethernet_dma_rx.csr_irq
ad_cpu_interrupt 1 sys_ethernet_dma_tx.csr_irq
ad_cpu_interrupt 2 sys_uart.irq
ad_cpu_interrupt 3 sys_timer_2.irq
ad_cpu_interrupt 4 sys_timer_1.irq
ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq


