#overwrite default settings

set_instance_parameter_value sys_spi {clockPhase} {1}
set_instance_parameter_value sys_spi {clockPolarity} {1}
set_instance_parameter_value sys_spi {targetClockRate} {5000000.0}


# Add adrv9371x

add_instance xcvr_ref_clk altera_clock_bridge 16.0
set_instance_parameter_value xcvr_ref_clk {EXPLICIT_CLOCK_RATE} {0.0}
set_instance_parameter_value xcvr_ref_clk {NUM_CLOCK_OUTPUTS} {1}

add_instance xcvr_pll altera_iopll 16.0
set_instance_parameter_value xcvr_pll {gui_device_speed_grade} {1}
set_instance_parameter_value xcvr_pll {gui_en_reconf} {1}
set_instance_parameter_value xcvr_pll {gui_en_dps_ports} {0}
set_instance_parameter_value xcvr_pll {gui_pll_mode} {Integer-N PLL}
set_instance_parameter_value xcvr_pll {gui_reference_clock_frequency} {122.88}
set_instance_parameter_value xcvr_pll {gui_fractional_cout} {32}
set_instance_parameter_value xcvr_pll {gui_dsm_out_sel} {1st_order}
set_instance_parameter_value xcvr_pll {gui_use_locked} {0}
set_instance_parameter_value xcvr_pll {gui_en_adv_params} {0}
set_instance_parameter_value xcvr_pll {gui_pll_bandwidth_preset} {Low}
set_instance_parameter_value xcvr_pll {gui_lock_setting} {Low Lock Time}
set_instance_parameter_value xcvr_pll {gui_pll_auto_reset} {0}
set_instance_parameter_value xcvr_pll {gui_en_lvds_ports} {Disabled}
set_instance_parameter_value xcvr_pll {gui_operation_mode} {direct}
set_instance_parameter_value xcvr_pll {gui_feedback_clock} {Global Clock}
set_instance_parameter_value xcvr_pll {gui_clock_to_compensate} {0}
set_instance_parameter_value xcvr_pll {gui_use_NDFB_modes} {0}
set_instance_parameter_value xcvr_pll {gui_refclk_switch} {0}
set_instance_parameter_value xcvr_pll {gui_refclk1_frequency} {100.0}
set_instance_parameter_value xcvr_pll {gui_en_phout_ports} {0}
set_instance_parameter_value xcvr_pll {gui_phout_division} {1}
set_instance_parameter_value xcvr_pll {gui_en_extclkout_ports} {0}
set_instance_parameter_value xcvr_pll {gui_number_of_clocks} {3}
set_instance_parameter_value xcvr_pll {gui_multiply_factor} {6}
set_instance_parameter_value xcvr_pll {gui_divide_factor_n} {1}
set_instance_parameter_value xcvr_pll {gui_frac_multiply_factor} {1.0}
set_instance_parameter_value xcvr_pll {gui_fix_vco_frequency} {0}
set_instance_parameter_value xcvr_pll {gui_fixed_vco_frequency} {600.0}
set_instance_parameter_value xcvr_pll {gui_vco_frequency} {600.0}
set_instance_parameter_value xcvr_pll {gui_enable_output_counter_cascading} {0}
set_instance_parameter_value xcvr_pll {gui_mif_gen_options} {Generate New MIF File}
set_instance_parameter_value xcvr_pll {gui_new_mif_file_path} {~/pll.mif}
set_instance_parameter_value xcvr_pll {gui_existing_mif_file_path} {~/pll.mif}
set_instance_parameter_value xcvr_pll {gui_mif_config_name} {unnamed}
set_instance_parameter_value xcvr_pll {gui_active_clk} {0}
set_instance_parameter_value xcvr_pll {gui_clk_bad} {0}
set_instance_parameter_value xcvr_pll {gui_switchover_mode} {Automatic Switchover}
set_instance_parameter_value xcvr_pll {gui_switchover_delay} {0}
set_instance_parameter_value xcvr_pll {gui_enable_cascade_out} {0}
set_instance_parameter_value xcvr_pll {gui_cascade_outclk_index} {0}
set_instance_parameter_value xcvr_pll {gui_enable_cascade_in} {0}
set_instance_parameter_value xcvr_pll {gui_pll_cascading_mode} {adjpllin}
set_instance_parameter_value xcvr_pll {gui_enable_mif_dps} {0}
set_instance_parameter_value xcvr_pll {gui_dps_cntr} {C0}
set_instance_parameter_value xcvr_pll {gui_dps_num} {1}
set_instance_parameter_value xcvr_pll {gui_dps_dir} {Positive}
set_instance_parameter_value xcvr_pll {gui_extclkout_0_source} {C0}
set_instance_parameter_value xcvr_pll {gui_extclkout_1_source} {C0}
set_instance_parameter_value xcvr_pll {gui_clock_name_global} {0}
set_instance_parameter_value xcvr_pll {gui_clock_name_string0} {tx_dac_clk}
set_instance_parameter_value xcvr_pll {gui_clock_name_string1} {rx_adc_clk}
set_instance_parameter_value xcvr_pll {gui_clock_name_string2} {rx_adc_os_clk}
set_instance_parameter_value xcvr_pll {gui_divide_factor_c0} {6}
set_instance_parameter_value xcvr_pll {gui_divide_factor_c1} {6}
set_instance_parameter_value xcvr_pll {gui_divide_factor_c2} {6}
set_instance_parameter_value xcvr_pll {gui_cascade_counter0} {0}
set_instance_parameter_value xcvr_pll {gui_cascade_counter1} {0}
set_instance_parameter_value xcvr_pll {gui_cascade_counter2} {0}
set_instance_parameter_value xcvr_pll {gui_output_clock_frequency0} {122.88}
set_instance_parameter_value xcvr_pll {gui_output_clock_frequency1} {122.88}
set_instance_parameter_value xcvr_pll {gui_output_clock_frequency2} {122.88}
set_instance_parameter_value xcvr_pll {gui_actual_output_clock_frequency0} {100.0}
set_instance_parameter_value xcvr_pll {gui_actual_output_clock_frequency1} {100.0}
set_instance_parameter_value xcvr_pll {gui_actual_output_clock_frequency2} {100.0}
set_instance_parameter_value xcvr_pll {gui_ps_units0} {ps}
set_instance_parameter_value xcvr_pll {gui_ps_units1} {ps}
set_instance_parameter_value xcvr_pll {gui_ps_units2} {ps}
set_instance_parameter_value xcvr_pll {gui_phase_shift0} {0.0}
set_instance_parameter_value xcvr_pll {gui_phase_shift1} {0.0}
set_instance_parameter_value xcvr_pll {gui_phase_shift2} {0.0}
set_instance_parameter_value xcvr_pll {gui_phase_shift_deg0} {0.0}
set_instance_parameter_value xcvr_pll {gui_phase_shift_deg1} {0.0}
set_instance_parameter_value xcvr_pll {gui_phase_shift_deg2} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift0} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift1} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift2} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift_deg0} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift_deg1} {0.0}
set_instance_parameter_value xcvr_pll {gui_actual_phase_shift_deg2} {0.0}
set_instance_parameter_value xcvr_pll {gui_duty_cycle0} {50.0}
set_instance_parameter_value xcvr_pll {gui_duty_cycle1} {50.0}
set_instance_parameter_value xcvr_pll {gui_duty_cycle2} {50.0}
set_instance_parameter_value xcvr_pll {gui_actual_duty_cycle0} {50.0}
set_instance_parameter_value xcvr_pll {gui_actual_duty_cycle1} {50.0}
set_instance_parameter_value xcvr_pll {gui_actual_duty_cycle2} {50.0}

add_instance xcvr_pll_reconfig altera_pll_reconfig 16.0
set_instance_parameter_value xcvr_pll_reconfig {ENABLE_MIF} {0}
set_instance_parameter_value xcvr_pll_reconfig {MIF_FILE_NAME} {}
set_instance_parameter_value xcvr_pll_reconfig {ENABLE_BYTEENABLE} {0}

add_instance xcvr_tx_rst_cntrl altera_xcvr_reset_control 16.0
set_instance_parameter_value xcvr_tx_rst_cntrl {CHANNELS} {4}
set_instance_parameter_value xcvr_tx_rst_cntrl {PLLS} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {SYS_CLK_IN_MHZ} {100}
set_instance_parameter_value xcvr_tx_rst_cntrl {SYNCHRONIZE_RESET} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {REDUCED_SIM_TIME} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {gui_split_interfaces} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {TX_PLL_ENABLE} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_PLL_POWERDOWN} {1000}
set_instance_parameter_value xcvr_tx_rst_cntrl {SYNCHRONIZE_PLL_RESET} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {TX_ENABLE} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {TX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {gui_tx_auto_reset} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_TX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_TX_DIGITALRESET} {70000}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_PLL_LOCK_HYST} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {gui_pll_cal_busy} {1}
set_instance_parameter_value xcvr_tx_rst_cntrl {RX_ENABLE} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {RX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {gui_rx_auto_reset} {0}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_RX_ANALOGRESET} {40}
set_instance_parameter_value xcvr_tx_rst_cntrl {T_RX_DIGITALRESET} {4000}

add_instance xcvr_tx_lane_pll altera_xcvr_atx_pll_a10 16.0
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_debug} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_pll_reconfig} {1}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_jtag_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_separate_avmm_busy} {1}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_enable_avmm_busy_port} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_capability_reg_enable} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_user_identifier} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_csr_soft_logic_enable} {1}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_file_prefix} {altera_xcvr_atx_pll_a10}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_sv_file_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_h_file_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_txt_file_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_mif_file_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_multi_enable} {0}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_profile_cnt} {2}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_profile_select} {1}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_param_vals1} {}
set_instance_parameter_value xcvr_tx_lane_pll {rcfg_param_vals2} {}
set_instance_parameter_value xcvr_tx_lane_pll {enable_manual_configuration} {1}
set_instance_parameter_value xcvr_tx_lane_pll {generate_docs} {1}
set_instance_parameter_value xcvr_tx_lane_pll {generate_add_hdl_instance_example} {0}
set_instance_parameter_value xcvr_tx_lane_pll {test_mode} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_pld_atx_cal_busy_port} {1}
set_instance_parameter_value xcvr_tx_lane_pll {enable_debug_ports_parameters} {0}
set_instance_parameter_value xcvr_tx_lane_pll {support_mode} {user_mode}
set_instance_parameter_value xcvr_tx_lane_pll {message_level} {error}
set_instance_parameter_value xcvr_tx_lane_pll {prot_mode} {Basic}
set_instance_parameter_value xcvr_tx_lane_pll {bw_sel} {medium}
set_instance_parameter_value xcvr_tx_lane_pll {refclk_cnt} {1}
set_instance_parameter_value xcvr_tx_lane_pll {refclk_index} {0}
set_instance_parameter_value xcvr_tx_lane_pll {silicon_rev} {0}
set_instance_parameter_value xcvr_tx_lane_pll {primary_pll_buffer} {GX clock output buffer}
set_instance_parameter_value xcvr_tx_lane_pll {enable_8G_path} {1}
set_instance_parameter_value xcvr_tx_lane_pll {enable_16G_path} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_pcie_clk} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_cascade_out} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_atx_to_fpll_cascade_out} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_hip_cal_done_port} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_hip_cal_en} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_output_clock_frequency} {2457.6}
set_instance_parameter_value xcvr_tx_lane_pll {enable_fractional} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_auto_reference_clock_frequency} {122.88}
set_instance_parameter_value xcvr_tx_lane_pll {set_manual_reference_clock_frequency} {200.0}
set_instance_parameter_value xcvr_tx_lane_pll {set_fref_clock_frequency} {156.25}
set_instance_parameter_value xcvr_tx_lane_pll {select_manual_config} {0}
set_instance_parameter_value xcvr_tx_lane_pll {set_m_counter} {24}
set_instance_parameter_value xcvr_tx_lane_pll {set_ref_clk_div} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_l_counter} {16}
set_instance_parameter_value xcvr_tx_lane_pll {set_l_cascade_counter} {15}
set_instance_parameter_value xcvr_tx_lane_pll {set_l_cascade_predivider} {1}
set_instance_parameter_value xcvr_tx_lane_pll {set_k_counter} {2000000000.0}
set_instance_parameter_value xcvr_tx_lane_pll {set_altera_xcvr_atx_pll_a10_calibration_en} {1}
set_instance_parameter_value xcvr_tx_lane_pll {enable_analog_resets} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_mcgb} {0}
set_instance_parameter_value xcvr_tx_lane_pll {mcgb_div} {1}
set_instance_parameter_value xcvr_tx_lane_pll {enable_hfreq_clk} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_mcgb_pcie_clksw} {0}
set_instance_parameter_value xcvr_tx_lane_pll {mcgb_aux_clkin_cnt} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_bonding_clks} {0}
set_instance_parameter_value xcvr_tx_lane_pll {enable_fb_comp_bonding} {0}
set_instance_parameter_value xcvr_tx_lane_pll {pma_width} {64}
set_instance_parameter_value xcvr_tx_lane_pll {enable_pld_mcgb_cal_busy_port} {0}

add_instance xcvr_tx_core altera_jesd204 16.0
set_instance_parameter_value xcvr_tx_core {wrapper_opt} {base_phy}
set_instance_parameter_value xcvr_tx_core {sdc_constraint} {1.0}
set_instance_parameter_value xcvr_tx_core {DATA_PATH} {TX}
set_instance_parameter_value xcvr_tx_core {SUBCLASSV} {1}
set_instance_parameter_value xcvr_tx_core {lane_rate} {4915.2}
set_instance_parameter_value xcvr_tx_core {PCS_CONFIG} {JESD_PCS_CFG1}
set_instance_parameter_value xcvr_tx_core {pll_type} {CMU}
set_instance_parameter_value xcvr_tx_core {bonded_mode} {non_bonded}
set_instance_parameter_value xcvr_tx_core {REFCLK_FREQ} {125.0}
set_instance_parameter_value xcvr_tx_core {bitrev_en} {0}
set_instance_parameter_value xcvr_tx_core {pll_reconfig_enable} {1}
set_instance_parameter_value xcvr_tx_core {rcfg_jtag_enable} {0}
set_instance_parameter_value xcvr_tx_core {set_capability_reg_enable} {1}
set_instance_parameter_value xcvr_tx_core {set_user_identifier} {0}
set_instance_parameter_value xcvr_tx_core {set_csr_soft_logic_enable} {1}
set_instance_parameter_value xcvr_tx_core {set_prbs_soft_logic_enable} {0}
set_instance_parameter_value xcvr_tx_core {L} {4}
set_instance_parameter_value xcvr_tx_core {M} {4}
set_instance_parameter_value xcvr_tx_core {GUI_EN_CFG_F} {0}
set_instance_parameter_value xcvr_tx_core {GUI_CFG_F} {4}
set_instance_parameter_value xcvr_tx_core {N} {16}
set_instance_parameter_value xcvr_tx_core {N_PRIME} {16}
set_instance_parameter_value xcvr_tx_core {S} {1}
set_instance_parameter_value xcvr_tx_core {K} {32}
set_instance_parameter_value xcvr_tx_core {SCR} {1}
set_instance_parameter_value xcvr_tx_core {CS} {0}
set_instance_parameter_value xcvr_tx_core {CF} {0}
set_instance_parameter_value xcvr_tx_core {HD} {0}
set_instance_parameter_value xcvr_tx_core {ECC_EN} {0}
set_instance_parameter_value xcvr_tx_core {DLB_TEST} {0}
set_instance_parameter_value xcvr_tx_core {PHADJ} {0}
set_instance_parameter_value xcvr_tx_core {ADJCNT} {0}
set_instance_parameter_value xcvr_tx_core {ADJDIR} {0}
set_instance_parameter_value xcvr_tx_core {OPTIMIZE} {0}
set_instance_parameter_value xcvr_tx_core {DID} {0}
set_instance_parameter_value xcvr_tx_core {BID} {0}
set_instance_parameter_value xcvr_tx_core {LID0} {0}
set_instance_parameter_value xcvr_tx_core {LID1} {1}
set_instance_parameter_value xcvr_tx_core {LID2} {2}
set_instance_parameter_value xcvr_tx_core {LID3} {3}
set_instance_parameter_value xcvr_tx_core {LID4} {4}
set_instance_parameter_value xcvr_tx_core {LID5} {5}
set_instance_parameter_value xcvr_tx_core {LID6} {6}
set_instance_parameter_value xcvr_tx_core {LID7} {7}
set_instance_parameter_value xcvr_tx_core {JESDV} {1}
set_instance_parameter_value xcvr_tx_core {RES1} {0}
set_instance_parameter_value xcvr_tx_core {RES2} {0}
set_instance_parameter_value xcvr_tx_core {TEST_COMPONENTS_EN} {0}
set_instance_parameter_value xcvr_tx_core {TERMINATE_RECONFIG_EN} {0}
set_instance_parameter_value xcvr_tx_core {ED_GENERIC_5SERIES} {No}
set_instance_parameter_value xcvr_tx_core {ED_GENERIC_A10} {No}
set_instance_parameter_value xcvr_tx_core {ED_FILESET_SIM} {0}
set_instance_parameter_value xcvr_tx_core {ED_FILESET_SYNTH} {0}
set_instance_parameter_value xcvr_tx_core {ED_HDL_FORMAT_SIM} {VERILOG}
set_instance_parameter_value xcvr_tx_core {ED_HDL_FORMAT_SYNTH} {VERILOG}
set_instance_parameter_value xcvr_tx_core {ED_DEV_KIT} {NONE}

add_instance axi_jesd_xcvr axi_jesd_xcvr 1.0
set_instance_parameter_value axi_jesd_xcvr {ID} {0}
set_instance_parameter_value axi_jesd_xcvr {DEVICE_TYPE} {0}
set_instance_parameter_value axi_jesd_xcvr {TX_NUM_OF_LANES} {4}
set_instance_parameter_value axi_jesd_xcvr {RX_NUM_OF_LANES} {2}

add_instance xcvr_rx_rst_cntrl altera_xcvr_reset_control 16.0
set_instance_parameter_value xcvr_rx_rst_cntrl {CHANNELS} {2}
set_instance_parameter_value xcvr_rx_rst_cntrl {PLLS} {1}
set_instance_parameter_value xcvr_rx_rst_cntrl {SYS_CLK_IN_MHZ} {100}
set_instance_parameter_value xcvr_rx_rst_cntrl {SYNCHRONIZE_RESET} {1}
set_instance_parameter_value xcvr_rx_rst_cntrl {REDUCED_SIM_TIME} {1}
set_instance_parameter_value xcvr_rx_rst_cntrl {gui_split_interfaces} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {TX_PLL_ENABLE} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_PLL_POWERDOWN} {1000}
set_instance_parameter_value xcvr_rx_rst_cntrl {SYNCHRONIZE_PLL_RESET} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {TX_ENABLE} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {TX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {gui_tx_auto_reset} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_TX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_TX_DIGITALRESET} {70000}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_PLL_LOCK_HYST} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {gui_pll_cal_busy} {1}
set_instance_parameter_value xcvr_rx_rst_cntrl {RX_ENABLE} {1}
set_instance_parameter_value xcvr_rx_rst_cntrl {RX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {gui_rx_auto_reset} {0}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_RX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rx_rst_cntrl {T_RX_DIGITALRESET} {4000}

add_instance xcvr_rx_core altera_jesd204 16.0
set_instance_parameter_value xcvr_rx_core {wrapper_opt} {base_phy}
set_instance_parameter_value xcvr_rx_core {sdc_constraint} {1.0}
set_instance_parameter_value xcvr_rx_core {DATA_PATH} {RX}
set_instance_parameter_value xcvr_rx_core {SUBCLASSV} {1}
set_instance_parameter_value xcvr_rx_core {lane_rate} {4915.2}
set_instance_parameter_value xcvr_rx_core {PCS_CONFIG} {JESD_PCS_CFG1}
set_instance_parameter_value xcvr_rx_core {pll_type} {CMU}
set_instance_parameter_value xcvr_rx_core {bonded_mode} {non_bonded}
set_instance_parameter_value xcvr_rx_core {REFCLK_FREQ} {122.88}
set_instance_parameter_value xcvr_rx_core {bitrev_en} {0}
set_instance_parameter_value xcvr_rx_core {pll_reconfig_enable} {0}
set_instance_parameter_value xcvr_rx_core {rcfg_jtag_enable} {0}
set_instance_parameter_value xcvr_rx_core {set_capability_reg_enable} {0}
set_instance_parameter_value xcvr_rx_core {set_user_identifier} {0}
set_instance_parameter_value xcvr_rx_core {set_csr_soft_logic_enable} {0}
set_instance_parameter_value xcvr_rx_core {set_prbs_soft_logic_enable} {0}
set_instance_parameter_value xcvr_rx_core {L} {2}
set_instance_parameter_value xcvr_rx_core {M} {4}
set_instance_parameter_value xcvr_rx_core {GUI_EN_CFG_F} {0}
set_instance_parameter_value xcvr_rx_core {GUI_CFG_F} {4}
set_instance_parameter_value xcvr_rx_core {N} {16}
set_instance_parameter_value xcvr_rx_core {N_PRIME} {16}
set_instance_parameter_value xcvr_rx_core {S} {1}
set_instance_parameter_value xcvr_rx_core {K} {32}
set_instance_parameter_value xcvr_rx_core {SCR} {1}
set_instance_parameter_value xcvr_rx_core {CS} {0}
set_instance_parameter_value xcvr_rx_core {CF} {0}
set_instance_parameter_value xcvr_rx_core {HD} {0}
set_instance_parameter_value xcvr_rx_core {ECC_EN} {0}
set_instance_parameter_value xcvr_rx_core {DLB_TEST} {0}
set_instance_parameter_value xcvr_rx_core {PHADJ} {0}
set_instance_parameter_value xcvr_rx_core {ADJCNT} {0}
set_instance_parameter_value xcvr_rx_core {ADJDIR} {0}
set_instance_parameter_value xcvr_rx_core {OPTIMIZE} {0}
set_instance_parameter_value xcvr_rx_core {DID} {0}
set_instance_parameter_value xcvr_rx_core {BID} {0}
set_instance_parameter_value xcvr_rx_core {LID0} {0}
set_instance_parameter_value xcvr_rx_core {LID1} {1}
set_instance_parameter_value xcvr_rx_core {LID2} {2}
set_instance_parameter_value xcvr_rx_core {LID3} {3}
set_instance_parameter_value xcvr_rx_core {LID4} {4}
set_instance_parameter_value xcvr_rx_core {LID5} {5}
set_instance_parameter_value xcvr_rx_core {LID6} {6}
set_instance_parameter_value xcvr_rx_core {LID7} {7}
set_instance_parameter_value xcvr_rx_core {JESDV} {1}
set_instance_parameter_value xcvr_rx_core {RES1} {0}
set_instance_parameter_value xcvr_rx_core {RES2} {0}
set_instance_parameter_value xcvr_rx_core {TEST_COMPONENTS_EN} {0}
set_instance_parameter_value xcvr_rx_core {TERMINATE_RECONFIG_EN} {0}
set_instance_parameter_value xcvr_rx_core {ED_GENERIC_5SERIES} {No}
set_instance_parameter_value xcvr_rx_core {ED_GENERIC_A10} {No}
set_instance_parameter_value xcvr_rx_core {ED_FILESET_SIM} {0}
set_instance_parameter_value xcvr_rx_core {ED_FILESET_SYNTH} {0}
set_instance_parameter_value xcvr_rx_core {ED_HDL_FORMAT_SIM} {VERILOG}
set_instance_parameter_value xcvr_rx_core {ED_HDL_FORMAT_SYNTH} {VERILOG}
set_instance_parameter_value xcvr_rx_core {ED_DEV_KIT} {NONE}

add_instance axi_os_jesd_xcvr axi_jesd_xcvr 1.0
set_instance_parameter_value axi_os_jesd_xcvr {ID} {1}
set_instance_parameter_value axi_os_jesd_xcvr {DEVICE_TYPE} {0}
set_instance_parameter_value axi_os_jesd_xcvr {TX_NUM_OF_LANES} {0}
set_instance_parameter_value axi_os_jesd_xcvr {RX_NUM_OF_LANES} {2}

add_instance xcvr_rx_os_rst_cntrl altera_xcvr_reset_control 16.0
set_instance_parameter_value xcvr_rx_os_rst_cntrl {CHANNELS} {2}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {PLLS} {1}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {SYS_CLK_IN_MHZ} {100}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {SYNCHRONIZE_RESET} {1}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {REDUCED_SIM_TIME} {1}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {gui_split_interfaces} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {TX_PLL_ENABLE} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_PLL_POWERDOWN} {1000}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {SYNCHRONIZE_PLL_RESET} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {TX_ENABLE} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {TX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {gui_tx_auto_reset} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_TX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_TX_DIGITALRESET} {70000}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_PLL_LOCK_HYST} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {gui_pll_cal_busy} {1}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {RX_ENABLE} {1}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {RX_PER_CHANNEL} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {gui_rx_auto_reset} {0}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_RX_ANALOGRESET} {70000}
set_instance_parameter_value xcvr_rx_os_rst_cntrl {T_RX_DIGITALRESET} {4000}

add_instance xcvr_rx_os_core altera_jesd204 16.0
set_instance_parameter_value xcvr_rx_os_core {wrapper_opt} {base_phy}
set_instance_parameter_value xcvr_rx_os_core {sdc_constraint} {1.0}
set_instance_parameter_value xcvr_rx_os_core {DATA_PATH} {RX}
set_instance_parameter_value xcvr_rx_os_core {SUBCLASSV} {1}
set_instance_parameter_value xcvr_rx_os_core {lane_rate} {4915.2}
set_instance_parameter_value xcvr_rx_os_core {PCS_CONFIG} {JESD_PCS_CFG1}
set_instance_parameter_value xcvr_rx_os_core {pll_type} {CMU}
set_instance_parameter_value xcvr_rx_os_core {bonded_mode} {non_bonded}
set_instance_parameter_value xcvr_rx_os_core {REFCLK_FREQ} {122.88}
set_instance_parameter_value xcvr_rx_os_core {bitrev_en} {0}
set_instance_parameter_value xcvr_rx_os_core {pll_reconfig_enable} {0}
set_instance_parameter_value xcvr_rx_os_core {rcfg_jtag_enable} {0}
set_instance_parameter_value xcvr_rx_os_core {set_capability_reg_enable} {0}
set_instance_parameter_value xcvr_rx_os_core {set_user_identifier} {0}
set_instance_parameter_value xcvr_rx_os_core {set_csr_soft_logic_enable} {0}
set_instance_parameter_value xcvr_rx_os_core {set_prbs_soft_logic_enable} {0}
set_instance_parameter_value xcvr_rx_os_core {L} {2}
set_instance_parameter_value xcvr_rx_os_core {M} {2}
set_instance_parameter_value xcvr_rx_os_core {GUI_EN_CFG_F} {0}
set_instance_parameter_value xcvr_rx_os_core {GUI_CFG_F} {4}
set_instance_parameter_value xcvr_rx_os_core {N} {16}
set_instance_parameter_value xcvr_rx_os_core {N_PRIME} {16}
set_instance_parameter_value xcvr_rx_os_core {S} {1}
set_instance_parameter_value xcvr_rx_os_core {K} {16}
set_instance_parameter_value xcvr_rx_os_core {SCR} {1}
set_instance_parameter_value xcvr_rx_os_core {CS} {0}
set_instance_parameter_value xcvr_rx_os_core {CF} {0}
set_instance_parameter_value xcvr_rx_os_core {HD} {0}
set_instance_parameter_value xcvr_rx_os_core {ECC_EN} {0}
set_instance_parameter_value xcvr_rx_os_core {DLB_TEST} {0}
set_instance_parameter_value xcvr_rx_os_core {PHADJ} {0}
set_instance_parameter_value xcvr_rx_os_core {ADJCNT} {0}
set_instance_parameter_value xcvr_rx_os_core {ADJDIR} {0}
set_instance_parameter_value xcvr_rx_os_core {OPTIMIZE} {0}
set_instance_parameter_value xcvr_rx_os_core {DID} {0}
set_instance_parameter_value xcvr_rx_os_core {BID} {0}
set_instance_parameter_value xcvr_rx_os_core {LID0} {0}
set_instance_parameter_value xcvr_rx_os_core {LID1} {1}
set_instance_parameter_value xcvr_rx_os_core {LID2} {2}
set_instance_parameter_value xcvr_rx_os_core {LID3} {3}
set_instance_parameter_value xcvr_rx_os_core {LID4} {4}
set_instance_parameter_value xcvr_rx_os_core {LID5} {5}
set_instance_parameter_value xcvr_rx_os_core {LID6} {6}
set_instance_parameter_value xcvr_rx_os_core {LID7} {7}
set_instance_parameter_value xcvr_rx_os_core {JESDV} {1}
set_instance_parameter_value xcvr_rx_os_core {RES1} {0}
set_instance_parameter_value xcvr_rx_os_core {RES2} {0}
set_instance_parameter_value xcvr_rx_os_core {TEST_COMPONENTS_EN} {0}
set_instance_parameter_value xcvr_rx_os_core {TERMINATE_RECONFIG_EN} {0}
set_instance_parameter_value xcvr_rx_os_core {ED_GENERIC_5SERIES} {No}
set_instance_parameter_value xcvr_rx_os_core {ED_GENERIC_A10} {No}
set_instance_parameter_value xcvr_rx_os_core {ED_FILESET_SIM} {0}
set_instance_parameter_value xcvr_rx_os_core {ED_FILESET_SYNTH} {0}
set_instance_parameter_value xcvr_rx_os_core {ED_HDL_FORMAT_SIM} {VERILOG}
set_instance_parameter_value xcvr_rx_os_core {ED_HDL_FORMAT_SYNTH} {VERILOG}
set_instance_parameter_value xcvr_rx_os_core {ED_DEV_KIT} {NONE}

add_instance axi_ad9371 axi_ad9371 1.0
set_instance_parameter_value axi_ad9371 {ID} {0}
set_instance_parameter_value axi_ad9371 {DAC_DATAPATH_DISABLE} {0}
set_instance_parameter_value axi_ad9371 {ADC_DATAPATH_DISABLE} {0}

add_instance adc_pack util_cpack 1.0
set_instance_parameter_value adc_pack {CHANNEL_DATA_WIDTH} {16}
set_instance_parameter_value adc_pack {NUM_OF_CHANNELS} {4}

add_instance dac_upack util_upack 1.0
set_instance_parameter_value dac_upack {CHANNEL_DATA_WIDTH} {32}
set_instance_parameter_value dac_upack {NUM_OF_CHANNELS} {4}

add_instance adc_os_pack util_cpack 1.0
set_instance_parameter_value adc_os_pack {CHANNEL_DATA_WIDTH} {32}
set_instance_parameter_value adc_os_pack {NUM_OF_CHANNELS} {2}

add_instance axi_adc_dma axi_dmac 1.0
set_instance_parameter_value axi_adc_dma {ID} {0}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_adc_dma {DMA_DATA_WIDTH_DEST} {256}
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
set_instance_parameter_value axi_adc_dma {FIFO_SIZE} {16}

add_instance axi_os_adc_dma axi_dmac 1.0
set_instance_parameter_value axi_os_adc_dma {ID} {0}
set_instance_parameter_value axi_os_adc_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_os_adc_dma {DMA_DATA_WIDTH_DEST} {256}
set_instance_parameter_value axi_os_adc_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_os_adc_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_os_adc_dma {ASYNC_CLK_REQ_SRC} {1}
set_instance_parameter_value axi_os_adc_dma {ASYNC_CLK_SRC_DEST} {1}
set_instance_parameter_value axi_os_adc_dma {ASYNC_CLK_DEST_REQ} {1}
set_instance_parameter_value axi_os_adc_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_os_adc_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_os_adc_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_os_adc_dma {CYCLIC} {0}
set_instance_parameter_value axi_os_adc_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_os_adc_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_os_adc_dma {FIFO_SIZE} {16}

add_instance axi_dac_dma axi_dmac 1.0
set_instance_parameter_value axi_dac_dma {ID} {0}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_SRC} {256}
set_instance_parameter_value axi_dac_dma {DMA_DATA_WIDTH_DEST} {128}
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
set_instance_parameter_value axi_dac_dma {FIFO_SIZE} {16}

add_instance ad9371_gpio altera_avalon_pio 16.0
set_instance_parameter_value ad9371_gpio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value ad9371_gpio {bitModifyingOutReg} {1}
set_instance_parameter_value ad9371_gpio {captureEdge} {0}
set_instance_parameter_value ad9371_gpio {direction} {Bidir}
set_instance_parameter_value ad9371_gpio {edgeType} {RISING}
set_instance_parameter_value ad9371_gpio {generateIRQ} {0}
set_instance_parameter_value ad9371_gpio {irqType} {LEVEL}
set_instance_parameter_value ad9371_gpio {resetValue} {0.0}
set_instance_parameter_value ad9371_gpio {simDoTestBenchWiring} {0}
set_instance_parameter_value ad9371_gpio {simDrivenValue} {0.0}
set_instance_parameter_value ad9371_gpio {width} {19}

# connections

add_connection axi_jesd_xcvr.if_tx_ip_avl xcvr_tx_core.jesd204_tx_link

add_connection xcvr_rx_core.jesd204_rx_link axi_jesd_xcvr.if_rx_ip_avl

add_connection xcvr_rx_os_core.jesd204_rx_link axi_os_jesd_xcvr.if_rx_ip_avl

add_connection sys_clk.clk xcvr_tx_rst_cntrl.clock
add_connection sys_clk.clk xcvr_rx_rst_cntrl.clock
add_connection sys_clk.clk xcvr_rx_os_rst_cntrl.clock
add_connection sys_clk.clk xcvr_rx_core.jesd204_rx_avs_clk
add_connection sys_clk.clk xcvr_rx_os_core.jesd204_rx_avs_clk
add_connection sys_clk.clk xcvr_tx_core.jesd204_tx_avs_clk
add_connection sys_ddr3_cntrl.emif_usr_clk axi_adc_dma.m_dest_axi_clock
add_connection sys_ddr3_cntrl.emif_usr_clk axi_os_adc_dma.m_dest_axi_clock
add_connection sys_clk.clk axi_dac_dma.m_src_axi_clock
add_connection sys_clk.clk xcvr_pll_reconfig.mgmt_clk
#add_connection sys_clk.clk xcvr_rx_core.reconfig_clk
#add_connection sys_clk.clk xcvr_rx_os_core.reconfig_clk
add_connection sys_clk.clk xcvr_tx_core.reconfig_clk
add_connection sys_clk.clk xcvr_tx_lane_pll.reconfig_clk0
add_connection sys_clk.clk axi_adc_dma.s_axi_clock
add_connection sys_clk.clk axi_dac_dma.s_axi_clock
add_connection sys_clk.clk axi_jesd_xcvr.s_axi_clock
add_connection sys_clk.clk axi_os_jesd_xcvr.s_axi_clock
add_connection sys_clk.clk axi_ad9371.s_axi_clock
add_connection sys_clk.clk axi_os_adc_dma.s_axi_clock
add_connection sys_clk.clk ad9371_gpio.clk

add_connection sys_clk.clk_reset xcvr_rx_os_core.jesd204_rx_avs_rst_n
add_connection sys_clk.clk_reset xcvr_tx_core.jesd204_tx_avs_rst_n
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_adc_dma.m_dest_axi_reset
add_connection sys_ddr3_cntrl.emif_usr_reset_n axi_os_adc_dma.m_dest_axi_reset
add_connection sys_clk.clk_reset axi_dac_dma.m_src_axi_reset
add_connection sys_clk.clk_reset xcvr_pll_reconfig.mgmt_reset
add_connection sys_clk.clk_reset xcvr_tx_lane_pll.reconfig_reset0
add_connection sys_clk.clk_reset xcvr_pll.reset
add_connection sys_clk.clk_reset xcvr_rx_rst_cntrl.reset
add_connection sys_clk.clk_reset xcvr_tx_rst_cntrl.reset
add_connection sys_clk.clk_reset xcvr_rx_os_rst_cntrl.reset
#add_connection sys_clk.clk_reset xcvr_rx_core.reconfig_reset
#add_connection sys_clk.clk_reset xcvr_rx_os_core.reconfig_reset
add_connection sys_clk.clk_reset xcvr_tx_core.reconfig_reset
add_connection sys_clk.clk_reset axi_adc_dma.s_axi_reset
add_connection sys_clk.clk_reset axi_dac_dma.s_axi_reset
add_connection sys_clk.clk_reset axi_jesd_xcvr.s_axi_reset
add_connection sys_clk.clk_reset axi_os_jesd_xcvr.s_axi_reset
add_connection sys_clk.clk_reset axi_ad9371.s_axi_reset
add_connection sys_clk.clk_reset axi_os_adc_dma.s_axi_reset
add_connection sys_clk.clk_reset ad9371_gpio.reset

add_connection xcvr_pll.outclk0 axi_ad9371.if_dac_clk
add_connection xcvr_pll.outclk0 dac_upack.if_dac_clk
add_connection xcvr_pll.outclk0 axi_dac_dma.if_fifo_rd_clk
add_connection xcvr_pll.outclk0 axi_jesd_xcvr.if_tx_clk
add_connection xcvr_pll.outclk0 xcvr_tx_core.txlink_clk
add_connection xcvr_pll.outclk1 adc_pack.if_adc_clk
add_connection xcvr_pll.outclk1 axi_ad9371.if_adc_clk
add_connection xcvr_pll.outclk1 axi_adc_dma.if_fifo_wr_clk
add_connection xcvr_pll.outclk1 axi_jesd_xcvr.if_rx_clk
add_connection xcvr_pll.outclk1 xcvr_rx_core.rxlink_clk
add_connection xcvr_pll.outclk2 adc_os_pack.if_adc_clk
add_connection xcvr_pll.outclk2 axi_ad9371.if_adc_os_clk
add_connection xcvr_pll.outclk2 axi_os_adc_dma.if_fifo_wr_clk
add_connection xcvr_pll.outclk2 axi_os_jesd_xcvr.if_rx_clk
add_connection xcvr_pll.outclk2 xcvr_rx_os_core.rxlink_clk

add_connection adc_pack.adc_ch_0 axi_ad9371.adc_ch_0
add_connection axi_ad9371.adc_ch_1 adc_pack.adc_ch_1
add_connection adc_pack.adc_ch_2 axi_ad9371.adc_ch_2
add_connection axi_ad9371.adc_ch_3 adc_pack.adc_ch_3

add_connection adc_os_pack.adc_ch_0 axi_ad9371.adc_os_ch_0
add_connection axi_ad9371.adc_os_ch_1 adc_os_pack.adc_ch_1

add_connection xcvr_rx_os_core.alldev_lane_aligned xcvr_rx_os_core.dev_lane_aligned

add_connection dac_upack.dac_ch_0 axi_ad9371.dac_ch_0
add_connection axi_ad9371.dac_ch_1 dac_upack.dac_ch_1
add_connection dac_upack.dac_ch_2 axi_ad9371.dac_ch_2
add_connection axi_ad9371.dac_ch_3 dac_upack.dac_ch_3

add_connection xcvr_rx_core.dev_lane_aligned xcvr_rx_core.alldev_lane_aligned
add_connection xcvr_rx_core.dev_sync_n axi_jesd_xcvr.if_rx_ip_sync
add_connection xcvr_tx_core.dev_sync_n xcvr_tx_core.mdev_sync_n
add_connection adc_pack.if_adc_data axi_adc_dma.if_fifo_wr_din
add_connection adc_os_pack.if_adc_data axi_os_adc_dma.if_fifo_wr_din
add_connection axi_ad9371.if_adc_rx_data axi_jesd_xcvr.if_rx_data
add_connection axi_ad9371.if_adc_rx_os_data axi_os_jesd_xcvr.if_rx_data
add_connection adc_pack.if_adc_sync axi_adc_dma.if_fifo_wr_sync
add_connection adc_os_pack.if_adc_sync axi_os_adc_dma.if_fifo_wr_sync
add_connection adc_pack.if_adc_valid axi_adc_dma.if_fifo_wr_en
add_connection dac_upack.if_dac_data axi_dac_dma.if_fifo_rd_dout
add_connection axi_dac_dma.if_fifo_rd_en dac_upack.if_dac_valid
add_connection axi_dac_dma.if_fifo_rd_underflow axi_ad9371.if_dac_dunf
add_connection axi_os_adc_dma.if_fifo_wr_en adc_os_pack.if_adc_valid
add_connection axi_adc_dma.if_fifo_wr_overflow axi_ad9371.if_adc_dovf
add_connection axi_os_adc_dma.if_fifo_wr_overflow axi_ad9371.if_adc_os_dovf
add_connection axi_jesd_xcvr.if_rx_ip_sof xcvr_rx_core.sof
add_connection axi_os_jesd_xcvr.if_rx_ip_sync xcvr_rx_os_core.dev_sync_n
add_connection axi_jesd_xcvr.if_rx_ip_sysref xcvr_rx_core.sysref
add_connection axi_jesd_xcvr.if_rx_ready xcvr_rx_rst_cntrl.rx_ready
add_connection axi_jesd_xcvr.if_tx_data axi_ad9371.if_dac_tx_data
add_connection axi_jesd_xcvr.if_tx_ip_sync xcvr_tx_core.sync_n
add_connection axi_jesd_xcvr.if_tx_ip_sysref xcvr_tx_core.sysref
add_connection xcvr_tx_lane_pll.pll_cal_busy xcvr_tx_rst_cntrl.pll_cal_busy
add_connection xcvr_tx_lane_pll.pll_locked xcvr_tx_rst_cntrl.pll_locked
add_connection xcvr_tx_lane_pll.pll_powerdown xcvr_tx_rst_cntrl.pll_powerdown
add_connection xcvr_pll_reconfig.reconfig_from_pll xcvr_pll.reconfig_from_pll
add_connection xcvr_pll_reconfig.reconfig_to_pll xcvr_pll.reconfig_to_pll
add_connection xcvr_rx_core.rx_analogreset xcvr_rx_rst_cntrl.rx_analogreset
add_connection xcvr_rx_os_core.rx_analogreset xcvr_rx_os_rst_cntrl.rx_analogreset
add_connection xcvr_rx_rst_cntrl.rx_cal_busy xcvr_rx_core.rx_cal_busy
add_connection xcvr_rx_os_rst_cntrl.rx_cal_busy xcvr_rx_os_core.rx_cal_busy
add_connection xcvr_rx_rst_cntrl.rx_digitalreset xcvr_rx_core.rx_digitalreset
add_connection xcvr_rx_os_rst_cntrl.rx_digitalreset xcvr_rx_os_core.rx_digitalreset
add_connection xcvr_rx_core.rx_islockedtodata xcvr_rx_rst_cntrl.rx_is_lockedtodata
add_connection xcvr_rx_os_core.rx_islockedtodata xcvr_rx_os_rst_cntrl.rx_is_lockedtodata
add_connection xcvr_rx_os_rst_cntrl.rx_ready axi_os_jesd_xcvr.if_rx_ready
add_connection xcvr_rx_os_core.sof axi_os_jesd_xcvr.if_rx_ip_sof
add_connection xcvr_rx_os_core.sysref axi_os_jesd_xcvr.if_rx_ip_sysref
add_connection xcvr_tx_core.tx_analogreset xcvr_tx_rst_cntrl.tx_analogreset
add_connection xcvr_tx_core.tx_cal_busy xcvr_tx_rst_cntrl.tx_cal_busy
add_connection xcvr_tx_rst_cntrl.tx_digitalreset xcvr_tx_core.tx_digitalreset
add_connection xcvr_tx_rst_cntrl.tx_ready axi_jesd_xcvr.if_tx_ready

add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_tx_core.tx_serial_clk0_ch0
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_tx_core.tx_serial_clk0_ch1
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_tx_core.tx_serial_clk0_ch2
add_connection xcvr_tx_lane_pll.tx_serial_clk xcvr_tx_core.tx_serial_clk0_ch3
add_connection axi_jesd_xcvr.if_rst xcvr_tx_rst_cntrl.reset
add_connection axi_os_jesd_xcvr.if_rst xcvr_rx_os_rst_cntrl.reset
add_connection axi_jesd_xcvr.if_rx_rstn adc_pack.if_adc_rst
add_connection axi_os_jesd_xcvr.if_rx_rstn adc_os_pack.if_adc_rst
add_connection axi_jesd_xcvr.if_rx_rstn xcvr_rx_core.rxlink_rst_n
add_connection axi_os_jesd_xcvr.if_rx_rstn xcvr_rx_os_core.rxlink_rst_n
add_connection axi_jesd_xcvr.if_tx_rstn xcvr_tx_core.txlink_rst_n

add_connection sys_clk.clk_reset xcvr_rx_core.jesd204_rx_avs_rst_n

add_interface rx_data conduit end
set_interface_property rx_data EXPORT_OF xcvr_rx_core.rx_serial_data
add_interface rx_os_data conduit end
set_interface_property rx_os_data EXPORT_OF xcvr_rx_os_core.rx_serial_data
add_interface rx_os_sync conduit end
set_interface_property rx_os_sync EXPORT_OF axi_os_jesd_xcvr.if_rx_sync
add_interface rx_os_sysref conduit end
set_interface_property rx_os_sysref EXPORT_OF axi_os_jesd_xcvr.if_rx_ext_sysref_in
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF axi_jesd_xcvr.if_rx_sync
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF axi_jesd_xcvr.if_rx_ext_sysref_in
add_interface tx_data conduit end
set_interface_property tx_data EXPORT_OF xcvr_tx_core.tx_serial_data
add_interface tx_sync conduit end
set_interface_property tx_sync EXPORT_OF axi_jesd_xcvr.if_tx_sync
add_interface tx_sysref conduit end
set_interface_property tx_sysref EXPORT_OF axi_jesd_xcvr.if_tx_ext_sysref_in

add_interface xcvr_ref_clk clock sink
set_interface_property xcvr_ref_clk EXPORT_OF xcvr_ref_clk.in_clk

add_connection xcvr_ref_clk.out_clk xcvr_pll.refclk
add_connection xcvr_ref_clk.out_clk xcvr_rx_core.pll_ref_clk
add_connection xcvr_ref_clk.out_clk xcvr_rx_os_core.pll_ref_clk
add_connection xcvr_ref_clk.out_clk xcvr_tx_lane_pll.pll_refclk0

add_interface ad9371_gpio conduit end
set_interface_property ad9371_gpio EXPORT_OF ad9371_gpio.external_connection

# addresses

add_connection sys_cpu.data_master xcvr_pll_reconfig.mgmt_avalon_slave
add_connection sys_cpu.data_master xcvr_tx_lane_pll.reconfig_avmm0
add_connection sys_cpu.data_master axi_adc_dma.s_axi
add_connection sys_cpu.data_master axi_dac_dma.s_axi
add_connection sys_cpu.data_master axi_jesd_xcvr.s_axi
add_connection sys_cpu.data_master axi_os_jesd_xcvr.s_axi
add_connection sys_cpu.data_master axi_ad9371.s_axi
add_connection sys_cpu.data_master axi_os_adc_dma.s_axi
#add_connection sys_cpu.data_master xcvr_rx_core.reconfig_avmm
add_connection sys_cpu.data_master xcvr_rx_core.jesd204_rx_avs
#add_connection sys_cpu.data_master xcvr_rx_os_core.reconfig_avmm
add_connection sys_cpu.data_master xcvr_rx_os_core.jesd204_rx_avs
add_connection sys_cpu.data_master xcvr_tx_core.reconfig_avmm
add_connection sys_cpu.data_master xcvr_tx_core.jesd204_tx_avs
add_connection sys_cpu.data_master ad9371_gpio.s1

add_connection axi_adc_dma.m_dest_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection axi_os_adc_dma.m_dest_axi sys_ddr3_cntrl.ctrl_amm_0
add_connection axi_dac_dma.m_src_axi sys_ddr3_cntrl.ctrl_amm_0

set_connection_parameter_value sys_cpu.data_master/xcvr_pll_reconfig.mgmt_avalon_slave  baseAddress {0x1003d800}
set_connection_parameter_value sys_cpu.data_master/xcvr_tx_lane_pll.reconfig_avmm0      baseAddress {0x1003c000}
set_connection_parameter_value sys_cpu.data_master/axi_adc_dma.s_axi                    baseAddress {0x10034000}
set_connection_parameter_value sys_cpu.data_master/axi_dac_dma.s_axi                    baseAddress {0x10010000}
set_connection_parameter_value sys_cpu.data_master/axi_jesd_xcvr.s_axi                  baseAddress {0x10040000}
set_connection_parameter_value sys_cpu.data_master/axi_os_jesd_xcvr.s_axi               baseAddress {0x10020000}
set_connection_parameter_value sys_cpu.data_master/axi_ad9371.s_axi                     baseAddress {0x10000000}
set_connection_parameter_value sys_cpu.data_master/axi_os_adc_dma.s_axi                 baseAddress {0x10500000}
#set_connection_parameter_value sys_cpu.data_master/xcvr_rx_core.reconfig_avmm           baseAddress {0x10030000}
set_connection_parameter_value sys_cpu.data_master/xcvr_rx_core.jesd204_rx_avs          baseAddress {0x1003e400}
#set_connection_parameter_value sys_cpu.data_master/xcvr_rx_os_core.reconfig_avmm        baseAddress {0x10130000}
set_connection_parameter_value sys_cpu.data_master/xcvr_rx_os_core.jesd204_rx_avs       baseAddress {0x1013e400}
set_connection_parameter_value sys_cpu.data_master/xcvr_tx_core.reconfig_avmm           baseAddress {0x10050000}
set_connection_parameter_value sys_cpu.data_master/xcvr_tx_core.jesd204_tx_avs          baseAddress {0x1005e400}
set_connection_parameter_value sys_cpu.data_master/ad9371_gpio.s1                       baseAddress {0x10060000}

set_connection_parameter_value axi_adc_dma.m_dest_axi/sys_ddr3_cntrl.ctrl_amm_0         baseAddress {0x00000000}
set_connection_parameter_value axi_os_adc_dma.m_dest_axi/sys_ddr3_cntrl.ctrl_amm_0      baseAddress {0x00000000}
set_connection_parameter_value axi_dac_dma.m_src_axi/sys_ddr3_cntrl.ctrl_amm_0          baseAddress {0x00000000}

# interrupts

add_connection sys_cpu.irq axi_adc_dma.interrupt_sender
add_connection sys_cpu.irq axi_dac_dma.interrupt_sender
add_connection sys_cpu.irq axi_os_adc_dma.interrupt_sender
set_connection_parameter_value sys_cpu.irq/axi_adc_dma.interrupt_sender irqNumber {10}
set_connection_parameter_value sys_cpu.irq/axi_dac_dma.interrupt_sender irqNumber {11}
set_connection_parameter_value sys_cpu.irq/axi_os_adc_dma.interrupt_sender irqNumber {12}

