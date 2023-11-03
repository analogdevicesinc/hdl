###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# stratix10soc carrier qsys

set system_type s10soc

# clock & reset

add_instance sys_clk clock_source
add_interface sys_clk clock sink
add_interface sys_rst reset sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

add_instance s10_reset altera_s10_user_rst_clkgate
add_interface rst_ninit_done reset source
set_interface_property rst_ninit_done EXPORT_OF s10_reset.ninit_done

# sysid

add_instance axi_sysid_0 axi_sysid
add_instance rom_sys_0 sysid_rom

add_instance sys_id altera_avalon_sysid_qsys
set_instance_parameter_value sys_id {ID} {0x00000100}
add_connection sys_clk.clk sys_id.clk
add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk rom_sys_0.if_clk
add_connection sys_clk.clk axi_sysid_0.s_axi_clock
add_connection sys_clk.clk_reset axi_sysid_0.s_axi_reset

# hps
# round-about way - qsys-script doesn't support {*}?

variable  hps_io_list

proc set_hps_io {io_index io_type} {

  global hps_io_list
  lappend hps_io_list $io_type
}

set_hps_io IO_SHARED_Q1_1   USB0:CLK
set_hps_io IO_SHARED_Q1_2   USB0:STP
set_hps_io IO_SHARED_Q1_3   USB0:DIR
set_hps_io IO_SHARED_Q1_4   USB0:DATA0
set_hps_io IO_SHARED_Q1_5   USB0:DATA1
set_hps_io IO_SHARED_Q1_6   USB0:NXT
set_hps_io IO_SHARED_Q1_7   USB0:DATA2
set_hps_io IO_SHARED_Q1_8   USB0:DATA3
set_hps_io IO_SHARED_Q1_9   USB0:DATA4
set_hps_io IO_SHARED_Q1_10  USB0:DATA5
set_hps_io IO_SHARED_Q1_11  USB0:DATA6
set_hps_io IO_SHARED_Q1_12  USB0:DATA7
set_hps_io IO_SHARED_Q2_1   EMAC0:TX_CLK
set_hps_io IO_SHARED_Q2_2   EMAC0:TX_CTL
set_hps_io IO_SHARED_Q2_3   EMAC0:RX_CLK
set_hps_io IO_SHARED_Q2_4   EMAC0:RX_CTL
set_hps_io IO_SHARED_Q2_5   EMAC0:TXD0
set_hps_io IO_SHARED_Q2_6   EMAC0:TXD1
set_hps_io IO_SHARED_Q2_7   EMAC0:RXD0
set_hps_io IO_SHARED_Q2_8   EMAC0:RXD1
set_hps_io IO_SHARED_Q2_9   EMAC0:TXD2
set_hps_io IO_SHARED_Q2_10  EMAC0:TXD3
set_hps_io IO_SHARED_Q2_11  EMAC0:RXD2
set_hps_io IO_SHARED_Q1_12  EMAC0:RXD3
set_hps_io IO_SHARED_Q3_1   GPIO
set_hps_io IO_SHARED_Q3_2   GPIO
set_hps_io IO_SHARED_Q3_3   UART0:TX
set_hps_io IO_SHARED_Q3_4   UART0:RX
set_hps_io IO_SHARED_Q3_5   GPIO
set_hps_io IO_SHARED_Q3_6   GPIO
set_hps_io IO_SHARED_Q3_7   I2C1:SDA
set_hps_io IO_SHARED_Q3_8   I2C1:SCL
set_hps_io IO_SHARED_Q3_9   JTAG:TCK
set_hps_io IO_SHARED_Q3_10  JTAG:TMS
set_hps_io IO_SHARED_Q3_11  JTAG:TDO
set_hps_io IO_SHARED_Q3_12  JTAG:TDI
set_hps_io IO_SHARED_Q4_1   SDMMC:D0
set_hps_io IO_SHARED_Q4_2   SDMMC:CMD
set_hps_io IO_SHARED_Q4_3   SDMMC:CCLK
set_hps_io IO_SHARED_Q4_4   SDMMC:D1
set_hps_io IO_SHARED_Q4_5   SDMMC:D2
set_hps_io IO_SHARED_Q4_6   SDMMC:D3
set_hps_io IO_SHARED_Q4_7   HPS_OSC_CLK
set_hps_io IO_SHARED_Q4_8   GPIO
set_hps_io IO_SHARED_Q4_9   GPIO
set_hps_io IO_SHARED_Q4_10  GPIO
set_hps_io IO_SHARED_Q4_11  MDIO0:MDIO
set_hps_io IO_SHARED_Q4_12  MDIO0:MDC

add_instance sys_hps altera_stratix10_hps
set_instance_parameter_value sys_hps {CLK_PERI_PLL_SOURCE2} {0}
set_instance_parameter_value sys_hps {CLK_PSI_SOURCE} {1}
set_instance_parameter_value sys_hps {CLK_S2F_USER0_SOURCE} {1}
set_instance_parameter_value sys_hps {CLK_S2F_USER1_SOURCE} {1}
set_instance_parameter_value sys_hps {CLK_SDMMC_SOURCE} {0}
set_instance_parameter_value sys_hps {CTI_Enable} {0}
set_instance_parameter_value sys_hps {DMA_Enable} {No No No No No No No No}
set_instance_parameter_value sys_hps {EMAC0_CLK} {250}
set_instance_parameter_value sys_hps {EMAC0_Mode} {RGMII_with_MDIO}
set_instance_parameter_value sys_hps {EMAC0_PTP} {0}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {EMAC0_SWITCH_Enable} {0}
set_instance_parameter_value sys_hps {EMAC_PTP_REF_CLK} {100}
set_instance_parameter_value sys_hps {EMIF_BYPASS_CHECK} {0}
set_instance_parameter_value sys_hps {EMIF_CONDUIT_Enable} {1}
set_instance_parameter_value sys_hps {F2SDRAM0_Width} {3}
set_instance_parameter_value sys_hps {F2SDRAM0_ready_latency} {2}
set_instance_parameter_value sys_hps {F2SDRAM_ADDRESS_WIDTH} {32}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {GPIO_REF_CLK} {4}
set_instance_parameter_value sys_hps {GPIO_REF_CLK2} {200}
set_instance_parameter_value sys_hps {H2F_COLD_RST_Enable} {1}
set_instance_parameter_value sys_hps {H2F_PENDING_RST_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_FREQ} {100}
set_instance_parameter_value sys_hps {HPS_IO_Enable} $hps_io_list
set_instance_parameter_value sys_hps {IO_OUTPUT_DELAY12} {17}
set_instance_parameter_value sys_hps {L3_MAIN_FREE_CLK} {400}
set_instance_parameter_value sys_hps {L4_SYS_FREE_CLK} {1}
set_instance_parameter_value sys_hps {LWH2F_ADDRESS_WIDTH} {21}
set_instance_parameter_value sys_hps {LWH2F_Enable} {1}
set_instance_parameter_value sys_hps {LWH2F_ready_latency} {0}
set_instance_parameter_value sys_hps {MPU_CLK_VCCL} {2}
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {PSI_CLK_FREQ} {500}
set_instance_parameter_value sys_hps {S2F_ready_latency} {0}
set_instance_parameter_value sys_hps {SDMMC_Mode} {4-bit}
set_instance_parameter_value sys_hps {SDMMC_PinMuxing} {IO}
set_instance_parameter_value sys_hps {SDMMC_REF_CLK} {200}
set_instance_parameter_value sys_hps {I2C1_Mode} {default}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {SPIM0_Mode} {N/A}
set_instance_parameter_value sys_hps {SPIM0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {SPIM1_Mode} {N/A}
set_instance_parameter_value sys_hps {SPIM1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {STM_Enable} {1}
set_instance_parameter_value sys_hps {TESTIOCTRL_DEBUGCLKSEL} {16}
set_instance_parameter_value sys_hps {TESTIOCTRL_MAINCLKSEL} {8}
set_instance_parameter_value sys_hps {TESTIOCTRL_PERICLKSEL} {8}
set_instance_parameter_value sys_hps {TEST_Enable} {0}
set_instance_parameter_value sys_hps {TRACE_Mode} {N/A}
set_instance_parameter_value sys_hps {TRACE_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {UART0_Mode} {No_flow_control}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {UART1_Mode} {N/A}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {USB0_Mode} {default}
set_instance_parameter_value sys_hps {USB0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {USB1_Mode} {N/A}
set_instance_parameter_value sys_hps {USB1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {USE_DEFAULT_MPU_CLK} {0}
set_instance_parameter_value sys_hps {W_RESET_ACTION} {0}
set_instance_parameter_value sys_hps {eosc1_clk_mhz} {25.0}
set_instance_parameter_value sys_hps {watchdog_reset} {1}

add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_lw_axi_reset
add_connection sys_clk.clk sys_hps.f2h_axi_clock
add_connection sys_clk.clk_reset sys_hps.f2h_axi_reset
add_connection sys_clk.clk sys_hps.h2f_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_axi_reset

add_interface h2f_reset reset source
set_interface_property h2f_reset EXPORT_OF sys_hps.h2f_reset

# common dma interface

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in
add_connection sys_dma_clk.clk sys_hps.f2sdram0_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2sdram0_reset

# hps ddr4 interface

add_instance sys_hps_ddr4_cntrl altera_emif_s10_hps
set_instance_parameter_value sys_hps_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1066.667}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_DATA_LANES}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_DQS_GROUP} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DQ_WIDTH} {72}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_DBI} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCL} {20}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WTCL} {16}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_4}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_48_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_120_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2666}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRCD_NS} {13.50}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRP_NS} {13.50}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {6}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {9}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_VREFDQ_VALUE} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_LEVEL} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {SHORT_QSYS_INTERFACE_NAMES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ECC_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_VDIVW_TOTAL} {120}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQH_UI} {0.74}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSCK_PS} {170}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQSH_CYC} {0.4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TMRD_CK_CYC} {9}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRFC_NS} {350.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSQ_UI} {0.18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDIVW_TOTAL_UI} {0.22}

add_connection sys_hps_ddr4_cntrl.hps_emif sys_hps.hps_emif
add_interface sys_hps_ddr conduit end
set_interface_property sys_hps_ddr EXPORT_OF sys_hps_ddr4_cntrl.mem
add_interface sys_hps_ddr_oct conduit end
set_interface_property sys_hps_ddr_oct EXPORT_OF sys_hps_ddr4_cntrl.oct
add_interface sys_hps_ddr_ref_clk clock sink
set_interface_property sys_hps_ddr_ref_clk EXPORT_OF sys_hps_ddr4_cntrl.pll_ref_clk

# cpu/hps handling

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_hps.f2h_irq0 ${m_port}
  set_connection_parameter_value sys_hps.f2h_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port {avl_bridge ""} {avl_bridge_base 0x00000000} {avl_address_width 18}} {

  if {[string equal ${avl_bridge} ""]} {
    add_connection sys_hps.h2f_lw_axi_master ${m_port}
    set_connection_parameter_value sys_hps.h2f_lw_axi_master/${m_port} baseAddress ${m_base}
  } else {
    if {[lsearch -exact [get_instances] ${avl_bridge}] == -1} {
      ## Instantiate the bridge and connect the interfaces
      add_instance ${avl_bridge} altera_avalon_mm_bridge
      set_instance_parameter_value ${avl_bridge} {ADDRESS_WIDTH} $avl_address_width
      set_instance_parameter_value ${avl_bridge} {SYNC_RESET} {1}
      add_connection sys_hps.h2f_lw_axi_master ${avl_bridge}.s0
      set_connection_parameter_value sys_hps.h2f_lw_axi_master/${avl_bridge}.s0 baseAddress ${avl_bridge_base}
      add_connection sys_clk.clk ${avl_bridge}.clk
      add_connection sys_clk.clk_reset ${avl_bridge}.reset
    }
    add_connection ${avl_bridge}.m0 ${m_port}
    set_connection_parameter_value ${avl_bridge}.m0/${m_port} baseAddress ${m_base}
  }
 }

## Connect the memory mapped interface of an ADI DMAC to the hps.f2sdram0 interface
#  Use an altera_axi_bridge to isolate the bridging logic, which will be generated
#  either way due to the interface attribute differences.
#  This will optimize the interconnects in QSYS design, resulting a smaller and
#  faster logic.
#
# \param[m_port] - the interface name which will be connected to the HPS
#
proc ad_dma_interconnect {m_port} {

  # define the axi_bridge name from the source IP name
  set axi_bridge ""
  append axi_bridge [lindex [split $m_port "."] 0] "_bridge"
  set if_name [lindex [split $m_port "."] 1]

  ## Instantiate the bridge and connect the interfaces
  add_instance ${axi_bridge} altera_axi_bridge
  set_instance_parameter_value ${axi_bridge} {SYNC_RESET} {1}
  set_instance_parameter_value ${axi_bridge} {AXI_VERSION} {AXI4}
  set_instance_parameter_value ${axi_bridge} {DATA_WIDTH} {128}
  set_instance_parameter_value ${axi_bridge} {ADDR_WIDTH} {32}
  ## Naively assuming that this will be used with ADI's DMA only, look for 'src'
  ## or 'dst' in the name of the bridge to identify the direction of the interface
  if {[string equal ${if_name} "m_src_axi"]} {
    set_instance_parameter_value ${axi_bridge} {WRITE_ACCEPTANCE_CAPABILITY} {16}
    set_instance_parameter_value ${axi_bridge} {READ_ACCEPTANCE_CAPABILITY} {1}
    set_instance_parameter_value ${axi_bridge} {COMBINED_ACCEPTANCE_CAPABILITY} {16}
  } elseif {[string equal ${if_name} "m_dest_axi"]} {
    set_instance_parameter_value ${axi_bridge} {WRITE_ACCEPTANCE_CAPABILITY} {1}
    set_instance_parameter_value ${axi_bridge} {READ_ACCEPTANCE_CAPABILITY} {16}
    set_instance_parameter_value ${axi_bridge} {COMBINED_ACCEPTANCE_CAPABILITY} {16}
  } else {
    send_message error "Something went terribly wrong. Maybe you're not using an ADI DMA with the ad_dma_interconnect process?"
  }
  set_instance_parameter_value ${axi_bridge} {S0_ID_WIDTH} {2}
  set_instance_parameter_value ${axi_bridge} {M0_ID_WIDTH} {2}
  set_instance_parameter_value ${axi_bridge} {WRITE_ISSUING_CAPABILITY} {16}
  set_instance_parameter_value ${axi_bridge} {READ_ISSUING_CAPABILITY} {16}
  set_instance_parameter_value ${axi_bridge} {COMBINED_ISSUING_CAPABILITY} {16}

  add_connection sys_clk.clk ${axi_bridge}.clk
  add_connection sys_clk.clk_reset ${axi_bridge}.clk_reset
  add_connection ${m_port} ${axi_bridge}.s0
  add_connection ${axi_bridge}.m0 sys_hps.f2sdram0_data
  set_connection_parameter_value ${axi_bridge}.m0/sys_hps.f2sdram0_data baseAddress {0x0}
}

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
set_instance_parameter_value sys_spi {clockPolarity} {0}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {8}
set_instance_parameter_value sys_spi {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset sys_spi.reset
add_connection sys_clk.clk sys_spi.clk
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external

# base-addresses

ad_cpu_interconnect 0x000000e0 sys_id.control_slave "avl_peripheral_mm_bridge" 0x0000 17
ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port "avl_peripheral_mm_bridge"

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq

# architecture specific global variables

set xcvr_reconfig_addr_width 11

