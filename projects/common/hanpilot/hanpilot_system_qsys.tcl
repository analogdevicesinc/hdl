# hanpilot carrier qsys

set xcvr_reconfig_addr_width 10

# clock-&-reset
add_instance sys_clk clock_source
add_interface sys_clk clock sink
set_interface_property sys_clk EXPORT_OF sys_clk.clk_in
add_interface sys_rstn reset sink
set_interface_property sys_rstn EXPORT_OF sys_clk.clk_in_reset
set_instance_parameter_value sys_clk {clockFrequency} {100000000.0}
set_instance_parameter_value sys_clk {clockFrequencyKnown} {1}
set_instance_parameter_value sys_clk {resetSynchronousEdges} {DEASSERT}

add_instance sys_hps altera_arria10_hps
set_instance_parameter_value sys_hps {MPU_EVENTS_Enable} {0}
set_instance_parameter_value sys_hps {F2S_Width} {0}
set_instance_parameter_value sys_hps {S2F_Width} {0}
set_instance_parameter_value sys_hps {LWH2F_Enable} {1}
set_instance_parameter_value sys_hps {F2SDRAM_PORT_CONFIG} {6}
set_instance_parameter_value sys_hps {F2SDRAM0_ENABLED} {1}
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {HPS_IO_Enable} {SDMMC:D0 SDMMC:CMD SDMMC:CCLK SDMMC:D1 SDMMC:D2 SDMMC:D3 NONE NONE GPIO GPIO GPIO GPIO UART1:TX UART1:RX USB0:CLK USB0:STP USB0:DIR USB0:DATA0 USB0:DATA1 USB0:NXT USB0:DATA2 USB0:DATA3 USB0:DATA4 USB0:DATA5 USB0:DATA6 USB0:DATA7 EMAC0:TX_CLK EMAC0:TX_CTL EMAC0:RX_CLK EMAC0:RX_CTL EMAC0:TXD0 EMAC0:TXD1 EMAC0:RXD0 EMAC0:RXD1 EMAC0:TXD2 EMAC0:TXD3 EMAC0:RXD2 EMAC0:RXD3 NONE GPIO I2C0:SDA I2C0:SCL GPIO NONE NONE NONE NONE NONE MDIO0:MDIO MDIO0:MDC NONE NONE NONE GPIO NONE NONE NONE NONE NONE NONE NONE NONE}
set_instance_parameter_value sys_hps {SDMMC_PinMuxing} {IO}
set_instance_parameter_value sys_hps {SDMMC_Mode} {4-bit}
set_instance_parameter_value sys_hps {USB0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {USB0_Mode} {default}
set_instance_parameter_value sys_hps {EMAC0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {EMAC0_Mode} {RGMII_with_MDIO}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {UART1_Mode} {No_flow_control}
set_instance_parameter_value sys_hps {I2C0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {I2C0_Mode} {default}
set_instance_parameter_value sys_hps {F2H_COLD_RST_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_Enable} {1}
set_instance_parameter_value sys_hps {H2F_USER0_CLK_FREQ} {175}
set_instance_parameter_value sys_hps {CLK_SDMMC_SOURCE} {1}

add_interface sys_hps_rstn reset sink
set_interface_property sys_hps_rstn EXPORT_OF sys_hps.f2h_cold_reset_req
add_interface sys_hps_out_rstn reset source
set_interface_property sys_hps_out_rstn EXPORT_OF sys_hps.h2f_reset
add_connection sys_clk.clk sys_hps.h2f_lw_axi_clock
add_connection sys_clk.clk_reset sys_hps.h2f_lw_axi_reset
add_interface sys_hps_io conduit end
set_interface_property sys_hps_io EXPORT_OF sys_hps.hps_io
add_interface sys_hps_fpga_irq1 conduit end
set_interface_property sys_hps_fpga_irq1 EXPORT_OF sys_hps.f2h_irq1

# common dma interfaces

add_instance sys_dma_clk clock_source
set_instance_parameter_value sys_dma_clk {resetSynchronousEdges} {DEASSERT}
set_instance_parameter_value sys_dma_clk {clockFrequencyKnown} {false}
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in
add_connection sys_dma_clk.clk sys_hps.f2sdram0_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2sdram0_reset

# ddr4 interface

add_instance sys_hps_ddr4_cntrl altera_emif_a10_hps

set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_AC_TO_CK_SKEW_NS} {-8.83595e-05}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_DQS_TO_CK_SKEW_NS} {-0.08659949}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_IS_SKEW_WITHIN_AC_DESKEWED} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_IS_SKEW_WITHIN_DQS_DESKEWED} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_MAX_CK_DELAY_NS} {0.60460588}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_MAX_DQS_DELAY_NS} {0.566834552}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_PKG_BRD_SKEW_WITHIN_AC_NS} {0.002694888}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_PKG_BRD_SKEW_WITHIN_DQS_NS} {0.00142042}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_SKEW_BETWEEN_DIMMS_NS} {0.05}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_SKEW_BETWEEN_DQS_NS} {0.098106304}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_AC_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_AC_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_CK_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RCLK_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RCLK_SLEW_RATE} {8.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RDATA_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RDATA_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WCLK_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WCLK_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WDATA_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WDATA_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USE_DEFAULT_ISI_VALUES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USE_DEFAULT_SLEW_RATES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ADDR_ORDER_ENUM} {DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_POWER_DOWN_CYCS} {32}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_POWER_DOWN_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_PRECHARGE_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AVL_PROTOCOL_ENUM} {CTRL_AVL_PROTOCOL_ST}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ECC_AUTO_CORRECTION_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ECC_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_MMR_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_WR_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_REORDER_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_SELF_REFRESH_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_STARVE_LIMIT} {10}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_USER_PRIORITY_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_USER_REFRESH_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_RD_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_ABSTRACT_PHY} {0}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_DEFAULT_PATTERN} {0}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_REPEAT_STAGE} {1}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_STRESS_STAGE} {1}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_USER_STAGE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ADDR0} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ADDR1} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ENABLE_NON_DES} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_FULL_CAL_ON_RESET} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EFFICIENCY_MONITOR} {EFFMON_MODE_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EXPORT_SEQ_AVALON_MASTER} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE} {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_ISSP_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_NUM_OF_SLAVES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_SEPARATE_RZQS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_INTERFACE_ID} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SEPARATE_READ_WRITE_ITFS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SIM_CAL_MODE_ENUM} {SIM_CAL_MODE_SKIP}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_DESKEW} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_LEVEL} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_VREF_CAL} {0}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_TG_BE_PATTERN_LENGTH} {8}
#set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_TG_DATA_PATTERN_LENGTH} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_USE_TG_AVL_2} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ECLIPSE_DEBUG} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_HPS_EMIF_DEBUG} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_JTAG_UART} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_JTAG_UART_HEX} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXPORT_VJI} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXPOSE_DFT_SIGNALS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXTRA_CONFIGS} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXT_DOCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EX_DESIGN_ADD_TEST_EMIFS} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_AC_PARITY_LATENCY} {DDR4_AC_PARITY_LATENCY_DISABLE}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_AC_PERSISTENT_ERROR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_LANE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_PIN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_DQS_GROUP} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_DATA_LANES}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_PAR_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ASR_ENUM} {DDR4_ASR_MANUAL_NORMAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ATCL_ENUM} {DDR4_ATCL_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_ADDR_WIDTH} {2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BL_ENUM} {DDR4_BL_BL8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BT_ENUM} {DDR4_BT_SEQUENTIAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CAL_MODE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CHIP_ID_WIDTH} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CKE_PER_DIMM} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CK_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DB_DQ_DRV_ENUM} {DDR4_DB_DRV_STR_RZQ_7}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DB_RTT_NOM_ENUM} {DDR4_DB_RTT_NOM_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DB_RTT_PARK_ENUM} {DDR4_DB_RTT_PARK_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DB_RTT_WR_ENUM} {DDR4_DB_RTT_WR_RZQ_3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DEFAULT_VREFOUT} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DISCRETE_MIRROR_ADDRESSING_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DLL_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DM_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DQ_PER_DQS} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DQ_WIDTH} {32}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DRV_STR_ENUM} {DDR4_DRV_STR_RZQ_7}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_FINE_GRANULARITY_REFRESH} {DDR4_FINE_REFRESH_FIXED_1X}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_FORMAT_ENUM} {MEM_FORMAT_DISCRETE}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_GEARDOWN} {DDR4_GEARDOWN_HR}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_HIDE_ADV_MR_SETTINGS} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_INTERNAL_VREFDQ_MONITOR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_ODT_LESS_BS} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_ODT_LESS_BS_PARK_OHM} {240}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_VREFDQ_VALUE} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MAX_POWERDOWN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MIRROR_ADDRESSING_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MPR_READ_FORMAT} {DDR4_MPR_READ_FORMAT_SERIAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_NUM_OF_DIMMS} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ODT_IN_POWERDOWN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_PER_DRAM_ADDR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RANKS_PER_DIMM} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RCD_CA_IBT_ENUM} {DDR4_RCD_CA_IBT_100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RCD_CKE_IBT_ENUM} {DDR4_RCD_CKE_IBT_100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RCD_CS_IBT_ENUM} {DDR4_RCD_CS_IBT_100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RCD_ODT_IBT_ENUM} {DDR4_RCD_ODT_IBT_100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_DBI} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE} {2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE_TRAINING} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_PARK} {DDR4_RTT_PARK_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_WR_ENUM} {DDR4_RTT_WR_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_1X1} {off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_2X2} {off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_4X2} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_4X4} {off off off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_2X2} {off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_4X2} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT2_4X4} {off off off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT3_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SELF_RFSH_ABORT} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_133_RCD_DB_VENDOR_LSB} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_134_RCD_DB_VENDOR_MSB} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_135_RCD_REV} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_137_RCD_CA_DRV} {101}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_138_RCD_CK_DRV} {5}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_139_DB_REV} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_140_DRAM_VREFDQ_R0} {29}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_141_DRAM_VREFDQ_R1} {29}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_142_DRAM_VREFDQ_R2} {29}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_143_DRAM_VREFDQ_R3} {29}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_144_DB_VREFDQ} {37}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_145_DB_MDQ_DRV} {21}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_148_DRAM_DRV} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_149_DRAM_RTT_WR_NOM} {20}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPD_152_DRAM_RTT_PARK} {39}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2133}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCCD_L_CYC} {6}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCCD_S_CYC} {4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCL} {20}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDIVW_DJ_CYC} {0.1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDIVW_TOTAL_UI} {0.2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSCK_PS} {175}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSQ_PS} {66}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSQ_UI} {0.17}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSS_CYC} {0.27}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDSH_CYC} {0.18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDSS_CYC} {0.18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDVWP_UI} {0.72}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_ENA} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_RANGE} {DDR4_TEMP_CONTROLLED_RFSH_NORMAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_SENSOR_READOUT} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIH_DC_MV} {75}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIH_PS} {87}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TINIT_US} {500}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIS_AC_MV} {100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIS_PS} {62}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TMRD_CK_CYC} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQH_CYC} {0.38}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQH_UI} {0.74}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQSH_CYC} {0.4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRAS_NS} {32.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRCD_NS} {14.16}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TREFI_US} {7.8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRFC_NS} {260.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRP_NS} {14.16}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {7}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWLH_PS} {108.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWLS_PS} {108.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWR_NS} {15.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {9}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_RANGE} {DDR4_VREFDQ_TRAINING_RANGE_1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_VALUE} {72.9}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USE_DEFAULT_ODT} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_VDIVW_TOTAL} {130}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_CRC} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_DBI} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_PREAMBLE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WTCL} {16}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_1X1} {on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_2X2} {on off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_4X2} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_2X2} {off on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_4X2} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT2_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT3_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}

set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_CORE_CLKS_SHARING_ENUM} {CORE_CLKS_SHARING_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_HPS_ENABLE_EARLY_RELEASE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_IO_VOLTAGE} {1.2}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1066.666}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_RATE_ENUM} {RATE_HALF}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_REF_CLK_JITTER_PS} {10.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AUTO_STARTING_VREFIN_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_60_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_48_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PERIODIC_OCT_RECAL_ENUM} {PERIODIC_OCT_RECAL_AUTO}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PING_PONG_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {266.667}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_STARTING_VREFIN} {70.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}

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

proc ad_cpu_interconnect {m_base m_port} {

  add_connection sys_hps.h2f_lw_axi_master ${m_port}
  set_connection_parameter_value sys_hps.h2f_lw_axi_master/${m_port} baseAddress ${m_base}
}

proc ad_dma_interconnect {m_port} {

  add_connection ${m_port} sys_hps.f2sdram0_data
  set_connection_parameter_value ${m_port}/sys_hps.f2sdram0_data baseAddress {0x0}
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

# FPGA I2C

add_instance sys_i2c altera_avalon_i2c
set_instance_parameter_value sys_i2c {USE_AV_ST} {0}
set_instance_parameter_value sys_i2c {FIFO_DEPTH} {64}

add_connection sys_clk.clk_reset sys_i2c.reset_sink
add_connection sys_clk.clk sys_i2c.clock
add_interface sys_i2c conduit end
set_interface_property sys_i2c EXPORT_OF sys_i2c.i2c_serial

# FMC I2C

add_instance fmc_i2c altera_avalon_i2c
set_instance_parameter_value fmc_i2c {USE_AV_ST} {0}
set_instance_parameter_value fmc_i2c {FIFO_DEPTH} {128}

add_connection sys_clk.clk_reset fmc_i2c.reset_sink
add_connection sys_clk.clk fmc_i2c.clock
add_interface fmc_i2c conduit end
set_interface_property fmc_i2c EXPORT_OF fmc_i2c.i2c_serial


# fx3

# add_instance usb_fx3 axi_usb_fx3
# add_interface usb_fx3_if_gpif conduit end
# set_interface_property usb_fx3_if_gpif EXPORT_OF usb_fx3.if_gpif
# # add_interface usb_fx3_s_axis s_axis end
# # set_interface_property usb_fx3_s_axis EXPORT_OF usb_fx3.s_axis
# # add_interface usb_fx3_m_axis m_axis end
# # set_interface_property usb_fx3_m_axis EXPORT_OF usb_fx3.m_axis
# add_connection sys_clk.clk usb_fx3.s_axi_clock
# add_connection sys_clk.clk_reset usb_fx3.s_axi_reset

# add_instance axi_usb_fx3_tx_dma axi_dmac
# set_instance_parameter_value axi_usb_fx3_tx_dma {ID} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_DATA_WIDTH_SRC} {128}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_DATA_WIDTH_DEST} {32}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_LENGTH_WIDTH} {24}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_2D_TRANSFER} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {AXI_SLICE_DEST} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {AXI_SLICE_SRC} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {SYNC_TRANSFER_START} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {CYCLIC} {1}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_TYPE_DEST} {1}
# set_instance_parameter_value axi_usb_fx3_tx_dma {DMA_TYPE_SRC} {0}
# set_instance_parameter_value axi_usb_fx3_tx_dma {FIFO_SIZE} {16}
# set_instance_parameter_value axi_usb_fx3_tx_dma {HAS_AXIS_TLAST} {1}
# set_instance_parameter_value axi_usb_fx3_tx_dma {HAS_AXIS_TKEEP} {1}
# add_connection axi_usb_fx3_tx_dma.m_axis usb_fx3.s_axis
# add_connection sys_clk.clk axi_usb_fx3_tx_dma.if_m_axis_aclk
# add_connection sys_clk.clk axi_usb_fx3_tx_dma.s_axi_clock
# add_connection sys_clk.clk_reset axi_usb_fx3_tx_dma.s_axi_reset
# add_connection sys_dma_clk.clk axi_usb_fx3_tx_dma.m_src_axi_clock
# add_connection sys_dma_clk.clk_reset axi_usb_fx3_tx_dma.m_src_axi_reset

# add_instance axi_usb_fx3_rx_dma axi_dmac
# set_instance_parameter_value axi_usb_fx3_rx_dma {ID} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_DATA_WIDTH_SRC} {32}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_DATA_WIDTH_DEST} {128}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_LENGTH_WIDTH} {24}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_2D_TRANSFER} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {AXI_SLICE_DEST} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {AXI_SLICE_SRC} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {SYNC_TRANSFER_START} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {CYCLIC} {1}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_TYPE_DEST} {0}
# set_instance_parameter_value axi_usb_fx3_rx_dma {DMA_TYPE_SRC} {1}
# set_instance_parameter_value axi_usb_fx3_rx_dma {FIFO_SIZE} {16}
# set_instance_parameter_value axi_usb_fx3_rx_dma {HAS_AXIS_TLAST} {1}
# set_instance_parameter_value axi_usb_fx3_rx_dma {HAS_AXIS_TKEEP} {1}
# add_connection usb_fx3.m_axis axi_usb_fx3_rx_dma.s_axis
# add_connection sys_clk.clk axi_usb_fx3_rx_dma.if_s_axis_aclk
# add_connection sys_clk.clk axi_usb_fx3_rx_dma.s_axi_clock
# add_connection sys_clk.clk_reset axi_usb_fx3_rx_dma.s_axi_reset
# add_connection sys_dma_clk.clk axi_usb_fx3_rx_dma.m_dest_axi_clock
# add_connection sys_dma_clk.clk_reset axi_usb_fx3_rx_dma.m_dest_axi_reset

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

ad_cpu_interconnect 0x00000010 sys_gpio_bd.s1
ad_cpu_interconnect 0x00000000 sys_gpio_in.s1
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port
ad_cpu_interconnect 0x00000080 sys_i2c.csr
ad_cpu_interconnect 0x000000C0 fmc_i2c.csr
ad_cpu_interconnect 0x00018000 axi_sysid_0.s_axi
# ad_cpu_interconnect 0x00010000 usb_fx3.s_axi
# ad_cpu_interconnect 0x00070000 axi_usb_fx3_tx_dma.s_axi
# ad_cpu_interconnect 0x00080000 axi_usb_fx3_rx_dma.s_axi

#dma 
# ad_dma_interconnect axi_usb_fx3_tx_dma.m_src_axi
# ad_dma_interconnect axi_usb_fx3_rx_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 6 sys_gpio_bd.irq
ad_cpu_interrupt 7 sys_spi.irq
ad_cpu_interrupt 15 sys_i2c.interrupt_sender
ad_cpu_interrupt 16 fmc_i2c.interrupt_sender
# ad_cpu_interrupt 17 usb_fx3.interrupt_sender
# ad_cpu_interrupt 18 axi_usb_fx3_tx_dma.interrupt_sender
# ad_cpu_interrupt 19 axi_usb_fx3_rx_dma.interrupt_sender
