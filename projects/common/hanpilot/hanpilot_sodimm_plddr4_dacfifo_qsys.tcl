proc ad_dacfifo_create {dac_fifo_name dac_data_width dac_dma_data_width dac_fifo_address_width} {

  # pl-ddr4 settings

  add_instance sys_ddr4_cntrl altera_emif
  set_instance_parameter_value sys_ddr4_cntrl {PROTOCOL_ENUM} {PROTOCOL_DDR4}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1066.667}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {0}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {266.667}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_RATE_ENUM} {RATE_QUARTER}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_FORMAT_ENUM} {MEM_FORMAT_SODIMM}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_DQ_WIDTH} {72}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_DQ_PER_DQS} {8}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_ROW_ADDR_WIDTH} {15}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_COL_ADDR_WIDTH} {10}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_BANK_ADDR_WIDTH} {2}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_BANK_GROUP_WIDTH} {2}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_DM_EN} {1}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_DATA_LANES}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_LANE} {0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_ALERT_N_AC_PIN} {0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TCL} {20}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_WTCL} {16}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_4}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_IO_VOLTAGE} {1.2}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_DEFAULT_IO} {0}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_48_CAL}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS_NO_OCT}
  set_instance_parameter_value sys_ddr4_cntrl {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2400}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TDQSQ_UI} {0.16}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TDQSCK_PS} {175}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TWLS_PS} {108.0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TWLH_PS} {108.0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TINIT_US} {500}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TRAS_NS} {32.0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TRCD_NS} {14.16}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TRP_NS} {14.16}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TWR_NS} {15.0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TRRD_S_CYC} {4}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TRRD_L_CYC} {6}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TFAW_NS} {21.0}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TCCD_S_CYC} {4}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TCCD_L_CYC} {6}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TWTR_S_CYC} {3}
  set_instance_parameter_value sys_ddr4_cntrl {MEM_DDR4_TWTR_L_CYC} {9}
  set_instance_parameter_value sys_ddr4_cntrl {CTRL_DDR4_ECC_EN} {1}

  add_interface sys_ddr_ref_clk clock sink
  set_interface_property sys_ddr_ref_clk EXPORT_OF sys_ddr4_cntrl.pll_ref_clk_clock_sink
  add_interface sys_ddr_oct conduit end
  set_interface_property sys_ddr_oct EXPORT_OF sys_ddr4_cntrl.oct_conduit_end
  add_interface sys_ddr_mem conduit end
  set_interface_property sys_ddr_mem EXPORT_OF sys_ddr4_cntrl.mem_conduit_end
  add_interface sys_ddr_status conduit end
  set_interface_property sys_ddr_status EXPORT_OF sys_ddr4_cntrl.status_conduit_end

  add_instance $dac_fifo_name avl_dacfifo
  set_instance_parameter_value $dac_fifo_name {DAC_DATA_WIDTH} $dac_data_width
  set_instance_parameter_value $dac_fifo_name {DMA_DATA_WIDTH} $dac_dma_data_width
  set_instance_parameter_value $dac_fifo_name {AVL_DATA_WIDTH} {512}
  set_instance_parameter_value $dac_fifo_name {AVL_ADDRESS_WIDTH} {26}
  set_instance_parameter_value $dac_fifo_name {AVL_BASE_ADDRESS} {0}
  set_instance_parameter_value $dac_fifo_name {AVL_ADDRESS_LIMIT} {0x8fffffff}
  set_instance_parameter_value $dac_fifo_name {DAC_MEM_ADDRESS_WIDTH} {12}
  set_instance_parameter_value $dac_fifo_name {DMA_MEM_ADDRESS_WIDTH} {12}
  set_instance_parameter_value $dac_fifo_name {AVL_BURST_LENGTH} {72}

  add_connection sys_clk.clk_reset sys_ddr4_cntrl.global_reset_reset_sink
  add_connection sys_ddr4_cntrl.emif_usr_reset_reset_source $dac_fifo_name.avl_reset
  add_connection sys_ddr4_cntrl.emif_usr_clk_clock_source $dac_fifo_name.avl_clock
  add_connection $dac_fifo_name.amm_ddr sys_ddr4_cntrl.ctrl_amm_avalon_slave_0
  set_connection_parameter_value $dac_fifo_name.amm_ddr/sys_ddr4_cntrl.ctrl_amm_avalon_slave_0 baseAddress {0x0}

}
