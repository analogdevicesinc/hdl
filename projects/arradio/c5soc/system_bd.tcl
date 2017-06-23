# qsys scripting (.tcl) file for system_bd
package require -exact qsys 16.0

create_system {system_bd}

set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE {5CSXFC6D6F31C8ES}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance axi_ad9361 axi_ad9361 1.0
set_instance_parameter_value axi_ad9361 {ID} {0}
set_instance_parameter_value axi_ad9361 {MODE_1R1T} {0}
set_instance_parameter_value axi_ad9361 {DEVICE_TYPE} {1}
set_instance_parameter_value axi_ad9361 {TDD_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {CMOS_OR_LVDS_N} {0}
set_instance_parameter_value axi_ad9361 {ADC_DATAPATH_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {ADC_USERPORTS_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {ADC_DATAFORMAT_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {ADC_DCFILTER_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {ADC_IQCORRECTION_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_IODELAY_ENABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_DATAPATH_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_DDS_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_USERPORTS_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {DAC_IQCORRECTION_DISABLE} {0}
set_instance_parameter_value axi_ad9361 {IO_DELAY_GROUP} {dev_if_delay_group}

add_instance axi_adc_dma axi_dmac 1.0
set_instance_parameter_value axi_adc_dma {ID} {0}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value axi_adc_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_adc_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_adc_dma {ASYNC_CLK_REQ_SRC} {1}
set_instance_parameter_value axi_adc_dma {ASYNC_CLK_SRC_DEST} {1}
set_instance_parameter_value axi_adc_dma {ASYNC_CLK_DEST_REQ} {1}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_adc_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_adc_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_adc_dma {CYCLIC} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_adc_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_adc_dma {FIFO_SIZE} {4}

add_instance axi_dac_dma axi_dmac 1.0
set_instance_parameter_value axi_dac_dma {ID} {0}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_DEST} {64}
set_instance_parameter_value axi_dac_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_dac_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_dac_dma {ASYNC_CLK_REQ_SRC} {1}
set_instance_parameter_value axi_dac_dma {ASYNC_CLK_SRC_DEST} {1}
set_instance_parameter_value axi_dac_dma {ASYNC_CLK_DEST_REQ} {1}
set_instance_parameter_value axi_dac_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_dac_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_dac_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value axi_dac_dma {CYCLIC} {1}
set_instance_parameter_value axi_dac_dma {DMA_TYPE_DEST} {2}
set_instance_parameter_value axi_dac_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value axi_dac_dma {FIFO_SIZE} {4}

add_instance sys_clk clock_source 16.0
set_instance_parameter_value sys_clk {clockFrequency} {50000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {NONE}

add_instance sys_dma_clk clock_source 16.0
set_instance_parameter_value sys_dma_clk {clockFrequency} {50000000.0}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {NONE}

add_instance sys_gpio_bd altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_bd {bitClearingEdgeCapReg} {0}
set_instance_parameter_value sys_gpio_bd {bitModifyingOutReg} {0}
set_instance_parameter_value sys_gpio_bd {captureEdge} {0}
set_instance_parameter_value sys_gpio_bd {direction} {InOut}
set_instance_parameter_value sys_gpio_bd {edgeType} {RISING}
set_instance_parameter_value sys_gpio_bd {generateIRQ} {1}
set_instance_parameter_value sys_gpio_bd {irqType} {LEVEL}
set_instance_parameter_value sys_gpio_bd {resetValue} {0.0}
set_instance_parameter_value sys_gpio_bd {simDoTestBenchWiring} {0}
set_instance_parameter_value sys_gpio_bd {simDrivenValue} {0.0}
set_instance_parameter_value sys_gpio_bd {width} {32}

add_instance sys_gpio_in altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_in {bitClearingEdgeCapReg} {0}
set_instance_parameter_value sys_gpio_in {bitModifyingOutReg} {0}
set_instance_parameter_value sys_gpio_in {captureEdge} {0}
set_instance_parameter_value sys_gpio_in {direction} {Input}
set_instance_parameter_value sys_gpio_in {edgeType} {RISING}
set_instance_parameter_value sys_gpio_in {generateIRQ} {1}
set_instance_parameter_value sys_gpio_in {irqType} {LEVEL}
set_instance_parameter_value sys_gpio_in {resetValue} {0.0}
set_instance_parameter_value sys_gpio_in {simDoTestBenchWiring} {0}
set_instance_parameter_value sys_gpio_in {simDrivenValue} {0.0}
set_instance_parameter_value sys_gpio_in {width} {32}

add_instance sys_gpio_out altera_avalon_pio 16.0
set_instance_parameter_value sys_gpio_out {bitClearingEdgeCapReg} {0}
set_instance_parameter_value sys_gpio_out {bitModifyingOutReg} {0}
set_instance_parameter_value sys_gpio_out {captureEdge} {0}
set_instance_parameter_value sys_gpio_out {direction} {Output}
set_instance_parameter_value sys_gpio_out {edgeType} {RISING}
set_instance_parameter_value sys_gpio_out {generateIRQ} {0}
set_instance_parameter_value sys_gpio_out {irqType} {LEVEL}
set_instance_parameter_value sys_gpio_out {resetValue} {0.0}
set_instance_parameter_value sys_gpio_out {simDoTestBenchWiring} {0}
set_instance_parameter_value sys_gpio_out {simDrivenValue} {0.0}
set_instance_parameter_value sys_gpio_out {width} {32}

add_instance sys_hps altera_hps 16.0
set_instance_parameter_value sys_hps {MEM_VENDOR} {JEDEC}
set_instance_parameter_value sys_hps {MEM_FORMAT} {DISCRETE}
set_instance_parameter_value sys_hps {RDIMM_CONFIG} {0000000000000000}
set_instance_parameter_value sys_hps {LRDIMM_EXTENDED_CONFIG} {0x000000000000000000}
set_instance_parameter_value sys_hps {DISCRETE_FLY_BY} {1}
set_instance_parameter_value sys_hps {DEVICE_DEPTH} {1}
set_instance_parameter_value sys_hps {MEM_MIRROR_ADDRESSING} {0}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ_MAX} {800.0}
set_instance_parameter_value sys_hps {MEM_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value sys_hps {MEM_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_hps {MEM_DQ_WIDTH} {32}
set_instance_parameter_value sys_hps {MEM_DQ_PER_DQS} {8}
set_instance_parameter_value sys_hps {MEM_BANKADDR_WIDTH} {3}
set_instance_parameter_value sys_hps {MEM_IF_DM_PINS_EN} {1}
set_instance_parameter_value sys_hps {MEM_IF_DQSN_EN} {1}
set_instance_parameter_value sys_hps {MEM_NUMBER_OF_DIMMS} {1}
set_instance_parameter_value sys_hps {MEM_NUMBER_OF_RANKS_PER_DIMM} {1}
set_instance_parameter_value sys_hps {MEM_NUMBER_OF_RANKS_PER_DEVICE} {1}
set_instance_parameter_value sys_hps {MEM_RANK_MULTIPLICATION_FACTOR} {1}
set_instance_parameter_value sys_hps {MEM_CK_WIDTH} {1}
set_instance_parameter_value sys_hps {MEM_CS_WIDTH} {1}
set_instance_parameter_value sys_hps {MEM_CLK_EN_WIDTH} {1}
set_instance_parameter_value sys_hps {ALTMEMPHY_COMPATIBLE_MODE} {0}
set_instance_parameter_value sys_hps {NEXTGEN} {1}
set_instance_parameter_value sys_hps {MEM_IF_BOARD_BASE_DELAY} {10}
set_instance_parameter_value sys_hps {MEM_IF_SIM_VALID_WINDOW} {0}
set_instance_parameter_value sys_hps {MEM_GUARANTEED_WRITE_INIT} {0}
set_instance_parameter_value sys_hps {MEM_VERBOSE} {1}
set_instance_parameter_value sys_hps {PINGPONGPHY_EN} {0}
set_instance_parameter_value sys_hps {DUPLICATE_AC} {0}
set_instance_parameter_value sys_hps {REFRESH_BURST_VALIDATION} {0}
set_instance_parameter_value sys_hps {AP_MODE_EN} {0}
set_instance_parameter_value sys_hps {AP_MODE} {0}
set_instance_parameter_value sys_hps {MEM_BL} {OTF}
set_instance_parameter_value sys_hps {MEM_BT} {Sequential}
set_instance_parameter_value sys_hps {MEM_ASR} {Manual}
set_instance_parameter_value sys_hps {MEM_SRT} {Normal}
set_instance_parameter_value sys_hps {MEM_PD} {DLL off}
set_instance_parameter_value sys_hps {MEM_DRV_STR} {RZQ/7}
set_instance_parameter_value sys_hps {MEM_DLL_EN} {1}
set_instance_parameter_value sys_hps {MEM_RTT_NOM} {RZQ/4}
set_instance_parameter_value sys_hps {MEM_RTT_WR} {RZQ/4}
set_instance_parameter_value sys_hps {MEM_WTCL} {8}
set_instance_parameter_value sys_hps {MEM_ATCL} {Disabled}
set_instance_parameter_value sys_hps {MEM_TCL} {11}
set_instance_parameter_value sys_hps {MEM_AUTO_LEVELING_MODE} {1}
set_instance_parameter_value sys_hps {MEM_USER_LEVELING_MODE} {Leveling}
set_instance_parameter_value sys_hps {MEM_INIT_EN} {0}
set_instance_parameter_value sys_hps {MEM_INIT_FILE} {}
set_instance_parameter_value sys_hps {DAT_DATA_WIDTH} {32}
set_instance_parameter_value sys_hps {TIMING_TIS} {180}
set_instance_parameter_value sys_hps {TIMING_TIH} {140}
set_instance_parameter_value sys_hps {TIMING_TDS} {30}
set_instance_parameter_value sys_hps {TIMING_TDH} {65}
set_instance_parameter_value sys_hps {TIMING_TDQSQ} {125}
set_instance_parameter_value sys_hps {TIMING_TQHS} {300}
set_instance_parameter_value sys_hps {TIMING_TQH} {0.38}
set_instance_parameter_value sys_hps {TIMING_TDQSCK} {255}
set_instance_parameter_value sys_hps {TIMING_TDQSCKDS} {450}
set_instance_parameter_value sys_hps {TIMING_TDQSCKDM} {900}
set_instance_parameter_value sys_hps {TIMING_TDQSCKDL} {1200}
set_instance_parameter_value sys_hps {TIMING_TDQSS} {0.25}
set_instance_parameter_value sys_hps {TIMING_TDQSH} {0.35}
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
set_instance_parameter_value sys_hps {CFG_TCCD_NS} {2.5}
set_instance_parameter_value sys_hps {MEM_TWR_NS} {15.0}
set_instance_parameter_value sys_hps {MEM_TWTR} {4}
set_instance_parameter_value sys_hps {MEM_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps {MEM_TRRD_NS} {7.5}
set_instance_parameter_value sys_hps {MEM_TRTP_NS} {7.5}
set_instance_parameter_value sys_hps {POWER_OF_TWO_BUS} {0}
set_instance_parameter_value sys_hps {SOPC_COMPAT_RESET} {0}
set_instance_parameter_value sys_hps {AVL_MAX_SIZE} {4}
set_instance_parameter_value sys_hps {BYTE_ENABLE} {1}
set_instance_parameter_value sys_hps {ENABLE_CTRL_AVALON_INTERFACE} {1}
set_instance_parameter_value sys_hps {CTL_DEEP_POWERDN_EN} {0}
set_instance_parameter_value sys_hps {CTL_SELF_REFRESH_EN} {0}
set_instance_parameter_value sys_hps {AUTO_POWERDN_EN} {0}
set_instance_parameter_value sys_hps {AUTO_PD_CYCLES} {0}
set_instance_parameter_value sys_hps {CTL_USR_REFRESH_EN} {0}
set_instance_parameter_value sys_hps {CTL_AUTOPCH_EN} {0}
set_instance_parameter_value sys_hps {CTL_ZQCAL_EN} {0}
set_instance_parameter_value sys_hps {ADDR_ORDER} {0}
set_instance_parameter_value sys_hps {CTL_LOOK_AHEAD_DEPTH} {4}
set_instance_parameter_value sys_hps {CONTROLLER_LATENCY} {5}
set_instance_parameter_value sys_hps {CFG_REORDER_DATA} {1}
set_instance_parameter_value sys_hps {STARVE_LIMIT} {10}
set_instance_parameter_value sys_hps {CTL_CSR_ENABLED} {0}
set_instance_parameter_value sys_hps {CTL_CSR_CONNECTION} {INTERNAL_JTAG}
set_instance_parameter_value sys_hps {CTL_ECC_ENABLED} {0}
set_instance_parameter_value sys_hps {CTL_HRB_ENABLED} {0}
set_instance_parameter_value sys_hps {CTL_ECC_AUTO_CORRECTION_ENABLED} {0}
set_instance_parameter_value sys_hps {MULTICAST_EN} {0}
set_instance_parameter_value sys_hps {CTL_DYNAMIC_BANK_ALLOCATION} {0}
set_instance_parameter_value sys_hps {CTL_DYNAMIC_BANK_NUM} {4}
set_instance_parameter_value sys_hps {DEBUG_MODE} {0}
set_instance_parameter_value sys_hps {ENABLE_BURST_MERGE} {0}
set_instance_parameter_value sys_hps {CTL_ENABLE_BURST_INTERRUPT} {0}
set_instance_parameter_value sys_hps {CTL_ENABLE_BURST_TERMINATE} {0}
set_instance_parameter_value sys_hps {LOCAL_ID_WIDTH} {8}
set_instance_parameter_value sys_hps {WRBUFFER_ADDR_WIDTH} {6}
set_instance_parameter_value sys_hps {MAX_PENDING_WR_CMD} {16}
set_instance_parameter_value sys_hps {MAX_PENDING_RD_CMD} {32}
set_instance_parameter_value sys_hps {USE_MM_ADAPTOR} {1}
set_instance_parameter_value sys_hps {USE_AXI_ADAPTOR} {0}
set_instance_parameter_value sys_hps {HCX_COMPAT_MODE} {0}
set_instance_parameter_value sys_hps {CTL_CMD_QUEUE_DEPTH} {8}
set_instance_parameter_value sys_hps {CTL_CSR_READ_ONLY} {1}
set_instance_parameter_value sys_hps {CFG_DATA_REORDERING_TYPE} {INTER_BANK}
set_instance_parameter_value sys_hps {NUM_OF_PORTS} {1}
set_instance_parameter_value sys_hps {ENABLE_BONDING} {0}
set_instance_parameter_value sys_hps {ENABLE_USER_ECC} {0}
set_instance_parameter_value sys_hps {AVL_DATA_WIDTH_PORT} {32 32 32 32 32 32}
set_instance_parameter_value sys_hps {PRIORITY_PORT} {1 1 1 1 1 1}
set_instance_parameter_value sys_hps {WEIGHT_PORT} {0 0 0 0 0 0}
set_instance_parameter_value sys_hps {CPORT_TYPE_PORT} {Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional}
set_instance_parameter_value sys_hps {ENABLE_EMIT_BFM_MASTER} {0}
set_instance_parameter_value sys_hps {FORCE_SEQUENCER_TCL_DEBUG_MODE} {0}
set_instance_parameter_value sys_hps {ENABLE_SEQUENCER_MARGINING_ON_BY_DEFAULT} {0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ} {25.0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ_PARAM_VALID} {0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ_MIN_PARAM} {0.0}
set_instance_parameter_value sys_hps {REF_CLK_FREQ_MAX_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_DR_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_DR_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_DR_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_DR_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_DR_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_DR_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_MEM_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_WRITE_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_ADDR_CMD_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_HALF_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_NIOS_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_CONFIG_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_P2C_READ_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_C2P_WRITE_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_HR_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_HR_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_HR_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_HR_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_HR_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_HR_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_FREQ_PARAM} {0.0}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_FREQ_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_PHASE_PS_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_PHASE_PS_SIM_STR_PARAM} {}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_MULT_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_AFI_PHY_CLK_DIV_PARAM} {0}
set_instance_parameter_value sys_hps {PLL_CLK_PARAM_VALID} {0}
set_instance_parameter_value sys_hps {ENABLE_EXTRA_REPORTING} {0}
set_instance_parameter_value sys_hps {NUM_EXTRA_REPORT_PATH} {10}
set_instance_parameter_value sys_hps {ENABLE_ISS_PROBES} {0}
set_instance_parameter_value sys_hps {CALIB_REG_WIDTH} {8}
set_instance_parameter_value sys_hps {USE_SEQUENCER_BFM} {0}
set_instance_parameter_value sys_hps {PLL_SHARING_MODE} {None}
set_instance_parameter_value sys_hps {NUM_PLL_SHARING_INTERFACES} {1}
set_instance_parameter_value sys_hps {EXPORT_AFI_HALF_CLK} {0}
set_instance_parameter_value sys_hps {ABSTRACT_REAL_COMPARE_TEST} {0}
set_instance_parameter_value sys_hps {INCLUDE_BOARD_DELAY_MODEL} {0}
set_instance_parameter_value sys_hps {INCLUDE_MULTIRANK_BOARD_DELAY_MODEL} {0}
set_instance_parameter_value sys_hps {USE_FAKE_PHY} {0}
set_instance_parameter_value sys_hps {FORCE_MAX_LATENCY_COUNT_WIDTH} {0}
set_instance_parameter_value sys_hps {ENABLE_NON_DESTRUCTIVE_CALIB} {0}
set_instance_parameter_value sys_hps {FIX_READ_LATENCY} {8}
set_instance_parameter_value sys_hps {ENABLE_DELAY_CHAIN_WRITE} {0}
set_instance_parameter_value sys_hps {TRACKING_ERROR_TEST} {0}
set_instance_parameter_value sys_hps {TRACKING_WATCH_TEST} {0}
set_instance_parameter_value sys_hps {MARGIN_VARIATION_TEST} {0}
set_instance_parameter_value sys_hps {AC_ROM_USER_ADD_0} {0_0000_0000_0000}
set_instance_parameter_value sys_hps {AC_ROM_USER_ADD_1} {0_0000_0000_1000}
set_instance_parameter_value sys_hps {TREFI} {35100}
set_instance_parameter_value sys_hps {REFRESH_INTERVAL} {15000}
set_instance_parameter_value sys_hps {ENABLE_NON_DES_CAL_TEST} {0}
set_instance_parameter_value sys_hps {TRFC} {350}
set_instance_parameter_value sys_hps {ENABLE_NON_DES_CAL} {0}
set_instance_parameter_value sys_hps {EXTRA_SETTINGS} {}
set_instance_parameter_value sys_hps {MEM_DEVICE} {MISSING_MODEL}
set_instance_parameter_value sys_hps {FORCE_SYNTHESIS_LANGUAGE} {}
set_instance_parameter_value sys_hps {FORCED_NUM_WRITE_FR_CYCLE_SHIFTS} {0}
set_instance_parameter_value sys_hps {SEQUENCER_TYPE} {NIOS}
set_instance_parameter_value sys_hps {ADVERTIZE_SEQUENCER_SW_BUILD_FILES} {0}
set_instance_parameter_value sys_hps {FORCED_NON_LDC_ADDR_CMD_MEM_CK_INVERT} {0}
set_instance_parameter_value sys_hps {PHY_ONLY} {0}
set_instance_parameter_value sys_hps {SEQ_MODE} {0}
set_instance_parameter_value sys_hps {ADVANCED_CK_PHASES} {0}
set_instance_parameter_value sys_hps {COMMAND_PHASE} {0.0}
set_instance_parameter_value sys_hps {MEM_CK_PHASE} {0.0}
set_instance_parameter_value sys_hps {P2C_READ_CLOCK_ADD_PHASE} {0.0}
set_instance_parameter_value sys_hps {C2P_WRITE_CLOCK_ADD_PHASE} {0.0}
set_instance_parameter_value sys_hps {ACV_PHY_CLK_ADD_FR_PHASE} {0.0}
set_instance_parameter_value sys_hps {MEM_VOLTAGE} {1.5V DDR3}
set_instance_parameter_value sys_hps {PLL_LOCATION} {Top_Bottom}
set_instance_parameter_value sys_hps {SKIP_MEM_INIT} {1}
set_instance_parameter_value sys_hps {READ_DQ_DQS_CLOCK_SOURCE} {INVERTED_DQS_BUS}
set_instance_parameter_value sys_hps {DQ_INPUT_REG_USE_CLKN} {0}
set_instance_parameter_value sys_hps {DQS_DQSN_MODE} {DIFFERENTIAL}
set_instance_parameter_value sys_hps {AFI_DEBUG_INFO_WIDTH} {32}
set_instance_parameter_value sys_hps {CALIBRATION_MODE} {Skip}
set_instance_parameter_value sys_hps {NIOS_ROM_DATA_WIDTH} {32}
set_instance_parameter_value sys_hps {READ_FIFO_SIZE} {8}
set_instance_parameter_value sys_hps {PHY_CSR_ENABLED} {0}
set_instance_parameter_value sys_hps {PHY_CSR_CONNECTION} {INTERNAL_JTAG}
set_instance_parameter_value sys_hps {USER_DEBUG_LEVEL} {1}
set_instance_parameter_value sys_hps {TIMING_BOARD_DERATE_METHOD} {AUTO}
set_instance_parameter_value sys_hps {TIMING_BOARD_CK_CKN_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_SLEW_RATE} {1.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQS_DQSN_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQ_SLEW_RATE} {1.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_TIS} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_TIH} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_TDS} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_TDH} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_ISI_METHOD} {AUTO}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_EYE_REDUCTION_SU} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_EYE_REDUCTION_H} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQ_EYE_REDUCTION} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_DELTA_DQS_ARRIVAL_TIME} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_READ_DQ_EYE_REDUCTION} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_DELTA_READ_DQS_ARRIVAL_TIME} {0.0}
set_instance_parameter_value sys_hps {PACKAGE_DESKEW} {0}
set_instance_parameter_value sys_hps {AC_PACKAGE_DESKEW} {0}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_CK_DELAY} {0.03}
set_instance_parameter_value sys_hps {TIMING_BOARD_MAX_DQS_DELAY} {0.02}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MIN} {0.09}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_CKDQS_DIMM_MAX} {0.16}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_BETWEEN_DIMMS} {0.05}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_WITHIN_DQS} {0.01}
set_instance_parameter_value sys_hps {TIMING_BOARD_SKEW_BETWEEN_DQS} {0.08}
set_instance_parameter_value sys_hps {TIMING_BOARD_DQ_TO_DQS_SKEW} {0.0}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_SKEW} {0.03}
set_instance_parameter_value sys_hps {TIMING_BOARD_AC_TO_CK_SKEW} {0.0}
set_instance_parameter_value sys_hps {RATE} {Full}
set_instance_parameter_value sys_hps {MEM_CLK_FREQ} {400.0}
set_instance_parameter_value sys_hps {USE_MEM_CLK_FREQ} {0}
set_instance_parameter_value sys_hps {FORCE_DQS_TRACKING} {AUTO}
set_instance_parameter_value sys_hps {FORCE_SHADOW_REGS} {AUTO}
set_instance_parameter_value sys_hps {MRS_MIRROR_PING_PONG_ATSO} {0}
set_instance_parameter_value sys_hps {PARSE_FRIENDLY_DEVICE_FAMILY_PARAM_VALID} {0}
set_instance_parameter_value sys_hps {PARSE_FRIENDLY_DEVICE_FAMILY_PARAM} {}
set_instance_parameter_value sys_hps {DEVICE_FAMILY_PARAM} {}
set_instance_parameter_value sys_hps {SPEED_GRADE} {7}
set_instance_parameter_value sys_hps {IS_ES_DEVICE} {0}
set_instance_parameter_value sys_hps {DISABLE_CHILD_MESSAGING} {0}
set_instance_parameter_value sys_hps {HARD_EMIF} {1}
set_instance_parameter_value sys_hps {HHP_HPS} {1}
set_instance_parameter_value sys_hps {HHP_HPS_VERIFICATION} {0}
set_instance_parameter_value sys_hps {HHP_HPS_SIMULATION} {0}
set_instance_parameter_value sys_hps {HPS_PROTOCOL} {DDR3}
set_instance_parameter_value sys_hps {CUT_NEW_FAMILY_TIMING} {1}
set_instance_parameter_value sys_hps {ENABLE_EXPORT_SEQ_DEBUG_BRIDGE} {0}
set_instance_parameter_value sys_hps {CORE_DEBUG_CONNECTION} {EXPORT}
set_instance_parameter_value sys_hps {ADD_EXTERNAL_SEQ_DEBUG_NIOS} {0}
set_instance_parameter_value sys_hps {ED_EXPORT_SEQ_DEBUG} {0}
set_instance_parameter_value sys_hps {ADD_EFFICIENCY_MONITOR} {0}
set_instance_parameter_value sys_hps {ENABLE_ABS_RAM_MEM_INIT} {0}
set_instance_parameter_value sys_hps {ABS_RAM_MEM_INIT_FILENAME} {meminit}
set_instance_parameter_value sys_hps {DLL_SHARING_MODE} {None}
set_instance_parameter_value sys_hps {NUM_DLL_SHARING_INTERFACES} {1}
set_instance_parameter_value sys_hps {OCT_SHARING_MODE} {None}
set_instance_parameter_value sys_hps {NUM_OCT_SHARING_INTERFACES} {1}
set_instance_parameter_value sys_hps {show_advanced_parameters} {0}
set_instance_parameter_value sys_hps {configure_advanced_parameters} {0}
set_instance_parameter_value sys_hps {customize_device_pll_info} {0}
set_instance_parameter_value sys_hps {device_pll_info_manual} {{320000000 1600000000} {320000000 1000000000} {800000000 400000000 400000000}}
set_instance_parameter_value sys_hps {show_debug_info_as_warning_msg} {0}
set_instance_parameter_value sys_hps {show_warning_as_error_msg} {0}
set_instance_parameter_value sys_hps {eosc1_clk_mhz} {25.0}
set_instance_parameter_value sys_hps {eosc2_clk_mhz} {25.0}
set_instance_parameter_value sys_hps {F2SCLK_SDRAMCLK_Enable} {0}
set_instance_parameter_value sys_hps {F2SCLK_PERIPHCLK_Enable} {0}
set_instance_parameter_value sys_hps {periph_pll_source} {0}
set_instance_parameter_value sys_hps {sdmmc_clk_source} {2}
set_instance_parameter_value sys_hps {nand_clk_source} {2}
set_instance_parameter_value sys_hps {qspi_clk_source} {1}
set_instance_parameter_value sys_hps {l4_mp_clk_source} {1}
set_instance_parameter_value sys_hps {l4_sp_clk_source} {1}
set_instance_parameter_value sys_hps {use_default_mpu_clk} {1}
set_instance_parameter_value sys_hps {desired_mpu_clk_mhz} {800.0}
set_instance_parameter_value sys_hps {l3_mp_clk_div} {1}
set_instance_parameter_value sys_hps {l3_sp_clk_div} {1}
set_instance_parameter_value sys_hps {dbctrl_stayosc1} {1}
set_instance_parameter_value sys_hps {dbg_at_clk_div} {0}
set_instance_parameter_value sys_hps {dbg_clk_div} {1}
set_instance_parameter_value sys_hps {dbg_trace_clk_div} {0}
set_instance_parameter_value sys_hps {desired_l4_mp_clk_mhz} {100.0}
set_instance_parameter_value sys_hps {desired_l4_sp_clk_mhz} {100.0}
set_instance_parameter_value sys_hps {desired_cfg_clk_mhz} {80.0}
set_instance_parameter_value sys_hps {desired_sdmmc_clk_mhz} {200.0}
set_instance_parameter_value sys_hps {desired_nand_clk_mhz} {12.5}
set_instance_parameter_value sys_hps {desired_qspi_clk_mhz} {400.0}
set_instance_parameter_value sys_hps {desired_emac0_clk_mhz} {250.0}
set_instance_parameter_value sys_hps {desired_emac1_clk_mhz} {250.0}
set_instance_parameter_value sys_hps {desired_usb_mp_clk_mhz} {200.0}
set_instance_parameter_value sys_hps {desired_spi_m_clk_mhz} {200.0}
set_instance_parameter_value sys_hps {desired_can0_clk_mhz} {100.0}
set_instance_parameter_value sys_hps {desired_can1_clk_mhz} {100.0}
set_instance_parameter_value sys_hps {desired_gpio_db_clk_hz} {32000}
set_instance_parameter_value sys_hps {S2FCLK_USER0CLK_Enable} {1}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_Enable} {0}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK_Enable} {0}
set_instance_parameter_value sys_hps {S2FCLK_USER1CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK_FREQ} {100.0}
set_instance_parameter_value sys_hps {S2FCLK_USER2CLK} {5}
set_instance_parameter_value sys_hps {main_pll_m} {63}
set_instance_parameter_value sys_hps {main_pll_n} {0}
set_instance_parameter_value sys_hps {main_pll_c3} {3}
set_instance_parameter_value sys_hps {main_pll_c4} {3}
set_instance_parameter_value sys_hps {main_pll_c5} {15}
set_instance_parameter_value sys_hps {periph_pll_m} {79}
set_instance_parameter_value sys_hps {periph_pll_n} {1}
set_instance_parameter_value sys_hps {periph_pll_c0} {3}
set_instance_parameter_value sys_hps {periph_pll_c1} {3}
set_instance_parameter_value sys_hps {periph_pll_c2} {1}
set_instance_parameter_value sys_hps {periph_pll_c3} {19}
set_instance_parameter_value sys_hps {periph_pll_c4} {4}
set_instance_parameter_value sys_hps {periph_pll_c5} {9}
set_instance_parameter_value sys_hps {usb_mp_clk_div} {0}
set_instance_parameter_value sys_hps {spi_m_clk_div} {0}
set_instance_parameter_value sys_hps {can0_clk_div} {1}
set_instance_parameter_value sys_hps {can1_clk_div} {1}
set_instance_parameter_value sys_hps {gpio_db_clk_div} {6249}
set_instance_parameter_value sys_hps {l4_mp_clk_div} {1}
set_instance_parameter_value sys_hps {l4_sp_clk_div} {1}
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {GP_Enable} {0}
set_instance_parameter_value sys_hps {DEBUGAPB_Enable} {0}
set_instance_parameter_value sys_hps {STM_Enable} {0}
set_instance_parameter_value sys_hps {CTI_Enable} {0}
set_instance_parameter_value sys_hps {TPIUFPGA_Enable} {0}
set_instance_parameter_value sys_hps {TPIUFPGA_alt} {0}
set_instance_parameter_value sys_hps {BOOTFROMFPGA_Enable} {0}
set_instance_parameter_value sys_hps {TEST_Enable} {0}
set_instance_parameter_value sys_hps {HLGPI_Enable} {0}
set_instance_parameter_value sys_hps {BSEL_EN} {0}
set_instance_parameter_value sys_hps {BSEL} {1}
set_instance_parameter_value sys_hps {CSEL_EN} {0}
set_instance_parameter_value sys_hps {CSEL} {0}
set_instance_parameter_value sys_hps {F2S_Width} {2}
set_instance_parameter_value sys_hps {S2F_Width} {2}
set_instance_parameter_value sys_hps {LWH2F_Enable} {true}
set_instance_parameter_value sys_hps {F2SDRAM_Type} {Avalon-MM\ Bidirectional AXI-3 AXI-3}
set_instance_parameter_value sys_hps {F2SDRAM_Width} {64 64 64}
set_instance_parameter_value sys_hps {BONDING_OUT_ENABLED} {0}
set_instance_parameter_value sys_hps {S2FCLK_COLDRST_Enable} {0}
set_instance_parameter_value sys_hps {S2FCLK_PENDINGRST_Enable} {0}
set_instance_parameter_value sys_hps {F2SCLK_DBGRST_Enable} {0}
set_instance_parameter_value sys_hps {F2SCLK_WARMRST_Enable} {0}
set_instance_parameter_value sys_hps {F2SCLK_COLDRST_Enable} {0}
set_instance_parameter_value sys_hps {DMA_Enable} {No No No No No No No No}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {S2FINTERRUPT_CAN_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_CLOCKPERIPHERAL_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_CTI_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_DMA_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_EMAC_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_FPGAMANAGER_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_GPIO_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_I2CEMAC_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_I2CPERIPHERAL_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_L4TIMER_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_NAND_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_OSCTIMER_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_QSPI_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_SDMMC_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_SPIMASTER_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_SPISLAVE_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_UART_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_USB_Enable} {0}
set_instance_parameter_value sys_hps {S2FINTERRUPT_WATCHDOG_Enable} {0}
set_instance_parameter_value sys_hps {EMAC0_PTP} {0}
set_instance_parameter_value sys_hps {EMAC1_PTP} {0}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {EMAC0_Mode} {N/A}
set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {EMAC1_Mode} {RGMII}
set_instance_parameter_value sys_hps {NAND_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {NAND_Mode} {N/A}
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
set_instance_parameter_value sys_hps {SPIS0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {SPIS0_Mode} {N/A}
set_instance_parameter_value sys_hps {SPIS1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {SPIS1_Mode} {N/A}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {HPS I/O Set 0}
set_instance_parameter_value sys_hps {UART0_Mode} {No Flow Control}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {UART1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C0_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {I2C0_Mode} {Full}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {I2C1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C2_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {I2C2_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C3_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {I2C3_Mode} {N/A}
set_instance_parameter_value sys_hps {CAN0_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {CAN0_Mode} {N/A}
set_instance_parameter_value sys_hps {CAN1_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {CAN1_Mode} {N/A}
set_instance_parameter_value sys_hps {TRACE_PinMuxing} {Unused}
set_instance_parameter_value sys_hps {TRACE_Mode} {N/A}
set_instance_parameter_value sys_hps {GPIO_Enable} {No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No}
set_instance_parameter_value sys_hps {LOANIO_Enable} {No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_MD_CLK} {2.5}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_GTX_CLK} {125}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_MD_CLK} {2.5}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK} {125}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_QSPI_SCLK_OUT} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SDIO_CCLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM0_SCLK_OUT} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM1_SCLK_OUT} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C0_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C1_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C2_CLK} {100}
set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C3_CLK} {100}

add_instance sys_id altera_avalon_sysid_qsys 16.0
set_instance_parameter_value sys_id {id} {-1395322110}

add_instance sys_int_mem altera_avalon_onchip_memory2 16.0
set_instance_parameter_value sys_int_mem {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value sys_int_mem {blockType} {AUTO}
set_instance_parameter_value sys_int_mem {dataWidth} {64}
set_instance_parameter_value sys_int_mem {dataWidth2} {32}
set_instance_parameter_value sys_int_mem {dualPort} {0}
set_instance_parameter_value sys_int_mem {enableDiffWidth} {0}
set_instance_parameter_value sys_int_mem {initMemContent} {0}
set_instance_parameter_value sys_int_mem {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value sys_int_mem {instanceID} {NONE}
set_instance_parameter_value sys_int_mem {memorySize} {65536.0}
set_instance_parameter_value sys_int_mem {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value sys_int_mem {simAllowMRAMContentsFile} {0}
set_instance_parameter_value sys_int_mem {simMemInitOnlyFilename} {0}
set_instance_parameter_value sys_int_mem {singleClockOperation} {0}
set_instance_parameter_value sys_int_mem {slave1Latency} {1}
set_instance_parameter_value sys_int_mem {slave2Latency} {1}
set_instance_parameter_value sys_int_mem {useNonDefaultInitFile} {0}
set_instance_parameter_value sys_int_mem {copyInitFile} {0}
set_instance_parameter_value sys_int_mem {useShallowMemBlocks} {0}
set_instance_parameter_value sys_int_mem {writable} {1}
set_instance_parameter_value sys_int_mem {ecc_enabled} {0}
set_instance_parameter_value sys_int_mem {resetrequest_enabled} {1}

add_instance sys_spi altera_avalon_spi 16.0
set_instance_parameter_value sys_spi {clockPhase} {0}
set_instance_parameter_value sys_spi {clockPolarity} {1}
set_instance_parameter_value sys_spi {dataWidth} {8}
set_instance_parameter_value sys_spi {disableAvalonFlowControl} {0}
set_instance_parameter_value sys_spi {insertDelayBetweenSlaveSelectAndSClk} {0}
set_instance_parameter_value sys_spi {insertSync} {0}
set_instance_parameter_value sys_spi {lsbOrderedFirst} {0}
set_instance_parameter_value sys_spi {masterSPI} {1}
set_instance_parameter_value sys_spi {numberOfSlaves} {1}
set_instance_parameter_value sys_spi {syncRegDepth} {2}
set_instance_parameter_value sys_spi {targetClockRate} {50000000.0}
set_instance_parameter_value sys_spi {targetSlaveSelectToSClkDelay} {0.0}

add_instance util_adc_pack util_cpack 1.0
set_instance_parameter_value util_adc_pack {CHANNEL_DATA_WIDTH} {16}
set_instance_parameter_value util_adc_pack {NUM_OF_CHANNELS} {4}

add_instance util_adc_wfifo util_wfifo 1.0
set_instance_parameter_value util_adc_wfifo {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_adc_wfifo {DIN_DATA_WIDTH} {16}
set_instance_parameter_value util_adc_wfifo {DOUT_DATA_WIDTH} {16}
set_instance_parameter_value util_adc_wfifo {DIN_ADDRESS_WIDTH} {5}

add_instance util_dac_rfifo util_rfifo 1.0
set_instance_parameter_value util_dac_rfifo {NUM_OF_CHANNELS} {4}
set_instance_parameter_value util_dac_rfifo {DIN_DATA_WIDTH} {16}
set_instance_parameter_value util_dac_rfifo {DOUT_DATA_WIDTH} {16}
set_instance_parameter_value util_dac_rfifo {DIN_ADDRESS_WIDTH} {5}

add_instance util_dac_upack util_upack 1.0
set_instance_parameter_value util_dac_upack {CHANNEL_DATA_WIDTH} {16}
set_instance_parameter_value util_dac_upack {NUM_OF_CHANNELS} {4}

add_instance vga_frame_reader alt_vip_vfr 14.0
set_instance_parameter_value vga_frame_reader {BITS_PER_PIXEL_PER_COLOR_PLANE} {8}
set_instance_parameter_value vga_frame_reader {NUMBER_OF_CHANNELS_IN_PARALLEL} {4}
set_instance_parameter_value vga_frame_reader {NUMBER_OF_CHANNELS_IN_SEQUENCE} {1}
set_instance_parameter_value vga_frame_reader {MAX_IMAGE_WIDTH} {1360}
set_instance_parameter_value vga_frame_reader {MAX_IMAGE_HEIGHT} {768}
set_instance_parameter_value vga_frame_reader {MEM_PORT_WIDTH} {128}
set_instance_parameter_value vga_frame_reader {RMASTER_FIFO_DEPTH} {64}
set_instance_parameter_value vga_frame_reader {RMASTER_BURST_TARGET} {32}
set_instance_parameter_value vga_frame_reader {CLOCKS_ARE_SEPARATE} {1}

add_instance vga_out_clock altera_clock_bridge 16.0
set_instance_parameter_value vga_out_clock {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value vga_out_clock {NUM_CLOCK_OUTPUTS} {1}

add_instance vga_out_data alt_vip_itc 14.0
set_instance_parameter_value vga_out_data {NUMBER_OF_COLOUR_PLANES} {4}
set_instance_parameter_value vga_out_data {COLOUR_PLANES_ARE_IN_PARALLEL} {1}
set_instance_parameter_value vga_out_data {BPS} {8}
set_instance_parameter_value vga_out_data {INTERLACED} {0}
set_instance_parameter_value vga_out_data {H_ACTIVE_PIXELS} {1360}
set_instance_parameter_value vga_out_data {V_ACTIVE_LINES} {768}
set_instance_parameter_value vga_out_data {ACCEPT_COLOURS_IN_SEQ} {0}
set_instance_parameter_value vga_out_data {FIFO_DEPTH} {1920}
set_instance_parameter_value vga_out_data {CLOCKS_ARE_SAME} {0}
set_instance_parameter_value vga_out_data {USE_CONTROL} {0}
set_instance_parameter_value vga_out_data {NO_OF_MODES} {1}
set_instance_parameter_value vga_out_data {THRESHOLD} {1919}
set_instance_parameter_value vga_out_data {STD_WIDTH} {1}
set_instance_parameter_value vga_out_data {GENERATE_SYNC} {0}
set_instance_parameter_value vga_out_data {USE_EMBEDDED_SYNCS} {0}
set_instance_parameter_value vga_out_data {AP_LINE} {0}
set_instance_parameter_value vga_out_data {V_BLANK} {0}
set_instance_parameter_value vga_out_data {H_BLANK} {0}
set_instance_parameter_value vga_out_data {H_SYNC_LENGTH} {112}
set_instance_parameter_value vga_out_data {H_FRONT_PORCH} {64}
set_instance_parameter_value vga_out_data {H_BACK_PORCH} {256}
set_instance_parameter_value vga_out_data {V_SYNC_LENGTH} {6}
set_instance_parameter_value vga_out_data {V_FRONT_PORCH} {3}
set_instance_parameter_value vga_out_data {V_BACK_PORCH} {18}
set_instance_parameter_value vga_out_data {F_RISING_EDGE} {0}
set_instance_parameter_value vga_out_data {F_FALLING_EDGE} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_RISING_EDGE} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_BLANK} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_SYNC_LENGTH} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_FRONT_PORCH} {0}
set_instance_parameter_value vga_out_data {FIELD0_V_BACK_PORCH} {0}
set_instance_parameter_value vga_out_data {ANC_LINE} {0}
set_instance_parameter_value vga_out_data {FIELD0_ANC_LINE} {0}

add_instance vga_pll altera_pll 16.0
set_instance_parameter_value vga_pll {debug_print_output} {0}
set_instance_parameter_value vga_pll {debug_use_rbc_taf_method} {0}
set_instance_parameter_value vga_pll {gui_device_speed_grade} {2}
set_instance_parameter_value vga_pll {gui_pll_mode} {Integer-N PLL}
set_instance_parameter_value vga_pll {gui_reference_clock_frequency} {50.0}
set_instance_parameter_value vga_pll {gui_channel_spacing} {0.0}
set_instance_parameter_value vga_pll {gui_operation_mode} {direct}
set_instance_parameter_value vga_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value vga_pll {gui_fractional_cout} {32}
set_instance_parameter_value vga_pll {gui_dsm_out_sel} {1st_order}
set_instance_parameter_value vga_pll {gui_use_locked} {0}
set_instance_parameter_value vga_pll {gui_en_adv_params} {0}
set_instance_parameter_value vga_pll {gui_number_of_clocks} {2}
set_instance_parameter_value vga_pll {gui_multiply_factor} {1}
set_instance_parameter_value vga_pll {gui_frac_multiply_factor} {1.0}
set_instance_parameter_value vga_pll {gui_divide_factor_n} {1}
set_instance_parameter_value vga_pll {gui_cascade_counter0} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency0} {85.5}
set_instance_parameter_value vga_pll {gui_divide_factor_c0} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency0} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units0} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift0} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg0} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift0} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle0} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter1} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency1} {171.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c1} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency1} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units1} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift1} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg1} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift1} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle1} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter2} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency2} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c2} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency2} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units2} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift2} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg2} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift2} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle2} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter3} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency3} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c3} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency3} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units3} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift3} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg3} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift3} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle3} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter4} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency4} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c4} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency4} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units4} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift4} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg4} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift4} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle4} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter5} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency5} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c5} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency5} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units5} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift5} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg5} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift5} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle5} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter6} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency6} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c6} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency6} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units6} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift6} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg6} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift6} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle6} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter7} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency7} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c7} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency7} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units7} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift7} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg7} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift7} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle7} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter8} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency8} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c8} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency8} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units8} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift8} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg8} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift8} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle8} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter9} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency9} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c9} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency9} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units9} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift9} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg9} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift9} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle9} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter10} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency10} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c10} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency10} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units10} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift10} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg10} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift10} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle10} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter11} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency11} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c11} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency11} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units11} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift11} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg11} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift11} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle11} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter12} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency12} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c12} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency12} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units12} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift12} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg12} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift12} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle12} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter13} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency13} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c13} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency13} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units13} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift13} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg13} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift13} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle13} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter14} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency14} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c14} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency14} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units14} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift14} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg14} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift14} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle14} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter15} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency15} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c15} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency15} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units15} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift15} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg15} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift15} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle15} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter16} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency16} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c16} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency16} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units16} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift16} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg16} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift16} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle16} {50}
set_instance_parameter_value vga_pll {gui_cascade_counter17} {0}
set_instance_parameter_value vga_pll {gui_output_clock_frequency17} {100.0}
set_instance_parameter_value vga_pll {gui_divide_factor_c17} {1}
set_instance_parameter_value vga_pll {gui_actual_output_clock_frequency17} {0 MHz}
set_instance_parameter_value vga_pll {gui_ps_units17} {ps}
set_instance_parameter_value vga_pll {gui_phase_shift17} {0}
set_instance_parameter_value vga_pll {gui_phase_shift_deg17} {0.0}
set_instance_parameter_value vga_pll {gui_actual_phase_shift17} {0}
set_instance_parameter_value vga_pll {gui_duty_cycle17} {50}
set_instance_parameter_value vga_pll {gui_pll_auto_reset} {Off}
set_instance_parameter_value vga_pll {gui_pll_bandwidth_preset} {Auto}
set_instance_parameter_value vga_pll {gui_en_reconf} {0}
set_instance_parameter_value vga_pll {gui_en_dps_ports} {0}
set_instance_parameter_value vga_pll {gui_en_phout_ports} {0}
set_instance_parameter_value vga_pll {gui_phout_division} {1}
set_instance_parameter_value vga_pll {gui_mif_generate} {0}
set_instance_parameter_value vga_pll {gui_enable_mif_dps} {0}
set_instance_parameter_value vga_pll {gui_dps_cntr} {C0}
set_instance_parameter_value vga_pll {gui_dps_num} {1}
set_instance_parameter_value vga_pll {gui_dps_dir} {Positive}
set_instance_parameter_value vga_pll {gui_refclk_switch} {0}
set_instance_parameter_value vga_pll {gui_refclk1_frequency} {100.0}
set_instance_parameter_value vga_pll {gui_switchover_mode} {Automatic Switchover}
set_instance_parameter_value vga_pll {gui_switchover_delay} {0}
set_instance_parameter_value vga_pll {gui_active_clk} {0}
set_instance_parameter_value vga_pll {gui_clk_bad} {0}
set_instance_parameter_value vga_pll {gui_enable_cascade_out} {0}
set_instance_parameter_value vga_pll {gui_cascade_outclk_index} {0}
set_instance_parameter_value vga_pll {gui_enable_cascade_in} {0}
set_instance_parameter_value vga_pll {gui_pll_cascading_mode} {Create an adjpllin signal to connect with an upstream PLL}

# exported interfaces
add_interface axi_ad9361_device_if conduit end
set_interface_property axi_ad9361_device_if EXPORT_OF axi_ad9361.device_if
add_interface axi_ad9361_up_enable conduit end
set_interface_property axi_ad9361_up_enable EXPORT_OF axi_ad9361.if_up_enable
add_interface axi_ad9361_up_txnrx conduit end
set_interface_property axi_ad9361_up_txnrx EXPORT_OF axi_ad9361.if_up_txnrx
add_interface sys_clk clock sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
add_interface sys_gpio_bd conduit end
set_interface_property sys_gpio_bd EXPORT_OF sys_gpio_bd.external_connection
add_interface sys_gpio_in conduit end
set_interface_property sys_gpio_in EXPORT_OF sys_gpio_in.external_connection
add_interface sys_gpio_out conduit end
set_interface_property sys_gpio_out EXPORT_OF sys_gpio_out.external_connection
add_interface sys_hps_h2f_reset reset source
set_interface_property sys_hps_h2f_reset EXPORT_OF sys_hps.h2f_reset
add_interface sys_hps_hps_io conduit end
set_interface_property sys_hps_hps_io EXPORT_OF sys_hps.hps_io
add_interface sys_hps_memory conduit end
set_interface_property sys_hps_memory EXPORT_OF sys_hps.memory
add_interface sys_rst reset sink
set_interface_property sys_rst EXPORT_OF sys_clk.clk_in_reset
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external
add_interface vga_out_clk clock source
set_interface_property vga_out_clk EXPORT_OF vga_out_clock.out_clk
add_interface vga_out_data conduit end
set_interface_property vga_out_data EXPORT_OF vga_out_data.clocked_video
add_interface sys_hps_i2c0 conduit end
set_interface_property sys_hps_i2c0 EXPORT_OF sys_hps.i2c0
add_interface sys_hps_i2c0_clk clock source
set_interface_property sys_hps_i2c0_clk EXPORT_OF sys_hps.i2c0_clk
add_interface sys_hps_i2c0_scl_in clock sink
set_interface_property sys_hps_i2c0_scl_in EXPORT_OF sys_hps.i2c0_scl_in

# connections and connection parameters
add_connection vga_frame_reader.avalon_master sys_hps.f2h_sdram0_data
set_connection_parameter_value vga_frame_reader.avalon_master/sys_hps.f2h_sdram0_data arbitrationPriority {1}
set_connection_parameter_value vga_frame_reader.avalon_master/sys_hps.f2h_sdram0_data baseAddress {0x0000}
set_connection_parameter_value vga_frame_reader.avalon_master/sys_hps.f2h_sdram0_data defaultConnection {0}

add_connection sys_hps.h2f_axi_master sys_int_mem.s1
set_connection_parameter_value sys_hps.h2f_axi_master/sys_int_mem.s1 arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_axi_master/sys_int_mem.s1 baseAddress {0x0000}
set_connection_parameter_value sys_hps.h2f_axi_master/sys_int_mem.s1 defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master vga_frame_reader.avalon_slave
set_connection_parameter_value sys_hps.h2f_lw_axi_master/vga_frame_reader.avalon_slave arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/vga_frame_reader.avalon_slave baseAddress {0x9000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/vga_frame_reader.avalon_slave defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master sys_id.control_slave
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_id.control_slave arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_id.control_slave baseAddress {0x00010000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_id.control_slave defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master sys_gpio_bd.s1
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_bd.s1 arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_bd.s1 baseAddress {0x00010080}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_bd.s1 defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master sys_gpio_in.s1
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_in.s1 arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_in.s1 baseAddress {0x00010100}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_in.s1 defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master sys_gpio_out.s1
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_out.s1 arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_out.s1 baseAddress {0x00109000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_gpio_out.s1 defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master axi_ad9361.s_axi
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_ad9361.s_axi arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_ad9361.s_axi baseAddress {0x00120000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_ad9361.s_axi defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master axi_adc_dma.s_axi
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_adc_dma.s_axi arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_adc_dma.s_axi baseAddress {0x00100000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_adc_dma.s_axi defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master axi_dac_dma.s_axi
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_dac_dma.s_axi arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_dac_dma.s_axi baseAddress {0x00104000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/axi_dac_dma.s_axi defaultConnection {0}

add_connection sys_hps.h2f_lw_axi_master sys_spi.spi_control_port
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_spi.spi_control_port arbitrationPriority {1}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_spi.spi_control_port baseAddress {0x00108000}
set_connection_parameter_value sys_hps.h2f_lw_axi_master/sys_spi.spi_control_port defaultConnection {0}

add_connection axi_adc_dma.m_dest_axi sys_hps.f2h_sdram2_data
set_connection_parameter_value axi_adc_dma.m_dest_axi/sys_hps.f2h_sdram2_data arbitrationPriority {1}
set_connection_parameter_value axi_adc_dma.m_dest_axi/sys_hps.f2h_sdram2_data baseAddress {0x0000}
set_connection_parameter_value axi_adc_dma.m_dest_axi/sys_hps.f2h_sdram2_data defaultConnection {0}

add_connection axi_dac_dma.m_src_axi sys_hps.f2h_sdram1_data
set_connection_parameter_value axi_dac_dma.m_src_axi/sys_hps.f2h_sdram1_data arbitrationPriority {1}
set_connection_parameter_value axi_dac_dma.m_src_axi/sys_hps.f2h_sdram1_data baseAddress {0x0000}
set_connection_parameter_value axi_dac_dma.m_src_axi/sys_hps.f2h_sdram1_data defaultConnection {0}

add_connection vga_frame_reader.avalon_streaming_source vga_out_data.din

add_connection sys_clk.clk sys_id.clk

add_connection sys_clk.clk sys_gpio_bd.clk

add_connection sys_clk.clk sys_gpio_in.clk

add_connection sys_clk.clk sys_gpio_out.clk

add_connection sys_clk.clk sys_spi.clk

add_connection sys_clk.clk sys_int_mem.clk1

add_connection sys_clk.clk vga_frame_reader.clock_master

add_connection sys_clk.clk sys_hps.f2h_axi_clock

add_connection sys_clk.clk sys_hps.f2h_sdram0_clock

add_connection sys_dma_clk.clk sys_hps.f2h_sdram1_clock

add_connection sys_dma_clk.clk sys_hps.f2h_sdram2_clock

add_connection sys_clk.clk sys_hps.h2f_axi_clock

add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock

add_connection sys_dma_clk.clk util_adc_pack.if_adc_clk

add_connection sys_dma_clk.clk util_dac_upack.if_dac_clk

add_connection sys_clk.clk axi_ad9361.if_delay_clk

add_connection sys_dma_clk.clk util_dac_rfifo.if_din_clk

add_connection sys_dma_clk.clk util_adc_wfifo.if_dout_clk

add_connection sys_dma_clk.clk axi_dac_dma.if_fifo_rd_clk

add_connection sys_dma_clk.clk axi_adc_dma.if_fifo_wr_clk

add_connection sys_dma_clk.clk axi_adc_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk axi_dac_dma.m_src_axi_clock

add_connection sys_clk.clk vga_pll.refclk

add_connection sys_clk.clk axi_ad9361.s_axi_clock

add_connection sys_clk.clk axi_adc_dma.s_axi_clock

add_connection sys_clk.clk axi_dac_dma.s_axi_clock

add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in

add_connection axi_ad9361.if_l_clk axi_ad9361.if_clk

add_connection axi_ad9361.if_l_clk util_adc_wfifo.if_din_clk

add_connection axi_ad9361.if_l_clk util_dac_rfifo.if_dout_clk

add_connection vga_pll.outclk0 vga_frame_reader.clock_reset

add_connection vga_pll.outclk0 vga_out_clock.in_clk

add_connection vga_pll.outclk0 vga_out_data.is_clk_rst

add_connection axi_ad9361.adc_ch_0 util_adc_wfifo.din_0
set_connection_parameter_value axi_ad9361.adc_ch_0/util_adc_wfifo.din_0 endPort {}
set_connection_parameter_value axi_ad9361.adc_ch_0/util_adc_wfifo.din_0 endPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_0/util_adc_wfifo.din_0 startPort {}
set_connection_parameter_value axi_ad9361.adc_ch_0/util_adc_wfifo.din_0 startPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_0/util_adc_wfifo.din_0 width {0}

add_connection axi_ad9361.adc_ch_1 util_adc_wfifo.din_1
set_connection_parameter_value axi_ad9361.adc_ch_1/util_adc_wfifo.din_1 endPort {}
set_connection_parameter_value axi_ad9361.adc_ch_1/util_adc_wfifo.din_1 endPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_1/util_adc_wfifo.din_1 startPort {}
set_connection_parameter_value axi_ad9361.adc_ch_1/util_adc_wfifo.din_1 startPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_1/util_adc_wfifo.din_1 width {0}

add_connection axi_ad9361.adc_ch_2 util_adc_wfifo.din_2
set_connection_parameter_value axi_ad9361.adc_ch_2/util_adc_wfifo.din_2 endPort {}
set_connection_parameter_value axi_ad9361.adc_ch_2/util_adc_wfifo.din_2 endPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_2/util_adc_wfifo.din_2 startPort {}
set_connection_parameter_value axi_ad9361.adc_ch_2/util_adc_wfifo.din_2 startPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_2/util_adc_wfifo.din_2 width {0}

add_connection axi_ad9361.adc_ch_3 util_adc_wfifo.din_3
set_connection_parameter_value axi_ad9361.adc_ch_3/util_adc_wfifo.din_3 endPort {}
set_connection_parameter_value axi_ad9361.adc_ch_3/util_adc_wfifo.din_3 endPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_3/util_adc_wfifo.din_3 startPort {}
set_connection_parameter_value axi_ad9361.adc_ch_3/util_adc_wfifo.din_3 startPortLSB {0}
set_connection_parameter_value axi_ad9361.adc_ch_3/util_adc_wfifo.din_3 width {0}

add_connection util_dac_upack.dac_ch_0 util_dac_rfifo.din_0
set_connection_parameter_value util_dac_upack.dac_ch_0/util_dac_rfifo.din_0 endPort {}
set_connection_parameter_value util_dac_upack.dac_ch_0/util_dac_rfifo.din_0 endPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_0/util_dac_rfifo.din_0 startPort {}
set_connection_parameter_value util_dac_upack.dac_ch_0/util_dac_rfifo.din_0 startPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_0/util_dac_rfifo.din_0 width {0}

add_connection util_dac_upack.dac_ch_1 util_dac_rfifo.din_1
set_connection_parameter_value util_dac_upack.dac_ch_1/util_dac_rfifo.din_1 endPort {}
set_connection_parameter_value util_dac_upack.dac_ch_1/util_dac_rfifo.din_1 endPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_1/util_dac_rfifo.din_1 startPort {}
set_connection_parameter_value util_dac_upack.dac_ch_1/util_dac_rfifo.din_1 startPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_1/util_dac_rfifo.din_1 width {0}

add_connection util_dac_upack.dac_ch_2 util_dac_rfifo.din_2
set_connection_parameter_value util_dac_upack.dac_ch_2/util_dac_rfifo.din_2 endPort {}
set_connection_parameter_value util_dac_upack.dac_ch_2/util_dac_rfifo.din_2 endPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_2/util_dac_rfifo.din_2 startPort {}
set_connection_parameter_value util_dac_upack.dac_ch_2/util_dac_rfifo.din_2 startPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_2/util_dac_rfifo.din_2 width {0}

add_connection util_dac_upack.dac_ch_3 util_dac_rfifo.din_3
set_connection_parameter_value util_dac_upack.dac_ch_3/util_dac_rfifo.din_3 endPort {}
set_connection_parameter_value util_dac_upack.dac_ch_3/util_dac_rfifo.din_3 endPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_3/util_dac_rfifo.din_3 startPort {}
set_connection_parameter_value util_dac_upack.dac_ch_3/util_dac_rfifo.din_3 startPortLSB {0}
set_connection_parameter_value util_dac_upack.dac_ch_3/util_dac_rfifo.din_3 width {0}

add_connection util_adc_wfifo.dout_0 util_adc_pack.adc_ch_0
set_connection_parameter_value util_adc_wfifo.dout_0/util_adc_pack.adc_ch_0 endPort {}
set_connection_parameter_value util_adc_wfifo.dout_0/util_adc_pack.adc_ch_0 endPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_0/util_adc_pack.adc_ch_0 startPort {}
set_connection_parameter_value util_adc_wfifo.dout_0/util_adc_pack.adc_ch_0 startPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_0/util_adc_pack.adc_ch_0 width {0}

add_connection util_dac_rfifo.dout_0 axi_ad9361.dac_ch_0
set_connection_parameter_value util_dac_rfifo.dout_0/axi_ad9361.dac_ch_0 endPort {}
set_connection_parameter_value util_dac_rfifo.dout_0/axi_ad9361.dac_ch_0 endPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_0/axi_ad9361.dac_ch_0 startPort {}
set_connection_parameter_value util_dac_rfifo.dout_0/axi_ad9361.dac_ch_0 startPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_0/axi_ad9361.dac_ch_0 width {0}

add_connection util_adc_wfifo.dout_1 util_adc_pack.adc_ch_1
set_connection_parameter_value util_adc_wfifo.dout_1/util_adc_pack.adc_ch_1 endPort {}
set_connection_parameter_value util_adc_wfifo.dout_1/util_adc_pack.adc_ch_1 endPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_1/util_adc_pack.adc_ch_1 startPort {}
set_connection_parameter_value util_adc_wfifo.dout_1/util_adc_pack.adc_ch_1 startPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_1/util_adc_pack.adc_ch_1 width {0}

add_connection util_dac_rfifo.dout_1 axi_ad9361.dac_ch_1
set_connection_parameter_value util_dac_rfifo.dout_1/axi_ad9361.dac_ch_1 endPort {}
set_connection_parameter_value util_dac_rfifo.dout_1/axi_ad9361.dac_ch_1 endPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_1/axi_ad9361.dac_ch_1 startPort {}
set_connection_parameter_value util_dac_rfifo.dout_1/axi_ad9361.dac_ch_1 startPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_1/axi_ad9361.dac_ch_1 width {0}

add_connection util_adc_wfifo.dout_2 util_adc_pack.adc_ch_2
set_connection_parameter_value util_adc_wfifo.dout_2/util_adc_pack.adc_ch_2 endPort {}
set_connection_parameter_value util_adc_wfifo.dout_2/util_adc_pack.adc_ch_2 endPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_2/util_adc_pack.adc_ch_2 startPort {}
set_connection_parameter_value util_adc_wfifo.dout_2/util_adc_pack.adc_ch_2 startPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_2/util_adc_pack.adc_ch_2 width {0}

add_connection util_dac_rfifo.dout_2 axi_ad9361.dac_ch_2
set_connection_parameter_value util_dac_rfifo.dout_2/axi_ad9361.dac_ch_2 endPort {}
set_connection_parameter_value util_dac_rfifo.dout_2/axi_ad9361.dac_ch_2 endPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_2/axi_ad9361.dac_ch_2 startPort {}
set_connection_parameter_value util_dac_rfifo.dout_2/axi_ad9361.dac_ch_2 startPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_2/axi_ad9361.dac_ch_2 width {0}

add_connection util_adc_wfifo.dout_3 util_adc_pack.adc_ch_3
set_connection_parameter_value util_adc_wfifo.dout_3/util_adc_pack.adc_ch_3 endPort {}
set_connection_parameter_value util_adc_wfifo.dout_3/util_adc_pack.adc_ch_3 endPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_3/util_adc_pack.adc_ch_3 startPort {}
set_connection_parameter_value util_adc_wfifo.dout_3/util_adc_pack.adc_ch_3 startPortLSB {0}
set_connection_parameter_value util_adc_wfifo.dout_3/util_adc_pack.adc_ch_3 width {0}

add_connection util_dac_rfifo.dout_3 axi_ad9361.dac_ch_3
set_connection_parameter_value util_dac_rfifo.dout_3/axi_ad9361.dac_ch_3 endPort {}
set_connection_parameter_value util_dac_rfifo.dout_3/axi_ad9361.dac_ch_3 endPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_3/axi_ad9361.dac_ch_3 startPort {}
set_connection_parameter_value util_dac_rfifo.dout_3/axi_ad9361.dac_ch_3 startPortLSB {0}
set_connection_parameter_value util_dac_rfifo.dout_3/axi_ad9361.dac_ch_3 width {0}

add_connection util_adc_pack.if_adc_data axi_adc_dma.if_fifo_wr_din
set_connection_parameter_value util_adc_pack.if_adc_data/axi_adc_dma.if_fifo_wr_din endPort {}
set_connection_parameter_value util_adc_pack.if_adc_data/axi_adc_dma.if_fifo_wr_din endPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_data/axi_adc_dma.if_fifo_wr_din startPort {}
set_connection_parameter_value util_adc_pack.if_adc_data/axi_adc_dma.if_fifo_wr_din startPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_data/axi_adc_dma.if_fifo_wr_din width {0}

add_connection util_adc_pack.if_adc_sync axi_adc_dma.if_fifo_wr_sync
set_connection_parameter_value util_adc_pack.if_adc_sync/axi_adc_dma.if_fifo_wr_sync endPort {}
set_connection_parameter_value util_adc_pack.if_adc_sync/axi_adc_dma.if_fifo_wr_sync endPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_sync/axi_adc_dma.if_fifo_wr_sync startPort {}
set_connection_parameter_value util_adc_pack.if_adc_sync/axi_adc_dma.if_fifo_wr_sync startPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_sync/axi_adc_dma.if_fifo_wr_sync width {0}

add_connection util_adc_pack.if_adc_valid axi_adc_dma.if_fifo_wr_en
set_connection_parameter_value util_adc_pack.if_adc_valid/axi_adc_dma.if_fifo_wr_en endPort {}
set_connection_parameter_value util_adc_pack.if_adc_valid/axi_adc_dma.if_fifo_wr_en endPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_valid/axi_adc_dma.if_fifo_wr_en startPort {}
set_connection_parameter_value util_adc_pack.if_adc_valid/axi_adc_dma.if_fifo_wr_en startPortLSB {0}
set_connection_parameter_value util_adc_pack.if_adc_valid/axi_adc_dma.if_fifo_wr_en width {0}

add_connection util_dac_upack.if_dac_valid axi_dac_dma.if_fifo_rd_en
set_connection_parameter_value util_dac_upack.if_dac_valid/axi_dac_dma.if_fifo_rd_en endPort {}
set_connection_parameter_value util_dac_upack.if_dac_valid/axi_dac_dma.if_fifo_rd_en endPortLSB {0}
set_connection_parameter_value util_dac_upack.if_dac_valid/axi_dac_dma.if_fifo_rd_en startPort {}
set_connection_parameter_value util_dac_upack.if_dac_valid/axi_dac_dma.if_fifo_rd_en startPortLSB {0}
set_connection_parameter_value util_dac_upack.if_dac_valid/axi_dac_dma.if_fifo_rd_en width {0}

add_connection util_adc_wfifo.if_din_ovf axi_ad9361.if_adc_dovf
set_connection_parameter_value util_adc_wfifo.if_din_ovf/axi_ad9361.if_adc_dovf endPort {}
set_connection_parameter_value util_adc_wfifo.if_din_ovf/axi_ad9361.if_adc_dovf endPortLSB {0}
set_connection_parameter_value util_adc_wfifo.if_din_ovf/axi_ad9361.if_adc_dovf startPort {}
set_connection_parameter_value util_adc_wfifo.if_din_ovf/axi_ad9361.if_adc_dovf startPortLSB {0}
set_connection_parameter_value util_adc_wfifo.if_din_ovf/axi_ad9361.if_adc_dovf width {0}

add_connection util_dac_rfifo.if_dout_unf axi_ad9361.if_dac_dunf
set_connection_parameter_value util_dac_rfifo.if_dout_unf/axi_ad9361.if_dac_dunf endPort {}
set_connection_parameter_value util_dac_rfifo.if_dout_unf/axi_ad9361.if_dac_dunf endPortLSB {0}
set_connection_parameter_value util_dac_rfifo.if_dout_unf/axi_ad9361.if_dac_dunf startPort {}
set_connection_parameter_value util_dac_rfifo.if_dout_unf/axi_ad9361.if_dac_dunf startPortLSB {0}
set_connection_parameter_value util_dac_rfifo.if_dout_unf/axi_ad9361.if_dac_dunf width {0}

add_connection axi_dac_dma.if_fifo_rd_dout util_dac_upack.if_dac_data
set_connection_parameter_value axi_dac_dma.if_fifo_rd_dout/util_dac_upack.if_dac_data endPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_dout/util_dac_upack.if_dac_data endPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_dout/util_dac_upack.if_dac_data startPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_dout/util_dac_upack.if_dac_data startPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_dout/util_dac_upack.if_dac_data width {0}

add_connection axi_dac_dma.if_fifo_rd_underflow util_dac_rfifo.if_din_unf
set_connection_parameter_value axi_dac_dma.if_fifo_rd_underflow/util_dac_rfifo.if_din_unf endPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_underflow/util_dac_rfifo.if_din_unf endPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_underflow/util_dac_rfifo.if_din_unf startPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_underflow/util_dac_rfifo.if_din_unf startPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_underflow/util_dac_rfifo.if_din_unf width {0}

add_connection axi_dac_dma.if_fifo_rd_xfer_req util_dac_upack.if_dma_xfer_in
set_connection_parameter_value axi_dac_dma.if_fifo_rd_xfer_req/util_dac_upack.if_dma_xfer_in endPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_xfer_req/util_dac_upack.if_dma_xfer_in endPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_xfer_req/util_dac_upack.if_dma_xfer_in startPort {}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_xfer_req/util_dac_upack.if_dma_xfer_in startPortLSB {0}
set_connection_parameter_value axi_dac_dma.if_fifo_rd_xfer_req/util_dac_upack.if_dma_xfer_in width {0}

add_connection axi_adc_dma.if_fifo_wr_overflow util_adc_wfifo.if_dout_ovf
set_connection_parameter_value axi_adc_dma.if_fifo_wr_overflow/util_adc_wfifo.if_dout_ovf endPort {}
set_connection_parameter_value axi_adc_dma.if_fifo_wr_overflow/util_adc_wfifo.if_dout_ovf endPortLSB {0}
set_connection_parameter_value axi_adc_dma.if_fifo_wr_overflow/util_adc_wfifo.if_dout_ovf startPort {}
set_connection_parameter_value axi_adc_dma.if_fifo_wr_overflow/util_adc_wfifo.if_dout_ovf startPortLSB {0}
set_connection_parameter_value axi_adc_dma.if_fifo_wr_overflow/util_adc_wfifo.if_dout_ovf width {0}

add_connection sys_hps.f2h_irq0 vga_frame_reader.interrupt_sender
set_connection_parameter_value sys_hps.f2h_irq0/vga_frame_reader.interrupt_sender irqNumber {4}

add_connection sys_hps.f2h_irq0 axi_adc_dma.interrupt_sender
set_connection_parameter_value sys_hps.f2h_irq0/axi_adc_dma.interrupt_sender irqNumber {2}

add_connection sys_hps.f2h_irq0 axi_dac_dma.interrupt_sender
set_connection_parameter_value sys_hps.f2h_irq0/axi_dac_dma.interrupt_sender irqNumber {3}

add_connection sys_hps.f2h_irq0 sys_gpio_bd.irq
set_connection_parameter_value sys_hps.f2h_irq0/sys_gpio_bd.irq irqNumber {0}

add_connection sys_hps.f2h_irq0 sys_spi.irq
set_connection_parameter_value sys_hps.f2h_irq0/sys_spi.irq irqNumber {1}

add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset

add_connection sys_clk.clk_reset vga_frame_reader.clock_master_reset

add_connection sys_clk.clk_reset vga_frame_reader.clock_reset_reset

add_connection sys_dma_clk.clk_reset util_adc_pack.if_adc_rst

add_connection sys_dma_clk.clk_reset util_dac_rfifo.if_din_rstn

add_connection sys_dma_clk.clk_reset util_adc_wfifo.if_dout_rstn

add_connection sys_clk.clk_reset vga_out_data.is_clk_rst_reset

add_connection sys_dma_clk.clk_reset axi_adc_dma.m_dest_axi_reset

add_connection sys_dma_clk.clk_reset axi_dac_dma.m_src_axi_reset

add_connection sys_clk.clk_reset vga_pll.reset

add_connection sys_clk.clk_reset sys_id.reset

add_connection sys_clk.clk_reset sys_gpio_bd.reset

add_connection sys_clk.clk_reset sys_gpio_in.reset

add_connection sys_clk.clk_reset sys_gpio_out.reset

add_connection sys_clk.clk_reset sys_spi.reset

add_connection sys_clk.clk_reset sys_int_mem.reset1

add_connection sys_clk.clk_reset axi_ad9361.s_axi_reset

add_connection sys_clk.clk_reset axi_adc_dma.s_axi_reset

add_connection sys_clk.clk_reset axi_dac_dma.s_axi_reset

add_connection axi_ad9361.if_rst util_adc_wfifo.if_din_rst

add_connection axi_ad9361.if_rst util_dac_rfifo.if_dout_rst

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {FIFO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {2}

save_system {system_bd.qsys}
