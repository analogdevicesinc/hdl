###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Agilex5e carrier qsys, NIOS-V/g variant of projects/common/a5e.
#
# intel_niosv_g has no MMU: this carrier is bare-metal, does not boot Linux, and
# takes its software over JTAG (niosv-download) rather than from the bitstream.
# The ad_cpu_interconnect/ad_cpu_interrupt/ad_dma_interconnect signatures and the
# peripheral addresses match the HPS carrier, so project files are shared.

set system_type "Agilex 5"

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

add_instance gts_reset intel_srcss_gts
set_instance_parameter_value gts_reset {SRC_RS_DISABLE} {1}
set_instance_parameter_value gts_reset {NUM_BANKS_SHORELINE} {1}

add_instance sys_cpu intel_niosv_g
set_instance_parameter_value sys_cpu {clockFrequency} {100000000}
set_instance_parameter_value sys_cpu {resetSlave} {sys_int_mem.s1}
set_instance_parameter_value sys_cpu {resetOffset} {0x0}
set_instance_parameter_value sys_cpu {enableMulDiv} {1}
set_instance_parameter_value sys_cpu {enableFPU} {0}
set_instance_parameter_value sys_cpu {enableBranchPrediction} {1}
set_instance_parameter_value sys_cpu {enableDebug} {1}
set_instance_parameter_value sys_cpu {enableDebugReset} {0}
set_instance_parameter_value sys_cpu {hartId} {0}
set_instance_parameter_value sys_cpu {instCacheSize} {4096}
set_instance_parameter_value sys_cpu {dataCacheSize} {4096}
set_instance_parameter_value sys_cpu {itcm1Size} {0}
set_instance_parameter_value sys_cpu {itcm2Size} {0}
set_instance_parameter_value sys_cpu {dtcm1Size} {0}
set_instance_parameter_value sys_cpu {dtcm2Size} {0}
set_instance_parameter_value sys_cpu {enableCoreLevelInterruptController} {1}
set_instance_parameter_value sys_cpu {numCLICPlatformInterrupts} {32}

set_instance_parameter_value sys_cpu {peripheralRegionABase} {0x00000000}
set_instance_parameter_value sys_cpu {peripheralRegionASize} {0x00100000}

# CPU address map. The peripheral window must keep 0x00000000 - the project layer
# maps its own peripherals there directly, and the device tree assumes it.
#
#   0x00000000..0x000FFFFF  peripheral window (avl_peripheral_mm_bridge)
#   0x08000000..0x0FFFFFFF  sys_emif.s0_axi4lite - EMIF calibration/config port,
#                           128 MB span, only 0x0 or 0x8000000 are legal
#   0x10000000..0x1017FFFF  sys_int_mem - boot and run RAM (1.5 MB, holds full app)
#   0x10200000..0x1023FFFF  sys_ddr_window.windowed_slave - 256 KB view of DDR
#   0x10300000              sys_cpu.dm_agent - debug module
#   0x10310000              sys_cpu.timer_sw_agent - machine timer
#   0x10320000              sys_ddr_window.cntl - DDR window position
#
# NOTE: sys_int_mem enlarged from 256 KB to 1.5 MB so the full ad9088 app runs
# entirely on-chip (instruction_manager only reaches OCM + dm_agent). The debug
# module, machine timer and DDR-window control port were moved up to 0x1030xxxx
# so they clear the enlarged OCM (which now ends at 0x1017FFFF).
add_connection sys_clk.clk sys_cpu.clk
add_connection sys_clk.clk_reset sys_cpu.reset

add_instance sys_int_mem altera_avalon_onchip_memory2
set_instance_parameter_value sys_int_mem {memorySize} {1572864}
set_instance_parameter_value sys_int_mem {dataWidth} {32}
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
set_instance_parameter_value sys_int_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value sys_int_mem {resetrequest_enabled} {0}

add_connection sys_clk.clk sys_int_mem.clk1
add_connection sys_clk.clk_reset sys_int_mem.reset1

add_connection sys_cpu.instruction_manager sys_int_mem.s1
set_connection_parameter_value sys_cpu.instruction_manager/sys_int_mem.s1 baseAddress {0x10000000}
add_connection sys_cpu.data_manager sys_int_mem.s1
set_connection_parameter_value sys_cpu.data_manager/sys_int_mem.s1 baseAddress {0x10000000}

add_connection sys_cpu.instruction_manager sys_cpu.dm_agent
set_connection_parameter_value sys_cpu.instruction_manager/sys_cpu.dm_agent baseAddress {0x10300000}
add_connection sys_cpu.data_manager sys_cpu.dm_agent
set_connection_parameter_value sys_cpu.data_manager/sys_cpu.dm_agent baseAddress {0x10300000}

add_connection sys_cpu.data_manager sys_cpu.timer_sw_agent
set_connection_parameter_value sys_cpu.data_manager/sys_cpu.timer_sw_agent baseAddress {0x10310000}

# stdout: read on the host with juart-terminal
add_instance sys_uart altera_avalon_jtag_uart
set_instance_parameter_value sys_uart {readBufferDepth} {64}
set_instance_parameter_value sys_uart {writeBufferDepth} {64}

add_connection sys_clk.clk sys_uart.clk
add_connection sys_clk.clk_reset sys_uart.reset

add_instance sys_timer altera_avalon_timer
set_instance_parameter_value sys_timer {alwaysRun} {0}
set_instance_parameter_value sys_timer {counterSize} {32}
set_instance_parameter_value sys_timer {fixedPeriod} {0}
set_instance_parameter_value sys_timer {period} {1}
set_instance_parameter_value sys_timer {periodUnits} {MSEC}
set_instance_parameter_value sys_timer {resetOutput} {0}
set_instance_parameter_value sys_timer {snapshot} {1}
set_instance_parameter_value sys_timer {systemFrequency} {100000000}
set_instance_parameter_value sys_timer {timeoutPulseOutput} {0}
set_instance_parameter_value sys_timer {watchdogPulse} {2}

add_connection sys_clk.clk sys_timer.clk
add_connection sys_clk.clk_reset sys_timer.reset
add_instance sys_emif emif_io96b_ddr4comp

set_instance_parameter_value sys_emif ADV_CAL_ENABLE_MARGIN {0}
set_instance_parameter_value sys_emif ADV_CAL_ENABLE_REQ {1}
set_instance_parameter_value sys_emif ADV_CAL_ENABLE_WEQ {1}
set_instance_parameter_value sys_emif ANALOG_PARAM_DERIVATION_PARAM_NAME {}
set_instance_parameter_value sys_emif CTRL_AUTO_PRECHARGE_EN {0}
set_instance_parameter_value sys_emif CTRL_DMDBI_EN {0}
set_instance_parameter_value sys_emif CTRL_DM_EN {1}
set_instance_parameter_value sys_emif CTRL_ECC_AUTOCORRECT_EN {1}
set_instance_parameter_value sys_emif CTRL_PERFORMANCE_PROFILE {SEQ}
set_instance_parameter_value sys_emif CTRL_RD_DBI_EN {0}
set_instance_parameter_value sys_emif CTRL_SCRAMBLER_EN {0}
set_instance_parameter_value sys_emif CTRL_WR_DBI_EN {0}
set_instance_parameter_value sys_emif DIAG_EXTRA_PARAMETERS {}
set_instance_parameter_value sys_emif DIAG_HMC_ADDR_SWAP_EN {0}
set_instance_parameter_value sys_emif EX_DESIGN_PMON_EN {0}
set_instance_parameter_value sys_emif EX_DESIGN_PMON_INTERNAL_JAMB_EN {1}
set_instance_parameter_value sys_emif HPS_EMIF_RZQ_SHARING {0}
set_instance_parameter_value sys_emif INSTANCE_ID {0}
set_instance_parameter_value sys_emif IS_HPS {0}
set_instance_parameter_value sys_emif PHY_MAINBAND_ACCESS_MODE_AUTOSET_EN {0}
set_instance_parameter_value sys_emif PHY_MAINBAND_ACCESS_MODE {SYNC}
set_instance_parameter_value sys_emif PHY_SIDEBAND_ACCESS_MODE {FABRIC}
set_instance_parameter_value sys_emif JEDEC_OVERRIDE_TABLE_PARAM_NAME {}
set_instance_parameter_value sys_emif MEM_3DS_EN {0}
set_instance_parameter_value sys_emif MEM_AC_MIRRORING_EN {0}
set_instance_parameter_value sys_emif MEM_AC_PARITY_EN {0}
set_instance_parameter_value sys_emif MEM_AC_PARITY_LATENCY_MODE {0.0}
set_instance_parameter_value sys_emif MEM_AL_CYC {0.0}
set_instance_parameter_value sys_emif MEM_A_WIDTH {17}
set_instance_parameter_value sys_emif MEM_BANK_ADDR_WIDTH {2}
set_instance_parameter_value sys_emif MEM_BANK_GROUP_ADDR_WIDTH {2}
set_instance_parameter_value sys_emif MEM_CHANNEL_ADDR_NUM_BITS {36}
set_instance_parameter_value sys_emif MEM_CHANNEL_CAPACITY_GBITS {64}
set_instance_parameter_value sys_emif MEM_CHANNEL_CS_WIDTH {1}
set_instance_parameter_value sys_emif MEM_CHANNEL_ECC_DQ_WIDTH {8}
set_instance_parameter_value sys_emif MEM_CKE_WIDTH {1}
set_instance_parameter_value sys_emif MEM_CK_WIDTH {1}
set_instance_parameter_value sys_emif MEM_CLAMSHELL_EN {0}
set_instance_parameter_value sys_emif MEM_CL_CYC {12.0}
set_instance_parameter_value sys_emif MEM_COL_ADDR_WIDTH {10}
set_instance_parameter_value sys_emif MEM_CS_WIDTH {1}
set_instance_parameter_value sys_emif MEM_CS_WIDTH_PHYSICAL {1}
set_instance_parameter_value sys_emif MEM_CWL_CYC {9.0}
set_instance_parameter_value sys_emif MEM_C_WIDTH {0}
set_instance_parameter_value sys_emif MEM_DIE_DENSITY_GBITS {16}
set_instance_parameter_value sys_emif MEM_DIE_DQ_WIDTH {8}
set_instance_parameter_value sys_emif MEM_DQ_PER_DQS {8}
set_instance_parameter_value sys_emif MEM_DQ_VREF {35}
set_instance_parameter_value sys_emif MEM_FINE_GRANULARITY_REFRESH_MODE {1.0}
set_instance_parameter_value sys_emif MEM_NUM_CHANNELS {1}
set_instance_parameter_value sys_emif MEM_NUM_CHANNELS_PER_IO96 {1}
set_instance_parameter_value sys_emif MEM_NUM_IO96 {1}
set_instance_parameter_value sys_emif MEM_ODT_DQ_X_IDLE {off}
set_instance_parameter_value sys_emif MEM_ODT_DQ_X_NON_TGT_RD {off}
set_instance_parameter_value sys_emif MEM_ODT_DQ_X_NON_TGT_WR {off}
set_instance_parameter_value sys_emif MEM_ODT_DQ_X_RON {7}
set_instance_parameter_value sys_emif MEM_ODT_DQ_X_TGT_WR {4}
set_instance_parameter_value sys_emif MEM_ODT_NOM {off}
set_instance_parameter_value sys_emif MEM_ODT_PARK {4}
set_instance_parameter_value sys_emif MEM_ODT_WR {off}
set_instance_parameter_value sys_emif MEM_OPERATING_FREQ_MHZ {800}
set_instance_parameter_value sys_emif MEM_OPERATING_FREQ_MHZ_AUTOSET_EN {0}
set_instance_parameter_value sys_emif MEM_PAGE_SIZE {1024.0}
set_instance_parameter_value sys_emif MEM_RANKS_SHARE_CK_EN {1}
set_instance_parameter_value sys_emif MEM_RD_PREAMBLE_MODE {1.0}
set_instance_parameter_value sys_emif MEM_ROW_ADDR_WIDTH {17}
set_instance_parameter_value sys_emif MEM_SPEEDBIN {3200AA}
set_instance_parameter_value sys_emif MEM_SPEEDBIN_DATARATE {3200}
set_instance_parameter_value sys_emif MEM_TCCD_DLR_NS {5.0}
set_instance_parameter_value sys_emif MEM_TCCD_L_NS {5.0}
set_instance_parameter_value sys_emif MEM_TCCD_S_NS {4.0}
set_instance_parameter_value sys_emif MEM_TCKESR_CYC {5.0}
set_instance_parameter_value sys_emif MEM_TCKE_NS {4.0}
set_instance_parameter_value sys_emif MEM_TCKSRE_NS {8.0}
set_instance_parameter_value sys_emif MEM_TCKSRX_NS {8.0}
set_instance_parameter_value sys_emif MEM_TCK_CL_CWL_MAX_NS {1.5}
set_instance_parameter_value sys_emif MEM_TCK_CL_CWL_MIN_NS {1.25}
set_instance_parameter_value sys_emif MEM_TCPDED_NS {4.0}
set_instance_parameter_value sys_emif MEM_TDQSCK_MAX_MIN_NS {0.225}
set_instance_parameter_value sys_emif MEM_TDQSCK_NS {0.0}
set_instance_parameter_value sys_emif MEM_TFAW_DLR_NS {20.0}
set_instance_parameter_value sys_emif MEM_TFAW_NS {35.0}
set_instance_parameter_value sys_emif MEM_TMOD_NS {24.0}
set_instance_parameter_value sys_emif MEM_TMPRR_NS {1.0}
set_instance_parameter_value sys_emif MEM_TMRD_NS {8.0}
set_instance_parameter_value sys_emif MEM_TRAS_MAX_NS {70200.0}
set_instance_parameter_value sys_emif MEM_TRAS_MIN_NS {35.0}
set_instance_parameter_value sys_emif MEM_TRAS_NS {35.0}
set_instance_parameter_value sys_emif MEM_TRCD_NS {15.0}
set_instance_parameter_value sys_emif MEM_TRC_NS {50.0}
set_instance_parameter_value sys_emif MEM_TREFI_NS {7800.0}
set_instance_parameter_value sys_emif MEM_TRFC_DLR_NS {190.0}
set_instance_parameter_value sys_emif MEM_TRFC_NS {550.0}
set_instance_parameter_value sys_emif MEM_TRP_NS {15.0}
set_instance_parameter_value sys_emif MEM_TRRD_DLR_NS {4.0}
set_instance_parameter_value sys_emif MEM_TRRD_L_NS {6.0}
set_instance_parameter_value sys_emif MEM_TRRD_S_NS {5.0}
set_instance_parameter_value sys_emif MEM_TRTP_NS {7.5}
set_instance_parameter_value sys_emif MEM_TWR_CRC_DM_NS {5.0}
set_instance_parameter_value sys_emif MEM_TWR_NS {15.0}
set_instance_parameter_value sys_emif MEM_TWTR_L_CRC_DM_NS {5.0}
set_instance_parameter_value sys_emif MEM_TWTR_L_NS {6.0}
set_instance_parameter_value sys_emif MEM_TWTR_S_CRC_DM_NS {5.0}
set_instance_parameter_value sys_emif MEM_TWTR_S_NS {2.0}
set_instance_parameter_value sys_emif MEM_TXP_NS {5.0}
set_instance_parameter_value sys_emif MEM_TXS_DLL_NS {597.0}
set_instance_parameter_value sys_emif MEM_TXS_NS {560.0}
set_instance_parameter_value sys_emif MEM_TZQCS_NS {128.0}
set_instance_parameter_value sys_emif MEM_TZQINIT_CYC {1024.0}
set_instance_parameter_value sys_emif MEM_TZQOPER_CYC {512.0}
set_instance_parameter_value sys_emif MEM_VREF_DQ_X_RANGE {2}
set_instance_parameter_value sys_emif MEM_VREF_DQ_X_VALUE {67.75}
set_instance_parameter_value sys_emif MEM_WR_CRC_EN {0.0}
set_instance_parameter_value sys_emif MEM_WR_PREAMBLE_MODE {1.0}
set_instance_parameter_value sys_emif PHY_AC_PLACEMENT {BOT}
set_instance_parameter_value sys_emif PHY_ALERT_N_PLACEMENT {AC2}
set_instance_parameter_value sys_emif PHY_FORCE_MIN_4_AC_LANES_EN {0}
set_instance_parameter_value sys_emif PHY_REFCLK_ADVANCED_SELECT_EN {1}
set_instance_parameter_value sys_emif PHY_REFCLK_FREQ_MHZ {100.0}
set_instance_parameter_value sys_emif PHY_REFCLK_FREQ_MHZ_AUTOSET_EN {0}
set_instance_parameter_value sys_emif PHY_SWIZZLE_MAP {BYTE_SWIZZLE_CH0=0 X X X 1 2 3 ECC;PIN_SWIZZLE_CH0_DQS0=0 2 6 4 1 3 5 7;PIN_SWIZZLE_CH0_DQS1=12 15 8 11 14 10 13 9;PIN_SWIZZLE_CH0_DQS2=20 16 18 22 23 17 19 21;PIN_SWIZZLE_CH0_DQS3=26 30 28 24 25 27 31 29;PIN_SWIZZLE_CH0_ECC=2 6 0 4 5 3 7 1;}
set_instance_parameter_value sys_emif PHY_TERM_X_AC_OUTPUT_IO_STD_TYPE {SSTL}
set_instance_parameter_value sys_emif PHY_TERM_X_CK_OUTPUT_IO_STD_TYPE {DF_SSTL}
set_instance_parameter_value sys_emif PHY_TERM_X_CS_OUTPUT_IO_STD_TYPE {SSTL}
set_instance_parameter_value sys_emif PHY_TERM_X_DQS_IO_STD_TYPE {DF_POD}
set_instance_parameter_value sys_emif PHY_TERM_X_DQ_IO_STD_TYPE {POD}
set_instance_parameter_value sys_emif PHY_TERM_X_DQ_SLEW_RATE {FASTEST}
set_instance_parameter_value sys_emif PHY_TERM_X_DQ_VREF {68.3}
set_instance_parameter_value sys_emif PHY_TERM_X_GPIO_IO_STD_TYPE {LVCMOS}
set_instance_parameter_value sys_emif PHY_TERM_X_REFCLK_IO_STD_TYPE {TRUE_DIFF}
set_instance_parameter_value sys_emif PHY_TERM_X_R_S_AC_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_instance_parameter_value sys_emif PHY_TERM_X_R_S_CK_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_instance_parameter_value sys_emif PHY_TERM_X_R_S_CS_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_instance_parameter_value sys_emif PHY_TERM_X_R_S_DQ_OUTPUT_OHM {SERIES_34_OHM_CAL}
set_instance_parameter_value sys_emif PHY_TERM_X_R_T_DQ_INPUT_OHM {RT_50_OHM_CAL}
set_instance_parameter_value sys_emif PHY_TERM_X_R_T_GPIO_INPUT_OHM {RT_OFF}
set_instance_parameter_value sys_emif PHY_TERM_X_R_T_REFCLK_INPUT_OHM {RT_DIFF}
set_instance_parameter_value sys_emif PLACEMENT_SCHEMES {DDR4_X32_3AC_BOT}
set_instance_parameter_value sys_emif S0_AXID_WIDTH {7}
set_instance_parameter_value sys_emif SYSINFO_BOARD {default}
set_instance_parameter_value sys_emif SYSINFO_BOARD_TRAIT {}
set_instance_parameter_value sys_emif SYSINFO_DEVICE {A5ED065AB32AE1V}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_BASE_DIE {SM7}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_DIE_REVISIONS {MAIN_SM7_REVA}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_FAMILY {Agilex 5}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_GROUP {B}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_IOBANK_REVISION {IO96B}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_POWER_MODEL {STANDARD_POWER_FIXED}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_SPEEDGRADE {6}
set_instance_parameter_value sys_emif SYSINFO_DEVICE_TEMPERATURE_GRADE {EXTENDED}
set_instance_parameter_value sys_emif SYSINFO_SUPPORTS_VID {0}
set_instance_parameter_value sys_emif TURNAROUND_R2R_DIFFCS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_R2R_SAMECS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_R2W_DIFFCS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_R2W_SAMECS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_W2R_DIFFCS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_W2R_SAMECS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_W2W_DIFFCS_CYC {0}
set_instance_parameter_value sys_emif TURNAROUND_W2W_SAMECS_CYC {0}

# common dma interfaces

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {false}
add_connection sys_emif.s0_axi4_clock_out sys_dma_clk.clk_in
add_connection sys_emif.s0_axi4_ctrl_ready sys_dma_clk.clk_in_reset

# CPU access to DDR.

add_instance sys_ddr_window altera_address_span_extender
set_instance_parameter_value sys_ddr_window {DATA_WIDTH} {32}
set_instance_parameter_value sys_ddr_window {BURSTCOUNT_WIDTH} {1}
set_instance_parameter_value sys_ddr_window {MASTER_ADDRESS_WIDTH} {33}
set_instance_parameter_value sys_ddr_window {SLAVE_ADDRESS_WIDTH} {18}
set_instance_parameter_value sys_ddr_window {SLAVE_ADDRESS_SHIFT} {2}
set_instance_parameter_value sys_ddr_window {ENABLE_SLAVE_PORT} {1}

add_connection sys_dma_clk.clk sys_ddr_window.clock
add_connection sys_dma_clk.clk_reset sys_ddr_window.reset

add_connection sys_ddr_window.expanded_master sys_emif.s0_axi4
set_connection_parameter_value sys_ddr_window.expanded_master/sys_emif.s0_axi4 baseAddress {0x0}

add_connection sys_cpu.data_manager sys_ddr_window.windowed_slave
set_connection_parameter_value sys_cpu.data_manager/sys_ddr_window.windowed_slave baseAddress {0x10200000}
add_connection sys_cpu.data_manager sys_ddr_window.cntl
set_connection_parameter_value sys_cpu.data_manager/sys_ddr_window.cntl baseAddress {0x10320000}

# EMIF sideband (calibration / IOSSM config port)

add_connection sys_clk.clk sys_emif.s0_axi4lite_clock
add_connection sys_clk.clk_reset sys_emif.s0_axi4lite_reset_n
add_connection sys_clk.clk_reset sys_emif.core_init_n

add_connection sys_cpu.data_manager sys_emif.s0_axi4lite
set_connection_parameter_value sys_cpu.data_manager/sys_emif.s0_axi4lite baseAddress {0x08000000}

# jtag

add_instance fpga_m altera_jtag_avalon_master

add_connection sys_clk.clk fpga_m.clk
add_connection sys_clk.clk_reset fpga_m.clk_reset

add_instance axi_sysid_0 axi_sysid
add_instance rom_sys_0 sysid_rom

add_connection axi_sysid_0.if_rom_addr rom_sys_0.if_rom_addr
add_connection rom_sys_0.if_rom_data axi_sysid_0.if_sys_rom_data
add_connection sys_clk.clk rom_sys_0.if_clk
add_connection sys_clk.clk axi_sysid_0.s_axi_clock
add_connection sys_clk.clk_reset axi_sysid_0.s_axi_reset

add_interface pr_rom_data_nc conduit end
set_interface_property pr_rom_data_nc EXPORT_OF axi_sysid_0.if_pr_rom_data

# cpu handling

proc ad_dma_interconnect {m_port {m_addr 0x00000000} {data_width 128}} {

  set avm_bridge ""
  append avm_bridge [lindex [split $m_port "."] 0] "_bridge"

  add_instance ${avm_bridge} altera_avalon_mm_bridge
  set_instance_parameter_value ${avm_bridge} {SYNC_RESET} {1}
  set_instance_parameter_value ${avm_bridge} {DATA_WIDTH} $data_width
  set_instance_parameter_value ${avm_bridge} {USE_AUTO_ADDRESS_WIDTH} {1}

  add_connection sys_dma_clk.clk ${avm_bridge}.clk
  add_connection sys_dma_clk.clk_reset ${avm_bridge}.reset

  add_connection ${m_port} ${avm_bridge}.s0

  set avm_span "${avm_bridge}_span"
  add_instance ${avm_span} altera_address_span_extender
  set_instance_parameter_value ${avm_span} {DATA_WIDTH} $data_width

  set slave_shift [expr int(log($data_width / 8) / log(2))]
  set_instance_parameter_value ${avm_span} {MASTER_ADDRESS_WIDTH} {33}
  set_instance_parameter_value ${avm_span} {SLAVE_ADDRESS_SHIFT} $slave_shift
  set_instance_parameter_value ${avm_span} {SLAVE_ADDRESS_WIDTH} [expr 32 - $slave_shift]
  set_instance_parameter_value ${avm_span} {BURSTCOUNT_WIDTH} {8}
  set_instance_parameter_value ${avm_span} {ENABLE_SLAVE_PORT} {0}

  add_connection sys_dma_clk.clk ${avm_span}.clock
  add_connection sys_dma_clk.clk_reset ${avm_span}.reset

  add_connection ${avm_bridge}.m0 ${avm_span}.windowed_slave
  set_connection_parameter_value ${avm_bridge}.m0/${avm_span}.windowed_slave baseAddress ${m_addr}

  add_connection ${avm_span}.expanded_master sys_emif.s0_axi4
  set_connection_parameter_value ${avm_span}.expanded_master/sys_emif.s0_axi4 baseAddress {0x0}
}

proc ad_cpu_interrupt {m_irq m_port} {

  add_connection sys_cpu.platform_irq_rx ${m_port}
  set_connection_parameter_value sys_cpu.platform_irq_rx/${m_port} irqNumber ${m_irq}
}

proc ad_cpu_interconnect {m_base m_port {avl_bridge ""} {avl_bridge_base 0x00000000} {avl_address_width 18}} {
  if {[string equal ${avl_bridge} ""]} {
    add_connection sys_cpu.data_manager ${m_port}
    set_connection_parameter_value sys_cpu.data_manager/${m_port} baseAddress ${m_base}
  } else {
    if {[lsearch -exact [get_instances] ${avl_bridge}] == -1} {
      ## Instantiate the bridge and connect the interfaces
      add_instance ${avl_bridge} altera_avalon_mm_bridge
      set_instance_parameter_value ${avl_bridge} {ADDRESS_WIDTH} $avl_address_width
      set_instance_parameter_value ${avl_bridge} {SYNC_RESET} {1}
      add_connection sys_cpu.data_manager ${avl_bridge}.s0
      set_connection_parameter_value sys_cpu.data_manager/${avl_bridge}.s0 baseAddress ${avl_bridge_base}
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

set_interface_property o_pma_cu_clk EXPORT_OF gts_reset.o_pma_cu_clk

set_interface_property emif_mem_0 EXPORT_OF sys_emif.mem_0
set_interface_property emif_mem_ck_0 EXPORT_OF sys_emif.mem_ck_0
set_interface_property emif_mem_reset_n EXPORT_OF sys_emif.mem_reset_n
set_interface_property emif_oct_0 EXPORT_OF sys_emif.oct_0
set_interface_property emif_ref_clk_0 EXPORT_OF sys_emif.ref_clk

# cpu interconnect

ad_cpu_interconnect 0x000000d0 sys_gpio_bd.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1 "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi "avl_peripheral_mm_bridge"

ad_cpu_interconnect 0x00000100 sys_uart.avalon_jtag_slave "avl_peripheral_mm_bridge"
ad_cpu_interconnect 0x00000200 sys_timer.s1 "avl_peripheral_mm_bridge"

# interrupts

ad_cpu_interrupt 2 sys_uart.irq
ad_cpu_interrupt 4 sys_timer.irq
ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq

set xcvr_reconfig_addr_width 11
