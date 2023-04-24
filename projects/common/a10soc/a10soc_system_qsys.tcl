###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# a10soc carrier qsys
set system_type a10soc

# clock-&-reset

add_instance sys_clk clock_source
add_interface sys_clk clock sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
add_interface sys_rstn reset sink
set_interface_property sys_rstn EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

# hps
# round-about way - qsys-script doesn't support {*}?

variable  hps_io_list

proc set_hps_io {io_index io_type} {

  global hps_io_list
  lappend hps_io_list $io_type
}

set_hps_io  IO_DEDICATED_04   SDMMC:D0
set_hps_io  IO_DEDICATED_05   SDMMC:CMD
set_hps_io  IO_DEDICATED_06   SDMMC:CCLK
set_hps_io  IO_DEDICATED_07   SDMMC:D1
set_hps_io  IO_DEDICATED_08   SDMMC:D2
set_hps_io  IO_DEDICATED_09   SDMMC:D3
set_hps_io  IO_DEDICATED_10   NONE
set_hps_io  IO_DEDICATED_11   NONE
set_hps_io  IO_DEDICATED_12   SDMMC:D4
set_hps_io  IO_DEDICATED_13   SDMMC:D5
set_hps_io  IO_DEDICATED_14   SDMMC:D6
set_hps_io  IO_DEDICATED_15   SDMMC:D7
set_hps_io  IO_DEDICATED_16   UART1:TX
set_hps_io  IO_DEDICATED_17   UART1:RX
set_hps_io  IO_SHARED_Q1_01   USB0:CLK
set_hps_io  IO_SHARED_Q1_02   USB0:STP
set_hps_io  IO_SHARED_Q1_03   USB0:DIR
set_hps_io  IO_SHARED_Q1_04   USB0:DATA0
set_hps_io  IO_SHARED_Q1_05   USB0:DATA1
set_hps_io  IO_SHARED_Q1_06   USB0:NXT
set_hps_io  IO_SHARED_Q1_07   USB0:DATA2
set_hps_io  IO_SHARED_Q1_08   USB0:DATA3
set_hps_io  IO_SHARED_Q1_09   USB0:DATA4
set_hps_io  IO_SHARED_Q1_10   USB0:DATA5
set_hps_io  IO_SHARED_Q1_11   USB0:DATA6
set_hps_io  IO_SHARED_Q1_12   USB0:DATA7
set_hps_io  IO_SHARED_Q2_01   EMAC0:TX_CLK
set_hps_io  IO_SHARED_Q2_02   EMAC0:TX_CTL
set_hps_io  IO_SHARED_Q2_03   EMAC0:RX_CLK
set_hps_io  IO_SHARED_Q2_04   EMAC0:RX_CTL
set_hps_io  IO_SHARED_Q2_05   EMAC0:TXD0
set_hps_io  IO_SHARED_Q2_06   EMAC0:TXD1
set_hps_io  IO_SHARED_Q2_07   EMAC0:RXD0
set_hps_io  IO_SHARED_Q2_08   EMAC0:RXD1
set_hps_io  IO_SHARED_Q2_09   EMAC0:TXD2
set_hps_io  IO_SHARED_Q2_10   EMAC0:TXD3
set_hps_io  IO_SHARED_Q2_11   EMAC0:RXD2
set_hps_io  IO_SHARED_Q2_12   EMAC0:RXD3
set_hps_io  IO_SHARED_Q3_01   NONE
set_hps_io  IO_SHARED_Q3_02   NONE
set_hps_io  IO_SHARED_Q3_03   NONE
set_hps_io  IO_SHARED_Q3_04   NONE
set_hps_io  IO_SHARED_Q3_05   NONE
set_hps_io  IO_SHARED_Q3_06   GPIO
set_hps_io  IO_SHARED_Q3_07   NONE
set_hps_io  IO_SHARED_Q3_08   NONE
set_hps_io  IO_SHARED_Q3_09   NONE
set_hps_io  IO_SHARED_Q3_10   NONE
set_hps_io  IO_SHARED_Q3_11   MDIO0:MDIO
set_hps_io  IO_SHARED_Q3_12   MDIO0:MDC
set_hps_io  IO_SHARED_Q4_01   I2C1:SDA
set_hps_io  IO_SHARED_Q4_02   I2C1:SCL
set_hps_io  IO_SHARED_Q4_03   GPIO
set_hps_io  IO_SHARED_Q4_04   NONE
set_hps_io  IO_SHARED_Q4_05   GPIO
set_hps_io  IO_SHARED_Q4_06   GPIO
set_hps_io  IO_SHARED_Q4_07   NONE
set_hps_io  IO_SHARED_Q4_08   NONE
set_hps_io  IO_SHARED_Q4_09   NONE
set_hps_io  IO_SHARED_Q4_10   NONE
set_hps_io  IO_SHARED_Q4_11   NONE
set_hps_io  IO_SHARED_Q4_12   NONE

add_instance sys_hps altera_arria10_hps
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {F2S_Width} {0}
set_instance_parameter_value sys_hps {S2F_Width} {0}
set_instance_parameter_value sys_hps {LWH2F_Enable} {1}
set_instance_parameter_value sys_hps {F2SDRAM_PORT_CONFIG} {6}
set_instance_parameter_value sys_hps {F2SDRAM0_ENABLED} {1}
set_instance_parameter_value sys_hps {F2SDRAM2_ENABLED} {1}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {HPS_IO_Enable} $hps_io_list
set_instance_parameter_value sys_hps {SDMMC_PinMuxing} {IO}
set_instance_parameter_value sys_hps {SDMMC_Mode} {8-bit}
set_instance_parameter_value sys_hps {USB0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {USB0_Mode} {default}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {EMAC0_Mode} {RGMII_with_MDIO}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {UART1_Mode} {No_flow_control}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {I2C1_Mode} {default}
set_instance_parameter_value sys_hps {F2H_COLD_RST_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_FREQ} {175}
set_instance_parameter_value sys_hps {H2F_USER1_CLK_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER1_CLK_FREQ} {250}
set_instance_parameter_value sys_hps {CLK_SDMMC_SOURCE} {1}

add_interface sys_hps_rstn reset sink
set_interface_property sys_hps_rstn EXPORT_OF sys_hps.f2h_cold_reset_req
add_interface sys_hps_out_rstn reset source
set_interface_property sys_hps_out_rstn EXPORT_OF sys_hps.h2f_reset
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_lw_axi_reset
add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io

# common dma interfaces

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {true}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in
add_connection sys_dma_clk.clk sys_hps.f2sdram0_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2sdram0_reset

add_instance sys_dma_clk_2 clock_source
set_instance_parameter_value sys_dma_clk_2 {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk_2 {clockFrequencyKnown} {true}
add_connection sys_clk.clk_reset sys_dma_clk_2.clk_in_reset
add_connection sys_hps.h2f_user1_clock sys_dma_clk_2.clk_in
add_connection sys_dma_clk_2.clk sys_hps.f2sdram2_clock
add_connection sys_dma_clk_2.clk_reset sys_hps.f2sdram2_reset

# ddr4 interface

add_instance sys_hps_ddr4_cntrl altera_emif_a10_hps
set_instance_parameter_value sys_hps_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1066.667}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_DATA_LANES}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_DQS_GROUP} {3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_DBI} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCL} {20}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WTCL} {18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_6}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_60_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS_NO_OCT}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2666}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRCD_NS} {14.25}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRP_NS} {14.25}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {7}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {10}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_VREFDQ_VALUE} {1D}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_LEVEL} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {SHORT_QSYS_INTERFACE_NAMES} {0}

add_interface sys_hps_ddr_rstn reset sink
set_interface_property sys_hps_ddr_rstn EXPORT_OF sys_hps_ddr4_cntrl.global_reset_reset_sink
add_connection sys_hps_ddr4_cntrl.hps_emif_conduit_end sys_hps.emif
add_interface sys_hps_ddr conduit end
set_interface_property sys_hps_ddr EXPORT_OF sys_hps_ddr4_cntrl.mem_conduit_end
add_interface sys_hps_ddr_oct conduit end
set_interface_property sys_hps_ddr_oct EXPORT_OF sys_hps_ddr4_cntrl.oct_conduit_end
add_interface sys_hps_ddr_ref_clk clock sink
set_interface_property sys_hps_ddr_ref_clk EXPORT_OF sys_hps_ddr4_cntrl.pll_ref_clk_clock_sink

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

proc ad_dma_interconnect {m_port} {

  add_connection ${m_port} sys_hps.f2sdram0_data
  set_connection_parameter_value ${m_port}/sys_hps.f2sdram0_data baseAddress {0x0}
}

proc ad_dma_interconnect_2 {m_port} {

  add_connection ${m_port} sys_hps.f2sdram2_data
  set_connection_parameter_value ${m_port}/sys_hps.f2sdram2_data baseAddress {0x0}
}

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

ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq

# architecture specific global variables

set xcvr_reconfig_addr_width 10

