
package require -exact qsys 14.0

set_module_property NAME alt_serdes
set_module_property DESCRIPTION "Altera SERDES"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME alt_serdes
set_module_property COMPOSITION_CALLBACK p_alt_serdes

# parameters

add_parameter MODE STRING "CLK"
set_parameter_property MODE DISPLAY_NAME MODE
set_parameter_property MODE TYPE STRING
set_parameter_property MODE UNITS None
set_parameter_property MODE HDL_PARAMETER false
set_parameter_property MODE ALLOWED_RANGES {"CLK" "IN" "OUT"}

add_parameter DDR_OR_SDR_N INTEGER 1
set_parameter_property DDR_OR_SDR_N DISPLAY_NAME DDR_OR_SDR_N
set_parameter_property DDR_OR_SDR_N TYPE INTEGER
set_parameter_property DDR_OR_SDR_N UNITS None
set_parameter_property DDR_OR_SDR_N HDL_PARAMETER false
set_parameter_property DDR_OR_SDR_N ALLOWED_RANGES {0 1}

add_parameter SERDES_FACTOR INTEGER 8
set_parameter_property SERDES_FACTOR DISPLAY_NAME SERDES_FACTOR
set_parameter_property SERDES_FACTOR TYPE INTEGER
set_parameter_property SERDES_FACTOR UNITS None
set_parameter_property SERDES_FACTOR HDL_PARAMETER false
set_parameter_property SERDES_FACTOR ALLOWED_RANGES {4 8}

add_parameter CLKIN_FREQUENCY FLOAT 500.0
set_parameter_property CLKIN_FREQUENCY DISPLAY_NAME CLKIN_FREQUENCY
set_parameter_property CLKIN_FREQUENCY TYPE FLOAT
set_parameter_property CLKIN_FREQUENCY UNITS None
set_parameter_property CLKIN_FREQUENCY DISPLAY_UNITS "MHz"
set_parameter_property CLKIN_FREQUENCY HDL_PARAMETER false

proc p_alt_serdes {} {

  set m_mode [get_parameter_value "MODE"]
  set m_ddr_or_sdr_n [get_parameter_value "DDR_OR_SDR_N"]
  set m_serdes_factor [get_parameter_value "SERDES_FACTOR"]
  set m_clkin_frequency [get_parameter_value "CLKIN_FREQUENCY"]

  set m_hs_data_rate [expr ($m_clkin_frequency * ($m_ddr_or_sdr_n + 1))]
  set m_ls_data_rate [expr ($m_hs_data_rate/$m_serdes_factor)]
  set m_ls_phase 315.0
  if {$m_serdes_factor == 4} {
    set m_ls_phase 270.0
  }

  if {$m_mode == "CLK"} {

    add_instance alt_serdes_pll altera_iopll
    set_instance_parameter_value alt_serdes_pll {gui_reference_clock_frequency} $m_clkin_frequency
    set_instance_parameter_value alt_serdes_pll {gui_use_locked} {1}
    set_instance_parameter_value alt_serdes_pll {gui_operation_mode} {lvds}
    set_instance_parameter_value alt_serdes_pll {gui_en_lvds_ports} {Enable LVDS_CLK/LOADEN 0}
    set_instance_parameter_value alt_serdes_pll {gui_en_phout_ports} {true}
    set_instance_parameter_value alt_serdes_pll {gui_en_reconf} {true}
    set_instance_parameter_value alt_serdes_pll {gui_output_clock_frequency0} $m_hs_data_rate
    set_instance_parameter_value alt_serdes_pll {gui_ps_units0} {degrees}
    set_instance_parameter_value alt_serdes_pll {gui_phase_shift_deg0} {180.0}
    set_instance_parameter_value alt_serdes_pll {gui_output_clock_frequency1} $m_ls_data_rate
    set_instance_parameter_value alt_serdes_pll {gui_ps_units1} {degrees}
    set_instance_parameter_value alt_serdes_pll {gui_phase_shift_deg1} $m_ls_phase
    set_instance_parameter_value alt_serdes_pll {gui_duty_cycle1} {12.5}
    set_instance_parameter_value alt_serdes_pll {gui_output_clock_frequency2} $m_ls_data_rate
    set_instance_parameter_value alt_serdes_pll {gui_ps_units2} {degrees}
    add_interface rst reset sink
    set_interface_property rst EXPORT_OF alt_serdes_pll.reset
    add_interface ref_clk clock sink
    set_interface_property ref_clk EXPORT_OF alt_serdes_pll.refclk
    add_interface locked conduit end
    set_interface_property locked EXPORT_OF alt_serdes_pll.locked
    add_interface hs_phase conduit end
    set_interface_property hs_phase EXPORT_OF alt_serdes_pll.phout
    add_interface hs_clk conduit end
    set_interface_property hs_clk EXPORT_OF alt_serdes_pll.lvds_clk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF alt_serdes_pll.loaden
    add_interface ls_clk clock source
    set_interface_property ls_clk EXPORT_OF alt_serdes_pll.outclk2

    add_instance alt_serdes_pll_reconfig altera_pll_reconfig
    add_connection alt_serdes_pll.reconfig_from_pll alt_serdes_pll_reconfig.reconfig_from_pll
    add_connection alt_serdes_pll_reconfig.reconfig_to_pll alt_serdes_pll.reconfig_to_pll
    add_interface drp_clk clock sink
    set_interface_property drp_clk EXPORT_OF alt_serdes_pll_reconfig.mgmt_clk
    add_interface drp_rst reset sink
    set_interface_property drp_rst EXPORT_OF alt_serdes_pll_reconfig.mgmt_reset
    add_interface pll_reconfig avalon slave
    set_interface_property pll_reconfig EXPORT_OF alt_serdes_pll_reconfig.mgmt_avalon_slave
  }

  if {$m_mode == "IN"} {

    add_instance alt_serdes_in altera_lvds
    set_instance_parameter_value alt_serdes_in {MODE} {RX_DPA-FIFO}
    set_instance_parameter_value alt_serdes_in {NUM_CHANNELS} {1}
    set_instance_parameter_value alt_serdes_in {DATA_RATE} $m_hs_data_rate
    set_instance_parameter_value alt_serdes_in {J_FACTOR} $m_serdes_factor
    set_instance_parameter_value alt_serdes_in {USE_EXTERNAL_PLL} {true}
    set_instance_parameter_value alt_serdes_in {INCLOCK_FREQUENCY} $m_clkin_frequency
    set_instance_parameter_value alt_serdes_in {PLL_USE_RESET} {false}
    add_interface data_in conduit end
    set_interface_property data_in EXPORT_OF alt_serdes_in.rx_in
    add_interface clk conduit end
    set_interface_property clk EXPORT_OF alt_serdes_in.ext_fclk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF alt_serdes_in.ext_loaden
    add_interface div_clk conduit end
    set_interface_property div_clk EXPORT_OF alt_serdes_in.ext_coreclock
    add_interface hs_phase conduit end
    set_interface_property hs_phase EXPORT_OF alt_serdes_in.ext_vcoph
    add_interface locked conduit end
    set_interface_property locked EXPORT_OF alt_serdes_in.ext_pll_locked
    add_interface data_s conduit end
    set_interface_property data_s EXPORT_OF alt_serdes_in.rx_out
    add_interface delay_locked conduit end
    set_interface_property delay_locked EXPORT_OF alt_serdes_in.rx_dpa_locked
  }

  if {$m_mode == "OUT"} {

    add_instance alt_serdes_out altera_lvds
    set_instance_parameter_value alt_serdes_out {MODE} {TX}
    set_instance_parameter_value alt_serdes_out {NUM_CHANNELS} {1}
    set_instance_parameter_value alt_serdes_out {DATA_RATE} $m_hs_data_rate
    set_instance_parameter_value alt_serdes_out {J_FACTOR} $m_serdes_factor
    set_instance_parameter_value alt_serdes_out {TX_EXPORT_CORECLOCK} {false}
    set_instance_parameter_value alt_serdes_out {TX_USE_OUTCLOCK} {false}
    set_instance_parameter_value alt_serdes_out {USE_EXTERNAL_PLL} {true}
    set_instance_parameter_value alt_serdes_out {INCLOCK_FREQUENCY} $m_clkin_frequency
    set_instance_parameter_value alt_serdes_out {PLL_USE_RESET} {false}
    add_interface data_out conduit end
    set_interface_property data_out EXPORT_OF alt_serdes_out.tx_out
    add_interface clk conduit end
    set_interface_property clk EXPORT_OF alt_serdes_out.ext_fclk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF alt_serdes_out.ext_loaden
    add_interface div_clk conduit end
    set_interface_property div_clk EXPORT_OF alt_serdes_out.ext_coreclock
    add_interface data_s conduit end
    set_interface_property data_s EXPORT_OF alt_serdes_out.tx_in
  }
}


