###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# fm87 carrier qsys

set system_type "Agilex 7"

# clocks & reset

add_instance sys_clk clock_source
add_interface sys_clk clock sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
add_interface sys_rst reset sink
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

add_instance agilex_reset altera_s10_user_rst_clkgate
add_interface rst_ninit_done reset source
set_interface_property rst EXPORT_OF agilex_reset.ninit_done

# hps
# round-about way - qsys-script doesn't support {*}?

variable  hps_io_list

proc set_hps_io {io_index io_type} {

  global hps_io_list
  lappend hps_io_list $io_type
}

set_hps_io HPS_IOA_1   USB0:CLK
set_hps_io HPS_IOA_2   USB0:STP
set_hps_io HPS_IOA_3   USB0:DIR
set_hps_io HPS_IOA_4   USB0:DATA0
set_hps_io HPS_IOA_5   USB0:DATA1
set_hps_io HPS_IOA_6   USB0:NXT
set_hps_io HPS_IOA_7   USB0:DATA2
set_hps_io HPS_IOA_8   USB0:DATA3
set_hps_io HPS_IOA_9   USB0:DATA4
set_hps_io HPS_IOA_10  USB0:DATA5
set_hps_io HPS_IOA_11  USB0:DATA6
set_hps_io HPS_IOA_12  USB0:DATA7
set_hps_io HPS_IOA_13  EMAC0:TX_CLK
set_hps_io HPS_IOA_14  EMAC0:TX_CTL
set_hps_io HPS_IOA_15  EMAC0:RX_CLK
set_hps_io HPS_IOA_16  EMAC0:RX_CTL
set_hps_io HPS_IOA_17  EMAC0:TXD0
set_hps_io HPS_IOA_18  EMAC0:TXD1
set_hps_io HPS_IOA_19  EMAC0:RXD0
set_hps_io HPS_IOA_20  EMAC0:RXD1
set_hps_io HPS_IOA_21  EMAC0:TXD2
set_hps_io HPS_IOA_22  EMAC0:TXD3
set_hps_io HPS_IOA_23  EMAC0:RXD2
set_hps_io HPS_IOA_24  EMAC0:RXD3
set_hps_io HPS_IOB_1   GPIO
set_hps_io HPS_IOB_2   GPIO
set_hps_io HPS_IOB_3   UART0:TX
set_hps_io HPS_IOB_4   UART0:RX
set_hps_io HPS_IOB_5   GPIO
set_hps_io HPS_IOB_6   GPIO
set_hps_io HPS_IOB_7   I2C1:SDA
set_hps_io HPS_IOB_8   I2C1:SCL
set_hps_io HPS_IOB_9   JTAG:TCK
set_hps_io HPS_IOB_10  JTAG:TMS
set_hps_io HPS_IOB_11  JTAG:TDO
set_hps_io HPS_IOB_12  JTAG:TDI
set_hps_io HPS_IOB_13  SDMMC:D0
set_hps_io HPS_IOB_14  SDMMC:CMD
set_hps_io HPS_IOB_15  SDMMC:CCLK
set_hps_io HPS_IOB_16  SDMMC:D1
set_hps_io HPS_IOB_17  SDMMC:D2
set_hps_io HPS_IOB_18  SDMMC:D3
set_hps_io HPS_IOB_19  HPS_OSC_CLK
set_hps_io HPS_IOB_20  GPIO
set_hps_io HPS_IOB_21  GPIO
set_hps_io HPS_IOB_22  GPIO
set_hps_io HPS_IOB_23  MDIO0:MDIO
set_hps_io HPS_IOB_24  MDIO0:MDC

add_instance sys_hps intel_agilex_hps
set_instance_parameter_value sys_hps CLK_GPIO_SOURCE {1}
set_instance_parameter_value sys_hps CLK_EMACA_SOURCE {1}
set_instance_parameter_value sys_hps CLK_EMACB_SOURCE {1}
set_instance_parameter_value sys_hps CLK_EMAC_PTP_SOURCE {1}
set_instance_parameter_value sys_hps CLK_PSI_SOURCE {1}
set_instance_parameter_value sys_hps EMAC0_Mode {RGMII_with_MDIO}
set_instance_parameter_value sys_hps EMAC0_PinMuxing {IO}
set_instance_parameter_value sys_hps EMIF_CONDUIT_Enable {1}
set_instance_parameter_value sys_hps EMIF_DDR_WIDTH {64}
set_instance_parameter_value sys_hps F2SINTERRUPT_Enable {1}
set_instance_parameter_value sys_hps F2S_ADDRESS_WIDTH {32}
set_instance_parameter_value sys_hps F2S_Width {5}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_GTX_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C0_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C1_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC0_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC1_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC2_CLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SDMMC_CCLK {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM0_SCLK_OUT {100}
set_instance_parameter_value sys_hps FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM1_SCLK_OUT {100}
set_instance_parameter_value sys_hps HPS_IO_Enable $hps_io_list
set_instance_parameter_value sys_hps I2C1_Mode {default}
set_instance_parameter_value sys_hps I2C1_PinMuxing {IO}
set_instance_parameter_value sys_hps IO_OUTPUT_DELAY12 {45}
set_instance_parameter_value sys_hps LWH2F_ADDRESS_WIDTH {21}
set_instance_parameter_value sys_hps LWH2F_Enable {1}
set_instance_parameter_value sys_hps MPU_EVENTS_Enable {0}
set_instance_parameter_value sys_hps S2F_ADDRESS_WIDTH {32}
set_instance_parameter_value sys_hps S2F_Width {3}
set_instance_parameter_value sys_hps SDMMC_Mode {4-bit}
set_instance_parameter_value sys_hps SDMMC_PinMuxing {IO}
set_instance_parameter_value sys_hps STM_Enable {1}
set_instance_parameter_value sys_hps UART0_Mode {No_flow_control}
set_instance_parameter_value sys_hps UART0_PinMuxing {IO}
set_instance_parameter_value sys_hps USB0_Mode {default}
set_instance_parameter_value sys_hps USB0_PinMuxing {IO}
set_instance_parameter_value sys_hps watchdog_reset {1}
# TODO: See if these are necessary
set_instance_parameter_value sys_hps W_RESET_ACTION {0}
set_instance_parameter_value sys_hps IO_INPUT_DELAY0 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY1 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY2 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY3 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY4 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY5 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY6 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY7 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY8 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY9 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY10 {126}
set_instance_parameter_value sys_hps IO_INPUT_DELAY11 {126}

set_instance_parameter_value sys_hps H2F_USER0_CLK_Enable {1}
set_instance_parameter_value sys_hps H2F_USER0_CLK_FREQ {250}
set_instance_parameter_value sys_hps CLK_SDMMC_SOURCE {1}

add_interface h2f_reset reset source
set_interface_property h2f_reset EXPORT_OF sys_hps.h2f_reset

add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_lw_axi_reset
add_connection sys_clk.clk sys_hps.h2f_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_axi_reset
add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io

# emif_callbus

add_instance emif_calbus_0 altera_emif_cal
set_instance_parameter_value emif_calbus_0 DIAG_ENABLE_JTAG_UART {0}
set_instance_parameter_value emif_calbus_0 DIAG_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value emif_calbus_0 DIAG_EXPORT_VJI {0}
set_instance_parameter_value emif_calbus_0 DIAG_EXTRA_CONFIGS {}
set_instance_parameter_value emif_calbus_0 DIAG_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
set_instance_parameter_value emif_calbus_0 DIAG_SIM_VERBOSE {0}
set_instance_parameter_value emif_calbus_0 DIAG_SYNTH_FOR_SIM {0}
set_instance_parameter_value emif_calbus_0 NUM_CALBUS_INTERFACE {1}
set_instance_parameter_value emif_calbus_0 SHORT_QSYS_INTERFACE_NAMES {1}

# common dma interfaces

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {true}
set_instance_parameter_value sys_dma_clk {clockFrequency} {250000000.0}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in

add_connection sys_dma_clk.clk sys_hps.f2h_axi_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2h_axi_reset

# sys-id

add_instance sys_id altera_avalon_sysid_qsys
set_instance_parameter_value sys_id {id} {0x00000100}
add_connection sys_clk.clk_reset sys_id.reset
add_connection sys_clk.clk sys_id.clk

# hps emif

add_instance emif_hps altera_emif_fm_hps
set_instance_parameter_value emif_hps PROTOCOL_ENUM {PROTOCOL_DDR4}
set_instance_parameter_value emif_hps PHY_DDR4_RATE_ENUM {RATE_QUARTER}
set_instance_parameter_value emif_hps MEM_DDR4_FORMAT_ENUM {MEM_FORMAT_DISCRETE}
set_instance_parameter_value emif_hps MEM_DDR4_DQ_WIDTH {72}
set_instance_parameter_value emif_hps MEM_DDR4_TCL {0}
set_instance_parameter_value emif_hps MEM_DDR4_WTCL {0}
set_instance_parameter_value emif_hps MEM_DDR4_ROW_ADDR_WIDTH {17}
set_instance_parameter_value emif_hps MEM_DDR4_BANK_ADDR_WIDTH {2}
set_instance_parameter_value emif_hps MEM_DDR4_BANK_GROUP_WIDTH {1}
set_instance_parameter_value emif_hps MEM_DDR4_NUM_OF_DIMMS {1}
set_instance_parameter_value emif_hps MEM_DDR4_RANKS_PER_DIMM {1}
set_instance_parameter_value emif_hps MEM_DDR4_CK_WIDTH {1}
set_instance_parameter_value emif_hps MEM_DDR4_RTT_WR_ENUM {DDR4_RTT_WR_ODT_DISABLED}
set_instance_parameter_value emif_hps MEM_DDR4_DRV_STR_ENUM {DDR4_DRV_STR_RZQ_7}
set_instance_parameter_value emif_hps MEM_DDR4_RTT_NOM_ENUM {DDR4_RTT_NOM_ODT_DISABLED}
set_instance_parameter_value emif_hps MEM_DDR4_RTT_PARK {DDR4_RTT_PARK_RZQ_4}
set_instance_parameter_value emif_hps MEM_DDR4_USE_DEFAULT_ODT {false}
set_instance_parameter_value emif_hps MEM_DDR4_R_ODT0_1X1 {off}
set_instance_parameter_value emif_hps MEM_DDR4_W_ODT0_1X1 {off}
set_instance_parameter_value emif_hps MEM_DDR4_DM_EN {true}
set_instance_parameter_value emif_hps MEM_DDR4_READ_DBI {true}
set_instance_parameter_value emif_hps MEM_DDR4_WRITE_DBI {false}
set_instance_parameter_value emif_hps PHY_DDR4_CONFIG_ENUM {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value emif_hps PHY_DDR4_USER_PING_PONG_EN {false}
set_instance_parameter_value emif_hps PHY_DDR4_DEFAULT_REF_CLK_FREQ {false}
set_instance_parameter_value emif_hps PHY_DDR4_USER_REF_CLK_FREQ_MHZ {166.666}
set_instance_parameter_value emif_hps CTRL_DDR4_ECC_EN {1}
set_instance_parameter_value emif_hps CTRL_DDR4_ECC_AUTO_CORRECTION_EN {1}
set_instance_parameter_value emif_hps PHY_DDR4_DEFAULT_IO {false}
set_instance_parameter_value emif_hps PHY_DDR4_USER_AC_IO_STD_ENUM {IO_STD_SSTL_12}
set_instance_parameter_value emif_hps PHY_DDR4_USER_CK_IO_STD_ENUM {IO_STD_SSTL_12}
set_instance_parameter_value emif_hps PHY_DDR4_USER_DATA_IO_STD_ENUM {IO_STD_POD_12}
set_instance_parameter_value emif_hps PHY_DDR4_USER_AC_MODE_ENUM {OUT_OCT_40_CAL}
set_instance_parameter_value emif_hps PHY_DDR4_USER_CK_MODE_ENUM {OUT_OCT_40_CAL}
set_instance_parameter_value emif_hps PHY_DDR4_USER_DATA_OUT_MODE_ENUM {OUT_OCT_34_CAL}
set_instance_parameter_value emif_hps PHY_DDR4_USER_DATA_IN_MODE_ENUM {IN_OCT_60_CAL}
set_instance_parameter_value emif_hps PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM {IO_STD_TRUE_DIFF_SIGNALING}
set_instance_parameter_value emif_hps PHY_DDR4_USER_RZQ_IO_STD_ENUM {IO_STD_CMOS_12}
set_instance_parameter_value emif_hps PHY_DDR4_MEM_CLK_FREQ_MHZ {1333.33}
set_instance_parameter_value emif_hps DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value emif_hps DIAG_ENABLE_JTAG_UART {false}
set_instance_parameter_value emif_hps DIAG_HMC_HRC {OFF}
set_instance_parameter_value emif_hps DIAG_SOFT_NIOS_MODE {SOFT_NIOS_MODE_DISABLED}
set_instance_parameter_value emif_hps MEM_DDR4_SPEEDBIN_ENUM {DDR4_SPEEDBIN_3200}
set_instance_parameter_value emif_hps MEM_DDR4_TCCD_L_CYC {7}
set_instance_parameter_value emif_hps MEM_DDR4_TCCD_S_CYC {4}
set_instance_parameter_value emif_hps MEM_DDR4_TCL {23}
set_instance_parameter_value emif_hps MEM_DDR4_TDIVW_DJ_CYC {0.1}
set_instance_parameter_value emif_hps MEM_DDR4_TDIVW_TOTAL_UI {0.23}
set_instance_parameter_value emif_hps MEM_DDR4_TDQSCK_PS {160}
set_instance_parameter_value emif_hps MEM_DDR4_TDQSQ_PS {66}
set_instance_parameter_value emif_hps MEM_DDR4_TDQSQ_UI {0.2}
set_instance_parameter_value emif_hps MEM_DDR4_TDQSS_CYC {0.27}
set_instance_parameter_value emif_hps MEM_DDR4_TDSH_CYC {0.18}
set_instance_parameter_value emif_hps MEM_DDR4_TDSS_CYC {0.18}
set_instance_parameter_value emif_hps MEM_DDR4_TDVWP_UI {0.72}
set_instance_parameter_value emif_hps MEM_DDR4_TEMP_CONTROLLED_RFSH_ENA {0}
set_instance_parameter_value emif_hps MEM_DDR4_TEMP_CONTROLLED_RFSH_RANGE {DDR4_TEMP_CONTROLLED_RFSH_NORMAL}
set_instance_parameter_value emif_hps MEM_DDR4_TEMP_SENSOR_READOUT {0}
set_instance_parameter_value emif_hps MEM_DDR4_TFAW_DLR_CYC {16}
set_instance_parameter_value emif_hps MEM_DDR4_TFAW_NS {30.0}
set_instance_parameter_value emif_hps MEM_DDR4_TIH_DC_MV {65}
set_instance_parameter_value emif_hps MEM_DDR4_TIH_PS {65}
set_instance_parameter_value emif_hps MEM_DDR4_TINIT_US {500}
set_instance_parameter_value emif_hps MEM_DDR4_TIS_AC_MV {90}
set_instance_parameter_value emif_hps MEM_DDR4_TIS_PS {40}
set_instance_parameter_value emif_hps MEM_DDR4_TMRD_CK_CYC {8}
set_instance_parameter_value emif_hps MEM_DDR4_TQH_CYC {0.38}
set_instance_parameter_value emif_hps MEM_DDR4_TQH_UI {0.7}
set_instance_parameter_value emif_hps MEM_DDR4_TQSH_CYC {0.4}
set_instance_parameter_value emif_hps MEM_DDR4_TRAS_NS {32.0}
set_instance_parameter_value emif_hps MEM_DDR4_TRCD_NS {13.75}
set_instance_parameter_value emif_hps MEM_DDR4_TREFI_US {7.8}
set_instance_parameter_value emif_hps MEM_DDR4_TRFC_DLR_NS {350.0}
set_instance_parameter_value emif_hps MEM_DDR4_TRFC_NS {350.0}
set_instance_parameter_value emif_hps MEM_DDR4_TRP_NS {13.75}
set_instance_parameter_value emif_hps MEM_DDR4_TRRD_DLR_CYC {4}
set_instance_parameter_value emif_hps MEM_DDR4_TRRD_L_CYC {9}
set_instance_parameter_value emif_hps MEM_DDR4_TRRD_S_CYC {8}
set_instance_parameter_value emif_hps MEM_DDR4_TWLH_CYC {0.13}
set_instance_parameter_value emif_hps MEM_DDR4_TWLH_PS {0.0}
set_instance_parameter_value emif_hps MEM_DDR4_TWLS_CYC {0.13}
set_instance_parameter_value emif_hps MEM_DDR4_TWLS_PS {0.0}
set_instance_parameter_value emif_hps MEM_DDR4_TWR_NS {15.0}
set_instance_parameter_value emif_hps MEM_DDR4_TWTR_L_CYC {10}
set_instance_parameter_value emif_hps MEM_DDR4_TWTR_S_CYC {4}
set_instance_parameter_value emif_hps MEM_DDR4_USER_VREFDQ_TRAINING_RANGE {DDR4_VREFDQ_TRAINING_RANGE_1}
set_instance_parameter_value emif_hps MEM_DDR4_USER_VREFDQ_TRAINING_VALUE {56.0}
set_instance_parameter_value emif_hps MEM_DDR4_USE_DEFAULT_ODT {1}
set_instance_parameter_value emif_hps MEM_DDR4_VDIVW_TOTAL {110}
set_instance_parameter_value emif_hps MEM_DDR4_WRITE_CRC {0}
set_instance_parameter_value emif_hps MEM_DDR4_WRITE_DBI {0}
set_instance_parameter_value emif_hps MEM_DDR4_WRITE_PREAMBLE {1}
set_instance_parameter_value emif_hps MEM_DDR4_WTCL {18}

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

# jtag

add_instance fpga_m altera_jtag_avalon_master
add_instance hps_m altera_jtag_avalon_master

add_connection sys_clk.clk fpga_m.clk
add_connection sys_clk.clk hps_m.clk
add_connection sys_clk.clk_reset fpga_m.clk_reset
add_connection sys_clk.clk_reset hps_m.clk_reset

set_interface_property fpga_m_master EXPORT_OF fpga_m.master
set_interface_property hps_m_master EXPORT_OF hps_m.master
add_connection hps_m.master sys_hps.f2h_axi_slave

set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

# cpu/hps handling

proc ad_dma_interconnect {m_port} {

    add_connection ${m_port} sys_hps.f2h_axi_slave
    set_connection_parameter_value ${m_port}/sys_hps.f2h_axi_slave baseAddress {0x0}
}

proc ad_cpu_interrupt {m_irq m_port} {

    add_connection sys_hps.f2h_irq0 ${m_port}
    set_connection_parameter_value sys_hps.f2h_irq0/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port {avl_bridge ""} {avl_bridge_base 0x00000000} {avl_address_width 18}} {
  if {[string equal ${avl_bridge} ""]} {
    add_connection sys_hps.h2f_axi_master ${m_port}
    set_connection_parameter_value sys_hps.h2f_axi_master/${m_port} baseAddress ${m_base}
  } else {
    if {[lsearch -exact [get_instances] ${avl_bridge}] == -1} {
      ## Instantiate the bridge and connect the interfaces
      add_instance ${avl_bridge} altera_avalon_mm_bridge
      set_instance_parameter_value ${avl_bridge} {ADDRESS_WIDTH} $avl_address_width
      set_instance_parameter_value ${avl_bridge} {SYNC_RESET} {1}
      add_connection sys_hps.h2f_axi_master ${avl_bridge}.s0
      set_connection_parameter_value sys_hps.h2f_axi_master/${avl_bridge}.s0 baseAddress ${avl_bridge_base}
      add_connection sys_clk.clk ${avl_bridge}.clk
      add_connection sys_clk.clk_reset ${avl_bridge}.reset
    }
    add_connection ${avl_bridge}.m0 ${m_port}
    set_connection_parameter_value ${avl_bridge}.m0/${m_port} baseAddress ${m_base}
  }
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

## connections

# exports

add_interface emif_calbus_0 conduit INPUT
add_interface hps_emif conduit INPUT
add_interface emif_calbus_clk clock OUTPUT

add_connection emif_hps.hps_emif/sys_hps.hps_emif
add_connection emif_calbus_0.emif_calbus_clk/emif_hps.emif_calbus_clk
add_connection emif_hps.emif_calbus/emif_calbus_0.emif_calbus_0

set_interface_property emif_hps EXPORT_OF emif_hps.oct
set_interface_property emif_hps_ddr EXPORT_OF emif_hps.mem
set_interface_property sys_hps_f2h EXPORT_OF sys_hps.f2h_stm_hw_events
set_interface_property sys_hps_h2f_cs EXPORT_OF sys_hps.h2f_cs
set_interface_property emif_hps_pll_ref EXPORT_OF emif_hps.pll_ref_clk

# cpu interconnect

ad_cpu_interconnect 0x000000e0 sys_id.control_slave "avl_peripheral_mm_bridge" 0x0000 17
ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi "avl_peripheral_mm_bridge"

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq

set xcvr_reconfig_addr_width 11
