###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc ad_ip_instance {i_ip i_name {i_params {}}} {
  add_instance ${i_name} ${i_ip}
  # Set parameters if provided
  if {$i_params != {}} {
    foreach {k v} $i_params {
      set_instance_parameter_value ${i_name} $k $v
    }
  }
}

proc ad_ip_parameter {i_name i_param i_value} {

    # Remove CONFIG. prefix if present for Intel
    regsub {^CONFIG\.} $i_param {} param_name
    set_instance_parameter_value ${i_name} ${param_name} ${i_value}
}

proc ad_connect {name_a name_b} {

    add_connection $name_a $name_b
}
