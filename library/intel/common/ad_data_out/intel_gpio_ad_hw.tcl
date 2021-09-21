
package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create intel_gpio_ad {Intel GPIO AD}
set_module_property COMPOSITION_CALLBACK p_intel_gpio_ad

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}
ad_ip_parameter MODE STRING "IN" false
ad_ip_parameter DDR_OR_SDR_N INTEGER 1 false

set_parameter_property MODE ALLOWED_RANGES {"IN" "OUT" "CLK"}
set_parameter_property DDR_OR_SDR_N ALLOWED_RANGES {0 1}

proc p_intel_gpio_ad {} {

  set m_mode [get_parameter_value "MODE"]
  set m_ddr_or_sdr_n [get_parameter_value "DDR_OR_SDR_N"]

  ## arria 10 only

  if {$m_mode == "IN"} {

    add_instance intel_gpio_ad_in altera_gpio 19.3
    set_instance_parameter_value intel_gpio_ad_in {EXT_DRIVER_PARAM} {0}
    set_instance_parameter_value intel_gpio_ad_in {GENERATE_SDC_FILE} {0}
    set_instance_parameter_value intel_gpio_ad_in {IP_MIGRATE_PORT_MAP_FILE} {altddio_bidir_port_map.csv}
    set_instance_parameter_value intel_gpio_ad_in {PIN_TYPE_GUI} {Input}
    set_instance_parameter_value intel_gpio_ad_in {SIZE} {1}
    set_instance_parameter_value intel_gpio_ad_in {gui_areset_mode} {None}
    set_instance_parameter_value intel_gpio_ad_in {gui_bus_hold} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_diff_buff} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_enable_cke} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_enable_migratable_port_names} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_enable_termination_ports} {0}
    if {$m_ddr_or_sdr_n == 1} {
      set_instance_parameter_value intel_gpio_ad_in {gui_io_reg_mode} {DDIO}
    }
    set_instance_parameter_value intel_gpio_ad_in {gui_open_drain} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_pseudo_diff} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_separate_io_clks} {0}
    set_instance_parameter_value intel_gpio_ad_in {gui_sreset_mode} {None}
    set_instance_parameter_value intel_gpio_ad_in {gui_use_oe} {0}

    add_interface ck conduit end
    set_interface_property ck EXPORT_OF intel_gpio_ad_in.ck
    add_interface data_out conduit end
    set_interface_property data_out EXPORT_OF intel_gpio_ad_in.dout
    add_interface rx_in_p conduit end
    set_interface_property rx_in_p EXPORT_OF intel_gpio_ad_in.pad_in
    add_interface rx_in_n conduit end
    set_interface_property rx_in_n EXPORT_OF intel_gpio_ad_in.pad_in_b
    return
  }
  
  if {$m_mode == "CLK"} {
    add_instance intel_iopll altera_iopll 19.3
    set_instance_parameter_value intel_iopll {gui_reference_clock_frequency} {250.0}
    set_instance_parameter_value intel_iopll {gui_use_locked} {true}
    set_instance_parameter_value intel_iopll {gui_pll_bandwidth_preset} {High}
    set_instance_parameter_value intel_iopll {gui_operation_mode} {source synchronous}
    set_instance_parameter_value intel_iopll {gui_number_of_clocks} {2}
    set_instance_parameter_value intel_iopll {gui_en_lvds_ports} {Disabled}
    set_instance_parameter_value intel_iopll {gui_en_phout_ports} {false}
    set_instance_parameter_value intel_iopll {gui_pll_auto_reset} {false}
    set_instance_parameter_value intel_iopll {gui_output_clock_frequency0} {250.0}
    set_instance_parameter_value intel_iopll {gui_ps_units0} {degrees}
    set_instance_parameter_value intel_iopll {gui_phase_shift_deg0} {0.0}
    set_instance_parameter_value intel_iopll {gui_output_clock_frequency1} {125.0}
    set_instance_parameter_value intel_iopll {gui_ps_units1} {degrees}
    set_instance_parameter_value intel_iopll {gui_phase_shift_deg1} {0.0}
    
    add_interface rst reset sink
    set_interface_property rst EXPORT_OF intel_iopll.reset
    add_interface locked conduit end
    set_interface_property locked EXPORT_OF intel_iopll.locked
    add_interface ref_clk clock sink
    set_interface_property ref_clk EXPORT_OF intel_iopll.refclk
    add_interface f_clk clock source
    set_interface_property f_clk EXPORT_OF intel_iopll.outclk0
    add_interface h_clk clock source
    set_interface_property h_clk EXPORT_OF intel_iopll.outclk1
    
    return
  }

  if {$m_mode == "OUT"} {

    add_instance intel_gpio_ad_out altera_gpio 19.3
    set_instance_parameter_value intel_gpio_ad_out {EXT_DRIVER_PARAM} {0}
    set_instance_parameter_value intel_gpio_ad_out {GENERATE_SDC_FILE} {0}
    set_instance_parameter_value intel_gpio_ad_out {IP_MIGRATE_PORT_MAP_FILE} {altddio_bidir_port_map.csv}
    set_instance_parameter_value intel_gpio_ad_out {PIN_TYPE_GUI} {Output}
    set_instance_parameter_value intel_gpio_ad_out {SIZE} {1}
    set_instance_parameter_value intel_gpio_ad_out {gui_areset_mode} {None}
    set_instance_parameter_value intel_gpio_ad_out {gui_bus_hold} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_diff_buff} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_enable_cke} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_enable_migratable_port_names} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_enable_termination_ports} {0}
    if {$m_ddr_or_sdr_n == 1} {
      set_instance_parameter_value intel_gpio_ad_out {gui_io_reg_mode} {DDIO}
    }
    set_instance_parameter_value intel_gpio_ad_out {gui_open_drain} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_pseudo_diff} {1}
    set_instance_parameter_value intel_gpio_ad_out {gui_separate_io_clks} {0}
    set_instance_parameter_value intel_gpio_ad_out {gui_sreset_mode} {None}
    set_instance_parameter_value intel_gpio_ad_out {gui_use_oe} {0}

    
    add_interface ck conduit end
    set_interface_property ck EXPORT_OF intel_gpio_ad_out.ck
    add_interface data_in conduit end
    set_interface_property data_in EXPORT_OF intel_gpio_ad_out.din
    add_interface tx_out_p conduit end
    set_interface_property tx_out_p EXPORT_OF intel_gpio_ad_out.pad_out
    add_interface tx_out_n conduit end
    set_interface_property tx_out_n EXPORT_OF intel_gpio_ad_out.pad_out_b
    return
  }
}

