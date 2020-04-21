
source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl

# Instances and instance parameters
add_instance gmii_to_rgmii_adapter_0 altera_gmii_to_rgmii_adapter
set_instance_parameter_value gmii_to_rgmii_adapter_0 {RX_PIPELINE_DEPTH} {1}
set_instance_parameter_value gmii_to_rgmii_adapter_0 {TX_PIPELINE_DEPTH} {1}

add_instance hps_emac_interface_splitter_0 altera_hps_emac_interface_splitter

    add_instance pll_0 altera_pll
    set_instance_parameter_value pll_0 {gui_device_speed_grade} {1}
    set_instance_parameter_value pll_0 {gui_divide_factor_c0} {1}
    set_instance_parameter_value pll_0 {gui_divide_factor_c1} {1}
    set_instance_parameter_value pll_0 {gui_divide_factor_n} {1}
    set_instance_parameter_value pll_0 {gui_dps_cntr} {C0}
    set_instance_parameter_value pll_0 {gui_dps_dir} {Positive}
    set_instance_parameter_value pll_0 {gui_dps_num} {1}
    set_instance_parameter_value pll_0 {gui_dsm_out_sel} {1st_order}
    set_instance_parameter_value pll_0 {gui_duty_cycle0} {50}
    set_instance_parameter_value pll_0 {gui_duty_cycle1} {50}
    set_instance_parameter_value pll_0 {gui_en_adv_params} {0}
    set_instance_parameter_value pll_0 {gui_en_dps_ports} {0}
    set_instance_parameter_value pll_0 {gui_en_phout_ports} {0}
    set_instance_parameter_value pll_0 {gui_en_reconf} {0}
    set_instance_parameter_value pll_0 {gui_enable_cascade_in} {0}
    set_instance_parameter_value pll_0 {gui_enable_cascade_out} {0}
    set_instance_parameter_value pll_0 {gui_enable_mif_dps} {0}
    set_instance_parameter_value pll_0 {gui_feedback_clock} {Global Clock}
    set_instance_parameter_value pll_0 {gui_frac_multiply_factor} {1.0}
    set_instance_parameter_value pll_0 {gui_fractional_cout} {32}
    set_instance_parameter_value pll_0 {gui_multiply_factor} {1}
    set_instance_parameter_value pll_0 {gui_number_of_clocks} {2}
    set_instance_parameter_value pll_0 {gui_operation_mode} {direct}
    set_instance_parameter_value pll_0 {gui_output_clock_frequency0} {25.0}
    set_instance_parameter_value pll_0 {gui_output_clock_frequency1} {2.5}
    set_instance_parameter_value pll_0 {gui_phase_shift_deg0} {0.0}
    set_instance_parameter_value pll_0 {gui_phase_shift_deg1} {0.0}
    set_instance_parameter_value pll_0 {gui_phout_division} {1}
    set_instance_parameter_value pll_0 {gui_pll_auto_reset} {Off}
    set_instance_parameter_value pll_0 {gui_pll_bandwidth_preset} {Auto}
    set_instance_parameter_value pll_0 {gui_pll_mode} {Integer-N PLL}
    set_instance_parameter_value pll_0 {gui_ps_units0} {ps}
    set_instance_parameter_value pll_0 {gui_ps_units1} {ps}
    set_instance_parameter_value pll_0 {gui_refclk1_frequency} {50.0}
    set_instance_parameter_value pll_0 {gui_refclk_switch} {0}
    set_instance_parameter_value pll_0 {gui_reference_clock_frequency} {50.0}
    set_instance_parameter_value pll_0 {gui_switchover_delay} {0}
    set_instance_parameter_value pll_0 {gui_switchover_mode} {Automatic Switchover}
    set_instance_parameter_value pll_0 {gui_use_locked} {1}

    set_instance_parameter_value sys_hps {EMAC1_Mode} {Full}
    set_instance_parameter_value sys_hps {EMAC1_PTP} {0}
    set_instance_parameter_value sys_hps {EMAC1_PinMuxing} {FPGA}

    set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK} {125}
    set_instance_parameter_value sys_hps {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_MD_CLK} {2.5}

    # connections and connection parameters
    add_connection gmii_to_rgmii_adapter_0.hps_gmii hps_emac_interface_splitter_0.hps_gmii conduit
    set_connection_parameter_value gmii_to_rgmii_adapter_0.hps_gmii/hps_emac_interface_splitter_0.hps_gmii endPort {}
    set_connection_parameter_value gmii_to_rgmii_adapter_0.hps_gmii/hps_emac_interface_splitter_0.hps_gmii endPortLSB {0}
    set_connection_parameter_value gmii_to_rgmii_adapter_0.hps_gmii/hps_emac_interface_splitter_0.hps_gmii startPort {}
    set_connection_parameter_value gmii_to_rgmii_adapter_0.hps_gmii/hps_emac_interface_splitter_0.hps_gmii startPortLSB {0}
    set_connection_parameter_value gmii_to_rgmii_adapter_0.hps_gmii/hps_emac_interface_splitter_0.hps_gmii width {0}

    add_connection hps_emac_interface_splitter_0.emac sys_hps.emac1 conduit
    set_connection_parameter_value hps_emac_interface_splitter_0.emac/sys_hps.emac1 endPort {}
    set_connection_parameter_value hps_emac_interface_splitter_0.emac/sys_hps.emac1 endPortLSB {0}
    set_connection_parameter_value hps_emac_interface_splitter_0.emac/sys_hps.emac1 startPort {}
    set_connection_parameter_value hps_emac_interface_splitter_0.emac/sys_hps.emac1 startPortLSB {0}
    set_connection_parameter_value hps_emac_interface_splitter_0.emac/sys_hps.emac1 width {0}

    add_connection hps_emac_interface_splitter_0.emac_rx_clk_in sys_hps.emac1_rx_clk_in clock
    add_connection hps_emac_interface_splitter_0.emac_tx_clk_in sys_hps.emac1_tx_clk_in clock

    add_connection pll_0.outclk0 gmii_to_rgmii_adapter_0.pll_25m_clock clock
    add_connection pll_0.outclk1 gmii_to_rgmii_adapter_0.pll_2_5m_clock clock

    add_connection sys_clk.clk gmii_to_rgmii_adapter_0.peri_clock clock
    add_connection sys_clk.clk hps_emac_interface_splitter_0.peri_clock clock
    add_connection sys_clk.clk pll_0.refclk clock
    add_connection sys_clk.clk_reset gmii_to_rgmii_adapter_0.peri_reset reset
    add_connection sys_clk.clk_reset hps_emac_interface_splitter_0.peri_reset reset
    add_connection sys_clk.clk_reset pll_0.reset reset

    add_connection sys_clk.clk sys_hps.emac_ptp_ref_clock
    add_connection sys_hps.emac1_gtx_clk hps_emac_interface_splitter_0.emac_gtx_clk clock
    add_connection sys_hps.emac1_rx_reset hps_emac_interface_splitter_0.emac_rx_reset reset
    add_connection sys_hps.emac1_tx_reset hps_emac_interface_splitter_0.emac_tx_reset reset

    # exported interfaces
    add_interface sys_hps_emac1_md_clk clock source
    set_interface_property sys_hps_emac1_md_clk EXPORT_OF sys_hps.emac1_md_clk
    add_interface gmii_to_rgmii_adapter_0_phy_rgmii conduit end
    set_interface_property gmii_to_rgmii_adapter_0_phy_rgmii EXPORT_OF gmii_to_rgmii_adapter_0.phy_rgmii
    add_interface hps_emac_interface_splitter_0_mdio conduit end
    set_interface_property hps_emac_interface_splitter_0_mdio EXPORT_OF hps_emac_interface_splitter_0.mdio
    add_interface hps_emac_interface_splitter_0_ptp conduit end
    set_interface_property hps_emac_interface_splitter_0_ptp EXPORT_OF hps_emac_interface_splitter_0.ptp

    add_interface pll_0_locked conduit end
    set_interface_property pll_0_locked EXPORT_OF pll_0.locked
