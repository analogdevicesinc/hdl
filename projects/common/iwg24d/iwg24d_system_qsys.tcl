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
set_instance_parameter_value sys_clk {resetSynchronousEdges} {NONE}

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
set_hps_io  IO_DEDICATED_12   NONE
set_hps_io  IO_DEDICATED_13   NONE
set_hps_io  IO_DEDICATED_14   NONE
set_hps_io  IO_DEDICATED_15   NONE
set_hps_io  IO_DEDICATED_16   NONE
set_hps_io  IO_DEDICATED_17   NONE
set_hps_io  IO_SHARED_Q1_01   NONE
set_hps_io  IO_SHARED_Q1_02   NONE
set_hps_io  IO_SHARED_Q1_03   UART0:TX
set_hps_io  IO_SHARED_Q1_04   UART0:RX
set_hps_io  IO_SHARED_Q1_05   UART1:CTS_N
set_hps_io  IO_SHARED_Q1_06   UART1:RTS_N
set_hps_io  IO_SHARED_Q1_07   UART1:TX
set_hps_io  IO_SHARED_Q1_08   UART1:RX
set_hps_io  IO_SHARED_Q1_09   MDIO1:MDIO
set_hps_io  IO_SHARED_Q1_10   MDIO1:MDC
set_hps_io  IO_SHARED_Q1_11   NONE
set_hps_io  IO_SHARED_Q1_12   NONE
set_hps_io  IO_SHARED_Q2_01   USB1:CLK
set_hps_io  IO_SHARED_Q2_02   USB1:STP
set_hps_io  IO_SHARED_Q2_03   USB1:DIR
set_hps_io  IO_SHARED_Q2_04   USB1:DATA0
set_hps_io  IO_SHARED_Q2_05   USB1:DATA1
set_hps_io  IO_SHARED_Q2_06   USB1:NXT
set_hps_io  IO_SHARED_Q2_07   USB1:DATA2
set_hps_io  IO_SHARED_Q2_08   USB1:DATA3
set_hps_io  IO_SHARED_Q2_09   USB1:DATA4
set_hps_io  IO_SHARED_Q2_10   USB1:DATA5
set_hps_io  IO_SHARED_Q2_11   USB1:DATA6
set_hps_io  IO_SHARED_Q2_12   USB1:DATA7
set_hps_io  IO_SHARED_Q3_01   EMAC1:TX_CLK
set_hps_io  IO_SHARED_Q3_02   EMAC1:TX_CTL
set_hps_io  IO_SHARED_Q3_03   EMAC1:RX_CLK
set_hps_io  IO_SHARED_Q3_04   EMAC1:RX_CTL
set_hps_io  IO_SHARED_Q3_05   EMAC1:TXD0
set_hps_io  IO_SHARED_Q3_06   EMAC1:TXD1
set_hps_io  IO_SHARED_Q3_07   EMAC1:RXD0
set_hps_io  IO_SHARED_Q3_08   EMAC1:RXD1
set_hps_io  IO_SHARED_Q3_09   EMAC1:TXD2
set_hps_io  IO_SHARED_Q3_10   EMAC1:TXD3
set_hps_io  IO_SHARED_Q3_11   EMAC1:RXD2
set_hps_io  IO_SHARED_Q3_12   EMAC1:RXD3
set_hps_io  IO_SHARED_Q4_01   I2C1:SDA
set_hps_io  IO_SHARED_Q4_02   I2C1:SCL
set_hps_io  IO_SHARED_Q4_03   NONE
set_hps_io  IO_SHARED_Q4_04   NONE
set_hps_io  IO_SHARED_Q4_05   NONE
set_hps_io  IO_SHARED_Q4_06   NONE
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
set_instance_parameter_value sys_hps {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value sys_hps {HPS_IO_Enable} $hps_io_list
set_instance_parameter_value sys_hps {SDMMC_PinMuxing} {IO}
set_instance_parameter_value sys_hps {SDMMC_Mode} {4-bit}
set_instance_parameter_value sys_hps {USB1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {USB1_Mode} {default}
set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {EMAC1_Mode} {RGMII_with_MDIO}
set_instance_parameter_value sys_hps {UART0_PinMuxing} {IO}
set_instance_parameter_value sys_hps {UART0_Mode} {No_flow_control}
set_instance_parameter_value sys_hps {UART1_PinMuxing} {IO}
set_instance_parameter_value sys_hps {UART1_Mode} {Flow_control}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {FPGA}
set_instance_parameter_value sys_hps {I2C1_Mode} {default}
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
add_interface sys_hps_2c1_scl_in clock sink
set_interface_property sys_hps_i2c1_scl_in EXPORT_OF sys_hps.i2c1_scl_in
add_interface sys_hps_i2c1_clk clock source
set_interface_property sys_hps_i2c1_clk EXPORT_OF sys_hps.i2c1_clk
add_interface sys_hps_i2c1 conduit end
set_interface_property sys_hps_i2c1 EXPORT_OF sys_hps.i2c1

# common dma interfaces

add_instance sys_dma_clk clock_source
add_connection sys_clk.clk_reset sys_dma_clk.clk_in_reset
add_connection sys_hps.h2f_user0_clock sys_dma_clk.clk_in
add_connection sys_dma_clk.clk sys_hps.f2sdram0_clock
add_connection sys_dma_clk.clk_reset sys_hps.f2sdram0_reset

# ddr4 interface

add_instance sys_hps_ddr4_cntrl altera_emif_a10_hps
set_instance_parameter_value sys_hps_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}
set_instance_parameter_value sys_hps_ddr4_cntrl {IS_ED_SLAVE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {INTERNAL_TESTING_MODE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_ADD_EXTRA_CLKS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_USER_NUM_OF_EXTRA_CLKS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8} {50.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PING_PONG_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1067.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {-1.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_REF_CLK_JITTER_PS} {10.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_RATE_ENUM} {RATE_HALF}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_CORE_CLKS_SHARING_ENUM} {CORE_CLKS_SHARING_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_IO_VOLTAGE} {1.2}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_STARTING_VREFIN} {70.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_HPS_ENABLE_EARLY_RELEASE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PERIODIC_OCT_RECAL_ENUM} {PERIODIC_OCT_RECAL_AUTO}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_60_CAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value sys_hps_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_FORMAT_ENUM} {MEM_FORMAT_DISCRETE}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DQ_WIDTH} {40}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DQ_PER_DQS} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_NUM_OF_DIMMS} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RANKS_PER_DIMM} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CKE_PER_DIMM} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CK_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_COL_ADDR_WIDTH} {10}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_ADDR_WIDTH} {2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CHIP_ID_WIDTH} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DM_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_PAR_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_AUTO}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_DQS_GROUP} {3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_LANE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_PIN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DISCRETE_MIRROR_ADDRESSING_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MIRROR_ADDRESSING_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RDIMM_CONFIG} {00000000000000000000000000000000000000}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_EXTENDED_CONFIG} {0000000000000000}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_LRDIMM_VREFDQ_VALUE} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_CRC} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_GEARDOWN} {DDR4_GEARDOWN_HR}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_PER_DRAM_ADDR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_SENSOR_READOUT} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_FINE_GRANULARITY_REFRESH} {DDR4_FINE_REFRESH_FIXED_1X}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MPR_READ_FORMAT} {DDR4_MPR_READ_FORMAT_SERIAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_MAX_POWERDOWN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_RANGE} {DDR4_TEMP_CONTROLLED_RFSH_NORMAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_ENA} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_INTERNAL_VREFDQ_MONITOR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_CAL_MODE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SELF_RFSH_ABORT} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE_TRAINING} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE} {2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_PREAMBLE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_AC_PARITY_LATENCY} {DDR4_AC_PARITY_LATENCY_DISABLE}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ODT_IN_POWERDOWN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_PARK} {DDR4_RTT_PARK_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_AC_PERSISTENT_ERROR} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WRITE_DBI} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_READ_DBI} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DEFAULT_VREFOUT} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_VALUE} {56.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_RANGE} {DDR4_VREFDQ_TRAINING_RANGE_1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BL_ENUM} {DDR4_BL_BL8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_BT_ENUM} {DDR4_BT_SEQUENTIAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ASR_ENUM} {DDR4_ASR_MANUAL_NORMAL}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DRV_STR_ENUM} {DDR4_DRV_STR_RZQ_7}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_DLL_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_6}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_RTT_WR_ENUM} {DDR4_RTT_WR_ODT_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_WTCL} {12}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_ATCL_ENUM} {DDR4_ATCL_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCL} {18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_USE_DEFAULT_ODT} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_1X1} {off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_1X1} {on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_2X2} {off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_2X2} {off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_2X2} {on off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_2X2} {off on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_4X2} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_4X2} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_4X2} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_4X2} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT0_4X4} {off off off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT1_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT2_4X4} {off off off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_R_ODT3_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT0_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT1_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT2_4X4} {off off on on}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_W_ODT3_4X4} {on on off off}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2400}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIS_PS} {62}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIS_AC_MV} {100}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIH_PS} {87}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TIH_DC_MV} {75}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDIVW_TOTAL_UI} {0.2}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_VDIVW_TOTAL} {130}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSQ_UI} {0.16}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQH_UI} {0.76}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDVWP_UI} {0.72}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSCK_PS} {165}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSS_CYC} {0.27}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQSH_CYC} {0.38}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDSH_CYC} {0.18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDSS_CYC} {0.18}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWLS_PS} {162.5}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWLH_PS} {162.5}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TINIT_US} {500}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TMRD_CK_CYC} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRAS_NS} {35.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRCD_NS} {15.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRP_NS} {15.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TREFI_US} {7.8}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRFC_NS} {260.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWR_NS} {15.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {3}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {6}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCCD_L_CYC} {6}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TCCD_S_CYC} {4}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDIVW_DJ_CYC} {0.1}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TDQSQ_PS} {66}
set_instance_parameter_value sys_hps_ddr4_cntrl {MEM_DDR4_TQH_CYC} {0.38}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USE_DEFAULT_SLEW_RATES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USE_DEFAULT_ISI_VALUES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_CK_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_AC_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RCLK_SLEW_RATE} {8.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WCLK_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RDATA_SLEW_RATE} {4.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WDATA_SLEW_RATE} {2.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_AC_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RCLK_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WCLK_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_RDATA_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_USER_WDATA_ISI_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_IS_SKEW_WITHIN_DQS_DESKEWED} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_PKG_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_IS_SKEW_WITHIN_AC_DESKEWED} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_PKG_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_DQS_TO_CK_SKEW_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_SKEW_BETWEEN_DIMMS_NS} {0.05}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_SKEW_BETWEEN_DQS_NS} {0.02}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_AC_TO_CK_SKEW_NS} {0.0}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_MAX_CK_DELAY_NS} {0.6}
set_instance_parameter_value sys_hps_ddr4_cntrl {BOARD_DDR4_MAX_DQS_DELAY_NS} {0.6}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AVL_PROTOCOL_ENUM} {CTRL_AVL_PROTOCOL_ST}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_SELF_REFRESH_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_POWER_DOWN_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_POWER_DOWN_CYCS} {32}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_USER_REFRESH_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_USER_PRIORITY_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_AUTO_PRECHARGE_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ADDR_ORDER_ENUM} {DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ECC_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_ECC_AUTO_CORRECTION_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_REORDER_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_STARVE_LIMIT} {10}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_MMR_EN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_WR_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_RD_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_RD_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {CTRL_DDR4_WR_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_SIM_REGTEST_MODE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_TIMING_REGTEST_MODE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_SYNTH_FOR_SIM} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_FAST_SIM_OVERRIDE} {FAST_SIM_OVERRIDE_DEFAULT}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_VERBOSE_IOAUX} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ECLIPSE_DEBUG} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXPORT_VJI} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_JTAG_UART} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_JTAG_UART_HEX} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_ENABLE_HPS_EMIF_DEBUG} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_SOFT_NIOS_MODE} {SOFT_NIOS_MODE_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_SOFT_NIOS_CLOCK_FREQUENCY} {100}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_USE_RS232_UART} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_RS232_UART_BAUDRATE} {57600}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EX_DESIGN_ADD_TEST_EMIFS} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EX_DESIGN_SEPARATE_RESETS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXPOSE_DFT_SIGNALS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_EXTRA_CONFIGS} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_USE_BOARD_DELAY_MODEL} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_BOARD_DELAY_CONFIG_STR} {}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_TG_AVL_2_NUM_CFG_INTERFACES} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {SHORT_QSYS_INTERFACE_NAMES} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SIM_CAL_MODE_ENUM} {SIM_CAL_MODE_SKIP}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE} {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EXPORT_SEQ_AVALON_MASTER} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_NUM_OF_SLAVES} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_SEPARATE_RZQS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EX_DESIGN_ISSP_EN} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_INTERFACE_ID} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_EFFICIENCY_MONITOR} {EFFMON_MODE_DISABLED}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_USE_TG_AVL_2} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_ABSTRACT_PHY} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_DEFAULT_PATTERN} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_USER_STAGE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_REPEAT_STAGE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_BYPASS_STRESS_STAGE} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_TG_DATA_PATTERN_LENGTH} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_TG_BE_PATTERN_LENGTH} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SEPARATE_READ_WRITE_ITFS} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_LEVEL} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_CA_DESKEW} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_SKIP_VREF_CAL} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ADDR0} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ADDR1} {8}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_ENABLE_NON_DES} {0}
set_instance_parameter_value sys_hps_ddr4_cntrl {DIAG_DDR4_CAL_FULL_CAL_ON_RESET} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_SEL_DESIGN} {AVAIL_EX_DESIGNS_GEN_DESIGN}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_GEN_SIM} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_GEN_SYNTH} {1}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_HDL_FORMAT} {HDL_FORMAT_VERILOG}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_TARGET_DEV_KIT} {TARGET_DEV_KIT_NONE}
set_instance_parameter_value sys_hps_ddr4_cntrl {EX_DESIGN_GUI_DDR4_PREV_PRESET} {TARGET_DEV_KIT_NONE}


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
set_instance_parameter_value sys_spi {targetClockRate} {128000.0}

add_connection sys_clk.clk_reset sys_spi.reset
add_connection sys_clk.clk sys_spi.clk
add_interface sys_spi conduit end
set_interface_property sys_spi EXPORT_OF sys_spi.external

# base-addresses

ad_cpu_interconnect 0x00000000 sys_gpio_in.s1
ad_cpu_interconnect 0x00000020 sys_gpio_out.s1
ad_cpu_interconnect 0x00000040 sys_spi.spi_control_port

# interrupts

ad_cpu_interrupt 5 sys_gpio_in.irq
ad_cpu_interrupt 7 sys_spi.irq

