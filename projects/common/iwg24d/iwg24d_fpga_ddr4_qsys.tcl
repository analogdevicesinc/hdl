
# fpga-ddr4 instance and configuration

add_instance fpga_ddr4_cntrl altera_emif
set_instance_parameter_value fpga_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_PING_PONG_EN} {false}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1067.0}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {true}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {266.75}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_REF_CLK_JITTER_PS} {10.0}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_RATE_ENUM} {RATE_QUARTER}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_CORE_CLKS_SHARING_ENUM} {CORE_CLKS_SHARING_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_IO_VOLTAGE} {1.2}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {true}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_HPS_ENABLE_EARLY_RELEASE} {false}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_PERIODIC_OCT_RECAL_ENUM} {PERIODIC_OCT_RECAL_AUTO}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_REF_CLK_FREQ_MHZ} {266.75}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_PING_PONG_EN} {false}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_AUTO_STARTING_VREFIN_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_STARTING_VREFIN} {70.0}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {unset}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_DATA_IN_MODE_ENUM} {IN_OCT_120_CAL}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_AUTO_STARTING_VREFIN_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_STARTING_VREFIN} {61.0}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value fpga_ddr4_cntrl {PHY_DDR4_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_FORMAT_ENUM} {MEM_FORMAT_DISCRETE}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DQ_WIDTH} {64}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DQ_PER_DQS} {8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_NUM_OF_DIMMS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RANKS_PER_DIMM} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CKE_PER_DIMM} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CK_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ROW_ADDR_WIDTH} {16}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_COL_ADDR_WIDTH} {10}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_BANK_ADDR_WIDTH} {2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CHIP_ID_WIDTH} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DM_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ALERT_PAR_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_AUTO}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ALERT_N_DQS_GROUP} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_LANE} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_PIN} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DISCRETE_MIRROR_ADDRESSING_EN} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MIRROR_ADDRESSING_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_HIDE_ADV_MR_SETTINGS} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_BL_ENUM} {DDR4_BL_BL8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_BT_ENUM} {DDR4_BT_SEQUENTIAL}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TCL} {12}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_7}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DLL_EN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ATCL_ENUM} {DDR4_ATCL_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DRV_STR_ENUM} {DDR4_DRV_STR_RZQ_7}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ASR_ENUM} {DDR4_ASR_MANUAL_NORMAL}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RTT_WR_ENUM} {DDR4_RTT_WR_ODT_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_WTCL} {12}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_WRITE_CRC} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_GEARDOWN} {DDR4_GEARDOWN_HR}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_PER_DRAM_ADDR} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TEMP_SENSOR_READOUT} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_FINE_GRANULARITY_REFRESH} {DDR4_FINE_REFRESH_FIXED_1X}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MPR_READ_FORMAT} {DDR4_MPR_READ_FORMAT_SERIAL}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MAX_POWERDOWN} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_RANGE} {DDR4_TEMP_CONTROLLED_RFSH_NORMAL}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TEMP_CONTROLLED_RFSH_ENA} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_INTERNAL_VREFDQ_MONITOR} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CAL_MODE} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SELF_RFSH_ABORT} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE_TRAINING} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_READ_PREAMBLE} {2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_WRITE_PREAMBLE} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_AC_PARITY_LATENCY} {DDR4_AC_PARITY_LATENCY_DISABLE}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ODT_IN_POWERDOWN} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RTT_PARK} {DDR4_RTT_PARK_ODT_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_AC_PERSISTENT_ERROR} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_WRITE_DBI} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_READ_DBI} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DEFAULT_VREFOUT} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_VALUE} {56.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_USER_VREFDQ_TRAINING_RANGE} {DDR4_VREFDQ_TRAINING_RANGE_1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_CA_IBT_ENUM} {DDR4_RCD_CA_IBT_100}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_CS_IBT_ENUM} {DDR4_RCD_CS_IBT_100}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_CKE_IBT_ENUM} {DDR4_RCD_CKE_IBT_100}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_ODT_IBT_ENUM} {DDR4_RCD_ODT_IBT_100}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DB_RTT_NOM_ENUM} {DDR4_DB_RTT_NOM_ODT_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DB_RTT_WR_ENUM} {DDR4_DB_RTT_WR_RZQ_3}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DB_RTT_PARK_ENUM} {DDR4_DB_RTT_PARK_ODT_DISABLED}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DB_DQ_DRV_ENUM} {DDR4_DB_DRV_STR_RZQ_7}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_137_RCD_CA_DRV} {101}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_138_RCD_CK_DRV} {5}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_140_DRAM_VREFDQ_R0} {29}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_141_DRAM_VREFDQ_R1} {29}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_142_DRAM_VREFDQ_R2} {29}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_143_DRAM_VREFDQ_R3} {29}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_144_DB_VREFDQ} {37}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_145_DB_MDQ_DRV} {21}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_148_DRAM_DRV} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_149_DRAM_RTT_WR_NOM} {20}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_152_DRAM_RTT_PARK} {39}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_133_RCD_DB_VENDOR_LSB} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_134_RCD_DB_VENDOR_MSB} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_135_RCD_REV} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPD_139_DB_REV} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_LRDIMM_ODT_LESS_BS} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_LRDIMM_ODT_LESS_BS_PARK_OHM} {240}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_DQS_WIDTH} {8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CS_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CS_PER_DIMM} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CKE_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ODT_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ADDR_WIDTH} {17}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RM_WIDTH} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_NUM_OF_PHYSICAL_RANKS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_NUM_OF_LOGICAL_RANKS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_VREFDQ_TRAINING_VALUE} {74.9}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_VREFDQ_TRAINING_RANGE} {DDR4_VREFDQ_TRAINING_RANGE_1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_VREFDQ_TRAINING_RANGE_DISP} {Range 2 - 45% to 77.5%}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_DQS_WIDTH} {8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_DQ_WIDTH} {64}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_CS_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_CK_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_CKE_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_ODT_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_BANK_ADDR_WIDTH} {2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_CHIP_ID_WIDTH} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_ADDR_WIDTH} {17}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_RM_WIDTH} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_NUM_OF_DIMMS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_NUM_OF_PHYSICAL_RANKS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TTL_NUM_OF_LOGICAL_RANKS} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR0} {2068}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR1} {67329}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR2} {131096}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR3} {197120}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR4} {264192}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR5} {328736}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_MR6} {393326}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RDIMM_CONFIG} {}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_LRDIMM_EXTENDED_CONFIG} {}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_ADDRESS_MIRROR_BITVEC} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_PARITY_CONTROL_WORD} {13}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_RCD_COMMAND_LATENCY} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_USE_DEFAULT_ODT} {true}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODTN_1X1} {{Rank 0}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT0_1X1} {off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODTN_1X1} {{Rank 0}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT0_1X1} {on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODTN_2X2} {{Rank 0} {Rank 1}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT0_2X2} {off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT1_2X2} {off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODTN_2X2} {{Rank 0} {Rank 1}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT0_2X2} {on off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT1_2X2} {off on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODTN_4X2} {{Rank 0} {Rank 1} {Rank 2} {Rank 3}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT0_4X2} {off off on on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT1_4X2} {on on off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODTN_4X2} {{Rank 0} {Rank 1} {Rank 2} {Rank 3}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT0_4X2} {off off on on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT1_4X2} {on on off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODTN_4X4} {{Rank 0} {Rank 1} {Rank 2} {Rank 3}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT0_4X4} {off off off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT1_4X4} {off off on on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT2_4X4} {off off off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_ODT3_4X4} {on on off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODTN_4X4} {{Rank 0} {Rank 1} {Rank 2} {Rank 3}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT0_4X4} {on on off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT1_4X4} {off off on on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT2_4X4} {off off on on}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_ODT3_4X4} {on on off off}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_DERIVED_ODTN} {{Rank 0} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_DERIVED_ODT0} {{(Drive) RZQ/7 (34 Ohm)} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_DERIVED_ODT1} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_DERIVED_ODT2} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_R_DERIVED_ODT3} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_DERIVED_ODTN} {{Rank 0} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_DERIVED_ODT0} {{(Nominal) RZQ/7 (34 Ohm)} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_DERIVED_ODT1} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_DERIVED_ODT2} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_W_DERIVED_ODT3} {{} {} {} {}}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SEQ_ODT_TABLE_LO} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SEQ_ODT_TABLE_HI} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CTRL_CFG_READ_ODT_CHIP} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CTRL_CFG_WRITE_ODT_CHIP} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CTRL_CFG_READ_ODT_RANK} {0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CTRL_CFG_WRITE_ODT_RANK} {1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2400}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TIS_PS} {62}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TIS_AC_MV} {100}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TIH_PS} {87}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TIH_DC_MV} {75}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDIVW_TOTAL_UI} {0.2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_VDIVW_TOTAL} {130}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSQ_UI} {0.17}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TQH_UI} {0.74}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDVWP_UI} {0.72}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSCK_PS} {175}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSS_CYC} {0.27}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TQSH_CYC} {0.4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDSH_CYC} {0.18}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDSS_CYC} {0.18}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWLS_PS} {108.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWLH_PS} {108.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TINIT_US} {500}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TMRD_CK_CYC} {8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRAS_NS} {32.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRCD_NS} {13.32}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRP_NS} {13.32}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TREFI_US} {7.8}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRFC_NS} {260.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWR_NS} {15.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TCCD_L_CYC} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TCCD_S_CYC} {4}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDIVW_DJ_CYC} {0.1}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSQ_PS} {66}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TQH_CYC} {0.38}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TINIT_CK} {533500}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSCK_DERV_PS} {2}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSCKDS} {450}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSCKDM} {900}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TDQSCKDL} {1200}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRAS_CYC} {35}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRCD_CYC} {15}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRP_CYC} {15}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRFC_CYC} {278}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TWR_CYC} {18}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TRTP_CYC} {9}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TFAW_CYC} {33}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_TREFI_CYC} {8323}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_WRITE_CMD_LATENCY} {5}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CFG_GEN_SBE} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_CFG_GEN_DBE} {false}
set_instance_parameter_value fpga_ddr4_cntrl {MEM_DDR4_LRDIMM_VREFDQ_VALUE} {1D}
set_instance_parameter_value fpga_ddr4_cntrl {CTRL_DDR4_ECC_EN} {0}

add_interface sys_ddr4_ref_clk clock sink
set_interface_property sys_ddr4_ref_clk EXPORT_OF fpga_ddr4_cntrl.pll_ref_clk_clock_sink
add_interface sys_ddr4_oct conduit end
set_interface_property sys_ddr4_oct EXPORT_OF fpga_ddr4_cntrl.oct_conduit_end
add_interface sys_ddr4_mem conduit end
set_interface_property sys_ddr4_mem EXPORT_OF fpga_ddr4_cntrl.mem_conduit_end
add_interface sys_ddr4_status conduit end
set_interface_property sys_ddr4_status EXPORT_OF fpga_ddr4_cntrl.status_conduit_end

add_instance $dac_fifo_name avl_dacfifo
set_instance_parameter_value $dac_fifo_name {DAC_DATA_WIDTH} $dac_data_width
set_instance_parameter_value $dac_fifo_name {DMA_DATA_WIDTH} $dac_dma_data_width
set_instance_parameter_value $dac_fifo_name {AVL_DATA_WIDTH} {512}
set_instance_parameter_value $dac_fifo_name {AVL_ADDRESS_WIDTH} {26}
set_instance_parameter_value $dac_fifo_name {AVL_BASE_ADDRESS} {0}
set_instance_parameter_value $dac_fifo_name {AVL_ADDRESS_LIMIT} {0x8fffffff}
set_instance_parameter_value $dac_fifo_name {DAC_MEM_ADDRESS_WIDTH} {12}
set_instance_parameter_value $dac_fifo_name {DMA_MEM_ADDRESS_WIDTH} {12}
set_instance_parameter_value $dac_fifo_name {AVL_BURST_LENGTH} {64}

add_connection sys_clk.clk_reset fpga_ddr4_cntrl.global_reset_reset_sink
add_connection fpga_ddr4_cntrl.emif_usr_reset_reset_source $dac_fifo_name.avl_reset
add_connection fpga_ddr4_cntrl.emif_usr_clk_clock_source $dac_fifo_name.avl_clock
add_connection $dac_fifo_name.amm_ddr fpga_ddr4_cntrl.ctrl_amm_avalon_slave_0
set_connection_parameter_value $dac_fifo_name.amm_ddr/fpga_ddr4_cntrl.ctrl_amm_avalon_slave_0 baseAddress {0x0}

