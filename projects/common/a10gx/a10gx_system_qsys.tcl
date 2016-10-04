
package require qsys

set_module_property NAME {system_bd}
set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S3F45E2SGE3}

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

add_instance sys_ddr3_cntrl altera_emif 16.0
set_instance_parameter_value sys_ddr3_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR3}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_MEM_CLK_FREQ_MHZ} {533.333}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_DEFAULT_IO} {0}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_AC_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_CK_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_DATA_IO_STD_ENUM} {IO_STD_SSTL_15}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_15}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_DATA_IN_MODE_ENUM} {IN_OCT_40_CAL}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_FORMAT_ENUM} {MEM_FORMAT_UDIMM}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_DQ_WIDTH} {64}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_ROW_ADDR_WIDTH} {12}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_BANK_ADDR_WIDTH} {3}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_DM_EN} {1}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TCL} {13}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_WTCL} {9}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRCD_NS} {10.285}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRP_NS} {10.285}
set_instance_parameter_value sys_ddr3_cntrl {BOARD_DDR3_USER_RCLK_SLEW_RATE} {4.0}
set_instance_parameter_value sys_ddr3_cntrl {SHORT_QSYS_INTERFACE_NAMES} {1}

add_connection sys_clk.clk_reset sys_ddr3_cntrl.global_reset_n
add_interface sys_ddr3_cntrl_mem conduit end
add_interface sys_ddr3_cntrl_oct conduit end
add_interface sys_ddr3_cntrl_pll_ref_clk clock sink

set_interface_property sys_ddr3_cntrl_mem EXPORT_OF sys_ddr3_cntrl.mem
set_interface_property sys_ddr3_cntrl_oct EXPORT_OF sys_ddr3_cntrl.oct
set_interface_property sys_ddr3_cntrl_pll_ref_clk EXPORT_OF sys_ddr3_cntrl.pll_ref_clk

# cpu

add_instance sys_cpu altera_nios2_gen2 16.0
set_instance_parameter_value sys_cpu {setting_support31bitdcachebypass} {0}
set_instance_parameter_value sys_cpu {setting_activateTrace} {1}
set_instance_parameter_value sys_cpu {mmu_autoAssignTlbPtrSz} {0}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcOffset} {4096}
set_instance_parameter_value sys_cpu {resetSlave} {sys_ddr3_cntrl_arch.ctrl_amm_0}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcSlave} {sys_tlb_mem.s2}
set_instance_parameter_value sys_cpu {exceptionSlave} {sys_ddr3_cntrl_arch.ctrl_amm_0}
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
add_connection sys_cpu.data_master sys_cpu.debug_mem_slave
add_connection sys_cpu.instruction_master sys_int_mem.s1
add_connection sys_cpu.data_master sys_int_mem.s1
add_connection sys_cpu.tightly_coupled_instruction_master_0 sys_tlb_mem.s2
add_connection sys_cpu.tightly_coupled_data_master_0 sys_tlb_mem.s1
add_connection sys_cpu.instruction_master sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.data_master sys_ddr3_cntrl.ctrl_amm_0

# ethernet

add_instance sys_ethernet altera_eth_tse 16.0
set_instance_parameter_value sys_ethernet {core_variation} {MAC_PCS}
set_instance_parameter_value sys_ethernet {ifGMII} {MII_GMII}
set_instance_parameter_value sys_ethernet {transceiver_type} {LVDS_IO}
set_instance_parameter_value sys_ethernet {enable_hd_logic} {0}
set_instance_parameter_value sys_ethernet {useMDIO} {1}
set_instance_parameter_value sys_ethernet {eg_addr} {12}
set_instance_parameter_value sys_ethernet {ing_addr} {12}
set_instance_parameter_value sys_ethernet {enable_sgmii} {1}

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

add_instance sys_ethernet_reset altera_reset_bridge 16.0
set_instance_parameter_value sys_ethernet_reset {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value sys_ethernet_reset {NUM_RESET_OUTPUTS} {1}

add_connection sys_clk.clk_reset sys_ethernet.reset_connection
add_connection sys_clk.clk_reset sys_ethernet_dma_rx.reset_n
add_connection sys_clk.clk_reset sys_ethernet_dma_tx.reset_n
add_connection sys_clk.clk_reset sys_ethernet_reset.in_reset
add_connection sys_clk.clk sys_ethernet.control_port_clock_connection
add_connection sys_clk.clk sys_ethernet.receive_clock_connection
add_connection sys_clk.clk sys_ethernet.transmit_clock_connection
add_connection sys_clk.clk sys_ethernet_dma_rx.clock
add_connection sys_clk.clk sys_ethernet_dma_tx.clock
add_connection sys_clk.clk sys_ethernet_reset.clk
add_connection sys_cpu.data_master sys_ethernet.control_port
add_connection sys_cpu.data_master sys_ethernet_dma_rx.csr
add_connection sys_cpu.data_master sys_ethernet_dma_rx.response
add_connection sys_cpu.data_master sys_ethernet_dma_rx.descriptor_slave
add_connection sys_cpu.data_master sys_ethernet_dma_tx.csr
add_connection sys_cpu.data_master sys_ethernet_dma_tx.descriptor_slave
add_connection sys_cpu.irq sys_ethernet_dma_rx.csr_irq
add_connection sys_cpu.irq sys_ethernet_dma_tx.csr_irq
add_connection sys_ethernet.receive sys_ethernet_dma_rx.st_sink
add_connection sys_ethernet_dma_tx.st_source sys_ethernet.transmit
add_connection sys_ethernet_dma_rx.mm_write sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_ethernet_dma_tx.mm_read sys_ddr3_cntrl.ctrl_amm_0
add_interface sys_ethernet_reset reset source
add_interface sys_ethernet_ref_clk clock sink
add_interface sys_ethernet_mdio conduit end
add_interface sys_ethernet_sgmii conduit end

set_interface_property sys_ethernet_mdio EXPORT_OF sys_ethernet.mac_mdio_connection
set_interface_property sys_ethernet_ref_clk EXPORT_OF sys_ethernet.pcs_ref_clk_clock_connection
set_interface_property sys_ethernet_reset EXPORT_OF sys_ethernet_reset.out_reset
set_interface_property sys_ethernet_sgmii EXPORT_OF sys_ethernet.serial_connection

# sys-id

add_instance sys_id altera_avalon_sysid_qsys 16.0
set_instance_parameter_value sys_id {id} {182193580}

add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk sys_id.clk
add_connection sys_cpu.data_master sys_id.control_slave

# timer-1

add_instance sys_timer_1 altera_avalon_timer 16.0
set_instance_parameter_value sys_timer_1 {counterSize} {32}

add_connection sys_clk.clk_reset sys_timer_1.reset
add_connection sys_clk.clk sys_timer_1.clk
add_connection sys_cpu.data_master sys_timer_1.s1
add_connection sys_cpu.irq sys_timer_1.irq

# timer-2

add_instance sys_timer_2 altera_avalon_timer 16.0
set_instance_parameter_value sys_timer_2 {counterSize} {32}

add_connection sys_clk.clk_reset sys_timer_2.reset
add_connection sys_clk.clk sys_timer_2.clk
add_connection sys_cpu.data_master sys_timer_2.s1
add_connection sys_cpu.irq sys_timer_2.irq

# uart

add_instance sys_uart altera_avalon_jtag_uart 16.0
set_instance_parameter_value sys_uart {allowMultipleConnections} {0}

add_connection sys_clk.clk_reset sys_uart.reset
add_connection sys_clk.clk sys_uart.clk
add_connection sys_cpu.data_master sys_uart.avalon_jtag_slave
add_connection sys_cpu.irq sys_uart.irq

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {32}

add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_connection sys_clk.clk sys_gpio_bd.clk
add_connection sys_cpu.data_master sys_gpio_bd.s1
add_connection sys_cpu.irq sys_gpio_bd.irq
add_interface sys_gpio_bd conduit end

set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection

# gpio-in

add_instance sys_gpio_in altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_in {direction} {Input}
set_instance_parameter_value sys_gpio_in {generateIRQ} {1}
set_instance_parameter_value sys_gpio_in {width} {32}

add_connection sys_clk.clk_reset sys_gpio_in.reset
add_connection sys_clk.clk sys_gpio_in.clk
add_connection sys_cpu.data_master sys_gpio_in.s1
add_connection sys_cpu.irq sys_gpio_in.irq
add_interface sys_gpio_in conduit end

set_interface_property sys_gpio_in EXPORT_OF sys_gpio_in.external_connection

# gpio-out

add_instance sys_gpio_out altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_out {direction} {Output}
set_instance_parameter_value sys_gpio_out {generateIRQ} {0}
set_instance_parameter_value sys_gpio_out {width} {32}

add_connection sys_clk.clk_reset sys_gpio_out.reset
add_connection sys_clk.clk sys_gpio_out.clk
add_connection sys_cpu.data_master sys_gpio_out.s1
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
add_connection sys_cpu.data_master sys_spi.spi_control_port
add_connection sys_cpu.irq sys_spi.irq
add_interface sys_spi conduit end

set_interface_property sys_spi EXPORT_OF sys_spi.external

# addresses

set_connection_parameter_value sys_cpu.data_master/sys_ddr3_cntrl.ctrl_amm_0                baseAddress {0x00000000}
set_connection_parameter_value sys_cpu.data_master/sys_int_mem.s1                           baseAddress {0x10140000}
set_connection_parameter_value sys_cpu.data_master/sys_cpu.debug_mem_slave                  baseAddress {0x10180800}
set_connection_parameter_value sys_cpu.data_master/sys_uart.avalon_jtag_slave               baseAddress {0x101814f0}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet.control_port                baseAddress {0x10181000}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet_dma_rx.csr                  baseAddress {0x101814a0}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet_dma_rx.response             baseAddress {0x101814e0}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet_dma_rx.descriptor_slave     baseAddress {0x10181440}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet_dma_tx.csr                  baseAddress {0x10181480}
set_connection_parameter_value sys_cpu.data_master/sys_ethernet_dma_tx.descriptor_slave     baseAddress {0x10181460}
set_connection_parameter_value sys_cpu.data_master/sys_spi.spi_control_port                 baseAddress {0x10181400}
set_connection_parameter_value sys_cpu.data_master/sys_gpio_out.s1                          baseAddress {0x10181500}
set_connection_parameter_value sys_cpu.data_master/sys_gpio_in.s1                           baseAddress {0x101814c0}
set_connection_parameter_value sys_cpu.data_master/sys_gpio_bd.s1                           baseAddress {0x101814d0}
set_connection_parameter_value sys_cpu.data_master/sys_timer_2.s1                           baseAddress {0x10181520}
set_connection_parameter_value sys_cpu.data_master/sys_timer_1.s1                           baseAddress {0x10181420}
set_connection_parameter_value sys_cpu.data_master/sys_id.control_slave                     baseAddress {0x101814e8}
set_connection_parameter_value sys_cpu.instruction_master/sys_ddr3_cntrl.ctrl_amm_0         baseAddress {0x00000000}
set_connection_parameter_value sys_cpu.instruction_master/sys_cpu.debug_mem_slave           baseAddress {0x10180800}
set_connection_parameter_value sys_cpu.instruction_master/sys_int_mem.s1                    baseAddress {0x10140000}
set_connection_parameter_value sys_cpu.tightly_coupled_instruction_master_0/sys_tlb_mem.s2  baseAddress {0x10200000}
set_connection_parameter_value sys_cpu.tightly_coupled_data_master_0/sys_tlb_mem.s1         baseAddress {0x10200000}
set_connection_parameter_value sys_ethernet_dma_tx.mm_read/sys_ddr3_cntrl.ctrl_amm_0        baseAddress {0x00000000}
set_connection_parameter_value sys_ethernet_dma_rx.mm_write/sys_ddr3_cntrl.ctrl_amm_0       baseAddress {0x00000000}

set_connection_parameter_value sys_cpu.irq/sys_ethernet_dma_rx.csr_irq irqNumber  {0}
set_connection_parameter_value sys_cpu.irq/sys_ethernet_dma_tx.csr_irq irqNumber  {1}
set_connection_parameter_value sys_cpu.irq/sys_uart.irq irqNumber                 {2}
set_connection_parameter_value sys_cpu.irq/sys_timer_2.irq irqNumber              {3}
set_connection_parameter_value sys_cpu.irq/sys_timer_1.irq irqNumber              {4}
set_connection_parameter_value sys_cpu.irq/sys_gpio_in.irq irqNumber              {5}
set_connection_parameter_value sys_cpu.irq/sys_gpio_bd.irq irqNumber              {6}
set_connection_parameter_value sys_cpu.irq/sys_spi.irq irqNumber                  {7}

# interrupts


