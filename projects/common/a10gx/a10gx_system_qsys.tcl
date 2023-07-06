###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# a10gx carrier qsys
set system_type nios

# clock-&-reset

add_instance sys_clk clock_source
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

# memory (int)

add_instance sys_int_mem altera_avalon_onchip_memory2
set_instance_parameter_value sys_int_mem {dataWidth} {32}
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
set_instance_parameter_value sys_int_mem {memorySize} {163840.0}
add_connection sys_clk.clk sys_int_mem.clk1
add_connection sys_clk.clk_reset sys_int_mem.reset1

# memory (tlb)

add_instance sys_tlb_mem altera_avalon_onchip_memory2
set_instance_parameter_value sys_tlb_mem {dataWidth} {32}
set_instance_parameter_value sys_tlb_mem {dualPort} {1}
set_instance_parameter_value sys_tlb_mem {initMemContent} {1}
set_instance_parameter_value sys_tlb_mem {memorySize} {163840.0}
add_connection sys_clk.clk sys_tlb_mem.clk1
add_connection sys_clk.clk_reset sys_tlb_mem.reset1
add_connection sys_clk.clk sys_tlb_mem.clk2
add_connection sys_clk.clk_reset sys_tlb_mem.reset2

# memory (ddr)

add_instance sys_ddr3_cntrl altera_emif
set_instance_parameter_value sys_ddr3_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR3}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_MEM_CLK_FREQ_MHZ} {1066.667}
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
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_DATA_IN_MODE_ENUM} {IN_OCT_120_CAL}
set_instance_parameter_value sys_ddr3_cntrl {PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_FORMAT_ENUM} {MEM_FORMAT_UDIMM}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_DQ_WIDTH} {64}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_ROW_ADDR_WIDTH} {12}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_BANK_ADDR_WIDTH} {3}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_DM_EN} {1}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TCL} {14}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_WTCL} {10}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRCD_NS} {13.09}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRP_NS} {13.09}
set_instance_parameter_value sys_ddr3_cntrl {BOARD_DDR3_USER_RCLK_SLEW_RATE} {5.0}
set_instance_parameter_value sys_ddr3_cntrl {SHORT_QSYS_INTERFACE_NAMES} {1}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_RTT_NOM_ENUM} {DDR3_RTT_NOM_RZQ_2}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_RTT_WR_ENUM} {DDR3_RTT_WR_ODT_DISABLED}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRRD_CYC} {7}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TFAW_NS} {35.0}
set_instance_parameter_value sys_ddr3_cntrl {MEM_DDR3_TRFC_NS} {260.0}
add_connection sys_clk.clk_reset sys_ddr3_cntrl.global_reset_n
add_interface sys_ddr3_cntrl_mem conduit end
add_interface sys_ddr3_cntrl_oct conduit end
add_interface sys_ddr3_cntrl_pll_ref_clk clock sink
set_interface_property sys_ddr3_cntrl_mem EXPORT_OF sys_ddr3_cntrl.mem
set_interface_property sys_ddr3_cntrl_oct EXPORT_OF sys_ddr3_cntrl.oct
set_interface_property sys_ddr3_cntrl_pll_ref_clk EXPORT_OF sys_ddr3_cntrl.pll_ref_clk

# flash bridge

add_instance sys_flash_bridge altera_tristate_conduit_bridge
add_connection sys_clk.clk sys_flash_bridge.clk
add_connection sys_clk.clk_reset sys_flash_bridge.reset

# flash

add_instance sys_flash altera_generic_tristate_controller
set_instance_parameter_value sys_flash {TCM_ADDRESS_W} {24}
set_instance_parameter_value sys_flash {TCM_DATA_W} {32}
set_instance_parameter_value sys_flash {TCM_BYTEENABLE_W} {4}
set_instance_parameter_value sys_flash {TCM_READ_WAIT} {144}
set_instance_parameter_value sys_flash {TCM_WRITE_WAIT} {144}
set_instance_parameter_value sys_flash {TCM_SETUP_WAIT} {33}
set_instance_parameter_value sys_flash {TCM_DATA_HOLD} {33}
set_instance_parameter_value sys_flash {TCM_MAX_PENDING_READ_TRANSACTIONS} {3}
set_instance_parameter_value sys_flash {TCM_TURNAROUND_TIME} {2}
set_instance_parameter_value sys_flash {TCM_TIMING_UNITS} {0}
set_instance_parameter_value sys_flash {TCM_READLATENCY} {2}
set_instance_parameter_value sys_flash {TCM_SYMBOLS_PER_WORD} {4}
set_instance_parameter_value sys_flash {USE_READDATA} {1}
set_instance_parameter_value sys_flash {USE_WRITEDATA} {1}
set_instance_parameter_value sys_flash {USE_READ} {1}
set_instance_parameter_value sys_flash {USE_WRITE} {1}
set_instance_parameter_value sys_flash {USE_BEGINTRANSFER} {0}
set_instance_parameter_value sys_flash {USE_BYTEENABLE} {0}
set_instance_parameter_value sys_flash {USE_CHIPSELECT} {1}
set_instance_parameter_value sys_flash {USE_LOCK} {0}
set_instance_parameter_value sys_flash {USE_ADDRESS} {1}
set_instance_parameter_value sys_flash {USE_WAITREQUEST} {0}
set_instance_parameter_value sys_flash {USE_WRITEBYTEENABLE} {0}
set_instance_parameter_value sys_flash {USE_OUTPUTENABLE} {0}
set_instance_parameter_value sys_flash {USE_RESETREQUEST} {0}
set_instance_parameter_value sys_flash {USE_IRQ} {0}
set_instance_parameter_value sys_flash {USE_RESET_OUTPUT} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_READ} {1}
set_instance_parameter_value sys_flash {ACTIVE_LOW_LOCK} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_WRITE} {1}
set_instance_parameter_value sys_flash {ACTIVE_LOW_CHIPSELECT} {1}
set_instance_parameter_value sys_flash {ACTIVE_LOW_BYTEENABLE} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_OUTPUTENABLE} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_WRITEBYTEENABLE} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_WAITREQUEST} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_BEGINTRANSFER} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_RESETREQUEST} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_IRQ} {0}
set_instance_parameter_value sys_flash {ACTIVE_LOW_RESET_OUTPUT} {0}
set_instance_parameter_value sys_flash {CHIPSELECT_THROUGH_READLATENCY} {0}
set_instance_parameter_value sys_flash {IS_MEMORY_DEVICE} {1}
set_instance_parameter_value sys_flash {MODULE_ASSIGNMENT_KEYS} {embeddedsw.configuration.hwClassnameDriverSupportList \
                                                                 embeddedsw.configuration.hwClassnameDriverSupportDefault \
                                                                 embeddedsw.CMacro.SETUP_VALUE \
                                                                 embeddedsw.CMacro.WAIT_VALUE \
                                                                 embeddedsw.CMacro.HOLD_VALUE \
                                                                 embeddedsw.CMacro.TIMING_UNITS \
                                                                 embeddedsw.CMacro.SIZE \
                                                                 embeddedsw.memoryInfo.MEM_INIT_DATA_WIDTH \
                                                                 embeddedsw.memoryInfo.HAS_BYTE_LANE \
                                                                 embeddedsw.memoryInfo.IS_FLASH \
                                                                 embeddedsw.memoryInfo.GENERATE_DAT_SYM \
                                                                 embeddedsw.memoryInfo.GENERATE_FLASH \
                                                                 embeddedsw.memoryInfo.DAT_SYM_INSTALL_DIR \
                                                                 embeddedsw.memoryInfo.FLASH_INSTALL_DIR}
set_instance_parameter_value sys_flash {MODULE_ASSIGNMENT_VALUES} {altera_avalon_lan91c111:altera_avalon_cfi_flash1616 \
                                                                   altera_avalon_cfi_flash1616 \
                                                                   33 \
                                                                   144 \
                                                                   33 \
                                                                   ns \
                                                                   134217728u \
                                                                   32 \
                                                                   1 \
                                                                   1 \
                                                                   1 \
                                                                   1 \
                                                                   SIM_DIR \
                                                                   APP_DIR}
set_instance_parameter_value sys_flash {INTERFACE_ASSIGNMENT_KEYS} {embeddedsw.configuration.isFlash \
                                                                    embeddedsw.configuration.isMemoryDevice \
                                                                    embeddedsw.configuration.isNonVolatileStorage}
set_instance_parameter_value sys_flash {INTERFACE_ASSIGNMENT_VALUES} {1 \
                                                                      1 \
                                                                      1}

add_connection sys_flash.tcm sys_flash_bridge.tcs
add_connection sys_clk.clk sys_flash.clk
add_connection sys_clk.clk_reset sys_flash.reset

# cpu

add_instance sys_cpu altera_nios2_gen2
set_instance_parameter_value sys_cpu {setting_support31bitdcachebypass} {0}
set_instance_parameter_value sys_cpu {setting_activateTrace} {1}
set_instance_parameter_value sys_cpu {mmu_autoAssignTlbPtrSz} {0}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcOffset} {4096}
set_instance_parameter_value sys_cpu {resetSlave} {sys_flash.uas}
set_instance_parameter_value sys_cpu {mmu_TLBMissExcSlave} {sys_tlb_mem.s2}
set_instance_parameter_value sys_cpu {exceptionSlave} {sys_ddr3_cntrl.ctrl_amm_0}
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
add_connection sys_cpu.instruction_master sys_ddr3_cntrl.ctrl_amm_0
add_connection sys_cpu.data_master sys_ddr3_cntrl.ctrl_amm_0
set_connection_parameter_value sys_cpu.data_master/sys_ddr3_cntrl.ctrl_amm_0 baseAddress {0x0}
set_connection_parameter_value sys_cpu.instruction_master/sys_ddr3_cntrl.ctrl_amm_0 baseAddress {0x0}
set_connection_parameter_value sys_cpu.instruction_master/sys_cpu.debug_mem_slave baseAddress {0x10180800}
set_connection_parameter_value sys_cpu.instruction_master/sys_int_mem.s1 baseAddress {0x10140000}
set_connection_parameter_value sys_cpu.tightly_coupled_instruction_master_0/sys_tlb_mem.s2 baseAddress {0x10200000}
set_connection_parameter_value sys_cpu.tightly_coupled_data_master_0/sys_tlb_mem.s1 baseAddress {0x10200000}

add_connection sys_cpu.data_master sys_flash.uas
set_connection_parameter_value sys_cpu.data_master/sys_flash.uas arbitrationPriority {1}
set_connection_parameter_value sys_cpu.data_master/sys_flash.uas baseAddress {0x11000000}
set_connection_parameter_value sys_cpu.data_master/sys_flash.uas defaultConnection {0}

add_connection sys_cpu.instruction_master sys_flash.uas
set_connection_parameter_value sys_cpu.instruction_master/sys_flash.uas arbitrationPriority {1}
set_connection_parameter_value sys_cpu.instruction_master/sys_flash.uas baseAddress {0x11000000}
set_connection_parameter_value sys_cpu.instruction_master/sys_flash.uas defaultConnection {0}



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

  set avm_bridge ""
  append avm_bridge [lindex [split $m_port "."] 0] "_bridge"
  set if_name [lindex [split $m_port "."] 1]

  ## Instantiate an Avalon Pipeline Bridge, in order to isolate the AXI to Avalon
  ## adapters from the main interconnect
  add_instance ${avm_bridge} altera_avalon_mm_bridge
  set_instance_parameter_value ${avm_bridge} {SYNC_RESET} {1}
  set_instance_parameter_value ${avm_bridge} {DATA_WIDTH} {128}
  set_instance_parameter_value ${avm_bridge} {USE_AUTO_ADDRESS_WIDTH} {1}

  add_connection sys_clk.clk ${avm_bridge}.clk
  add_connection sys_clk.clk_reset ${avm_bridge}.reset
  add_connection ${m_port} ${avm_bridge}.s0
  add_connection ${avm_bridge}.m0 sys_ddr3_cntrl.ctrl_amm_0
  set_connection_parameter_value ${avm_bridge}.m0/sys_ddr3_cntrl.ctrl_amm_0 baseAddress {0x0}

}

# common dma interfaces

add_instance sys_dma_clk clock_source
add_connection sys_ddr3_cntrl.emif_usr_clk sys_dma_clk.clk_in
add_connection sys_ddr3_cntrl.emif_usr_reset_n sys_dma_clk.clk_in_reset

# ethernet

add_instance sys_ethernet altera_eth_tse
set_instance_parameter_value sys_ethernet {core_variation} {MAC_PCS}
set_instance_parameter_value sys_ethernet {ifGMII} {MII_GMII}
set_instance_parameter_value sys_ethernet {transceiver_type} {LVDS_IO}
set_instance_parameter_value sys_ethernet {enable_hd_logic} {0}
set_instance_parameter_value sys_ethernet {useMDIO} {1}
set_instance_parameter_value sys_ethernet {eg_addr} {12}
set_instance_parameter_value sys_ethernet {ing_addr} {12}
set_instance_parameter_value sys_ethernet {enable_sgmii} {1}

add_instance sys_ethernet_dma_rx altera_msgdma
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

add_instance sys_ethernet_dma_tx altera_msgdma
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

add_instance sys_ethernet_reset altera_reset_bridge
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
add_connection sys_ethernet.receive sys_ethernet_dma_rx.st_sink
add_connection sys_ethernet_dma_tx.st_source sys_ethernet.transmit
add_interface sys_ethernet_reset reset source
add_interface sys_ethernet_ref_clk clock sink
add_interface sys_ethernet_mdio conduit end
add_interface sys_ethernet_sgmii conduit end

set_interface_property sys_ethernet_mdio EXPORT_OF sys_ethernet.mac_mdio_connection
set_interface_property sys_ethernet_ref_clk EXPORT_OF sys_ethernet.pcs_ref_clk_clock_connection
set_interface_property sys_ethernet_reset EXPORT_OF sys_ethernet_reset.out_reset
set_interface_property sys_ethernet_sgmii EXPORT_OF sys_ethernet.serial_connection

# sys-id

add_instance sys_id altera_avalon_sysid_qsys
set_instance_parameter_value sys_id {id} {182193580}
add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk sys_id.clk

# timer-1

add_instance sys_timer_1 altera_avalon_timer
set_instance_parameter_value sys_timer_1 {counterSize} {32}
add_connection sys_clk.clk_reset sys_timer_1.reset
add_connection sys_clk.clk sys_timer_1.clk

# timer-2

add_instance sys_timer_2 altera_avalon_timer
set_instance_parameter_value sys_timer_2 {counterSize} {32}
add_connection sys_clk.clk_reset sys_timer_2.reset
add_connection sys_clk.clk sys_timer_2.clk

# uart

add_instance sys_uart altera_avalon_jtag_uart
set_instance_parameter_value sys_uart {allowMultipleConnections} {0}
add_connection sys_clk.clk_reset sys_uart.reset
add_connection sys_clk.clk sys_uart.clk

# gpio-bd

add_instance sys_gpio_bd altera_avalon_pio
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {width} {32}
add_connection sys_clk.clk_reset sys_gpio_bd.reset
add_connection sys_clk.clk sys_gpio_bd.clk
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
set_instance_parameter_value sys_spi {clockPolarity} {0}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {8}
set_instance_parameter_value sys_spi {targetClockRate} {10000000.0}
add_connection sys_clk.clk_reset sys_spi.reset
add_connection sys_clk.clk sys_spi.clk
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
ad_cpu_interconnect 0x00190000 axi_sysid_0.s_axi

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

# exported interfaces
add_interface sys_flash conduit end
set_interface_property sys_flash EXPORT_OF sys_flash_bridge.out

# architecture specific global variables

set xcvr_reconfig_addr_width 10

