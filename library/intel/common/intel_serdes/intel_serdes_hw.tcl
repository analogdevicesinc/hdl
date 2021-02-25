
package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create intel_serdes {Intel SERDES}
set_module_property COMPOSITION_CALLBACK p_intel_serdes

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter MODE STRING "CLK" false
ad_ip_parameter DDR_OR_SDR_N INTEGER 1 false
ad_ip_parameter SERDES_FACTOR INTEGER 8 false
ad_ip_parameter CLKIN_FREQUENCY FLOAT 500.0 false

set_parameter_property MODE ALLOWED_RANGES {"CLK" "IN" "IN_NODPA" "OUT"}
set_parameter_property DDR_OR_SDR_N ALLOWED_RANGES {0 1}
set_parameter_property SERDES_FACTOR ALLOWED_RANGES {4 8}
set_parameter_property CLKIN_FREQUENCY DISPLAY_UNITS "MHz"

proc p_intel_serdes {} {

  set m_mode [get_parameter_value "MODE"]
  set m_ddr_or_sdr_n [get_parameter_value "DDR_OR_SDR_N"]
  set m_serdes_factor [get_parameter_value "SERDES_FACTOR"]
  set m_clkin_frequency [get_parameter_value "CLKIN_FREQUENCY"]

  set m_hs_data_rate [expr ($m_clkin_frequency * ($m_ddr_or_sdr_n + 1))]
  set m_ls_data_rate [expr ($m_hs_data_rate/$m_serdes_factor)]

  set m_ls_phase 22.5
  set m_ld_phase 315.0
  set m_ld_duty_cycle 12.5

  if {$m_serdes_factor == 4} {
    set m_ls_phase 45
    set m_ld_phase 270.0
    set m_ld_duty_cycle 25.0
  }

  ## arria 10 only

  if {$m_mode == "CLK"} {
    add_instance intel_serdes_pll altera_iopll 19.1
    set_instance_parameter_value intel_serdes_pll {gui_reference_clock_frequency} $m_clkin_frequency
    set_instance_parameter_value intel_serdes_pll {gui_use_locked} {1}
    set_instance_parameter_value intel_serdes_pll {gui_operation_mode} {lvds}
    set_instance_parameter_value intel_serdes_pll {gui_number_of_clocks} {3}
    set_instance_parameter_value intel_serdes_pll {gui_en_lvds_ports} {Enable LVDS_CLK/LOADEN 0}
    set_instance_parameter_value intel_serdes_pll {gui_en_phout_ports} {true}
    set_instance_parameter_value intel_serdes_pll {gui_output_clock_frequency0} $m_hs_data_rate
    set_instance_parameter_value intel_serdes_pll {gui_ps_units0} {degrees}
    set_instance_parameter_value intel_serdes_pll {gui_phase_shift_deg0} {180.0}
    set_instance_parameter_value intel_serdes_pll {gui_output_clock_frequency1} $m_ls_data_rate
    set_instance_parameter_value intel_serdes_pll {gui_ps_units1} {degrees}
    set_instance_parameter_value intel_serdes_pll {gui_phase_shift_deg1} $m_ld_phase
    set_instance_parameter_value intel_serdes_pll {gui_duty_cycle1} $m_ld_duty_cycle
    set_instance_parameter_value intel_serdes_pll {gui_output_clock_frequency2} $m_ls_data_rate
    set_instance_parameter_value intel_serdes_pll {gui_phase_shift_deg2} $m_ls_phase
    set_instance_parameter_value intel_serdes_pll {gui_ps_units2} {degrees}
    add_interface rst reset sink
    set_interface_property rst EXPORT_OF intel_serdes_pll.reset
    add_interface ref_clk clock sink
    set_interface_property ref_clk EXPORT_OF intel_serdes_pll.refclk
    add_interface locked conduit end
    set_interface_property locked EXPORT_OF intel_serdes_pll.locked
    add_interface hs_phase conduit end
    set_interface_property hs_phase EXPORT_OF intel_serdes_pll.phout
    add_interface hs_clk conduit end
    set_interface_property hs_clk EXPORT_OF intel_serdes_pll.lvds_clk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF intel_serdes_pll.loaden
    add_interface ls_clk clock source
    set_interface_property ls_clk EXPORT_OF intel_serdes_pll.outclk2
    return
  }

  if {$m_mode == "IN" || $m_mode == "IN_NODPA"} {
    add_instance intel_serdes_in altera_lvds 19.1
    if {$m_mode == "IN"} {
    set_instance_parameter_value intel_serdes_in {MODE} {RX_DPA-FIFO}
    } else {
    set_instance_parameter_value intel_serdes_in {MODE} {RX_Non-DPA}
    }
    set_instance_parameter_value intel_serdes_in {NUM_CHANNELS} {1}
    set_instance_parameter_value intel_serdes_in {DATA_RATE} $m_hs_data_rate
    set_instance_parameter_value intel_serdes_in {J_FACTOR} $m_serdes_factor
    set_instance_parameter_value intel_serdes_in {USE_EXTERNAL_PLL} {true}
    set_instance_parameter_value intel_serdes_in {INCLOCK_FREQUENCY} $m_clkin_frequency
    set_instance_parameter_value intel_serdes_in {PLL_USE_RESET} {false}
    add_interface data_in conduit end
    set_interface_property data_in EXPORT_OF intel_serdes_in.rx_in
    add_interface clk conduit end
    set_interface_property clk EXPORT_OF intel_serdes_in.ext_fclk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF intel_serdes_in.ext_loaden
    add_interface div_clk conduit end
    set_interface_property div_clk EXPORT_OF intel_serdes_in.ext_coreclock
    if {$m_mode == "IN"} {
    add_interface hs_phase conduit end
    set_interface_property hs_phase EXPORT_OF intel_serdes_in.ext_vcoph
    add_interface locked conduit end
    set_interface_property locked EXPORT_OF intel_serdes_in.ext_pll_locked
    add_interface delay_locked conduit end
    set_interface_property delay_locked EXPORT_OF intel_serdes_in.rx_dpa_locked
    }
    add_interface data_s conduit end
    set_interface_property data_s EXPORT_OF intel_serdes_in.rx_out
    return
  }

  if {$m_mode == "OUT"} {
    add_instance intel_serdes_out altera_lvds 19.1
    set_instance_parameter_value intel_serdes_out {MODE} {TX}
    set_instance_parameter_value intel_serdes_out {NUM_CHANNELS} {1}
    set_instance_parameter_value intel_serdes_out {DATA_RATE} $m_hs_data_rate
    set_instance_parameter_value intel_serdes_out {J_FACTOR} $m_serdes_factor
    set_instance_parameter_value intel_serdes_out {TX_EXPORT_CORECLOCK} {false}
    set_instance_parameter_value intel_serdes_out {TX_USE_OUTCLOCK} {false}
    set_instance_parameter_value intel_serdes_out {USE_EXTERNAL_PLL} {true}
    set_instance_parameter_value intel_serdes_out {INCLOCK_FREQUENCY} $m_clkin_frequency
    set_instance_parameter_value intel_serdes_out {PLL_USE_RESET} {false}
    add_interface data_out conduit end
    set_interface_property data_out EXPORT_OF intel_serdes_out.tx_out
    add_interface clk conduit end
    set_interface_property clk EXPORT_OF intel_serdes_out.ext_fclk
    add_interface loaden conduit end
    set_interface_property loaden EXPORT_OF intel_serdes_out.ext_loaden
    add_interface div_clk conduit end
    set_interface_property div_clk EXPORT_OF intel_serdes_out.ext_coreclock
    add_interface data_s conduit end
    set_interface_property data_s EXPORT_OF intel_serdes_out.tx_in
    return
  }
}

