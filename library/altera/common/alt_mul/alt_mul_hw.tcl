
package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_alt.tcl

ad_ip_create alt_mul {Altera LPM Multiplier}
set_module_property COMPOSITION_CALLBACK p_alt_mul

# parameters

ad_ip_parameter DEVICE_FAMILY STRING {Arria 10}

# compose

proc p_alt_mul {} {

  add_instance alt_mul lpm_mult
  set_instance_parameter_value alt_mul {GUI_USE_MULT} {1}
  set_instance_parameter_value alt_mul {GUI_WIDTH_A} {17}
  set_instance_parameter_value alt_mul {GUI_WIDTH_B} {17}
  set_instance_parameter_value alt_mul {GUI_AUTO_SIZE_RESULT} {0}
  set_instance_parameter_value alt_mul {GUI_WIDTH_P} {34}
  set_instance_parameter_value alt_mul {GUI_B_IS_CONSTANT} {0}
  set_instance_parameter_value alt_mul {GUI_SIGNED_MULT} {1}
  set_instance_parameter_value alt_mul {GUI_PIPELINE} {1}
  set_instance_parameter_value alt_mul {GUI_LATENCY} {3}
  set_instance_parameter_value alt_mul {GUI_OPTIMIZE} {1}

  add_interface mult_i conduit end
  add_interface mult_o conduit end
  set_interface_property mult_i EXPORT_OF alt_mul.mult_input
  set_interface_property mult_o EXPORT_OF alt_mul.mult_output
}

